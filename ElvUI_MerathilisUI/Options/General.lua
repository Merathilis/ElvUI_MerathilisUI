local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local options = module.options.general.args

local ipairs, tconcat, tinsert, tonumber = ipairs, table.concat, tinsert, tonumber

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_SetCVar = C_CVar.SetCVar
local InCombatLockdown = InCombatLockdown

-- Graphics CVars the performance tuning sets, with the line shown in the info
-- card. The values from before the tuning are kept in
-- E.global.mui.perfTuningBackup (graphics CVars are per machine, not per
-- profile) and are not reapplied on login, so later manual changes stick.
local TUNED_CVARS = {
	{ "graphicsShadowQuality", "1", L["Shadow Quality: Fair (balanced quality and FPS)"] },
	{ "graphicsLiquidDetail", "0", L["Liquid Detail: Low"] },
	{ "graphicsParticleDensity", "5", L["Particle Density: Ultra (keeps important spell effects)"] },
	{ "graphicsSSAO", "0", L["SSAO (Ambient Occlusion): Disabled"] },
	{ "graphicsDepthEffects", "0", L["Depth Effects: Disabled"] },
	{ "graphicsComputeEffects", "0", L["Compute Effects: Disabled"] },
	{ "graphicsOutlineMode", "0", L["Outline Mode: Disabled"] },
	{ "graphicsTextureResolution", "2", L["Texture Resolution: High"] },
	{ "graphicsSpellDensity", "0", L["Spell Density: Essential"] },
	{ "graphicsProjectedTextures", "1", L["Projected Textures: Enabled (needed for ground effects)"] },
	{ "graphicsViewDistance", "0", L["View Distance: 1"] },
	{ "graphicsEnvironmentDetail", "0", L["Environment Detail: 1"] },
	{ "graphicsGroundClutter", "0", L["Ground Clutter: 1"] },
	{ "RAIDsettingsEnabled", "0", L["Raid/Dungeon Settings: Same settings everywhere"] },
	{ "ResampleAlwaysSharpen", "1", L["Resample Sharpening: Enabled (crisper image)"] },
	{ "Sound_EnableReverb", "0", L["Reverb: Disabled (spell and interrupt sound cues stay crisp)"] },
}

-- Contrast is raised by this much when it is at or below CONTRAST_MAX
local CONTRAST_BOOST = 10
local CONTRAST_MAX = 55

local showTuningInfo = false

-- A CVar the client doesn't know returns nil, skip those instead of erroring
local function SetKnownCVar(cvar, value)
	if C_CVar_GetCVar(cvar) ~= nil then
		C_CVar_SetCVar(cvar, value)
	end
end

local function ApplyPerformanceTuning()
	if InCombatLockdown() then
		F.Print(_G.ERR_NOT_IN_COMBAT)
		return
	end

	-- Only the first tuning takes a snapshot, a second click must not
	-- overwrite the user's real settings with the tuned ones. CVars added
	-- to the list later are backfilled so the revert covers them too.
	local backup = E.global.mui.perfTuningBackup or {}
	for _, entry in ipairs(TUNED_CVARS) do
		if backup[entry[1]] == nil then
			backup[entry[1]] = C_CVar_GetCVar(entry[1])
		end
	end
	if backup.Contrast == nil then
		backup.Contrast = C_CVar_GetCVar("Contrast")
	end
	E.global.mui.perfTuningBackup = backup

	for _, entry in ipairs(TUNED_CVARS) do
		SetKnownCVar(entry[1], entry[2])
	end

	local contrast = tonumber(C_CVar_GetCVar("Contrast"))
	if contrast and contrast <= CONTRAST_MAX then
		SetKnownCVar("Contrast", contrast + CONTRAST_BOOST)
	end

	F.Print(L["Performance tuning applied."])
end

local function RevertPerformanceTuning()
	local backup = E.global.mui.perfTuningBackup
	if not backup then
		return
	end

	if InCombatLockdown() then
		F.Print(_G.ERR_NOT_IN_COMBAT)
		return
	end

	for _, entry in ipairs(TUNED_CVARS) do
		if backup[entry[1]] then
			SetKnownCVar(entry[1], backup[entry[1]])
		end
	end
	if backup.Contrast then
		SetKnownCVar("Contrast", backup.Contrast)
	end

	E.global.mui.perfTuningBackup = nil
	F.Print(L["Previous graphics settings are back."])
end

local function GetPerformanceTuningInfo()
	local lines = {
		L["The tuning lowers the settings that cost a lot of FPS but add little to what you actually see in combat."],
		L["Your previous values are saved first, so the revert button can bring them back at any time."],
		"",
		F.String.RGB(L["Changed settings:"], I.Colors.Accent),
	}
	for _, entry in ipairs(TUNED_CVARS) do
		tinsert(lines, "- " .. entry[3])
	end
	tinsert(lines, "- " .. L["Contrast: +10 (if currently 55 or below)"])
	tinsert(lines, "")
	tinsert(
		lines,
		L["Character and world textures are left on high, only distant scenery, effects and post-processing are toned down."]
	)

	return tconcat(lines, "\n")
end

options.name = {
	order = 1,
	type = "group",
	name = module:AddCategorieIcon(L["General"], "OptionsHome"),
	get = function(info)
		return E.db.mui.general[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.general[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["General"],
		},
		performanceTuning = {
			order = 1.5,
			type = "group",
			name = L["Performance Tuning"],
			guiInline = true,
			args = {
				desc = {
					order = 1,
					type = "description",
					dialogControl = "MERNewFeatureLabel",
					name = F.NewFeatureTrailingText(
						L["Trades environment detail for a higher frame rate and a sharper image with one click."]
					),
					width = "full",
				},
				apply = {
					order = 2,
					type = "execute",
					name = L["Boost FPS & Clarity"],
					desc = L["Adjusts your graphics settings for a higher frame rate and a sharper image. Textures stay on high."],
					width = "full",
					arg = { boxWidth = 320, large = true },
					func = ApplyPerformanceTuning,
				},
				revert = {
					order = 3,
					type = "execute",
					name = L["Revert to Previous Settings"],
					desc = L["Puts back the graphics settings you had before the tuning."],
					width = "full",
					arg = { boxWidth = 220 },
					func = RevertPerformanceTuning,
					hidden = function()
						return not E.global.mui.perfTuningBackup
					end,
				},
				details = {
					order = 4,
					type = "execute",
					dialogControl = "MERTextLink",
					name = function()
						return showTuningInfo and L["Hide Details"] or L["Show Details"]
					end,
					width = "full",
					arg = { align = "CENTER" },
					func = function()
						showTuningInfo = not showTuningInfo
					end,
				},
				info = {
					order = 5,
					type = "description",
					dialogControl = "MERTextCard",
					fontSize = "medium",
					name = GetPerformanceTuningInfo,
					arg = { title = L["What the Tuning Changes"] },
					hidden = function()
						return not showTuningInfo
					end,
				},
			},
		},
		style = {
			order = 2,
			type = "group",
			name = MER.Title .. L["Style"],
			guiInline = true,
			get = function(info)
				return E.db.mui.style[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.style[info[#info]] = value
				-- Applied live: the template sweep in MER_Style adds or hides the overlays
				F.Event.TriggerEvent("Style.DatabaseUpdate")
			end,
			args = {
				enable = module.ToggleCard({
					order = 1,
					name = L["Enable"],
					desc = L["Enables the stripes/gradient look on the frames"],
					image = I.Media.Icons.Categories.Gradient,
				}),
			},
		},
		splashScreen = module.ToggleCard({
			order = 3,
			name = L["SplashScreen"],
			desc = L["Enable/Disable the Splash Screen on Login."],
		}, 0.5),
		AFK = module.ToggleCard({
			order = 4,
			name = L["AFK"],
			desc = L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"],
			disabled = module.RequirementsDisabled(I.Requirements.AFK),
		}, 0.5),
		afkRequirements = module.RequirementsNotice(I.Requirements.AFK, 5),
	},
}

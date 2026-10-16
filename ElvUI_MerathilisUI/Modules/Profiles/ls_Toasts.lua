local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

local ipairs = ipairs
local tinsert = tinsert

function module:LoadLSProfile()
	local _, LC = unpack(_G.ls_Toasts)
	if not (LC and LC.db) then
		return
	end

	-- Anchors are stored per Edit Mode layout since 120105.01, layouts missing here fall back to ls_Toasts' defaults
	local layouts = {}
	local layoutNames = { "Modern", "Classic" }

	local LEM = LibStub("LibEditMode", true)
	local activeLayout = LEM and LEM:GetActiveLayoutName()
	if activeLayout then
		tinsert(layoutNames, activeLayout)
	end

	for _, layoutName in ipairs(layoutNames) do
		layouts[layoutName] = {
			["anchors"] = {
				[1] = {
					["id"] = 1,
					["point"] = {
						["point"] = "TOP",
						["x"] = 0,
						["y"] = -210,
					},
					["scale"] = 1,
				},
			},
		}
	end

	self:ApplyAceDBProfile(LC.db, I.ProfileNames.Default, {
		["layouts"] = layouts,
		["font"] = {
			["name"] = I.Fonts.Primary,
			["size"] = 11,
		},
		["colors"] = {
			["enabled"] = true,
			["threshold"] = 2,
			["border"] = false,
		},
		["skin"] = "MerathilisUI",
		["types"] = {
			["garrison_6_0"] = {
				["enabled"] = true,
				["dnd"] = true,
				["sfx"] = true,
			},
			["loot_currency"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["instance"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["world"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["loot_special"] = {
				["enabled"] = true,
				["ilvl"] = true,
				["sfx"] = true,
				["threshold"] = 1,
				["dnd"] = false,
			},
			["achievement"] = {
				["enabled"] = true,
				["dnd"] = false,
			},
			["loot_gold"] = {
				["threshold"] = 1,
				["enabled"] = false,
				["dnd"] = false,
				["sfx"] = true,
			},
			["loot_common"] = {
				["threshold"] = 1,
				["ilvl"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["quest"] = false,
				["enabled"] = true,
			},
			["recipe"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["collection"] = {
				["enabled"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["left_click"] = false,
			},
			["archaeology"] = {
				["enabled"] = true,
				["dnd"] = false,
				["sfx"] = true,
			},
			["garrison_7_0"] = {
				["enabled"] = true,
				["dnd"] = true,
				["sfx"] = true,
			},
			["transmog"] = {
				["enabled"] = true,
				["sfx"] = true,
				["dnd"] = false,
				["left_click"] = false,
			},
		},
	})
end

function module:ApplyLSProfile()
	if not E:IsAddOnEnabled("ls_Toasts") then
		F.Developer.LogWarning("ls_Toasts is not enabled. Will not apply profile.")
		return
	end

	Splash:Wrap("Applying ls_Toasts Profile ...", function()
		self:LoadLSProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ls_Toasts")
end

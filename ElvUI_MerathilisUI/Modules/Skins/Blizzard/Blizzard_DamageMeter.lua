local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G

local C_CVar_SetCVar = C_CVar.SetCVar

local BlizzardTextureIDsForSpecs = {
	["608952"] = 270,
	["608953"] = 269,
	["608951"] = 268,
	["136145"] = 265,
	["136172"] = 266,
	["136186"] = 267,
	["135932"] = 62,
	["135810"] = 63,
	["135846"] = 64,
	["4511811"] = 1467,
	["4511812"] = 1468,
	["5198700"] = 1473,
	["1247264"] = 577,
	["1247265"] = 581,
	["7455385"] = 1480,
	["135940"] = 256,
	["237542"] = 257,
	["136207"] = 258,
	["461112"] = 253,
	["236179"] = 254,
	["461113"] = 255,
	["135920"] = 65,
	["236264"] = 66,
	["135873"] = 70,
	["136048"] = 262,
	["237581"] = 263,
	["136052"] = 264,
	["136096"] = 102,
	["132115"] = 103,
	["132276"] = 104,
	["136041"] = 105,
	["132355"] = 71,
	["132347"] = 72,
	["132341"] = 73,
	["135770"] = 250,
	["135773"] = 251,
	["135775"] = 252,
	["236270"] = 259,
	["236286"] = 260,
	["132320"] = 261,
	--initial specs, seems only evoker doesnt use the same icon
	--["135775"]=1455,
	--["1247264"]=1456,
	--["136096"]=1447,
	["4574311"] = 1465,
	--["461112"]=1448,
	--["135846"]=1449,
	--["608953"]=1450,
	--["135873"]=1451,
	--["135940"]=1452,
	--["236270"]=1453,
	--["136048"]=1444,
	--["136145"]=1454,
	--["132355"]=1446,
}

local class_specs_coords = {
	[577] = { 128 / 512, 192 / 512, 256 / 512, 320 / 512 }, --havoc demon hunter
	[581] = { 192 / 512, 256 / 512, 256 / 512, 320 / 512 }, --vengeance demon hunter
	[1480] = { 448 / 512, 512 / 512, 256 / 512, 320 / 512 }, --devourer demon hunter

	[250] = { 0, 64 / 512, 0, 64 / 512 }, --blood dk
	[251] = { 64 / 512, 128 / 512, 0, 64 / 512 }, --frost dk
	[252] = { 128 / 512, 192 / 512, 0, 64 / 512 }, --unholy dk

	[102] = { 192 / 512, 256 / 512, 0, 64 / 512 }, -- druid balance
	[103] = { 256 / 512, 320 / 512, 0, 64 / 512 }, -- druid feral
	[104] = { 320 / 512, 384 / 512, 0, 64 / 512 }, -- druid guardian
	[105] = { 384 / 512, 448 / 512, 0, 64 / 512 }, -- druid resto

	[253] = { 448 / 512, 512 / 512, 0, 64 / 512 }, -- hunter bm
	[254] = { 0, 64 / 512, 64 / 512, 128 / 512 }, --hunter marks
	[255] = { 64 / 512, 128 / 512, 64 / 512, 128 / 512 }, --hunter survivor

	[62] = { (128 / 512) + 0.001953125, 192 / 512, 64 / 512, 128 / 512 }, --mage arcane
	[63] = { 192 / 512, 256 / 512, 64 / 512, 128 / 512 }, --mage fire
	[64] = { 256 / 512, 320 / 512, 64 / 512, 128 / 512 }, --mage frost

	[268] = { 320 / 512, 384 / 512, 64 / 512, 128 / 512 }, --monk bm
	[269] = { 448 / 512, 512 / 512, 64 / 512, 128 / 512 }, --monk ww
	[270] = { 384 / 512, 448 / 512, 64 / 512, 128 / 512 }, --monk mw

	[65] = { 0, 64 / 512, 128 / 512, 192 / 512 }, --paladin holy
	[66] = { 64 / 512, 128 / 512, 128 / 512, 192 / 512 }, --paladin protect
	[70] = { (128 / 512) + 0.001953125, 192 / 512, 128 / 512, 192 / 512 }, --paladin ret

	[256] = { 192 / 512, 256 / 512, 128 / 512, 192 / 512 }, --priest disc
	[257] = { 256 / 512, 320 / 512, 128 / 512, 192 / 512 }, --priest holy
	[258] = { (320 / 512) + (0.001953125 * 4), 384 / 512, 128 / 512, 192 / 512 }, --priest shadow

	[259] = { 384 / 512, 448 / 512, 128 / 512, 192 / 512 }, --rogue assassination
	[260] = { 448 / 512, 512 / 512, 128 / 512, 192 / 512 }, --rogue combat
	[261] = { 0, 64 / 512, 192 / 512, 256 / 512 }, --rogue sub

	[262] = { 64 / 512, 128 / 512, 192 / 512, 256 / 512 }, --shaman elemental
	[263] = { 128 / 512, 192 / 512, 192 / 512, 256 / 512 }, --shamel enhancement
	[264] = { 192 / 512, 256 / 512, 192 / 512, 256 / 512 }, --shaman resto

	[265] = { 256 / 512, 320 / 512, 192 / 512, 256 / 512 }, --warlock aff
	[266] = { 320 / 512, 384 / 512, 192 / 512, 256 / 512 }, --warlock demo
	[267] = { 384 / 512, 448 / 512, 192 / 512, 256 / 512 }, --warlock destro

	[71] = { 448 / 512, 512 / 512, 192 / 512, 256 / 512 }, --warrior arms
	[72] = { 0, 64 / 512, 256 / 512, 320 / 512 }, --warrior fury
	[73] = { 64 / 512, 128 / 512, 256 / 512, 320 / 512 }, --warrior protect

	[1467] = { 256 / 512, 320 / 512, 256 / 512, 320 / 512 }, -- Devastation
	[1468] = { 320 / 512, 384 / 512, 256 / 512, 320 / 512 }, -- Preservation
	[1473] = { 384 / 512, 448 / 512, 256 / 512, 320 / 512 }, -- Augmentation
	[1465] = { 256 / 512, 320 / 512, 256 / 512, 320 / 512 }, -- Initial, let it use Devastation
}

local class_coords = {
	["DEMONHUNTER"] = {
		0.73828126 / 2, -- [1]
		1 / 2, -- [2]
		0.5 / 2, -- [3]
		0.75 / 2, -- [4]
	},
	["HUNTER"] = {
		0, -- [1]
		0.25 / 2, -- [2]
		0.25 / 2, -- [3]
		0.5 / 2, -- [4]
	},
	["WARRIOR"] = {
		0, -- [1]
		0.25 / 2, -- [2]
		0, -- [3]
		0.25 / 2, -- [4]
	},
	["ROGUE"] = {
		0.49609375 / 2, -- [1]
		0.7421875 / 2, -- [2]
		0, -- [3]
		0.25 / 2, -- [4]
	},
	["MAGE"] = {
		0.25 / 2, -- [1]
		0.49609375 / 2, -- [2]
		0, -- [3]
		0.25 / 2, -- [4]
	},
	["PET"] = {
		0.25 / 2, -- [1]
		0.49609375 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["DRUID"] = {
		0.7421875 / 2, -- [1]
		0.98828125 / 2, -- [2]
		0, -- [3]
		0.25 / 2, -- [4]
	},
	["MONK"] = {
		0.5 / 2, -- [1]
		0.73828125 / 2, -- [2]
		0.5 / 2, -- [3]
		0.75 / 2, -- [4]
	},
	["DEATHKNIGHT"] = {
		0.25 / 2, -- [1]
		0.5 / 2, -- [2]
		0.5 / 2, -- [3]
		0.75 / 2, -- [4]
	},
	["UNKNOW"] = {
		0.5 / 2, -- [1]
		0.75 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["PRIEST"] = {
		0.49609375 / 2, -- [1]
		0.7421875 / 2, -- [2]
		0.25 / 2, -- [3]
		0.5 / 2, -- [4]
	},
	["UNGROUPPLAYER"] = {
		0.5 / 2, -- [1]
		0.75 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["Alliance"] = {
		0.49609375 / 2, -- [1]
		0.742187 / 25, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["WARLOCK"] = {
		0.7421875 / 2, -- [1]
		0.98828125 / 2, -- [2]
		0.25 / 2, -- [3]
		0.5 / 2, -- [4]
	},
	["ENEMY"] = {
		0, -- [1]
		0.25 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["Horde"] = {
		0.7421875 / 2, -- [1]
		0.98828125 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["PALADIN"] = {
		0, -- [1]
		0.25 / 2, -- [2]
		0.5 / 2, -- [3]
		0.75 / 2, -- [4]
	},
	["MONSTER"] = {
		0, -- [1]
		0.25 / 2, -- [2]
		0.75 / 2, -- [3]
		1 / 2, -- [4]
	},
	["SHAMAN"] = {
		0.25 / 2, -- [1]
		0.49609375 / 2, -- [2]
		0.25 / 2, -- [3]
		0.5 / 2, -- [4]
	},
	["EVOKER"] = {
		0.50390625, -- [1]
		0.625, -- [2]
		0, -- [3]
		0.125, -- [4]
	},
}

module.DamageMeterIcons = {
	["details_white"] = {
		["DisplayName"] = "details_white",
		["isSpec"] = false,
		["path"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\Details\\details_white",
	},
	["details_roles"] = {
		["DisplayName"] = "details_roles",
		["isSpec"] = false,
		["path"] = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\Details\\details_roles",
	},
}

function module:AddDamageMeterIconPack(name, displayName, isSpec, path)
	if module.DamageMeterIcons[name] then
		return
	end --protect against adding it multiple times

	module.DamageMeterIcons[name] = {
		["displayName"] = displayName,
		["isSpec"] = isSpec,
		["path"] = path,
	}
end

local function SkinDamageMeter(bar)
	if not bar or not bar.StatusBar then
		return
	end

	if E.private.mui.skins.blizzard.damageMeter.replaceIcon then
		if bar.UpdateIcon and not bar.UpdateIconHook then
			hooksecurefunc(bar, "UpdateIcon", function(icon)
				local textureCoords
				if not bar.spellID then --avoid spell stuff
					textureCoords = class_coords[bar.classFilename]

					if textureCoords then
						if
							module.DamageMeterIcons[tostring(E.private.mui.skins.blizzard.damageMeter.iconPack)]["path"]
						then
							icon.Icon.Icon:SetTexture(
								module.DamageMeterIcons[tostring(E.private.mui.skins.blizzard.damageMeter.iconPack)]["path"]
							)
						else
							icon.Icon.Icon:SetTexture(module.DamageMeterIcons["details_white"]["path"])
						end
						icon.Icon.Icon:SetTexCoord(
							textureCoords[1],
							textureCoords[2],
							textureCoords[3],
							textureCoords[4]
						)
					end
				end
			end)
			bar.UpdateIconHook = true
		end
	end

	if E.private.mui.skins.blizzard.damageMeter.gradientBar then
		if not bar.GradientStatusBarHook then
			local sbtexture = bar.StatusBar:GetStatusBarTexture()
			hooksecurefunc(sbtexture, "SetVertexColor", function(_, r, g, b)
				if bar.classFilename then
					sbtexture:SetGradient("HORIZONTAL", F.GradientColorsDetails(bar.classFilename))
				else
					sbtexture:SetGradient("HORIZONTAL", {
						r = F:Interval(r - 0.5, 0, 1),
						g = F:Interval(g - 0.5, 0, 1),
						b = F:Interval(b - 0.5, 0, 1),
						a = 0.9,
					}, {
						r = F:Interval(r + 0.2, 0, 1),
						g = F:Interval(g + 0.2, 0, 1),
						b = F:Interval(b + 0.2, 0, 1),
						a = 0.9,
					})
				end
			end)

			bar.GradientStatusBarHook = true
		end
	end
end

function module:Blizzard_DamageMeter()
	if not E.private.mui.skins.blizzard.damageMeter.enable then
		return
	end

	C_CVar_SetCVar("damageMeterEnabled", 1)

	if _G.DamageMeter and not DamageMeter.IsSkinned then
		hooksecurefunc(S, "DamageMeter_HandleStatusBar", SkinDamageMeter)

		DamageMeter.IsSkinned = true
	end
end

module:AddCallbackForAddon("Blizzard_DamageMeter")

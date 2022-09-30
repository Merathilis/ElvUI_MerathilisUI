local MER, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local twipe = table.wipe

local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

function MER:LoadBigWigsProfile()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]----------------------------------
	local main = F.Profiles.Default

	-- Required to add profiles to BigWigs
	if not IsAddOnLoaded("BigWigs_Core") then LoadAddOn("BigWigs_Core") end

	-- Required to add profiles to Plugins BigWigs
	if not IsAddOnLoaded("BigWigs_Plugins") then LoadAddOn("BigWigs_Plugins") end

	local DB = E.Retail and _G.BigWigs3DB or _G.BigWigsClassicDB
	local iconDB = E.Retail and _G.BigWigsIconDB or _G.BigWigsIconClassicDB

	DB["profiles"] = DB["profiles"] or {}

	-- Disable minimap icon
	iconDB["hide"] = true

	DB["profiles"][main] = DB["profiles"][main] or {}
	DB["profiles"][main]["showZoneMessages"] = true
	DB["profiles"][main]["fakeDBMVersion"] = true
	DB["profiles"][main]["flash"] = true

	DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"][main] = {
		["bigwigsMsg"] = true,
		["blizzMsg"] = false,
	}
	DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][main] = {
		["outline"] = "OUTLINE",
		["fontName"] = "Expressway",
		["position"] = {
			"CENTER", -- [1]
			"CENTER", -- [2]
			7.999993801116943, -- [3]
			122.0000915527344, -- [4]
		},
	}
	DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][main] = {
		["exitCombatOther"] = 3,
		["disabled"] = false,
		["modeOther"] = 2,
	}
	DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][main] = {
		["barBackground"] = {
			["BigWigs_Plugins_Colors"] = {
				["default"] = {
					0, -- [1]
					0.474509803921569, -- [2]
					0.980392156862745, -- [3]
				},
			},
		},
	}
	DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"][main] = {
		["disabled"] = true,
	}
	DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][main] = {
		["posx"] = 962.8442941480171,
		["posy"] = 71.71141124165615,
	}
	DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][main] = {
		["BigWigsEmphasizeAnchor_y"] = 256,
		["BigWigsEmphasizeAnchor_x"] = 457,
		["BigWigsAnchor_y"] = 24,
		["BigWigsAnchor_x"] = 835,
		["BigWigsAnchor_width"] = 212,
		["BigWigsAnchor_height"] = 18,
		["BigWigsEmphasizeAnchor_height"] = 28,
		["BigWigsEmphasizeAnchor_width"] = 170,
		["fontName"] = "Expressway",
		["fontSizeEmph"] = 12,
		["fontSize"] = 11,
		["outline"] = "OUTLINE",
		["emphasizeScale"] = 1.1,
		["barStyle"] = "MerathilisUI",
		["growup"] = true,
		["emphasizeGrowup"] = true,
		["texture"] = "MER_NormTex",
	}
	DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][main] = {
		["outline"] = "OUTLINE",
		["fontSize"] = 20,
		["BWEmphasizeCountdownMessageAnchor_x"] = 664,
		["BWMessageAnchor_x"] = 608,
		["growUpwards"] = false,
		["BWEmphasizeCountdownMessageAnchor_y"] = 523,
		["BWEmphasizeMessageAnchor_y"] = 614,
		["BWMessageAnchor_y"] = 676,
		["BWEmphasizeMessageAnchor_x"] = 610,
		["emphFontName"] = "Expressway",
		["fontName"] = "Expressway",
	}
	DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][main] = {
		["posx"] = 346.27,
		["fontName"] = "Expressway",
		["lock"] = true,
		["height"] = 99.0000381469727,
		["posy"] = 81.82,
	}

	if E.Retail then
		-- Disable LibDualSpec to set the profile
		DB["namespaces"]["LibDualSpec-1.0"] = DB["namespaces"]["LibDualSpec-1.0"] or {}
		DB["namespaces"]["LibDualSpec-1.0"]["char"][E.mynameRealm]["enabled"] = false

		-- AltPower db
		DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"] or {}
		DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"][main] = {
			["posx"] = 600,
			["fontSize"] = 11,
			["fontOutline"] = "",
			["fontName"] = "Expressway",
			["lock"] = true,
			["posy"] = 132,
		}
	end

	-- Set the profile
	_G.BigWigs.db:SetProfile(main)
end

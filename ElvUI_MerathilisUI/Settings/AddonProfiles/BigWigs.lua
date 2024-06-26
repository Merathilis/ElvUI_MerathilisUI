local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G
local twipe = table.wipe

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = LoadAddOn

function MER:LoadBigWigsProfile()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]
	----------------------------------
	local profileName = I.ProfileNames.Default

	-- Required to add profiles to BigWigs
	if not C_AddOns_IsAddOnLoaded("BigWigs_Core") then
		LoadAddOn("BigWigs_Core")
	end

	-- Required to add profiles to Plugins BigWigs
	if not C_AddOns_IsAddOnLoaded("BigWigs_Plugins") then
		LoadAddOn("BigWigs_Plugins")
	end

	local DB = _G.BigWigs3DB
	local iconDB = _G.BigWigsIconDB

	DB["profiles"] = DB["profiles"] or {}

	iconDB["hide"] = true
	iconDB["showInCompartment"] = true

	DB["profiles"][profileName] = DB["profiles"][profileName] or {}
	DB["profiles"][profileName]["showZoneMessages"] = true
	DB["profiles"][profileName]["fakeDBMVersion"] = true
	DB["profiles"][profileName]["flash"] = true
	DB["profiles"][profileName]["englishSayMessages"] = true

	DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"][profileName] = {
		["bigwigsMsg"] = true,
		["blizzMsg"] = false,
	}
	DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName] = {
		["outline"] = "SHADOWOUTLINE",
		["fontName"] = I.Fonts.Primary,
		["position"] = {
			"CENTER",
			"CENTER",
			nil,
			200,
		},
	}
	DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName] = {
		["exitCombatOther"] = 3,
		["disabled"] = false,
		["modeOther"] = 2,
	}
	DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName] = {
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
	DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"][profileName] = {
		["disabled"] = true,
	}
	DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName] = {
		["posx"] = 962.8442941480171,
		["posy"] = 71.71141124165615,
	}
	DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] or {}
	DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName] = {
		["outline"] = "OUTLINE",
		["expWidth"] = 190,
		["growup"] = true,
		["fontName"] = I.Fonts.Primary,
		["fontSize"] = F.SetFontSizeScaled(13),
		["expHeight"] = 18,
		["emphasizeGrowup"] = true,
		["spacing"] = 15,
		["barStyle"] = "|cffffffffMerathilis|r|cffff7d0aUI|r ",
		["expPosition"] = {
			nil,
			nil,
			nil,
			90,
			"ElvUF_Player",
		},
		["fontSizeEmph"] = F.SetFontSizeScaled(15),
		["normalWidth"] = 295,
		["normalHeight"] = 20,
		["normalPosition"] = {
			"BOTTOMRIGHT",
			"BOTTOMRIGHT",
			-13,
			263,
		},
	}
	DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName] = {
		["emphFontName"] = I.Fonts.Primary,
		["emphFontSize"] = F.SetFontSizeScaled(24),
		["emphPosition"] = {
			nil,
			nil,
			nil,
			110,
		},
		["fontName"] = I.Fonts.Primary,
		["normalPosition"] = {
			"TOP",
			nil,
			nil,
			-180,
		},
	}
	DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName] = {
		["posx"] = 346.27,
		["fontName"] = I.Fonts.Primary,
		["lock"] = true,
		["height"] = 99.0000381469727,
		["posy"] = 81.82,
	}

	-- Disable LibDualSpec to set the profile
	DB["namespaces"]["LibDualSpec-1.0"] = DB["namespaces"]["LibDualSpec-1.0"] or {}
	DB["namespaces"]["LibDualSpec-1.0"]["char"][E.mynameRealm]["enabled"] = false

	-- AltPower db
	DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"] = DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"]
		or {}
	DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"][profileName] = {
		["fontSize"] = F.SetFontSizeScaled(11),
		["fontName"] = I.Fonts.Primary,
		["lock"] = true,
		["position"] = {
			"BOTTOM",
			"BOTTOM",
			-263.0009155273438,
			75.00016784667969,
		},
	}

	-- Set the profile
	_G.BigWigs.db:SetProfile(profileName)
end

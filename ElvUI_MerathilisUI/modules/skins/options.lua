local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, unpack = ipairs, unpack
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

local DecorAddons = {
	{'BigWigs', L["BigWigs"], 'bw'},
	{'WeakAuras', L["WeakAuras"]..MER.NewSign, 'wa'},
}

--[[local DecorElvUIAddons = {
	{'ElvUI_SLE', L['Shadow & Light'], 'sle'},
}]]

local function SkinsTable()
	E.Options.args.mui.args.skins = {
		order = 15,
		type = 'group',
		name = L['Skins']..MER.NewSign,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER:cOption(L['Skins']),
			},
		},
	}

	--[[E.Options.args.mui.args.skins.args.elvuiaddons = {
		order = 3,
		type = 'group',
		guiInline = true,
		name = L['ElvUI AddOns'],
		get = function(info) return E.private.muiSkins.elvuiAddons[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.elvuiAddons[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}

	local elvorder = 0
	for i, v in ipairs(DecorElvUIAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.mui.args.skins.args.elvuiaddons.args[addonOption] = {
			order = elvorder + 1,
			type = 'toggle',
			name = addonString,
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end]]

	E.Options.args.mui.args.skins.args.addonskins = {
		order = 4,
		type = 'group',
		guiInline = true,
		name = L['AddOnSkins'],
		get = function(info) return E.private.muiSkins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}

	local addorder = 0
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.mui.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = 'toggle',
			name = addonString,
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end

	E.Options.args.mui.args.skins.args.blizzard = {
		order = 5,
		type = 'group',
		guiInline = true,
		name = L['Blizzard'],
		get = function(info) return E.private.muiSkins.blizzard[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.blizzard[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["MER_SKINS_DESC"],
			},
			space1 = {
				order = 2,
				type = "description",
				name = "",
			},
			gotoskins = {
				order = 3,
				type = "execute",
				name = L["ElvUI Skins"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "skins") end,
			},
			space2 = {
				order = 4,
				type = "description",
				name = "",
			},
			encounterjournal = {
				order = 10,
				type = 'toggle',
				name = L["Encounter Journal"],
				disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
			},
			spellbook = {
				order = 11,
				type = 'toggle',
				name = L["Spellbook"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook end,
			},
			character = {
				order = 12,
				type = 'toggle',
				name = L["Character Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
			},
			gossip = {
				order = 13,
				type = 'toggle',
				name = L["Gossip Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip end,
			},
			quest = {
				order = 14,
				type = 'toggle',
				name = L["Quest Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},
			--[[worldmap = {
				order = 15,
				type = 'toggle',
				name = L["World Map"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},]]
			orderhall = {
				order = 17,
				type = 'group',
				name = L["Orderhall"],
				guiInline = true,
				get = function(info) return E.private.muiSkins.blizzard.orderhall[ info[#info] ] end,
				set = function(info, value) E.private.muiSkins.blizzard.orderhall[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
					},
					zoneText = {
						order = 2,
						type = 'toggle',
						name = L["Zone Text"],
						desc = L["Enable/Disable the Zone Text in the OrderHall Commandbar."],
						disabled = function() return not E.private.muiSkins.blizzard.orderhall.enable end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, SkinsTable)

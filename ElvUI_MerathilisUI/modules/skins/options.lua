local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:GetModule('MuiSkins');

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, unpack = ipairs, unpack
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

local DecorElvUIAddons = {}

local DecorAddons = {
	{'MasterPlan', L["MasterPlan"], 'mp'},
}

local function SkinsTable()
	E.Options.args.mui.args.skins = {
		order = 15,
		type = 'group',
		name = L['Skins'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER:cOption(L['Skins']),
			},
		},
	}
	
	E.Options.args.mui.args.skins.args.elvuiaddons = {
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
	end
	
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
			encounterjournal = {
				order = 1,
				type = 'toggle',
				name = L["Encounter Journal"],
			},
			objectivetracker = {
				order = 2,
				type = 'toggle',
				name = _G["OBJECTIVES_TRACKER_LABEL"],
			},
			spellbook = {
				order = 3,
				type = 'toggle',
				name = L["Spellbook"],
			},
			character = {
				order = 4,
				type = 'toggle',
				name = L["Character Frame"],
			},
			gossip = {
				order = 5,
				type = 'toggle',
				name = L["Gossip Frame"],
			},
			quest = {
				order = 5,
				type = 'toggle',
				name = L["Quest Frames"],
			},
		},
	}
end
tinsert(MER.Config, SkinsTable)

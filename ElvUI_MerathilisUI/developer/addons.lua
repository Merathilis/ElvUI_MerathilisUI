local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local pairs = pairs
-- WoW API / Variables
local EnableAddOn = EnableAddOn
local DisableAllAddOns = DisableAllAddOns
local ReloadUI = ReloadUI
--GLOBALS: DefaultList

local AddonList = {
	["!BugGrabber"] = {
		["default"] = true,
		["instance"] = true,
	},
	["!InspectFix"] = {
		["default"] = true,
		["instance"] = true,
	},
	["AddOnSkins"] = {
		["default"] = true,
		["instance"] = true,
	},
	["AdvancedInterfaceOptions"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Auctionator"] = {
		["default"] = true,
		["instance"] = false,
	},
	["BadBoy"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BagSync"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_AutoReply"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_BrokenIsles"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Cataclysm"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Core"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Nighthold"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Nightmare"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Options"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Plugins"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_TrialOfValor"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_Voice_HeroesOfTheStorm"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BigWigs_WarlordsOfDraenor"] = {
		["default"] = true,
		["instance"] = true,
	},
	["BugSack"] = {
		["default"] = true,
		["instance"] = true,
	},
	["CalendarKeyboardFixer"] = {
		["default"] = true,
		["instance"] = true,
	},
	["CleanBossButton"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Clique"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI_Config"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI_BenikUI"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI_MerathilisUI"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI_SLE"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ElvUI_VisualAuraTimers"] = {
		["default"] = true,
		["instance"] = true,
	},
	["ExRT"] = {
		["default"] = true,
		["instance"] = true,
	},
	["HandyNotes"] = {
		["default"] = true,
		["instance"] = false,
	},
	["HandyNotes_LegionRaresTreasures"] = {
		["default"] = true,
		["instance"] = false,
	},
	["HandyNotes_SuramarTelemancy"] = {
		["default"] = true,
		["instance"] = false,
	},
	["LittleWigs"] = {
		["default"] = true,
		["instance"] = true,
	},
	["LootMon"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Masque"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Masque_Renaitre"] = {
		["default"] = true,
		["instance"] = true,
	},
	["MasterPlan"] = {
		["default"] = true,
		["instance"] = false,
	},
	["MasterPlanA"] = {
		["default"] = true,
		["instance"] = false,
	},
	["NomiCakes"] = {
		["default"] = true,
		["instance"] = false,
	},
	["oRA3"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Pawn"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Postal"] = {
		["default"] = true,
		["instance"] = false,
	},
	["premade-filter"] = {
		["default"] = true,
		["instance"] = true,
	},
	["RCLootCouncil"] = {
		["default"] = true,
		["instance"] = true,
	},
	["SavedInstances"] = {
		["default"] = true,
		["instance"] = true,
	},
	["Skada"] = {
		["default"] = true,
		["instance"] = true,
	},
	["SorhaQuestLog"] = {
		["default"] = true,
		["instance"] = true,
	},
	["SpeedyLoad"] = {
		["default"] = true,
		["instance"] = true,
	},
	["StrataFix"] = {
		["default"] = true,
		["instance"] = true,
	},
	["WeakAuras"] = {
		["default"] = true,
		["instance"] = true,
	},
	["WeakAurasOptions"] = {
		["default"] = true,
		["instance"] = true,
	},
	["WIM"] = {
		["default"] = true,
		["instance"] = true,
	},
	["WIM_FlatPanel"] = {
		["default"] = true,
		["instance"] = true,
	},
	["WowLua"] = {
		["default"] = true,
		["instance"] = true,
	},
}

E.PopupDialogs["MERUI_SelectUI"] = {
	text = L["Choose a preset!"],
	button1 = L["Default"],
	button2 = L["Instance"],
	button3 = L["ElvUI only"],
	OnAccept = function() E:StaticPopup_Show("MERUI_StandardUI") end,
	OnCancel = function() E:StaticPopup_Show("MERUI_InstanceUI") end,
	OnAlt = function() E:StaticPopup_Show("MERUI_ElvTest") end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

E.PopupDialogs["MERUI_StandardUI"] = {
	text = L["Choose this preset?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function() MER:AddonsPreset("default") end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}

E.PopupDialogs["MERUI_InstanceUI"] = {
	text = L["Choose this preset?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function() MER:AddonsPreset("instance") end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}

E.PopupDialogs["MERUI_ElvTest"] = {
	text = L["ElvU only"],
	button1 = YES,
	button2 = NO,
	OnAccept = function() MER:ElvUITest() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}

function MER:AddonsPreset(mode)
	DisableAllAddOns(E.myname)
	for addon, presets in pairs(AddonList) do
		if presets[mode] then
			EnableAddOn(addon)
		end
	end
	ReloadUI()
end

function MER:ElvUITest()
	DisableAllAddOns(E.myname)
	EnableAddOn("ElvUI")
	EnableAddOn("ElvUI_Config")
	EnableAddOn("!BugGrabber")
	EnableAddOn("BugSack")

	ReloadUI()
end
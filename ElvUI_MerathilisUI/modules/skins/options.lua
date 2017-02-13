local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, unpack = ipairs, unpack
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

local DecorAddons = {
	{"ActionBarProfiles", L["ActonBarProfiles"], "abp"},
	{"BigWigs", L["BigWigs"], "bw"},
	{"WeakAuras", L["WeakAuras"], "wa"},
	{"XIV_Databar", L["XIV_Databar"], "xiv"},
}

local SupportedProfiles = {
	{'AddOnSkins', 'AddOnSkins'},
	{'BigWigs', 'BigWigs'},
	{'ElvUI_BenikUI', 'ElvUI_BenikUI'},
	{'ElvUI_SLE', 'ElvUI_SLE'},
	{'Kui_Nameplates_Core', 'KuiNamePlatesCore'},
	{'Skada', 'Skada'},
	{'SorhaQuestLog', 'SorhaQuestLog'},
	{'XIV_Databar', 'XIV_Databar'},
}

local profileString = format('|cfffff400%s |r', L["MerathilisUI successfully created and applied profile(s) for:"])

local function SkinsTable()
	E.Options.args.mui.args.skins = {
		order = 15,
		type = "group",
		name = L["Skins/AddOns"]..MER.NewSign,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Skins"]),
			},
		},
	}

	E.Options.args.mui.args.skins.args.addonskins = {
		order = 4,
		type = "group",
		guiInline = true,
		name = MER:cOption(L["AddOnSkins"]),
		get = function(info) return E.private.muiSkins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			},
		}

	local addorder = 0
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.mui.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = "toggle",
			name = addonString,
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end

	E.Options.args.mui.args.skins.args.blizzard = {
		order = 5,
		type = "group",
		guiInline = true,
		name = MER:cOption(L["Blizzard"]),
		get = function(info) return E.private.muiSkins.blizzard[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.blizzard[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
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
				type = "toggle",
				name = L["Encounter Journal"],
				disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
			},
			spellbook = {
				order = 11,
				type = "toggle",
				name = L["Spellbook"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook end,
			},
			character = {
				order = 12,
				type = "toggle",
				name = L["Character Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
			},
			gossip = {
				order = 13,
				type = "toggle",
				name = L["Gossip Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip end,
			},
			quest = {
				order = 14,
				type = "toggle",
				name = L["Quest Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},
			orderhall = {
				order = 15,
				type = "toggle",
				name = L["Orderhall"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
			},
			talent = {
				order = 16,
				type = "toggle",
				name = L["Talent Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent end,
			},
		},
	}

	E.Options.args.mui.args.skins.args.profiles = {
		order = 6,
		type = 'group',
		guiInline = true,
		name = L["Profiles"]..MER.NewSign,
		args = {
		},
	}

	for i, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		local optionOrder = 1
		E.Options.args.mui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = 'execute',
			name = addonName,
			desc = L['This will create and apply profile for ']..addonName,
			func = function()
				if addon == 'BigWigs' then
					MER:LoadBigWigsProfile()
				elseif addon == 'ElvUI_BenikUI' then
					MER:LoadBenikUIProfile()
				elseif addon == 'ElvUI_SLE' then
					MER:LoadShadowandLightProfile()
				elseif addon == 'SorhaQuestLog' then
					MER:LoadSorhaQuestLogProfile()
				elseif addon == 'Skada' then
					MER:LoadSkadaProfile()
				elseif addon == 'XIV_Databar' then
					MER:LoadXIVDatabarProfile()
				elseif addon == 'AddOnSkins' then
					MER:LoadAddOnSkinsProfile()
				end
				print(profileString..addonName)
			end,
			disabled = function() return not IsAddOnLoaded(addon) end,
		}
	end
end
tinsert(MER.Config, SkinsTable)
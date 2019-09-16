local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, unpack = ipairs, unpack
local format = string.format
local tinsert = table.insert
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: LibStub, GARRISON_LOCATION_TOOLTIP, COLLECTIONS, OBJECTIVES_TRACKER_LABEL, DRESSUP_FRAME

local DecorAddons = {
	{"ActionBarProfiles", L["ActonBarProfiles"], "abp"},
	{"BigWigs", L["BigWigs"], "bw"},
	{"ElvUI_BenikUI", L["BenikUI"], "bui"},
	{"BugSack", L["BugSack"], "bs",},
	{"ProjectAzilroka", L["ProjectAzilroka"], "pa"},
	{"Postal", L["Postal"], "po"},
	{"ls_Toasts", L["ls_Toasts"], "ls"},
	{"DBM-Core", L["Deadly Boss Mods"], "dbm"},
	{"Clique", L["Clique"], "cl"},
	{"cargBags_Nivaya", L["cargBags_Nivaya"], "cbn"},
	{"EventTracker", L["EventTracker"], "et"},
}

local SupportedProfiles = {
	{"AddOnSkins", "AddOnSkins"},
	{"BigWigs", "BigWigs"},
	{"Details", "Details"},
	{"ElvUI_BenikUI", "BenikUI"},
	{"ElvUI_FCT", "FCT"},
	{"Skada", "Skada"},
	{"ProjectAzilroka", "ProjectAzilroka"},
	{"ls_Toasts", "ls_Toasts"},
	{"DBM-Core", "Deadly Boss Mods"},
	{"Touhin", "Touhin"},
	{"iFilger", "iFilger"},
}

local profileString = format('|cfffff400%s |r', L["MerathilisUI successfully created and applied profile(s) for:"])

local function SkinsTable()
	E.Options.args.mui.args.skins = {
		order = 200,
		type = "group",
		name = L["Skins/AddOns"],
		childGroups = "tab",
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Skins/AddOns"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					style = {
						order = 1,
						type = "toggle",
						name = L["MerathilisUI Style"],
						desc = L["Creates decorative stripes and a gradient on some frames"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					panels = {
						order = 2,
						type = "toggle",
						name = L["MerathilisUI Panels"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					shadowOverlay = {
						order = 3,
						type = "toggle",
						name = L["MerathilisUI Shadows"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
			spacer = {
				order = 3,
				type = 'description',
				name = "",
			},
			merchant = {
				order = 4,
				type = 'group',
				name = L["Merchant Frame"],
				get = function(info) return E.db.mui.merchant[ info[#info] ] end,
				set = function(info, value) E.db.mui.merchant[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					credits = {
						order = 0,
						type = "group",
						name = MER:cOption(L["Credits"]),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = format("|cff9482c9Shadow&Light - Darth Predator|r"),
							},
						},
					},
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					subpages = {
						order = 2,
						type = 'range',
						name = L["Subpages"],
						desc = L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."],
						min = 2, max = 5, step = 1,
						disabled = function() return not E.db.mui.merchant.enable or E.db.mui.merchant.style ~= "Default" end,
					},
				},
			},
		},
	}

	E.Options.args.mui.args.skins.args.addonskins = {
		order = 6,
		type = "group",
		name =L["AddOnSkins"],
		get = function(info) return E.private.muiSkins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.private.muiSkins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["MER_ADDONSKINS_DESC"],
			},
			space1 = {
				order = 2,
				type = "description",
				name = "",
			},
		},
	}

	local addorder = 3
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption, Notes = unpack(v)
		E.Options.args.mui.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = "toggle",
			name = addonString,
			desc = format('%s '..addonString..' %s', L["Enable/Disable"], L["decor."]),
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end

	local blizzOrder = 4
	E.Options.args.mui.args.skins.args.blizzard = {
		order = blizzOrder + 1,
		type = "group",
		name = L["Blizzard"],
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
				type = "toggle",
				name = ENCOUNTER_JOURNAL,
				disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
			},
			spellbook = {
				type = "toggle",
				name = SPELLBOOK,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook end,
			},
			character = {
				type = "toggle",
				name = L["Character Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
			},
			gossip = {
				type = "toggle",
				name = L["Gossip Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip end,
			},
			quest = {
				type = "toggle",
				name = L["Quest Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},
			questChoice = {
				type = "toggle",
				name = L["Quest Choice"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice end,
			},
			garrison = {
				type = "toggle",
				name = _G.GARRISON_LOCATION_TOOLTIP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.garrison end,
			},
			orderhall = {
				type = "toggle",
				name = L["Orderhall"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
			},
			talent = {
				type = "toggle",
				name = _G.TALENTS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent end,
			},
			auctionhouse = {
				type = "toggle",
				name = _G.AUCTIONS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse end,
			},
			friends = {
				type = "toggle",
				name = _G.FRIENDS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.friends end,
			},
			contribution = {
				type = "toggle",
				name = L["Contribution"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Contribution end,
			},
			artifact = {
				type = "toggle",
				name = _G.ITEM_QUALITY6_DESC,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.artifact end,
			},
			collections = {
				type = "toggle",
				name = _G.COLLECTIONS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.collections end,
			},
			calendar = {
				type = "toggle",
				name = L["Calendar Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.calendar end,
			},
			merchant = {
				type = "toggle",
				name = L["Merchant Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.merchant end,
			},
			worldmap = {
				type = "toggle",
				name = _G.WORLD_MAP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap end,
			},
			pvp = {
				type = "toggle",
				name = L["PvP Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp end,
			},
			achievement = {
				type = "toggle",
				name = _G.ACHIEVEMENTS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.achievement end,
			},
			tradeskill = {
				type = "toggle",
				name = _G.TRADESKILLS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tradeskill end,
			},
			lfg = {
				type = "toggle",
				name = _G.LFG_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg end,
			},
			lfguild = {
				type = "toggle",
				name = L["LF Guild Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfguild end,
			},
			talkinghead = {
				type = "toggle",
				name = L["TalkingHead"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talkinghead end,
			},
			guild = {
				type = "toggle",
				name = _G.GUILD,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guild end,
			},
			objectiveTracker = {
				type = "toggle",
				name = _G.OBJECTIVES_TRACKER_LABEL,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
			},
			addonManager = {
				type = "toggle",
				name = L["AddOn Manager"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.addonManager end,
			},
			mail = {
				type = "toggle",
				name =  L["Mail Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.mail end,
			},
			raid = {
				type = "toggle",
				name = L["Raid Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.raid end,
			},
			dressingroom = {
				type = "toggle",
				name = _G.DRESSUP_FRAME,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom end,
			},
			timemanager = {
				type = "toggle",
				name = _G.TIMEMANAGER_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.timemanager end,
			},
			blackmarket = {
				type = "toggle",
				name = _G.BLACK_MARKET_AUCTION_HOUSE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.bmah end,
			},
			guildcontrol = {
				type = "toggle",
				name = L["Guild Control Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guildcontrol end,
			},
			macro = {
				type = "toggle",
				name = _G.MACROS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro end,
			},
			binding = {
				type = "toggle",
				name = _G.KEY_BINDING,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.binding end,
			},
			gbank = {
				type = "toggle",
				name = _G.GUILD_BANK,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gbank end,
			},
			taxi = {
				type = "toggle",
				name = _G.FLIGHT_MAP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.taxi end,
			},
			help = {
				type = "toggle",
				name = L["Help Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.help end,
			},
			loot = {
				type = "toggle",
				name = L["Loot Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.loot end,
			},
			warboard = {
				type = "toggle",
				name = L["Warboard"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Warboard end,
			},
			deathRecap = {
				type = "toggle",
				name = _G.DEATH_RECAP_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.deathRecap end,
			},
			questPOI = {
				type = "toggle",
				name = "QuestPOI",
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice end,
			},
			channels = {
				type = "toggle",
				name = _G.CHANNELS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Channels end,
			},
			communities = {
				type = "toggle",
				name = _G.COMMUNITIES,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Communities end,
			},
			challenges = {
				type = "toggle",
				name = _G.CHALLENGES,
				disabled = function() return not E.private.skins.blizzard.enable end, -- No ElvUI skin yet
			},
			AzeriteUI = {
				type = "toggle",
				name = L["AzeriteUI"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.AzeriteUI end,
			},
			AzeriteRespec = {
				type = "toggle",
				name = _G.AZERITE_RESPEC_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.AzeriteRespec end,
			},
			IslandQueue = {
				type = "toggle",
				name = _G.ISLANDS_HEADER,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.IslandQueue end,
			},
			IslandsPartyPose = {
				type = "toggle",
				name = L["Island Party Pose"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.IslandsPartyPose end,
			},
			minimap = {
				type = "toggle",
				name = L["Minimap"],
				disabled = function() return not E.private.skins.blizzard.enable end,
			},
			Scrapping = {
				type = "toggle",
				name = _G.SCRAP_BUTTON,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Scrapping end,
			},
			trainer = {
				type = "toggle",
				name = L["Trainer Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer end,
			},
			debug = {
				type = "toggle",
				name = L["Debug Tools"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.debug end,
			},
			inspect = {
				type = "toggle",
				name = _G.INSPECT,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
			},
			socket = {
				type = "toggle",
				name = L["Socket Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket end,
			},
			itemUpgrade = {
				type = "toggle",
				name = L["Item Upgrade"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade end,
			},
			trade = {
				type = "toggle",
				name = _G.TRADESKILLS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trade end,
			},
			voidstorage = {
				type = "toggle",
				name = _G.VOID_STORAGE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.voidstorage end,
			},
			AlliedRaces = {
				type = "toggle",
				name = L["Allied Races"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.AlliedRaces end,
			},
			GMChat = {
				type = "toggle",
				name = L["GM Chat"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.GMChat end,
			},
			Archaeology = {
				type = "toggle",
				name = L["Archaeology Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.archaeology end,
			},
		},
	}

	E.Options.args.mui.args.skins.args.profiles = {
		order = 6,
		type = "group",
		name = L["Profiles"],
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["MER_PROFILE_DESC"],
			},
		},
	}

	for i, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		local optionOrder = 1
		E.Options.args.mui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = "execute",
			name = addonName,
			desc = L["This will create and apply profile for "]..addonName,
			buttonElvUI = true,
			func = function()
				if addon == 'BigWigs' then
					E:StaticPopup_Show("MUI_INSTALL_BW_LAYOUT")
				elseif addon == 'DBM-Core' then
					E:StaticPopup_Show("MUI_INSTALL_DBM_LAYOUT")
				elseif addon == 'ElvUI_BenikUI' then
					E:StaticPopup_Show("MUI_INSTALL_BUI_LAYOUT")
				elseif addon == 'Skada' then
					MER:LoadSkadaProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Details' then
					E:StaticPopup_Show("MUI_INSTALL_DETAILS_LAYOUT")
				elseif addon == 'AddOnSkins' then
					MER:LoadAddOnSkinsProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ProjectAzilroka' then
					MER:LoadPAProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ls_Toasts' then
					MER:LoadLSProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Touhin' then
					MER:LoadTouhinProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'iFilger' then
					MER:LoadiFilgerProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				end
				MER:Print(profileString..addonName)
			end,
			disabled = function() return not IsAddOnLoaded(addon) end,
		}
	end
end
tinsert(MER.Config, SkinsTable)

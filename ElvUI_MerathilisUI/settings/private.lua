local MER, E, L, V, P, G = unpack(select(2, ...))

----------------------------------------------------------------------------------------
-- Misc options
----------------------------------------------------------------------------------------
if V["mui"] == nil then V["mui"] = {} end
if V["muiMisc"] == nil then V["muiMisc"] = {} end

V["mui"] = {
	["installed"] = nil,
}

V["muiMisc"] = {
	["session"] = {
		["day"] = 1,
	}
}

----------------------------------------------------------------------------------------
-- Skins options
----------------------------------------------------------------------------------------
if V["muiSkins"] == nil then V["muiSkins"] = {} end

V["muiSkins"] = {
	["blizzard"] = {
		["character"] = true,
		["encounterjournal"] = true,
		["gossip"] = true,
		["quest"] = true,
		["questChoice"] = true,
		["spellbook"] = true,
		["orderhall"] = true,
		["talent"] = true,
		["auctionhouse"] = true,
		["friends"] = true,
		["garrison"] = true,
		["contribution"] = true,
		["artifact"] = true,
		["collections"] = true,
		["calendar"] = true,
		["merchant"] = true,
		["worldmap"] = true,
		["pvp"] = true,
		["achievement"] = true,
		["tradeskill"] = true,
		["lfg"] = true,
		["lfguild"] = true,
		["talkinghead"] = true,
		["guild"] = true,
		["objectiveTracker"] = true,
		["addonManager"] = true,
		["mail"] = true,
		["raid"] = true,
		["dressingroom"] = true,
		["timemanager"] = true,
		["blackmarket"] = true,
		["guildcontrol"] = true,
		["macro"] = true,
		["binding"] = true,
		["gbank"] = true,
		["taxi"] = true,
		["help"] = true,
		["loot"] = true,
		["warboard"] = true,
		["deathRecap"] = true,
		["questPOI"] = true,
		["communities"] = true,
		["channels"] = true,
	},
	["addonSkins"] = {
		["abp"] = true,
		["bw"] = true,
		["wa"] = true,
		["xiv"] = true,
		["bui"] = true,
		["bs"] = true,
		["pa"] = true,
		["po"] = true,
		["ls"] = true,
		["dbm"] = true,
	},
	["elvuiAddons"] = {
		-- ["sle"] = true,
	},
	["closeButton"] = true,
}

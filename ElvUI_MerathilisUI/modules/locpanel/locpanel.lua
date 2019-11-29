local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("LocPanel", "AceTimer-3.0", "AceEvent-3.0")
local M = E:GetModule("Minimap")
local DD = E:GetModule("Dropdown")

-- Cache global variables
-- Lua functions
local _G = _G
local format, split = string.format, string.split
local tinsert, twipe = table.insert, table.wipe
local pairs, select, tonumber = pairs, select, tonumber
local collectgarbage = collectgarbage
-- WoW API / Variables
local GetBindLocation = GetBindLocation
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local GetItemInfo = GetItemInfo
local GetMinimapZoneText = GetMinimapZoneText
local GetScreenHeight = GetScreenHeight
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local GetZonePVPInfo = GetZonePVPInfo
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local IsShiftKeyDown = IsShiftKeyDown
local IsSpellKnown = IsSpellKnown
local IsUsableItem = IsUsableItem
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat
local UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK = UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK
local DUNGEON_FLOOR_DALARAN1 = DUNGEON_FLOOR_DALARAN1
local CHALLENGE_MODE = CHALLENGE_MODE
local PlayerHasToy = PlayerHasToy
local C_GarrisonIsPlayerInGarrison = C_Garrison.IsPlayerInGarrison
local C_ToyBox = C_ToyBox
local Minimap = Minimap
local UnitFactionGroup = UnitFactionGroup
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
-- GLOBALS: HSplace, LE_GARRISON_TYPE_7_0, TUTORIAL_TITLE31

local loc_panel
local faction

module.CDformats = {
	["DEFAULT"] = [[ (%s |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
	["DEFAULT_ICONFIRST"] = [[ (|TInterface\FriendsFrame\StatusIcon-Away:16|t %s)]],
}

module.ReactionColors = {
	["sanctuary"] = {r = 0.41, g = 0.8, b = 0.94},
	["arena"] = {r = 1, g = 0.1, b = 0.1},
	["friendly"] = {r = 0.1, g = 1, b = 0.1},
	["hostile"] = {r = 1, g = 0.1, b = 0.1},
	["contested"] = {r = 1, g = 0.7, b = 0.10},
	["combat"] = {r = 1, g = 0.1, b = 0.1},
}

module.MainMenu = {}
module.SecondaryMenu = {}

module.ListUpdating = false
module.ListBuilding = false
module.InfoUpdatingTimer = nil

local function GetDirection()
	local _, y = _G["MER_LocPanel"]:GetCenter()
	local screenHeight = GetScreenHeight()
	local anchor, point = "TOP", "BOTTOM"
	if y and y < (screenHeight / 2) then
		anchor = "BOTTOM"
		point = "TOP"
	end
	return anchor, point
end

--{ItemID, ButtonText, isToy}
module.Hearthstones = {
	{6948}, -- Hearthstone
	{54452, nil, true}, -- Ethereal Portal
	{64488, nil, true}, -- The Innkeeper's Daughter
	{93672, nil, true}, -- Dark Portal
	{142542, nil, true}, -- Tome of Town Portal (Diablo Event)
	{162973, nil, true}, -- Winter HS
	{163045, nil, true}, -- Hallow HS
	{165669, nil, true}, -- Lunar HS
	{165670, nil, true}, -- Love HS
	{165802, nil, true}, -- Noblegarden HS
	{166746, nil, true}, -- Midsummer HS
	{166747, nil, true}, -- Brewfest HS
	{172179, nil, true}, -- Eternal Traveler's HS
}

module.PortItems = {
	{140192, DUNGEON_FLOOR_DALARAN1}, --Dalaran Hearthstone
	{110560, GARRISON_LOCATION_TOOLTIP}, --Garrison Hearthstone
	{128353}, --Admiral's Compass
	{37863}, --Grim Guzzler
	{52251}, --Jaina's Locket
	{58487}, --Potion of Deepholm
	{43824, nil, true}, --The Schools of Arcane Magic - Mastery
	{64457}, --The Last Relic of Argus
	{141605}, --Flight Masters's Whistle
	{128502}, --Hunter's Seeking Crystal
	{128503}, --Master Hunter's Seeking Crystal
	{140324, nil, true}, --Mobile Telemancy Beacon
	{129276}, --Beginner's Guide to Dimensional Rifting
	{140493}, --Adept's Guide to Dimensional Rifting
	{95567, nil, true}, --Kirin Tor beakon
	{95568, nil, true}, --Sunreaver beakon
	{87548}, --Pandaria Arch
}
module.EngineerItems = {
	{18984, nil, true}, --Dimensional Ripper - Everlook
	{18986, nil, true}, --Ultrasafe Transporter: Gadgetzan
	{30542, nil, true}, --Dimensional Ripper - Area 52
	{30544, nil, true}, --Ultrasafe Transporter: Toshley's Station
	{48933, nil, true}, --Wormhole Generator: Northrend
	{87215, nil, true}, --Wormhole Generator: Pandaria
	{112059, nil, true}, --Wormhole Centrifuge
	{151652, nil, true}, --Wormhole Generator: Argus
	{168807, nil, true}, --Wormhole Generator: Kul Tiras
	{168808, nil, true}, --Wormhole Generator: Zandalar
}
module.Spells = {
	["DEATHKNIGHT"] = {
		[1] = {text =  GetSpellInfo(50977),icon = MER:GetIconFromID("spell", 50977),secure = {buttonType = "spell",ID = 50977}, UseTooltip = true},
	},
	["DEMONHUNTER"] = {},
	["DRUID"] = {
		[1] = {text = GetSpellInfo(18960),icon = MER:GetIconFromID("spell", 18960),secure = {buttonType = "spell",ID = 18960}, UseTooltip = true},--Moonglade
		[2] = {text = GetSpellInfo(147420),icon = MER:GetIconFromID("spell", 147420),secure = {buttonType = "spell",ID = 147420}, UseTooltip = true},--One With Nature
		[3] = {text = GetSpellInfo(193753),icon = MER:GetIconFromID("spell", 193753),secure = {buttonType = "spell",ID = 193753}, UseTooltip = true},--Druid ClassHall
	},
	["HUNTER"] = {},
	["MAGE"] = {
		[1] = {text = GetSpellInfo(193759),icon = MER:GetIconFromID("spell", 193759),secure = {buttonType = "spell",ID = 193759}, UseTooltip = true}, --Guardian place
	},
	["MONK"] = {
		[1] = {text = GetSpellInfo(126892),icon = MER:GetIconFromID("spell", 126892),secure = {buttonType = "spell",ID = 126892}, UseTooltip = true},-- Zen Pilgrimage
		[2] = {text = GetSpellInfo(126895),icon = MER:GetIconFromID("spell", 126895),secure = {buttonType = "spell",ID = 126895}, UseTooltip = true},-- Zen Pilgrimage: Return
	},
	["PALADIN"] = {},
	["PRIEST"] = {},
	["ROGUE"] = {},
	["SHAMAN"] = {
		[1] = {text = GetSpellInfo(556),icon = MER:GetIconFromID("spell", 556),secure = {buttonType = "spell",ID = 556}, UseTooltip = true},
	},
	["WARLOCK"] = {},
	["WARRIOR"] = {},
	["DarkIronDwarf"] = {
		[1] = {text = GetSpellInfo(265225),icon = MER:GetIconFromID("spell", 265225),secure = {buttonType = "spell",ID = 265225}, UseTooltip = true}, -- Mole Machine (Dark Iron Dwarfs)
	},
	["teleports"] = {
		["Horde"] = {
			[1] = {text = GetSpellInfo(3563),icon = MER:GetIconFromID("spell", 3563),secure = {buttonType = "spell",ID = 3563}, UseTooltip = true},-- TP:Undercity
			[2] = {text = GetSpellInfo(3566),icon = MER:GetIconFromID("spell", 3566),secure = {buttonType = "spell",ID = 3566}, UseTooltip = true},-- TP:Thunder Bluff
			[3] = {text = GetSpellInfo(3567),icon = MER:GetIconFromID("spell", 3567),secure = {buttonType = "spell",ID = 3567}, UseTooltip = true},-- TP:Orgrimmar
			[4] = {text = GetSpellInfo(32272),icon = MER:GetIconFromID("spell", 32272),secure = {buttonType = "spell",ID = 32272}, UseTooltip = true},-- TP:Silvermoon
			[5] = {text = GetSpellInfo(49358),icon = MER:GetIconFromID("spell", 49358),secure = {buttonType = "spell",ID = 49358}, UseTooltip = true},-- TP:Stonard
			[6] = {text = GetSpellInfo(35715),icon = MER:GetIconFromID("spell", 35715),secure = {buttonType = "spell",ID = 35715}, UseTooltip = true},-- TP:Shattrath
			[7] = {text = GetSpellInfo(53140),icon = MER:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}, UseTooltip = true},-- TP:Dalaran - Northrend
			[8] = {text = GetSpellInfo(88344),icon = MER:GetIconFromID("spell", 88344),secure = {buttonType = "spell",ID = 88344}, UseTooltip = true},-- TP:Tol Barad
			[9] = {text = GetSpellInfo(132627),icon = MER:GetIconFromID("spell", 132627),secure = {buttonType = "spell",ID = 132627}, UseTooltip = true},-- TP:Vale of Eternal Blossoms
			[10] = {text = GetSpellInfo(120145),icon = MER:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}, UseTooltip = true},-- TP:Ancient Dalaran
			[11] = {text = GetSpellInfo(176242),icon = MER:GetIconFromID("spell", 176242),secure = {buttonType = "spell",ID = 176242}, UseTooltip = true},-- TP:Warspear
			[12] = {text = GetSpellInfo(224869),icon = MER:GetIconFromID("spell", 224869),secure = {buttonType = "spell",ID = 224869}, UseTooltip = true},-- TP:Dalaran - BI
			[13] = {text = GetSpellInfo(281404),icon = MER:GetIconFromID("spell", 281404),secure = {buttonType = "spell",ID = 281404}, UseTooltip = true},-- TP:Dazar'alor
		},
		["Alliance"] = {
			[1] = {text = GetSpellInfo(3561),icon = MER:GetIconFromID("spell", 3561),secure = {buttonType = "spell",ID = 3561}, UseTooltip = true},-- TP:Stormwind
			[2] = {text = GetSpellInfo(3562),icon = MER:GetIconFromID("spell", 3562),secure = {buttonType = "spell",ID = 3562}, UseTooltip = true},-- TP:Ironforge
			[3] = {text = GetSpellInfo(3565),icon = MER:GetIconFromID("spell", 3565),secure = {buttonType = "spell",ID = 3565}, UseTooltip = true},-- TP:Darnassus
			[4] = {text = GetSpellInfo(32271),icon = MER:GetIconFromID("spell", 32271),secure = {buttonType = "spell",ID = 32271}, UseTooltip = true},-- TP:Exodar
			[5] = {text = GetSpellInfo(49359),icon = MER:GetIconFromID("spell", 49359),secure = {buttonType = "spell",ID = 49359}, UseTooltip = true},-- TP:Theramore
			[6] = {text = GetSpellInfo(33690),icon = MER:GetIconFromID("spell", 33690),secure = {buttonType = "spell",ID = 33690}, UseTooltip = true},-- TP:Shattrath
			[7] = {text = GetSpellInfo(53140),icon = MER:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}, UseTooltip = true},-- TP:Dalaran - Northrend
			[8] = {text = GetSpellInfo(88342),icon = MER:GetIconFromID("spell", 88342),secure = {buttonType = "spell",ID = 88342}, UseTooltip = true},-- TP:Tol Barad
			[9] = {text = GetSpellInfo(132621),icon = MER:GetIconFromID("spell", 132621),secure = {buttonType = "spell",ID = 132621}, UseTooltip = true},-- TP:Vale of Eternal Blossoms
			[10] = {text = GetSpellInfo(120145),icon = MER:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}, UseTooltip = true},-- TP:Ancient Dalaran
			[11] = {text = GetSpellInfo(176248),icon = MER:GetIconFromID("spell", 176248),secure = {buttonType = "spell",ID = 176248}, UseTooltip = true},-- TP:StormShield
			[12] = {text = GetSpellInfo(224869),icon = MER:GetIconFromID("spell", 224869),secure = {buttonType = "spell",ID = 224869}, UseTooltip = true},-- TP:Dalaran - BI
			[13] = {text = GetSpellInfo(281403),icon = MER:GetIconFromID("spell", 281403),secure = {buttonType = "spell",ID = 281403}, UseTooltip = true},-- TP:Boralus
		},
	},
	["portals"] = {
		["Horde"] = {
			[1] = {text = GetSpellInfo(11418),icon = MER:GetIconFromID("spell", 11418),secure = {buttonType = "spell",ID = 11418}, UseTooltip = true},-- P:Undercity
			[2] = {text = GetSpellInfo(11420),icon = MER:GetIconFromID("spell", 11420),secure = {buttonType = "spell",ID = 11420}, UseTooltip = true}, -- P:Thunder Bluff
			[3] = {text = GetSpellInfo(11417),icon = MER:GetIconFromID("spell", 11417),secure = {buttonType = "spell",ID = 11417}, UseTooltip = true},-- P:Orgrimmar
			[4] = {text = GetSpellInfo(32267),icon = MER:GetIconFromID("spell", 32267),secure = {buttonType = "spell",ID = 32267}, UseTooltip = true},-- P:Silvermoon
			[5] = {text = GetSpellInfo(49361),icon = MER:GetIconFromID("spell", 49361),secure = {buttonType = "spell",ID = 49361}, UseTooltip = true},-- P:Stonard
			[6] = {text = GetSpellInfo(35717),icon = MER:GetIconFromID("spell", 35717),secure = {buttonType = "spell",ID = 35717}, UseTooltip = true},-- P:Shattrath
			[7] = {text = GetSpellInfo(53142),icon = MER:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}, UseTooltip = true},-- P:Dalaran - Northred
			[8] = {text = GetSpellInfo(88346),icon = MER:GetIconFromID("spell", 88346),secure = {buttonType = "spell",ID = 88346}, UseTooltip = true},-- P:Tol Barad
			[9] = {text = GetSpellInfo(120146),icon = MER:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}, UseTooltip = true},-- P:Ancient Dalaran
			[10] = {text = GetSpellInfo(132626),icon = MER:GetIconFromID("spell", 132626),secure = {buttonType = "spell",ID = 132626}, UseTooltip = true},-- P:Vale of Eternal Blossoms
			[11] = {text = GetSpellInfo(176244),icon = MER:GetIconFromID("spell", 176244),secure = {buttonType = "spell",ID = 176244}, UseTooltip = true},-- P:Warspear
			[12] = {text = GetSpellInfo(224871),icon = MER:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}, UseTooltip = true},-- P:Dalaran - BI
			[13] = {text = GetSpellInfo(281402),icon = MER:GetIconFromID("spell", 281402),secure = {buttonType = "spell",ID = 281402}, UseTooltip = true},-- P:Dazar'alor
		},
		["Alliance"] = {
			[1] = {text = GetSpellInfo(10059),icon = MER:GetIconFromID("spell", 10059),secure = {buttonType = "spell",ID = 10059}, UseTooltip = true},-- P:Stormwind
			[2] = {text = GetSpellInfo(11416),icon = MER:GetIconFromID("spell", 11416),secure = {buttonType = "spell",ID = 11416}, UseTooltip = true},-- P:Ironforge
			[3] = {text = GetSpellInfo(11419),icon = MER:GetIconFromID("spell", 11419),secure = {buttonType = "spell",ID = 11419}, UseTooltip = true},-- P:Darnassus
			[4] = {text = GetSpellInfo(32266),icon = MER:GetIconFromID("spell", 32266),secure = {buttonType = "spell",ID = 32266}, UseTooltip = true},-- P:Exodar
			[5] = {text = GetSpellInfo(49360),icon = MER:GetIconFromID("spell", 49360),secure = {buttonType = "spell",ID = 49360}, UseTooltip = true},-- P:Theramore
			[6] = {text = GetSpellInfo(33691),icon = MER:GetIconFromID("spell", 33691),secure = {buttonType = "spell",ID = 33691}, UseTooltip = true},-- P:Shattrath
			[7] = {text = GetSpellInfo(53142),icon = MER:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}, UseTooltip = true},-- P:Dalaran - Northred
			[8] = {text = GetSpellInfo(88345),icon = MER:GetIconFromID("spell", 88345),secure = {buttonType = "spell",ID = 88345}, UseTooltip = true},-- P:Tol Barad
			[9] = {text = GetSpellInfo(120146),icon = MER:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}, UseTooltip = true},-- P:Ancient Dalaran
			[10] = {text = GetSpellInfo(132620),icon = MER:GetIconFromID("spell", 132620),secure = {buttonType = "spell",ID = 132620}, UseTooltip = true},-- P:Vale of Eternal Blossoms
			[11] = {text = GetSpellInfo(176246),icon = MER:GetIconFromID("spell", 176246),secure = {buttonType = "spell",ID = 176246}, UseTooltip = true},-- P:StormShield
			[12] = {text = GetSpellInfo(224871),icon = MER:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}, UseTooltip = true},-- P:Dalaran - BI
			[13] = {text = GetSpellInfo(281400),icon = MER:GetIconFromID("spell", 281400),secure = {buttonType = "spell",ID = 281400}, UseTooltip = true},-- P:Boralus
		},
	},
	["challenge"] = {
		[1] = {text = GetSpellInfo(131204),icon = MER:GetIconFromID("spell", 131204),secure = {buttonType = "spell",ID = 131204}, UseTooltip = true},-- Jade serpent
		[2] = {text = GetSpellInfo(131205),icon = MER:GetIconFromID("spell", 131205),secure = {buttonType = "spell",ID = 131205}, UseTooltip = true}, -- Brew
		[3] = {text = GetSpellInfo(131206),icon = MER:GetIconFromID("spell", 131206),secure = {buttonType = "spell",ID = 131206}, UseTooltip = true},-- Shado-pan
		[4] = {text = GetSpellInfo(131222),icon = MER:GetIconFromID("spell", 131222),secure = {buttonType = "spell",ID = 131222}, UseTooltip = true},-- Mogu
		[5] = {text = GetSpellInfo(131225),icon = MER:GetIconFromID("spell", 131225),secure = {buttonType = "spell",ID = 131225}, UseTooltip = true},-- Setting sun
		[6] = {text = GetSpellInfo(131231),icon = MER:GetIconFromID("spell", 131231),secure = {buttonType = "spell",ID = 131231}, UseTooltip = true},-- Scarlet blade
		[7] = {text = GetSpellInfo(131229),icon = MER:GetIconFromID("spell", 131229),secure = {buttonType = "spell",ID = 131229}, UseTooltip = true},-- scarlet mitre
		[8] = {text = GetSpellInfo(131232),icon = MER:GetIconFromID("spell", 131232),secure = {buttonType = "spell",ID = 131232}, UseTooltip = true},-- Scholo
		[9] = {text = GetSpellInfo(131228),icon = MER:GetIconFromID("spell", 131228),secure = {buttonType = "spell",ID = 131228}, UseTooltip = true},-- Black ox
		[10] = {text = GetSpellInfo(159895),icon = MER:GetIconFromID("spell", 159895),secure = {buttonType = "spell",ID = 159895}, UseTooltip = true},-- bloodmaul
		[11] = {text = GetSpellInfo(159902),icon = MER:GetIconFromID("spell", 159902),secure = {buttonType = "spell",ID = 159902}, UseTooltip = true},-- burning mountain
		[12] = {text = GetSpellInfo(159899),icon = MER:GetIconFromID("spell", 159899),secure = {buttonType = "spell",ID = 159899}, UseTooltip = true},-- crescent moon
		[13] = {text = GetSpellInfo(159900),icon = MER:GetIconFromID("spell", 159900),secure = {buttonType = "spell",ID = 159900}, UseTooltip = true},-- dark rail
		[14] = {text = GetSpellInfo(159896),icon = MER:GetIconFromID("spell", 159896),secure = {buttonType = "spell",ID = 159896}, UseTooltip = true},-- iron prow
		[15] = {text = GetSpellInfo(159898),icon = MER:GetIconFromID("spell", 159898),secure = {buttonType = "spell",ID = 159898}, UseTooltip = true},-- Skies
		[16] = {text = GetSpellInfo(159901),icon = MER:GetIconFromID("spell", 159901),secure = {buttonType = "spell",ID = 159901}, UseTooltip = true},-- Verdant
		[17] = {text = GetSpellInfo(159897),icon = MER:GetIconFromID("spell", 159897),secure = {buttonType = "spell",ID = 159897}, UseTooltip = true},-- Vigilant
	},
}

local function CreateCoords()
	if module.db.format == nil then return end

	local x, y = E.MapInfo.x or 0, E.MapInfo.y or 0
	if x then x = format(module.db.format, x * 100) else x = "0" end
	if y then y = format(module.db.format, y * 100) else y = "0" end

	return x, y
end

function module:CreateLocationPanel()
	--Main Panel
	loc_panel = CreateFrame('Frame', "MER_LocPanel", E.UIParent)
	loc_panel:SetPoint("TOP", E.UIParent, "TOP", 0, -1)
	loc_panel:SetFrameStrata("MEDIUM")
	loc_panel:SetFrameLevel(Minimap:GetFrameLevel()+1)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript("OnMouseUp", module.OnClick)
	loc_panel:SetScript("OnUpdate", module.UpdateCoords)

	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, "BACKGROUND")
	loc_panel.Text:SetPoint("CENTER", 0, 0)
	loc_panel.Text:SetWordWrap(false)
	E.FrameLocks[loc_panel] = true

	--Coords
	loc_panel.Xcoord = CreateFrame('Frame', "MER_LocPanel_X", loc_panel)
	loc_panel.Xcoord:SetPoint("RIGHT", loc_panel, "LEFT", 1 - 2*E.Spacing, 0)
	loc_panel.Xcoord.Text = loc_panel.Xcoord:CreateFontString(nil, "BACKGROUND")
	loc_panel.Xcoord.Text:Point("CENTER", 0, 0)

	loc_panel.Ycoord = CreateFrame('Frame', "MER_LocPanel_Y", loc_panel)
	loc_panel.Ycoord:SetPoint("LEFT", loc_panel, "RIGHT", -1 + 2*E.Spacing, 0)
	loc_panel.Ycoord.Text = loc_panel.Ycoord:CreateFontString(nil, "BACKGROUND")
	loc_panel.Ycoord.Text:Point("CENTER", 0, 0)

	module:Resize()

	-- Mover
	E:CreateMover(loc_panel, "MER_LocPanel_Mover", L["Location Panel"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, 'mui,modules,locPanel')

	module.Menu1 = CreateFrame("Frame", "MER_LocPanel_RightClickMenu1", E.UIParent)
	module.Menu1:SetTemplate("Transparent", true)
	module.Menu2 = CreateFrame("Frame", "MER_LocPanel_RightClickMenu2", E.UIParent)
	module.Menu2:SetTemplate("Transparent", true)
	DD:RegisterMenu(module.Menu1)
	DD:RegisterMenu(module.Menu2)
	module.Menu1:SetScript("OnHide", function() twipe(module.MainMenu) end)
	module.Menu2:SetScript("OnHide", function() twipe(module.SecondaryMenu) end)
end

function module:OnClick(btn)
	local zoneText = GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then
		if module.db.coordshide then return end
		if IsShiftKeyDown() and module.db.linkcoords then
			local edit_box = ChatEdit_ChooseBoxForSend()
			local x, y = CreateCoords()
			local message
			local coords = x..", "..y
				if zoneText ~= GetSubZoneText() then
					message = format("%s: %s (%s)", zoneText, GetSubZoneText(), coords)
				else
					message = format("%s (%s)", zoneText, coords)
				end
			ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message)
		else
			ToggleFrame(_G["WorldMapFrame"])
		end
	elseif btn == "RightButton" and module.db.portals.enable and not InCombatLockdown() then
		if module.ListBuilding then MER:Print(L["Info for some items is not available yet. Please try again later"]) return end
		module:PopulateDropdown(true)
	end
end

function module:UpdateCoords(elapsed)
	module.db = E.db.mui.locPanel

	module.elapsed = module.elapsed + elapsed
	if module.elapsed < (module.db.throttle or 0.2) then return end

	--Coords
	if E.MapInfo and module.db.coordshide ~= true then
		local x, y = E.MapInfo.x or nil, E.MapInfo.y or nil
		if x then x = format(module.db.format, x * 100) else x = "0" end
		if y then y = format(module.db.format, y * 100) else y = "0" end
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		loc_panel.Xcoord.Text:SetText(x)
		loc_panel.Ycoord.Text:SetText(y)
	else
		loc_panel.Xcoord.Text:SetText(" ")
		loc_panel.Ycoord.Text:SetText(" ")
	end

	--Coords coloring
	local colorC = {r = 1, g = 1, b = 1}
	if module.db.colorType_Coords == "REACTION" then
		local inInstance, _ = IsInInstance()
		if inInstance then
			colorC = {r = 1, g = 0.1,b =  0.1}
		else
			local pvpType = GetZonePVPInfo()
			colorC = module.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
		end
	elseif module.db.colorType_Coords == "CUSTOM" then
		colorC = module.db.customColor_Coords
	elseif module.db.colorType_Coords == "CLASS" then
		colorC = RAID_CLASS_COLORS[E.myclass]
	end
	loc_panel.Xcoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)
	loc_panel.Ycoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)

	--Location
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local displayLine
	if module.db.zoneText then
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end
	loc_panel.Text:SetText(displayLine)
	if module.db.autowidth then loc_panel:Width(loc_panel.Text:GetStringWidth() + 10) end

	--Location Colorings
	if displayLine ~= "" then
		local color = {r = 1, g = 1, b = 1}
		if module.db.colorType == "REACTION" then
			local inInstance, _ = IsInInstance()
			if inInstance then
				color = {r = 1, g = 0.1,b =  0.1}
			else
				local pvpType = GetZonePVPInfo()
				color = module.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
			end
		elseif module.db.colorType == "CUSTOM" then
			color = module.db.customColor
		elseif module.db.colorType == "CLASS" then
			color = RAID_CLASS_COLORS[E.myclass]
		end
		loc_panel.Text:SetTextColor(color.r, color.g, color.b)
	end

	module.elapsed = 0
end

function module:ToggleCoords()
	if module.db.coordshide then
		loc_panel.Xcoord:SetAlpha(0)
		loc_panel.Ycoord:SetAlpha(0)
	else
		loc_panel.Xcoord:SetAlpha(1)
		loc_panel.Ycoord:SetAlpha(1)
	end
end

function module:Resize()
	if module.db.autowidth then
		loc_panel:Size(loc_panel.Text:GetStringWidth() + 10, module.db.height)
	else
		loc_panel:Size(module.db.width, module.db.height)
	end
	loc_panel.Text:Width(module.db.width - 18)
	loc_panel.Xcoord:Size(module.db.fontSize * 3, module.db.height)
	loc_panel.Ycoord:Size(module.db.fontSize * 3, module.db.height)
end

function module:Fonts()
	loc_panel.Text:FontTemplate(E.LSM:Fetch('font', module.db.font), module.db.fontSize, module.db.fontOutline)
	loc_panel.Xcoord.Text:FontTemplate(E.LSM:Fetch('font', module.db.font), module.db.fontSize, module.db.fontOutline)
	loc_panel.Ycoord.Text:FontTemplate(E.LSM:Fetch('font', module.db.font), module.db.fontSize, module.db.fontOutline)
end

function module:Template()
	loc_panel:SetTemplate(module.db.template)
	loc_panel.Xcoord:SetTemplate(module.db.template)
	loc_panel.Ycoord:SetTemplate(module.db.template)
end

function module:Toggle()
	if module.db.enable then
		loc_panel:Show()
		E:EnableMover(loc_panel.mover:GetName())

		if module.db.combathide then
			RegisterStateDriver(loc_panel, 'visibility', '[combat] hide;show')
		end
	else
		loc_panel:Hide()
		E:DisableMover(loc_panel.mover:GetName())
		UnregisterStateDriver(loc_panel, 'visibility')
	end
	module:UNIT_AURA(nil, "player")
end

function module:PopulateItems()
	local noItem = false

	for index, data in pairs(module.Hearthstones) do
		if select(2, GetItemInfo(data[1])) == nil then noItem = true end
	end
	for index, data in pairs(module.PortItems) do
		if select(2, GetItemInfo(data[1])) == nil then noItem = true end
	end
	for index, data in pairs(module.EngineerItems) do
		if select(2, GetItemInfo(data[1])) == nil then noItem = true end
	end

	if noItem then
		module.ListBuilding = true
		E:Delay(2, module.PopulateItems)
	else
		module.ListBuilding = false
		for index, data in pairs(module.Hearthstones) do
			local id, name, toy = data[1], data[2], data[3]
			module.Hearthstones[index] = {text = name or GetItemInfo(id), icon = MER:GetIconFromID("item", id),secure = {buttonType = "item",ID = id, isToy = toy}, UseTooltip = true,}
		end
		for index, data in pairs(module.PortItems) do
			local id, name, toy = data[1], data[2], data[3]
			module.PortItems[index] = {text = name or GetItemInfo(id), icon = MER:GetIconFromID("item", id),secure = {buttonType = "item",ID = id, isToy = toy}, UseTooltip = true,}
		end
		for index, data in pairs(module.EngineerItems) do
			local id, name, toy = data[1], data[2], data[3]
			module.EngineerItems[index] = {text = name or GetItemInfo(id), icon = MER:GetIconFromID("item", id),secure = {buttonType = "item",ID = id, isToy = toy}, UseTooltip = true,}
		end
	end
end

function module:ItemList(check)
	if module.db.portals.HSplace then tinsert(module.MainMenu, {text = L["Hearthstone Location"]..": "..GetBindLocation(), title = true, nohighlight = true}) end
	tinsert(module.MainMenu, {text = ITEMS..":", title = true, nohighlight = true})

	if module.db.portals.showHearthstones then
		local priority = 100
		local ShownHearthstone
		local tmp = {}
		local hsPrio = {split(",", E.db.mui.locPanel.portals.hsPrio)}
		local hsReamodulerio = {}
		for key = 1, #hsPrio do
			hsReamodulerio[hsPrio[key]] = key
		end

		for i = 1, #module.Hearthstones do
			local data = module.Hearthstones[i]
			local ID, isToy = data.secure.ID, data.secure.isToy
			isToy = (module.db.portals.showToys and isToy)
			if not module.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
			if (not isToy and (MER:BagSearch(ID) and IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID))) then
				if data.text then
					if not isToy then
						ShownHearthstone = data
						-- break
					else
						local curPriorirty = hsReamodulerio[tostring(ID)]
						if curPriorirty < priority then
							priority = curPriorirty
							ShownHearthstone = data
						end
						if priority == 1 then break end
					end
				end
			end
		end

		local data = ShownHearthstone
		local ID, isToy = data.secure.ID, data.secure.isToy
		local cd = DD:GetCooldown("Item", ID)
		E:CopyTable(tmp, data)

		if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
			tmp.text = "|cff636363"..tmp.text.."|r"..format(module.CDformats[module.db.portals.cdFormat], cd)
			tinsert(module.MainMenu, tmp)
		else
			tinsert(module.MainMenu, data)
		end
	end

	for i = 1, #module.PortItems do
		local tmp = {}
		local data = module.PortItems[i]
		local ID, isToy = data.secure.ID, data.secure.isToy
		isToy = (module.db.portals.showToys and isToy)
		if not module.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
		if ((not isToy and (MER:BagSearch(ID) and IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID)))) then
			if data.text then
				local cd = DD:GetCooldown("Item", ID)
				E:CopyTable(tmp, data)
				if cd or (tonumber(cd) and tonumber(cd) > 2) then
					tmp.text = "|cff636363"..tmp.text.."|r"..format(module.CDformats[module.db.portals.cdFormat], cd)
					tinsert(module.MainMenu, tmp)
				else
					tinsert(module.MainMenu, data)
				end
			end
		end
	end

	if module.db.portals.showEngineer and module.isEngineer then
		tinsert(module.MainMenu, {text = module.EngineerName..":", title = true, nohighlight = true})
		for i = 1, #module.EngineerItems do
			local tmp = {}
			local data = module.EngineerItems[i]
			local ID, isToy = data.secure.ID, data.secure.isToy
			if not module.db.portals.ignoreMissingInfo and ((isToy and PlayerHasToy(ID)) and C_ToyBox.IsToyUsable(ID) == nil) then return false end
			if (not isToy and (MER:BagSearch(ID) and IsUsableItem(ID))) or (isToy and (PlayerHasToy(ID) and C_ToyBox.IsToyUsable(ID))) then
				if data.text then
					local cd = DD:GetCooldown("Item", ID)
					E:CopyTable(tmp, data)
					if cd or (tonumber(cd) and tonumber(cd) > 2) then
						tmp.text = "|cff636363"..tmp.text.."|r"..format(module.CDformats[module.db.portals.cdFormat], cd)
						tinsert(module.MainMenu, tmp)
					else
						tinsert(module.MainMenu, data)
					end
				end
			end
		end
	end
	return true
end

function module:SpellList(list, dropdown, check)
	for i = 1, #list do
		local tmp = {}
		local data = list[i]
		if IsSpellKnown(data.secure.ID) then
			if check then
				return true
			else
				if data.text then
					local cd = DD:GetCooldown("Spell", data.secure.ID)
					if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
						E:CopyTable(tmp, data)
						tmp.text = "|cff636363"..tmp.text.."|r"..format(module.CDformats[module.db.portals.cdFormat], cd)
						tinsert(dropdown, tmp)
					else
						tinsert(dropdown, data)
					end
				end
			end
		end
	end
end

function module:PopulateDropdown(click)
	if module.ListUpdating and click then
		MER:Print(L["Update canceled."])
		module.ListUpdating = false
		if module.InfoUpdatingTimer then module:CancelTimer(module.InfoUpdatingTimer) end
		return
	end
	module.InfoUpdatingTimer = nil
	if module.Menu1:IsShown() then ToggleFrame(module.Menu1) return end
	if module.Menu2:IsShown() then ToggleFrame(module.Menu2) return end
	local full_list = module:ItemList()
	if not full_list then
		if not module.ListUpdating then MER:Print(L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."]); module.ListUpdating = true end
		if not module.InfoUpdatingTimer then module.InfoUpdatingTimer = module:ScheduleTimer(module.PopulateDropdown, 3) end
		twipe(module.MainMenu)
		return
	end
	if module.ListUpdating then module.ListUpdating = false; MER:Print(L["Update complete. Opening menu."]) end
	local anchor, point = GetDirection()
	local MENU_WIDTH

	if module.db.portals.showSpells then
		if module:SpellList(module.Spells[E.myclass], nil, true) or module:SpellList(module.Spells.challenge, nil, true) or E.myclass == "MAGE" or E.myrace == "DarkIronDwarf" then
			tinsert(module.MainMenu, {text = SPELLS..":", title = true, nohighlight = true})
			module:SpellList(module.Spells[E.myclass], module.MainMenu)
			if module:SpellList(module.Spells.challenge, nil, true) then
				tinsert(module.MainMenu, {text = CHALLENGE_MODE.." >>",icon = MER:GetIconFromID("achiev", 6378), func = function()
					twipe(module.SecondaryMenu)
					MENU_WIDTH = module.db.portals.customWidth and module.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
					tinsert(module.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(module.MainMenu); ToggleFrame(module.Menu2); module:PopulateDropdown() end})
					tinsert(module.SecondaryMenu, {text = CHALLENGE_MODE..":", title = true, nohighlight = true})
					module:SpellList(module.Spells.challenge, module.SecondaryMenu)
					tinsert(module.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(module.MainMenu); twipe(module.SecondaryMenu); ToggleFrame(module.Menu2) end})
					MER:DropDown(module.SecondaryMenu, module.Menu2, anchor, point, 0, 1, _G["MER_LocPanel"], MENU_WIDTH, module.db.portals.justify)
				end})
			end
			if E.myclass == "MAGE" then
				tinsert(module.MainMenu, {text = L["Teleports"].." >>", icon = MER:GetIconFromID("spell", 53140), func = function()
					twipe(module.SecondaryMenu)
					MENU_WIDTH = module.db.portals.customWidth and module.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
					tinsert(module.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(module.MainMenu); ToggleFrame(module.Menu2); module:PopulateDropdown() end})
					tinsert(module.SecondaryMenu, {text = L["Teleports"]..":", title = true, nohighlight = true})
					module:SpellList(module.Spells["teleports"][faction], module.SecondaryMenu)
					tinsert(module.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(module.MainMenu); twipe(module.SecondaryMenu); ToggleFrame(module.Menu2) end})
					MER:DropDown(module.SecondaryMenu, module.Menu2, anchor, point, 0, 1, _G["MER_LocPanel"], MENU_WIDTH, module.db.portals.justify)
				end})
				tinsert(module.MainMenu, {text = L["Portals"].." >>",icon = MER:GetIconFromID("spell", 53142), func = function()
					twipe(module.SecondaryMenu)
					MENU_WIDTH = module.db.portals.customWidth and module.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
					tinsert(module.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(module.MainMenu); ToggleFrame(module.Menu2); module:PopulateDropdown() end})
					tinsert(module.SecondaryMenu, {text = L["Portals"]..":", title = true, nohighlight = true})
					module:SpellList(module.Spells["portals"][faction], module.SecondaryMenu)
					tinsert(module.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(module.MainMenu); twipe(module.SecondaryMenu); ToggleFrame(module.Menu2) end})
					MER:DropDown(module.SecondaryMenu, module.Menu2, anchor, point, 0, 1, _G["MER_LocPanel"], MENU_WIDTH, module.db.portals.justify)
				end})
			end
			if E.myrace == "DarkIronDwarf" then
				module:SpellList(module.Spells[E.myrace], module.MainMenu)
			end
		end
	end
	tinsert(module.MainMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(module.MainMenu); twipe(module.SecondaryMenu); ToggleFrame(module.Menu1) end})
	MENU_WIDTH = module.db.portals.customWidth and module.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
	MER:DropDown(module.MainMenu, module.Menu1, anchor, point, 0, 1, _G["MER_LocPanel"], MENU_WIDTH, module.db.portals.justify)

	collectgarbage('collect');
end

function module:GetProf()
	module.EngineerName = MER:GetSpell(4036)
	module:CHAT_MSG_SKILL()
end

function module:CHAT_MSG_SKILL()
	local prof1, prof2 = GetProfessions()
	if prof1 then
		local name, _, _ = GetProfessionInfo(prof1)
		if name == module.EngineerName then module.isEngineer = true return end
	end
	if prof2 then
		local name, _, _ = GetProfessionInfo(prof2)
		if name == module.EngineerName then module.isEngineer = true return end
	end
end

function module:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	if module.db.enable and module.db.orderhallhide then
		local inOrderHall = C_GarrisonIsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		if inOrderHall then
			loc_panel:SetAlpha(0)
		else
			loc_panel:SetAlpha(1)
		end
	end
end

function module:Initialize()
	local db = E.db.mui.locPanel
	MER:RegisterDB(self, "locPanel")

	faction = UnitFactionGroup('player')

	self:PopulateItems()
	self:GetProf()

	module.elapsed = 0
	self:CreateLocationPanel()
	self:Resize()
	self:Template()
	self:Fonts()
	self:Toggle()
	self:ToggleCoords()

	function module:ForUpdateAll()
		local db = E.db.mui.locPanel
		self:Resize()
		self:Template()
		self:Fonts()
		self:Toggle()
		self:ToggleCoords()
	end

	self:ForUpdateAll()

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("CHAT_MSG_SKILL")
end

MER:RegisterModule(module:GetName())

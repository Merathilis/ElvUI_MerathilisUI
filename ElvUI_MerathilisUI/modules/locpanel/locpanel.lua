local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local M = E:GetModule('Minimap')
local DD = E:GetModule("Dropdown")
local LP = E:NewModule("LocPanel", "AceTimer-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0");

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local tinsert, twipe = table.insert, table.wipe
local select, unpack = select, unpack
-- WoW API / Variables
local GetBindLocation = GetBindLocation
local GetPlayerMapPosition = GetPlayerMapPosition
local GetItemInfo = GetItemInfo
local GetMinimapZoneText = GetMinimapZoneText
local GetScreenHeight = GetScreenHeight
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local GetZonePVPInfo = GetZonePVPInfo
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local IsInInstance = IsInInstance
local IsShiftKeyDown = IsShiftKeyDown
local IsSpellKnown = IsSpellKnown
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat
local UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK = UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK
local DUNGEON_FLOOR_DALARAN1 = DUNGEON_FLOOR_DALARAN1
local CHALLENGE_MODE = CHALLENGE_MODE
local PlayerHasToy = PlayerHasToy
local IsToyUsable = C_ToyBox.IsToyUsable
local UnitFactionGroup = UnitFactionGroup

--GLOBALS: HSplace

local loc_panel
local COORDS_WIDTH = 35 -- Coord panels width

local cluster = _G["MinimapCluster"]
local faction

LP.CDformats = {
	["DEFAULT"] = [[ (%s |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
	["DEFAULT_ICONFIRST"] = [[ (|TInterface\FriendsFrame\StatusIcon-Away:16|t %s)]],
}

LP.ReactionColors = {
	["sanctuary"] = {r = 0.41, g = 0.8, b = 0.94},
	["arena"] = {r = 1, g = 0.1, b = 0.1},
	["friendly"] = {r = 0.1, g = 1, b = 0.1},
	["hostile"] = {r = 1, g = 0.1, b = 0.1},
	["contested"] = {r = 1, g = 0.7, b = 0.10},
	["combat"] = {r = 1, g = 0.1, b = 0.1},
}

LP.MainMenu = {}
LP.SecondaryMenu = {}

local function GetDirection()
	local x, y = _G["MER_LocPanel"]:GetCenter()
	local screenHeight = GetScreenHeight()
	local anchor, point = "TOP", "BOTTOM"
	if y and y < (screenHeight / 2) then
		anchor = "BOTTOM"
		point = "TOP"
	end
	return anchor, point
end

--{ItemID, ButtonText, isToy}
LP.PortItems = {
	{6948}, --Hearthstone
	{64488, nil, true}, --The Innkeeper's Daughter
	{110560, GARRISON_LOCATION_TOOLTIP}, --Garrison Hearthstone
	{128353}, --Admiral's Compass
	{140192, DUNGEON_FLOOR_DALARAN1}, --Dalaran Hearthstone
	{37863}, --Grim Guzzler
	{52251}, --Jaina's Locket
	{48933, nil, true}, --Wormhole Generator: Northrend
	{87215, nil, true}, --Wormhole Generator: Pandaria
	{112059, nil, true}, --Wormhole Centrifuge
	{18986, nil, true}, --Ultrasafe Transporter: Gadgetzan
	{30544, nil, true}, --Ultrasafe Transporter: Toshley's Station
	{18984, nil, true}, --Dimensional Ripper - Everlook
	{30542, nil, true}, --Dimensional Ripper - Area 52
	{58487}, --Potion of Deepholm
	{43824, nil, true}, --The Schools of Arcane Magic - Mastery
	{64457}, --The Last Relic of Argus
	{128502}, --Hunter's Seeking Crystal
	{128503}, --Master Hunter's Seeking Crystal
}

LP.Spells = {
	["DEATHKNIGHT"] = {
		[1] = {text =  GetSpellInfo(50977),icon = MER:GetIconFromID("spell", 50977),secure = {buttonType = "spell",ID = 50977}},
	},
	["DEMONHUNTER"] = {},
	["DRUID"] = {
		[1] = {text =  GetSpellInfo(18960),icon = MER:GetIconFromID("spell", 18960),secure = {buttonType = "spell",ID = 18960}}, --Moonglade
		[2] = {text =  GetSpellInfo(147420),icon = MER:GetIconFromID("spell", 147420),secure = {buttonType = "spell",ID = 147420}}, --One With Nature
		[3] = {text =  GetSpellInfo(193753),icon = MER:GetIconFromID("spell", 193753),secure = {buttonType = "spell",ID = 193753}}, --Druid ClassHall
	},
	["HUNTER"] = {},
	["MAGE"] = {},
	["MONK"] = {
		[1] = {text =  GetSpellInfo(126892),icon = MER:GetIconFromID("spell", 126892),secure = {buttonType = "spell",ID = 126892}}, -- Zen Pilgrimage
		[2] = {text =  GetSpellInfo(126895),icon = MER:GetIconFromID("spell", 126895),secure = {buttonType = "spell",ID = 126895}}, -- Zen Pilgrimage: Return
	},
	["PALADIN"] = {},
	["PRIEST"] = {},
	["ROGUE"] = {},
	["SHAMAN"] = {
		[1] = {text =  GetSpellInfo(556),icon = MER:GetIconFromID("spell", 556),secure = {buttonType = "spell",ID = 556}},
	},
	["WARLOCK"] = {},
	["WARRIOR"] = {},
	["teleports"] = {
		["Horde"] = {
			[1] = {text = GetSpellInfo(3563),icon = MER:GetIconFromID("spell", 3563),secure = {buttonType = "spell",ID = 3563}}, -- TP:Undercity
			[2] = {text = GetSpellInfo(3566),icon = MER:GetIconFromID("spell", 3566),secure = {buttonType = "spell",ID = 3566}}, -- TP:Thunder Bluff
			[3] = {text = GetSpellInfo(3567),icon = MER:GetIconFromID("spell", 3567),secure = {buttonType = "spell",ID = 3567}}, -- TP:Orgrimmar
			[4] = {text = GetSpellInfo(32272),icon = MER:GetIconFromID("spell", 32272),secure = {buttonType = "spell",ID = 32272}}, -- TP:Silvermoon
			[5] = {text = GetSpellInfo(49358),icon = MER:GetIconFromID("spell", 49358),secure = {buttonType = "spell",ID = 49358}}, -- TP:Stonard
			[6] = {text = GetSpellInfo(35715),icon = MER:GetIconFromID("spell", 35715),secure = {buttonType = "spell",ID = 35715}}, -- TP:Shattrath
			[7] = {text = GetSpellInfo(53140),icon = MER:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}}, -- TP:Dalaran - Northrend
			[8] = {text = GetSpellInfo(88344),icon = MER:GetIconFromID("spell", 88344),secure = {buttonType = "spell",ID = 88344}}, -- TP:Tol Barad
			[9] = {text = GetSpellInfo(132627),icon = MER:GetIconFromID("spell", 132627),secure = {buttonType = "spell",ID = 132627}}, -- TP:Vale of Eternal Blossoms
			[10] = {text = GetSpellInfo(120145),icon = MER:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}}, -- TP:Ancient Dalaran
			[11] = {text = GetSpellInfo(176242),icon = MER:GetIconFromID("spell", 176242),secure = {buttonType = "spell",ID = 176242}}, -- TP:Warspear
			[12] = {text = GetSpellInfo(224873),icon = MER:GetIconFromID("spell", 224873),secure = {buttonType = "spell",ID = 224873}}, -- TP:Dalaran - BI
			[13] = {text =  GetSpellInfo(193759),icon = MER:GetIconFromID("spell", 193759),secure = {buttonType = "spell",ID = 193759}}, -- Mage Classhall
		},
		["Alliance"] = {
			[1] = {text = GetSpellInfo(3561),icon = MER:GetIconFromID("spell", 3561),secure = {buttonType = "spell",ID = 3561}},-- TP:Stormwind
			[2] = {text = GetSpellInfo(3562),icon = MER:GetIconFromID("spell", 3562),secure = {buttonType = "spell",ID = 3562}},-- TP:Ironforge
			[3] = {text = GetSpellInfo(3565),icon = MER:GetIconFromID("spell", 3565),secure = {buttonType = "spell",ID = 3565}},-- TP:Darnassus
			[4] = {text = GetSpellInfo(32271),icon = MER:GetIconFromID("spell", 32271),secure = {buttonType = "spell",ID = 32271}},-- TP:Exodar
			[5] = {text = GetSpellInfo(49359),icon = MER:GetIconFromID("spell", 49359),secure = {buttonType = "spell",ID = 49359}},-- TP:Theramore
			[6] = {text = GetSpellInfo(33690),icon = MER:GetIconFromID("spell", 33690),secure = {buttonType = "spell",ID = 33690}},-- TP:Shattrath
			[7] = {text = GetSpellInfo(53140),icon = MER:GetIconFromID("spell", 53140),secure = {buttonType = "spell",ID = 53140}},-- TP:Dalaran - Northrend
			[8] = {text = GetSpellInfo(88342),icon = MER:GetIconFromID("spell", 88342),secure = {buttonType = "spell",ID = 88342}},-- TP:Tol Barad
			[9] = {text = GetSpellInfo(132621),icon = MER:GetIconFromID("spell", 132621),secure = {buttonType = "spell",ID = 132621}},-- TP:Vale of Eternal Blossoms
			[10] = {text = GetSpellInfo(120145),icon = MER:GetIconFromID("spell", 120145),secure = {buttonType = "spell",ID = 120145}},-- TP:Ancient Dalaran
			[11] = {text = GetSpellInfo(176248),icon = MER:GetIconFromID("spell", 176248),secure = {buttonType = "spell",ID = 176248}},-- TP:StormShield
			[12] = {text = GetSpellInfo(224873),icon = MER:GetIconFromID("spell", 224873),secure = {buttonType = "spell",ID = 224873}},-- TP:Dalaran - BI
			[13] = {text = GetSpellInfo(193759),icon = MER:GetIconFromID("spell", 193759),secure = {buttonType = "spell",ID = 193759}}, -- Mage Classhall
		},
	},
	["portals"] = {
		["Horde"] = {
			[1] = {text = GetSpellInfo(11418),icon = MER:GetIconFromID("spell", 11418),secure = {buttonType = "spell",ID = 11418}},-- P:Undercity
			[2] = {text = GetSpellInfo(11420),icon = MER:GetIconFromID("spell", 11420),secure = {buttonType = "spell",ID = 11420}}, -- P:Thunder Bluff
			[3] = {text = GetSpellInfo(11417),icon = MER:GetIconFromID("spell", 11417),secure = {buttonType = "spell",ID = 11417}},-- P:Orgrimmar
			[4] = {text = GetSpellInfo(32267),icon = MER:GetIconFromID("spell", 32267),secure = {buttonType = "spell",ID = 32267}},-- P:Silvermoon
			[5] = {text = GetSpellInfo(49361),icon = MER:GetIconFromID("spell", 49361),secure = {buttonType = "spell",ID = 49361}},-- P:Stonard
			[6] = {text = GetSpellInfo(35717),icon = MER:GetIconFromID("spell", 35717),secure = {buttonType = "spell",ID = 35717}},-- P:Shattrath
			[7] = {text = GetSpellInfo(53142),icon = MER:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}},-- P:Dalaran - Northred
			[8] = {text = GetSpellInfo(88346),icon = MER:GetIconFromID("spell", 88346),secure = {buttonType = "spell",ID = 88346}},-- P:Tol Barad
			[9] = {text = GetSpellInfo(120146),icon = MER:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}},-- P:Ancient Dalaran
			[10] = {text = GetSpellInfo(132626),icon = MER:GetIconFromID("spell", 132626),secure = {buttonType = "spell",ID = 132626}},-- P:Vale of Eternal Blossoms
			[11] = {text = GetSpellInfo(176244),icon = MER:GetIconFromID("spell", 176244),secure = {buttonType = "spell",ID = 176244}},-- P:Warspear
			[12] = {text = GetSpellInfo(224871),icon = MER:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}},-- P:Dalaran - BI
		},
		["Alliance"] = {
			[1] = {text = GetSpellInfo(10059),icon = MER:GetIconFromID("spell", 10059),secure = {buttonType = "spell",ID = 10059}},-- P:Stormwind
			[2] = {text = GetSpellInfo(11416),icon = MER:GetIconFromID("spell", 11416),secure = {buttonType = "spell",ID = 11416}},-- P:Ironforge
			[3] = {text = GetSpellInfo(11419),icon = MER:GetIconFromID("spell", 11419),secure = {buttonType = "spell",ID = 11419}},-- P:Darnassus
			[4] = {text = GetSpellInfo(32266),icon = MER:GetIconFromID("spell", 32266),secure = {buttonType = "spell",ID = 32266}},-- P:Exodar
			[5] = {text = GetSpellInfo(49360),icon = MER:GetIconFromID("spell", 49360),secure = {buttonType = "spell",ID = 49360}},-- P:Theramore
			[6] = {text = GetSpellInfo(33691),icon = MER:GetIconFromID("spell", 33691),secure = {buttonType = "spell",ID = 33691}},-- P:Shattrath
			[7] = {text = GetSpellInfo(53142),icon = MER:GetIconFromID("spell", 53142),secure = {buttonType = "spell",ID = 53142}},-- P:Dalaran - Northred
			[8] = {text = GetSpellInfo(88345),icon = MER:GetIconFromID("spell", 88345),secure = {buttonType = "spell",ID = 88345}},-- P:Tol Barad
			[9] = {text = GetSpellInfo(120146),icon = MER:GetIconFromID("spell", 120146),secure = {buttonType = "spell",ID = 120146}},-- P:Ancient Dalaran
			[10] = {text = GetSpellInfo(132620),icon = MER:GetIconFromID("spell", 132620),secure = {buttonType = "spell",ID = 132620}},-- P:Vale of Eternal Blossoms
			[11] = {text = GetSpellInfo(176246),icon = MER:GetIconFromID("spell", 176246),secure = {buttonType = "spell",ID = 176246}},-- P:StormShield
			[12] = {text = GetSpellInfo(224871),icon = MER:GetIconFromID("spell", 224871),secure = {buttonType = "spell",ID = 224871}},-- P:Dalaran - BI
		},
	},
	["challenge"] = {
		[1] = {text = GetSpellInfo(131204),icon = MER:GetIconFromID("spell", 131204),secure = {buttonType = "spell",ID = 131204}},-- Jade serpent
		[2] = {text = GetSpellInfo(131205),icon = MER:GetIconFromID("spell", 131205),secure = {buttonType = "spell",ID = 131205}}, -- Brew
		[3] = {text = GetSpellInfo(131206),icon = MER:GetIconFromID("spell", 131206),secure = {buttonType = "spell",ID = 131206}},-- Shado-pan
		[4] = {text = GetSpellInfo(131222),icon = MER:GetIconFromID("spell", 131222),secure = {buttonType = "spell",ID = 131222}},-- Mogu
		[5] = {text = GetSpellInfo(131225),icon = MER:GetIconFromID("spell", 131225),secure = {buttonType = "spell",ID = 131225}},-- Setting sun
		[6] = {text = GetSpellInfo(131231),icon = MER:GetIconFromID("spell", 131231),secure = {buttonType = "spell",ID = 131231}},-- Scarlet blade
		[7] = {text = GetSpellInfo(131229),icon = MER:GetIconFromID("spell", 131229),secure = {buttonType = "spell",ID = 131229}},-- scarlet mitre
		[8] = {text = GetSpellInfo(131232),icon = MER:GetIconFromID("spell", 131232),secure = {buttonType = "spell",ID = 131232}},-- Scholo
		[9] = {text = GetSpellInfo(131228),icon = MER:GetIconFromID("spell", 131228),secure = {buttonType = "spell",ID = 131228}},-- Black ox
		[10] = {text = GetSpellInfo(159895),icon = MER:GetIconFromID("spell", 159895),secure = {buttonType = "spell",ID = 159895}},-- bloodmaul
		[11] = {text = GetSpellInfo(159902),icon = MER:GetIconFromID("spell", 159902),secure = {buttonType = "spell",ID = 159902}},-- burning mountain
		[12] = {text = GetSpellInfo(159899),icon = MER:GetIconFromID("spell", 159899),secure = {buttonType = "spell",ID = 159899}},-- crescent moon
		[13] = {text = GetSpellInfo(159900),icon = MER:GetIconFromID("spell", 159900),secure = {buttonType = "spell",ID = 159900}},-- dark rail
		[14] = {text = GetSpellInfo(159896),icon = MER:GetIconFromID("spell", 159896),secure = {buttonType = "spell",ID = 159896}},-- iron prow
		[15] = {text = GetSpellInfo(159898),icon = MER:GetIconFromID("spell", 159898),secure = {buttonType = "spell",ID = 159898}},-- Skies
		[16] = {text = GetSpellInfo(159901),icon = MER:GetIconFromID("spell", 159901),secure = {buttonType = "spell",ID = 159901}},-- Verdant
		[17] = {text = GetSpellInfo(159897),icon = MER:GetIconFromID("spell", 159897),secure = {buttonType = "spell",ID = 159897}},-- Vigilant
	},
}

local function CreateCoords()
	local x, y = GetPlayerMapPosition("player")
	x = format(LP.db.format, x * 100)
	y = format(LP.db.format, y * 100)
	
	return x, y
end

function LP:CreateLocationPanel()
	loc_panel = CreateFrame('Frame', "MER_LocPanel", E.UIParent)
	loc_panel:Point('TOP', E.UIParent, 'TOP', 0, -E.mult -4)
	loc_panel:SetFrameStrata('LOW')
	loc_panel:SetFrameLevel(2)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript('OnMouseUp', LP.OnClick)
	loc_panel:SetScript("OnUpdate", LP.UpdateCoords)
	MER:StyleSmall(loc_panel)

	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, "LOW")
	loc_panel.Text:Point("CENTER", 0, 0)
	loc_panel.Text:SetWordWrap(false)
	E.FrameLocks[loc_panel] = true

	--Coords
	loc_panel.Xcoord = CreateFrame('Frame', "MER_LocPanel_X", loc_panel)
	loc_panel.Xcoord:SetPoint("RIGHT", loc_panel, "LEFT", 1 - 2*E.Spacing, 0)
	MER:StyleSmall(loc_panel.Xcoord)
	loc_panel.Xcoord.Text = loc_panel.Xcoord:CreateFontString(nil, "LOW")
	loc_panel.Xcoord.Text:Point("CENTER", 0, 0)

	loc_panel.Ycoord = CreateFrame('Frame', "MER_LocPanel_Y", loc_panel)
	loc_panel.Ycoord:SetPoint("LEFT", loc_panel, "RIGHT", -1 + 2*E.Spacing, 0)
	MER:StyleSmall(loc_panel.Ycoord)
	loc_panel.Ycoord.Text = loc_panel.Ycoord:CreateFontString(nil, "LOW")
	loc_panel.Ycoord.Text:Point("CENTER", 0, 0)

	LP:Resize()
	-- Mover
	E:CreateMover(loc_panel, "MER_LocPanel_Mover", L["Location Panel"], nil, nil, "ALL, SOLO")

	LP.Menu1 = CreateFrame("Frame", "MER_LocPanel_RightClickMenu1", E.UIParent)
	LP.Menu1:SetTemplate("Transparent", true)
	LP.Menu2 = CreateFrame("Frame", "MER_LocPanel_RightClickMenu2", E.UIParent)
	LP.Menu2:SetTemplate("Transparent", true)
	DD:RegisterMenu(LP.Menu1)
	DD:RegisterMenu(LP.Menu2)
	LP.Menu1:SetScript("OnHide", function() twipe(LP.MainMenu) end)
	LP.Menu2:SetScript("OnHide", function() twipe(LP.SecondaryMenu) end)
end

function LP:OnClick(btn)
	local zoneText = GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then
		if IsShiftKeyDown() and LP.db.linkcoords then
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
	elseif btn == "RightButton" and LP.db.portals.enable then
		LP:PopulateDropdown()
	end
end

function LP:UpdateCoords(elapsed)
	LP.elapsed = LP.elapsed + elapsed
	if LP.elapsed < LP.db.throttle then return end
	--Coords
	local x, y = CreateCoords()
	if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
	if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
	loc_panel.Xcoord.Text:SetText(x)
	loc_panel.Ycoord.Text:SetText(y)
	--Location
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local displayLine
	if LP.db.zoneText then
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end
	loc_panel.Text:SetText(displayLine)
	if LP.db.autowidth then
		loc_panel:Width(loc_panel.Text:GetStringWidth() + 10)
	end

	--Location Colorings
	if displayLine ~= "" then
		local color = {r = 1, g = 1, b = 1}
		if LP.db.colorType == "REACTION" then
			local inInstance, _ = IsInInstance()
			if inInstance then
				color = {r = 1, g = 0.1,b =  0.1}
			else
				local pvpType = GetZonePVPInfo()
				color = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
			end
		elseif LP.db.colorType == "CUSTOM" then
			color = LP.db.customColor
		end
		loc_panel.Text:SetTextColor(color.r, color.g, color.b)
	end

	LP.elapsed = 0
end

function LP:Resize()
	if LP.db.autowidth then
		loc_panel:Size(loc_panel.Text:GetStringWidth() + 10, LP.db.height)
	else
		loc_panel:Size(LP.db.width, LP.db.height)
	end
	loc_panel.Text:Width(LP.db.width - 18)
	loc_panel.Xcoord:Size(LP.db.fontSize * 3, LP.db.height)
	loc_panel.Ycoord:Size(LP.db.fontSize * 3, LP.db.height)
end

function LP:Fonts()
	loc_panel.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Xcoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Ycoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
end

function LP:Template()
	loc_panel:SetTemplate(LP.db.template)
	loc_panel.Xcoord:SetTemplate(LP.db.template)
	loc_panel.Ycoord:SetTemplate(LP.db.template)
end

function LP:Toggle()
	if LP.db.enable then
		loc_panel:Show()
		E:EnableMover(loc_panel.mover:GetName())
	else
		loc_panel:Hide()
		E:DisableMover(loc_panel.mover:GetName())
	end
end

function LP:PopulateItems()
	local noItem = false
	if select(2, GetItemInfo(6948)) == nil then noItem = true end
	if noItem then
		E:Delay(2, LP.PopulateItems)
	else
		for i = 1, #LP.PortItems do
			local id, name, toy = unpack(LP.PortItems[i])
			LP.PortItems[i] = {text = name or GetItemInfo(id), icon = MER:GetIconFromID("item", id),secure = {buttonType = "item",ID = id, isToy = toy}, UseTooltip = true}
		end
	end
end

function LP:ItemList(check)
	for i = 1, #LP.PortItems do
		local data = LP.PortItems[i]
		if MER:BagSearch(data.secure.ID) or (PlayerHasToy(data.secure.ID) and IsToyUsable(data.secure.ID)) then
			if check then 
				tinsert(LP.MainMenu, {text = ITEMS..":", title = true, nohighlight = true})
				return true 
			else
				local tmp = {}
				local cd = DD:GetCooldown("Item", data.secure.ID)
				local HSplace = ""
				if LP.db.portals.HSplace and (data.secure.ID == 6948 or data.secure.ID == 64488) then
					HSplace = " - "..GetBindLocation()
				end
				E:CopyTable(tmp, data)
				if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
					tmp.text = "|cff636363"..tmp.text..HSplace.."|r"..format(LP.CDformats[LP.db.portals.cdFormat], cd)
				else
					tmp.text = tmp.text..HSplace
				end
				tinsert(LP.MainMenu, tmp)
			end
		end
	end
end

function LP:SpellList(list, dropdown, check)
	local tmp = {}
	for i = 1, #list do
		local data = list[i]
		if IsSpellKnown(data.secure.ID) then
			if check then 
				return true 
			else
				local cd = DD:GetCooldown("Spell", data.secure.ID)
				if cd or (tonumber(cd) and tonumber(cd) > 1.5) then
					E:CopyTable(tmp, data)
					tmp.text = tmp.text..format(LP.CDformats[LP.db.portals.cdFormat], cd)
					tinsert(dropdown, tmp)
				else
					tinsert(dropdown, data)
				end
			end
		end
	end
end

function LP:PopulateDropdown()
	if LP.Menu2:IsShown() then ToggleFrame(LP.Menu2) end
	if #LP.MainMenu > 0 then
		MER:DropDown(LP.MainMenu, LP.Menu1)
		return
	end
	local anchor, point = GetDirection()
	local MENU_WIDTH
	if LP:ItemList(true) then
		LP:ItemList() 
	end

	if LP:SpellList(LP.Spells[E.myclass], nil, true) or LP:SpellList(LP.Spells.challenge, nil, true) or E.myclass == "MAGE" then
		tinsert(LP.MainMenu, {text = SPELLS..":", title = true, nohighlight = true})
		LP:SpellList(LP.Spells[E.myclass], LP.MainMenu)
		if LP:SpellList(LP.Spells.challenge, nil, true) then
			tinsert(LP.MainMenu, {text = CHALLENGE_MODE.." >>",icon = MER:GetIconFromID("achiev", 6378), func = function() 
				twipe(LP.SecondaryMenu)
				MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
				tinsert(LP.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(LP.MainMenu); LP:PopulateDropdown() end})
				tinsert(LP.SecondaryMenu, {text = CHALLENGE_MODE..":", title = true, nohighlight = true})
				LP:SpellList(LP.Spells.challenge, LP.SecondaryMenu)
				tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(LP.MainMenu); twipe(LP.SecondaryMenu); ToggleFrame(LP.Menu2) end})
				MER:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 0, _G["MER_LocPanel"], MENU_WIDTH, LP.db.portals.justify)
			end})
		end
		if E.myclass == "MAGE" then
			tinsert(LP.MainMenu, {text = L["Teleports"].." >>", icon = MER:GetIconFromID("spell", 53140), func = function() 
				twipe(LP.SecondaryMenu)
				MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
				tinsert(LP.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(LP.MainMenu); LP:PopulateDropdown() end})
				tinsert(LP.SecondaryMenu, {text = L["Teleports"]..":", title = true, nohighlight = true})
				LP:SpellList(LP.Spells["teleports"][faction], LP.SecondaryMenu)
				tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() ToggleFrame(LP.Menu2) end})
				MER:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 0, _G["MER_LocPanel"], MENU_WIDTH, LP.db.portals.justify)
			end})
			tinsert(LP.MainMenu, {text = L["Portals"].." >>",icon = MER:GetIconFromID("spell", 53142), func = function() 
				twipe(LP.SecondaryMenu)
				MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
				tinsert(LP.SecondaryMenu, {text = "<< "..BACK, func = function() twipe(LP.MainMenu); LP:PopulateDropdown() end})
				tinsert(LP.SecondaryMenu, {text = L["Portals"]..":", title = true, nohighlight = true})
				LP:SpellList(LP.Spells["portals"][faction], LP.SecondaryMenu)
				tinsert(LP.SecondaryMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(LP.MainMenu); twipe(LP.SecondaryMenu); ToggleFrame(LP.Menu2) end})
				MER:DropDown(LP.SecondaryMenu, LP.Menu2, anchor, point, 0, 0, _G["MER_LocPanel"], MENU_WIDTH, LP.db.portals.justify)
			end})
		end
	end
	tinsert(LP.MainMenu, {text = CLOSE, title = true, ending = true, func = function() twipe(LP.MainMenu); twipe(LP.SecondaryMenu); ToggleFrame(LP.Menu1) end})
	MENU_WIDTH = LP.db.portals.customWidth and LP.db.portals.customWidthValue or _G["MER_LocPanel"]:GetWidth()
	MER:DropDown(LP.MainMenu, LP.Menu1, anchor, point, 0, 1, _G["MER_LocPanel"], MENU_WIDTH, LP.db.portals.justify)
end

function LP:PLAYER_REGEN_DISABLED()
	if LP.db.combathide then
		loc_panel:Hide()
	end
end

function LP:PLAYER_REGEN_ENABLED()
	if LP.db.enable then
		loc_panel:Show()
	end
end

function LP:Initialize()
	LP.db = E.db.mui.locPanel

	faction = UnitFactionGroup('player')
	LP:PopulateItems()

	LP.elapsed = 0
	LP:CreateLocationPanel()
	LP:Template()
	LP:Fonts()
	LP:Toggle()
	function LP:ForUpdateAll()
		LP.db = E.db.mui.locPanel
		LP:Resize()
		LP:Template()
		LP:Fonts()
		LP:Toggle()
	end

	LP:RegisterEvent("PLAYER_REGEN_DISABLED")
	LP:RegisterEvent("PLAYER_REGEN_ENABLED")
end

E:RegisterModule(LP:GetName())
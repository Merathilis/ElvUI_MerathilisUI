local MER, E, L, V, P, G = unpack(select(2, ...))
local LM = E:NewModule("LootMon", "AceHook-3.0", "AceEvent-3.0")
LM.modName = L["Loot Monitor"]

-- Cache global variables
-- Lua functions
local _G = _G
local select, tonumber, unpack = select, tonumber, unpack
local find, gsub, match = string.find, string.gsub, string.match
local ceil = math.ceil
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetNumGroupMembers = GetNumGroupMembers
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UnitClass = UnitClass
local UnitName = UnitName
local UnitInRaid = UnitInRaid
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: 

local LM = CreateFrame("Frame", "LootMon")
LM:SetScript("OnEvent", function(self, event, arg1)
	self[event](self, event, arg1)
end)
LM:RegisterEvent("CHAT_MSG_LOOT")
LM:RegisterEvent("CHAT_MSG_MONEY")
local deformat = LibStub("LibDeformat-3.0")
LM.items = {}
LM.id = 0
local items, id = LM.items, LM.id

local lootMon_db = {}
local config

lootMon_db = {
	selfRarity = 1, --0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
	Rarity = 3,
	position = {
		Xoff = 5,
		Yoff = 150,
		Anchor = "UIParent",
		AnchorPoint = "LEFT",
		nextFrameOff = 25,
	},
	scale = 1.0,
	maxItems = 10,
	timers = {
		fadeIn = 1, -- time to show item
		fadeOut = 1, -- time to hide item
		fade = 5, --how long item is shown
	},
}

local backdrop = {
	bgFile =  E["media"].blankTex,
	tile = false, tileSize = 0,
	insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult},
}

local gradientOn = {"VERTICAL", .1, .1, .1, 0, .25, .25, .25, 1}
local gradientOff = {"VERTICAL", 0, 0, 0, 1, 0, 0, 0, 1}

local sdb = {
	BackdropBorder = {r = 0.5, g = 0.5, b = 0.5, a = 1},
	Backdrop = {r = 0, g = 0, b = 0, a = 0.5},
	FadeHeight = {enable = false, value = 500, force = false},
	Gradient = false,
}

local function CreateTimer(duration, step, id)
	if(not duration or duration <= 0) then
		return
	end

	if(not step or step <= 0) then 
		return
	end

	local timer
	if not timer then
		timer = CreateFrame('Frame')
	end

	timer.duration = duration
	timer.step = step

	timer.timeleft = duration
	timer.nextUpdate = 0

	timer:SetScript('OnUpdate', function(self, elapsed)
		if(timer.timeleft <= 0) then
			timer:SetScript('OnUpdate',nil)
			if(id) then
				UIFrameFadeIn(items[id], config.timers.fadeOut, 1, 0)
				items[id].fadeInfo.finishedFunc = function()
					items[id]:Hide()
					items[id].isshown = false
				end
			end;
		end

		if(timer.nextUpdate <= 0) then
			timer.nextUpdate = timer.nextUpdate - elapsed
			timer.timeleft = timer.timeleft - elapsed
		end
	end)

	return timer
end

local function unitFromPlayerName(name)
	name = gsub(name, "(-.*)", "")

	if UnitName("player") == name then
		return "player"
	end

	if UnitInRaid("player") then
		for i = 1,GetNumGroupMembers() do
			if(UnitName("raid"..i) == name) then
				return "raid"..i
			end
		end
	else
		for i = 1,GetNumGroupMembers()-1 do
			if(UnitName("party"..i) == name) then
				return "party"..i
			end
		end
	end

	return nil
end

function reSize(frame)
	local row = frame
	local playerw, lootw = row.player:GetWidth(), row.loot:GetWidth()
	local framewidth = (playerw > 0 and playerw+37 or -11)+lootw
	row:SetWidth(framewidth+8)
end

function FindFreeID()
	local i = 1
	for i = 1, config.maxItems do
		if not items[i].isshown then 
			return i
		end
	end
	return false
end

function QColor(row, quality)
	local r, g, b, hex = GetItemQualityColor(quality)
	row.border:SetVertexColor(r, g, b, .3)
	row.border:Show()
	row:SetBackdropBorderColor(r, g, b, 1)
end

function CreateItem(type, ItemID, unit, icount, skip)
	local count, iName, iLink, iRarity, r, g, b, hex, iTexture
	local id = FindFreeID()
	if not id then debug("There is no free id") return end
	count = 0
	item = items[id]

	if type == "loot" then
		iName, iLink, iRarity, _, _, _, _, _, _, iTexture, _ = GetItemInfo(ItemID) 
		r, g, b, hex = GetItemQualityColor(iRarity)

		if unit == UnitName("player") then
			count = GetItemCount(ItemID) or 0
			local total
			if skip then total = 0 else total = count + icount end
			if total > 1 then item.extra:SetText(total) else item.extra:SetText("") end
		else
			item.extra:SetText("")
		end
	elseif type == "money" then
		iName = ItemID
		iLink = nil
		iRarity = 1
		iTexture = "Interface\\MoneyFrame\\UI-GoldIcon"
		hex = " "
		item.extra:SetText("")
	end

	item.link = iLink
	unit_id = unitFromPlayerName(unit)

	local classTextColor
	if unit_id then
		local _, class = UnitClass(unit_id)
		classTextColor = RAID_CLASS_COLORS[class]
	end

	if unit then
		item.player:SetText(unit)
		if classTextColor then item.player:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b) end
	else
		item.player:SetText("Unknown")
	end

	if icount and tonumber(icount) > 1 then
		iName = icount.."x ".."|c"..hex..iName.."|r"
	else 
		if type ~= "money" then
			iName = "|c"..hex..iName.."|r"
		end
	end
	item.loot:SetText(iName)

	SetItemButtonTexture(item.button, iTexture)

	reSize(item)
	item:ClearAllPoints()
	if id > 0 then
		if items[id-1]  then
			item:SetPoint("LEFT", items[id-1], "LEFT", 0, -config.position.nextFrameOff)
		else
			if config.position.AnchorPoint == "LEFT" then
				item:SetPoint("LEFT", config.position.Anchor, "LEFT", config.position.Xoff, config.position.Yoff)
			else
				item:SetPoint("RIGHT", config.position.Anchor, "RIGHT", -config.position.Xoff, config.position.Yoff)
			end
		end
	end

	item:SetScale(config.scale)
	items[id] = item
	items[id].isshown = true

	UIFrameFadeIn(item, config.timers.fadeIn, 0, 1)
	CreateTimer(config.timers.fade, 1, id)
end

function OnItemClick(button, item)
	if button == "LeftButton" and item.link then
		if ( IsControlKeyDown() ) then
			DressUpItemLink(item.link)
		elseif ( IsShiftKeyDown() ) then
			ChatEdit_InsertLink(item.link)
		else
			ShowUIPanel(ItemRefTooltip)
			if not ItemRefTooltip:IsVisible() then
				ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
			end
			ItemRefTooltip:SetHyperlink(item.link)
		end
	end
end

function BuildItem(id)
	local row = CreateFrame("Frame", "LM"..id, UIParent)
	local button = CreateFrame("Button", "LMButton"..id, row, "ItemButtonTemplate")
	button:EnableMouse(false)
	_G[button:GetName().."NormalTexture"]:SetWidth(66)
	_G[button:GetName().."NormalTexture"]:SetHeight(66)

	local overlay = CreateFrame("Button", "LMOverlay"..id, row)
	row.overlay = overlay

	row.player = row:CreateFontString("LM"..id.."Player", "ARTWORK", "GameFontNormalSmall")
	row.loot = row:CreateFontString("LM"..id.."Loot", "ARTWORK", "GameFontNormalSmall")
	row.extra = row:CreateFontString("LM"..id.."Extra", "ARTWORK", "GameFontNormalSmall")

	row:SetWidth(316)
	row:SetHeight(22)

	button:SetScale(0.55)
	button:ClearAllPoints()
	button:SetPoint("LEFT", row, "LEFT", 5, 0)
	button:Disable()

	overlay:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	overlay:SetScript("OnEnter", function(self)
		if row.link then
			GameTooltip:SetOwner(row, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink(row.link)
			if IsShiftKeyDown() then
				GameTooltip_ShowCompareItem()
			end
			CursorUpdate(self);
		end
	end)
	overlay:SetScript("OnLeave", function() GameTooltip:Hide(); ResetCursor(); end)
	overlay:SetScript("OnClick", function(self,arg1) OnItemClick(arg1, row) end)
	overlay:SetScript("OnUpdate", function(self) 
		if IsShiftKeyDown() then
			GameTooltip_ShowCompareItem()
		end
		CursorOnUpdate(self);
	end)

	overlay:ClearAllPoints()
	overlay:SetAllPoints(row)

	row.player:SetHeight(16)
	row.loot:SetHeight(16)
	row.extra:SetHeight(16)

	row.player:ClearAllPoints()
	row.loot:ClearAllPoints()
	row.extra:ClearAllPoints()

	row.player:SetPoint("LEFT", button, "RIGHT", 3, 0)
	row.loot:SetPoint("LEFT", row.player, "RIGHT", 10, 0)
	row.extra:SetPoint("LEFT", row, "RIGHT", 2, 0)

	row.player:SetJustifyH("LEFT")
	row.loot:SetJustifyH("LEFT")
	row.extra:SetJustifyH("LEFT")

	button.wrapper = ItemWrapper(button, 9, 9, 20)

	button:Show()
	button:SetAlpha(1)

	Skin(row)

	row.button = button
	row.id = id

	row:Hide()

	return row
end

function ItemWrapper(button, w, h, edge, b_inset)
	local wrapper = button.wrapper or CreateFrame("Frame", button:GetName().."Wrapper", button)
	wrapper:SetWidth(button:GetWidth()+(w or 10))
	wrapper:SetHeight(button:GetHeight()+(h or 10))
	wrapper:ClearAllPoints()
	wrapper:SetPoint("CENTER", button, "CENTER")
	Skin(wrapper)
	if edge then
		local backdrop = wrapper:GetBackdrop()
		backdrop.edgesize = edge
		wrapper:SetBackdrop(backdrop)
	end

	wrapper:SetBackdropColor(1, 1, 1, 0)
	wrapper:SetBackdropBorderColor(.7, .7, .7, 1)
	wrapper:Show()
	return wrapper
end

function Skin(frame)
	if not frame then return end

	frame:SetBackdrop(backdrop)
	frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	frame:SetBackdropColor(unpack(E["media"].backdropfadecolor))

	if not frame.fade then 
		frame.fade = frame:CreateTexture(nil, "BORDER")
	end
	frame.fade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

	if sdb.FadeHeight.enable and sdb.FadeHeight.force then
		fh = sdb.FadeHeight.value <= ceil(frame:GetHeight()) and sdb.FadeHeight.value
	end

	frame.fade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)

	if fh then
		frame.fade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -fh)
	else
		frame.fade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	end

	frame.fade:SetBlendMode("ADD")
	frame.fade:SetGradientAlpha(unpack(sdb.Gradient and gradientOn or gradientOff))
end

local LOOT_ITEM_SELF_REG = string.gsub(LOOT_ITEM_SELF, " %%s.", "")
local LOOT_ITEM_REG = string.gsub(LOOT_ITEM, "%%s ", "")
local LOOT_ITEM_REG = string.gsub(LOOT_ITEM_REG, " %%s.", "")
local LOOT_ITEM_CREATED_REG = string.gsub(LOOT_ITEM_CREATED_SELF, " %%s.", "")
local LOOT_ITEM_PUSHED_REG = string.gsub(LOOT_ITEM_PUSHED_SELF, " %%s.", "")

function LM:CHAT_MSG_LOOT(event, msg)
	if E.db.mui.lootMon.enable ~= true then return end

	local skipTotal = false
	local sPlayer, sLink, itemId, iCount = nil, nil, nil, nil

	if find(msg, LOOT_ITEM_SELF_REG) then
		sLink, iCount = deformat(msg, LOOT_ITEM_SELF_MULTIPLE)
		sPlayer = UnitName("player")
		if sLink then
			itemId=select(3, find(sLink, "item:(%d+):"))
		else
			sLink = deformat(msg, LOOT_ITEM_SELF) 
			itemId = select(3, find(sLink, "item:(%d+):"))
			iCount = 1
		end
	elseif find(msg, LOOT_ITEM_REG) then
		sPlayer, sLink, iCount = deformat(msg, LOOT_ITEM_MULTIPLE) 
		if sLink then
			itemId = select(3, find(sLink, "item:(%d+):"))
		else
			sPlayer, sLink = deformat(msg, LOOT_ITEM) 
			itemId = select(3, find(sLink, "item:(%d+):"))
			iCount = 1
		end
	elseif find(msg, LOOT_ITEM_CREATED_REG) then
		skipTotal = true
		sLink, iCount = deformat(msg, LOOT_ITEM_CREATED_SELF_MULTIPLE)
		sPlayer = UnitName("player")
		if sLink then
			itemId = select(3, find(sLink, "item:(%d+):"))
		else
			sLink = deformat(msg, LOOT_ITEM_CREATED_SELF)
			itemId = select(3, find(sLink, "item:(%d+):"))
			iCount = 1
		end
	elseif find(msg, LOOT_ITEM_PUSHED_REG) then
		skipTotal = true
		sLink, iCount = deformat(msg, LOOT_ITEM_PUSHED_SELF_MULTIPLE)
		sPlayer = UnitName("player")
		if sLink then
			itemId = select(3, find(sLink, "item:(%d+):"))
		else
			sLink = deformat(msg, LOOT_ITEM_PUSHED_SELF)
			itemId = select(3, find(sLink, "item:(%d+):"))
			iCount = 1
		end
	end

	if sPlayer and itemId then
		local Rarity = select(3, GetItemInfo(itemId))
		if (Rarity < config.Rarity and sPlayer ~= UnitName("player")) or (Rarity < config.selfRarity and sPlayer == UnitName("player")) then
		else
			CreateItem("loot", itemId, sPlayer, iCount, skipTotal)
		end
	end
end

local GOLD_REG = "(%d+) "..gsub(GOLD_AMOUNT, "%%d ", "")
local SILVER_REG = "(%d+) "..gsub(SILVER_AMOUNT, "%%d ", "")
local COPPER_REG = "(%d+) "..gsub(COPPER_AMOUNT, "%%d ", "")

function LM:CHAT_MSG_MONEY(event, msg)
	if E.db.mui.lootMon.enable ~= true then return end

	local gold = match(msg, GOLD_REG)
	local silver = match(msg, SILVER_REG)
	local copper = match(msg, COPPER_REG)
	local amount = "|cffffffff"..(gold or 0).."|rg ".."|cffffffff"..(silver or 0).."|rs ".."|cffffffff"..(copper or 0).."|rc"
	CreateItem("money", amount, " ", 0, false)
end

function LM:Initalize()
	if E.db.mui.lootMon.enable ~= true then return end

	config = E.db.mui.lootMon
	if not MERData["lootMon"] then
		MERData["lootMon"] = lootMon_db
	end
	for i = 1, lootMon_db.maxItems do
		if not items[i] then
			items[i] = BuildItem(i)
			items[i].isShown = false
		end
	end
end

local function InitializeCallback()
	LM:Initalize()
end

E:RegisterModule(LM:GetName(), InitializeCallback)
local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule('MER_Corruption', 'AceHook-3.0')
local I, F

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, pairs, tonumber, tostring = ipairs, pairs, tonumber, tostring
local find, match, strsplit, strsub = string.find, string.match, strsplit, strsub
local tsort = table.sort
-- WoW API / Variables
local C_Timer_After = C_Timer.After
local CreateFrame = CreateFrame
local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemStats = GetItemStats
local GetLocale = GetLocale
local GetSpellInfo = GetSpellInfo
local IsAddOnLoaded = IsAddOnLoaded
local IsCorruptedItem = IsCorruptedItem
local Item = Item

module.slotNames = {
	"HeadSlot", -- [1]
	"NeckSlot", -- [2]
	"ShoulderSlot", -- [3]
	"ShirtSlot", -- [4]
	"ChestSlot", -- [5]
	"WaistSlot", -- [6]
	"LegsSlot", -- [7]
	"FeetSlot", -- [8]
	"WristSlot", -- [9]
	"HandsSlot", -- [10]
	"Finger0Slot", -- [11]
	"Finger1Slot", -- [12]
	"Trinket0Slot", -- [13]
	"Trinket1Slot", -- [14]
	"BackSlot", -- [15]
	"MainHandSlot", -- [16]
	"SecondaryHandSlot", -- [17]
	"TabardSlot",
	"AmmoSlot"
}

module.Ranks = {
	["6483"] = {"Avoidant", "I", 315607},
	["6484"] = {"Avoidant", "II", 315608},
	["6485"] = {"Avoidant", "III", 315609},
	["6474"] = {"Expedient", "I", 315544},
	["6475"] = {"Expedient", "II", 315545},
	["6476"] = {"Expedient", "III", 315546},
	["6471"] = {"Masterful", "I", 315529},
	["6472"] = {"Masterful", "II", 315530},
	["6473"] = {"Masterful", "III", 315531},
	["6480"] = {"Severe", "I", 315554},
	["6481"] = {"Severe", "II", 315557},
	["6482"] = {"Severe", "III", 315558},
	["6477"] = {"Versatile", "I", 315549},
	["6478"] = {"Versatile", "II", 315552},
	["6479"] = {"Versatile", "III", 315553},
	["6493"] = {"Siphoner", "I", 315590},
	["6494"] = {"Siphoner", "II", 315591},
	["6495"] = {"Siphoner", "III", 315592},
	["6437"] = {"Strikethrough", "I", 315277},
	["6438"] = {"Strikethrough", "II", 315281},
	["6439"] = {"Strikethrough", "III", 315282},
	["6555"] = {"Racing Pulse", "I", 318266},
	["6559"] = {"Racing Pulse", "II", 318492},
	["6560"] = {"Racing Pulse", "III", 318496},
	["6556"] = {"Deadly Momentum", "I", 318268},
	["6561"] = {"Deadly Momentum", "II", 318493},
	["6562"] = {"Deadly Momentum", "III", 318497},
	["6558"] = {"Surging Vitality", "I", 318270},
	["6565"] = {"Surging Vitality", "II", 318495},
	["6566"] = {"Surging Vitality", "III", 318499},
	["6557"] = {"Honed Mind", "I", 318269},
	["6563"] = {"Honed Mind", "II", 318494},
	["6564"] = {"Honed Mind", "III", 318498},
	["6549"] = {"Echoing Void", "I", 318280},
	["6550"] = {"Echoing Void", "II", 318485},
	["6551"] = {"Echoing Void", "III", 318486},
	["6552"] = {"Infinite Stars", "I", 318274},
	["6553"] = {"Infinite Stars", "II", 318487},
	["6554"] = {"Infinite Stars", "III", 318488},
	["6547"] = {"Ineffable Truth", "I", 318303},
	["6548"] = {"Ineffable Truth", "II", 318484},
	["6537"] = {"Twilight Devastation", "I", 318276},
	["6538"] = {"Twilight Devastation", "II", 318477},
	["6539"] = {"Twilight Devastation", "III", 318478},
	["6543"] = {"Twisted Appendage", "I", 318481},
	["6544"] = {"Twisted Appendage", "II", 318482},
	["6545"] = {"Twisted Appendage", "III", 318483},
	["6540"] = {"Void Ritual", "I", 318286},
	["6541"] = {"Void Ritual", "II", 318479},
	["6542"] = {"Void Ritual", "III", 318480},
	["6573"] = {"Gushing Wound", "", 318272},
	["6546"] = {"Glimpse of Clarity", "", 318239},
	["6571"] = {"Searing Flames", "", 318293},
	["6572"] = {"Obsidian Skin", "", 316651},
	["6567"] = {"Devour Vitality", "", 318294},
	["6568"] = {"Whispered Truths", "", 316780},
	["6570"] = {"Flash of Insight", "", 318299},
	["6569"] = {"Lash of the Void", "", 317290},
}

-- fixed weapon bonuses for EJ
module.Weapons = {
	["172199"] = "6571", -- Faralos, Empire's Dream
	["172200"] = "6572", -- Sk'shuul Vaz
	["172191"] = "6567", -- An'zig Vra
	["172193"] = "6568", -- Whispering Eldritch Bow
	["172198"] = "6570", -- Mar'kowa, the Mindpiercer
	["172197"] = "6569", -- Unguent Caress
	["172227"] = "6544", -- Shard of the Black Empire
	["172196"] = "6541", -- Vorzz Yoq'al
	["174106"] = "6550", -- Qwor N'lyeth
	["172189"] = "6548", -- Eyestalk of Il'gynoth
	["174108"] = "6553", -- Shgla'yos, Astral Malignity
	["172187"] = "6539", -- Devastation's Hour
}

local function GetItemSplit(itemLink)
	local itemString = match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}

	-- Split data into a table
	for _, v in ipairs({strsplit(":", itemString)}) do
		if v == "" then
			itemSplit[#itemSplit + 1] = 0
		else
			itemSplit[#itemSplit + 1] = tonumber(v)
		end
	end

	return itemSplit
end

function module:TooltipHook(tooltip)
	local name, item = tooltip:GetItem()
	if not name then return end

	if IsCorruptedItem(item) then
		local itemSplit = GetItemSplit(item)
		local bonuses = {}

		for index=1, itemSplit[13] do
			bonuses[#bonuses + 1] = itemSplit[13 + index]
		end

		-- local lookup for items without bonuses, like in the EJ
		if itemSplit[13] == 1 then
			local itemID = tostring(itemSplit[1])
			if module.Weapons[itemID] ~= nil then
				bonuses[#bonuses + 1] = module.Weapons[itemID]
			end
		end

		local corruption = module:GetCorruption(bonuses)

		if corruption then
			local name = corruption[1]
			local icon = corruption[2]
			local line = '|T'..icon..':14:14:0:0:64:64:4:60:4:60|t '..'|cff956dd1'..name..'|r'
			if E.db.mui.tooltip.corruption.icon ~= true then
				line = '|cff956dd1'..name..'|r'
			end

			if module:Append(tooltip, line) ~= true then
				tooltip:AddLine(" ")
				tooltip:AddLine(line)
			end
		end
	end
end

function module:GetCorruption(bonuses)
	if #bonuses > 0 then
		for i, bonus_id in pairs(bonuses) do
			bonus_id = tostring(bonus_id)
			if module.Ranks[bonus_id] ~= nil then
				local name, rank, icon = GetSpellInfo(module.Ranks[bonus_id][3])
				if module.Ranks[bonus_id][2] ~= "" then
					rank = L[module.Ranks[bonus_id][2]]
				else
					rank = ""
				end
				if E.db.mui.tooltip.corruption.english then
					name = module.Ranks[bonus_id][1]
					rank = module.Ranks[bonus_id][2]
				end
				return {name.." "..rank, icon}
			end
		end
	end
end

function module:Append(tooltip, line)
	if E.db.mui.tooltip.corruption.append then
		for i = 1, tooltip:NumLines() do
			local left = _G[tooltip:GetName().."TextLeft"..i]
			local text = left:GetText()
			if (text ~= nil) then
				local detected = find(text, _G.ITEM_MOD_CORRUPTION)
				if (detected ~= nil and ((strsub(text, 1, 1) == "+") or (GetLocale() == "koKR"))) then
					left:SetText(left:GetText().." / "..line)
					return true
				end
			end
		end
	end
end

function module:SummaryEnter(frame)
	module:SummaryHook(frame)
end

function module:SummaryHook(frame)
	if E.db.mui.tooltip.corruption.summary then
		local corruptions = module:GetCorruptions()
		if #corruptions > 0 then
			_G.GameTooltip:AddLine(" ")

			local buckets = {}
			for i = 1, #corruptions do
				local name = corruptions[i][1]
				local icon = corruptions[i][2]
				local line = '|T'..icon..':14:14:0:0:64:64:4:60:4:60|t |cff956dd1'..name..'|r'
				if E.db.mui.tooltip.corruption.icon ~= true then
					line = '|cff956dd1'..name..'|r'
				end

				if buckets[name] == nil then
					buckets[name] = {1, line}
				else
					buckets[name][1]= buckets[name][1] + 1
				end
			end
			tsort(buckets)
			for name, _ in pairs(buckets) do
				_G.GameTooltip:AddLine("|cff956dd1"..buckets[name][1]..' x '..buckets[name][2].."|r")
			end

			_G.GameTooltip:Show()
		end
	end
end

function module:GetCorruptions()
	local corruptions = {}
	for slotNum = 1, #module.slotNames do
		local slotId = GetInventorySlotInfo(module.slotNames[slotNum])
		local itemLink = GetInventoryItemLink('player', slotId)
		if itemLink then
			local itemSplit = GetItemSplit(itemLink)
			local bonuses = {}

			for index=1, itemSplit[13] do
				bonuses[#bonuses + 1] = itemSplit[13 + index]
			end

			local corruption = module:GetCorruption(bonuses)
			if corruption then
				corruptions[#corruptions + 1] = corruption
			end
		end
	end

	return corruptions
end

function module:returnPoints(slotId)
	if slotId <= 5 or slotId == 15 or slotId == 9 then -- Left side
		return "LEFT", "RIGHT", 8, 0, "LEFT", "MIDDLE"
	elseif slotId <= 14 then -- Right side
		return "RIGHT", "LEFT", -8, 0, "RIGHT", "MIDDLE"
	else -- Weapon slots
		return "BOTTOM", "TOP", 2, 3, "CENTER", "MIDDLE"
	end
end

function module:SetupCharacterFrame(frame)
	if #frame > 0 then return end

	if frame == F then
		frame:SetFrameLevel(_G.CharacterHeadSlot:GetFrameLevel())
		self:SecureHook("PaperDollItemSlotButton_Update", 'CharacterFrameUpdate')
		--self:SecureHookScript(frame, "OnShow", 'CharacterFrameShow')
	else
		frame:SetFrameLevel(_G.InspectHeadSlot:GetFrameLevel())
		self:SecureHook("InspectPaperDollItemSlotButton_Update", 'CharacterFrameUpdate')
	end

	for i = 1, #module.slotNames do
		frame[i] = CreateFrame("Frame", nil, frame)
		local s = frame[i]:CreateFontString(nil, "OVERLAY", "GameFontNormalOutline") -- Revert the previous fix, the smaller text size made it bit too hard to read the icons
		frame[i]:SetAllPoints(s) -- Fontstring anchoring hack by SDPhantom https://www.wowinterface.com/forums/showpost.php?p=280136&postcount=6
		frame[i].string = s;
	end

	local point
	if frame == F then
		point = "Character"
	else
		point = "Inspect"
	end

	for i = 1, #module.slotNames do -- Set Point and Justify
		local parent = _G[ point..module.slotNames[i] ]
		local myPoint, parentPoint, x, y, justifyH, justifyV = module:returnPoints(i)
		frame[i].string:ClearAllPoints()
		frame[i].string:SetPoint(myPoint, parent, parentPoint, x, y)
		frame[i].string:SetJustifyH(justifyH)
		frame[i].string:SetJustifyV(justifyV)
		frame[i].string:SetFormattedText("")
	end
end

function module:CharacterFrameUpdate(button)
	local slotId = button:GetID()
	local frame, unit

	if (button:GetParent():GetName() == "PaperDollItemsFrame") then
		frame, unit = F, "player"
	elseif (button:GetParent():GetName()) == "InspectPaperDollItemsFrame" then
		frame, unit = I, _G.InspectFrame.unit or "target"
	end
end

function module:Initialize()
	module.db = E.db.mui.tooltip.corruption
	MER:RegisterDB(self, "corruption")

	if not E.db.mui.tooltip.corruption.enable or IsAddOnLoaded('CorruptionTooltips') then return end

	self:SecureHookScript(_G.GameTooltip, 'OnTooltipSetItem', 'TooltipHook')
	self:SecureHookScript(_G.ItemRefTooltip, 'OnTooltipSetItem', 'TooltipHook')
	self:SecureHookScript(_G.ShoppingTooltip1, 'OnTooltipSetItem', 'TooltipHook')
	self:SecureHookScript(_G.ShoppingTooltip2, 'OnTooltipSetItem', 'TooltipHook')
	self:SecureHookScript(_G.EmbeddedItemTooltip, 'OnTooltipSetItem', 'TooltipHook')
	self:SecureHookScript(_G.CharacterStatsPane.ItemLevelFrame.Corruption, 'OnEnter', 'SummaryEnter')
	--self:SecureHookScript(_G.CharacterStatsPane.ItemLevelFrame.Corruption, 'OnLeave', 'SummaryLeave')
end

MER:RegisterModule(module:GetName())

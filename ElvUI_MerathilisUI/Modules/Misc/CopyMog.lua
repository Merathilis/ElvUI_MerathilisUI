local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins") ---@type Skins

------------------------------------
-- Credit: Narcissus, by Peterodox
------------------------------------

local _G = _G
local tinsert = table.insert
local wipe = wipe

local C_Transmog_CanHaveSecondaryAppearanceForSlotID = C_Transmog.CanHaveSecondaryAppearanceForSlotID
local C_TransmogCollection_GetAppearanceSourceDrops = C_TransmogCollection.GetAppearanceSourceDrops
local C_TransmogCollection_GetIllusionStrings = C_TransmogCollection.GetIllusionStrings
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo
local C_TransmogCollection_GetInspectItemTransmogInfoList = C_TransmogCollection.GetInspectItemTransmogInfoList

local SlotIDtoName = {
	[1] = HEADSLOT,
	[2] = NECKSLOT,
	[3] = SHOULDERSLOT,
	[4] = SHIRTSLOT,
	[5] = CHESTSLOT,
	[6] = WAISTSLOT,
	[7] = LEGSSLOT,
	[8] = FEETSLOT,
	[9] = WRISTSLOT,
	[10] = HANDSSLOT,
	[11] = FINGER0SLOT_UNIQUE,
	[12] = FINGER1SLOT_UNIQUE,
	[13] = TRINKET0SLOT_UNIQUE,
	[14] = TRINKET1SLOT_UNIQUE,
	[15] = BACKSLOT,
	[16] = MAINHANDSLOT,
	[17] = SECONDARYHANDSLOT,
	[18] = RANGEDSLOT,
	[19] = TABARDSLOT,
}

local TransmogSlotOrder = {
	INVSLOT_HEAD,
	INVSLOT_SHOULDER,
	INVSLOT_BACK,
	INVSLOT_CHEST,
	INVSLOT_BODY,
	INVSLOT_TABARD,
	INVSLOT_WRIST,
	INVSLOT_HAND,
	INVSLOT_WAIST,
	INVSLOT_LEGS,
	INVSLOT_FEET,
	INVSLOT_MAINHAND,
	INVSLOT_OFFHAND,
}

local function GenerateSource(sourceID, sourceType, itemModID, itemQuality)
	local sourceTextColorized = ""
	if sourceType == 1 then --TRANSMOG_SOURCE_BOSS_DROP
		local drops = C_TransmogCollection_GetAppearanceSourceDrops(sourceID)
		if drops and drops[1] then
			sourceTextColorized = drops[1].encounter .. " " .. "|cFFFFD100" .. drops[1].instance .. "|r|CFFf8e694"
			if itemModID == 0 then
				sourceTextColorized = sourceTextColorized .. " " .. PLAYER_DIFFICULTY1
			elseif itemModID == 1 then
				sourceTextColorized = sourceTextColorized .. " " .. PLAYER_DIFFICULTY2
			elseif itemModID == 3 then
				sourceTextColorized = sourceTextColorized .. " " .. PLAYER_DIFFICULTY6
			elseif itemModID == 4 then
				sourceTextColorized = sourceTextColorized .. " " .. PLAYER_DIFFICULTY3
			end
		end
	else
		if sourceType == 2 then --quest
			sourceTextColorized = TRANSMOG_SOURCE_2
		elseif sourceType == 3 then --vendor
			sourceTextColorized = TRANSMOG_SOURCE_3
		elseif sourceType == 4 then --world drop
			sourceTextColorized = TRANSMOG_SOURCE_4
		elseif sourceType == 5 then --achievement
			sourceTextColorized = TRANSMOG_SOURCE_5
		elseif sourceType == 6 then --profession
			sourceTextColorized = TRANSMOG_SOURCE_6
		else
			if itemQuality == 6 then
				sourceTextColorized = ITEM_QUALITY6_DESC
			elseif itemQuality == 5 then
				sourceTextColorized = ITEM_QUALITY5_DESC
			end
		end
	end

	return sourceTextColorized
end

local function GetIllusionSource(illusionID)
	local name, _, sourceText = C_TransmogCollection_GetIllusionStrings(illusionID)
	name = name and format(TRANSMOGRIFIED_ENCHANT, name)

	return name, sourceText
end

local function GetTransmogInfo(slotID, sourceID)
	local sourceInfo = C_TransmogCollection_GetSourceInfo(sourceID)
	if not sourceInfo or not sourceInfo.name then
		module.TransmogTextFrame.waitingOnItemData = true
		return
	end

	if sourceInfo.isHideVisual and not E.db.mui.misc.copyMog.ShowHideVisual then
		return
	end

	return {
		["SlotID"] = slotID,
		["Name"] = sourceInfo.name,
		["Source"] = GenerateSource(sourceID, sourceInfo.sourceType, sourceInfo.itemModID, sourceInfo.quality),
	}
end

function module:CopyMog_UpdateItemText(transmogInfoList)
	local textFrame = module.TransmogTextFrame
	wipe(textFrame.itemList)
	textFrame.waitingOnItemData = false
	textFrame.transmogInfoList = transmogInfoList

	local mainHandEnchant, offHandEnchant
	for _, slotID in ipairs(TransmogSlotOrder) do
		local transmogInfo = transmogInfoList[slotID]
		if transmogInfo then
			local appearanceID, secondaryAppearanceID, illusionID =
				transmogInfo.appearanceID, transmogInfo.secondaryAppearanceID, transmogInfo.illusionID
			if appearanceID and appearanceID ~= Constants.Transmog.NoTransmogID then
				local info = GetTransmogInfo(slotID, appearanceID)
				if info then
					tinsert(textFrame.itemList, info)
				end
			end

			if
				C_Transmog_CanHaveSecondaryAppearanceForSlotID(slotID)
				and secondaryAppearanceID ~= Constants.Transmog.NoTransmogID
				and secondaryAppearanceID ~= appearanceID
			then
				local info = GetTransmogInfo(slotID, secondaryAppearanceID)
				if info then
					tinsert(textFrame.itemList, info)
				end
			end

			if slotID == 16 then
				mainHandEnchant = illusionID
			elseif slotID == 17 then
				offHandEnchant = illusionID
			end
		end
	end

	if E.db.mui.misc.copyMog.ShowIllusion then
		if mainHandEnchant and mainHandEnchant > 0 then
			local illusionName, sourceText = GetIllusionSource(mainHandEnchant)
			tinsert(textFrame.itemList, { ["SlotID"] = 16, ["Name"] = illusionName, ["Source"] = sourceText })
		end

		if offHandEnchant and offHandEnchant > 0 then
			local illusionName, sourceText = GetIllusionSource(offHandEnchant)
			tinsert(textFrame.itemList, { ["SlotID"] = 17, ["Name"] = illusionName, ["Source"] = sourceText })
		end
	end

	local texts = ""
	for _, info in ipairs(textFrame.itemList) do
		if info.Name and info.Name ~= "" then
			texts = texts .. "|cFFFFD100" .. SlotIDtoName[info.SlotID] .. ":|r " .. info.Name
			if info.Source and info.Source ~= "" then
				texts = texts .. " |cFF40C7EB(" .. info.Source .. ")|r|r"
			end
			texts = texts .. "\n"
		end
	end

	textFrame.EditBox:SetText(strtrim(texts))
	textFrame.EditBox:HighlightText()
	textFrame:Show()
end

local function TextFrame_OnShow(self)
	self:RegisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
end

local function TextFrame_OnHide(self)
	self:UnregisterEvent("TRANSMOG_COLLECTION_ITEM_UPDATE")
end

local function TextFrame_OnEvent(self, event, ...)
	if event == "TRANSMOG_COLLECTION_ITEM_UPDATE" then
		if self.waitingOnItemData and self.transmogInfoList then
			module:CopyMog_UpdateItemText(self.transmogInfoList)
		end
	end
end

function module:CopyMog_CreateTextFrame()
	local textFrame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	textFrame:SetPoint("CENTER")
	textFrame:SetSize(400, 300)
	textFrame:SetFrameStrata("DIALOG")
	textFrame:SetTemplate("Transparent")
	WS:CreateShadow(textFrame)

	E:CreateMover(
		textFrame,
		"CopyMogTextFrameMover",
		MER.Title .. L["Transmog Text Frame"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,misc,copyMog"
	)

	textFrame:SetScript("OnShow", TextFrame_OnShow)
	textFrame:SetScript("OnHide", TextFrame_OnHide)
	textFrame:SetScript("OnEvent", TextFrame_OnEvent)
	textFrame:Hide()

	textFrame.Header = textFrame:CreateFontString(nil, "OVERLAY")
	textFrame.Header:FontTemplate(nil, 14, "OUTLINE")
	textFrame.Header:SetPoint("TOP", 0, -5)
	textFrame.Header:SetText(TRANSMOGRIFY)

	local close = CreateFrame("Button", nil, textFrame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", textFrame)
	S:HandleCloseButton(close)
	textFrame.Close = close

	local scrollArea = CreateFrame("ScrollFrame", nil, textFrame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)
	S:HandleScrollBar(scrollArea.ScrollBar)

	local editBox = CreateFrame("EditBox", nil, textFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:FontTemplate(nil, 14, "OUTLINE")
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript("OnEscapePressed", function()
		textFrame:Hide()
	end)
	scrollArea:SetScrollChild(editBox)
	textFrame.EditBox = editBox

	return textFrame
end

local function CreateCopyButton(parent)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(50, 20)
	button:SetText(L["Transmog"])
	button.Text:FontTemplate(nil, 12, "OUTLINE")
	button.Text:SetTextColor(F.r, F.g, F.b)
	S:HandleButton(button)
	parent.CopyButton = button

	return button
end

function module:CopyMog_CreatePlayerButton()
	local button = CreateCopyButton(_G.PaperDollFrame)
	button:SetPoint("TOPLEFT", 5, -6)
	button:SetScript("OnClick", function()
		local playerActor = _G.CharacterModelScene:GetPlayerActor()
		if not playerActor then
			return
		end

		local transmogInfoList = playerActor:GetItemTransmogInfoList()
		if not transmogInfoList then
			return
		end

		module:CopyMog_UpdateItemText(transmogInfoList)
	end)
end

function module:CopyMog_CreateInspectButton()
	local button = CreateCopyButton(_G.InspectPaperDollFrame)
	button:SetPoint("TOPLEFT", 5, -6)
	button:SetScript("OnClick", function()
		local transmogInfoList = C_TransmogCollection_GetInspectItemTransmogInfoList()
		if not transmogInfoList then
			return
		end

		module:CopyMog_UpdateItemText(transmogInfoList)
	end)
end

function module:CopyMog()
	local db = E.db.mui.misc.copyMog
	if not db or not db.enable then
		return
	end

	module.TransmogTextFrame = module:CopyMog_CreateTextFrame()
	module.TransmogTextFrame.itemList = {}
	module.TransmogTextFrame.waitingOnItemData = false

	module:CopyMog_CreatePlayerButton()
	module:AddCallbackForAddon("Blizzard_InspectUI", module.CopyMog_CreateInspectButton)
end

module:AddCallback("CopyMog")

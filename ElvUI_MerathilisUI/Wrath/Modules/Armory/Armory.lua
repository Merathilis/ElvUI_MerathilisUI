local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local M = MER:GetModule('MER_Misc')
local IL = MER:GetModule('MER_ItemLevel')
local S = MER:GetModule('MER_Skins')

local wipe, gmatch, tinsert, ipairs, pairs = wipe, gmatch, tinsert, ipairs, pairs
local tonumber, tostring, max = tonumber, tostring, max

local PaperDollFrame = _G.PaperDollFrame
local CharacterNameText = _G.CharacterNameText
local EquipmentManager_EquipSet = EquipmentManager_EquipSet

local ClassSymbolFrame

local function SetCharacterStats(statsTable, category)
	if category == "PLAYERSTAT_BASE_STATS" then
		PaperDollFrame_SetStat(statsTable[1], 1)
		PaperDollFrame_SetStat(statsTable[2], 2)
		PaperDollFrame_SetStat(statsTable[3], 3)
		PaperDollFrame_SetStat(statsTable[4], 4)
		PaperDollFrame_SetStat(statsTable[5], 5)
		PaperDollFrame_SetArmor(statsTable[6])
	elseif category == "PLAYERSTAT_DEFENSES" then
		PaperDollFrame_SetArmor(statsTable[1])
		PaperDollFrame_SetDefense(statsTable[2])
		PaperDollFrame_SetDodge(statsTable[3])
		PaperDollFrame_SetParry(statsTable[4])
		PaperDollFrame_SetBlock(statsTable[5])
		PaperDollFrame_SetResilience(statsTable[6])
	elseif category == "PLAYERSTAT_MELEE_COMBAT" then
		PaperDollFrame_SetDamage(statsTable[1])
		statsTable[1]:SetScript("OnEnter", CharacterDamageFrame_OnEnter)
		PaperDollFrame_SetAttackSpeed(statsTable[2])
		PaperDollFrame_SetAttackPower(statsTable[3])
		PaperDollFrame_SetRating(statsTable[4], CR_HIT_MELEE)
		PaperDollFrame_SetMeleeCritChance(statsTable[5])
		PaperDollFrame_SetExpertise(statsTable[6])
	elseif category == "PLAYERSTAT_SPELL_COMBAT" then
		PaperDollFrame_SetSpellBonusDamage(statsTable[1])
		statsTable[1]:SetScript("OnEnter", CharacterSpellBonusDamage_OnEnter)
		PaperDollFrame_SetSpellBonusHealing(statsTable[2])
		PaperDollFrame_SetRating(statsTable[3], CR_HIT_SPELL)
		PaperDollFrame_SetSpellCritChance(statsTable[4])
		statsTable[4]:SetScript("OnEnter", CharacterSpellCritChance_OnEnter)
		PaperDollFrame_SetSpellHaste(statsTable[5])
		PaperDollFrame_SetManaRegen(statsTable[6])
	elseif category == "PLAYERSTAT_RANGED_COMBAT" then
		PaperDollFrame_SetRangedDamage(statsTable[1])
		statsTable[1]:SetScript("OnEnter", CharacterRangedDamageFrame_OnEnter)
		PaperDollFrame_SetRangedAttackSpeed(statsTable[2])
		PaperDollFrame_SetRangedAttackPower(statsTable[3])
		PaperDollFrame_SetRating(statsTable[4], CR_HIT_RANGED)
		PaperDollFrame_SetRangedCritChance(statsTable[5])
	end
end

local orderList = {}
local function BuildListFromValue()
	wipe(orderList)

	for number in gmatch(E.db.mui.armory.StatOrder, "%d") do
		tinsert(orderList, tonumber(number))
	end
end

local categoryFrames = {}
local framesToSort = {}
local function UpdateCategoriesOrder()
	wipe(framesToSort)

	for _, index in ipairs(orderList) do
		tinsert(framesToSort, categoryFrames[index])
	end
end

local function UpdateCategoriesAnchor()
	UpdateCategoriesOrder()

	local prev
	for _, frame in pairs(framesToSort) do
		if not prev then
			frame:SetPoint("TOP", 0, -70)
		else
			frame:SetPoint("TOP", prev, "BOTTOM")
		end
		prev = frame
	end
end

local function BuildValueFromList()
	local str = ""
	for _, index in ipairs(orderList) do
		str = str..tostring(index)
	end
	E.db.mui.armory.StatOrder = str

	UpdateCategoriesAnchor()
end

local function Arrow_GoUp(bu)
	local frameIndex = bu.__owner.index

	BuildListFromValue()

	for order, index in pairs(orderList) do
		if index == frameIndex then
			if order > 1 then
				local oldIndex = orderList[order-1]
				orderList[order-1] = frameIndex
				orderList[order] = oldIndex

				BuildValueFromList()
			end
			break
		end
	end
end

local function Arrow_GoDown(bu)
	local frameIndex = bu.__owner.index

	BuildListFromValue()

	for order, index in pairs(orderList) do
		if index == frameIndex then
			if order < 5 then
				local oldIndex = orderList[order+1]
				orderList[order+1] = frameIndex
				orderList[order] = oldIndex

				BuildValueFromList()
			end
			break
		end
	end
end

local function CreateStatRow(parent, index)
	local frame = CreateFrame("Frame", "$parentRow"..index, parent, "StatFrameTemplate")
	frame:SetWidth(180)
	frame:SetPoint("TOP", parent.header, "BOTTOM", 0, -2 - (index - 1) * 16)

	local background = frame:CreateTexture(nil, "BACKGROUND")
	background:SetAtlas("UI-Character-Info-Line-Bounce", true)
	background:SetAlpha(.3)
	background:SetPoint("CENTER")
	background:SetShown(index%2 == 0)
	frame.background = background

	return frame
end

local function CreateHeaderArrow(parent, direct, func)
	local onLeft = direct == "LEFT"
	local xOffset = onLeft and 10 or -10
	local arrowDirec = onLeft and "up" or "down"

	local bu = CreateFrame("Button", nil, parent)
	bu:SetPoint(direct, parent.header, xOffset, 0)

	local tex = bu:CreateTexture()
	tex:SetAllPoints()
	S:SetupArrow(tex, arrowDirec)
	bu.__texture = tex
	bu:SetScript("OnEnter", F.Texture_OnEnter)
	bu:SetScript("OnLeave", F.Texture_OnLeave)

	bu:SetSize(18, 18)
	bu.__owner = parent
	bu:SetScript("OnClick", func)
end

local function CreatePlayerILvl(parent, category)
	local frame = CreateFrame("Frame", "MER_StatCategoryIlvl", parent)
	frame:SetWidth(200)
	frame:SetHeight(42 + 16)
	frame:SetPoint("TOP")

	local header = CreateFrame("Frame", "$parentHeader", frame, "CharacterStatFrameCategoryTemplate")
	header:SetPoint("TOP", 0, 10)
	header.Background:Hide()
	header.Title:FontTemplate(nil, 14)
	header.Title:SetText(E:TextGradient(category, F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
	frame.header = header

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize(180, E.mult)
	line:SetPoint("BOTTOM", header, 0, 5)
	line:SetColorTexture(1, 1, 1, .25)

	local iLvlFrame = CreateStatRow(frame, 1)
	iLvlFrame:SetHeight(30)
	iLvlFrame.background:Show()
	iLvlFrame.background:SetAtlas("UI-Character-Info-ItemLevel-Bounce", true)

	M.PlayerILvl = iLvlFrame:CreateFontString(nil, "OVERLAY")
    M.PlayerILvl:FontTemplate(nil, 20)
	M.PlayerILvl:SetAllPoints()
end

function M:UpdatePlayerILvl()
	IL:UpdateUnitILvl("player", M.PlayerILvl)
end

local function CreateStatHeader(parent, index, category)
	local maxLines = index == 5 and 5 or 6
	local frame = CreateFrame("Frame", "MER_StatCategory"..index, parent)
	frame:SetWidth(200)
	frame:SetHeight(42 + maxLines*16)
	frame.index = index
	tinsert(categoryFrames, frame)

	local header = CreateFrame("Frame", "$parentHeader", frame, "CharacterStatFrameCategoryTemplate")
	header:SetPoint("TOP")
	header.Background:Hide()
	header.Title:FontTemplate(nil, 14)
	header.Title:SetText(E:TextGradient(_G[category], F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))
	frame.header = header

	CreateHeaderArrow(frame, "LEFT", Arrow_GoUp)
	CreateHeaderArrow(frame, "RIGHT", Arrow_GoDown)

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize(180, E.mult)
	line:SetPoint("BOTTOM", header, 0, 5)
	line:SetColorTexture(1, 1, 1, .25)

	local statsTable = {}
	for i = 1, maxLines do
		statsTable[i] = CreateStatRow(frame, i)
	end
	SetCharacterStats(statsTable, category)
	frame.category = category
	frame.statsTable = statsTable

	return frame
end

local function ToggleMagicRes()
	if E.db.mui.armory.StatExpand then
		CharacterResistanceFrame:ClearAllPoints()
		CharacterResistanceFrame:SetPoint("TOPLEFT", M.StatPanel2, 28, -10)
		CharacterResistanceFrame:SetParent(M.StatPanel2)
		if not M.hasOtherAddon then CharacterModelFrame:SetSize(231, 320) end -- size in retail

		for i = 1, 5 do
			local bu = _G["MagicResFrame"..i]
			if i > 1 then
				bu:ClearAllPoints()
				bu:SetPoint("LEFT", _G["MagicResFrame"..(i-1)], "RIGHT", 3, 0)
			end
		end
	else
		CharacterResistanceFrame:ClearAllPoints()
		CharacterResistanceFrame:SetPoint("TOPRIGHT", PaperDollFrame, "TOPLEFT", 297, -77)
		CharacterResistanceFrame:SetParent(PaperDollFrame)
		CharacterModelFrame:SetSize(233, 224)

		for i = 1, 5 do
			local bu = _G["MagicResFrame"..i]
			if i > 1 then
				bu:ClearAllPoints()
				bu:SetPoint("TOP", _G["MagicResFrame"..(i-1)], "BOTTOM", 0, -3)
			end
		end
	end
end

local function UpdateStats()
	if not (M.StatPanel2 and M.StatPanel2:IsShown()) then return end

	for _, frame in pairs(categoryFrames) do
		SetCharacterStats(frame.statsTable, frame.category)
	end
end

local function ToggleStatPanel(texture)
	if E.db.mui.armory.StatExpand then
		S:SetupArrow(texture, "left")
		CharacterAttributesFrame:Hide()
		M.StatPanel2:Show()
	else
		S:SetupArrow(texture, "right")
		CharacterAttributesFrame:SetShown(not M.hasOtherAddon)
		M.StatPanel2:Hide()
	end
	ToggleMagicRes()
end

local function ExpandCharacterFrame(expand)
	if MER.IsWrath then return end
	CharacterFrame:SetWidth(expand and 584 or 384)
end

M.OtherPanels = {"DCS_StatScrollFrame", "CSC_SideStatsFrame"}
local found
function M:FindAddOnPanels()
	if not found then
		for _, name in pairs(M.OtherPanels) do
			if _G[name] then
				tinsert(PaperDollFrame.__statPanels, _G[name])
			end
		end
		if PaperDollFrame.inspectFrame then
			tinsert(PaperDollFrame.__statPanels, PaperDollFrame.inspectFrame)
		end
		found = true
	end

	M:SortAddOnPanels()
end

function M:SortAddOnPanels()
	local prev

	for _, frame in pairs(PaperDollFrame.__statPanels) do
		frame:ClearAllPoints()

		if not prev then
			if M.StatPanel2:IsShown() then
				frame:SetPoint("TOPLEFT", M.StatPanel2, "TOPRIGHT", 3, 0)
			else
				frame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -32, -15-C.mult)
			end
		else
			frame:SetPoint("TOPLEFT", prev, "TOPRIGHT", 3, 0)
		end
		prev = frame
	end
end

function M:AddCharacterIcon()
	ClassSymbolFrame = ("|T" .. (MER.ClassIcons[E.myclass] .. ".tga:0:0:0:0|t"))

	E:Delay(0, function() -- otherwise it will just return "name"
		if not (CharacterNameText:GetText():match("|T")) then
			CharacterNameText:SetFont(E.LSM:Fetch('font', E.db.general.font), 16, E.db.general.fontStyle)
			CharacterNameText:SetShadowColor(0, 0, 0, 0.6)
			CharacterNameText:SetShadowOffset(2, -1)

			CharacterNameText:SetText(ClassSymbolFrame .. " " .. F.GradientName(CharacterNameText:GetText(), E.myclass))
		end
	end)
end

function M:SelectEquipSet()
	if InCombatLockdown() then UIErrorsFrame:AddMessage(MER.InfoColor .. ERR_NOT_IN_COMBAT) return end

	local selectedSet = _G.GearManagerDialog.selectedSet
	local name = selectedSet and selectedSet.id
	if name then
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		EquipmentManager_EquipSet(name)
	end
end

function M:ExGearManager()
	_G.GearManagerDialog.Title:SetJustifyH("LEFT")
	_G.GearManagerDialog.Title:SetPoint("TOPLEFT", 12, -12)
	_G.GearManagerDialog:SetFrameStrata("DIALOG")
	_G.GearManagerDialog:SetSize(339, 70)
	_G.GearManagerDialog:ClearAllPoints()
	_G.GearManagerDialog:SetPoint("BOTTOMLEFT", PaperDollFrame, "TOPLEFT", 10, -18)

	local prevButton
	for i = 1, 10 do
		local button = _G["GearSetButton" .. i]
		button:ClearAllPoints()
		button:SetSize(28, 28)
		if not prevButton then
			button:SetPoint("BOTTOMLEFT", 10, 10)
		else
			button:SetPoint("LEFT", prevButton, "RIGHT", 5, 0)
		end
		prevButton = button

		button:SetScript("OnDoubleClick", M.SelectEquipSet)
	end

	local names = { "EquipSet", "DeleteSet", "SaveSet" }
	for i, name in pairs(names) do
		local button = _G["GearManagerDialog" .. name]
		button:SetSize(60, 20)
		button:ClearAllPoints()
		button:SetPoint("TOPRIGHT", 35 - 62 * i, -9)
	end
end

function M:Armory()
	if not E.db.mui.armory.character.enable or not (E.private.skins.blizzard.enable or E.private.skins.blizzard.character) then
		return
	end

	M.hasOtherAddon = IsAddOnLoaded("CharacterStatsTBC")

	local statPanel = CreateFrame("Frame", "MER_StatPanel", PaperDollFrame)
	statPanel:SetSize(200, 424)
	statPanel:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -30, -12)

	statPanel:SetTemplate('Transparent')
	statPanel:Styling()
	S:CreateShadow(statPanel)
	M.StatPanel2 = statPanel

	local scrollFrame = CreateFrame("ScrollFrame", nil, statPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -45)

	scrollFrame:SetPoint("BOTTOMRIGHT", 0, 2)
	scrollFrame.ScrollBar:Hide()
	scrollFrame.ScrollBar.Show = E.noop

	local stat = CreateFrame("Frame", nil, scrollFrame)
	stat:SetSize(200, 1)
	statPanel.child = stat
	scrollFrame:SetScrollChild(stat)
	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local scrollBar = self.ScrollBar
		local step = delta*25
		if IsShiftKeyDown() then
			step = step*6
		end
		scrollBar:SetValue(scrollBar:GetValue() - step)
	end)

	-- Player iLvl
	CreatePlayerILvl(stat, _G.STAT_AVERAGE_ITEM_LEVEL)
	hooksecurefunc("PaperDollFrame_UpdateStats", M.UpdatePlayerILvl)

	-- Player stats
	local categories = {
		"PLAYERSTAT_BASE_STATS",
		"PLAYERSTAT_DEFENSES",
		"PLAYERSTAT_MELEE_COMBAT",
		"PLAYERSTAT_SPELL_COMBAT",
		"PLAYERSTAT_RANGED_COMBAT",
	}
	for index, category in pairs(categories) do
		CreateStatHeader(stat, index, category)
	end

	-- Init
	BuildListFromValue()
	BuildValueFromList()
	CharacterNameFrame:ClearAllPoints()
	CharacterNameFrame:SetPoint("TOPLEFT", _G.CharacterFrame, 130, -20)
	PaperDollFrame.__statPanels = {}
	M:ExGearManager()

	-- Update data
	hooksecurefunc("ToggleCharacter", UpdateStats)
	PaperDollFrame:HookScript("OnEvent", UpdateStats)

	-- Expand button
	local bu = CreateFrame("Button", nil, PaperDollFrame)
	bu:SetPoint("RIGHT", _G.CharacterFrameCloseButton, "LEFT", -3, 0)
	S:ReskinArrow(bu, "right")

	bu:SetScript("OnClick", function(self)
		E.db.mui.armory.StatExpand = not E.db.mui.armory.StatExpand
		ExpandCharacterFrame(E.db.mui.armory.StatExpand)
		ToggleStatPanel(self.__texture)
		M:SortAddOnPanels()
	end)

	ToggleStatPanel(bu.__texture)

	PaperDollFrame:HookScript("OnHide", function()
		ExpandCharacterFrame()
	end)

	PaperDollFrame:HookScript("OnShow", function()
		ExpandCharacterFrame(E.db.mui.armory.StatExpand)
		M:FindAddOnPanels()
	end)

	-- Block LeatrixPlus toggle
	if IsAddOnLoaded("Leatrix_Plus") then
		local function resetModelAnchor(frame, _, _, x, y)
			if x ~= 65 or y ~= -78 then
				frame:ClearAllPoints()
				frame:SetPoint("TOPLEFT", PaperDollFrame, 65, -78)
				ToggleStatPanel(bu.__texture)
				_G.CharacterResistanceFrame:Show()
			end
		end
		resetModelAnchor(_G.CharacterModelFrame)
		hooksecurefunc(_G.CharacterModelFrame, "SetPoint", resetModelAnchor)
	end

	hooksecurefunc("PaperDollFrame_SetLevel", M.AddCharacterIcon)

	local EventFrame = CreateFrame("Frame")
	EventFrame:RegisterUnitEvent("UNIT_NAME_UPDATE", "player")
	EventFrame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
	EventFrame:SetScript("OnEvent", function()
		M:AddCharacterIcon()
	end)
end

M:AddCallback("Armory")

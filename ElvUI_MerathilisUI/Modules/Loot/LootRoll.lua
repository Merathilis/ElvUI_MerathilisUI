local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_LootRoll") ---@class LootRoll
local B = E:GetModule("Bags")
local LSM = E.Libs.LSM

local _G = _G
local next, pairs, ipairs, unpack = next, pairs, ipairs, unpack
local tinsert, tremove, wipe, format = tinsert, tremove, wipe, format

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetLootRollItemInfo = GetLootRollItemInfo
local GetLootRollItemLink = GetLootRollItemLink
local GetLootRollTimeLeft = GetLootRollTimeLeft
local IsModifiedClick = IsModifiedClick
local IsShiftKeyDown = IsShiftKeyDown
local RollOnLoot = RollOnLoot

local GameTooltip_Hide = GameTooltip_Hide
local GameTooltip_ShowCompareItem = GameTooltip_ShowCompareItem
local GetItemInfo = C_Item.GetItemInfo
local C_LootHistory_GetSortedInfoForDrop = C_LootHistory.GetSortedInfoForDrop

local GREED, NEED, PASS = GREED, NEED, PASS
local TRANSMOGRIFY, ROLL_DISENCHANT = TRANSMOGRIFY, ROLL_DISENCHANT

module.RollBars = {}

local anchor
local cachedRolls = {} -- [rollID] = { [rolltype] = { {name, class}, ... } }
local cachedEncounterIndex = {} -- [encounterID] = first rollID handed out for that encounter

local rollTypes = { [1] = "need", [2] = "greed", [3] = "disenchant", [4] = "transmog", [0] = "pass" }

-- Plain Blizzard textures - these have been around since Classic and are
-- guaranteed to exist, unlike the newer "lootroll-toast-icon-*" atlases which
-- turned out to render as missing-texture blobs on live. Shown uncropped
-- (full 0-1 texcoord), same as Blizzard's own default GroupLootFrame - a
-- zoom-crop meant to hide the round button bezel (copied from ElvUI) ended up
-- cropping into the bezel itself instead of the icon, so it's not worth it.
local rollTextures = {
	[0] = [[Interface\Buttons\UI-GroupLoot-Pass-Up]],
	[1] = [[Interface\Buttons\UI-GroupLoot-Dice-Up]],
	[2] = [[Interface\Buttons\UI-GroupLoot-Coin-Up]],
	[3] = [[Interface\Buttons\UI-GroupLoot-DE-Up]],
	[4] = [[Interface\MINIMAP\TRACKING\Transmogrifier]],
}

local rollStateToType = Enum.EncounterLootDropRollState
	and {
		[Enum.EncounterLootDropRollState.NeedMainSpec] = 1,
		[Enum.EncounterLootDropRollState.Transmog] = 4,
		[Enum.EncounterLootDropRollState.Greed] = 2,
		[Enum.EncounterLootDropRollState.Pass] = 0,
	}
	or {}

--------------------------------------------------------------------
-- Roll buttons
--------------------------------------------------------------------
local function ClickRoll(button)
	if button.parent.rollID and button.rolltype then
		RollOnLoot(button.parent.rollID, button.rolltype)
	end
end

local function SetTip(button)
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(button.tiptext)

	if not button:IsEnabled() then
		GameTooltip:AddLine("|cffff3333" .. L["Can't Roll"])
	end

	local rollID = button.parent.rollID
	local rolls = rollID and cachedRolls[rollID] and cachedRolls[rollID][button.rolltype]
	if rolls and next(rolls) then
		GameTooltip:AddLine(" ")
		for _, rollerInfo in next, rolls do
			local name, class = unpack(rollerInfo)
			local r, g, b = F.ClassColor(class)
			GameTooltip:AddLine(name, r, g, b)
		end
	end

	GameTooltip:Show()
end

local function RollMouseDown(button)
	if button.highlightTex then
		button.highlightTex:SetAlpha(0)
	end
end

local function RollMouseUp(button)
	if button.highlightTex then
		button.highlightTex:SetAlpha(1)
	end
end

local function CreateRollButton(parent, rolltype, tiptext)
	local button = CreateFrame("Button", nil, parent)
	button:SetScript("OnMouseDown", RollMouseDown)
	button:SetScript("OnMouseUp", RollMouseUp)
	button:SetScript("OnClick", ClickRoll)
	button:SetScript("OnEnter", SetTip)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:SetMotionScriptsWhileDisabled(true)
	button:SetHitRectInsets(2, 2, 2, 2)
	button:CreateBackdrop("Default") -- dark slot behind the icon so it doesn't wash out against a bright/saturated status bar color

	local texture = rollTextures[rolltype]
	button:SetNormalTexture(texture)
	button:SetPushedTexture(texture)
	button:SetDisabledTexture(texture)
	button:SetHighlightTexture(texture)

	button.normalTex = button:GetNormalTexture()
	button.disabledTex = button:GetDisabledTexture()
	button.pushedTex = button:GetPushedTexture()
	button.highlightTex = button:GetHighlightTexture()
	button.disabledTex:SetDesaturated(true)
	button.disabledTex:SetAlpha(0.3)

	button.parent = parent
	button.rolltype = rolltype
	button.tiptext = tiptext

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:FontTemplate(nil, nil, "OUTLINE")
	button.count:SetPoint("BOTTOMRIGHT", 1, -1)

	return button
end

--------------------------------------------------------------------
-- Item icon button
--------------------------------------------------------------------
local function ItemButton_OnEnter(self)
	if not self.link then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(self.link)

	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end
end

local function ItemButton_OnEvent(self, event)
	if event == "MODIFIER_STATE_CHANGED" and self:IsMouseOver() then
		ItemButton_OnEnter(self)
	end
end

local function ItemButton_OnClick(self)
	if self.link and IsModifiedClick() then
		_G.HandleModifiedItemClick(self.link)
	end
end

--------------------------------------------------------------------
-- Timer / lifecycle
--------------------------------------------------------------------
local function StatusUpdate(status, elapsed)
	local bar = status.parent
	local rollID = bar.rollID
	if not rollID then
		if not bar.isTest then
			bar:Hide()
		end
		return
	end

	if status.elapsed and status.elapsed > 0.1 then
		local timeLeft = GetLootRollTimeLeft(rollID)
		if timeLeft <= 0 then -- workaround for other addons auto-passing loot
			module:ClearBar(bar, rollID)
		else
			status:SetValue(timeLeft)
			status.elapsed = 0
		end
	else
		status.elapsed = (status.elapsed or 0) + elapsed
	end
end

function module:ClearBar(bar, rollID)
	if bar.rollID ~= rollID then
		return
	end

	bar.rollID = nil
	bar.time = nil
	bar:Hide()

	if cachedRolls[rollID] then
		wipe(cachedRolls[rollID])
		cachedRolls[rollID] = nil
	end
end

--------------------------------------------------------------------
-- Bar creation
--------------------------------------------------------------------
function module:CreateBar(index)
	local db = module.db
	local bar = CreateFrame("Frame", "MERLootRollBar" .. index, anchor)
	bar:SetFrameStrata("HIGH")
	bar:Hide()

	-- Neutral dark panel behind name/buttons, sized to just the main row (not
	-- the rollers line below it) - the quality color only lives in the icon
	-- border + the slim timer strip, so it never fights with text/icon contrast.
	local panel = CreateFrame("Frame", nil, bar)
	panel:CreateBackdrop("Default")
	bar.panel = panel

	local button = CreateFrame("Button", nil, bar)
	button:SetScript("OnEnter", ItemButton_OnEnter)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:SetScript("OnClick", ItemButton_OnClick)
	button:SetScript("OnEvent", ItemButton_OnEvent)
	button:RegisterEvent("MODIFIER_STATE_CHANGED")
	button:CreateBackdrop("Default")
	button.parent = bar
	bar.button = button

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetPoint("TOPLEFT", 2, -2)
	button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	button.stack = button:CreateFontString(nil, "OVERLAY")
	button.stack:FontTemplate(nil, nil, "OUTLINE")
	button.stack:SetPoint("BOTTOMRIGHT", -1, 1)

	button.ilvl = button:CreateFontString(nil, "OVERLAY")
	button.ilvl:FontTemplate(nil, nil, "OUTLINE")
	button.ilvl:SetPoint("BOTTOMLEFT", 1, 1)

	button.questIcon = button:CreateTexture(nil, "OVERLAY")
	button.questIcon:SetTexture(E.Media.Textures.BagQuestIcon)
	button.questIcon:SetTexCoord(1, 0, 0, 1)
	button.questIcon:SetPoint("TOPLEFT", -3, 3)
	button.questIcon:Hide()

	local status = CreateFrame("StatusBar", nil, bar)
	status:CreateBackdrop("Default")
	status:SetScript("OnUpdate", StatusUpdate)
	status.parent = bar
	bar.status = status

	local spark = status:CreateTexture(nil, "OVERLAY")
	spark:SetBlendMode("ADD")
	spark:SetWidth(8)
	spark:Point("TOP", status:GetStatusBarTexture(), "TOPRIGHT")
	spark:Point("BOTTOM", status:GetStatusBarTexture(), "BOTTOMRIGHT")
	spark:SetColorTexture(1, 1, 1, 0.5) -- neutral white regardless of quality color, so it never outshines the (dimmer) fill
	status.spark = spark

	bar.need = CreateRollButton(bar, 1, NEED)
	bar.transmog = CreateRollButton(bar, 4, TRANSMOGRIFY)
	bar.greed = CreateRollButton(bar, 2, GREED)
	bar.disenchant = CreateRollButton(bar, 3, ROLL_DISENCHANT)
	bar.pass = CreateRollButton(bar, 0, PASS)

	local name = bar:CreateFontString(nil, "OVERLAY")
	name:FontTemplate(nil, nil, "OUTLINE")
	name:SetJustifyH("LEFT")
	name:SetWordWrap(false)
	bar.name = name

	local bind = bar:CreateFontString(nil, "OVERLAY")
	bind:FontTemplate(nil, nil, "OUTLINE")
	bar.bind = bind

	local rollers = bar:CreateFontString(nil, "OVERLAY")
	rollers:FontTemplate(nil, nil, "OUTLINE")
	rollers:SetJustifyH("LEFT")
	rollers:SetWordWrap(false)
	bar.rollers = rollers

	bar.rolls = {}

	tinsert(module.RollBars, bar)

	return bar
end

function module:GetFrame()
	for _, bar in next, module.RollBars do
		if not bar.rollID then
			return bar
		end
	end

	if #module.RollBars >= module.db.maxBars then
		return nil
	end

	local bar = module:CreateBar(#module.RollBars + 1)
	module:Layout()
	module:UpdateAnchors()
	return bar
end

--------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------
function module:LayoutBar(bar)
	local db = module.db
	local rollersHeight = db.showRollers and (F.FontSize(db.fontSize) + 4) or 0
	local texture = LSM:Fetch("statusbar", db.statusBarTexture)

	bar:Size(db.width, db.height + rollersHeight)

	bar.panel:ClearAllPoints()
	bar.panel:Point("TOPLEFT", bar, "TOPLEFT")
	bar.panel:Point("TOPRIGHT", bar, "TOPRIGHT")
	bar.panel:SetHeight(db.height)

	bar.button:ClearAllPoints()
	bar.button:Point("TOPLEFT")
	bar.button:Size(db.height, db.height)

	bar.button.questIcon:Size(db.height / 2.4)

	-- Slim timer strip at the very bottom of the main row - this is the ONLY
	-- place the quality color fills solidly, so it never has to compete with
	-- name/icon text for contrast (name/buttons sit on bar's own plain dark
	-- backdrop above it instead, same as ElvUI's own default loot roll style).
	local timerHeight = 6
	bar.status:ClearAllPoints()
	bar.status:Point("BOTTOMLEFT", bar.button, "BOTTOMRIGHT", 4, 0)
	bar.status:Point("TOPRIGHT", bar, "TOPRIGHT", 0, -(db.height - timerHeight))
	bar.status:SetStatusBarTexture(texture)

	bar.name:ClearAllPoints()
	bar.name:FontTemplate(F.GetFontPath(db.font), db.fontSize, db.fontOutline)
	bar.name:Point("TOPLEFT", bar.button, "TOPRIGHT", 8, -3)
	bar.name:Point("RIGHT", bar.bind, "LEFT", -4, 0)

	bar.bind:ClearAllPoints()
	bar.bind:FontTemplate(F.GetFontPath(db.font), db.fontSize, db.fontOutline)
	bar.bind:Point("TOPRIGHT", bar, "TOPRIGHT", -4, -3)

	local buttons = { bar.need, bar.transmog, bar.greed, bar.disenchant, bar.pass }
	local last
	for _, bu in ipairs(buttons) do
		bu:Size(db.buttonSize, db.buttonSize)
		bu:ClearAllPoints()
		if last then
			bu:Point("LEFT", last, "RIGHT", 3, 0)
		else
			bu:Point("BOTTOMLEFT", bar.status, "TOPLEFT", 4, 3)
		end
		bu.count:FontTemplate(F.GetFontPath(db.font), db.fontSize - 3, db.fontOutline)
		last = bu
	end

	bar.rollers:ClearAllPoints()
	bar.rollers:SetShown(db.showRollers)
	if db.showRollers then
		bar.rollers:FontTemplate(F.GetFontPath(db.font), db.fontSize - 2, db.fontOutline)
		bar.rollers:Point("TOPLEFT", bar.button, "BOTTOMLEFT", 0, -2)
		bar.rollers:Point("RIGHT", bar, "RIGHT", 0, 0)
	end
end

function module:Layout()
	for _, bar in next, module.RollBars do
		module:LayoutBar(bar)
	end

	if module.testBars then
		for _, bar in ipairs(module.testBars) do
			module:LayoutBar(bar)
		end
	end

	if anchor then
		anchor:Size(module.db.width, module.db.height + (module.db.showRollers and (F.FontSize(module.db.fontSize) + 4) or 0))
	end
end

function module:StackBars(list)
	local db = module.db
	local lastFrame

	for i, bar in ipairs(list) do
		bar:ClearAllPoints()

		if i == 1 then
			bar:Point(db.growDirection == "UP" and "BOTTOM" or "TOP", anchor, db.growDirection == "UP" and "BOTTOM" or "TOP")
		elseif db.growDirection == "UP" then
			bar:Point("BOTTOM", lastFrame, "TOP", 0, db.spacing)
		else
			bar:Point("TOP", lastFrame, "BOTTOM", 0, -db.spacing)
		end

		lastFrame = bar
	end
end

function module:UpdateAnchors()
	module:StackBars(module.RollBars)
end

--------------------------------------------------------------------
-- Inline roller list (best effort, only populated for boss/encounter loot
-- where Blizzard exposes C_LootHistory roll data on retail)
--------------------------------------------------------------------
local function GetRollBarByID(rollID)
	for _, bar in next, module.RollBars do
		if bar.rollID == rollID then
			return bar
		end
	end
end

local function RefreshRollCounts(bar)
	local info = bar.rollID and cachedRolls[bar.rollID]
	for rolltype, key in pairs(rollTypes) do
		local bu = bar[key]
		local rolls = info and info[rolltype]
		bu.count:SetText(rolls and next(rolls) and #rolls or "")
	end

	if not module.db.showRollers then
		return
	end

	if not info or not next(info) then
		bar.rollers:SetText("")
		return
	end

	local parts = {}
	for rolltype, rolls in pairs(info) do
		if next(rolls) then
			for _, rollerInfo in next, rolls do
				local name, class = unpack(rollerInfo)
				local r, g, b = F.ClassColor(class)
				tinsert(parts, format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name))
			end
		end
	end

	bar.rollers:SetText(table.concat(parts, "  "))
end

function module:LootRoll_GetRollID(encounterID, lootListID)
	local index = cachedEncounterIndex[encounterID]
	return index and (index + lootListID - 1)
end

function module:LOOT_HISTORY_UPDATE_DROP(_, encounterID, lootListID)
	local rollID = module:LootRoll_GetRollID(encounterID, lootListID)
	if not rollID then
		return
	end

	local dropInfo = C_LootHistory_GetSortedInfoForDrop(encounterID, lootListID)
	if not dropInfo then
		return
	end

	cachedRolls[rollID] = {}
	if not dropInfo.allPassed and dropInfo.rollInfos then
		for _, roll in ipairs(dropInfo.rollInfos) do
			local rolltype = rollStateToType[roll.state]
			if rolltype then
				cachedRolls[rollID][rolltype] = cachedRolls[rollID][rolltype] or {}
				tinsert(cachedRolls[rollID][rolltype], { roll.playerName, roll.playerClass })
			end
		end
	end

	local bar = GetRollBarByID(rollID)
	if bar then
		RefreshRollCounts(bar)
	end
end

function module:ENCOUNTER_END(_, id, _, _, _, status)
	if status == 1 then
		module.EncounterID = id
	end
end

--------------------------------------------------------------------
-- Core loot roll events
--------------------------------------------------------------------
function module:START_LOOT_ROLL(_, rollID, rollTime)
	local texture, name, count, quality, _, canNeed, canGreed, canDisenchant, _, _, _, _, canTransmog = GetLootRollItemInfo(rollID)
	if not name then
		local bar = GetRollBarByID(rollID)
		if bar then
			module:ClearBar(bar, rollID)
		end
		return
	end

	if module.EncounterID and not cachedEncounterIndex[module.EncounterID] then
		cachedEncounterIndex[module.EncounterID] = rollID
	end

	local bar = module:GetFrame()
	if not bar then
		return
	end

	local itemLink = GetLootRollItemLink(rollID)
	local _, _, _, itemLevel, _, _, _, _, itemEquipLoc, _, _, itemClassID, itemSubClassID, bindType = GetItemInfo(itemLink)

	local db = module.db
	local r, g, b = E:GetItemQualityColor(quality)

	wipe(bar.rolls)
	bar.rollID = rollID
	bar.time = rollTime

	bar.button.link = itemLink
	bar.button.icon:SetTexture(texture)
	bar.button.stack:SetShown(count > 1)
	bar.button.stack:SetText(count)
	bar.button.ilvl:SetText(itemLevel)

	local canShowItemLevel = B:IsItemEligibleForItemLevelDisplay(itemClassID, itemSubClassID, itemEquipLoc, quality)
	bar.button.ilvl:SetShown(canShowItemLevel and db.qualityItemLevel)

	local questItem = B:GetItemQuestInfo(itemLink, bindType, itemClassID)
	bar.button.questIcon:SetShown(questItem)

	if db.qualityBorder then
		bar.button.backdrop:SetBackdropBorderColor(r, g, b)
	else
		bar.button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	bar.need.count:SetText("")
	bar.transmog.count:SetText("")
	bar.greed.count:SetText("")
	bar.disenchant.count:SetText("")
	bar.pass.count:SetText("")

	bar.need:SetEnabled(canNeed)
	bar.transmog:SetShown(not not canTransmog)
	bar.transmog:SetEnabled(canTransmog)
	bar.greed:SetShown(not canTransmog)
	bar.greed:SetEnabled(canGreed)
	bar.disenchant:SetEnabled(canDisenchant)

	bar.name:SetText(name)
	bar.name:SetTextColor(db.qualityName and r or 1, db.qualityName and g or 1, db.qualityName and b or 1)

	local bop = bindType == 1
	bar.bind:SetVertexColor(bop and 1 or 0.3, bop and 0.3 or 1, bop and 0.1 or 0.3)
	bar.bind:SetText(B.BindText[bindType] or "")

	if db.qualityStatusBar then
		bar.status:SetStatusBarColor(r, g, b, 0.9)
	else
		local c = db.statusBarColor
		bar.status:SetStatusBarColor(c.r, c.g, c.b, 0.9)
	end

	bar.status.elapsed = 1
	bar.status:SetMinMaxValues(0, rollTime)
	bar.status:SetValue(rollTime)

	bar:Show()

	RefreshRollCounts(bar)
end

function module:CANCEL_LOOT_ROLL(_, rollID)
	local bar = GetRollBarByID(rollID)
	if bar then
		module:ClearBar(bar, rollID)
	end
end

function module:CANCEL_ALL_LOOT_ROLLS()
	for _, bar in next, module.RollBars do
		if bar.rollID then
			module:ClearBar(bar, bar.rollID)
		end
	end
end

--------------------------------------------------------------------
-- Disable ElvUI's native loot roll bars/events so we don't get duplicates
--------------------------------------------------------------------
local function DisableElvUILootRoll()
	local misc = E:GetModule("Misc")
	if misc then
		misc:UnregisterEvent("START_LOOT_ROLL")
		misc:UnregisterEvent("CANCEL_LOOT_ROLL")
		misc:UnregisterEvent("CANCEL_ALL_LOOT_ROLLS")
		misc:UnregisterEvent("LOOT_HISTORY_ROLL_CHANGED")
		misc:UnregisterEvent("LOOT_HISTORY_ROLL_COMPLETE")
		misc:UnregisterEvent("LOOT_ROLLS_COMPLETE")

		if misc.RollBars then
			for _, bar in next, misc.RollBars do
				bar:UnregisterAllEvents()
				bar.rollID = nil
				bar:Hide()
			end
		end
	end

	-- Keep Blizzard's own default loot roll frame suppressed no matter what
	-- ElvUI's "Loot Roll" private setting is currently set to.
	E:UnregisterGameEvent("START_LOOT_ROLL")
	E:UnregisterGameEvent("CANCEL_LOOT_ROLL")
	E:UnregisterGameEvent("CANCEL_ALL_LOOT_ROLLS")
end

--------------------------------------------------------------------
-- Test bar
--------------------------------------------------------------------
-- Fully synthetic - no real item lookup needed, so the preview works
-- instantly and never depends on the item cache being warm. Spans the
-- quality spectrum plus a mix of bind/roll-option combos so layout and
-- text contrast can be checked against every quality color at once.
local TEST_ICON = [[Interface\Icons\INV_Misc_QuestionMark]]
local testItems = {
	{ name = L["Uncommon Test Item"], quality = 2, itemLevel = 45, bop = false, canNeed = true, canGreed = true, canTransmog = false, canDisenchant = false, needCount = 1, greedCount = 4 },
	{ name = L["Rare Test Item"], quality = 3, itemLevel = 190, bop = true, canNeed = true, canGreed = true, canTransmog = false, canDisenchant = true, needCount = 3, greedCount = 0 },
	{ name = L["Epic Test Item"], quality = 4, itemLevel = 415, bop = true, canNeed = true, canGreed = false, canTransmog = true, canDisenchant = true, needCount = 2, greedCount = 0 },
	{ name = L["Legendary Test Item"], quality = 5, itemLevel = 450, bop = true, canNeed = true, canGreed = false, canTransmog = false, canDisenchant = false, needCount = 1, greedCount = 0 },
}

local function PopulateTestBar(bar, item)
	local db = module.db
	local r, g, b = E:GetItemQualityColor(item.quality)

	bar.button.link = nil
	bar.button.icon:SetTexture(TEST_ICON)
	bar.button.stack:Hide()
	bar.button.ilvl:SetShown(db.qualityItemLevel)
	bar.button.ilvl:SetText(item.itemLevel)
	bar.button.ilvl:SetTextColor(r, g, b)
	bar.button.questIcon:Hide()

	if db.qualityBorder then
		bar.button.backdrop:SetBackdropBorderColor(r, g, b)
	else
		bar.button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	bar.need:Show()
	bar.need:SetEnabled(item.canNeed)
	bar.need.count:SetText(item.needCount > 0 and item.needCount or "")

	bar.transmog:SetShown(item.canTransmog)
	bar.transmog:SetEnabled(item.canTransmog)
	bar.transmog.count:SetText("")

	bar.greed:SetShown(not item.canTransmog)
	bar.greed:SetEnabled(item.canGreed)
	bar.greed.count:SetText(item.greedCount > 0 and item.greedCount or "")

	bar.disenchant:SetEnabled(item.canDisenchant)
	bar.disenchant.count:SetText("")

	bar.pass.count:SetText("")

	bar.name:SetText(item.name)
	bar.name:SetTextColor(db.qualityName and r or 1, db.qualityName and g or 1, db.qualityName and b or 1)
	bar.bind:SetVertexColor(item.bop and 1 or 0.3, item.bop and 0.3 or 1, item.bop and 0.1 or 0.3)
	bar.bind:SetText(item.bop and B.BindText[1] or B.BindText[2])

	if db.qualityStatusBar then
		bar.status:SetStatusBarColor(r, g, b, 0.9)
	else
		local c = db.statusBarColor
		bar.status:SetStatusBarColor(c.r, c.g, c.b, 0.9)
	end

	bar.rollers:SetText(db.showRollers and format("|cffff8000%s|r  |cffffffff%s|r", L["Example"], UnitName("player")) or "")

	bar.status.elapsed = 0
	bar.status:SetMinMaxValues(0, 60)
	bar.status:SetValue(45)

	bar:Show()
end

function module:Test()
	if not anchor then
		return
	end

	if module.testBars and module.testBars[1] and module.testBars[1]:IsShown() then
		for _, bar in ipairs(module.testBars) do
			bar.rollID = nil
			bar:Hide()
		end
		return
	end

	if not module.testBars then
		module.testBars = {}
		for i in ipairs(testItems) do
			local bar = module:CreateBar("Test" .. i)
			tremove(module.RollBars) -- keep test bars out of the real roll bar pool
			bar.isTest = true
			module:LayoutBar(bar)
			tinsert(module.testBars, bar)
		end
	end

	module:StackBars(module.testBars)

	for i, bar in ipairs(module.testBars) do
		PopulateTestBar(bar, testItems[i])

		if module.debug then
			for _, key in ipairs({ "need", "greed", "disenchant", "transmog", "pass" }) do
				local bu = bar[key]
				local tex = bu.normalTex
				local w, h = bu:GetSize()
				print(
					format(
						"|cff33ff99[MLR]|r #%d %s: shown=%s enabled=%s size=%.0fx%.0f alpha=%.2f texture=%s",
						i,
						key,
						tostring(bu:IsShown()),
						tostring(bu:IsEnabled()),
						w,
						h,
						tex and tex:GetAlpha() or -1,
						tex and tex:GetTexture() or "nil"
					)
				)
			end
		end
	end
end

MER:AddCommand("MLR", "/mlr", function()
	module:Test()
end)

MER:AddCommand("MLRDEBUG", "/mlrdebug", function()
	module.debug = not module.debug
	print("|cff33ff99[MLR]|r debug: " .. tostring(module.debug))
end)

--------------------------------------------------------------------
-- Init
--------------------------------------------------------------------
function module:ApplySettings()
	if not module.db.enable then
		return
	end

	module:Layout()
	module:UpdateAnchors()
end

function module:Initialize()
	if type(E.db.mui.lootRoll) ~= "table" then
		E.db.mui.lootRoll = CopyTable(P.lootRoll)
	end
	module.db = E.db.mui.lootRoll

	DisableElvUILootRoll()

	if not module.db.enable then
		return
	end

	anchor = CreateFrame("Frame", "MERLootRollAnchor", E.UIParent)
	anchor:Size(module.db.width, module.db.height)
	anchor:Point("CENTER", E.UIParent, "CENTER", 0, 220)

	E:CreateMover(anchor, "MERLootRollMover", MER.Title .. L["Loot Roll"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, "mui,modules,lootRoll")

	module:CreateBar(1)
	module:Layout()
	module:UpdateAnchors()

	module:RegisterEvent("START_LOOT_ROLL")
	module:RegisterEvent("CANCEL_LOOT_ROLL")
	module:RegisterEvent("CANCEL_ALL_LOOT_ROLLS")
	module:RegisterEvent("ENCOUNTER_END")
	module:RegisterEvent("LOOT_HISTORY_UPDATE_DROP")

	-- Reassert after a delay in case another addon/ElvUI re-registers its
	-- own loot roll handling shortly after login.
	E:Delay(2, DisableElvUILootRoll)
end

MER:RegisterModule(module:GetName())

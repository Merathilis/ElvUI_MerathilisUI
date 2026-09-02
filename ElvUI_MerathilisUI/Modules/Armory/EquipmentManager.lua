local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory") ---@class Armory

local _G = _G
local ipairs, pairs, select = ipairs, pairs, select
local format = string.format
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local C_EquipmentSet = C_EquipmentSet
local C_SpecializationInfo = C_SpecializationInfo

local INCOMPLETE_R, INCOMPLETE_G, INCOMPLETE_B = 0.94, 0.33, 0.31
local ACTIVE_CHECK_R, ACTIVE_CHECK_G, ACTIVE_CHECK_B = 0.071, 0.902, 0.149

local TILE_HEIGHT = 24
local TILE_GAP = 2
local TILE_STEP = TILE_HEIGHT + TILE_GAP

local function GetDB()
	return module.db and module.db.equipmentManager
end

local function GetAccentColor(db)
	if db.useClassColor then
		local classColorMap = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL]
		local classColor = classColorMap and classColorMap[E.myclass]
		if classColor then
			return classColor.r, classColor.g, classColor.b
		end
	end

	local accent = db.accentColor
	return accent.r, accent.g, accent.b
end

local function EquipSet(setID)
	if InCombatLockdown() or not setID then
		return
	end
	if _G.EquipmentManager_EquipSet then
		_G.EquipmentManager_EquipSet(setID)
	else
		C_EquipmentSet.UseEquipmentSet(setID)
	end
end

local function OpenIconPopup(mode, setID, origName)
	if InCombatLockdown() or not _G.GearManagerPopupFrame then
		return
	end
	local popup = _G.GearManagerPopupFrame
	popup.mode = mode
	popup.setID = setID
	popup.origName = origName
	popup:Show()
end

local function MakeTextLink(parent, label, onClick)
	local btn = CreateFrame("Button", nil, parent)
	local fs = btn:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(E.media.normFont, 11, "NONE")
	fs:SetText(label)
	fs:SetTextColor(1, 1, 1, 0.8)
	fs:SetPoint("CENTER", btn, "CENTER", 0, 0)
	btn:SetSize((fs:GetStringWidth() or 30) + 8, 16)
	btn._fs = fs
	btn:SetScript("OnEnter", function()
		fs:SetTextColor(1, 1, 1, 1)
	end)
	btn:SetScript("OnLeave", function()
		fs:SetTextColor(1, 1, 1, 0.8)
	end)
	btn:SetScript("OnClick", onClick)
	return btn
end

function module:BuildEquipmentManagerPanel(pane)
	if self.equipmentPanel then
		return self.equipmentPanel
	end

	local panel = CreateFrame("Frame", "MER_ArmoryEquipmentPanel", pane)
	panel:SetAllPoints(pane)
	panel:SetFrameStrata(pane:GetFrameStrata())
	panel:SetFrameLevel(pane:GetFrameLevel() + 1)
	self.equipmentPanel = panel

	local bg = panel:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetColorTexture(0, 0, 0, 0.6)
	bg:Hide()
	panel.bg = bg

	local header = CreateFrame("Frame", nil, panel)
	header:SetHeight(14)
	header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
	header:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -4)

	local headerText = header:CreateFontString(nil, "OVERLAY")
	WF.SetFontWithDB(headerText, module.db.stats.headerFont)
	headerText:SetText(L["Gear Sets"] or "Gear Sets")
	headerText:SetPoint("CENTER", header, "CENTER", 0, 0)
	panel.headerText = headerText

	local leftLine = header:CreateTexture(nil, "ARTWORK")
	leftLine:SetTexture(E.media.blankTex)
	leftLine:SetHeight(2)
	leftLine:SetPoint("LEFT", header, "LEFT", 3, 0)
	leftLine:SetPoint("RIGHT", headerText, "LEFT", -3, 0)

	local rightLine = header:CreateTexture(nil, "ARTWORK")
	rightLine:SetTexture(E.media.blankTex)
	rightLine:SetHeight(2)
	rightLine:SetPoint("LEFT", headerText, "RIGHT", 3, 0)
	rightLine:SetPoint("RIGHT", header, "RIGHT", -3, 0)
	panel.headerLeftLine, panel.headerRightLine = leftLine, rightLine

	local linksRow = CreateFrame("Frame", nil, panel)
	linksRow:SetHeight(14)
	linksRow:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
	linksRow:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -8)

	local newBtn = MakeTextLink(linksRow, L["New"] or "New", function()
		if InCombatLockdown() then
			return
		end
		OpenIconPopup(_G.IconSelectorPopupFrameModes.New, nil, "")
	end)

	local equipBtn, equipText
	equipBtn = MakeTextLink(linksRow, L["Equip"] or "Equip", function()
		if InCombatLockdown() then
			return
		end
		if panel.selectedSetID then
			EquipSet(panel.selectedSetID)
			panel.activeSetID = panel.selectedSetID
			module:RefreshEquipmentManagerPanel()
		end
	end)
	equipText = equipBtn._fs

	local saveBtn, saveText
	saveBtn = MakeTextLink(linksRow, L["Save"] or "Save", function()
		if InCombatLockdown() then
			return
		end
		if panel.selectedSetID then
			C_EquipmentSet.SaveEquipmentSet(panel.selectedSetID)
			saveText:SetText(L["Saved!"] or "Saved!")
			C_Timer.After(1, function()
				if saveText then
					saveText:SetText(L["Save"] or "Save")
				end
			end)
		end
	end)
	saveText = saveBtn._fs

	newBtn:ClearAllPoints()
	newBtn:SetPoint("LEFT", linksRow, "LEFT", 0, 0)
	equipBtn:ClearAllPoints()
	equipBtn:SetPoint("CENTER", linksRow, "CENTER", 0, 0)
	saveBtn:ClearAllPoints()
	saveBtn:SetPoint("RIGHT", linksRow, "RIGHT", 0, 0)
	panel.saveBtn = saveBtn

	local scrollFrame = CreateFrame("ScrollFrame", nil, panel)
	scrollFrame:SetPoint("TOPLEFT", linksRow, "BOTTOMLEFT", 0, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, 0)
	scrollFrame:EnableMouseWheel(true)

	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollChild:SetPoint("TOPLEFT")
	scrollChild:SetWidth(scrollFrame:GetWidth())
	scrollFrame:SetScrollChild(scrollChild)

	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local current = self:GetVerticalScroll()
		local maxScroll = _G.math.max(0, scrollChild:GetHeight() - self:GetHeight())
		local new = _G.math.max(0, _G.math.min(current - delta * 20, maxScroll))
		self:SetVerticalScroll(new)
	end)

	panel.scrollFrame = scrollFrame
	panel.scrollChild = scrollChild
	panel.tilePool = {}

	return panel
end

local function ShowTileControls(tile, show)
	if show then
		tile._del:Show()
		tile._cog:Show()
	else
		tile._del:Hide()
		tile._cog:Hide()
	end
end

function module:AcquireEquipmentTile(index)
	local panel = self.equipmentPanel
	local tile = panel.tilePool[index]
	if tile then
		return tile
	end

	tile = CreateFrame("Button", nil, panel.scrollChild)
	tile:SetHeight(TILE_HEIGHT)

	tile._bg = tile:CreateTexture(nil, "BACKGROUND")
	tile._bg:SetAllPoints()
	tile._bg:SetColorTexture(1, 1, 1, 0.05)

	tile._selection = tile:CreateTexture(nil, "ARTWORK", nil, -1)
	tile._selection:SetAllPoints()
	tile._selection:Hide()

	tile._hover = tile:CreateTexture(nil, "ARTWORK")
	tile._hover:SetColorTexture(1, 1, 1, 0.12)
	tile._hover:SetAllPoints()
	tile._hover:Hide()

	tile._text = tile:CreateFontString(nil, "OVERLAY")
	tile._text:SetPoint("LEFT", tile, "LEFT", 10, 0)
	tile._text:SetPoint("RIGHT", tile, "RIGHT", -45, 0)
	tile._text:SetJustifyH("LEFT")

	tile._specIcon = tile:CreateTexture(nil, "OVERLAY")
	tile._specIcon:SetSize(16, 16)
	tile._specIcon:SetPoint("RIGHT", tile, "RIGHT", -45, 0)
	tile._specIcon:Hide()

	local cog = CreateFrame("Button", nil, tile)
	cog:SetSize(16, 16)
	cog:SetPoint("RIGHT", tile, "RIGHT", -5, 0)
	local cogTex = cog:CreateTexture(nil, "OVERLAY")
	cogTex:SetTexture([[Interface\WorldMap\GEAR_64GREY]])
	cogTex:SetAllPoints()
	cog:SetAlpha(0.6)
	cog:Hide()
	tile._cog = cog

	local del = CreateFrame("Button", nil, tile)
	del:SetSize(14, 14)
	del:SetPoint("RIGHT", cog, "LEFT", -4, 0)
	local delText = del:CreateFontString(nil, "OVERLAY")
	delText:FontTemplate(E.media.normFont, 12, "NONE")
	delText:SetText("x")
	delText:SetTextColor(1, 1, 1, 0.7)
	delText:SetPoint("CENTER", del, "CENTER", 0, 0)
	del:Hide()
	tile._del = del

	local function IsTileHovered()
		return tile:IsMouseOver() or cog:IsMouseOver() or del:IsMouseOver()
	end

	local function UpdateHoverState()
		if IsTileHovered() then
			tile._hover:Show()
			if tile._setID then
				ShowTileControls(tile, true)
				if GameTooltip:GetOwner() ~= tile or not GameTooltip:IsShown() then
					GameTooltip:Hide()
					GameTooltip:SetOwner(tile, "ANCHOR_RIGHT")
					GameTooltip:SetEquipmentSet(tile._setID)
				end
			end
		else
			tile._hover:Hide()
			ShowTileControls(tile, false)
			if GameTooltip:GetOwner() == tile then
				GameTooltip:Hide()
			end
		end
	end
	tile._updateHoverState = UpdateHoverState

	tile:SetScript("OnUpdate", function(self, elapsed)
		self._hoverPoll = (self._hoverPoll or 0) + elapsed
		if self._hoverPoll < 0.05 then
			return
		end
		self._hoverPoll = 0
		UpdateHoverState()
	end)

	cog:SetScript("OnEnter", function(self)
		self:SetAlpha(1)
		UpdateHoverState()
	end)
	cog:SetScript("OnLeave", function(self)
		self:SetAlpha(0.6)
		C_Timer.After(0, UpdateHoverState)
	end)

	del:SetScript("OnEnter", function()
		delText:SetTextColor(1, 0.2, 0.2, 1)
		UpdateHoverState()
	end)
	del:SetScript("OnLeave", function()
		delText:SetTextColor(1, 1, 1, 0.7)
		C_Timer.After(0, UpdateHoverState)
	end)

	del:SetScript("OnClick", function()
		local setID, setName = tile._setID, tile._setName
		if not setID then
			return
		end
		StaticPopupDialogs["MER_DELETE_EQUIPMENT_SET"] = {
			text = format(L["Delete equipment set '%s'?"] or "Delete equipment set '%s'?", setName),
			button1 = L["Delete"] or "Delete",
			button2 = L["Cancel"] or "Cancel",
			OnAccept = function()
				C_EquipmentSet.DeleteEquipmentSet(setID)
				module:RefreshEquipmentManagerPanel()
			end,
			timeout = 0,
			whileDead = false,
			hideOnEscape = true,
		}
		StaticPopup_Show("MER_DELETE_EQUIPMENT_SET")
	end)

	cog:SetScript("OnClick", function(self)
		local setID, setName = tile._setID, tile._setName
		if not setID then
			return
		end

		local function IsSpecSelected(specIndex)
			return C_EquipmentSet.GetEquipmentSetAssignedSpec(setID) == specIndex
		end
		local function SetSpecSelected(specIndex)
			if InCombatLockdown() then
				return
			end
			if specIndex then
				C_EquipmentSet.AssignSpecToEquipmentSet(setID, specIndex)
			else
				C_EquipmentSet.UnassignEquipmentSetSpec(setID)
			end
			module:RefreshEquipmentManagerPanel()
		end

		_G.MenuUtil.CreateContextMenu(self, function(dropdown, rootDescription)
			rootDescription:CreateButton(L["Change Icon"] or "Change Icon", function()
				OpenIconPopup(_G.IconSelectorPopupFrameModes.Edit, setID, setName)
			end)

			rootDescription:CreateTitle(L["Assign to Spec"] or "Assign to Spec")
			for i = 1, _G.GetNumSpecializations() do
				local specID = C_SpecializationInfo.GetSpecializationInfo(i)
				local specName = select(2, GetSpecializationInfoByID(specID))
				rootDescription:CreateRadio(specName, IsSpecSelected, SetSpecSelected, i)
			end
			rootDescription:CreateRadio(L["Unassigned"] or "Unassigned", function()
				return not C_EquipmentSet.GetEquipmentSetAssignedSpec(setID)
			end, function()
				SetSpecSelected(nil)
			end)
		end)
	end)

	tile:RegisterForDrag("LeftButton")
	tile:SetScript("OnDragStart", function()
		if tile._setID and C_EquipmentSet.PickupEquipmentSet then
			C_EquipmentSet.PickupEquipmentSet(tile._setID)
		end
	end)

	tile._lastClick = 0
	tile:SetScript("OnClick", function()
		local setID = tile._setID
		local panel = module.equipmentPanel
		if not setID then
			OpenIconPopup(_G.IconSelectorPopupFrameModes.New, nil, "")
			return
		end

		panel.selectedSetID = setID
		local now = GetTime()
		if (now - (tile._lastClick or 0)) < 0.4 then
			tile._lastClick = 0
			EquipSet(setID)
			panel.activeSetID = setID
		else
			tile._lastClick = now
		end
		module:RefreshEquipmentManagerPanel()
	end)

	tile:SetScript("OnEnter", tile._updateHoverState)
	tile:SetScript("OnLeave", function()
		C_Timer.After(0, tile._updateHoverState)
	end)

	panel.tilePool[index] = tile
	return tile
end

function module:RefreshEquipmentManagerPanel()
	local db = GetDB()
	local panel = self.equipmentPanel
	if not db or not db.enable or not panel then
		return
	end

	panel.bg:SetShown(db.showBackdrop)

	do
		local statsHeaderFont = module.db.stats.headerFont
		local headerLabel = L["Gear Sets"] or "Gear Sets"

		WF.SetFontWithDB(panel.headerText, statsHeaderFont)

		if statsHeaderFont.headerFontColor == "GRADIENT" then
			panel.headerText:SetText(F.String.FastGradient(headerLabel, 0, 0.9, 1, 0, 0.6, 1))
			F.Color.SetGradientRGB(panel.headerLeftLine, "HORIZONTAL", 0, 0.6, 1, 0, 0, 0.9, 1, 1)
			F.Color.SetGradientRGB(panel.headerRightLine, "HORIZONTAL", 0, 0.9, 1, 1, 0, 0.6, 1, 0)
		elseif statsHeaderFont.headerFontColor == "CLASS" then
			local currentClass = E.myclass
			local classColorMap = E.db.mui.themes.gradientMode.classColorMap
			local classColorNormal = classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
			local classColorShift = classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

			panel.headerText:SetText(F.String.GradientClass(headerLabel))
			F.Color.SetGradientRGB(
				panel.headerLeftLine,
				"HORIZONTAL",
				classColorNormal.r,
				classColorNormal.g,
				classColorNormal.b,
				0,
				classColorShift.r,
				classColorShift.g,
				classColorShift.b,
				1
			)
			F.Color.SetGradientRGB(
				panel.headerRightLine,
				"HORIZONTAL",
				classColorShift.r,
				classColorShift.g,
				classColorShift.b,
				1,
				classColorNormal.r,
				classColorNormal.g,
				classColorNormal.b,
				0
			)
		else
			panel.headerText:SetText(headerLabel)
			WF.SetFontColorWithDB(panel.headerText, statsHeaderFont.color)

			local fontColor = F.GetFontColorFromDB(module.db.stats, "header")
			F.Color.SetGradientRGB(
				panel.headerLeftLine,
				"HORIZONTAL",
				fontColor.r,
				fontColor.g,
				fontColor.b,
				0,
				fontColor.r,
				fontColor.g,
				fontColor.b,
				fontColor.a
			)
			F.Color.SetGradientRGB(
				panel.headerRightLine,
				"HORIZONTAL",
				fontColor.r,
				fontColor.g,
				fontColor.b,
				fontColor.a,
				fontColor.r,
				fontColor.g,
				fontColor.b,
				0
			)
		end
	end

	local scrollWidth = panel.scrollFrame:GetWidth()
	if scrollWidth and scrollWidth > 0 then
		panel.scrollChild:SetWidth(scrollWidth)
	end

	local r, g, b = GetAccentColor(db)

	local setIDs = C_EquipmentSet.GetEquipmentSetIDs() or {}
	local activeSetID = nil
	local sets = {}
	for _, setID in ipairs(setIDs) do
		local name, texture, _, isEquipped, _, _, _, numLost = C_EquipmentSet.GetEquipmentSetInfo(setID)
		if name and name ~= "" then
			sets[#sets + 1] = { id = setID, name = name, texture = texture, numLost = numLost or 0 }
			if isEquipped then
				activeSetID = setID
			end
		end
	end
	panel.activeSetID = activeSetID
	if not panel.selectedSetID and activeSetID then
		panel.selectedSetID = activeSetID
	end

	local yOffset = 0
	for i, setData in ipairs(sets) do
		local tile = self:AcquireEquipmentTile(i)
		tile._setID = setData.id
		tile._setName = setData.name
		tile._incomplete = setData.numLost > 0

		WF.SetFontWithDB(tile._text, db.font)
		tile._text:SetText(setData.name)
		if tile._incomplete then
			tile._text:SetTextColor(INCOMPLETE_R, INCOMPLETE_G, INCOMPLETE_B)
		else
			tile._text:SetTextColor(1, 1, 1, 1)
		end

		if setData.id == activeSetID then
			tile._bg:SetColorTexture(r, g, b, 0.5)
		else
			tile._bg:SetColorTexture(1, 1, 1, 0.05)
		end

		if setData.id == panel.selectedSetID then
			tile._selection:SetColorTexture(r, g, b, 0.18)
			tile._selection:Show()
		else
			tile._selection:Hide()
		end

		local assignedSpec = C_EquipmentSet.GetEquipmentSetAssignedSpec(setData.id)
		if assignedSpec then
			local specID = C_SpecializationInfo.GetSpecializationInfo(assignedSpec)
			local specIcon = specID and select(4, GetSpecializationInfoByID(specID))
			if specIcon then
				tile._specIcon:SetTexture(specIcon)
				tile._specIcon:Show()
			else
				tile._specIcon:Hide()
			end
		else
			tile._specIcon:Hide()
		end

		tile:ClearAllPoints()
		tile:SetPoint("TOPLEFT", panel.scrollChild, "TOPLEFT", 0, -yOffset)
		tile:SetPoint("TOPRIGHT", panel.scrollChild, "TOPRIGHT", 0, -yOffset)
		tile:Show()
		yOffset = yOffset + TILE_STEP
	end

	local newTile = self:AcquireEquipmentTile(#sets + 1)
	newTile._setID = nil
	newTile._setName = nil
	newTile._incomplete = false
	WF.SetFontWithDB(newTile._text, db.font)
	newTile._text:SetText(L["+ New Set"] or "+ New Set")
	newTile._text:SetTextColor(ACTIVE_CHECK_R, ACTIVE_CHECK_G, ACTIVE_CHECK_B)
	newTile._bg:SetColorTexture(1, 1, 1, 0.05)
	newTile._selection:Hide()
	newTile._specIcon:Hide()
	newTile:ClearAllPoints()
	newTile:SetPoint("TOPLEFT", panel.scrollChild, "TOPLEFT", 0, -yOffset)
	newTile:SetPoint("TOPRIGHT", panel.scrollChild, "TOPRIGHT", 0, -yOffset)
	newTile:Show()
	yOffset = yOffset + TILE_STEP

	for i = #sets + 2, #panel.tilePool do
		panel.tilePool[i]:Hide()
	end

	panel.scrollChild:SetHeight(yOffset)

	if panel.selectedSetID then
		local _, _, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(panel.selectedSetID)
		panel.saveBtn:SetAlpha(isEquipped and 0.5 or 1)
	else
		panel.saveBtn:SetAlpha(0.5)
	end
end

function module:EnableEquipmentManagerSkin()
	if self.equipmentManagerSkinned then
		return
	end

	if not GetDB() then
		return
	end

	local pane = _G.PaperDollFrame and _G.PaperDollFrame.EquipmentManagerPane
	if not pane or not pane.ScrollBox then
		return
	end

	self.equipmentManagerSkinned = true

	pane.ScrollBox:Hide()
	if pane.ScrollBar then
		pane.ScrollBar:Hide()
	end
	if pane.EquipSet then
		pane.EquipSet:Hide()
	end
	if pane.SaveSet then
		pane.SaveSet:Hide()
	end

	self:BuildEquipmentManagerPanel(pane)

	pane:HookScript("OnShow", function()
		module:RefreshEquipmentManagerPanel()
	end)

	local refreshPending = false
	local function QueueRefresh()
		if refreshPending then
			return
		end
		refreshPending = true
		C_Timer.After(0.2, function()
			refreshPending = false
			if pane:IsShown() then
				module:RefreshEquipmentManagerPanel()
			end
		end)
	end

	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	eventFrame:RegisterEvent("EQUIPMENT_SWAP_FINISHED")
	eventFrame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	eventFrame:SetScript("OnEvent", QueueRefresh)
end

function module:DisableEquipmentManagerSkin()
	self.equipmentManagerSkinned = false
end

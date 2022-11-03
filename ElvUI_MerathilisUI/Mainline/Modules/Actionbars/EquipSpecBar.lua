local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule('MER_Actionbars')

local _G = _G
local select = select

local CreateFrame = CreateFrame
local C_EquipmentSet = C_EquipmentSet
local GameTooltip_Hide = GameTooltip_Hide
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local InCombatLockdown = InCombatLockdown
local ShowUIPanel = ShowUIPanel
local UIErrorsFrame = UIErrorsFrame
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local PaperDollFrame_SetSidebar = PaperDollFrame_SetSidebar
local SetLootSpecialization = SetLootSpecialization
local SetSpecialization = SetSpecialization

function MAB:CreateSpecBar()
	local db = E.db.mui.actionbars.specBar

	if not db.enable then
		return
	end

	local Spacing, Mult = 4, 1
	local Size = E.db.mui.actionbars.specBar.size or 24

	local specBar = CreateFrame("Frame", nil, E.UIParent)
	specBar:SetFrameStrata(db.frameStrata or "BACKGROUND")
	specBar:SetFrameLevel(db.frameLevel or 1)
	specBar:Size(40, 40)
	specBar:CreateBackdrop("Transparent")
	specBar:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 177)
	specBar.backdrop:Styling()
	specBar:Hide()
	E.FrameLocks[specBar] = true

	specBar.Button = {}
	E:CreateMover(specBar, "MER_SpecializationBarMover", L["SpecializationBarMover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI', nil, 'mui,modules,actionbars')

	specBar:SetScript('OnEnter', function(self) UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	specBar:SetScript('OnLeave', function(self)
		if E.db.mui.actionbars.specBar.mouseover then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	local Specs = GetNumSpecializations()

	for i = 1, Specs do
		local SpecID, SpecName, Description, Icon = GetSpecializationInfo(i)
		local Button = CreateFrame("Button", nil, specBar)
		Button:Size(Size, Size)
		Button:SetID(i)
		Button.SpecID = SpecID
		Button:CreateBackdrop()
		Button:SetFrameLevel(specBar:GetFrameLevel()+1)
		Button:StyleButton()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture(Icon)
		Button:GetPushedTexture():SetInside()
		Button:RegisterForClicks('AnyDown')
		Button:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			_G.GameTooltip:AddLine(SpecName)
			_G.GameTooltip:AddLine(" ")
			_G.GameTooltip:AddLine(Description, 1, 1, 1, true)
			_G.GameTooltip:Show()
		end)
		Button:SetScript("OnLeave", GameTooltip_Hide)
		Button:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				if self:GetID() ~= self.Spec then
					SetSpecialization(self:GetID())
				end
			elseif button == "RightButton" then
				SetLootSpecialization(self.LootID == self.SpecID and 0 or self.SpecID)
			end
		end)
		Button:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		Button:RegisterEvent("PLAYER_ENTERING_WORLD")
		Button:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
		Button:SetScript("OnEvent", function(self)
			self.Spec = GetSpecialization()
			self.LootID = GetLootSpecialization()

			if self.Spec == self:GetID() then
				self.backdrop:SetBackdropBorderColor(0, 0.44, .87)
			elseif (self.LootID == self.SpecID) then
				self.backdrop:SetBackdropBorderColor(1, 0.44, .4)
			else
				self:CreateBackdrop()
			end
		end)
		Button:HookScript('OnEnter', function()
			if specBar:IsShown() then
				UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
			end
		end)
		Button:HookScript('OnLeave', function()
			if specBar:IsShown() and E.db.mui.actionbars.specBar.mouseover then
				UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), 0)
			end
		end)

		Button:SetPoint("LEFT", i == 1 and specBar or specBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)

		specBar.Button[i] = Button
	end

	local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

	specBar:Size(BarWidth, BarHeight)

	if E.db.mui.actionbars.specBar.mouseover then
		UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), 0)
	else
		UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
	end
end

function MAB:CreateEquipBar()
	local db = E.db.mui.actionbars.equipBar

	if not db.enable then
		return
	end

	local Size = E.db.mui.actionbars.equipBar.size or 32

	local GearTexture = "Interface\\WorldMap\\GEAR_64GREY"
	local EquipmentSets = CreateFrame("Frame", nil, E.UIParent)
	EquipmentSets:SetFrameStrata(db.frameStrata or "BACKGROUND")
	EquipmentSets:SetFrameLevel(db.frameLevel or 1)
	EquipmentSets:Size(32, 32)
	EquipmentSets:CreateBackdrop("Transparent")
	EquipmentSets:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 20, 177)
	EquipmentSets.backdrop:Styling()
	EquipmentSets:Hide()
	E.FrameLocks[EquipmentSets] = true

	E:CreateMover(EquipmentSets, "MER_EquipmentSetsBarMover", L["EquipmentSetsBarMover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI', nil, 'mui,modules,actionbars')

	EquipmentSets:SetScript('OnEnter', function(self) UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	EquipmentSets:SetScript('OnLeave', function(self)
		if E.db.mui.actionbars.equipBar.mouseover then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	EquipmentSets.Button = CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Button:SetFrameStrata(EquipmentSets:GetFrameStrata())
	EquipmentSets.Button:SetFrameLevel(EquipmentSets:GetFrameLevel())
	EquipmentSets.Button:CreateBackdrop()
	EquipmentSets.Button:Point("CENTER")
	EquipmentSets.Button:Size(Size-6 , Size-6) -- Ugly solution
	EquipmentSets.Button:SetNormalTexture("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
	EquipmentSets.Button:GetNormalTexture():SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	EquipmentSets.Button:GetNormalTexture():SetInside()
	EquipmentSets.Button:SetPushedTexture("")
	EquipmentSets.Button:SetHighlightTexture("")

	EquipmentSets.Button.Icon = EquipmentSets.Button:CreateTexture(nil, "OVERLAY")
	EquipmentSets.Button.Icon:SetTexCoord(.1, .9, .1, .9)
	EquipmentSets.Button.Icon:SetInside()

	EquipmentSets.Flyout = CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Flyout:SetFrameStrata(EquipmentSets:GetFrameStrata())
	EquipmentSets.Flyout:SetFrameLevel(EquipmentSets:GetFrameLevel()+1)
	EquipmentSets.Flyout:Point("TOP", EquipmentSets, "TOP", 0, 0)
	EquipmentSets.Flyout:Size(23, 11)

	EquipmentSets.Flyout.Arrow = EquipmentSets.Flyout:CreateTexture(nil, "OVERLAY")
	EquipmentSets.Flyout.Arrow:SetAtlas("UI-HUD-ActionBar-Flyout")
	EquipmentSets.Flyout.Arrow:SetAllPoints()
	EquipmentSets.Flyout:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(_G.PAPERDOLL_EQUIPMENTMANAGER)
		_G.GameTooltip:Show()
	end)

	EquipmentSets.Flyout:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Flyout:SetScript("OnClick", function()
		for i = 1, C_EquipmentSet.GetNumEquipmentSets() do
			if EquipmentSets.Button[i]:IsShown() then
				EquipmentSets.Button[i]:Hide()
			else
				if EquipmentSets.Button[i]:GetNormalTexture():GetTexture() ~= GearTexture then
					EquipmentSets.Button[i]:Show()
				end
			end
		end
	end)
	EquipmentSets.Flyout:HookScript("OnEnter", function(self)
		if EquipmentSets:IsShown() then
			UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
		end
	end)
	EquipmentSets.Flyout:HookScript("OnLeave", function(self)
		if EquipmentSets:IsShown() and E.db.mui.actionbars.equipBar.mouseover then
			UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
		end
	end)

	for i = 1, C_EquipmentSet.GetNumEquipmentSets() do
		local Button = CreateFrame("Button", nil, EquipmentSets.Flyout)
		Button:Hide()
		Button:Size(Size, Size)
		Button:CreateBackdrop()
		Button:SetFrameStrata("TOOLTIP")
		Button:SetNormalTexture(GearTexture)
		Button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		Button:GetNormalTexture():SetInside()
		Button:StyleButton()
		Button:Point("BOTTOM", i == 1 and EquipmentSets.Flyout or EquipmentSets.Button[i - 1], "TOP", 0, 3)
		Button:SetScript("OnEnter", function(self)
			local Name = C_EquipmentSet.GetEquipmentSetInfo(self:GetID())
			_G.GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			_G.GameTooltip:SetEquipmentSet(Name)
		end)
		Button:SetScript("OnClick", function(self)
			local _, Icon, Index, IsEquipped = C_EquipmentSet.GetEquipmentSetInfo(self:GetID())
			EquipmentSets.Button:SetID(Index)
			EquipmentSets.Button.Icon:SetTexture(Icon)
			if not IsEquipped then C_EquipmentSet.UseEquipmentSet(self:GetID()) end
			EquipmentSets.Flyout:Click()
		end)
		Button:SetScript("OnLeave", GameTooltip_Hide)
		Button:HookScript("OnEnter", function(self)
			if EquipmentSets:IsShown() then
				UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
			end
		end)
		Button:HookScript("OnLeave", function(self)
			if EquipmentSets:IsShown() and E.db.mui.actionbars.equipBar.mouseover then
				UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
			end
		end)

		EquipmentSets.Button[i] = Button
	end

	EquipmentSets.Button:SetScript("OnClick", function(self)
		if InCombatLockdown() then
			return UIErrorsFrame:AddMessage(_G.ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0);
		end
		if not self:GetID() then
			ShowUIPanel(_G["CharacterFrame"])
			PaperDollFrame_SetSidebar(_G["CharacterFrame"], 3)
			return
		end

		if not select(4, C_EquipmentSet.GetEquipmentSetInfo(self:GetID())) then
			C_EquipmentSet.UseEquipmentSet(self:GetID())
		end
	end)

	EquipmentSets.Button:SetScript("OnEnter", function(self)
		local Name = C_EquipmentSet.GetEquipmentSetInfo(self:GetID())
		if not Name then return end
		_G.GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		_G.GameTooltip:SetEquipmentSet(Name)
	end)
	EquipmentSets.Button:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button:RegisterEvent("PLAYER_ENTERING_WORLD")
	EquipmentSets.Button:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	EquipmentSets.Button:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	EquipmentSets.Button:RegisterUnitEvent('UNIT_INVENTORY_CHANGED', 'player')
	EquipmentSets.Button:SetScript("OnEvent", function(self)
		local Index, SetEquipped = 1
		for i = 1, C_EquipmentSet.GetNumEquipmentSets() do
			local _, Icon, SpecIndex, IsEquipped = C_EquipmentSet.GetEquipmentSetInfo(i - 1)
			self[i]:SetNormalTexture(GearTexture)
			self[i]:SetID(i)
			if SpecIndex then
				self[Index]:SetID(SpecIndex)
				self[Index]:SetNormalTexture(Icon)
				if IsEquipped then
					SetEquipped = IsEquipped
					self:SetID(SpecIndex)
					self.Icon:SetTexture(Icon)
				end
				Index = Index + 1
			end
		end
		if not SetEquipped then
			self.SaveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
			self.SaveButton:Enable()
			self.SaveButton:EnableMouse(true)
		else
			self.SaveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.SaveButton:Disable()
			self.SaveButton:EnableMouse(false)
		end
	end)

	EquipmentSets.Button:HookScript("OnEnter", function(self)
		self.backdrop:SetBackdropBorderColor(0, 0.44, .87)
		if EquipmentSets:IsShown() then
			UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
		end
	end)
	EquipmentSets.Button:HookScript("OnLeave", function(self)
		self:CreateBackdrop()
		if EquipmentSets:IsShown() and E.db.mui.actionbars.equipBar.mouseover then
			UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
		end
	end)

	EquipmentSets.Button.SaveButton = CreateFrame("Button", nil, EquipmentSets.Button)
	EquipmentSets.Button.SaveButton:SetFrameLevel(2)
	EquipmentSets.Button.SaveButton:Size(14, 14)
	EquipmentSets.Button.SaveButton:Point("BOTTOMLEFT", EquipmentSets.Button, "BOTTOMLEFT", 0, 0)
	EquipmentSets.Button.SaveButton.Icon = EquipmentSets.Button.SaveButton:CreateTexture(nil, "ARTWORK")
	EquipmentSets.Button.SaveButton.Icon:SetAllPoints()
	EquipmentSets.Button.SaveButton:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:SetText(_G.SAVE_CHANGES)
	end)
	EquipmentSets.Button.SaveButton:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button.SaveButton:SetScript("OnClick", function(self, button)
		C_EquipmentSet.SaveEquipmentSet(EquipmentSets.Button:GetID())
	end)

	EquipmentSets:SetSize(Size, Size)

	if E.db.mui.actionbars.equipBar.mouseover then
		UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
	else
		UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
	end
end

function MAB:EquipSpecBar()
	self:CreateSpecBar()
	self:CreateEquipBar()
end

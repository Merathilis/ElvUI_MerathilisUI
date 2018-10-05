local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule("mUIActionbars")

--Cache global variables
--Lua functions
local _G = _G
local select = select
--WoW API / Variables
local CreateFrame = CreateFrame
local C_EquipmentSet = C_EquipmentSet
local InCombatLockdown = InCombatLockdown
local ShowUIPanel = ShowUIPanel
local UIErrorsFrame = UIErrorsFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, GameTooltip_Hide, PAPERDOLL_EQUIPMENTMANAGER, ERR_NOT_IN_COMBAT, PaperDollFrame_SetSidebar
-- GLOBALS: SAVE_CHANGES

function MAB:CreateEquipBar()
	if E.db.mui.actionbars.equipBar.enable ~= true then return end

	local GearTexture = "Interface\\WorldMap\\GEAR_64GREY"
	local EquipmentSets = CreateFrame("Frame", "EquipmentSets", E.UIParent)
	EquipmentSets:SetFrameStrata("BACKGROUND")
	EquipmentSets:SetFrameLevel(0)
	EquipmentSets:SetSize(32, 32)
	EquipmentSets:SetTemplate("Transparent")
	EquipmentSets:SetPoint("RIGHT", _G["SpecializationBar"], "LEFT", -1, 0)
	EquipmentSets:Styling()
	EquipmentSets:Hide()
	E.FrameLocks[EquipmentSets] = true

	E:CreateMover(EquipmentSets, "EquipmentSetsBarMover", L["EquipmentSetsBarMover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI')

	EquipmentSets:SetScript('OnEnter', function(self) UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	EquipmentSets:SetScript('OnLeave', function(self)
		if E.db.mui.actionbars.equipBar.mouseover then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	EquipmentSets.Button = CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Button:SetFrameStrata("BACKGROUND")
	EquipmentSets.Button:SetFrameLevel(1)
	EquipmentSets.Button:SetTemplate()
	EquipmentSets.Button:SetPoint("CENTER")
	EquipmentSets.Button:SetSize(24, 24)
	EquipmentSets.Button:SetNormalTexture("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
	EquipmentSets.Button:GetNormalTexture():SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	EquipmentSets.Button:GetNormalTexture():SetInside()
	EquipmentSets.Button:SetPushedTexture("")
	EquipmentSets.Button:SetHighlightTexture("")

	EquipmentSets.Button.Icon = EquipmentSets.Button:CreateTexture(nil, "OVERLAY")
	EquipmentSets.Button.Icon:SetTexCoord(.1, .9, .1, .9)
	EquipmentSets.Button.Icon:SetInside()

	EquipmentSets.Flyout = CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Flyout:SetFrameStrata("BACKGROUND")
	EquipmentSets.Flyout:SetFrameLevel(2)
	EquipmentSets.Flyout:SetPoint("TOP", EquipmentSets, "TOP", 0, 0)
	EquipmentSets.Flyout:SetSize(23, 11)
	EquipmentSets.Flyout.Arrow = EquipmentSets.Flyout:CreateTexture(nil, "OVERLAY", "ActionBarFlyoutButton-ArrowUp")
	EquipmentSets.Flyout.Arrow:SetAllPoints()
	EquipmentSets.Flyout:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(PAPERDOLL_EQUIPMENTMANAGER)
		GameTooltip:Show()
	end)

	EquipmentSets.Flyout:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Flyout:SetScript("OnClick", function()
		for i = 1, 10 do
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

	for i = 1, 10 do
		local Button = CreateFrame("Button", nil, EquipmentSets.Flyout)
		Button:Hide()
		Button:SetSize(24, 24)
		Button:SetTemplate()
		Button:SetFrameStrata("TOOLTIP")
		Button:SetNormalTexture(GearTexture)
		Button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		Button:GetNormalTexture():SetInside()
		Button:SetPoint("BOTTOM", i == 1 and EquipmentSets.Flyout or EquipmentSets.Button[i - 1], "TOP", 0, 3)
		Button:SetScript("OnEnter", function(self)
			local Name = C_EquipmentSet.GetEquipmentSetInfo(self:GetID())
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetEquipmentSet(Name)
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
			return UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0);
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
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetEquipmentSet(Name)
	end)
	EquipmentSets.Button:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button:RegisterEvent("PLAYER_ENTERING_WORLD")
	EquipmentSets.Button:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	EquipmentSets.Button:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	EquipmentSets.Button:RegisterUnitEvent('UNIT_INVENTORY_CHANGED', 'player')
	EquipmentSets.Button:SetScript("OnEvent", function(self)
		local Index, SetEquipped = 1
		for i = 1, 10 do
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
		self:SetBackdropBorderColor(0, 0.44, .87)
		if EquipmentSets:IsShown() then
			UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
		end
	end)
	EquipmentSets.Button:HookScript("OnLeave", function(self)
		self:SetTemplate()
		if EquipmentSets:IsShown() and E.db.mui.actionbars.equipBar.mouseover then
			UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
		end
	end)

	EquipmentSets.Button.SaveButton = CreateFrame("Button", nil, EquipmentSets.Button)
	EquipmentSets.Button.SaveButton:SetFrameLevel(2)
	EquipmentSets.Button.SaveButton:SetSize(14, 14)
	EquipmentSets.Button.SaveButton:SetPoint("BOTTOMLEFT", EquipmentSets.Button, "BOTTOMLEFT", 0, 0)
	EquipmentSets.Button.SaveButton.Icon = EquipmentSets.Button.SaveButton:CreateTexture(nil, "ARTWORK")
	EquipmentSets.Button.SaveButton.Icon:SetAllPoints()
	EquipmentSets.Button.SaveButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(SAVE_CHANGES)
	end)
	EquipmentSets.Button.SaveButton:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button.SaveButton:SetScript("OnClick", function(self, button)
		C_EquipmentSet.SaveEquipmentSet(EquipmentSets.Button:GetID())
	end)

	if E.db.mui.actionbars.equipBar.mouseover then
		UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 0)
	else
		UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
	end
end

function MAB:EquipBarInit()
	self:CreateEquipBar()
end
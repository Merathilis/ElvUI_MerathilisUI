local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule("mUIActionbars")

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local tinsert = table.insert
--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local SetSpecialization = SetSpecialization
local GetLootSpecialization = GetLootSpecialization
local SetLootSpecialization = SetLootSpecialization
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, GameTooltip_Hide

function MAB:CreateSpecBar()
	if E.db.mui.actionbars.specBar.enable ~= true then return end

	local Spacing, Mult = 4, 1
	local Size = E.db.mui.actionbars.specBar.size or 24

	local specBar = CreateFrame("Frame", "SpecializationBar", E.UIParent)
	specBar:SetFrameStrata("BACKGROUND")
	specBar:SetFrameLevel(0)
	specBar:SetSize(40, 40)
	specBar:SetTemplate("Transparent")
	specBar:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 177)
	specBar:Styling()
	specBar:Hide()
	E.FrameLocks[specBar] = true

	specBar.Button = {}
	E:CreateMover(specBar, "SpecializationBarMover", L["SpecializationBarMover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI', nil, 'mui,modules,actionbars')

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
		Button:SetSize(Size, Size)
		Button:SetID(i)
		Button.SpecID = SpecID
		Button:SetTemplate()
		Button:StyleButton()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture(Icon)
		Button:GetPushedTexture():SetInside()
		Button:RegisterForClicks('AnyDown')
		Button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(SpecName)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(Description, 1, 1, 1, true)
			GameTooltip:Show()
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
				self:SetBackdropBorderColor(0, 0.44, .87)
			elseif (self.LootID == self.SpecID) then
				self:SetBackdropBorderColor(1, 0.44, .4)
			else
				self:SetTemplate()
			end
		end)
		Button:HookScript('OnEnter', function(self)
			if specBar:IsShown() then
				UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
			end
		end)
		Button:HookScript('OnLeave', function(self)
			if specBar:IsShown() and E.db.mui.actionbars.specBar.mouseover then
				UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), 0)
			end
		end)

		Button:SetPoint("LEFT", i == 1 and specBar or specBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)

		specBar.Button[i] = Button
	end

	local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

	specBar:SetSize(BarWidth, BarHeight)

	if E.db.mui.actionbars.specBar.mouseover then
		UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), 0)
	else
		UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
	end
end

function MAB:SpecBarInit()
	self:CreateSpecBar()
end

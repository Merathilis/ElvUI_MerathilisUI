local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")

local _G = _G

local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local SetLootSpecialization = SetLootSpecialization
local SetSpecialization = SetSpecialization

function module:CreateSpecBar()
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
	specBar:Hide()
	E.FrameLocks[specBar] = true

	specBar.Button = {}
	E:CreateMover(
		specBar,
		"MER_SpecializationBarMover",
		MER.Title .. L["SpecializationBarMover"],
		nil,
		nil,
		nil,
		"ALL,ACTIONBARS,MERATHILISUI",
		nil,
		"mui,modules,actionbars"
	)

	specBar:SetScript("OnEnter", function(self)
		UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end)
	specBar:SetScript("OnLeave", function(self)
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
		Button:SetFrameLevel(specBar:GetFrameLevel() + 1)
		Button:StyleButton()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture(Icon)
		Button:GetPushedTexture():SetInside()
		Button:RegisterForClicks("AnyDown")
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
				self.backdrop:SetBackdropBorderColor(0, 0.44, 0.87)
			elseif self.LootID == self.SpecID then
				self.backdrop:SetBackdropBorderColor(1, 0.44, 0.4)
			else
				self:CreateBackdrop()
			end
		end)
		Button:HookScript("OnEnter", function()
			if specBar:IsShown() then
				UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
			end
		end)
		Button:HookScript("OnLeave", function()
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

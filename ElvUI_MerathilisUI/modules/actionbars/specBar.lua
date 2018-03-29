local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:GetModule("mUIActionbars")
local BS = E:GetModule("mUIButtonStyle")

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
	if E.db.mui.actionbars.specBar ~= true then return end

	local Spacing, Mult = 4, 1
	local Size = 24

	local specBar = CreateFrame("Frame", "SpecializationBar", E.UIParent)
	specBar:SetFrameStrata("BACKGROUND")
	specBar:SetFrameLevel(0)
	specBar:SetSize(40, 40)
	specBar:SetTemplate("Transparent")
	specBar:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 177)
	specBar:Styling()

	specBar.Button = {}
	E:CreateMover(specBar, "SpecializationBarMover", L["SpecializationBarMover"], true, nil)

	local Specs = GetNumSpecializations()

	for i = 1, Specs do
		local SpecID, SpecName, Description, Icon = GetSpecializationInfo(i)
		local Button = CreateFrame("Button", nil, specBar)
		Button:SetSize(Size, Size)
		Button:SetID(i)
		Button:SetTemplate()
		Button:StyleButton()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		Button:GetNormalTexture():SetInside()
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
				if self:GetID() ~= GetSpecialization() then
					SetSpecialization(self:GetID())
				end
			end
		end)
		Button:SetScript("OnEvent", function(self)
			local Spec = GetSpecialization()
			if Spec == self:GetID() then
				self:SetBackdropBorderColor(0, 0.44, .87)
			else
				self:SetTemplate()
			end
		end)

		Button:SetPoint("LEFT", i == 1 and specBar or specBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)

		specBar.Button[i] = Button
	end

	local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

	specBar:SetSize(BarWidth, BarHeight)

	for _, Button in pairs(specBar.Button) do
		Button:HookScript("OnClick", function(self, button)
			if button == "RightButton" then
				local SpecID = GetSpecializationInfo(self:GetID())
				if (GetLootSpecialization() == SpecID) then
					SpecID = 0
				end
				SetLootSpecialization(SpecID)
			end
		end)
		Button:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		Button:RegisterEvent("PLAYER_ENTERING_WORLD")
		Button:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
		Button:HookScript("OnEvent", function(self)
			if (GetLootSpecialization() == GetSpecializationInfo(self:GetID())) then
				self:SetBackdropBorderColor(1, 0.44, .4)
			end
		end)
		BS:StyleButton(Button)
		BS:StyleBorder(Button)
	end
end

function MAB:SpecBarInit()
	self:CreateSpecBar()
end
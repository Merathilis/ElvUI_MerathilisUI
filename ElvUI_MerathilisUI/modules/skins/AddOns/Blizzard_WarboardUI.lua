local MER, E, L, V, P, G = unpack(select(2, ...))
-- local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, ContributionRewardMixin, ContributionMixin

local function styleWarboard()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.muiSkins.blizzard.warboard ~= true then return end

	local WarboardQuestChoiceFrame = _G["WarboardQuestChoiceFrame"]
	WarboardQuestChoiceFrame:Styling()

	local function WarboardQuestChoiceFrameMixin_Update(self)
		local _, _, numOptions = GetQuestChoiceInfo()

		if (numOptions == 1) then
			local textWidth = self.Title.Text:GetWidth()
			local neededWidth = max(120, (textWidth/2) - 40)

			local newWidth = (neededWidth*2)+430
			self.fixedWidth = max(600, newWidth)
			self.leftPadding = ((self.fixedWidth - self.Option1:GetWidth()) / 2) - 4
			self.Title:SetPoint("LEFT", self.Option1, "LEFT", -neededWidth, 0)
			self.Title:SetPoint("RIGHT", self.Option1, "RIGHT", neededWidth, 0)
		else
			self.fixedWidth = 600
			self.Title:SetPoint("LEFT", self.Option1, "LEFT", -3, 0)
			self.Title:SetPoint("RIGHT", self.Options[numOptions], "RIGHT", 3, 0)
		end
		self:Layout()
	end
	hooksecurefunc(WarboardQuestChoiceFrameMixin, "Update", WarboardQuestChoiceFrameMixin_Update)

	local function WarboardQuestChoiceOptionTemplate(button)
		button.Nail:Hide()
		button.Artwork:ClearAllPoints()
		button.Artwork:SetPoint("TOPLEFT", 31, -31)
		button.Artwork:SetPoint("BOTTOMRIGHT", button, "TOPRIGHT", -31, -112)
		button.Border:Hide()

		button.Header.Background:Hide()
		button.Header.Text:SetTextColor(.9, .9, .9)
		button.OptionText:SetTextColor(.9, .9, .9)

		button:SetSize(240, 332)
		button.OptionButton:SetSize(175, 22)
		button.OptionButton:SetPoint("BOTTOM", 0, 46)
		button.Header.Text:SetWidth(180)
		button.Header.Text:SetPoint("TOP", button.Artwork, "BOTTOM", 0, -21)
		button.OptionText:SetWidth(180)
		button.OptionText:SetPoint("TOP", button.Header.Text, "BOTTOM", 0, -12)
		button.OptionText:SetPoint("BOTTOM", button.OptionButton, "TOP", 0, 39)
		button.OptionText:SetText("Text")
	end

	for _, option in next, WarboardQuestChoiceFrame.Options do
		WarboardQuestChoiceOptionTemplate(option)
	end

	WarboardQuestChoiceFrame.Header:SetSize(354, 105)
	WarboardQuestChoiceFrame.Header:SetPoint("TOP", 0, 72)
	WarboardQuestChoiceFrame.Title:SetSize(500, 85)
end

S:AddCallbackForAddon("Blizzard_WarboardUI", "mUIWarboard", styleWarboard)
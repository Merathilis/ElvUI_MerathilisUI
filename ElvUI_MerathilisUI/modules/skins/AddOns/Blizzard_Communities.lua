local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCommunities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Communities ~= true or E.private.muiSkins.blizzard.communities ~= true then return end

	local CommunitiesFrame = _G["CommunitiesFrame"]
	CommunitiesFrame.backdrop:Styling()

	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", function(self)
		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button.bg then
				button.bg:Hide() -- Hide ElvUI's bg Frame
			end

			if not button.IsSkinned then
				button:GetRegions():Hide()
				button:SetHighlightTexture("")

				button:CreateBackdrop("Transparent")
				button.backdrop:SetPoint("TOPLEFT", 4, -3)
				button.backdrop:SetPoint("BOTTOMRIGHT", -1, 3)
				MERS:CreateGradient(button.backdrop)

				button.IsSkinned = true
			end

			if button.highlight then
				button.highlight:SetInside(button.backdrop)
			end

			if button.Selection then
				button.Selection:SetInside(button.backdrop)
				button.Selection:SetColorTexture(r, g, b, .3)
			end
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:GetRegions():Hide()
		MERS:ReskinIcon(tab.Icon)
		tab:GetHighlightTexture():SetColorTexture(r, g, b, .25)
	end

	-- Chat Tab
	local Dialog = CommunitiesFrame.NotificationSettingsDialog
	Dialog:StripTextures()
	Dialog.BG:Hide()
	Dialog.backdrop:Styling()

	MERS:Reskin(Dialog.OkayButton)
	MERS:Reskin(Dialog.CancelButton)
	MERS:ReskinCheckBox(Dialog.ScrollFrame.Child.QuickJoinButton)
	Dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)
	MERS:Reskin(Dialog.ScrollFrame.Child.AllButton)
	MERS:Reskin(Dialog.ScrollFrame.Child.NoneButton)

	hooksecurefunc(Dialog, "Refresh", function(self)
		local frame = self.ScrollFrame.Child
		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child.StreamName and not child.styled then
				MERS:Reskin(child.ShowNotificationsButton)
				MERS:Reskin(child.HideNotificationsButton)

				child.styled = true
			end
		end
	end)

	local Dialog = CommunitiesFrame.EditStreamDialog
	MERS:CreateBDFrame(Dialog.Description, .25)
	Dialog.backdrop:Styling()

	-- Roster
	MERS:CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)

	local DetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	DetailFrame:ClearAllPoints()
	DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)
	DetailFrame:Styling()

	-- Guild Perks
	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button then
				-- Hide the ElvUI backdrop
				if button.backdrop then
					button.backdrop:Hide()
				end

				-- Reaply Transparent backdrop
				button:CreateBackdrop("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, -1, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", button.Right, 1, -1)
				MERS:CreateGradient(button.backdrop)

				MERS:ReskinIcon(button.Icon, true)
			end
		end
	end)

	-- Guild Rewards
	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button then
				-- Hide the ElvUI backdrop
				if button.backdrop then
					button.backdrop:Hide()
				end

				-- Reaply Transparent backdrop
				button:CreateBackdrop("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, 0, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", 0, 3)
				MERS:CreateGradient(button.backdrop)

				MERS:ReskinIcon(button.Icon, true)
				button.Icon.backdrop:SetOutside(button.Icon, 1, 1)
				button.Icon.backdrop:SetFrameLevel(button.backdrop:GetFrameLevel()+1)

				-- TO DO: ICON QUALITY BORDER
				--hooksecurefunc(button.Icon, "SetVertexColor", function(r, g, b)
					--button.Icon.backdrop:SetBackdropBorderColor(r, g, b)
				--end)
				--hooksecurefunc(button.Icon, "Hide", function()
					--button.Icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
				--end)

				if button.hover then
					button.hover:SetInside(button.backdrop)
					button.hover:SetColorTexture(r, g, b, 0.3)
				end

				button.DisabledBG:Hide()
			end
		end
	end)

	-- Guild Recruitment
	local GuildRecruitmentFrame = _G["CommunitiesGuildRecruitmentFrame"]
	GuildRecruitmentFrame.backdrop:Styling()

	-- Guild Log
	local GuildLog = _G["CommunitiesGuildLogFrame"]
	GuildLog:Styling()

	--Guild MOTD Edit
	local GuildText = _G["CommunitiesGuildTextEditFrame"]
	GuildText:Styling()

	-- Guild News Filter
	local GuildNewsFilter = _G["CommunitiesGuildNewsFiltersFrame"]
	GuildNewsFilter.backdrop:Styling()
end

S:AddCallbackForAddon("Blizzard_Communities", "mUICommunities", styleCommunities)

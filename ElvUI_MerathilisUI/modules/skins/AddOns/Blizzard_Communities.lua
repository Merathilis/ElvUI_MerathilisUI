local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
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

local function styleCommunities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Communities ~= true or E.private.muiSkins.blizzard.communities ~= true then return end

	local CommunitiesFrame = _G["CommunitiesFrame"]
	CommunitiesFrame:StripTextures()
	CommunitiesFrame:Styling()

	MERS:CreateBD(CommunitiesFrame)

	-- Hide ElvUI backdrop
	if CommunitiesFrame.backdrop then
		CommunitiesFrame.backdrop:Hide()
	end

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

				button.bd = MERS:CreateBDFrame(button, 0)
				button.bd:SetPoint("TOPLEFT", 4, -3)
				button.bd:SetPoint("BOTTOMRIGHT", -1, 3)
				MERS:CreateGradient(button.bd)

				button.IsSkinned = true
			end
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:GetRegions():Hide()
		MERS:ReskinIcon(tab.Icon)
		tab:GetHighlightTexture():SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .25)
	end

	-- Chat Tab
	local bg1 = MERS:CreateBDFrame(CommunitiesFrame.Chat.InsetFrame, .25)
	bg1:SetPoint("BOTTOMRIGHT", -1, 22)

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
			if button and button:IsShown() and not button.bg then
				-- Hide the ElvUI backdrop
				if button.backdrop then
					button.backdrop:Hide()
				end
				MERS:ReskinIcon(button.Icon)
				for i = 1, 4 do
					select(i, button:GetRegions()):SetAlpha(0)
				end
				button.bg = MERS:CreateBDFrame(button, .25)
				button.bg:SetPoint("TOPLEFT", button.Icon)
				button.bg:SetPoint("BOTTOMRIGHT", button.Right)
				MERS:Reskin(button.bg)
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
				-- Hide the hover from ElvUI
				if button.hover then
					button.hover:Hide()
				end
				if not button.bg then
					MERS:ReskinIcon(button.Icon)
					select(6, button:GetRegions()):SetAlpha(0)
					select(7, button:GetRegions()):SetAlpha(0)

					button.bg = MERS:CreateBDFrame(button, .25)
					button.bg:SetPoint("TOPLEFT", button.Icon, 0, 1)
					button.bg:SetPoint("BOTTOMRIGHT", 0, 3)
					MERS:Reskin(button.bg)
				end
				button.DisabledBG:Hide()
			end
		end
	end)

	-- Guild Info
	local bg3 = MERS:CreateBDFrame(_G["CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame"], .25)
	bg3:SetPoint("TOPLEFT", 0, 3)
	bg3:SetPoint("BOTTOMRIGHT", -5, -4)

	MERS:CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, .25)

	-- Guild Recruitment
	local GuildRecruitmentFrame = _G["CommunitiesGuildRecruitmentFrame"]
	GuildRecruitmentFrame.backdrop:Styling()

	-- Guild Log
	local GuildLog = _G["CommunitiesGuildLogFrame"]
	GuildLog:Styling()
end

S:AddCallbackForAddon("Blizzard_Communities", "mUICommunities", styleCommunities)
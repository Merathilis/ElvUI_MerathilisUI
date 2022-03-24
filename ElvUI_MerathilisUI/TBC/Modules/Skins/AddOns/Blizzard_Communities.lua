local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local next, select, unpack = next, select, unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.communities ~= true or E.private.muiSkins.blizzard.communities ~= true then return end

	local CommunitiesFrame = _G.CommunitiesFrame
	CommunitiesFrame:Styling()
	MER:CreateBackdropShadow(CommunitiesFrame)
	MER:CreateShadow(CommunitiesFrame.ChatTab)
	MER:CreateShadow(CommunitiesFrame.RosterTab)
	MER:CreateShadow(CommunitiesFrame.GuildBenefitsTab)
	MER:CreateShadow(CommunitiesFrame.GuildInfoTab)
	MER:CreateBackdropShadow(CommunitiesFrame.GuildMemberDetailFrame)
	MER:CreateBackdropShadow(CommunitiesFrame.ClubFinderInvitationFrame)
	if _G.CommunitiesGuildLogFrame then
		MER:CreateBackdropShadow(_G.CommunitiesGuildLogFrame)
	end

	-- Active Communities
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetClubInfo", function(self, clubInfo, isInvitation, isTicket)
		if clubInfo then
			if self.bg and self.bg.backdrop and not self.IsStyled then
				MERS:CreateGradient(self.bg.backdrop)
				self.IsStyled = true
			end
		end
	end)

	-- Add Community Button
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetAddCommunity", function(self)
		if self.bg and self.bg.backdrop and not self.IsStyled then
			MERS:CreateGradient(self.bg.backdrop)
			self.IsStyled = true
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		if tab then
			tab:GetRegions():Hide()
			MERS:ReskinIcon(tab.Icon)
			tab:GetHighlightTexture():SetColorTexture(r, g, b, .25)
		end
	end

	-- Chat Tab
	local Dialog = CommunitiesFrame.NotificationSettingsDialog
	Dialog:StripTextures()
	Dialog.BG:Hide()
	if Dialog.backdrop then
		Dialog.backdrop:Styling()
	end

	MERS:Reskin(Dialog.OkayButton)
	MERS:Reskin(Dialog.CancelButton)
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
	if Dialog.backdrop then
		Dialog.backdrop:Styling()
	end

	-- Roster
	MERS:CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)

	local DetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	if DetailFrame then
		DetailFrame:ClearAllPoints()
		DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)
		DetailFrame:Styling()
	end

	if CommunitiesFrame.RecruitmentDialog and CommunitiesFrame.RecruitmentDialog.backdrop then
		CommunitiesFrame.RecruitmentDialog.backdrop:Styling()
	end

	-- Guild Log
	local GuildLog = _G.CommunitiesGuildLogFrame
	if GuildLog then
		GuildLog:Styling()
	end

	--Guild MOTD Edit
	local GuildText = _G.CommunitiesGuildTextEditFrame
	if GuildText then
		GuildText:Styling()
	end

	-- Guild News Filter
	local GuildNewsFilter = _G.CommunitiesGuildNewsFiltersFrame
	if GuildNewsFilter and GuildNewsFilter.backdrop then
		GuildNewsFilter.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_Communities", "mUICommunities", LoadSkin)

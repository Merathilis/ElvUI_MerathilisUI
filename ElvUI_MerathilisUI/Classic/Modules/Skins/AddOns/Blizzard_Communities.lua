local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local next, unpack = next, unpack
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.communities ~= true or not E.private.mui.skins.blizzard.communities then return end

	local CommunitiesFrame = _G.CommunitiesFrame
	if not CommunitiesFrame.backdrop then
		CommunitiesFrame:CreateBackdrop('Transparent')
		CommunitiesFrame.backdrop:Styling()
	end

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
				module:CreateGradient(self.bg.backdrop)
				self.IsStyled = true
			end
		end
	end)

	-- Add Community Button
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetAddCommunity", function(self)
		if self.bg and self.bg.backdrop and not self.IsStyled then
			module:CreateGradient(self.bg.backdrop)
			self.IsStyled = true
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		if tab then
			tab:GetRegions():Hide()
			module:ReskinIcon(tab.Icon)
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

	Dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)

	local Dialog = CommunitiesFrame.EditStreamDialog
	module:CreateBDFrame(Dialog.Description, .25)
	if Dialog.backdrop then
		Dialog.backdrop:Styling()
	end

	-- Roster
	module:CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)

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

S:AddCallbackForAddon("Blizzard_Communities", LoadSkin)

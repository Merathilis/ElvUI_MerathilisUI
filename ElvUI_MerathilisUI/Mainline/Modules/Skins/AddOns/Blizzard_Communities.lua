local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local gsub, next, select, unpack = gsub, next, select, unpack
local format = string.format
local strmatch = strmatch

local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local cache = {}

local function ModifyGuildNews(button, _, text, name, link, ...)
	if not E.private.mui.misc.guildNewsItemLevel then
		return
	end

	if not link or not strmatch(link, "|H(item:%d+:.-)|h.-|h") then
		return
	end

	if not cache[link] then
		cache[link] = F.GetRealItemLevelByLink(link)
	end

	if cache[link] then
		local coloredItemLevel = format("|cfff1c40f%s|r", cache[link])
		link = gsub(link, "|h%[(.-)%]|h", "|h[" .. coloredItemLevel .. ":%1]|h")
		button.text:SetFormattedText(text, name, link, ...)
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.communities ~= true or E.private.mui.skins.blizzard.communities ~= true then return end

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
		tab:GetRegions():Hide()
		MERS:ReskinIcon(tab.Icon)
		tab:GetHighlightTexture():SetColorTexture(r, g, b, .25)
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
	DetailFrame:ClearAllPoints()
	DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)
	DetailFrame:Styling()

	-- Guild Perks
	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button.backdrop and not button.isStyled then
				button.backdrop:SetTemplate("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, -1, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", button.Right, 1, -1)
				MERS:CreateGradient(button.backdrop)
				button.isStyled = true
			end
		end
	end)

	-- Guild Rewards
	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button.backdrop and not button.isStyled then
				button.backdrop:SetTemplate("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, 0, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", 0, 3)
				MERS:CreateGradient(button.backdrop)

				if button.hover then
					button.hover:SetInside(button.backdrop)
					button.hover:SetColorTexture(r, g, b, 0.3)
				end

				button.DisabledBG:Hide()
				button.isStyled = true
			end
		end
	end)

	if CommunitiesFrame.RecruitmentDialog.backdrop then
		CommunitiesFrame.RecruitmentDialog.backdrop:Styling()
	end

	-- Guild Log
	local GuildLog = _G.CommunitiesGuildLogFrame
	GuildLog:Styling()

	--Guild MOTD Edit
	local GuildText = _G.CommunitiesGuildTextEditFrame
	GuildText:Styling()

	-- Guild News Filter
	local GuildNewsFilter = _G.CommunitiesGuildNewsFiltersFrame
	if GuildNewsFilter.backdrop then
		GuildNewsFilter.backdrop:Styling()
	end

	hooksecurefunc("GuildNewsButton_SetText", ModifyGuildNews)
end

S:AddCallbackForAddon("Blizzard_Communities", "mUICommunities", LoadSkin)

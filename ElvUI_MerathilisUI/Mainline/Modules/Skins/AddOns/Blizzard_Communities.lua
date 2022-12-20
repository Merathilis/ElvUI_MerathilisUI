local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local gsub, next, unpack = gsub, next, unpack
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

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local function ClassIconTexCoord(self, class)
	local tcoords = CLASS_ICON_TCOORDS[class]
	self:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
end

local function UpdateNameFrame(self)
	if not self.expanded then return end
	if not self.bg then
		self.bg = module:CreateBDFrame(self.Class)
	end

	local memberInfo = self:GetMemberInfo()
	if memberInfo and memberInfo.classID then
		local classInfo = C_CreatureInfo.GetClassInfo(memberInfo.classID)
		if classInfo then
			ClassIconTexCoord(self.Class, classInfo.classFile)
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("communities", "communities") then
		return
	end

	local CommunitiesFrame = _G.CommunitiesFrame
	CommunitiesFrame:Styling()
	module:CreateShadow(CommunitiesFrame)
	module:CreateShadow(CommunitiesFrame.ChatTab)
	module:CreateShadow(CommunitiesFrame.RosterTab)
	module:CreateShadow(CommunitiesFrame.GuildBenefitsTab)
	module:CreateShadow(CommunitiesFrame.GuildInfoTab)
	module:CreateBackdropShadow(CommunitiesFrame.GuildMemberDetailFrame)
	module:CreateBackdropShadow(CommunitiesFrame.ClubFinderInvitationFrame)
	if _G.CommunitiesGuildLogFrame then
		module:CreateBackdropShadow(_G.CommunitiesGuildLogFrame)
	end

	-- Add Community Button
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetAddCommunity", function(self)
		if self.bg and self.bg.backdrop and not self.__MERSkin then
			module:CreateGradient(self.bg.backdrop)
			self.__MERSkin = true
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:GetRegions():Hide()
		tab:GetHighlightTexture():SetColorTexture(r, g, b, .25)
	end

	local MemberList = CommunitiesFrame.MemberList
	-- MemberList:CreateBackdrop('Transparent')

	hooksecurefunc(MemberList.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				hooksecurefunc(child, "RefreshExpandedColumns", UpdateNameFrame)
				child.styled = true
			end

			local header = child.ProfessionHeader
			if header and not header.styled then
				for j = 1, 3 do
					select(j, header:GetRegions()):Hide()
				end
				header:CreateBackdrop('Transparent')
				header.backdrop:SetInside()
				header:SetHighlightTexture(E.media.normTex)
				header:GetHighlightTexture():SetVertexColor(r, g, b, .25)
				header:GetHighlightTexture():SetInside(header.backdrop)
				header.Icon:CreateBackdrop()

				header.styled = true
			end

			if child and child.bg then
				child.bg:SetShown(child.Class:IsShown())
			end
		end
	end)

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

	local DetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	DetailFrame:ClearAllPoints()
	DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)
	DetailFrame:Styling()

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

	local BossModel = _G.CommunitiesFrameGuildDetailsFrameNews.BossModel
	module:CreateShadow(BossModel)
	module:CreateShadow(BossModel.TextFrame)
end

S:AddCallbackForAddon("Blizzard_Communities", LoadSkin)

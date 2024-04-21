local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local next, unpack = next, unpack

local C_CreatureInfo_GetClassInfo = C_CreatureInfo.GetClassInfo
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local function ClassIconTexCoord(self, class)
	local tcoords = CLASS_ICON_TCOORDS[class]
	self:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)
end

local function UpdateNameFrame(self)
	if not self.expanded then
		return
	end
	if not self.bg then
		self.bg = module:CreateBDFrame(self.Class)
	end

	local memberInfo = self:GetMemberInfo()
	if memberInfo and memberInfo.classID then
		local classInfo = C_CreatureInfo_GetClassInfo(memberInfo.classID)
		if classInfo then
			ClassIconTexCoord(self.Class, classInfo.classFile)
		end
	end
end

function module:Blizzard_Communities()
	if not module:CheckDB("communities", "communities") then
		return
	end

	local CommunitiesFrame = _G.CommunitiesFrame
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

	for _, name in next, { "ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab" } do
		local tab = CommunitiesFrame[name]
		tab:GetRegions():Hide()
		tab:GetHighlightTexture():SetColorTexture(r, g, b, 0.25)
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
				header:CreateBackdrop("Transparent")
				header.backdrop:SetInside()
				header:SetHighlightTexture(E.media.normTex)
				header:GetHighlightTexture():SetVertexColor(r, g, b, 0.25)
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
	Dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)

	local Dialog = CommunitiesFrame.EditStreamDialog
	module:CreateBDFrame(Dialog.Description, 0.25)

	local DetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	DetailFrame:ClearAllPoints()
	DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)

	hooksecurefunc(CommunitiesFrame.GuildBenefitsFrame.Rewards.ScrollBox, "Update", function(button)
		for _, child in next, { button.ScrollTarget:GetChildren() } do
			if not child.IsSkinned then
				S:HandleIcon(child.Icon, true)
				child:StripTextures()
				child:CreateBackdrop("Transparent")
				child.backdrop:ClearAllPoints()
				child.backdrop:Point("TOPLEFT", child.Icon.backdrop)
				child.backdrop:Point("BOTTOMLEFT", child.Icon.backdrop)
				child.backdrop:SetWidth(child:GetWidth() - 5)
				child.IsSkinned = true
			end

			if not child.__MERSkin then
				child.backdrop:ClearAllPoints()
				child.backdrop:Point("TOPLEFT", child.Icon.backdrop, -7, 5)
				child.backdrop:Point("BOTTOMLEFT", child.Icon.backdrop, -7, -5)
				child.backdrop:SetWidth(child:GetWidth() + 9)
				child.__MERSkin = true
			end
		end
	end)

	local BossModel = _G.CommunitiesFrameGuildDetailsFrameNews.BossModel
	module:CreateShadow(BossModel)
	module:CreateShadow(BossModel.TextFrame)
end

module:AddCallbackForAddon("Blizzard_Communities")

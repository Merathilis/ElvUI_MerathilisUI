local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

local AnimateTexCoords = AnimateTexCoords
local hooksecurefunc = hooksecurefunc
local CreateColor = CreateColor
local GetWhoInfo = C_FriendList.GetWhoInfo

function FriendsCount_OnLoad(self)
	self:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FriendsCount_OnEvent(event, ...)
	local bnetCount = BNGetNumFriends()
	_G.MER_FriendsCounter:SetText(bnetCount .. "|cff416380/200|r")
end

local function ReskinFriendButton(button)
	if button.right then
		return
	end

	button.right = button:CreateTexture(nil, "BACKGROUND")
	button.right:Width(button:GetWidth() / 2)
	button.right:Height(32)
	button.right:Point("LEFT", button, "CENTER", 0)
	button.right:SetTexture(E.Media.Textures.White8x8)
	button.right:SetGradient("HORIZONTAL", CreateColor(0.243, 0.57, 1, 0), CreateColor(0.243, 0.57, 1, 0.25))

	if button.gameIcon then
		button.gameIcon:HookScript("OnShow", function()
			button.right:Show()
		end)

		button.gameIcon:HookScript("OnHide", function()
			button.right:Hide()
		end)

		if button.gameIcon:IsShown() then
			button.right:Show()
		else
			button.right:Hide()
		end
	end
end

local function ClassColor(class, showRGB)
	local color = F.ClassColors[F.ClassList[class] or class]

	if not color then
		color = F.ClassColors["PRIEST"]
	end

	if showRGB then
		return color.r, color.g, color.b
	else
		return "|c" .. color.colorStr
	end
end

local function DiffColor(level)
	return F.HexRGB(GetQuestDifficultyColor(level))
end

local function ReskinPartyButton(button)
	if button.__MERSkin then
		return
	end

	button:Width(button:GetWidth() - 4)

	module:Proxy("HandleButton", button)

	local normal = button:GetNormalTexture()
	normal:SetTexture(I.Media.Icons.Plus)
	normal:SetTexCoord(0, 1, 0, 1)
	normal:Size(14)
	normal:ClearAllPoints()
	normal:Point("CENTER")
	normal:SetVertexColor(1, 1, 1, 1)

	local disabled = button:GetDisabledTexture()
	disabled:SetTexture(I.Media.Icons.Plus)
	disabled:SetTexCoord(0, 1, 0, 1)
	disabled:Size(14)
	disabled:ClearAllPoints()
	disabled:Point("CENTER")
	disabled:SetVertexColor(0.4, 0.4, 0.4, 1)
	disabled:SetDesaturated(true)

	F.Move(button, -3, 0)

	button.__MERSkin = true
end

local function ReskinRecentAllyButton(button)
	local normal = button:GetNormalTexture()
	normal:SetTexture(E.media.blankTex)
	normal:Width(button:GetWidth() / 2)
	normal:Height(button:GetHeight() - 2)
	normal:Point("LEFT", button, "CENTER", 0)
	normal:SetGradient("HORIZONTAL", CreateColor(0.243, 0.57, 1, 0), CreateColor(0.243, 0.57, 1, 0.25))

	if not button.__MERSkin then
		local highlight = button:GetHighlightTexture()
		highlight:SetTexture(E.media.blankTex)
		highlight:SetVertexColor(0.243, 0.57, 1, 0.2)
		highlight:SetInside(button)

		F.InternalizeMethod(highlight, "SetTexture", true)
		F.InternalizeMethod(highlight, "SetVertexColor", true)

		button:HookScript("OnEnter", function()
			highlight:Show()
		end)

		button:HookScript("OnLeave", function()
			highlight:Hide()
		end)
	end

	ReskinPartyButton(button.PartyButton)

	button.__MERSkin = true
end

local function UpdateRewards()
	for tab in _G.RecruitAFriendRewardsFrame.rewardTabPool:EnumerateActive() do
		if not tab.__MERSkin then
			module:CreateBackdropShadow(tab)
			local relativeTo = select(2, tab:GetPoint(1))
			if relativeTo and relativeTo == _G.RecruitAFriendRewardsFrame then
				F.Move(tab, 4, 0)
			end
			tab.__MERSkin = true
		end
	end
end

function module:FriendsFrame()
	if not module:CheckDB("friends", "friends") then
		return
	end

	local FriendsFrame = _G.FriendsFrame

	_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:ClearAllPoints()
	_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:Point("TOPLEFT", FriendsFrame, "TOPRIGHT", 3, -1)

	local frames = {
		FriendsFrame,
		_G.FriendsFriendsFrame,
		_G.AddFriendFrame,
		_G.RecruitAFriendFrame.SplashFrame,
		_G.RecruitAFriendRewardsFrame,
		_G.RecruitAFriendRecruitmentFrame,
		_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame,
		_G.FriendsFrameBattlenetFrame.BroadcastFrame,
		_G.QuickJoinRoleSelectionFrame,
	}

	for _, frame in pairs(frames) do
		module:CreateShadow(frame)
	end

	for i = 1, 4 do
		module:ReskinTab(_G["FriendsFrameTab" .. i])
	end

	-- Animated Icon
	_G.FriendsFrameIcon:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 0, 0)
	_G.FriendsFrameIcon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Bnet]])
	_G.FriendsFrameIcon:SetSize(36, 36)
	_G.FriendsFrameIcon:Show()

	hooksecurefunc(_G.FriendsFrameIcon, "SetTexture", function(self, texture)
		if texture ~= [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Bnet]] then
			self:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Bnet]])
		end
	end)
	_G.FriendsListFrame:HookScript("OnShow", function()
		_G.FriendsFrameIcon:SetAlpha(1)
	end)
	_G.FriendsListFrame:HookScript("OnHide", function()
		_G.FriendsFrameIcon:SetAlpha(0)
	end)
	FriendsFrame:HookScript("OnUpdate", function(self, elapsed)
		AnimateTexCoords(_G.FriendsFrameIcon, 512, 256, 64, 64, 25, elapsed, 0.01)
	end)

	self:SecureHook("FriendsFrame_UpdateFriendButton", ReskinFriendButton)

	local RecentAlliesFrame = _G.RecentAlliesFrame
	if RecentAlliesFrame and RecentAlliesFrame.List and RecentAlliesFrame.List.ScrollBox then
		self:SecureHook(RecentAlliesFrame.List.ScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(ReskinRecentAllyButton)
		end)
	end

	self:SecureHook(_G.RecruitAFriendRewardsFrame, "UpdateRewards", UpdateRewards)
	UpdateRewards()

	-- Who Frame
	local columnTable = {
		["zone"] = "",
		["guild"] = "",
		["race"] = "",
	}

	local currentType = "zone"
	hooksecurefunc(C_FriendList, "SortWho", function(sortType)
		currentType = sortType
	end)

	hooksecurefunc(_G.WhoFrame.ScrollBox, "Update", function(self)
		local playerZone = GetRealZoneText()
		local playerGuild = GetGuildInfo("player")
		local playerRace = UnitRace("player")

		for i = 1, self.ScrollTarget:GetNumChildren() do
			local button = select(i, self.ScrollTarget:GetChildren())

			local nameText = button.Name
			local levelText = button.Level
			local variableText = button.Variable

			local info = GetWhoInfo(button.index)
			local guild, level, race, zone, class =
				info.fullGuildName, info.level, info.raceStr, info.area, info.filename
			if zone == playerZone then
				zone = "|cff00ff00" .. zone
			end
			if guild == playerGuild then
				guild = "|cff00ff00" .. guild
			end
			if race == playerRace then
				race = "|cff00ff00" .. race
			end

			columnTable.zone = zone or ""
			columnTable.guild = guild or ""
			columnTable.race = race or ""

			nameText:SetTextColor(ClassColor(class, true))
			levelText:SetText(DiffColor(level) .. level)
			variableText:SetText(columnTable[currentType])
		end
	end)
end

module:AddCallback("FriendsFrame")

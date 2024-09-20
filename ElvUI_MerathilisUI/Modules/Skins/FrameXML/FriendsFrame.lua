local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local C = MER.Utilities.Color

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

local function UpdateFriendsButton(button)
	if not button.right then
		button.right = button:CreateTexture(nil, "BACKGROUND")
		button.right:SetWidth(button:GetWidth() / 2)
		button.right:SetHeight(32)
		button.right:SetPoint("LEFT", button, "CENTER", 0)
		button.right:SetTexture(E.LSM:Fetch("statusbar", E.media.normTex))
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
	return C.HexRGB(GetQuestDifficultyColor(level))
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

	module:SecureHook("FriendsFrame_UpdateFriendButton", UpdateFriendsButton)

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

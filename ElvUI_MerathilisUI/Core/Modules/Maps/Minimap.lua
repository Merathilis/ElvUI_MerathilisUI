local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Minimap')
local S = MER:GetModule('MER_Skins')
local LCG = LibStub('LibCustomGlow-1.0')

local _G = _G
local select, unpack = select, unpack
local format = string.format

local C_Calendar_GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local GetInstanceInfo = GetInstanceInfo
local Minimap = _G.Minimap
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:CheckStatus()
	if not Minimap.backdrop or not E.db.mui.maps.minimap.flash then return end

	local inv = C_Calendar_GetNumPendingInvites()
	local mailFrame = _G.MinimapCluster.MailFrame or _G.MiniMapMailFrame
	local mail = mailFrame:IsShown() and true or false


	if inv > 0 and mail then -- New invites and mail
		LCG.PixelGlow_Start(Minimap.backdrop, {1, 0, 0, 1}, 8, -0.25, nil, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		LCG.PixelGlow_Start(Minimap.backdrop, {1, 1, 0, 1}, 8, -0.25, nil, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		LCG.PixelGlow_Start(Minimap.backdrop, {r, g, b, 1}, 8, -0.25, nil, 1)
	else -- None of the above
		LCG.PixelGlow_Stop(Minimap.backdrop)
	end
end

function module:MinimapCombatCheck()
	if not Minimap.backdrop then return end

	if not E.db.mui.CombatAlert.minimapAlert then
		return
	end

	local anim = Minimap.backdrop:CreateAnimationGroup()
	Minimap.backdrop:SetFrameStrata("BACKGROUND")
	anim:SetLooping("BOUNCE")

	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(.8)
	anim.fader:SetToAlpha(.2)
	anim.fader:SetDuration(1)
	anim.fader:SetSmoothing("OUT")

	local function UpdateMinimapAnim(event)
		if event == "PLAYER_REGEN_DISABLED" then
			Minimap.backdrop:SetBackdropBorderColor(1, 0, 0)
			anim:Play()
		elseif not InCombatLockdown() then
			anim:Stop()
			Minimap.backdrop:SetBackdropBorderColor(0, 0, 0)
		end
	end
	MER:RegisterEvent("PLAYER_REGEN_ENABLED", UpdateMinimapAnim)
	MER:RegisterEvent("PLAYER_REGEN_DISABLED", UpdateMinimapAnim)
end

function module:StyleMinimap()
	S:CreateBackdropShadow(Minimap)
end

function module:StyleMinimapRightClickMenu()
	-- Style the ElvUI's MiddleClick-Menu on the Minimap
	local Menu = _G.MinimapRightClickMenu
	if Menu then
		Menu:Styling()
	end
end

local function ReplaceFlag(self)
	self:SetTexture(MER.Media.Textures.flag)
end

local function ReskinDifficulty(frame)
	frame.Border:Hide()
	ReplaceFlag(frame.Background)
	hooksecurefunc(frame.Background, "SetAtlas", ReplaceFlag)
end

function module:InstanceDifficulty()
	local instDifficulty = _G.MinimapCluster.InstanceDifficulty
	if instDifficulty then
		instDifficulty:SetParent(Minimap)

		ReskinDifficulty(instDifficulty.Instance)
		ReskinDifficulty(instDifficulty.Guild)
		ReskinDifficulty(instDifficulty.ChallengeMode)
	end
end

function module:Initialize()
	if not E.private.general.minimap.enable then return end

	local db = E.db.mui.maps

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
	end

	self:StyleMinimap()
	self:StyleMinimapRightClickMenu()

	if E.Retail then
		self:InstanceDifficulty()
	end

	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckStatus")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckStatus")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckStatus")

	self:MinimapCombatCheck()
	self:MinimapPing()
end

MER:RegisterModule(module:GetName())

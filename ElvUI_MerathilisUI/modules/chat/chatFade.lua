local MER, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiChat")

--Cache global variables
--Lua Variables
local _G = _G
local pairs = pairs
--WoW API / Variables
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

local channelNumbers = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
}

local function HideChatPanel()
	if not E.db[_G.LeftChatToggleButton.parent:GetName()..'Faded'] then
		_G.HideLeftChat()
	end
	if not E.db[_G.RightChatToggleButton.parent:GetName()..'Faded'] then
		_G.HideRightChat()
	end
end

function module:HideChatFade()
	E:UIFrameFadeOut(self.fadeParent, 0.2, self.fadeParent:GetAlpha(), E.db.mui.chat.chatFade.minAlpha)
end

function module:ShowChatFade()
	self.timeout = 0
	E:UIFrameFadeOut(self.fadeParent, 0.2, self.fadeParent:GetAlpha(), 1)
end

local function CheckCursorPosition()
	local UIScale = _G.UIParent:GetScale()
	local x, y = GetCursorPosition()
	x = x/UIScale
	y = y/UIScale

	local IsOnLeftPanel = ( x > _G.LeftChatPanel:GetLeft() and x < _G.LeftChatPanel:GetLeft() + _G.LeftChatPanel:GetWidth() ) and ( y > _G.LeftChatPanel:GetBottom() and y < _G.LeftChatPanel:GetBottom() + _G.LeftChatPanel:GetHeight() )
	local IsOnRightPanel = ( x > _G.RightChatPanel:GetLeft() and x < _G.RightChatPanel:GetLeft() + _G.RightChatPanel:GetWidth() ) and ( y > _G.RightChatPanel:GetBottom() and y < _G.RightChatPanel:GetBottom() + _G.RightChatPanel:GetHeight() )

	return IsOnLeftPanel or IsOnRightPanel
end

function module:OnUpdate(elapsed)
	if CheckCursorPosition() then
		self:ShowChatFade()
		return
	end

	if not InCombatLockdown() and not self.editboxforced then
		self.timeout = self.timeout + elapsed
		if self.timeout > E.db.mui.chat.chatFade.timeout then
			self:HideChatFade()
		end
	end
end

function module:LoadChatFade()
	self.fadeParent = CreateFrame("Frame", nil, _G.UIParent)
	self.fadeParent:SetAlpha(1 - E.db.mui.chat.chatFade.minAlpha)
	self.fadeParent:SetFrameStrata("BACKGROUND")
	self.timeout = 0
	self:Configure_ChatFade()
end

function module:OnEditFocusGained()
	self.editboxforced = true
	self:ShowChatFade()
end

function module:OnEditFocusLost()
	self.editboxforced = false
end

function module:Configure_ChatFade()
	if E.db.mui.chat.chatFade.enable then
		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local frame = _G[frameName]
			local editbox = _G[frameName.."EditBox"]
			self:SecureHook(frame, "AddMessage", "ShowChatFade")
			self:HookScript(editbox, "OnEditFocusGained", "OnEditFocusGained")
			self:HookScript(editbox, "OnEditFocusLost", "OnEditFocusLost")
		end

		self:RegisterEvent("PLAYER_REGEN_DISABLED", "ShowChatFade")
		self.chatFadeTimer = self:ScheduleRepeatingTimer("OnUpdate", 0.5, 0.5)
		_G.LeftChatPanel:SetParent(self.fadeParent)
		_G.RightChatPanel:SetParent(self.fadeParent)
		_G.LeftChatToggleButton:SetParent(self.fadeParent)
		_G.RightChatToggleButton:SetParent(self.fadeParent)
	else
		self:ShowChatFade()

		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local frame = _G[frameName]
			local editbox = _G[frameName.."EditBox"]
			self:Unhook(frame, "AddMessage")
			self:Unhook(editbox, "OnEditFocusGained")
			self:Unhook(editbox, "OnEditFocusLost")
		end

		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:CancelTimer(self.chatFadeTimer)
		_G.LeftChatPanel:SetParent(E.UIParent)
		_G.RightChatPanel:SetParent(E.UIParent)
		_G.LeftChatToggleButton:SetParent(E.UIParent)
		_G.RightChatToggleButton:SetParent(E.UIParent)
	end
end

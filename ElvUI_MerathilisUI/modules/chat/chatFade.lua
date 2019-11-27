local MER, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiChat")

--Cache global variables
--Lua Variables
local _G = _G
local pairs = pairs
--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

function module:HideChatFade()
	E:UIFrameFadeOut(self.fadeParent, 0.2, self.fadeParent:GetAlpha(), E.db.mui.chat.chatFade.minAlpha)
end

function module:ShowChatFade()
	self.timeout = 0
	E:UIFrameFadeOut(self.fadeParent, 0.2, self.fadeParent:GetAlpha(), 1)
end

function module:OnUpdate(elapsed)
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
			if not self:IsHooked(frame, "AddMessage") then
				self:SecureHook(frame, "AddMessage", "ShowChatFade")
			end
			if not self:IsHooked(editbox, "OnEditFocusGained") then
				self:HookScript(editbox, "OnEditFocusGained", "OnEditFocusGained")
			end
			if not self:IsHooked(editbox, "OnEditFocusLost") then
				self:HookScript(editbox, "OnEditFocusLost", "OnEditFocusLost")
			end
		end

		self:RegisterEvent("PLAYER_REGEN_DISABLED", "ShowChatFade")
		if not self.chatFadeTimer then
			self.chatFadeTimer = self:ScheduleRepeatingTimer("OnUpdate", 0.5, 0.5)
		end
		if not self:IsHooked(_G.LeftChatPanel, "OnEnter") then
			self:HookScript(_G.LeftChatPanel, "OnEnter", "ShowChatFade")
		end
		if not self:IsHooked(_G.RightChatPanel, "OnEnter") then
			self:HookScript(_G.RightChatPanel, "OnEnter", "ShowChatFade")
		end
		_G.LeftChatPanel:SetParent(self.fadeParent)
		_G.RightChatPanel:SetParent(self.fadeParent)
		_G.LeftChatToggleButton:SetParent(self.fadeParent)
		_G.RightChatToggleButton:SetParent(self.fadeParent)
	else
		self:ShowChatFade()

		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local frame = _G[frameName]
			local editbox = _G[frameName.."EditBox"]
			if self:IsHooked(frame, "AddMessage") then
				self:Unhook(frame, "AddMessage")
			end
			if self:IsHooked(editbox, "OnEditFocusGained") then
				self:Unhook(editbox, "OnEditFocusGained")
			end
			if self:Unhook(editbox, "OnEditFocusLost") then
				self:Unhook(editbox, "OnEditFocusLost")
			end
		end

		if self.chatFadeTimer then
			self:CancelTimer(self.chatFadeTimer)
			self.chatFadeTimer = nil
		end
		if self:IsHooked(_G.LeftChatPanel, "OnEnter") then
			self:Unhook(_G.LeftChatPanel, "OnEnter")
		end
		if self:IsHooked(_G.RightChatPanel, "OnEnter") then
			self:Unhook(_G.RightChatPanel, "OnEnter")
		end
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		
		_G.LeftChatPanel:SetParent(E.UIParent)
		_G.RightChatPanel:SetParent(E.UIParent)
		_G.LeftChatToggleButton:SetParent(E.UIParent)
		_G.RightChatToggleButton:SetParent(E.UIParent)
	end
end

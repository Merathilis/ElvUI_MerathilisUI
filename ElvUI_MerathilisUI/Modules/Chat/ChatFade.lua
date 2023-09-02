local MER, F, E, _, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_ChatFade')

local _G = _G
local pairs = pairs

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown

function module:HideChatFade()
	local fadeOutTime = E.db.mui.chat.chatFade.fadeOutTime or 0.65

	E:UIFrameFadeOut(module.fadeParent, fadeOutTime, module.fadeParent:GetAlpha(), E.db.mui.chat.chatFade.minAlpha)
end

function module:ShowChatFade()
	module.timeout = 0

	E:UIFrameFadeOut(module.fadeParent, 0.2, module.fadeParent:GetAlpha(), 1)
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
		module:ShowChatFade()
		return
	end

	if not InCombatLockdown() and not module.editboxforced then
		module.timeout = module.timeout + elapsed
		if module.timeout > E.db.mui.chat.chatFade.timeout then
			module:HideChatFade()
		end
	end
end

function module:OnEditFocusGained()
	module.editboxforced = true
	module:ShowChatFade()
end

function module:OnEditFocusLost()
	module.editboxforced = false
end

function module:Configure_ChatFade()
	local db = E.db.mui.chat.chatFade

	if db and db.enable then
		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local frame = _G[frameName]
			local editbox = _G[frameName.."EditBox"]

			if not module:IsHooked(frame, "AddMessage") then
				module:SecureHook(frame, "AddMessage", "ShowChatFade")
			end

			if not module:IsHooked(editbox, "OnEditFocusGained") then
				module:HookScript(editbox, "OnEditFocusGained", "OnEditFocusGained")
			end

			if not module:IsHooked(editbox, "OnEditFocusLost") then
				module:HookScript(editbox, "OnEditFocusLost", "OnEditFocusLost")
			end
		end

		module:RegisterEvent("PLAYER_REGEN_DISABLED", "ShowChatFade")

		if not module.chatFadeTimer then
			module.chatFadeTimer = module:ScheduleRepeatingTimer("OnUpdate", 0.1, 0.1)
		end

		_G.LeftChatPanel:SetParent(module.fadeParent)
		_G.RightChatPanel:SetParent(module.fadeParent)
		_G.LeftChatToggleButton:SetParent(module.fadeParent)
		_G.RightChatToggleButton:SetParent(module.fadeParent)
	else
		module:ShowChatFade()

		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local frame = _G[frameName]
			local editbox = _G[frameName.."EditBox"]

			if module:IsHooked(frame, "AddMessage") then
				module:Unhook(frame, "AddMessage")
			end

			if module:IsHooked(editbox, "OnEditFocusGained") then
				module:Unhook(editbox, "OnEditFocusGained")
			end

			if module:Unhook(editbox, "OnEditFocusLost") then
				module:Unhook(editbox, "OnEditFocusLost")
			end
		end

		if module.chatFadeTimer then
			module:CancelTimer(module.chatFadeTimer)
			module.chatFadeTimer = nil
		end

		module:UnregisterEvent("PLAYER_REGEN_DISABLED")

		_G.LeftChatPanel:SetParent(E.UIParent)
		_G.RightChatPanel:SetParent(E.UIParent)
		_G.LeftChatToggleButton:SetParent(E.UIParent)
		_G.RightChatToggleButton:SetParent(E.UIParent)
	end
end

function module:Initialize()
	module.db = E.db.mui.chat.chatFade
	if not module.db and module.db.enable then
		return
	end

	module.fadeParent = CreateFrame("Frame", "MER_ChatFade", _G.UIParent)
	module.fadeParent:SetAlpha(1 - (E.db.mui.chat.chatFade.minAlpha or 0))
	module.fadeParent:SetFrameStrata("BACKGROUND")
	module.timeout = 0

	E:Delay(0.5, function()
		module:Configure_ChatFade()
	end)
end

MER:RegisterModule(module:GetName())

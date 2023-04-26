local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E.Skins
local WS = MER.Modules.WidgetSkin
module.Widgets = WS

local abs = abs
local pcall = pcall
local pairs, type = pairs, type
local strlower = strlower
local wipe = wipe

local currentAnimation = {
	frame = nil,
	group = nil,
	Wipe = function(self)
		self.frame = nil
		self.group = nil
	end,
	WipeIfMatched = function(self, frame, group)
		if frame and self.frame == frame or group and self.group == group then
			self:Wipe()
		end
	end,
	Update = function(self, frame, group)
		if self.frame and self.group then
			if self.frame ~= frame or self.group ~= group then
				self.frame.MERAnimation.fire(self.frame, "ANIMATION_LEAVE")
			end
		end
		self.frame = frame
		self.group = group
	end
}

local animationFunctions = {
	fade = {
		update = function(self, direction, fromAlpha, toAlpha, duration)
			self:SetFromAlpha(fromAlpha)
			self:SetToAlpha(toAlpha)
			self:SetSmoothing(direction)
			self:SetDuration(duration)
		end
	}
}

function WS.IsUglyYellow(...)
	local r, g, b = ...
	return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function WS.Animation(texture, aType, duration, data)
	local aType = strlower(aType)
	local group = texture:CreateAnimationGroup()

	if aType == "fade" then
		local alpha = data

		local anim = group:CreateAnimation("Alpha")
		group.anim = anim

		anim.Update = animationFunctions[aType].update

		-- Set the default status is waiting to play enter animation
		anim.isEnterMode = true
		anim:Update("in", 0, alpha, duration)

		group:SetScript("OnPlay", function()
			texture:SetAlpha(anim:GetFromAlpha())
		end)

		group:SetScript("OnFinished", function(self)
			texture:SetAlpha(anim:GetToAlpha())
			if not group.anim.isEnterMode then
				currentAnimation:WipeIfMatched(nil, self)
			end
		end)

		function group:ForcePlay(callBack, ...)
			if self:IsPlaying() then
				self:Pause()
				pcall(callBack, ...)
				self:Restart()
			else
				pcall(callBack, ...)
				self:Play()
			end
		end

		function group:StopInstant()
			if self:IsPlaying() then
				self:Stop()
			end

			texture:SetAlpha(0)
		end

		local function updateAlphaAnimation(isEnterMode)
			if isEnterMode then
				local remainingProgress = anim.isEnterMode and (1 - anim:GetProgress()) or anim:GetProgress()
				anim:Update("in", alpha * (1 - remainingProgress), alpha, remainingProgress * duration)
			else
				local remainingProgress = anim.isEnterMode and anim:GetProgress() or (1 - anim:GetProgress())
				anim:Update("out", alpha * remainingProgress, 0, remainingProgress * duration)
			end

			anim.isEnterMode = isEnterMode
		end

		local resultTable = {}
		resultTable.bg = texture
		resultTable.group = group

		function resultTable.onEnter(frame)
			resultTable.onStatusChange(frame)

			if not texture:IsShown() then
				return
			end

			group:ForcePlay(updateAlphaAnimation, true)
			currentAnimation:Update(frame, group)
		end

		function resultTable.onLeave(frame)
			if not texture:IsShown() then
				return
			end
			group:ForcePlay(updateAlphaAnimation, false)
		end

		function resultTable.onStatusChange(frame)
			if frame.IsEnabled and frame:IsEnabled() then
				texture:Show()
			else
				texture:Hide()
			end
		end

		function resultTable.fire(frame, event)
			if frame.IsEnabled and not frame:IsEnabled() then
				return group:StopInstant()
			end

			if event == "ANIMATION_LEAVE" then
				resultTable.onLeave(frame)
			end
		end

		return resultTable
	elseif aType == "scale" then
	-- TODO: Scale animation
	end
end

function WS:Ace3_RegisterAsWidget(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "Button" or widgetType == "Button-ElvUI" then
		self:HandleButton(nil, widget)
	end
end

function WS:Ace3_RegisterAsContainer(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "TreeGroup" then
		self:HandleTreeGroup(widget)
	end
end

WS:SecureHook(S, "Ace3_RegisterAsWidget")
WS:SecureHook(S, "Ace3_RegisterAsContainer")

WS.LazyLoadTable = {}

function WS:IsReady()
	return E.private and E.private.mui and E.private.mui.skins and E.private.mui.skins.widgets
end

function WS:RegisterLazyLoad(frame, func)
	if not frame then
		self:Log("debug", "frame is nil.")
		return
	end

	if type(func) ~= "function" then
		if self[func] and type(self[func]) == "function" then
			func = self[func]
		else
			self:Log("debug", func .. " is not a function.")
			return
		end
	end

	self.LazyLoadTable[frame] = func
end

function WS:LazyLoad()
	for frame, func in pairs(self.LazyLoadTable) do
		if frame and func then
			pcall(func, self, frame)
		end
	end

	wipe(self.LazyLoadTable)
end

function WS:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:LazyLoad()
end

WS:RegisterEvent("PLAYER_ENTERING_WORLD")

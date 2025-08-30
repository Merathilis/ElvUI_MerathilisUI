local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = module.Widgets

local _G = _G
local pairs = pairs
local min = min
local max = max

-- Animation Manager
local manager = { frame = nil, group = nil }

function manager:Drop()
	self.frame = nil
	self.group = nil
end

function manager:DropIfMatched(frame, group)
	if frame and self.frame == frame or group and self.group == group then
		self:Drop()
	end
end

function manager:SetCurrent(frame, group)
	if self.frame and self.frame ~= frame or self.group and self.group ~= group then
		E:Delay(0.01, self.frame.MERAnimation.OnEvent, self.frame.MERAnimation, "ANIMATION_LEAVE")
	end
	self.frame = frame
	self.group = group
end

-- Shared Animation Methods
local animationParent = { fade = {} }
local animationGroups = { fade = {} }
local animations = { fade = {} }

local function CreateAnimation(texture, aType)
	local group = _G.CreateAnimationGroup(texture)
	group.anim = group:CreateAnimation(aType)

	local parent = { __MERAnimTex = texture, __MERAnimGroup = group }

	if animationGroups[aType] then
		for k, v in pairs(animationGroups[aType]) do
			group:SetScript(k, v)
		end
	end

	if animationGroups[aType] then
		for k, v in pairs(animations[aType]) do
			group.anim[k] = v
		end
	end

	if animationParent[aType] then
		for k, v in pairs(animationParent[aType]) do
			parent[k] = v
		end
	end

	return parent, group, group.anim
end

-- Fade Animation
function animations.fade:CompletelyReset()
	self.StartAlpha = 0
	self.EndAlpha = self.maxAlpha
	self.EndAlphaSetting = self.EndAlpha
	self.Change = self.EndAlpha - self.StartAlpha
	self:SetEasing(self.inEase)
	self.Timer = 0
	self.isEnterMode = true
end

function animations.fade:Switch(isEnterMode)
	local elapsed = min(max(0, self:GetProgressByTimer()), self.totalDuration)
	self.Timer = isEnterMode == self.isEnterMode and elapsed or (self.totalDuration - elapsed)
	self.StartAlpha = isEnterMode and 0 or self.maxAlpha
	self.EndAlpha = isEnterMode and self.maxAlpha or 0
	self.EndAlphaSetting = self.EndAlpha
	self.Change = self.EndAlpha - self.StartAlpha
	self:SetEasing(isEnterMode and self.inEase or self.outEase)
	self.isEnterMode = isEnterMode
end

function animationGroups.fade:OnFinished()
	if not self.anim.isEnterMode then
		manager:DropIfMatched(nil, self)
	end
end

function animationParent.fade.SafeIsEnabled(frame)
	return frame.IsEnabled and frame:IsEnabled()
end

function animationParent.fade.OnStatusChange(frame)
	frame.__MERAnimTex:SetShown(frame:SafeIsEnabled())
	if frame.__MERAnimTex:IsShown() then
		if frame.__MERAnimationIsTab and not frame.__MERAnimationIsSelected then
			frame.__MERAnimGroup:Stop(false)
			frame.__MERAnimGroup.anim:CompletelyReset()
			frame.__MERAnimGroup.anim:Reset()
			manager:DropIfMatched(frame, frame.__MERAnimGroup)
		end
	end
end

function animationParent.fade.OnEnter(frame)
	animationParent.fade.OnStatusChange(frame)

	if not frame.__MERAnimTex:IsShown() then
		return
	end

	local group, anim = frame.__MERAnimGroup, frame.__MERAnimGroup.anim
	if group:IsPlaying() then
		group:Pause()
	end

	anim:Switch(true)
	group:Play()

	manager:SetCurrent(frame, group)
end

function animationParent.fade.OnLeave(frame)
	local group, anim = frame.__MERAnimGroup, frame.__MERAnimGroup.anim

	if not frame.__MERAnimTex:IsShown() then
		group:Stop(false)
		group.anim:CompletelyReset()
		group.anim:Reset()
		return
	end

	if group:IsPlaying() then
		group:Pause()
	end

	anim:Switch(false)
	group:Play()
end

function animationParent.fade.OnEvent(frame, event)
	if not frame or not event then
		return
	end

	if event == "ANIMATION_LEAVE" then
		animationParent.fade.OnLeave(frame)
	end
end

function WS.Animation(texture, data)
	local parent, group, anim = CreateAnimation(texture, data.type)

	if data.type == "fade" then
		texture:SetAlpha(0)
		anim.totalDuration = data.duration
		anim.maxAlpha = data.alpha
		anim.inEase = "in-" .. data.fadeEase
		anim.outEase = "out-" .. data.fadeEase
		if data.fadeEaseInvert then
			anim.inEase, anim.outEase = anim.outEase, anim.inEase
		end

		-- Initialize
		anim:SetDuration(anim.totalDuration)
		anim:CompletelyReset()
		return parent
	elseif data.type == "scale" then
		-- TODO: Scale animation
	end
end

function WS.SetAnimationMetadata(parent, MERAnimation)
	parent.__MERAnimTex = MERAnimation.__MERAnimTex
	parent.__MERAnimGroup = MERAnimation.__MERAnimGroup
	parent.SafeIsEnabled = MERAnimation.SafeIsEnabled
end

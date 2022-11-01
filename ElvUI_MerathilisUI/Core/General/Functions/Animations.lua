local MER, F, E, L, V, P, G = unpack(select(2, ...))
F.Animation = {}
local A = F.Animation

function A.CreateAnimationFrame(name, parent, strata, level, hidden, texture, isMirror)
	parent = parent or E.UIParent

	local frame = CreateFrame("Frame", name, parent)

	if strata then
		frame:SetFrameStrata(strata)
	end

	if level then
		frame:SetFrameLevel(level)
	end

	if hidden then
		frame:SetAlpha(0)
		frame:Hide()
	end

	if texture then
		local tex = frame:CreateTexture()
		tex:SetTexture(texture)

		if isMirror then
			local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = tex:GetTexCoord() -- 沿 y 轴翻转素材
			tex:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
		end

		tex:SetAllPoints()
		frame.texture = tex
	end

	return frame
end

function A.CreateAnimationGroup(frame, name)
	if not frame then
		F.Developer.LogDebug("Animation.CreateAnimationGroup: frame not found")
		return
	end

	name = name or "anime"

	local animationGroup = frame:CreateAnimationGroup()
	frame[name] = animationGroup

	return animationGroup
end

function A.AddTranslation(animationGroup, name)
	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		return
	end
	if not name then
		F.Developer.LogDebug("Animation.AddTranslation: name not found")
		return
	end

	local animation = animationGroup:CreateAnimation("Translation")
	animation:SetParent(animationGroup)
	animationGroup[name] = animation
end

function A.AddFadeIn(animationGroup, name)
	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.AddFadeIn: animation group not found")
		return
	end

	if not name then
		F.Developer.LogDebug("Animation.AddFadeIn: name not found")
		return
	end

	local animation = animationGroup:CreateAnimation("Alpha")
	animation:SetFromAlpha(0)
	animation:SetToAlpha(1)
	animation:SetSmoothing("IN")
	animation:SetParent(animationGroup)
	animationGroup[name] = animation
end

function A.AddFadeOut(animationGroup, name)
	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.AddFadeOut: animation group not found")
		return
	end

	if not name then
		F.Developer.LogDebug("Animation.AddFadeOut: name not found")
		return
	end

	local animation = animationGroup:CreateAnimation("Alpha")
	animation:SetFromAlpha(1)
	animation:SetToAlpha(0)
	animation:SetSmoothing("OUT")
	animation:SetParent(animationGroup)
	animationGroup[name] = animation
end

function A.AddScale(animationGroup, name, fromScale, toScale)
	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.AddScale: animation group not found")
		return
	end

	if not name then
		F.Developer.LogDebug("Animation.AddScale: name not found")
		return
	end

	if not fromScale or type(fromScale) ~= "table" or getn(fromScale) < 2 then
		F.Developer.LogDebug("Animation.AddScale: invalid fromScale (x, y)")
		return
	end

	if not toScale or type(toScale) ~= "table" or getn(toScale) < 2 then
		F.Developer.LogDebug("Animation.AddScale: invalid toScale (x, y)")
		return
	end

	local animation = animationGroup:CreateAnimation("Scale")
	animation:SetScaleFrom(unpack(fromScale))
	animation:SetScaleTo(unpack(toScale))
	animation:SetParent(animationGroup)
	animationGroup[name] = animation
end

function A.PlayAnimationOnShow(frame, animationGroup)
	if not animationGroup or type(animationGroup) == "string" then
		animationGroup = frame[animationGroup]
	end

	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.PlayAnimationOnShow: animation group not found")
		return
	end

	frame:SetScript("OnShow", function()
		animationGroup:Play()
	end)
end

function A.CloseAnimationOnHide(frame, animationGroup, callback)
	if not animationGroup or type(animationGroup) == "string" then
		animationGroup = frame[animationGroup]
	end

	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.CloseAnimationOnHide: animation group not found")
		return
	end

	animationGroup:SetScript("OnFinished", function()
		frame:Hide()
		if callback then
			callback()
		end
	end)
end

function A.SpeedAnimationGroup(animationGroup, speed)
	if not speed or type(speed) ~= "number" then
		F.Developer.LogDebug("Animation.SpeedAnimationGroup: speed not found")
		return
	end

	if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
		F.Developer.LogDebug("Animation.SpeedAnimationGroup: animation group not found")
		return
	end

	if not animationGroup.GetAnimations then
		F.Developer.LogDebug("Animation.SpeedAnimationGroup: animation not found")
		return
	end

	local durationTimer = 1 / speed

	for _, animation in pairs({animationGroup:GetAnimations()}) do
		if not animation.originalDuration then
			animation.originalDuration = animation:GetDuration()
		end
		if not animation.originalStartDelay then
			animation.originalStartDelay = animation:GetStartDelay()
		end
		animation:SetDuration(animation.originalDuration * durationTimer)
		animation:SetStartDelay(animation.originalStartDelay * durationTimer)
	end
end

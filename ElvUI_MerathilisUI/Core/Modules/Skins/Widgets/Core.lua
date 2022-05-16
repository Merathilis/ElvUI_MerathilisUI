local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local abs = abs
local strlower = strlower

function module.EnterAnimation(frame)
	if not frame:IsEnabled() or not frame.merAnimated then
		return
	end

	if not frame.selected then
		if frame.merAnimated.bgOnLeave:IsPlaying() then
			frame.merAnimated.bgOnLeave:Stop()
		end
		frame.merAnimated.bgOnEnter:Play()
	end
end

function module.LeaveAnimation(frame)
	if not frame:IsEnabled() or not frame.merAnimated then
		return
	end

	if not frame.selected then
		if frame.merAnimated.bgOnEnter:IsPlaying() then
			frame.merAnimated.bgOnEnter:Stop()
		end
		frame.merAnimated.bgOnLeave:Play()
	end
end

function module.IsUglyYellow(...)
	local r, g, b = ...
	return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function module.CreateAnimation(texture, aType, direction, duration, data)
	local aType = strlower(aType)
	local group = texture:CreateAnimationGroup()
	local event = direction == "in" and "OnPlay" or "OnFinished"

	local startAlpha = data and data[1] or (direction == "in" and 0 or 1)
	local endAlpha = data and data[2] or (direction == "in" and 1 or 0)

	if aType == "fade" then
		group.anim = group:CreateAnimation("Alpha")
		group.anim:SetFromAlpha(startAlpha)
		group.anim:SetToAlpha(endAlpha)
		group.anim:SetSmoothing(direction == "in" and "IN" or "OUT")
		group.anim:SetDuration(duration)
	elseif aType == "scale" then
	end

	if group.anim then
		group:SetScript(event, function()
			texture:SetAlpha(endAlpha)
		end)
		group.anim:SetDuration(duration)

		return group
	end
end
local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local floor = floor
-- WoW API / Variables
local GetTime = GetTime
-- GLOBALS:

-- Hook to ElvUI's cooldown module

local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.2 --the minimum scale we want to show cooldown counts at, anything below this will be hidden -- CHANGED
local MIN_DURATION = 1.5 --the minimum duration to show cooldown text for

function E:Cooldown_OnUpdate(elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	if not E:Cooldown_IsEnabled(self) then
		E:Cooldown_StopTimer(self)
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0.05 then
			if self.parent.hideText or (self.fontScale and (self.fontScale < MIN_SCALE)) then
				self.text:SetText('')
				self.nextUpdate = 500
			else
				local timeColors, timeThreshold = (self.timerOptions and self.timerOptions.timeColors) or E.TimeColors, (self.timerOptions and self.timerOptions.timeThreshold) or E.db.cooldown.threshold
				if not timeThreshold then timeThreshold = E.TimeThreshold end

				local hhmmThreshold = (self.timerOptions and self.timerOptions.hhmmThreshold) or (E.db.cooldown.checkSeconds and E.db.cooldown.hhmmThreshold)
				local mmssThreshold = (self.timerOptions and self.timerOptions.mmssThreshold) or (E.db.cooldown.checkSeconds and E.db.cooldown.mmssThreshold)

				local value1, formatid, nextUpdate, value2 = E:GetTimeInfo(remain, timeThreshold, hhmmThreshold, mmssThreshold)
				self.nextUpdate = nextUpdate
				self.text:SetFormattedText(("%s%s|r"):format(timeColors[formatid], E.TimeFormats[formatid][2]), value1, value2)
			end
		else
			E:Cooldown_StopTimer(self)
		end
	end
end

function E:Cooldown_OnSizeChanged(cd, width, force)
	local fontScale = width and (floor(width + .5) / ICON_SIZE)

	if fontScale and (fontScale == cd.fontScale) and (force ~= true) then return end
	cd.fontScale = fontScale

	if fontScale and (fontScale < MIN_SCALE) then
		cd:Hide()
	else
		local text = cd.text or cd.time
		if text then
			local useCustomFont = (cd.timerOptions and cd.timerOptions.fontOptions and cd.timerOptions.fontOptions.enable) and E.Libs.LSM:Fetch("font", cd.timerOptions.fontOptions.font)
			if useCustomFont then
				text:FontTemplate(useCustomFont, (fontScale * cd.timerOptions.fontOptions.fontSize), cd.timerOptions.fontOptions.fontOutline)
			elseif fontScale then
				text:FontTemplate(nil, (fontScale * FONT_SIZE), 'OUTLINE')
			end
		end

		if cd.enabled and (force ~= true) then
			self:Cooldown_ForceUpdate(cd)
		end
	end
end

function E:Cooldown_ForceUpdate(cd)
	cd.nextUpdate = -1

	if cd.fontScale and (cd.fontScale >= MIN_SCALE) then
		cd:Show()
	end
end

function E:OnSetCooldown(start, duration)
	if (not self.forceDisabled) and (start and duration) and (duration > MIN_DURATION) then
		local timer = self.timer or E:CreateCooldownTimer(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = -1

		if timer.fontScale and (timer.fontScale >= MIN_SCALE) then
			timer:Show()
		end
	elseif self.timer then
		E:Cooldown_StopTimer(self.timer)
	end
end

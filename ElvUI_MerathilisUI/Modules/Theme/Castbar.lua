local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local select = select
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer

function module:GetCastbarColor(frame, unit, castFailed, duration, maxDuration)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if unit == "vehicle" then
		unit = "player"
	end

	local interruptCD
	local canInterruptInTime = false
	local hasInterruptCD = false
	-- notInterruptible is secret in Midnight, cannot check it at all
	local canInterrupt = true
	local channeling = frame.channeling

	if unit and (self.db.interruptCDEnabled or self.db.interruptSoonEnabled) then
		hasInterruptCD = false

		if canInterrupt and (unit ~= "player") and (UnitCanAttack("player", unit)) then
			interruptCD = F.CanInterrupt()
			if interruptCD > 0 then
				hasInterruptCD = true
			end
		end
	end

	if self.db.interruptSoonEnabled and hasInterruptCD and unit then
		interruptCD = interruptCD or F.CanInterrupt()

		if interruptCD > 0 then
			if channeling then
				canInterruptInTime = (interruptCD + 0.3) < duration
			else
				canInterruptInTime = (interruptCD + 0.3) < (maxDuration - duration)
			end
		end
	end

	local useClassColor, colorEntry

	if castFailed then
		colorEntry = "INTERRUPTED"
	elseif hasInterruptCD and canInterruptInTime then
		colorEntry = "INTERRUPTSOON"
	elseif hasInterruptCD and not canInterruptInTime then
		colorEntry = "INTERRUPTCD"
	elseif
		not canInterrupt
		and unit
		and (UnitIsPlayer(unit) or (unit ~= "player" and UnitCanAttack("player", unit)))
	then
		colorEntry = "NOINTERRUPT"
	elseif frame.classColorFallback and (unit and UnitIsPlayer(unit)) then
		colorEntry = select(2, UnitClass(unit))
		useClassColor = true
	else
		colorEntry = "DEFAULT"
	end

	local colorMap = useClassColor and "classColorMap" or "castColorMap"
	if useClassColor and self.db[colorMap][I.Enum.GradientMode.Color.NORMAL][colorEntry] == nil then
		colorEntry = "DEFAULT"
		colorMap = "castColorMap"
	end

	return colorMap, colorEntry
end

function module:PostUpdateCastColor(frame, castFailed)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if not frame.__owner.unit and not frame.unit then
		return
	end

	local eR, eG, eB = frame:GetStatusBarColor()
	local unit = frame.unit or frame.__owner.unit
	if unit == "vehicle" then
		unit = "player"
	end

	local customColor = frame.db and frame.db.castbar and frame.db.castbar.customColor
	local custom = customColor and customColor.enable and customColor
	frame.classColorFallback = (custom and custom.useClassColor) or (not custom and self.uf.db.colors.castClassColor)

	-- Cast duration is secret in Midnight, use fixed percentage
	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	if not frame._gradColorFuncOk then
		frame._gradColorFuncOk = F.Event.GenerateClosure(self.GetCastbarColor, self, frame, unit, false)
		frame._gradColorFuncFail = F.Event.GenerateClosure(self.GetCastbarColor, self, frame, unit, true)
	end
	self:SetGradientColors(
		frame,
		valueChanged,
		nil,
		nil,
		nil,
		true,
		castFailed and frame._gradColorFuncFail or frame._gradColorFuncOk
	)
end

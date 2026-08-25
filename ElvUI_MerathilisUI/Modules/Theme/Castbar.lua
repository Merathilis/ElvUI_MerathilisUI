local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local select = select
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer

function module:GetCastbarColor(frame, unit, castFailed)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if unit == "vehicle" then
		unit = "player"
	end

	local notInterruptible = E:NotSecretValue(frame.notInterruptible) and frame.notInterruptible
	local isPlayer = unit and UnitIsPlayer(unit)
	local canAttack = unit and unit ~= "player" and UnitCanAttack("player", unit)
	local useClassColor, colorEntry

	if castFailed then
		colorEntry = "INTERRUPTED"
	elseif
		notInterruptible
		and unit
		and ((E:NotSecretValue(isPlayer) and isPlayer) or (E:NotSecretValue(canAttack) and canAttack))
	then
		colorEntry = "NOINTERRUPT"
	elseif frame.classColorFallback and unit and E:NotSecretValue(isPlayer) and isPlayer then
		local classToken = select(2, UnitClass(unit))
		if E:NotSecretValue(classToken) then
			colorEntry = classToken
			useClassColor = true
		else
			colorEntry = "DEFAULT"
		end
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
	if not frame.__owner.unit and not frame.__unit then
		return
	end

	local eR, eG, eB = frame:GetStatusBarColor()
	local unit = frame.__unit or frame.__owner.unit
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

	local colorFunc = F.Event.GenerateClosure(self.GetCastbarColor, self, frame, unit, castFailed)
	self:SetGradientColors(frame, valueChanged, nil, nil, nil, true, colorFunc)
end

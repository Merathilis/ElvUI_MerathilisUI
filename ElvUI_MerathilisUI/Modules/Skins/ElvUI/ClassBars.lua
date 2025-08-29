local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local UF = E:GetModule("UnitFrames")

local function reskinClassBar(_, frame)
	local classBar = frame[frame.ClassBar]
	if classBar then
		module:CreateBackdropShadow(classBar)
	end

	local additionalPowerBar = frame.AdditionalPower
	if additionalPowerBar then
		module:CreateBackdropShadow(additionalPowerBar)
	end
end

function module:ElvUI_ClassBars()
	if not E.private.unitframe.enable then
		return
	end

	if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
		return
	end

	self:SecureHook(UF, "Configure_ClassBar", reskinClassBar)
end

module:AddCallback("ElvUI_ClassBars")

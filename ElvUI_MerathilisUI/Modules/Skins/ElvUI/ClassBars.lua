local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')

local _G = _G

function module:ElvUI_UnitFrames_SkinClassBar(_, frame)
	local bar = frame[frame.ClassBar]
	self:CreateBackdropShadow(bar)
end

function module:ElvUI_ClassBars()
	if not E.private.unitframe.enable then
		return
	end

	if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
		return
	end

	self:SecureHook(UF, "Configure_ClassBar", "ElvUI_UnitFrames_SkinClassBar")
end

module:AddCallback("ElvUI_ClassBars")

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Auras")
local S = MER:GetModule("MER_Skins")
local A = E:GetModule("Auras")

function module:Auras_SkinIcon(_, button)
	if not button.__MERSkin then
		S:CreateLowerShadow(button)
		S:BindShadowColorWithBorder(button.MERshadow, button)
		button.__MERSkin = true
	end
end

function module:Auras_Shadow()
	if not E.private.mui.skins.shadow and not E.private.mui.skins.shadow.enable then
		return
	end

	self:SecureHook(A, "UpdateAura", "Auras_SkinIcon")
	self:SecureHook(A, "UpdateTempEnchant", "Auras_SkinIcon")
end

function module:Initialize()
	self:Auras_Shadow()
end

MER:RegisterModule(module:GetName())

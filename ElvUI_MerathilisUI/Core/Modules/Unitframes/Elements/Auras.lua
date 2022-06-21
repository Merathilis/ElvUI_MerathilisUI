local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E.UnitFrames
local S = MER.Modules.Skins

function module:ElvUI_PostUpdateDebuffs(uf, _, button)
	if uf.isNameplate then
		return
	end

	if not button.__MERSkin then
		S:CreateLowerShadow(button)
		S:BindShadowColorWithBorder(button.shadow, button)
		button.__MERSkin = true
	end
end

function module:LoadAuras()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.auras ~= true then return end

	-- Auras
	self:SecureHook(UF, "PostUpdateAura", "ElvUI_PostUpdateDebuffs")
end


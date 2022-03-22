local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Auras')
local A = E:GetModule("Auras")

local _G = _G

function module:Auras_SkinIcon(_, button)
	MER:CreateShadow(button)
end

function module:Auras_Shadow()
	self:SecureHook(A, "CreateIcon", "Auras_SkinIcon")
	self:SecureHook(A, "UpdateAura", "Auras_SkinIcon")
	self:SecureHook(A, "UpdateTempEnchant", "Auras_SkinIcon")
end

function module:Initialize()
	self:Auras_Shadow()
end

MER:RegisterModule(module:GetName())

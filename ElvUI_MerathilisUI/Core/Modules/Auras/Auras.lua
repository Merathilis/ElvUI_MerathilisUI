local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Auras')
local S = MER:GetModule('MER_Skins')
local A = E:GetModule("Auras")

local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemQualityColor = GetItemQualityColor

function module:Auras_CreateIcon(_, button)
	S:CreateLowerShadow(button)
end

function module:Auras_UpdateAura(_, button)
	S:CreateLowerShadow(button)

	local r, g, b

	if button.debuffType and (not button.debuffTypeWT or button.debuffTypeWT ~= button.debuffType) then
		local color = button.filter == "HARMFUL" and A.db.colorDebuffs and _G.DebuffTypeColor[button.debuffType]
		button.debuffTypeWT = button.debuffType

		if color then
			r, g, b = color.r, color.g, color.b
		end
	end

	S:UpdateShadowColor(button.shadow, r, g, b)
end

function module:Auras_UpdateTempEnchant(_, button, index, expiration)
	S:CreateLowerShadow(button)

	local r, g, b

	if expiration then
		local quality = A.db.colorEnchants and GetInventoryItemQuality("player", index)

		if quality and quality > 1 then
			r, g, b = GetItemQualityColor(quality)
		end
	end

	S:UpdateShadowColor(button.shadow, r, g, b)
end

function module:Auras_Shadow()
	self:SecureHook(A, "CreateIcon", "Auras_CreateIcon")
	self:SecureHook(A, "UpdateAura", "Auras_UpdateAura")
	self:SecureHook(A, "UpdateTempEnchant", "Auras_UpdateTempEnchant")
end

function module:Initialize()
	self:Auras_Shadow()
end

MER:RegisterModule(module:GetName())

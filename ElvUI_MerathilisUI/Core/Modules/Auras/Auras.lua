local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Auras')
local A = E:GetModule("Auras")

function module:Auras_SkinIcon(_, button, index)
	if index == nil then return end
	local r, g, b
	if button.auraType == 'debuffs' then
		local color = (A.db.colorDebuffs and _G.DebuffTypeColor[button.debuffType])
		r, g, b = color.r, color.g, color.b
	else
		r = E.private.mui.skins.shadow.color.r or 0
		g = E.private.mui.skins.shadow.color.g or 0
		b = E.private.mui.skins.shadow.color.b or 0
	end
	MER:CreateShadow(button, 3, r, g, b)
end

function module:Auras_SkinTempEnchantIcon(_, button, index)
	local quality, r, g, b = A.db.colorEnchants and GetInventoryItemQuality('player', index)
	if quality and quality > 1 then
		r, g, b = GetItemQualityColor(quality)
	else
		r = E.private.mui.skins.shadow.color.r or 0
		g = E.private.mui.skins.shadow.color.g or 0
		b = E.private.mui.skins.shadow.color.b or 0
	end
	MER:CreateShadow(button, 3, r, g, b)
end

function module:Auras_Shadow()
	self:SecureHook(A, "CreateIcon", "Auras_SkinIcon")
	self:SecureHook(A, "UpdateAura", "Auras_SkinIcon")
	self:SecureHook(A, "UpdateTempEnchant", "Auras_SkinTempEnchantIcon")
end

function module:Initialize()
	self:Auras_Shadow()
end

MER:RegisterModule(module:GetName())

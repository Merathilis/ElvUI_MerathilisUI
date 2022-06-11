local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local NP = E.NamePlates
local UF = E.UnitFrames
local S = MER.Modules.Skins

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc

function module:PostUpdateDebuffs(_, button)
	local db = (self.isNameplate and NP.db.colors) or UF.db.colors
	local enemyNPC = not button.isFriend and not button.isPlayer

	S:CreateLowerShadow(button)

	local r, g, b
	if button.isDebuff then
		if enemyNPC then
			if db.auraByType then
				r, g, b = .9, .1, .1
			end
		elseif db.auraByDispels and button.debuffType and E.BadDispels[button.spellID] and E:IsDispellableByMe(button.debuffType) then
			r, g, b = 05, .85, .94
		elseif db.auraByType then
			local color = _G.DebuffTypeColor[button.debuffType] or _G.DebuffTypeColor.none
			r, g, b = color.r * 0.6, color.g * 0.6, color.b * 0.6
		end
	elseif db.auraByDispels and button.isStealable and not button.isFriend then
		r, g, b = .93, .91, .55
	end

	S:UpdateShadowColor(button.shadow, r, g, b)
end

function module:LoadAuras()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.auras ~= true then return end

	for _, object in pairs(_G.ElvUF.objects) do
		if object.Debuffs and object.Debuffs.PostUpdateIcon then
			hooksecurefunc(object.Debuffs, 'PostUpdateIcon', module.PostUpdateDebuffs)
		end
	end
end


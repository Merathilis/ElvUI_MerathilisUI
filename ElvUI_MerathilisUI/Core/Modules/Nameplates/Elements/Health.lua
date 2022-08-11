local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NamePlates')
local NP = E:GetModule('NamePlates')

local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

local reactionType

function module:Health_UpdateColor(_, unit)
	if not E.db.mui.nameplates.gradient then return end

	if not unit or self.unit ~= unit then return end
	local element = self.Health

	local _, class = UnitClass(unit)
	local isPlayer = UnitIsPlayer(unit)
	local reaction = UnitReaction(unit, 'player')

	local sf = NP:StyleFilterChanges(unit)

	if element then
		if sf.HealthColor then
			return
		else
			if reaction and reaction >= 5 then
				reactionType = "NPCFRIENDLY"
			elseif reaction and reaction == 4 then
				reactionType = "NPCNEUTRAL"
			elseif reaction and reaction == 3 then
				reactionType = "NPCUNFRIENDLY"
			elseif reaction and reaction <= 2 then
				reactionType = "NPCHOSTILE"
			end

			if class and isPlayer then
				element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(class))
			elseif reaction then
				if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
					element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("TAPPED", false, false))
				else
					element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(reactionType))
				end
			end
		end
	end
end

hooksecurefunc(NP, 'Health_UpdateColor', module.Health_UpdateColor)

local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NamePlates')
local NP = E:GetModule('NamePlates')

local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local CreateColor = CreateColor

local reactionType

function module:Health_UpdateColor(_, unit)
	if not E.db.mui.nameplates.gradient then return end
	if E.db.nameplates.threat.enable then return end

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
				if E.Classic then
					element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(class))
				else
					element:GetStatusBarTexture():SetGradient("HORIZONTAL",
						CreateColor(F.ClassGradient[class].r2, F.ClassGradient[class].g2, F.ClassGradient[class].b2, 1), CreateColor(F.ClassGradient[class].r1, F.ClassGradient[class].g1, F.ClassGradient[class].b1, 1))
				end
			elseif reaction then
				if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
					if E.Classic then
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("TAPPED", false, false))
					else
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(0.6, 0.6, 0.60, 1), CreateColor(0, 0, 0, 1))
					end
				else
					if E.Classic then
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(reactionType))
					else
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(F.ClassGradient[reactionType].r1, F.ClassGradient[reactionType].g1, F.ClassGradient[reactionType].b1, 1), CreateColor(F.ClassGradient[reactionType].r2, F.ClassGradient[reactionType].g2, F.ClassGradient[reactionType].b2, 1))
					end
				end
			end
		end
	end
end

hooksecurefunc(NP, 'Health_UpdateColor', module.Health_UpdateColor)

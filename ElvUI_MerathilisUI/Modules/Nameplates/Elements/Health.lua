local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NamePlates")
local NP = E:GetModule("NamePlates")

local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local CreateColor = CreateColor

local reactionType

function module:Health_UpdateColor(_, unit)
	if not E.db.mui.nameplates.gradient then
		return
	end
	if E.db.nameplates.threat.enable then
		return
	end

	if not unit or self.unit ~= unit then
		return
	end
	local element = self.Health

	local colorDB = E.db.mui.gradient
	if not colorDB.enable then
		return
	end

	local _, class = UnitClass(unit)
	local isPlayer = UnitIsPlayer(unit)
	local reaction = UnitReaction(unit, "player")

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
				if colorDB and colorDB.customColor.enable or colorDB and colorDB.customColor.enableNP then
					element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(class))
				else
					element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(class))
				end
			elseif reaction then
				if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
					if colorDB and colorDB.customColor.enable or colorDB and colorDB.customColor.enableNP then
						element
							:GetStatusBarTexture()
							:SetGradient("HORIZONTAL", F.GradientColorsCustom("TAPPED", false, false))
					else
						element
							:GetStatusBarTexture()
							:SetGradient("HORIZONTAL", F.GradientColors("TAPPED", false, false))
					end
				else
					if colorDB and colorDB.customColor.enable or colorDB and colorDB.customColor.enableNP then
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(reactionType))
					else
						element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(reactionType))
					end
				end
			end
		end
	end
end

hooksecurefunc(NP, "Health_UpdateColor", module.Health_UpdateColor)

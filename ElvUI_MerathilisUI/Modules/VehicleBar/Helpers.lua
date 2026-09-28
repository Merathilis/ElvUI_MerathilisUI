local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")

local C_Spell_GetSpellCharges = C_Spell.GetSpellCharges
local C_UnitAuras_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID

local SKYWARD_ASCENT_SPELL_ID = 372610 -- vigor charges
local THRILL_OF_THE_SKIES_SPELL_ID = 377234

function module:IsVigorAvailable()
	-- Check if player has the skyriding spell AND currently has vigor charges available
	if not F.IsSkyriding() then
		return false
	end

	-- If we can get spell charge info, we're actively skyriding
	return self:GetSpellChargeInfo() ~= nil
end

-- Charges are secret while cooldowns are restricted; callers treat nil as "no vigor"
function module:GetSpellChargeInfo()
	local chargeInfo = C_Spell_GetSpellCharges(SKYWARD_ASCENT_SPELL_ID)
	if
		not chargeInfo
		or E:IsSecretValue(chargeInfo.currentCharges)
		or E:IsSecretValue(chargeInfo.maxCharges)
		or E:IsSecretValue(chargeInfo.cooldownStartTime)
		or E:IsSecretValue(chargeInfo.cooldownDuration)
	then
		return
	end

	return chargeInfo
end

function module:ColorSpeedText(msg)
	-- The aura is secret while auras are restricted, the text stays uncolored then
	local thrillActive = C_UnitAuras_GetPlayerAuraBySpellID(THRILL_OF_THE_SKIES_SPELL_ID)
	if thrillActive and E:NotSecretValue(thrillActive) then
		local r, g, b = self.vdb.thrillColor.r, self.vdb.thrillColor.g, self.vdb.thrillColor.b
		return F.String.Color(msg, F.String.FastRGB(r, g, b))
	else
		return msg
	end
end

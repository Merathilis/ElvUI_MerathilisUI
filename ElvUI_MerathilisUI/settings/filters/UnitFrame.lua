local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

local function Defaults(priorityOverride)
	return {['enable'] = true, ['priority'] = priorityOverride or 0, ['stackThreshold'] = 0}
end

--[[
	These are buffs that can be considered as important "protection" buffs
]]
G.unitframe.aurafilters['MER_RaidCDs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
	--Death Knight
		[48707] = Defaults(), --Anti-Magic Shell
		[55233] = Defaults(), --Vampiric Blood
		[48792] = Defaults(), --Icebound Fortitude
		[145629] = Defaults(), --Anti-Magic Zone
	--Demon Hunter
		[187827] = Defaults(), --Metamorphosis
		[227225] = Defaults(), --Soul Barrier
		[209426] = Defaults(), --Darkness
		[196555] = Defaults(), --Netherwalk
		[212800] = Defaults(), --Blur
		[218256] = Defaults(), --Empower Wards
	-- Druid
		[102342] = Defaults(), --Ironbark
		[61336] = Defaults(), --Survival Instincts
		[22812] = Defaults(), --Barkskin
		[234081] = Defaults(), --Celestial Guardian
		[192081] = Defaults(), --Ironfur
		[192083] = Defaults(), --Mark of Ursol
	--Hunter
		[186265] = Defaults(), --Aspect of the Turtle
	--Mage
		[45438] = Defaults(), --Ice Block
		[113862] = Defaults(), --Greater Invisibility
	--Monk
		[122783] = Defaults(), --Diffuse Magic
		[122278] = Defaults(), --Dampen Harm
		[201318] = Defaults(), --Fortifying Elixir
		[201325] = Defaults(), --Zen Moment
		[202248] = Defaults(), --Guided Meditation
		[120954] = Defaults(), --Fortifying Brew
		[116849] = Defaults(), --Life Cocoon
		[202162] = Defaults(), --Guard
		[215479] = Defaults(), --Ironskin Brew
	--Paladin
		[642] = Defaults(), --Divine Shield
		[498] = Defaults(), --Divine Protection
		[1022] = Defaults(), --Blessing of Protection
		[6940] = Defaults(), --Blessing of Sacrifice
		[204018] = Defaults(), --Blessing of Spellwarding
		[31850] = Defaults(), --Ardent Defender
		[86659] = Defaults(), --Guardian of Ancien Kings
		[211210] = Defaults(), --Protection of Tyr
	--Priest
		[81782] = Defaults(), --Power Word: Barrier
		[47585] = Defaults(), --Dispersion
		[213602] = Defaults(), --Greater Fade
		[27827] = Defaults(), --Spirit of Redemption
		[47788] = Defaults(), --Guardian Spirit
		[33206] = Defaults(), --Pain Suppression
	--Rogue
		[5277] = Defaults(), --Evasion
		[31224] = Defaults(), --Cloak of Shadows
		[1966] = Defaults(), --Feint
		[199754] = Defaults(), --Riposte
	--Shaman
		[204293] = Defaults(), --Spirit Link
		[108271] = Defaults(), --Astral Shift
		[98007] = Defaults(), --Spirit Link Totem
	--Warlock
		[108416] = Defaults(), --Dark Pact
		[104773] = Defaults(), --Unending Resolve
	--Warrior
		[118038] = Defaults(), --Die by the Sword
		[184364] = Defaults(), --Enraged Regeneration
		[97463] = Defaults(), --Commanding Shout
		[213915] = Defaults(), --Mass Spell Reflection
		[223658] = Defaults(), --Safeguard
		[147833] = Defaults(), --Intervene
		[198760] = Defaults(), --Intercept
		[12975] = Defaults(), --Last Stand
		[871] = Defaults(), --Shield Wall
		[23920] = Defaults(), --Spell Reflection
		[216890] = Defaults(), --Spell Reflection (PvPT)
		[203524] = Defaults(), --Neltharion's Fury
		[132404] = Defaults(), --Shield Block
	--Racial
		[65116] = Defaults(), --Stoneform
	},
}
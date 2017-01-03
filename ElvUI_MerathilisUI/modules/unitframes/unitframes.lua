local E, L, V, P, G = unpack(ElvUI);
local MUF = E:NewModule("muiUnits", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");

--Cache global variables
--Lua functions
--WoW API / Variables

MUF.CombatTextures = {
	["DEFAULT"] = [[Interface\CharacterFrame\UI-StateIcon]],
	["SVUI"] = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\SVUI-StateIcon]],
}

function MUF:UpdateUF()
	MUF:ArrangePlayer()

	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup("party")
	end
end

function MUF:Initialize()
	if E.private.unitframe.enable ~= true then return end

	self:InitPlayer()

	self:InitParty()
	self:InitRaid()
	self:InitRaid40()
end

E:RegisterModule(MUF:GetName())
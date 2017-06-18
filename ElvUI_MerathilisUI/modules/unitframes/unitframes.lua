local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:NewModule("muiUnits", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MUF.modName = L["UnitFrames"]

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:UnitDefaults()
	if E.db.mui.unitframes.player.portraitWidth == nil then
		E.db.mui.unitframes.player.portraitWidth = 110
	end
	if E.db.mui.unitframes.player.portraitHeight == nil then
		E.db.mui.unitframes.player.portraitHeight = 85
	end
	if E.db.mui.unitframes.target.portraitWidth == nil then
		E.db.mui.unitframes.target.portraitWidth = 110
	end
	if E.db.mui.unitframes.target.portraitHeight == nil then
		E.db.mui.unitframes.target.portraitHeight = 85
	end
end

function MUF:UpdateUF()
	if E.db.unitframe.units.player.enable then
		MUF:ArrangePlayer()
	end

	if E.db.unitframe.units.target.enable then
		MUF:ArrangeTarget()
	end

	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup("party")
	end
end

function MUF:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	MUF:UnregisterEvent(event)
end

function MUF:Initialize()
	if E.private.unitframe.enable ~= true then return end

	self:UnitDefaults()
	self:InitPlayer()
	self:InitTarget()

	-- self:InitParty()
	-- self:InitRaid()
	-- self:InitRaid40()
end

local function InitializeCallback()
	MUF:Initialize()
end

E:RegisterModule(MUF:GetName(), InitializeCallback)
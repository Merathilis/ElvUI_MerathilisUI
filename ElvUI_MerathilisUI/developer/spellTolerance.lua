local E, L, V, P, G = unpack(ElvUI);


--Cache global variables
--Lua functions
local _G = _G
local select = select
local math_min = math.min

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNetStats = GetNetStats
local GetCVar = GetCVar

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: 

local SpellTolerance = CreateFrame("Frame", "AutoLagTolerance")
SpellTolerance.cache = GetCVar("SpellQueueWindow")
SpellTolerance.timer = 0

local function SpellTolerance_OnUpdate(self, elapsed)
	self.timer = self.timer + elapsed

	if self.timer < 1.0 then
		return
	end

	self.timer = 0

	local SpellLatency = math_min(400, select(4, GetNetStats()))

	if SpellLatency == 0 then
		return
	end

	if SpellLatency == self.cache then
		return
	end

	E:LockCVar("SpellQueueWindow", SpellLatency)

	self.cache = SpellLatency
end

SpellTolerance:SetScript("OnUpdate", SpellTolerance_OnUpdate)
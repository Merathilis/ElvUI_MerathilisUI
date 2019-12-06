local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUI_databars")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local C_Timer_After = C_Timer.After
-- GLOBALS:

function module:StyleBackdrops()
	--Azerite
	local azerite = _G["ElvUI_AzeriteBar"]
	if azerite then
		azerite:Styling()
	end

	-- Experience
	local experience = _G["ElvUI_ExperienceBar"]
	if experience then
		experience:Styling()
	end

	-- Honor
	local honor = _G["ElvUI_HonorBar"]
	if honor then
		honor:Styling()
	end

	-- Reputation
	local reputation = _G["ElvUI_ReputationBar"]
	if reputation then
		reputation:Styling()
	end
end

function module:Initialize()
	module.db = E.db.mui.databars
	MER:RegisterDB(self, "databars")

	C_Timer_After(1, module.StyleBackdrops)
end

MER:RegisterModule(module:GetName())

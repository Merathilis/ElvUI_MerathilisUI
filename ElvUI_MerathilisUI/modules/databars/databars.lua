local MER, E, L, V, P, G = unpack(select(2, ...))
local MDB = E:NewModule("mUI_databars")
MDB.modName = L["DataBars"]

--Cache global variables
local _G = _G
--WoW API / Variables
local C_Timer_After = C_Timer.After
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MDB:StyleBackdrops()
	-- Artifact
	local artifact = _G["ElvUI_ArtifactBar"]
	if artifact then
		artifact:Styling()
	end

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

function MDB:Initialize()
	C_Timer_After(1, MDB.StyleBackdrops)
end

local function InitializeCallback()
	MDB:Initialize()
end

E:RegisterModule(MDB:GetName(), InitializeCallback)
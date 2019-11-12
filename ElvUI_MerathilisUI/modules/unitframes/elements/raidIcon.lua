local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E.UnitFrames

--Cache global variables
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MUF:Configure_RaidIcon(frame)
	local RI = frame.RaidTargetIndicator
	local db = frame.db

	if RI.Replace then return end
	RI.SetTexture = SetTexture

	if db.raidicon.enable then
		RI:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\raidIcons\UI-RaidTargetingIcons]])
	end

	RI.Replace = true
	RI.SetTexture = E.noop
end

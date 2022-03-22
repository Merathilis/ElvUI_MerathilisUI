local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')

--Cache global variables
--WoW API / Variables
-- GLOBALS:

function module:Configure_RaidIcon(frame)
	if E.db.mui.unitframes.raidIcons ~= true then return end

	local RI = frame.RaidTargetIndicator
	local db = frame.db

	if RI.Replace then return end
	RI.SetTexture = SetTexture

	if db.raidicon.enable then
		RI:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\RaidIcons\UI-RaidTargetingIcons]])
	end

	RI.Replace = true
	RI.SetTexture = E.noop
end

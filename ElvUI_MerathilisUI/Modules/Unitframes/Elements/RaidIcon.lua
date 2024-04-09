local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Configure_RaidIcon(frame)
	if E.db.mui.unitframes.raidIcons ~= true then
		return
	end

	local RI = frame.RaidTargetIndicator
	local db = frame.db

	if RI.Replace then
		return
	end
	RI.SetTexture = SetTexture

	if db.raidicon.enable then
		RI:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\RaidIcons\UI-RaidTargetingIcons]])
	end

	RI.Replace = true
	RI.SetTexture = E.noop
end

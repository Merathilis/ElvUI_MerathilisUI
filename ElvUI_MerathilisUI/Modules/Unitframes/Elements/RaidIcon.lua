local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Configure_RaidIcon(frame)
	if E.db.mui.unitframes.raidIcons ~= true then
		return
	end

	local RI = frame.RaidTargetIndicator
	if not RI or RI.Replace then
		return
	end

	-- Also while ElvUI's raid icon is off: the texture is locked below, turning the
	-- icon on later would otherwise keep the default one
	RI:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\RaidIcons\UI-RaidTargetingIcons]])
	RI.Replace = true
	RI.SetTexture = E.noop
end

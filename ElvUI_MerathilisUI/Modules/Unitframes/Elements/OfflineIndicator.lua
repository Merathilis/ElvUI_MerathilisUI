local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

-- Credits: Shadow & Light Darth Predator

module.OfflineTextures = {
	["MATERIAL"] = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\materialDC]],
	["ALERT"] = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
	["ARTHAS"] = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["PASS"] = [[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]],
	["NOTREADY"] = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
}

function module:Construct_OfflineIndicator(frame)
	local OfflineIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 7)

	OfflineIndicator:Point("CENTER", frame, "CENTER", 0, 0)
	OfflineIndicator:Size(36)

	return OfflineIndicator
end

function module:Configure_OfflineIndicator(frame)
	local OfflineIndicator = frame.OfflineIndicator
	local db = E.db.mui.unitframes.offlineIndicator

	frame.db.OfflineIndicator = db

	local width = db.size
	local height = db.keepSizeRatio and db.size or db.height

	OfflineIndicator:ClearAllPoints()
	OfflineIndicator:Point("CENTER", frame, db.anchorPoint, db.xOffset, db.yOffset)

	if db.texture ~= "CUSTOM" and F:TextureExists(module.OfflineTextures[db.texture]) then
		OfflineIndicator:SetTexture(module.OfflineTextures[db.texture])
	elseif F:TextureExists(db.custom) then
		OfflineIndicator:SetTexture(db.custom)
	else
		OfflineIndicator:SetTexture([[Interface\LootFrame\LootPanel-Icon]])
	end

	OfflineIndicator:Size(width, height)

	if db.enable and not frame:IsElementEnabled("OfflineIndicator") then
		frame:EnableElement("OfflineIndicator")
	elseif not db.enable and frame:IsElementEnabled("OfflineIndicator") then
		frame:DisableElement("OfflineIndicator")
	end
end

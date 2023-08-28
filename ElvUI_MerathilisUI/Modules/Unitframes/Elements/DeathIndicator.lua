local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')

-- Credits: Darth Predator - ElvUI_Shadow & Light

module.DeadTextures = {
	["MATERIAL"] = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\materialDead]],
	["SKULL"] = [[Interface\LootFrame\LootPanel-Icon]],
	["SKULL1"] = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\SKULL]],
	["SKULL2"] = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\SKULL1]],
	["SKULL3"] = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\SKULL2]],
	["SKULL4"] = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\SKULL3]],
}

function module:Construct_DeathIndicator(frame)
	local DeathIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, 'OVERLAY', nil, 7)

	DeathIndicator:Point('CENTER', frame, 'CENTER', 0, 0)
	DeathIndicator:Size(36)

	return DeathIndicator
end

function module:Configure_DeathIndicator(frame)
	local DeathIndicator = frame.DeathIndicator
	local db = E.db.mui.unitframes.deathIndicator

	frame.db.DeathIndicator = db

	local width = db.size
	local height = db.keepSizeRatio and db.size or db.height

	DeathIndicator:ClearAllPoints()
	DeathIndicator:Point('CENTER', frame, db.anchorPoint, db.xOffset, db.yOffset)

	if db.texture ~= 'CUSTOM' and F:TextureExists(module.DeadTextures[db.texture]) then
		DeathIndicator:SetTexture(module.DeadTextures[db.texture])
	elseif F:TextureExists(db.custom) then
		DeathIndicator:SetTexture(db.custom)
	else
		DeathIndicator:SetTexture([[Interface\LootFrame\LootPanel-Icon]])
	end

	DeathIndicator:Size(width, height)

	if db.enable and not frame:IsElementEnabled('DeathIndicator') then
		frame:EnableElement('DeathIndicator')
	elseif not db.enable and frame:IsElementEnabled('DeathIndicator') then
		frame:DisableElement('DeathIndicator')
	end
end

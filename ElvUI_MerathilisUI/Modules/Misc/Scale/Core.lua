local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Misc')

local talentsHooked = false

function module:SetElementScale(dbName, blizzName)
	local option = E.db.mui.scale[dbName]

	if not option then
		F.Developer.LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
		return
	end

	_G[blizzName]:SetScale(option.scale)
end

function module:ScaleCollections()
	module:SetElementScale('collections','CollectionsJournal')
	module:SetElementScale('wardrobe', 'WardrobeFrame')
end

function module:ScaleInspectUI()
	local dbName = E.db.mui.scale.syncInspect.enable and 'characterFrame' or 'inspectFrame'
	module:SetElementScale(dbName, 'InspectFrame')
end

function module:HookRetailTalentsWindow()
	_G.ClassTalentFrame:HookScript('OnShow', function()
		module:ScaleTalents()
	end)

	_G.ClassTalentFrame:HookScript('OnEvent', function()
		module:ScaleTalents()
	end)

	talentsHooked = true
end

function module:ScaleTalents()
	local frameName = 'ClassTalentFrame'
	if not talentsHooked then
		module:HookRetailTalentsWindow()
	else
		module:SetElementScale('talents', frameName)
	end
end

function module:Scale()
	-- Check if the db exist1
	if not E.db and not E.db.mui then
		F.Developer.LogDebug("Scaling >> Database not found. Scalling is not loaded!")
		return
	end

	if not E.db.mui.scale or not E.db.mui.scale.enable then
		return
	end

	module:SetElementScale('characterFrame', 'CharacterFrame')
	module:SetElementScale('dressingRoom', 'DressUpFrame')
	module:SetElementScale('spellbook', 'SpellBookFrame')

	module:AddCallbackOrScale('Blizzard_InspectUI', self.ScaleInspectUI)
	module:AddCallbackOrScale('Blizzard_ClassTalentUI', self.ScaleTalents)
	module:AddCallbackOrScale('Blizzard_Collections', self.ScaleCollections)
end

module:AddCallback('Scale')

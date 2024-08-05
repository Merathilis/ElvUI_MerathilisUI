local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G

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
	module:SetElementScale("collections", "CollectionsJournal")
	module:SetElementScale("wardrobe", "WardrobeFrame")
end

-- Credits to Kayr
function module:AdjustTransmogFrame()
	if not E.db.mui.scale.transmog.enable then
		return
	end

	local wardrobeFrame = _G["WardrobeFrame"]
	local transmogFrame = _G["WardrobeTransmogFrame"]

	local width = 1200
	local initialWidth = wardrobeFrame:GetWidth()
	local updatedWidth = width - initialWidth
	wardrobeFrame:SetWidth(width)

	local initialTransmogWidth = transmogFrame:GetWidth()
	local updatedTransmogWidth = initialTransmogWidth + updatedWidth
	transmogFrame:SetWidth(updatedTransmogWidth)

	-- Calculate inset width only once
	local modelScene = transmogFrame.ModelScene
	local insetWidth = E:Round(initialTransmogWidth - modelScene:GetWidth(), 0)
	transmogFrame.Inset.BG:SetWidth(transmogFrame.Inset.BG:GetWidth() - insetWidth)
	modelScene:SetWidth(transmogFrame:GetWidth() - insetWidth)
	modelScene:SetScript("OnShow", function()
		E:Delay(0.01, function()
			modelScene.activeCamera.maxZoomDistance = 6
		end)
	end)

	-- Move Slots
	transmogFrame.HeadButton:SetPoint("TOPLEFT", 20, -60)
	transmogFrame.HandsButton:SetPoint("TOPRIGHT", -20, -60)

	local mainHand = transmogFrame.MainHandButton
	local mainHandEnch = transmogFrame.MainHandEnchantButton
	local offHand = transmogFrame.SecondaryHandButton
	local offHandEnch = transmogFrame.SecondaryHandEnchantButton

	mainHand:SetPoint("BOTTOM", -30, 25)
	mainHandEnch:SetPoint("CENTER", mainHand, "BOTTOM", 0, -5)
	offHand:SetPoint("BOTTOM", 30, 25)
	offHandEnch:SetPoint("CENTER", offHand, "BOTTOM", 0, -5)

	transmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("BOTTOMLEFT", transmogFrame, "BOTTOMRIGHT", 20, 20)
end

function module:ScaleInspectUI()
	local dbName = E.db.mui.scale.syncInspect.enable and "characterFrame" or "inspectFrame"
	module:SetElementScale(dbName, "InspectFrame")
end

function module:HookRetailTalentsWindow()
	_G.PlayerSpellsFrame:HookScript("OnShow", function()
		module:ScaleTalents()
	end)

	_G.PlayerSpellsFrame:HookScript("OnEvent", function()
		module:ScaleTalents()
	end)

	talentsHooked = true
end

function module:ScaleTalents()
	local frameName = "PlayerSpellsFrame"
	if not talentsHooked then
		module:HookRetailTalentsWindow()
	else
		module:SetElementScale("talents", frameName)
	end
end

function module:ScaleAuctionHouse()
	module:SetElementScale("auctionHouse", "AuctionHouseFrame")
end

function module:ScaleProfessions()
	module:SetElementScale("professions", "ProfessionsBookFrame")
end

function module:Scale()
	-- Check if the db exist
	if not E.db and not E.db.mui then
		F.Developer.LogDebug("Scaling >> Database not found. Scalling is not loaded!")
		return
	end

	if not E.db.mui.scale or not E.db.mui.scale.enable then
		return
	end

	module:SetElementScale("characterFrame", "CharacterFrame")
	module:SetElementScale("dressingRoom", "DressUpFrame")

	module:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)
	module:AddCallbackOrScale("Blizzard_PlayerSpells", self.ScaleTalents)
	module:AddCallbackOrScale("Blizzard_AuctionHouseUI", self.ScaleAuctionHouse)
	module:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections)
	module:AddCallbackOrScale("Blizzard_Collections", self.AdjustTransmogFrame)
	module:AddCallbackOrScale("Blizzard_ProfessionsBook", self.ScaleProfessions)
end

module:AddCallback("Scale")

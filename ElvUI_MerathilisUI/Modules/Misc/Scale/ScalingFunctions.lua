local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

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

function module:ScaleItemUpgrade()
	module:SetElementScale("itemUpgrade", "ItemUpgradeFrame")
	module:SetElementScale("equipmentFlyout", "EquipmentFlyoutFrameButtons")
end

function module:ScaleCatalyst()
	module:SetElementScale("itemUpgrade", "ItemInteractionFrame")
	module:SetElementScale("equipmentFlyout", "EquipmentFlyoutFrameButtons")
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
	E:Delay(0.01, function()
		local isHooked = module.hookedFrames["profession"] == true
		if not isHooked then
			-- Scale initially
			module:SetElementScale("profession", "ProfessionsFrame")

			local frame = _G["ProfessionsFrame"]
			frame:HookScript("OnShow", function()
				module:SetElementScale("profession", "ProfessionsFrame")
			end)

			module.hookedFrames["profession"] = true
		end
	end)
end

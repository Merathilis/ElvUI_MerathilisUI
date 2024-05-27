local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local C_Timer_After = C_Timer.After

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

-- Credits to https://www.curseforge.com/wow/addons/kayrwidertransmogui
function module:AdjustTransmogFrame()
	if not E.db.mui.scale.transmog.enable then
		return
	end

	local wardrobeFrame = _G["WardrobeFrame"]
	local transmogFrame = _G["WardrobeTransmogFrame"]

	local initialParentFrameWidth = wardrobeFrame:GetWidth() -- Expecting 965
	local desiredParentFrameWidth = 1200
	local parentFrameWidthIncrease = desiredParentFrameWidth - initialParentFrameWidth
	wardrobeFrame:SetWidth(desiredParentFrameWidth)

	local initialTransmogFrameWidth = transmogFrame:GetWidth()
	local desiredTransmogFrameWidth = initialTransmogFrameWidth + parentFrameWidthIncrease
	transmogFrame:SetWidth(desiredTransmogFrameWidth)

	-- Calculate inset width only once
	local modelScene = transmogFrame.ModelScene
	local insetWidth = Round(initialTransmogFrameWidth - modelScene:GetWidth(), 0)
	transmogFrame.Inset.BG:SetWidth(transmogFrame.Inset.BG:GetWidth() - insetWidth)
	modelScene:SetWidth(transmogFrame:GetWidth() - insetWidth)

	-- Move Slots
	transmogFrame.HeadButton:SetPoint("TOPLEFT", 20, -60)
	transmogFrame.HandsButton:SetPoint("TOPRIGHT", -20, -60)
	transmogFrame.MainHandButton:SetPoint("BOTTOM", -26, 23)
	transmogFrame.MainHandEnchantButton:SetPoint("CENTER", -26, -230)
	transmogFrame.SecondaryHandButton:SetPoint("BOTTOM", 27, 23)
	transmogFrame.SecondaryHandEnchantButton:SetPoint("CENTER", 27, -230)

	-- Move Separate Shoulder checkbox
	transmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("BOTTOMLEFT", transmogFrame, "BOTTOMLEFT", 580, 15)

	-- Ease constraints on zooming out
	local function ExtendZoomDistance()
		modelScene.activeCamera.maxZoomDistance = 6
	end

	modelScene:SetScript("OnShow", function()
		C_Timer_After(0.01, ExtendZoomDistance)
	end)
end

function module:ScaleInspectUI()
	local dbName = E.db.mui.scale.syncInspect.enable and "characterFrame" or "inspectFrame"
	module:SetElementScale(dbName, "InspectFrame")
end

function module:HookRetailTalentsWindow()
	_G.ClassTalentFrame:HookScript("OnShow", function()
		module:ScaleTalents()
	end)

	_G.ClassTalentFrame:HookScript("OnEvent", function()
		module:ScaleTalents()
	end)

	talentsHooked = true
end

function module:ScaleTalents()
	local frameName = "ClassTalentFrame"
	if not talentsHooked then
		module:HookRetailTalentsWindow()
	else
		module:SetElementScale("talents", frameName)
	end
end

function module:ScaleAuctionHouse()
	module:SetElementScale("auctionHouse", "AuctionHouseFrame")
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

	module:SetElementScale("characterFrame", "CharacterFrame")
	module:SetElementScale("dressingRoom", "DressUpFrame")
	module:SetElementScale("spellbook", "SpellBookFrame")

	module:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)
	module:AddCallbackOrScale("Blizzard_ClassTalentUI", self.ScaleTalents)
	module:AddCallbackOrScale("Blizzard_AuctionHouseUI", self.ScaleAuctionHouse)
	module:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections)
	module:AddCallbackOrScale("Blizzard_Collections", self.AdjustTransmogFrame)
end

module:AddCallback("Scale")

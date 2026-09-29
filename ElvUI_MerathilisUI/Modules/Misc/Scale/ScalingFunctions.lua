local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local InCombatLockdown = InCombatLockdown

local talentsHooked = false

function module:SetElementScale(dbName, blizzName)
	local option = E.db.mui.scale[dbName]

	if not option then
		F.Developer.LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
		return
	end

	local frame = _G[blizzName]
	-- Missing on some clients; protected frames can't be scaled in combat
	if not frame or (frame:IsProtected() and InCombatLockdown()) then
		return
	end

	frame:SetScale(option.scale)
end

function module:ScaleCollections()
	module:SetElementScale("collections", "CollectionsJournal")
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

function module:ScaleEncounterJournal()
	module:SetElementScale("encounterjournal", "EncounterJournal")
end

-- The "wardrobe" setting scales the transmog frame, WardrobeFrame no longer exists
function module:ScaleTransmog()
	module:SetElementScale("wardrobe", "TransmogFrame")
end

function module:ScaleClassTrainer()
	module:SetElementScale("classTrainer", "ClassTrainerFrame")
end

function module:ScaleItemUpgrade()
	module:SetElementScale("itemUpgrade", "ItemUpgradeFrame")
end

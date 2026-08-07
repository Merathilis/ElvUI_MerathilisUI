local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local wipe = wipe
local tconcat = table.concat

local hooksecurefunc = hooksecurefunc
local C_Item_GetItemStats = C_Item.GetItemStats

local function CreateStatsText(self)
	local fs = F.CreateFS(self, 12, "OUTLINE")
	fs:SetTextColor(0.12, 1, 0)
	fs:ClearAllPoints()

	return fs
end

local statWatchList = {
	"ITEM_MOD_CR_AVOIDANCE_SHORT", -- Avoidance
	"ITEM_MOD_CR_LIFESTEAL_SHORT", -- Leech
	"ITEM_MOD_CR_SPEED_SHORT", -- Speed
}

local itemCache = {}
local parts = {}
local function GetStatsString(link)
	local cached = itemCache[link]
	if not cached then
		local stats = C_Item_GetItemStats(link)
		if stats then
			for i = 1, #statWatchList do
				local stat = statWatchList[i]
				if stats[stat] then
					parts[#parts + 1] = _G[stat]
				end
			end
		end

		cached = tconcat(parts, " ")
		wipe(parts)
		itemCache[link] = cached
	end

	return cached
end

function module:Auction_ItemStats()
	hooksecurefunc(_G.AuctionHouseTableExtraInfoMixin, "Populate", function(self, rowData)
		if not self.stats then
			self.stats = CreateStatsText(self)
			self.stats:SetPoint("RIGHT", self, "LEFT")
		end

		local itemLink = rowData and rowData.itemLink
		self.stats:SetText(itemLink and GetStatsString(itemLink) or "")
	end)
end

function module:AuctionEnhanced()
	if not E.db.mui.misc.auctionEnhanced then
		return
	end

	module:Auction_ItemStats()
	module:RegisterEvent("AUCTION_HOUSE_CLOSED", "ClearAuctionStatsCache")
end

function module:ClearAuctionStatsCache()
	wipe(itemCache)
end

module:AddCallbackForAddon("Blizzard_AuctionHouseUI", module.AuctionEnhanced)

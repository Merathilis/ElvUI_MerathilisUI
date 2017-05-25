local E, L, V, P, G = unpack(ElvUI);
local MI = E:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local select = select
-- WoW API / Variables
local GetAuctionItemInfo = GetAuctionItemInfo
local GetNumAuctionItems = GetNumAuctionItems
local GetCoinTextureString = GetCoinTextureString

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: CreateFrame, AuctionFrameAuctions, AuctionFrameMoneyFrame, BIDS, BUYOUT

function MI:sumAuctions()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_AuctionUI" then
			local f = CreateFrame("Frame", nil, AuctionFrameAuctions)
			f:SetSize(200, 20)
			f:SetPoint("LEFT", AuctionFrameMoneyFrame, "RIGHT", 38, -1)

			local text = f:CreateFontString(nil, "OVERLAY", "SystemFont_Small")
			text:SetPoint("LEFT")

			f:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
			f:SetScript("OnEvent", function(self, event, ...)
				local totalBuyout = 0
				local totalBid = 0

				for i = 1, GetNumAuctionItems("owner") do
					totalBuyout = totalBuyout + select(10, GetAuctionItemInfo("owner", i))
					totalBid = totalBid + select(8, GetAuctionItemInfo("owner", i))
				end

				if totalBuyout > 0 then
					text:SetText(BIDS..": "..GetCoinTextureString(totalBid).."     "..BUYOUT..": "..GetCoinTextureString(totalBuyout))
				elseif totalBid > 0 and totalBuyout == 0 then
					text:SetText(BIDS..": "..GetCoinTextureString(totalBid))
				else
					text:SetText("")
				end
			end)
		end
	end)
end

function MI:HighlightPrice()
	-- Show BID and highlight price
	hooksecurefunc("AuctionFrame_LoadUI", function()
		if AuctionFrameBrowse_Update then
			hooksecurefunc("AuctionFrameBrowse_Update", function()
				local numBatchAuctions = GetNumAuctionItems("list")
				local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
				for i=1, NUM_BROWSE_TO_DISPLAY do
					local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
					if index <= numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page) then
						local name, _, count, _, _, _, _, _, _, buyoutPrice, bidAmount =  GetAuctionItemInfo("list", offset + i)
						local alpha = 0.5
						local color = "yellow"
						if name then
							local itemName = _G["BrowseButton"..i.."Name"]
							local moneyFrame = _G["BrowseButton"..i.."MoneyFrame"]
							local buyoutMoney = _G["BrowseButton"..i.."BuyoutFrameMoney"]
							if (buyoutPrice/10000) >= 5000 then color = "red" end
							if bidAmount > 0 then
								name = name .. " |cffffff00"..BID.."|r"
								alpha = 1.0
							end
							itemName:SetText(name)
							moneyFrame:SetAlpha(alpha)
							SetMoneyFrameColor(buyoutMoney:GetName(), color)
						end
					end
				end
			end)
		end
	end)
end

function MI:LoadsumAuctions()
	self:sumAuctions()
	self:HighlightPrice()
end
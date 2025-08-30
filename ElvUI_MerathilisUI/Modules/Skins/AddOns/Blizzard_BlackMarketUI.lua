local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local pairs, select = pairs, select

local CreateFrame = CreateFrame

function module:Blizzard_BlackMarketUI()
	if not module:CheckDB("bmah", "blackmarket") then
		return
	end

	local BlackMarketFrame = _G.BlackMarketFrame

	BlackMarketFrame.Inset:DisableDrawLayer("BORDER")
	select(9, BlackMarketFrame.Inset:GetRegions()):Hide()
	BlackMarketFrame.MoneyFrameBorder:Hide()
	BlackMarketFrame.HotDeal.Left:Hide()
	BlackMarketFrame.HotDeal.Right:Hide()
	select(4, BlackMarketFrame.HotDeal:GetRegions()):Hide()

	module:CreateBackdropShadow(BlackMarketFrame)

	module:CreateBG(BlackMarketFrame.HotDeal.Item)

	local headers =
		{ "ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid" }
	for _, headerName in pairs(headers) do
		local header = BlackMarketFrame[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		local bg = CreateFrame("Frame", nil, header)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 0)
		bg:OffsetFrameLevel(-1, header)
		bg:SetTemplate("Transparent")
	end

	BlackMarketFrame.HotDeal:SetTemplate("Transparent")
end

module:AddCallbackForAddon("Blizzard_BlackMarketUI")

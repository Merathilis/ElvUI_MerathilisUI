local MER, E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Bags")

local function EventHandler(self, event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self:RegisterEvent("AUCTION_HOUSE_SHOW")
		self:RegisterEvent("AUCTION_HOUSE_CLOSED")
	elseif ( event == "AUCTION_HOUSE_SHOW" ) then
		B:OpenBags()
	elseif ( event == "AUCTION_HOUSE_CLOSED" ) then
		B:CloseBags()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", EventHandler)

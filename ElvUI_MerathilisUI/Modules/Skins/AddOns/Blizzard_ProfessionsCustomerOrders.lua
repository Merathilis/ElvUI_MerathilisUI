local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:Blizzard_ProfessionsCustomerOrders()
	if not module:CheckDB('tradeskill', 'tradeskill') then
		return
	end

	local frame = _G.ProfessionsCustomerOrdersFrame
	if frame then
		frame:CreateShadow()
	end

	local currentPrice = _G.ProfessionsCustomerOrdersFrame.Form.CurrentListings
	if currentPrice then
		currentPrice:CreateShadow()
	end

	module:ReskinTab(_G.ProfessionsCustomerOrdersFrameBrowseTab)
	module:ReskinTab(_G.ProfessionsCustomerOrdersFrameOrdersTab)
end

module:AddCallbackForAddon('Blizzard_ProfessionsCustomerOrders')

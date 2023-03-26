local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB('tradeskill', 'tradeskill') then
		return
	end

	local frame = _G.ProfessionsCustomerOrdersFrame
	if frame then
		frame:Styling()
		frame:CreateShadow()
	end

	local currentPrice = _G.ProfessionsCustomerOrdersFrame.Form.CurrentListings
	if currentPrice then
		currentPrice:Styling()
		currentPrice:CreateShadow()
	end

	module:ReskinTab(_G.ProfessionsCustomerOrdersFrameBrowseTab)
	module:ReskinTab(_G.ProfessionsCustomerOrdersFrameOrdersTab)
end

S:AddCallbackForAddon('Blizzard_ProfessionsCustomerOrders', LoadSkin)

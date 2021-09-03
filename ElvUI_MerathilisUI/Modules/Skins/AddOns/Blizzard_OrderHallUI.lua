local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

-- Cache global variables
local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

	local OrderHallTalentFrame = _G.OrderHallTalentFrame
	if not OrderHallTalentFrame.backdrop then
		OrderHallTalentFrame:CreateBackdrop('Transparent')
	end
	OrderHallTalentFrame.backdrop:Styling()

	MER:CreateBackdropShadow(OrderHallTalentFrame)
end

S:AddCallbackForAddon("Blizzard_OrderHallUI", "mUIOrderHall", LoadSkin)

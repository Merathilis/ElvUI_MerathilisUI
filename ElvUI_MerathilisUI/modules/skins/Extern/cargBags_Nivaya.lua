local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
if not IsAddOnLoaded("cargBags_Nivaya") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, BugSack

local function stylecargBags()
	if E.private.muiSkins.addonSkins.cbn ~= true then return end

	-- Default Containers from cargBags_Nivaya
	local frames = {
		NivayacBniv_Bag,
		NivayacBniv_TradeGoods,
		NivayacBniv_Consumables,
		NivayacBniv_Quest,
		NivayacBniv_ItemSets,
	}

	for _, frame in pairs(frames) do
		if frame then
			frame:Styling()
		end
	end
end

S:AddCallbackForAddon("cargBags_Nivaya", "mui_cargBags_Nivaya", stylecargBags)

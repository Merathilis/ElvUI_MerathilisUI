local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions

-- WoW API / Variables
-- GLOBALS:

if not IsAddOnLoaded("cargBags_Nivaya") then return end

local function stylecargBags()
	if E.private.muiSkins.addonSkins.cb ~= true then return end

	--[[
		-- Will not work for custom created Bags
	]]--

	-- Main Bag
	if NivayacBniv_Bag then
		NivayacBniv_Bag:Styling()
	end

	-- Trade Goods
	if NivayacBniv_TradeGoods then
		NivayacBniv_TradeGoods:Styling()
	end

	-- Consumables
	if NivayacBniv_Consumables then
		NivayacBniv_Consumables:Styling()
	end

	-- Quest
	if NivayacBniv_Quest then
		NivayacBniv_Quest:Styling()
	end

	-- ItemSets
	if NivayacBniv_ItemSets then
		NivayacBniv_ItemSets:Styling()
	end

	-- Armor
	if NivayacBniv_Armor then
		NivayacBniv_Armor:Styling()
	end

	-- Gems
	if NivayacBniv_Gem then
		NivayacBniv_Gem:Styling()
	end
end

S:AddCallbackForAddon("cargBags_Nivaya", "cargBags_Nivaya", stylecargBags)
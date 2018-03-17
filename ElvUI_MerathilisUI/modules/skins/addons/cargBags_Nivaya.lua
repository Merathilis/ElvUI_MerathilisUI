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

	-- BAGS
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

	--Artifact Power
	if NivayacBniv_ArtifactPower then
		NivayacBniv_ArtifactPower:Styling()
	end

	-- Stuff
	if NivayacBniv_Stuff then
		NivayacBniv_Stuff:Styling()
	end

	-- Junk
	if NivayacBniv_Junk then
		NivayacBniv_Junk:Styling()
	end

	-- BattlePets
	if NivayacBniv_BattlePet then
		NivayacBniv_BattlePet:Styling()
	end

	-- BANK
	-- Main Bank
	if NivayacBniv_Bank then
		NivayacBniv_Bank:Styling()
	end

	-- Reagent
	if NivayacBniv_BankReagent then
		NivayacBniv_BankReagent:Styling()
	end

	-- Bank Consumables
	if NivayacBniv_BankCons then
		NivayacBniv_BankCons:Styling()
	end

	-- Bank Quest
	if NivayacBniv_BankQuest then
		NivayacBniv_BankQuest:Styling()
	end

	-- Bank Armor
	if NivayacBniv_BankArmor then
		NivayacBniv_BankArmor:Styling()
	end

	-- Bank Gems
	if NivayacBniv_BankGem then
		NivayacBniv_BankGem:Styling()
	end

	-- Bank Trade
	if NivayacBniv_BankTrade then
		NivayacBniv_BankTrade:Styling()
	end
end

S:AddCallbackForAddon("cargBags_Nivaya", "cargBags_Nivaya", stylecargBags)
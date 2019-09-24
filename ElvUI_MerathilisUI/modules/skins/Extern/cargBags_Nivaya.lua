local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
if not IsAddOnLoaded("cargBags_Nivaya") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, BugSack

local function LoadAddOnSkin()
	if E.private.muiSkins.addonSkins.cbn ~= true then return end

	-- Default Containers from cargBags_Nivaya
	local frames = {
		-- Main Bags
		NivayacBniv_Bag,
		NivayacBniv_TradeGoods,
		NivayacBniv_Consumables,
		NivayacBniv_Quest,
		NivayacBniv_ItemSets,
		NivayacBniv_Stuff,
		NivayacBniv_BattlePet,
		NivayacBniv_Gem,
		NivayacBniv_ArtifactPower,
		NivayacBniv_Armor,
		NivayacBniv_NewItems,
		NivayacBniv_Junk,

		-- Bank
		NivayacBniv_Bank,
		NivayacBniv_BankReagent,
		NivayacBniv_BankArmor,
		NivayacBniv_BankCons,
		NivayacBniv_BankQuest,
		NivayacBniv_BankGem,
	}

	for _, frame in pairs(frames) do
		if frame then
			frame:Styling()
		end
	end
end

S:AddCallbackForAddon("cargBags_Nivaya", "mui_cargBags_Nivaya", LoadAddOnSkin)

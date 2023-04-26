local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
if not IsAddOnLoaded("cargBags_Nivaya") then return; end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.cbn then return end

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

module:AddCallbackForAddon("cargBags_Nivaya", LoadSkin)

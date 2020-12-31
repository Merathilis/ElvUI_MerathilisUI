local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true or E.private.muiSkins.blizzard.loot ~= true then return end

	_G.BonusRollFrame:Styling()
	_G.LootHistoryFrame:Styling()

	if E.private.general.loot then
		_G.ElvLootFrame:Styling()
	end

	-- Boss Banner
	hooksecurefunc("BossBanner_ConfigureLootFrame", function(lootFrame)
		if not lootFrame.isSkinned then
			local iconHitBox = lootFrame.IconHitBox
			S:HandleIcon(lootFrame.Icon, true)
			iconHitBox.IconBorder:SetTexture(nil)
			S:HandleIconBorder(iconHitBox.IconBorder, lootFrame.Icon.backdrop)

			lootFrame.isSkinned = true
		end
	end)
end

S:AddCallback("mUILoot", LoadSkin)

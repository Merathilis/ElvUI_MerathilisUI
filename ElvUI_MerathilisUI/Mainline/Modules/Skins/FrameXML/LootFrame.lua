local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function HideIconBG(anim)
	anim.__owner.Icon.backdrop:SetAlpha(0)
end

local function ShowIconBG(anim)
	anim.__owner.Icon.backdrop:SetAlpha(1)
end

local function LoadSkin()
	if not module:CheckDB("loot", "loot") then
		return
	end

	_G.BonusRollFrame:Styling()
	_G.LootHistoryFrame:Styling()

	if E.private.general.loot then
		_G.ElvLootFrame:Styling()
	end

	-- Boss Banner
	hooksecurefunc('BossBanner_ConfigureLootFrame', function(lootFrame)
		if not lootFrame.isSkinned then
			local iconHitBox = lootFrame.IconHitBox

			S:HandleIcon(lootFrame.Icon, true)
			iconHitBox.IconBorder:SetTexture(nil)
			S:HandleIconBorder(iconHitBox.IconBorder, lootFrame.Icon.backdrop)

			lootFrame.Anim.__owner = lootFrame
			lootFrame.Anim:HookScript("OnPlay", HideIconBG)
			lootFrame.Anim:HookScript("OnFinished", ShowIconBG)

			lootFrame.isSkinned = true
		end
	end)
end

S:AddCallback("LootFrame", LoadSkin)

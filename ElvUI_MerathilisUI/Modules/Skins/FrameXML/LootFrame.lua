local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
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

function module:LootFrame()
	if not module:CheckDB("loot", "loot") then
		return
	end

	_G.BonusRollFrame:Styling()
	module:CreateShadow(_G.BonusRollFrame)
	module:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	module:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

	_G.GroupLootHistoryFrame:Styling()
	module:CreateShadow(_G.GroupLootHistoryFrame)
	module:CreateShadow(_G.GroupLootHistoryFrame.ResizeButton)

	_G.GroupLootHistoryFrame.ResizeButton:SetTemplate("Transparent")
	_G.GroupLootHistoryFrame:SetWidth(300)
	_G.GroupLootHistoryFrame.ResizeButton:SetWidth(300)

	if E.private.general.loot then
		_G.ElvLootFrame:Styling()
	end

	-- Boss Banner
	hooksecurefunc('BossBanner_ConfigureLootFrame', function(lootFrame)
		if not lootFrame.__MERSkin then
			local iconHitBox = lootFrame.IconHitBox

			S:HandleIcon(lootFrame.Icon, true)
			iconHitBox.IconBorder:SetTexture(nil)
			S:HandleIconBorder(iconHitBox.IconBorder, lootFrame.Icon.backdrop)

			lootFrame.Anim.__owner = lootFrame
			lootFrame.Anim:HookScript("OnPlay", HideIconBG)
			lootFrame.Anim:HookScript("OnFinished", ShowIconBG)

			lootFrame.__MERSkin = true
		end
	end)
end

module:AddCallback("LootFrame")

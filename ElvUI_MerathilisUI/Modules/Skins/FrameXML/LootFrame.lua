local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

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

	module:CreateShadow(_G.BonusRollFrame)
	module:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	module:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

	module:CreateShadow(_G.GroupLootHistoryFrame)
	module:CreateShadow(_G.GroupLootHistoryFrame.ResizeButton)

	_G.GroupLootHistoryFrame.ResizeButton:SetTemplate("Transparent")
	_G.GroupLootHistoryFrame:SetWidth(300)
	_G.GroupLootHistoryFrame.ResizeButton:SetWidth(300)

	_G.GroupLootHistoryFrame.ScrollBox:ClearAllPoints()
	_G.GroupLootHistoryFrame.ScrollBox:SetPoint("TOPLEFT", _G.GroupLootHistoryFrame, "TOPLEFT", 6, -90)
	_G.GroupLootHistoryFrame.ScrollBox:SetPoint("BOTTOMRIGHT", _G.GroupLootHistoryFrame, "BOTTOMRIGHT", -23, 5)

	F.MoveFrameWithOffset(_G.GroupLootHistoryFrame.Timer, 0, -7)

	-- Boss Banner
	hooksecurefunc("BossBanner_ConfigureLootFrame", function(lootFrame)
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

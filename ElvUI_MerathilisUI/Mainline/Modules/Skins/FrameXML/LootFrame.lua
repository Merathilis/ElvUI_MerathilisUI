local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local C_LootHistory_GetNumItems = C_LootHistory.GetNumItems

local function LootHistoryFrame_Update()
	local numItems = C_LootHistory_GetNumItems()
	for i = 1, numItems do
		local frame = _G.LootHistoryFrame.itemFrames[i]
		if frame and not frame.__MERSkin then
			F.SetFontOutline(frame.WinnerRoll, nil, 13)
			frame.__MERSkin = true
		end
	end
end

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
	module:CreateShadow(_G.BonusRollFrame)

	_G.LootHistoryFrame:Styling()
	module:CreateShadow(_G.LootHistoryFrame)
	_G.LootHistoryFrame:SetWidth(300)
	module:CreateShadow(_G.LootHistoryFrame.ResizeButton)
	_G.LootHistoryFrame.ResizeButton:SetWidth(300)
	_G.LootHistoryFrame.ResizeButton:SetTemplate('Transparent')

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

	hooksecurefunc('LootHistoryFrame_FullUpdate', LootHistoryFrame_Update)
end

S:AddCallback("LootFrame", LoadSkin)

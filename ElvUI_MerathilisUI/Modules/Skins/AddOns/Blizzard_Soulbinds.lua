local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local hooksecurefunc = hooksecurefunc

local function UpdateButtonRank(button)
	if not button.levelText then
		button.levelText = button:CreateFontString(nil, 'OVERLAY')
		button.levelText:FontTemplate(nil, 14)
		button.levelText:ClearAllPoints()
		button.levelText:SetPoint('BOTTOMLEFT', button.Icon)
	end
	button.levelText:SetText(button.conduitData.conduitRank)
end

local function SkinConduitList(frame)
	for button in frame.pool:EnumerateActive() do
		if not button.IsSkinned then
			UpdateButtonRank(button)
			hooksecurefunc(button, 'UpdateVisuals', UpdateButtonRank)
			button.IsSkinned = true
		end
	end
end

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.soulbinds) or E.private.muiSkins.blizzard.soulbinds ~= true then return end

	local frame = _G.SoulbindViewer
	if frame.backdrop then
		frame.backdrop:Styling()
	end

	local scrollBox = frame.ConduitList.ScrollBox
	for i = 1, 3 do
		hooksecurefunc(scrollBox.ScrollTarget.Lists[i], 'UpdateLayout', SkinConduitList)
	end
end

S:AddCallbackForAddon('Blizzard_Soulbinds', "mUISoulbinds", LoadSkin)

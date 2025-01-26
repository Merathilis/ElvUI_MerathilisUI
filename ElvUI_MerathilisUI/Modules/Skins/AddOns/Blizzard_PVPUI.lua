local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:Blizzard_PVPUI()
	if not module:CheckDB("pvp", "pvp") then
		return
	end

	module:CreateBackdropShadow(_G.PVPReadyDialog)

	local PVPQueueFrame = _G.PVPQueueFrame
	local HonorFrame = _G.HonorFrame
	local ConquestFrame = _G.ConquestFrame
	local PlunderstormFrame = _G.PlunderstormFrame

	local iconSize = 56 - 2 * E.mult
	for i = 1, 4 do
		local bu = PVPQueueFrame["CategoryButton" .. i]
		local cu = bu.CurrencyDisplay

		bu.Name:SetTextColor(1, 1, 1)

		bu.Icon:SetSize(iconSize, iconSize)
		bu.Icon:SetDrawLayer("OVERLAY")
		bu.Icon:ClearAllPoints()
		bu.Icon:SetPoint("LEFT", bu, "LEFT", 5, 0)

		if cu then
			local ic = cu.Icon

			ic:SetSize(16, 16)
			ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			ic:SetTexCoord(unpack(E.TexCoords))
			ic.bg = module:CreateBG(ic)
			ic.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	local HonorInset = PVPQueueFrame.HonorInset

	if not HonorInset.backdrop then
		HonorInset:CreateBackdrop("Transparent")
		HonorInset.backdrop:SetOutside(HonorInset)
	end

	if PlunderstormFrame then
		if not PlunderstormFrame.backdrop then
			PlunderstormFrame:CreateBackdrop("Transparent")
			PlunderstormFrame.backdrop:SetPoint("TOPLEFT", PlunderstormFrame, "TOPLEFT", 3, 1)
			PlunderstormFrame.backdrop:SetPoint("BOTTOMRIGHT", PlunderstormFrame, "BOTTOMRIGHT", -4, 25)
		end

		local panel = PVPQueueFrame.HonorInset.PlunderstormPanel
		if panel then
			S:HandleButton(panel.PlunderstoreButton)
			F.ReplaceIconString(panel.PlunderDisplay)
			hooksecurefunc(panel.PlunderDisplay, "SetText", F.ReplaceIconString)
		end

		local popup = _G.PlunderstormFramePopup
		if popup then
			popup:StripTextures()
			popup:CreateBackdrop("Transparent")
			S:HandleButton(popup.AcceptButton)
			S:HandleButton(popup.DeclineButton)
		end
	end

	-- Casual - HonorFrame
	local BonusFrame = HonorFrame.BonusFrame

	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	for _, bonusButton in pairs({
		"RandomBGButton",
		"RandomEpicBGButton",
		"Arena1Button",
		"BrawlButton",
		"BrawlButton2", --[["SpecialEventButton"]]
	}) do
		local button = BonusFrame[bonusButton]

		button.SelectedTexture:SetDrawLayer("BACKGROUND")
		button.SelectedTexture:SetColorTexture(r, g, b, 0.2)
		button.SelectedTexture:SetAllPoints()

		button.Reward.Icon:SetInside(button.Reward)
	end

	-- Conquest
	for _, bu in pairs({
		ConquestFrame.RatedSoloShuffle,
		ConquestFrame.Arena2v2,
		ConquestFrame.Arena3v3,
		ConquestFrame.RatedBG,
	}) do
		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, 0.25)
		bu.SelectedTexture:SetAllPoints()
	end
	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)
end

module:AddCallbackForAddon("Blizzard_PVPUI")

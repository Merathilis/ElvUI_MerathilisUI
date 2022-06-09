local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs, unpack = pairs, unpack

local CreateFrame = CreateFrame

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("pvp", "pvp") then
		return
	end

	_G.PVPReadyDialog:Styling()
	MER:CreateBackdropShadow(_G.PVPReadyDialog)

	local PVPQueueFrame = _G.PVPQueueFrame
	local HonorFrame = _G.HonorFrame
	local ConquestFrame = _G.ConquestFrame

	local iconSize = 56-2*E.mult
	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
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

	-- Casual - HonorFrame
	local BonusFrame = HonorFrame.BonusFrame

	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	for _, bonusButton in pairs({"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton", "BrawlButton2", --[["SpecialEventButton"]]}) do
		local button = BonusFrame[bonusButton]

		button.SelectedTexture:SetDrawLayer("BACKGROUND")
		button.SelectedTexture:SetColorTexture(r, g, b, .2)
		button.SelectedTexture:SetAllPoints()

		button.Reward.Icon:SetInside(button.Reward)
	end

	-- Honor frame specific
	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		-- Hide ElvUI backdrop
		if bu.backdrop then
			bu.backdrop:Hide()
		end

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		module:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = module:CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(unpack(E.TexCoords))
		bu.Icon.bg = module:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	-- Conquest
	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:SetAllPoints()
	end
	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)
end

S:AddCallbackForAddon("Blizzard_PVPUI", LoadSkin)

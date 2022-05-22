local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function StyleRewardButton(button)
	local buttonName = button:GetName()

	local icon = _G[buttonName.."IconTexture"]
	local cta = _G[buttonName.."ShortageBorder"]
	local count = _G[buttonName.."Count"]
	local na = _G[buttonName.."NameFrame"]

	icon:SetTexCoord(unpack(E.TexCoords))
	icon:SetDrawLayer("OVERLAY")

	count:SetDrawLayer("OVERLAY")

	na:SetColorTexture(0, 0, 0, .25)
	na:SetSize(110, 39)
	na:ClearAllPoints()
	na:SetPoint("LEFT", icon, "RIGHT", -7, 0)

	if button.IconBorder then
		button.IconBorder:SetAlpha(0)
	end

	if cta then
		cta:SetAlpha(0)
	end

	button.bg2 = CreateFrame("Frame", nil, button)
	button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
	button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT", -1, 0)
	button.bg2:SetFrameStrata("BACKGROUND")
	MERS:CreateBD(button.bg2, .25)
	MERS:CreateGradient(button.bg2)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.mui.skins.blizzard.lfg ~= true then return; end

	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, _, index, _, _, _, _, _, _, _, _, _, _)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		if button and not button.styled then
			StyleRewardButton(button)
			button.styled = true
		end
	end)

	StyleRewardButton(_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	StyleRewardButton(_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

	_G.LFGDungeonReadyDialogBackground:SetAlpha(0.5)
end

S:AddCallback("mUILFG", LoadSkin)

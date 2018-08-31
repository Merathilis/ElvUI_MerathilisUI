local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, LFGListInviteDialog_Show

local function styleLFG()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.lfg ~= true then return; end

	local function styleRewardButton(button)
		MERS:ReskinItemFrame(button)
		button._mUINameBG:SetPoint("RIGHT", -4, 0)

		if button.shortageBorder then
			button.shortageBorder:SetAlpha(0)
		end
	end

	styleRewardButton(LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(ScenarioQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

	--Reward frame functions
	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, _, index, _, _, _, _, _, _, _, _, _, _)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		if button and not button._mUINameBG then
			styleRewardButton(button)
		end
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		if not button.styled then
			local border = _G[button:GetName().."Border"]
			button.texture:SetTexCoord(unpack(E.TexCoords))

			border:SetColorTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end
		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		if not button.styled then
			local border = _G[button:GetName().."Border"]
			button.texture:SetTexCoord(unpack(E.TexCoords))

			border:SetColorTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		local texturePath, _
		if rewardType == "reward" then
			_, texturePath, _ = GetLFGDungeonRewardInfo(dungeonID, rewardIndex)
		elseif rewardType == "shortage" then
			_, texturePath, _ = GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex)
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)
end

S:AddCallback("mUILFG", styleLFG)
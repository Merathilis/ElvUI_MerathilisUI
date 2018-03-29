local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select = select

--WoW API / Variables
local CreateFrame = CreateFrame
local C_LFGListGetSearchResultInfo = C_LFGList.GetSearchResultInfo
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, LFGListInviteDialog_Show

local function styleLFG()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.lfg ~= true then return; end

	_G["PVEFrame"]:Styling()
	_G["LFGListApplicationDialog"]:Styling()

	for i = 1, 4 do
		local bu = _G["GroupFinderFrame"]["groupButton"..i]
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu.icon:Size(54)
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint("LEFT", bu, "LEFT", 4, 0)
		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon.bg = MERS:CreateBG(bu.icon)
		bu.icon.bg:SetDrawLayer("ARTWORK")

		bu.backdropTexture:Hide()
	end

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

	-- Category selection
	local CategorySelection = _G["LFGListFrame"].CategorySelection

	CategorySelection.Inset.Bg:Hide()
	select(10, CategorySelection.Inset:GetRegions()):Hide()
	CategorySelection.Inset:DisableDrawLayer("BORDER")

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 2, 0)
			bg:SetPoint("BOTTOMRIGHT", -1, 2)
			MERS:CreateBD(bg, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
		end
	end)

	-- Invite frame
	_G["LFGListInviteDialog"]:Styling()
	_G["LFGDungeonReadyDialog"]:Styling()

	_G["LFGListInviteDialog"].GroupName:ClearAllPoints()
	_G["LFGListInviteDialog"].GroupName:SetPoint("TOP", 0, -33)

	_G["LFGListInviteDialog"].ActivityName:ClearAllPoints()
	_G["LFGListInviteDialog"].ActivityName:SetPoint("TOP", 0, -80)

	local orginalFunction = LFGListInviteDialog_Show
	LFGListInviteDialog_Show = function(self, resultID)
		orginalFunction(self, resultID)
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, isAutoAccept = C_LFGListGetSearchResultInfo(resultID)
		self.GroupName:SetText(name .. "\n" .. (leaderName or "") .. "\n" .. numMembers .. L[" members"])
	end
end

S:AddCallback("mUILFG", styleLFG)
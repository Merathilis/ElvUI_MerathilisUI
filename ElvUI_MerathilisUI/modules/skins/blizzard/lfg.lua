local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local select = select

--WoW API / Variables
local C_LFGListGetSearchResultInfo = C_LFGList.GetSearchResultInfo

local function styleLFG()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.lfg ~= true then return; end

	MERS:CreateGradient(PVEFrame)
	if not PVEFrame.stripes then
		MERS:CreateStripes(PVEFrame)
	end

	local function onEnter(self)
		self:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .4)
	end

	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, .25)
	end

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

		bu.backdropTexture:Hide()
	end

	-- Category selection
	local CategorySelection = LFGListFrame.CategorySelection

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

			local tex = MERS:CreateGradient(bu)
			tex:SetDrawLayer("BACKGROUND")
			tex:SetPoint("TOPLEFT", 3, -1)
			tex:SetPoint("BOTTOMRIGHT", -2, 3)
		end
	end)

	-- Invite frame
	MERS:CreateGradient(LFGListInviteDialog)
	MERS:CreateStripes(LFGListInviteDialog)

	LFGListInviteDialog.GroupName:ClearAllPoints()
	LFGListInviteDialog.GroupName:SetPoint("TOP", 0, -33)

	LFGListInviteDialog.ActivityName:ClearAllPoints()
	LFGListInviteDialog.ActivityName:SetPoint("TOP", 0, -80)

	local orginalFunction = LFGListInviteDialog_Show
	LFGListInviteDialog_Show = function(self, resultID)
		orginalFunction(self, resultID)
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, isAutoAccept = C_LFGListGetSearchResultInfo(resultID)
		self.GroupName:SetText(name .. "\n" .. leaderName .. "\n" .. numMembers .. L[" members"])
	end
end

S:AddCallback("mUILFG", styleLFG)
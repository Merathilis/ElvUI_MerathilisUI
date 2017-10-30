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

	_G["PVEFrame"]:Styling(true, true)
	_G["LFGListApplicationDialog"]:Styling(true, true)

	local function onEnter(self)
		self:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .4)
	end

	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, .25)
	end

	for i = 1, 4 do
		local bu = _G["GroupFinderFrame"]["groupButton"..i]
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

		bu.backdropTexture:Hide()
	end

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
	_G["LFGListInviteDialog"]:Styling(true, true)
	_G["LFGDungeonReadyDialog"]:Styling(true, true)

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
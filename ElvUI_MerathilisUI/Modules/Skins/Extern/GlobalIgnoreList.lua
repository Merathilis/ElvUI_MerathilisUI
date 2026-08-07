local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local next = next

local function handleAll(list, handler)
	for _, frame in next, list do
		if frame then
			handler(frame)
		end
	end
end

function module:GlobalIgnoreList()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.gil then
		return
	end

	FriendsFrame:HookScript("OnShow", function()
		if not GIL or GIL.IsSkinned then
			return
		end

		S:HandlePortraitFrame(GIL)
		WS:CreateShadow(GIL)

		for i = 1, 3 do
			S:HandleTab(_G["GILTab" .. i])
			WS:ReskinTab(_G["GILTab" .. i])
			S:HandleFrame(_G["GILFrame" .. i])

			for j = 1, 6 do
				local header = _G["GILFrame" .. i .. "Header" .. j]
				if header then
					S:HandleFrame(header)
				end
			end
		end

		S:HandleFrame(_G.GILFrame2Edit)

		handleAll({
			_G.GILFrame3AskNote,
			_G.GILFrame3OpenUI,
			_G.GILFrame3HackUnit,
			_G.GILFrame3HackLFG,
			_G.GILFrame3SameServer,
			_G.GILFrame3TrackChanges,
			_G.GILFrame3SyncWarning,
			_G.GILFrame3EnableFilter,
			_G.GILFrame3InvertFilter,
			_G.GILFrame3UpdateFilter,
			_G.GILFrame3SkipGuild,
			_G.GILFrame3SkipParty,
			_G.GILFrame3SkipPrivate,
			_G.GILFrame3SkipYourself,
			_G.GILFrame2Active,
			_G.GILFrame3SameFaction,
			_G.GILFrame3SyncMsgs,
			_G.GILFrame3ShowDeclines,
			_G.GILFrame3IgnoreResponse,
		}, function(checkbox)
			S:HandleCheckBox(checkbox)
		end)

		handleAll({
			_G.GILFrame1IgnoreButton,
			_G.GILFrame2RemoveButton,
			_G.GILFrame2CreateButton,
			_G.GILFrame2ResetButton,
			_G.GILFrame2EditSaveButton,
			_G.GILFrame2EditCancelButton,
			_G.GILFrame2EditFilterHelp,
			_G.GILFrame2EditTestHelp,
			_G.GILFrame2EditTestTest,
			_G.GILFrame2EditLinkHelp,
			_G.GILFrame1PruneButton,
			_G.GILFrame2BlockButton,
		}, function(button)
			S:HandleButton(button)
		end)

		handleAll({
			_G.GILFrame2EditDescField,
			_G.GILFrame2EditFilterField,
			_G.GILFrame2EditTestField,
			_G.GILFrame2EditLinkField,
			_G.GILFrame3Exp,
		}, function(editBox)
			editBox:StripTextures()
			S:HandleEditBox(editBox)
		end)

		handleAll({
			_G.GILFrame3FloodMenu,
			_G.GILFrame3StrataMenu,
		}, function(dropDown)
			S:HandleDropDownBox(dropDown)
		end)

		handleAll({
			_G.GILSlate3ScrollBar,
		}, function(scroll)
			S:HandleScrollBar(scroll)
		end)

		GIL.IsSkinned = true
	end)

	module:DisableAddOnSkins("GlobalIgnoreList", false)
end

module:AddCallbackForAddon("GlobalIgnoreList")

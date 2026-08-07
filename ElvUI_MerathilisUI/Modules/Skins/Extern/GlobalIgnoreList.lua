local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:GlobalIgnoreList()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.gil then
		return
	end

	FriendsFrame:HookScript("OnShow", function()
		if GIL and not GIL.MERStyle then
			S:HandlePortraitFrame(GIL)
			WS:CreateShadow(GIL)
			for i = 1, 3 do
				S:HandleTab(_G["GILTab" .. i])
				WS:ReskinTab(_G["GILTab" .. i])
				S:HandleFrame(_G["GILFrame" .. i])
				for j = 1, 6 do
					if _G["GILFrame" .. i .. "Header" .. j] then
						S:HandleFrame(_G["GILFrame" .. i .. "Header" .. j])
					end
				end
			end

			S:HandleFrame(GILFrame2Edit)

			local checkBoxes = {
				GILFrame3AskNote,
				GILFrame3OpenUI,
				GILFrame3HackUnit,
				GILFrame3HackLFG,
				GILFrame3SameServer,
				GILFrame3TrackChanges,
				GILFrame3SyncWarning,
				GILFrame3EnableFilter,
				GILFrame3InvertFilter,
				GILFrame3UpdateFilter,
				GILFrame3SkipGuild,
				GILFrame3SkipParty,
				GILFrame3SkipPrivate,
				GILFrame3SkipYourself,
				GILFrame2Active,
				GILFrame3SameFaction,
				GILFrame3SyncMsgs,
				GILFrame3ShowDeclines,
				GILFrame3IgnoreResponse,
			}
			for _, checkbox in next, checkBoxes do
				if checkbox then
					S:HandleCheckBox(checkbox)
				end
			end

			local buttons = {
				GILFrame1IgnoreButton,
				GILFrame2RemoveButton,
				GILFrame2CreateButton,
				GILFrame2ResetButton,
				GILFrame2EditSaveButton,
				GILFrame2EditCancelButton,
				GILFrame2EditFilterHelp,
				GILFrame2EditTestHelp,
				GILFrame2EditTestTest,
				GILFrame2EditLinkHelp,
				GILFrame1PruneButton,
				GILFrame2BlockButton,
			}
			for _, button in next, buttons do
				if button then
					S:HandleButton(button)
				end
			end

			local editBoxes = {
				GILFrame2EditDescField,
				GILFrame2EditFilterField,
				GILFrame2EditTestField,
				GILFrame2EditLinkField,
				GILFrame3Exp,
			}
			for _, editBox in next, editBoxes do
				if editBox then
					editBox:StripTextures()
					S:HandleEditBox(editBox)
				end
			end

			local dropDowns = {
				GILFrame3FloodMenu,
				GILFrame3StrataMenu,
			}
			for _, dropDown in next, dropDowns do
				if dropDown then
					S:HandleDropDownBox(dropDown)
				end
			end

			GIL.MERStyle = true
		end
	end)

	module:DisableAddOnSkins("GlobalIgnoreList", false)
end

module:AddCallbackForAddon("GlobalIgnoreList")

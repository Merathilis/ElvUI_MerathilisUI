local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("BugSack") then return; end

-- Cache global variables
-- Lua functions
local pairs = pairs
-- WoW API / Variables
-- GLOBALS: hooksecurefunc

local function styleBugSack(event, addon)
	if E.private.muiSkins.addonSkins.bs ~= true then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.IsSkinned then return end

		MERS:StripTextures(BugSackFrame)
		MERS:CreateBD(BugSackFrame, .5)
		BugSackTabAll:ClearAllPoints()
		BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 0)
		S:HandleTab(BugSackTabAll)
		S:HandleTab(BugSackTabSession)
		S:HandleTab(BugSackTabLast)
		S:HandleScrollBar(BugSackScrollScrollBar)
		S:HandleButton(BugSackNextButton)
		S:HandleButton(BugSackSendButton)
		S:HandleButton(BugSackPrevButton)
		for _, child in pairs({BugSackFrame:GetChildren()}) do
			if (child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack) then
				S:HandleCloseButton(child)
			end
		end
		MERS:CreateGradient(BugSackFrame)
		MERS:CreateStripes(BugSackFrame)

		BugSackFrame.IsSkinned = true
	end)
end

S:AddCallbackForAddon("BugSack", "mUIBugSack", styleBugSack)
local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("BugSack") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS: BugSack, BugSackFrame, BugSackTabAll

local function styleBugSack(event, addon)
	if E.private.muiSkins.addonSkins.bs ~= true then return end


	hooksecurefunc(BugSack, "OpenSack", function()
		if not BugSack.IsSkinned then
			BugSackFrame:StripTextures()

			BugSackFrame:CreateBackdrop("Transparent")
			BugSackFrame.backdrop:Styling()

			BugSackTabAll:ClearAllPoints()
			BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, -1)

			S:HandleTab(BugSackTabAll)
			S:HandleTab(BugSackTabSession)
			S:HandleTab(BugSackTabLast)
			S:HandleScrollBar(BugSackScrollScrollBar)
			S:HandleButton(BugSackNextButton)
			S:HandleButton(BugSackSendButton)
			S:HandleButton(BugSackPrevButton)

			for _, child in pairs({ BugSackFrame:GetChildren() }) do
				if (child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack) then
					S:HandleCloseButton(child)
				end
			end

			BugSack.IsSkinned = true
		end
	end)
end

S:AddCallbackForAddon("BugSack", "mUIBugSack", styleBugSack)

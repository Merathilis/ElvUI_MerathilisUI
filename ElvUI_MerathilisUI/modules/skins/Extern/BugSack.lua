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
-- GLOBALS: BugSack

local function styleBugSack(event, addon)
	if E.private.muiSkins.addonSkins.bs ~= true then return end

	local BugSackFrame = _G.BugSackFrame
	local BugSackTabAll = _G.BugSackTabAll

	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.IsSkinned then return end

		BugSackFrame:StripFrame()
		MERS:CreateBD(BugSackFrame, .5)
		BugSackTabAll:ClearAllPoints()
		BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 0)
		S:HandleTab(BugSackTabAll)
		S:HandleTab(_G.BugSackTabSession)
		S:HandleTab(_G.BugSackTabLast)
		S:HandleScrollBar(_G.BugSackScrollScrollBar)
		S:HandleButton(_G.BugSackNextButton)
		S:HandleButton(_G.BugSackSendButton)
		S:HandleButton(_G.BugSackPrevButton)
		for _, child in pairs({ BugSackFrame:GetChildren() }) do
			if (child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack) then
				S:HandleCloseButton(child)
			end
		end
		BugSackFrame:Styling()

		BugSackFrame.IsSkinned = true
	end)
end

S:AddCallbackForAddon("BugSack", "mUIBugSack", styleBugSack)

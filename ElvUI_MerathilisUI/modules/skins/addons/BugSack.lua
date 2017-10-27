local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("BugSack") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, BugSack

local function styleBugSack(event, addon)
	if E.private.muiSkins.addonSkins.bs ~= true then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if _G["BugSackFrame"].IsSkinned then return end

		MERS:StripTextures(_G["BugSackFrame"])
		MERS:CreateBD(_G["BugSackFrame"], .5)
		_G["BugSackTabAll"]:ClearAllPoints()
		_G["BugSackTabAll"]:SetPoint("TOPLEFT", _G["BugSackFrame"], "BOTTOMLEFT", 0, 0)
		S:HandleTab(_G["BugSackTabAll"])
		S:HandleTab(_G["BugSackTabSession"])
		S:HandleTab(_G["BugSackTabLast"])
		S:HandleScrollBar(_G["BugSackScrollScrollBar"])
		S:HandleButton(_G["BugSackNextButton"])
		S:HandleButton(_G["BugSackSendButton"])
		S:HandleButton(_G["BugSackPrevButton"])
		for _, child in pairs({_G["BugSackFrame"]:GetChildren()}) do
			if (child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack) then
				S:HandleCloseButton(child)
			end
		end
		_G["BugSackFrame"]:Styling()

		_G["BugSackFrame"].IsSkinned = true
	end)
end

S:AddCallbackForAddon("BugSack", "mUIBugSack", styleBugSack)
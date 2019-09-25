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

local function LoadAddOnSkin()
	if E.private.muiSkins.addonSkins.bs ~= true then return end

	hooksecurefunc(_G.BugSack, "OpenSack", function()
		if not _G.BugSack.IsSkinned then
			_G.BugSackFrame:StripTextures()

			_G.BugSackFrame:CreateBackdrop("Transparent")
			_G.BugSackFrame.backdrop:Styling()

			_G.BugSackTabAll:ClearAllPoints()
			_G.BugSackTabAll:SetPoint("TOPLEFT", _G.BugSackFrame, "BOTTOMLEFT", 0, -1)

			S:HandleTab(_G.BugSackTabAll)
			S:HandleTab(_G.BugSackTabSession)
			S:HandleTab(_G.BugSackTabLast)
			S:HandleScrollBar(_G.BugSackScrollScrollBar)
			S:HandleButton(_G.BugSackNextButton)
			S:HandleButton(_G.BugSackSendButton)
			S:HandleButton(_G.BugSackPrevButton)

			for _, child in pairs({ _G.BugSackFrame:GetChildren() }) do
				if (child:IsObjectType("Button") and child:GetScript("OnClick") == _G.BugSack.CloseSack) then
					S:HandleCloseButton(child)
				end
			end

			_G.BugSack.IsSkinned = true
		end
	end)
end

S:AddCallbackForAddon("BugSack", "mUIBugSack", LoadAddOnSkin)

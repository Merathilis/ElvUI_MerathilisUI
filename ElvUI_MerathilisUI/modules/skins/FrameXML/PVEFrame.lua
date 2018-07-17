local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function stylePVE()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.lfg ~= true then return; end

	local PVEFrame = _G["PVEFrame"]
	PVEFrame:Styling()
	PVEFrame:DisableDrawLayer("ARTWORK")
	PVEFrameLeftInset:DisableDrawLayer("BORDER")
	PVEFrameLeftInsetBg:Hide()
	PVEFrameBlueBg:Hide()
	PVEFrameBlueBg.Show = MER.dummy
	PVEFrameTopFiligree:Hide()
	PVEFrameTopFiligree.Show = MER.dummy
	PVEFrameBottomFiligree:Hide()
	PVEFrameBottomFiligree.Show = MER.dummy
	PVEFrame.shadows:Hide()
	PVEFrame.shadows.Show = MER.dummy

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

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = _G["GroupFinderFrame"]
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)
end

S:AddCallback("mUIPVE", stylePVE)
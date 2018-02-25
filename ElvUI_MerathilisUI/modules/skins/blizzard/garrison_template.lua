local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleGarrisonTemplate()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.muiSkins.blizzard.garrison ~= true then return end

	hooksecurefunc(GarrisonFollowerTabMixin, "ShowFollower", function(self, followerID, followerList)
		local followerInfo = C_Garrison.GetFollowerInfo(followerID)
		if not followerInfo then return end

		if not self.PortraitFrame.styled then
			MERS:ReskinGarrisonPortrait(self.PortraitFrame)

			self.PortraitFrame.styled = true
		end

		local color = ITEM_QUALITY_COLORS[followerInfo.quality]
		self.PortraitFrame:SetBackdropBorderColor(color.r, color.g, color.b)

		self.XPBar:ClearAllPoints()
		self.XPBar:SetPoint("BOTTOMLEFT", self.PortraitFrame, "BOTTOMRIGHT", 7, -15)
	end)
end

S:AddCallbackForAddon("Blizzard_GarrisonTemplates", "mUIGarrisonTemplate", styleGarrisonTemplate)
local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

do --[[ FrameXML\GarrisonBaseUtils.lua ]]
	function MERS.GarrisonFollowerPortraitMixin_SetQuality(self, quality)
		if not self._auroraPortraitBG then return end
		local color = ITEM_QUALITY_COLORS[quality]
		self._mUIPortraitBG:SetBackdropBorderColor(color.r, color.g, color.b)
		self._mUILvlBG:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	function MERS.GarrisonFollowerPortraitMixin_SetNoLevel(self)
		if not self._auroraLvlBG then return end
		self._mUILvlBG:Hide()
	end

	function MERS.GarrisonFollowerPortraitMixin_SetLevel(self)
		if not self._auroraLvlBG then return end
		self._mUILvlBG:Show()
	end

	function MERS.GarrisonFollowerPortraitMixin_SetILevel(self)
		if not self._auroraLvlBG then return end
		self._mUILvlBG:Show()
	end
end

do --[[ FrameXML\GarrisonBaseUtils.xml ]]
	function MERS:PositionGarrisonAbiltyBorder(border, icon)
		border:ClearAllPoints()
		border:SetPoint("TOPLEFT", icon, -8, 8)
		border:SetPoint("BOTTOMRIGHT", icon, 8, -8)
	end

	function MERS:GarrisonFollowerPortraitTemplate(Frame)
		Frame.PortraitRing:Hide()
		Frame.Portrait:SetPoint("CENTER", 0, 4)
		Frame.PortraitRingQuality:SetTexture("")

		local portraitBG = CreateFrame("Frame", nil, Frame)
		portraitBG:SetFrameLevel(Frame:GetFrameLevel())
		portraitBG:SetPoint("TOPLEFT", Frame.Portrait, -1, 1)
		portraitBG:SetPoint("BOTTOMRIGHT", Frame.Portrait, 1, -1)
		Frame._mUIPortraitBG = portraitBG

		Frame.LevelBorder:SetAlpha(0)
		local lvlBG = CreateFrame("Frame", nil, Frame)
		lvlBG:SetPoint("TOPLEFT", portraitBG, "BOTTOMLEFT", 0, 6)
		lvlBG:SetPoint("BOTTOMRIGHT", portraitBG, 0, -10)
		Frame._mUILvlBG = lvlBG

		Frame.Level:SetParent(lvlBG)
		Frame.Level:SetPoint("CENTER", lvlBG)

		Frame.PortraitRingCover:SetTexture("")
	end
end

hooksecurefunc(GarrisonFollowerPortraitMixin, "SetQuality", MERS.GarrisonFollowerPortraitMixin_SetQuality)
hooksecurefunc(GarrisonFollowerPortraitMixin, "SetNoLevel", MERS.GarrisonFollowerPortraitMixin_SetNoLevel)
hooksecurefunc(GarrisonFollowerPortraitMixin, "SetLevel", MERS.GarrisonFollowerPortraitMixin_SetLevel)
hooksecurefunc(GarrisonFollowerPortraitMixin, "SetILevel", MERS.GarrisonFollowerPortraitMixin_SetILevel)
local MER, E, L, V, P, G = unpack(select(2, ...))
local MDB = E:GetModule("mUI_databars")
local M = E:GetModule("DataBars")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local InCombatLockdown = InCombatLockdown

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, selectioncolor, PVP_TALENTS_TAB, HONOR, ShowUIPanel, HideUIPanel, TalentFrame_LoadUI

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == "NoBackdrop" then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(HONOR, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local bar = _G["ElvUI_HonorBar"]

	-- bottom decor/button
	bar.fb = CreateFrame("Button", nil, bar)
	bar.fb:Point("TOPLEFT", bar, "BOTTOMLEFT", 0, -SPACING)
	bar.fb:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, (E.PixelMode and -20 or -22))

	bar.fb:SetScript('OnEnter', onEnter)
	bar.fb:SetScript('OnLeave', onLeave)

	bar.fb:SetScript('OnClick', function(self)
		if not _G["PlayerTalentFrame"] then
			TalentFrame_LoadUI()
		end

		if not _G["PlayerTalentFrame"]:IsShown() then
			ShowUIPanel(_G["PlayerTalentFrame"])
			_G["PlayerTalentFrameTab"..PVP_TALENTS_TAB]:Click()
		else
			HideUIPanel(_G["PlayerTalentFrame"])
		end
	end)

	MDB:ToggleHonorBackdrop()
end

function MDB:ApplyHonorStyling()
	local bar = _G["ElvUI_HonorBar"]
	if E.db.databars.honor.enable then
		if bar.fb then
			if E.db.databars.artifact.orientation == "VERTICAL" then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end
end

function MDB:ToggleHonorBackdrop()
	local bar = _G["ElvUI_HonorBar"]

	if bar.fb then
		bar.fb:SetTemplate("Transparent")
	end
end

function MDB:LoadHonor()
	local bar = _G["ElvUI_HonorBar"]

	StyleBar()
	self:ApplyHonorStyling()

	hooksecurefunc(M, 'UpdateHonorDimensions', MDB.ApplyHonorStyling)
end

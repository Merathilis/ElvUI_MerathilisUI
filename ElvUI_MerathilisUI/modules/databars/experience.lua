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
local ShowUIPanel = ShowUIPanel
local HideUIPanel = HideUIPanel

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, selectioncolor, SPELLBOOK_ABILITIES_BUTTON

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == "NoBackdrop" then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(SPELLBOOK_ABILITIES_BUTTON, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local xp = _G["ElvUI_ExperienceBar"]

	-- bottom decor/button
	xp.fb = CreateFrame("Button", nil, xp)
	xp.fb:Point("TOPLEFT", xp, "BOTTOMLEFT", 0, -SPACING)
	xp.fb:Point("BOTTOMRIGHT", xp, "BOTTOMRIGHT", 0, (E.PixelMode and -20 or -22))

	xp.fb:SetScript("OnEnter", onEnter)
	xp.fb:SetScript("OnLeave", onLeave)

	xp.fb:SetScript("OnClick", function(self)
		if not _G["SpellBookFrame"]:IsShown() then
			ShowUIPanel(_G["SpellBookFrame"])
		else
			HideUIPanel(_G["SpellBookFrame"])
		end
	end)

	MDB:ToggleXPBackdrop()
end

function MDB:ApplyXpStyling()
	local xp = _G["ElvUI_ExperienceBar"]
	if E.db.databars.experience.enable then
		if xp.fb then
			if E.db.databars.experience.orientation == 'VERTICAL' then
				xp.fb:Show()
			else
				xp.fb:Hide()
			end
		end
	end
end

function MDB:ToggleXPBackdrop()
	local bar = _G["ElvUI_ExperienceBar"]

	if bar.fb then
		bar.fb:SetTemplate("Transparent")
	end
end

function MDB:LoadXP()
	StyleBar()
	self:ApplyXpStyling()

	hooksecurefunc(M, "UpdateExperienceDimensions", MDB.ApplyXpStyling)
end
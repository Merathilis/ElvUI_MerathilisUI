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
local SocketInventoryItem = SocketInventoryItem

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, selectioncolor, ARTIFACT_POWER, ShowUIPanel, HideUIPanel

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == 'NoBackdrop' then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(ARTIFACT_POWER, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local bar = _G["ElvUI_ArtifactBar"]

	-- bottom decor/button
	bar.fb = CreateFrame("Button", nil, bar)
	bar.fb:SetScript('OnEnter', onEnter)
	bar.fb:SetScript('OnLeave', onLeave)
	bar.fb:Point("TOPLEFT", bar, "BOTTOMLEFT", 0, -SPACING)
	bar.fb:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, (E.PixelMode and -20 or -22))

	bar.fb:SetScript('OnClick', function(self)
		if not _G["ArtifactFrame"] or not _G["ArtifactFrame"]:IsShown() then
			ShowUIPanel(SocketInventoryItem(16))
		elseif _G["ArtifactFrame"] and _G["ArtifactFrame"]:IsShown() then
			HideUIPanel(_G["ArtifactFrame"])
		end
	end)

	MDB:ToggleAFBackdrop()
end

function MDB:ToggleAFBackdrop()
	local bar = _G["ElvUI_ArtifactBar"]

	if bar.fb then
		bar.fb:SetTemplate("Transparent", true)
	end
end

function MDB:ApplyAfStyling()
	local bar =_G["ElvUI_ArtifactBar"]

	if E.db.databars.artifact.enable then
		if bar.fb then
			if E.db.databars.artifact.orientation == "VERTICAL" then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end
end

function MDB:LoadAF()
	StyleBar()
	self:ApplyAfStyling()

	hooksecurefunc(M, "UpdateArtifactDimensions", MDB.ApplyAfStyling)
end
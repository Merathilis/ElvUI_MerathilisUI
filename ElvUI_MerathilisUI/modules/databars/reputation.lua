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
-- GLOBALS: hooksecurefunc, BINDING_NAME_TOGGLECHARACTER2, selectioncolor

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == "NoBackdrop" then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(BINDING_NAME_TOGGLECHARACTER2, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local rp = _G["ElvUI_ReputationBar"]

	-- bottom decor/button
	rp.fb = CreateFrame("Button", nil, rp)
	rp.fb:Point("TOPLEFT", rp, "BOTTOMLEFT", 0, -SPACING)
	rp.fb:Point("BOTTOMRIGHT", rp, "BOTTOMRIGHT", 0, (E.PixelMode and -20 or -22))

	rp.fb:SetScript("OnEnter", onEnter)
	rp.fb:SetScript("OnLeave", onLeave)

	rp.fb:SetScript("OnClick", function(self)
		_G["ToggleCharacter"]("ReputationFrame")
	end)

	MDB:ToggleRepBackdrop()
end

function MDB:ApplyRepStyling()
	local rp = _G["ElvUI_ReputationBar"]
	if E.db.databars.reputation.enable then
		if rp.fb then
			if E.db.databars.reputation.orientation == "VERTICAL" then
				rp.fb:Show()
			else
				rp.fb:Hide()
			end
		end
	end
end

function MDB:ToggleRepBackdrop()
	local bar = _G["ElvUI_ReputationBar"]

	if bar.fb then
		bar.fb:SetTemplate("Transparent")
	end
end

function MDB:LoadRep()
	StyleBar()
	self:ApplyRepStyling()

	hooksecurefunc(M, "UpdateReputationDimensions", MDB.ApplyRepStyling)
end
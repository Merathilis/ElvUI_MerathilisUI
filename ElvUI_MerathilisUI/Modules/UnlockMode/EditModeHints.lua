local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Edit Mode hints: in the mover mode, the parts of the interface that are
-- still placed by Blizzard's Edit Mode (no ElvUI mover behind them) get a
-- marker with their Edit Mode name. A click closes the mover mode and opens
-- the Edit Mode. Read-only: the Blizzard frames are never touched.

local _G = _G
local ipairs, pairs, pcall = ipairs, pairs, pcall

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local InCombatLockdown = InCombatLockdown
local IsShiftKeyDown = IsShiftKeyDown
local ShowUIPanel = ShowUIPanel
local UIParent = UIParent

local EDIT_MODE = _G.HUD_EDIT_MODE_MENU or "Edit Mode"

-- How far the anchor chain is followed to find an ElvUI mover
local MAX_DEPTH = 4
local BORDER_COLOR = { r = 0.5, g = 0.5, b = 0.5 }

-- ElvUI places a frame by anchoring it, or a holder it hangs on, to a mover
-- (E:CreateMover sets parent.mover); frames ElvUI replaces are hidden
local function IsElvUIPlaced(region, depth)
	if region.mover or E.CreatedMovers[region:GetName() or ""] then
		return true
	end
	if depth >= MAX_DEPTH then
		return false
	end

	for i = 1, region:GetNumPoints() do
		local _, relativeTo = region:GetPoint(i)
		if relativeTo and relativeTo ~= UIParent and relativeTo ~= E.UIParent then
			if IsElvUIPlaced(relativeTo, depth + 1) then
				return true
			end
		end
	end

	return false
end

local function CheckFrame(frame)
	if not frame:IsVisible() or frame:GetEffectiveAlpha() < 0.05 then
		return false
	end

	local width, height = frame:GetSize()
	if E:IsSecretValue(width) or E:IsSecretValue(height) or width < 2 or height < 2 then
		return false
	end

	return not IsElvUIPlaced(frame, 0)
end

-- Restricted or secret layouts raise errors, those frames are left out
local function IsPlacedByEditMode(frame)
	local ok, result = pcall(CheckFrame, frame)
	return ok and result
end

-------------------------------------------------------------------------------
--  Markers
-------------------------------------------------------------------------------
function module:OpenEditMode()
	local manager = _G.EditModeManagerFrame
	if InCombatLockdown() or not manager or (manager.CanEnterEditMode and not manager:CanEnterEditMode()) then
		return
	end

	-- The ElvUI options would open on top of the Edit Mode
	E.ConfigurationToggled = nil
	E:ToggleMoveMode()
	ShowUIPanel(manager)
end

local function Marker_OnEnter(marker)
	marker:SetBackdropBorderColor(F.r, F.g, F.b, 1)
	marker.tag:SetTextColor(F.r, F.g, F.b)

	GameTooltip:SetOwner(marker, "ANCHOR_CURSOR")
	GameTooltip:AddLine(marker.label:GetText(), 1, 1, 1)
	GameTooltip:AddLine(L["Placed by Blizzard's Edit Mode, not by ElvUI."], nil, nil, nil, true)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["Click: open Blizzard's Edit Mode"], 0.7, 0.7, 0.7)
	GameTooltip:AddLine(L["Shift+Right-click: hide"], 0.7, 0.7, 0.7)
	GameTooltip:Show()
end

local function Marker_OnLeave(marker)
	marker:SetBackdropBorderColor(BORDER_COLOR.r, BORDER_COLOR.g, BORDER_COLOR.b, 0.9)
	marker.tag:SetTextColor(0.6, 0.6, 0.6)
	GameTooltip:Hide()
end

local function Marker_OnClick(marker, button)
	if button == "RightButton" then
		-- Like ElvUI's movers: gone until the mover mode opens again
		if IsShiftKeyDown() then
			marker:Hide()
			GameTooltip:Hide()
		end
	else
		module:OpenEditMode()
	end
end

function module:CreateEditModeMarker()
	-- Below ElvUI's movers (DIALOG), above the Blizzard frames it marks
	local marker = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
	marker:SetFrameStrata("HIGH")
	marker:SetFrameLevel(1)
	marker:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	marker:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	marker:SetBackdropColor(0, 0, 0, 0.45)
	marker:SetScript("OnEnter", Marker_OnEnter)
	marker:SetScript("OnLeave", Marker_OnLeave)
	marker:SetScript("OnClick", Marker_OnClick)

	local label = marker:CreateFontString(nil, "OVERLAY")
	label:FontTemplate(nil, 12, "SHADOW")
	label:SetPoint("CENTER", marker, "CENTER", 0, 6)
	label:SetTextColor(0.85, 0.85, 0.85)
	marker.label = label

	local tag = marker:CreateFontString(nil, "OVERLAY")
	tag:FontTemplate(nil, 10, "SHADOW")
	tag:SetPoint("TOP", label, "BOTTOM", 0, -2)
	tag:SetText(EDIT_MODE)
	marker.tag = tag

	Marker_OnLeave(marker)
	marker:Hide()

	return marker
end

function module:HideEditModeHints()
	if self.editModeMarkers then
		for _, marker in pairs(self.editModeMarkers) do
			marker:Hide()
		end
	end
end

-- which: the layout filter of ElvUI's mover mode, the markers belong to the full view
function module:UpdateEditModeHints(which)
	self:HideEditModeHints()

	if not (E.ConfigurationMode and self:IsActive() and self.db.editModeHints) then
		return
	end
	if which and which ~= "" and which ~= "ALL" and which ~= "GENERAL" then
		return
	end

	local manager = _G.EditModeManagerFrame
	local systems = manager and manager.registeredSystemFrames
	if not systems then
		return
	end

	self.editModeMarkers = self.editModeMarkers or {}
	for _, frame in ipairs(systems) do
		if IsPlacedByEditMode(frame) then
			local marker = self.editModeMarkers[frame]
			if not marker then
				marker = self:CreateEditModeMarker()
				self.editModeMarkers[frame] = marker
			end

			local name = frame.GetSystemName and frame:GetSystemName() or frame:GetName()
			marker.label:SetText(name or EDIT_MODE)
			marker:ClearAllPoints()
			if pcall(marker.SetAllPoints, marker, frame) then
				marker:Show()
			end
		end
	end
end

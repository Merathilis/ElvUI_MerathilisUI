local E, L, V, P, G = unpack(ElvUI);
local TC = E:NewModule('TargetClassIcon', 'AceEvent-3.0')

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitIsPlayer = UnitIsPlayer
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: CLASS_ICON_TCOORDS

if IsAddOnLoaded("ElvUI_Enhanced") then return end;

local classIcon

function TC:TargetChanged()
	classIcon:Hide()

	local class = UnitIsPlayer("target") and select(2, UnitClass("target")) or UnitClassification("target")
	if class then
		--local CLASS_BUTTONS = CLASS_BUTTONS
		local coordinates = CLASS_ICON_TCOORDS[class];
		--local coordinates = CLASS_BUTTONS[class]
		if coordinates then
			classIcon.Texture:SetTexCoord(coordinates[1], coordinates[2], coordinates[3], coordinates[4])
			classIcon:Show()
		end
	end	
end

function TC:ToggleSettings()
	if classIcon.db.enable then
		classIcon:SetSize(classIcon.db.size, classIcon.db.size)
		classIcon:ClearAllPoints()
		classIcon:SetPoint("CENTER", _G["ElvUF_Target"], "CENTER", classIcon.db.xOffset, classIcon.db.yOffset)

		TC:RegisterEvent("PLAYER_TARGET_CHANGED", "TargetChanged")
		TC:TargetChanged()
	else
		TC:UnregisterEvent("PLAYER_TARGET_CHANGED")
		classIcon:Hide()
	end
end

function TC:Initialize()
	classIcon = CreateFrame("Frame", "TargetClass", _G["ElvUF_Target"])
	classIcon:SetFrameLevel(12)
	classIcon.Texture = classIcon:CreateTexture(_G["ElvUF_Target"], "ARTWORK")
	classIcon.Texture:SetAllPoints()
	classIcon.Texture:SetTexture([[Interface\TargetingFrame\UI-Classes-Circles]])
	classIcon.db = E.db.mui.unitframes.unit.target.classicon

	self:ToggleSettings()
end

E:RegisterModule(TC:GetName())
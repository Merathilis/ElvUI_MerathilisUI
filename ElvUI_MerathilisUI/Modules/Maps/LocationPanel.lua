local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_LocationPanel")
local WS = W:GetModule("Skins")

local _G = _G
local format, ipairs, setmetatable = string.format, ipairs, setmetatable

local CreateFrame = CreateFrame
local GetMinimapZoneText = GetMinimapZoneText
local GetSubZoneText = GetSubZoneText
local GetZoneText = GetZoneText
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local C_Map = C_Map
local C_PvP = C_PvP

local COMBAT_ZONE = COMBAT_ZONE
local CONTESTED_TERRITORY = CONTESTED_TERRITORY
local FACTION_CONTROLLED_TERRITORY = FACTION_CONTROLLED_TERRITORY
local FREE_FOR_ALL_TERRITORY = FREE_FOR_ALL_TERRITORY
local NORMAL_FONT_COLOR = _G.NORMAL_FONT_COLOR
local SANCTUARY_TERRITORY = SANCTUARY_TERRITORY
local WORLDMAP_BUTTON = WORLDMAP_BUTTON

local Minimap = _G.Minimap
local mapInfo = E.MapInfo

-- Gap between the panel border, the coordinates and the zone text.
local INSET = 3

-- ElvUI only refreshes E.MapInfo while the player moves, so polling it is cheap.
local COORDS_INTERVAL = 0.1

-- Widest value each format can show; sizes the coordinate slots so the zone text
-- does not shift while the numbers change.
local COORDS_SAMPLE = {
	["%.0f"] = "100",
	["%.1f"] = "100.0",
	["%.2f"] = "100.00",
}

local ZONE_EVENTS = {
	"PLAYER_ENTERING_WORLD",
	"ZONE_CHANGED",
	"ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA",
}

-- Blizzard's own zone colors (Minimap_Update / Minimap_SetTooltip in Blizzard_Minimap),
-- everything not listed uses NORMAL_FONT_COLOR. The minimap text leaves combat zones
-- in the normal color, only the tooltip marks them red.
local ZONE_TEXT_COLORS = {
	sanctuary = { 0.41, 0.8, 0.94 },
	arena = { 1, 0.1, 0.1 },
	friendly = { 0.1, 1, 0.1 },
	hostile = { 1, 0.1, 0.1 },
	contested = { 1, 0.7, 0 },
}

local ZONE_TOOLTIP_COLORS = setmetatable({ combat = { 1, 0.1, 0.1 } }, { __index = ZONE_TEXT_COLORS })

local function GetZoneColor(colors, pvpType)
	local color = pvpType and colors[pvpType]
	if color then
		return color[1], color[2], color[3]
	end

	return NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
end

local function GetZoneTexts()
	local zone = GetZoneText() or ""
	local subZone = GetSubZoneText() or ""
	if subZone == zone then
		subZone = ""
	end

	return zone, subZone
end

function module:GetLocationText()
	local mode = self.db.textMode
	if mode == "ZONE" then
		return GetZoneText()
	elseif mode == "ZONE_SUBZONE" then
		local zone, subZone = GetZoneTexts()
		return subZone ~= "" and format("%s - %s", zone, subZone) or zone
	end

	return GetMinimapZoneText()
end

function module:GetTextColor()
	local mode = self.db.colorMode
	if mode == "CLASS" then
		local cc = E.myClassColor
		return cc.r, cc.g, cc.b
	elseif mode == "CUSTOM" then
		local color = self.db.customColor
		return color.r, color.g, color.b
	end

	return GetZoneColor(ZONE_TEXT_COLORS, (C_PvP.GetZonePVPInfo()))
end

function module:UpdateText()
	if not self.panel then
		return
	end

	self.panel.text:SetText(self:GetLocationText() or "")
	self.panel.text:SetTextColor(self:GetTextColor())

	if _G.GameTooltip:IsOwned(self.panel) then
		self:ShowTooltip()
	end
end

function module:UpdateCoords(force)
	local panel = self.panel
	if not panel or not self.db.coords then
		return
	end

	local x, y = mapInfo.xText, mapInfo.yText
	if not force and x == self.lastX and y == self.lastY then
		return
	end

	self.lastX, self.lastY = x, y

	-- Instances and other restricted areas have no map position.
	local fmt = self.db.coordsFormat
	panel.coordX:SetText(x and format(fmt, x) or "-")
	panel.coordY:SetText(y and format(fmt, y) or "-")
end

local function Panel_OnUpdate(panel, elapsed)
	panel.elapsed = (panel.elapsed or 0) + elapsed
	if panel.elapsed < COORDS_INTERVAL then
		return
	end

	panel.elapsed = 0
	module:UpdateCoords()
end

-- Same content as the tooltip of Blizzard's zone text button on the minimap.
function module:ShowTooltip()
	local panel = self.panel
	local tooltip = _G.GameTooltip
	local zone, subZone = GetZoneTexts()
	local pvpType, _, factionName = C_PvP.GetZonePVPInfo()
	local r, g, b = GetZoneColor(ZONE_TOOLTIP_COLORS, pvpType)

	tooltip:SetOwner(panel, "ANCHOR_NONE")
	tooltip:ClearAllPoints()

	-- Opens towards the middle of the screen, away from the edge the minimap sits on.
	local centerX = panel:GetCenter() * panel:GetEffectiveScale()
	if centerX > (E.UIParent:GetWidth() * E.UIParent:GetEffectiveScale()) / 2 then
		tooltip:SetPoint("TOPRIGHT", panel, "TOPLEFT", -F.Dpi(4), 0)
	else
		tooltip:SetPoint("TOPLEFT", panel, "TOPRIGHT", F.Dpi(4), 0)
	end

	tooltip:AddLine(zone, 1, 1, 1)
	if subZone ~= "" then
		tooltip:AddLine(subZone, r, g, b)
	end

	local territory
	if pvpType == "sanctuary" then
		territory = SANCTUARY_TERRITORY
	elseif pvpType == "arena" then
		territory = FREE_FOR_ALL_TERRITORY
	elseif (pvpType == "friendly" or pvpType == "hostile") and factionName and factionName ~= "" then
		territory = format(FACTION_CONTROLLED_TERRITORY, factionName)
	elseif pvpType == "contested" then
		territory = CONTESTED_TERRITORY
	elseif pvpType == "combat" then
		territory = COMBAT_ZONE
	end

	if territory then
		tooltip:AddLine(territory, r, g, b)
	end

	tooltip:AddLine(" ")
	tooltip:AddDoubleLine(L["Left Click"], WORLDMAP_BUTTON, 1, 1, 1, 0.8, 0.8, 0.8)
	tooltip:Show()
end

-- Goes through the C API instead of ToggleWorldMap(), so the map is not opened
-- from addon code. Closing is only safe out of combat, Escape or M still work.
local function Panel_OnMouseUp(_, button)
	if button ~= "LeftButton" then
		return
	end

	local worldMap = _G.WorldMapFrame
	if worldMap and worldMap:IsShown() then
		if not InCombatLockdown() then
			HideUIPanel(worldMap)
		end
	elseif C_Map.OpenWorldMap then
		C_Map.OpenWorldMap(C_Map.GetBestMapForUnit("player"))
	end
end

-------------------------------------------------------------------------------
-- Panel
-------------------------------------------------------------------------------
-- Left to right: X, zone text, Y. The zone text keeps the same inset on both
-- sides so it stays centered above the Minimap.
function module:UpdateTextLayout()
	local panel = self.panel
	if not panel then
		return
	end

	local gap = F.Dpi(INSET)
	local inset = gap
	local showCoords = self.db.coords
	if showCoords then
		panel.coordX:ClearAllPoints()
		panel.coordX:SetPoint("LEFT", panel, "LEFT", gap, 0)
		panel.coordY:ClearAllPoints()
		panel.coordY:SetPoint("RIGHT", panel, "RIGHT", -gap, 0)
		inset = gap + (panel.coordWidth or 0) + gap
	end

	panel.coordX:SetShown(showCoords)
	panel.coordY:SetShown(showCoords)

	panel.text:ClearAllPoints()
	panel.text:SetPoint("LEFT", panel, "LEFT", inset, 0)
	panel.text:SetPoint("RIGHT", panel, "RIGHT", -inset, 0)
end

function module:UpdateCoordsStyle()
	local panel = self.panel
	local db = self.db

	for _, coord in ipairs({ panel.coordX, panel.coordY }) do
		WF.SetFontWithDB(coord, db.font)
		WF.SetFontColorWithDB(coord, db.coordsColor)
	end

	-- Measure the widest value once so both slots get the same fixed width.
	panel.coordX:SetText(COORDS_SAMPLE[db.coordsFormat] or COORDS_SAMPLE["%.1f"])
	panel.coordWidth = panel.coordX:GetUnboundedStringWidth() + 1
	panel.coordX:SetWidth(panel.coordWidth)
	panel.coordY:SetWidth(panel.coordWidth)

	panel:SetScript("OnUpdate", db.coords and Panel_OnUpdate or nil)
	self:UpdateCoords(true)
end

function module:CreatePanel()
	-- A plain Frame on purpose: minimap button collectors (WindTools' Minimap Buttons)
	-- grab every Button parented to the Minimap and shrink it into their bar.
	local panel = CreateFrame("Frame", "MER_LocationPanel", Minimap)
	panel:SetFrameStrata(Minimap:GetFrameStrata())
	panel:SetFrameLevel(Minimap:GetFrameLevel() + 5)
	panel:EnableMouse(true)
	panel:SetTemplate("Transparent")
	WS:CreateShadow(panel)

	local text = panel:CreateFontString(nil, "OVERLAY")
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetWordWrap(false)
	panel.text = text

	local coordX = panel:CreateFontString(nil, "OVERLAY")
	coordX:SetJustifyH("LEFT")
	coordX:SetWordWrap(false)
	panel.coordX = coordX

	local coordY = panel:CreateFontString(nil, "OVERLAY")
	coordY:SetJustifyH("RIGHT")
	coordY:SetWordWrap(false)
	panel.coordY = coordY

	panel:SetScript("OnMouseUp", Panel_OnMouseUp)
	panel:SetScript("OnEnter", function()
		self:ShowTooltip()
	end)
	panel:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	panel:SetScript("OnEvent", function()
		self:UpdateText()
	end)

	self.panel = panel
end

function module:SettingsUpdate()
	if not self.Initialized or not self.active then
		return
	end

	if not self.panel then
		self:CreatePanel()
	end

	local panel = self.panel
	local backdrop = Minimap.backdrop or Minimap
	local spacing = F.Dpi(self.db.spacing)

	panel:ClearAllPoints()
	panel:SetPoint("BOTTOMLEFT", backdrop, "TOPLEFT", 0, spacing)
	panel:SetPoint("BOTTOMRIGHT", backdrop, "TOPRIGHT", 0, spacing)
	panel:SetHeight(F.Dpi(self.db.height))

	WF.SetFontWithDB(panel.text, self.db.font)
	self:UpdateCoordsStyle()
	self:UpdateTextLayout()
	self:UpdateText()
end

function module:Disable()
	if not self.Initialized or not self.panel then
		return
	end

	self.active = nil
	self.panel:UnregisterAllEvents()
	self.panel:SetScript("OnUpdate", nil)
	self.panel:Hide()
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self.active = true
	self:SettingsUpdate()

	if self.panel then
		for _, event in ipairs(ZONE_EVENTS) do
			self.panel:RegisterEvent(event)
		end
		self.panel:Show()
	end
end

function module:DatabaseUpdate()
	self:Disable()

	self.db = E.db.mui.locationPanel

	F.Event.ContinueOutOfCombat(function()
		if self.db and self.db.enable and E.private.general.minimap.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("LocationPanel.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("LocationPanel.SettingsUpdate", self.SettingsUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())

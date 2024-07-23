local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MiniMapCoords")
local MM = E:GetModule("Minimap")

local _G = _G
local CreateFrame = CreateFrame
local format = string.format
local mapInfo = E.MapInfo

function module:ZoneUpdate()
	if mapInfo.x and mapInfo.y then
		self.restrictedArea = false
	else
		self.restrictedArea = true
		self.coordsHolder.playerCoords:SetText("N/A")
	end
end

function module:UpdateCoords(_, elapsed)
	if self.restrictedArea or not mapInfo.coordsWatching then
		return
	end

	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.33 then
		return
	end

	if mapInfo.x and mapInfo.y then
		if not F.AlmostEqual(mapInfo.x, self.mapInfoX) and not F.AlmostEqual(mapInfo.y, self.mapInfoY) then
			self.mapInfoX = mapInfo.x
			self.mapInfoY = mapInfo.y

			self.coordsHolder.playerCoords:SetText(format(self.displayFormat, mapInfo.xText, mapInfo.yText))
		end
	else
		self.coordsHolder.playerCoords:SetText("N/A")
	end

	self.elapsed = 0
end

function module:UpdateCoordinatesPosition()
	self.coordsHolder.playerCoords:ClearAllPoints()
	self.coordsHolder.playerCoords:SetPoint(
		"CENTER",
		_G.Minimap,
		"CENTER",
		F.Dpi(self.db.xOffset),
		F.Dpi(self.db.yOffset)
	)
end

function module:CreateCoordsFrame()
	self.coordsHolder = CreateFrame("Frame", "MER_CoordsHolder", _G.Minimap)
	self.coordsHolder:SetFrameLevel(_G.Minimap:GetFrameLevel() + 10)
	self.coordsHolder:SetFrameStrata(_G.Minimap:GetFrameStrata())
	self.coordsHolder:SetScript("OnUpdate", self.updateClosure)

	self.coordsHolder.playerCoords = self.coordsHolder:CreateFontString(nil, "OVERLAY")

	self:UpdateCoordinatesPosition()
end

function module:SettingsUpdate()
	if not self.Initialized then
		return
	end
	if not self.coordsHolder then
		self:CreateCoordsFrame()
	end

	F.SetFontDB(self.coordsHolder.playerCoords, self.db.font)

	self.displayFormat = format("%s, %s", self.db.format, self.db.format)
	self:UpdateCoordinatesPosition()
end

function module:Disable()
	if not self.Initialized then
		return
	end

	self:UnhookAll()

	F.Event.UnregisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", self)
	F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_INDOORS", self)
	F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)
	F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED", self)

	if self.coordsHolder then
		self.coordsHolder:Hide()
		self.coordsHolder:SetScript("OnUpdate", nil)
	end
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self:SettingsUpdate()

	if self.coordsHolder then
		self.coordsHolder:Show()
		self.coordsHolder:SetScript("OnUpdate", self.updateClosure)
	end

	F.Event.RegisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", self.ZoneUpdate, self)
	F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_INDOORS", self.ZoneUpdate, self)
	F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.ZoneUpdate, self)
	F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED", self.ZoneUpdate, self)

	self:SecureHook(MM, "UpdateSettings", F.Event.GenerateClosure(self.SettingsUpdate, self))
end

function module:DatabaseUpdate()
	self:Disable()

	self.db = E.db.mui.maps.minimap.coords

	F.Event.ContinueOutOfCombat(function()
		if self.db and self.db.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	self.mapInfoX = 0
	self.mapInfoY = 0
	self.updateClosure = F.Event.GenerateClosure(self.UpdateCoords, self)

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("MiniMapCoords.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("MiniMapCoords.SettingsUpdate", self.SettingsUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())

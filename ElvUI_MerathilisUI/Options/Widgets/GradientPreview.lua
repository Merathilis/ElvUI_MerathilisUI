local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERGradientPreview"
local Version = 1

local function ApplyGradient(widget)
	local colorMapName = widget._colorMapName
	local colorKey = widget._colorKey
	if not colorMapName or not colorKey then
		return
	end

	local db = E.db.mui and E.db.mui.themes and E.db.mui.themes.gradientMode
	if not db then
		return
	end

	local colorMap = db[colorMapName]
	if not colorMap then
		return
	end

	local shiftColor = colorMap[I.Enum.GradientMode.Color.SHIFT] and colorMap[I.Enum.GradientMode.Color.SHIFT][colorKey]
	local normalColor = colorMap[I.Enum.GradientMode.Color.NORMAL]
		and colorMap[I.Enum.GradientMode.Color.NORMAL][colorKey]

	if not shiftColor or not normalColor then
		return
	end

	widget.texture:SetColorTexture(1, 1, 1, 1)
	widget.texture:SetGradient(
		"HORIZONTAL",
		CreateColor(shiftColor.r, shiftColor.g, shiftColor.b, 1),
		CreateColor(normalColor.r, normalColor.g, normalColor.b, 1)
	)
end

-- Track all active widgets so event callbacks can refresh them
local activeWidgets = {}

local eventsRegistered = false
local function RegisterEvents()
	if eventsRegistered then
		return
	end
	eventsRegistered = true

	local function RefreshAll()
		for widget in pairs(activeWidgets) do
			ApplyGradient(widget)
		end
	end

	F.Event.RegisterCallback("MER_Themes.SettingsUpdate.Health", RefreshAll, "MERGradientPreview.Health")
	F.Event.RegisterCallback("MER_Themes.SettingsUpdate.Power", RefreshAll, "MERGradientPreview.Power")
	F.Event.RegisterCallback("MER_Themes.SettingsUpdate", RefreshAll, "MERGradientPreview.Settings")
	F.Event.RegisterCallback("MER_Themes.DatabaseUpdate", RefreshAll, "MERGradientPreview.Database")
end

local function Constructor()
	RegisterEvents()

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(120, 16)
	frame:Hide()

	local texture = frame:CreateTexture(nil, "ARTWORK")
	-- x = 16 as padding/spacing
	texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -1)
	texture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 1)

	local widget = {
		type = Type,
		frame = frame,
		texture = texture,
	}

	widget.OnAcquire = function(self)
		self.frame:Show()
		activeWidgets[self] = true
	end

	widget.OnRelease = function(self)
		self.frame:Hide()
		activeWidgets[self] = nil
		self._colorMapName = nil
		self._colorKey = nil
		self.texture:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 1), CreateColor(0, 0, 0, 1))
	end

	widget.SetText = function(self, text)
		if not text or text == "" then
			return
		end

		local colorMapName, colorKey = strsplit(":", text, 2)
		if not colorMapName or not colorKey then
			return
		end

		self._colorMapName = colorMapName
		self._colorKey = colorKey
		ApplyGradient(self)
	end

	widget.SetLabel = function() end
	widget.SetDisabled = function() end
	widget.SetImage = function() end
	widget.SetImageSize = function() end
	widget.SetFontObject = function() end
	widget.SetJustifyH = function() end
	widget.SetJustifyV = function() end
	widget.SetColor = function() end

	widget.SetWidth = function(self, width)
		self.frame:SetWidth(width)
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)

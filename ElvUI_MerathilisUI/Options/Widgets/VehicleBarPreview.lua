local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local LSM = E.LSM or E.Libs.LSM

local min = math.min
local unpack = unpack
local CreateColor = CreateColor
local CreateFrame = CreateFrame
local C_Spell_GetSpellTexture = C_Spell and C_Spell.GetSpellTexture

-- Sample Vehicle Bar while skyriding. Used as `dialogControl` on a description
-- named "vehicleBar": the eight buttons with skyriding abilities, keybinds and
-- names, and the vigor bar above them with full, recharging and empty charges
-- and the speed text in the Thrill color. Sizes and colors follow
-- Modules/VehicleBar (Create.lua, Update.lua); a bar wider than the options is
-- scaled down.

local HEIGHT = 140
local NUM_BUTTONS = 8
local SPACING = 2
local SAMPLE_SPEED = "212%"

-- Skyriding abilities on the first buttons, the last one leaves the vehicle
local SAMPLE_SPELLS = { 372608, 372610, 361584, 403092, 425782, 374990, 418592 }
local EXIT_TEXTURE = [[Interface\Vehicles\UI-Vehicles-Button-Exit-Up]]
local EXIT_COORDS = { 0.140625, 0.859375, 0.140625, 0.859375 }

-- Charge values of the vigor segments: full, recharging, empty
local SAMPLE_CHARGES = { 1, 1, 1, 1, 0.55, 0 }
local RECHARGE_GRAY = 0.5

local function CreateButton(parent, index)
	local button = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	button:SetTemplate("Transparent")

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetPoint("TOPLEFT", 1, -1)
	button.icon:SetPoint("BOTTOMRIGHT", -1, 1)

	local spell = SAMPLE_SPELLS[index]
	local texture = spell and C_Spell_GetSpellTexture and C_Spell_GetSpellTexture(spell)
	if texture then
		button.icon:SetTexture(texture)
		button.coords = E.TexCoords
	else
		button.icon:SetTexture(EXIT_TEXTURE)
		button.coords = EXIT_COORDS
	end

	-- A font before the first SetText, Update applies the action bar font
	button.hotKey = button:CreateFontString(nil, "OVERLAY")
	button.hotKey:FontTemplate()
	button.hotKey:SetPoint("TOPRIGHT", -1, -2)
	button.hotKey:SetText(index == NUM_BUTTONS and "=" or tostring(index))

	button.name = button:CreateFontString(nil, "OVERLAY")
	button.name:FontTemplate()
	button.name:SetPoint("BOTTOM", 0, 2)
	button.name:SetText("Macro")

	return button
end

-- Vigor colors like CreateVigorSegments: custom, Theme gradient or class color
local function GetVigorColors(vdb)
	if vdb.useCustomColor then
		local left, right = vdb.customColorLeft, vdb.customColorRight
		return CreateColor(left.r, left.g, left.b, 1), CreateColor(right.r, right.g, right.b, 1)
	end

	local theme = E.db.mui.themes.gradientMode
	if theme.enable then
		local left = theme.classColorMap[1][E.myclass]
		local right = theme.classColorMap[2][E.myclass]
		if left and right and left.r and right.r then
			return CreateColor(left.r, left.g, left.b, 1), CreateColor(right.r, right.g, right.b, 1)
		end
	end
end

local function Build(widget)
	local holder = CreateFrame("Frame", nil, widget.frame)
	holder:SetPoint("BOTTOM", widget.frame, "BOTTOM", 0, 8)
	widget.holder = holder

	widget.buttons = {}
	for index = 1, NUM_BUTTONS do
		widget.buttons[index] = CreateButton(holder, index)
	end

	local vigor = CreateFrame("Frame", nil, holder)
	vigor:SetPoint("BOTTOM", holder, "TOP", 0, SPACING * 3)
	widget.vigor = vigor

	vigor.segments = {}
	for index = 1, #SAMPLE_CHARGES do
		local segment = CreateFrame("StatusBar", nil, vigor)
		segment:SetMinMaxValues(0, 1)
		segment:SetValue(SAMPLE_CHARGES[index])

		local bg = segment:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0, 0, 0, 0.5)

		local border = CreateFrame("Frame", nil, segment, "BackdropTemplate")
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetBackdrop({ edgeFile = E.media.blankTex, edgeSize = 1 })
		border:SetBackdropBorderColor(0, 0, 0)

		vigor.segments[index] = segment
	end

	local textLayer = CreateFrame("Frame", nil, vigor)
	textLayer:SetAllPoints()
	textLayer:SetFrameLevel(vigor:GetFrameLevel() + 10)
	vigor.speedText = textLayer:CreateFontString(nil, "OVERLAY")
end

local function UpdateButtons(widget, db, size)
	local height = size / 3 * 2
	local font = LSM:Fetch("font", E.db.actionbar.font)
	local fontSize = min(E.db.actionbar.fontSize, 14)

	for index, button in ipairs(widget.buttons) do
		button:SetSize(size, height)
		button:ClearAllPoints()
		if index == 1 then
			button:SetPoint("BOTTOMLEFT", widget.holder, "BOTTOMLEFT", SPACING, SPACING)
		else
			button:SetPoint("LEFT", widget.buttons[index - 1], "RIGHT", SPACING, 0)
		end

		-- Icons keep their aspect on the 4:3 buttons, like ElvUI's keepSizeRatio crop
		local left, right, top, bottom = unpack(button.coords)
		local crop = (bottom - top) * (1 - height / size) / 2
		button.icon:SetTexCoord(left, right, top + crop, bottom - crop)

		button.hotKey:FontTemplate(font, fontSize, E.db.actionbar.fontOutline)
		button.hotKey:SetShown(db.showKeybinds)
		button.name:FontTemplate(font, fontSize - 2, E.db.actionbar.fontOutline)
		button.name:SetShown(db.showMacro and index ~= NUM_BUTTONS)
	end
end

local function UpdateVigor(widget, vdb, barWidth)
	local vigor = widget.vigor
	vigor:SetShown(vdb.enable)
	if not vdb.enable then
		return
	end

	local width = barWidth - SPACING
	vigor:SetSize(width, vdb.height)

	local texture = LSM:Fetch("statusbar", vdb.darkTexture)
	local leftColor, rightColor = GetVigorColors(vdb)
	local classColor = E:ClassColor(E.myclass, true)
	local segmentWidth = width / #vigor.segments - SPACING * 2

	for index, segment in ipairs(vigor.segments) do
		segment:SetSize(segmentWidth, vdb.height)
		segment:ClearAllPoints()
		if index == 1 then
			segment:SetPoint("LEFT", vigor, "LEFT", SPACING, 0)
		else
			segment:SetPoint("LEFT", vigor.segments[index - 1], "RIGHT", SPACING * 2, 0)
		end

		segment:SetStatusBarTexture(texture)
		local fill = segment:GetStatusBarTexture()
		if SAMPLE_CHARGES[index] < 1 then
			fill:SetGradient("HORIZONTAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 1))
			segment:SetStatusBarColor(RECHARGE_GRAY, RECHARGE_GRAY, RECHARGE_GRAY)
		elseif leftColor then
			segment:SetStatusBarColor(1, 1, 1)
			fill:SetGradient("HORIZONTAL", leftColor, rightColor)
		else
			fill:SetGradient("HORIZONTAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 1))
			segment:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		end
	end

	local text = vigor.speedText
	text:SetShown(vdb.showSpeedText)
	text:SetFont(F.GetFontPath(vdb.speedTextFont), F.FontSizeScaled(vdb.speedTextFontSize), "OUTLINE")
	text:ClearAllPoints()
	text:SetPoint("BOTTOM", vigor, "TOP", 0, vdb.speedTextOffsetY)
	local thrill = vdb.thrillColor
	text:SetText(F.String.Color(SAMPLE_SPEED, F.String.FastRGB(thrill.r, thrill.g, thrill.b)))
end

local function Update(widget)
	local db = E.db.mui.vehicleBar
	local size = db.buttonWidth
	local barWidth = size * NUM_BUTTONS + SPACING * (NUM_BUTTONS - 1) + 4

	widget.holder:SetSize(barWidth, size / 3 * 2 + SPACING * 2)
	-- A wide bar is scaled down to fit the options
	local available = widget.frame:GetWidth() - 16
	widget.holder:SetScale(available > 0 and min(1, available / barWidth) or 1)

	UpdateButtons(widget, db, size)
	UpdateVigor(widget, db.vigorBar, barWidth)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERVehicleBarPreview", 1, HEIGHT, Build, Update)

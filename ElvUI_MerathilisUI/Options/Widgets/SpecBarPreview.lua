local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local max, min = math.max, math.min
local unpack = unpack
local CreateFrame = CreateFrame
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local C_SpecializationInfo = C_SpecializationInfo

-- The Specialization Bar with your specs and the border colors of the module
-- (active spec, loot spec, both). Used as `dialogControl` on a description
-- named "specBar". Display only, nothing is switched from here. With Mouseover
-- the bar fades in while the mouse is over the preview.

local HEIGHT = 80
local SPACING = 4
local MAX_SPECS = 4
local FADE_SPEED = 5

-- Same colors as Modules/Actionbars/SpecBar.lua
local COLOR_ACTIVE = { 0, 0.44, 0.87 }
local COLOR_LOOT = { 1, 0.44, 0.4 }
local COLOR_ACTIVE_LOOT = { 0.6, 0.44, 0.75 }

local function OnUpdate(frame, elapsed)
	local bar = frame.obj.bar
	local target = 1
	if E.db.mui.actionbars.specBar.mouseover then
		target = frame:IsMouseOver() and 1 or 0
	end

	local alpha = bar:GetAlpha()
	if alpha ~= target then
		local step = elapsed * FADE_SPEED
		alpha = target > alpha and min(target, alpha + step) or max(target, alpha - step)
		bar:SetAlpha(alpha)
	end
end

local function Build(widget)
	widget.frame.obj = widget

	local bar = CreateFrame("Frame", nil, widget.frame, "BackdropTemplate")
	bar:CreateBackdrop("Transparent")
	bar:SetPoint("CENTER")
	widget.bar = bar

	widget.buttons = {}
	for index = 1, MAX_SPECS do
		local button = CreateFrame("Frame", nil, bar)
		button:CreateBackdrop(nil, nil, true)
		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetInside()
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button:Hide()
		widget.buttons[index] = button
	end

	widget.frame:SetScript("OnUpdate", OnUpdate)
end

local function Update(widget)
	local db = E.db.mui.actionbars.specBar
	local getInfo = C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
	local numSpecs = getInfo and min(GetNumSpecializations() or 0, MAX_SPECS) or 0
	local currentSpec = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization()
	local lootID = GetLootSpecialization and GetLootSpecialization() or 0
	local size = db.size

	for index, button in ipairs(widget.buttons) do
		local shown = index <= numSpecs
		button:SetShown(shown)
		if shown then
			local specID, _, _, icon = getInfo(index)
			button.icon:SetTexture(icon)
			button:SetSize(size, size)
			button:ClearAllPoints()
			if index == 1 then
				button:SetPoint("LEFT", widget.bar, "LEFT", SPACING, 0)
			else
				button:SetPoint("LEFT", widget.buttons[index - 1], "RIGHT", SPACING, 0)
			end

			-- "Current Specialization" as loot spec follows the active spec
			local isActive = currentSpec == index
			local isLootSpec = lootID == specID or (lootID == 0 and isActive)
			local color = isActive and isLootSpec and COLOR_ACTIVE_LOOT
				or isActive and COLOR_ACTIVE
				or isLootSpec and COLOR_LOOT
				or E.media.bordercolor
			button.backdrop:SetBackdropBorderColor(unpack(color, 1, 3))
		end
	end

	local count = max(numSpecs, 1)
	widget.bar:SetSize(SPACING * 2 + size * count + SPACING * (count - 1), SPACING * 2 + size)
	widget.bar:SetAlpha(db.mouseover and 0 or 1)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERSpecBarPreview", 1, HEIGHT, Build, Update)

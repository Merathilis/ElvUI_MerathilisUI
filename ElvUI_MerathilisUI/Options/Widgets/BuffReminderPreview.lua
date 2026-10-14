local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local floor, max, min = math.floor, math.max, math.min
local CreateFrame = CreateFrame
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture

-- The row of the Buff Reminder test mode: raid buffs and consumables with
-- labels, bag counts and the pulsing glow. Used as `dialogControl` on a
-- description named "buffReminder". The entries and the glow come from the
-- module, sizes follow its LayoutIcons; a row wider than the options is scaled
-- down.

local ICON_SIZE = 36
local PADDING = 10
local MIN_HEIGHT = 60
local FALLBACK_ICON = 134400

local function GetBuffReminder()
	return MER:GetModule("MER_BuffReminder")
end

local function CreateIcon(parent, entry)
	local button = CreateFrame("Frame", nil, parent)

	local icon = button:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	local texture = entry.spellID and C_Spell_GetSpellTexture(entry.spellID)
		or entry.itemID and C_Item_GetItemIconByID(entry.itemID)
	icon:SetTexture(texture or FALLBACK_ICON)
	icon:SetDesaturated(entry.desaturated or false)
	MER:GetModule("MER_Skins"):CreateBG(icon)

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:FontTemplate()
	button.text:SetPoint("TOP", button, "BOTTOM", 0, -2)
	button.text:SetText(entry.label or "")

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:FontTemplate(nil, 10, "OUTLINE")
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	button.bagCount = entry.bagCount

	return button
end

local function Build(widget)
	widget.holder = CreateFrame("Frame", nil, widget.frame)
	widget.holder:SetPoint("CENTER")

	widget.icons = {}
	for index, entry in ipairs(GetBuffReminder().TestPreview or {}) do
		widget.icons[index] = CreateIcon(widget.holder, entry)
	end
end

-- Glow like ApplyGlow, without the module's settings lookup
local function ApplyGlow(button, db)
	if not db.glowEnable then
		if button.glow then
			button.glow.anim:Stop()
			button.glow:Hide()
		end
		return
	end

	local glow = button.glow or GetBuffReminder().CreateIconGlow(button)
	local color = db.glowColor
	for _, texture in ipairs(glow.textures) do
		texture:SetVertexColor(color.r, color.g, color.b, 1)
	end
	glow:Show()
	if not glow.anim:IsPlaying() then
		glow.anim:Play()
	end
end

local function Update(widget)
	local db = E.db.mui.buffReminder
	local icons = widget.icons
	local count = #icons
	if count == 0 then
		return
	end

	-- Same math as LayoutIcons
	local spacing = db.iconSpacing or 6
	local size = floor(ICON_SIZE * (db.scale or 1) + 0.5)
	local totalWidth = count * size + (count - 1) * spacing
	local textHeight = db.showText and (db.textSize + 4) or 0

	local holder = widget.holder
	holder:SetSize(totalWidth, size + textHeight)
	local available = widget.frame:GetWidth() - PADDING * 2
	local scale = available > 0 and min(1, available / totalWidth) or 1
	holder:SetScale(scale)
	widget.frame:SetHeight(max(MIN_HEIGHT, (size + textHeight) * scale + PADDING * 2))

	for index, button in ipairs(icons) do
		button:SetSize(size, size)
		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", holder, "TOPLEFT", (index - 1) * (size + spacing), 0)

		button.text:FontTemplate(nil, db.textSize, db.textOutline)
		button.text:SetShown(db.showText)

		local bagCount = button.bagCount
		if db.showBagCount and bagCount ~= nil then
			button.count:SetText(bagCount > 0 and bagCount or "|cffff3333" .. bagCount .. "|r")
		else
			button.count:SetText("")
		end

		ApplyGlow(button, db)
	end

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERBuffReminderPreview", 1, MIN_HEIGHT, Build, Update)

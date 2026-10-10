local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local LSM = E.LSM or E.Libs.LSM

local floor, max = math.floor, math.max
local format, gsub = format, gsub
local unpack = unpack
local CreateFrame = CreateFrame
local GetTime = GetTime
local C_Spell_GetSpellInfo = C_Spell and C_Spell.GetSpellInfo

-- Movement Alert with running sample countdowns. Used as `dialogControl` on a
-- description whose name is the part to show: "general" (the cooldown slots in
-- the chosen display mode, stacked in the grow direction), "timeSpiral" (the
-- free movement banner) or "gateway" (the Gateway Control Shard reminder).
-- Fonts, colors, sizes and the text layout follow Modules/MovementAlert/Core.lua.

local PADDING = 10
local MIN_HEIGHT = 50
local COUNTDOWN_LENGTH = 8

-- Two sample spells with different cooldowns left
local SAMPLE_SPELLS = {
	{ spellID = 1953, offset = 0 }, -- Blink
	{ spellID = 2983, offset = 3 }, -- Sprint
}

local function GetColor(db)
	if db.useClassColor then
		local color = E:ClassColor(E.myclass, true)
		return color.r, color.g, color.b
	end

	return db.color.r, db.color.g, db.color.b
end

-- Same handling of the SHADOW styles as the module's SetFont
local function SetFont(object, db)
	local style = db.style or "OUTLINE"
	local shadow = style:find("SHADOW") ~= nil
	style = gsub(style, "SHADOW", "")
	if style == "NONE" then
		style = ""
	end

	object:SetFont(F.GetFontPath(db.name), db.size or 20, style)
	if shadow then
		object:SetShadowColor(0, 0, 0, 1)
		object:SetShadowOffset(1, -1)
	else
		object:SetShadowOffset(0, 0)
	end
end

local function FormatTime(remaining, decimals)
	if decimals then
		return format("%.1f", remaining)
	end
	return tostring(floor(remaining + 0.99))
end

local function CreateSlot(parent, sample)
	local info = C_Spell_GetSpellInfo and C_Spell_GetSpellInfo(sample.spellID)

	local slot = CreateFrame("Frame", nil, parent)
	slot.name = info and info.name or ""
	slot.offset = sample.offset

	slot.text = slot:CreateFontString(nil, "OVERLAY")
	slot.text:FontTemplate()
	slot.time = slot:CreateFontString(nil, "OVERLAY")
	slot.time:FontTemplate()

	slot.iconFrame = CreateFrame("Frame", nil, slot, "BackdropTemplate")
	slot.iconFrame:SetTemplate()
	slot.icon = slot.iconFrame:CreateTexture(nil, "ARTWORK")
	slot.icon:SetInside()
	slot.icon:SetTexCoord(unpack(E.TexCoords))
	slot.icon:SetTexture(info and info.iconID)
	slot.swipe = CreateFrame("Cooldown", nil, slot.iconFrame, "CooldownFrameTemplate")
	slot.swipe:SetInside()
	slot.swipe:SetDrawEdge(false)
	slot.swipe:SetHideCountdownNumbers(true)
	slot.swipe.noCooldownCount = true
	slot.swipe.noOCC = true

	slot.bar = CreateFrame("StatusBar", nil, slot)
	slot.bar:CreateBackdrop("Transparent")
	slot.bar:SetMinMaxValues(0, COUNTDOWN_LENGTH)
	slot.barIconFrame = CreateFrame("Frame", nil, slot.bar, "BackdropTemplate")
	slot.barIconFrame:SetTemplate()
	slot.barIcon = slot.barIconFrame:CreateTexture(nil, "ARTWORK")
	slot.barIcon:SetInside()
	slot.barIcon:SetTexCoord(unpack(E.TexCoords))
	slot.barIcon:SetTexture(info and info.iconID)

	-- The countdown number sits above the icon and the bar
	slot.timeLayer = CreateFrame("Frame", nil, slot)
	slot.timeLayer:SetAllPoints()
	slot.timeLayer:SetFrameLevel(slot:GetFrameLevel() + 10)
	slot.time:SetParent(slot.timeLayer)

	return slot
end

local function GetSlotSize(db)
	if db.displayMode == "ICON" then
		return db.iconSize, db.iconSize
	elseif db.displayMode == "BAR" then
		return db.bar.width, db.bar.height
	end

	return db.textWidth, db.font.size + 8
end

-- Label and number centered as one unit, like the module's LayoutText
local function LayoutText(slot, db)
	local textFormat = db.textFormat
	local size = db.font.size
	local gap = max(2, floor(size * 0.25))
	local reserved = size * (db.decimals and 2.4 or 1.6)
	local labelWidth = slot.text:IsShown() and slot.text:GetStringWidth() or 0
	local total = labelWidth + (labelWidth > 0 and (gap + reserved) or reserved)

	slot.text:ClearAllPoints()
	slot.time:ClearAllPoints()

	if textFormat == "TIME" or labelWidth == 0 then
		slot.time:SetJustifyH("CENTER")
		slot.time:SetPoint("CENTER", slot, "CENTER")
	elseif textFormat == "NAME_TIME" then
		slot.text:SetPoint("LEFT", slot, "CENTER", -total / 2, 0)
		slot.time:SetJustifyH("LEFT")
		slot.time:SetPoint("LEFT", slot.text, "RIGHT", gap, 0)
	else
		slot.text:SetPoint("RIGHT", slot, "CENTER", total / 2, 0)
		slot.time:SetJustifyH("RIGHT")
		slot.time:SetPoint("RIGHT", slot.text, "LEFT", -gap, 0)
	end
end

local function StyleSlot(slot, db)
	local mode = db.displayMode
	local r, g, b = GetColor(db)

	slot:SetSize(GetSlotSize(db))
	SetFont(slot.text, db.font)
	slot.text:SetTextColor(r, g, b)
	SetFont(slot.time, db.font)
	slot.time:SetTextColor(r, g, b)

	slot.text:Hide()
	slot.iconFrame:SetShown(mode == "ICON")
	slot.bar:SetShown(mode == "BAR")
	slot.time:Show()

	if mode == "ICON" then
		slot.iconFrame:SetSize(db.iconSize, db.iconSize)
		slot.iconFrame:ClearAllPoints()
		slot.iconFrame:SetPoint("CENTER")
		slot.time:ClearAllPoints()
		slot.time:SetJustifyH("CENTER")
		slot.time:SetPoint("CENTER", slot, "CENTER")
	elseif mode == "BAR" then
		local barDB = db.bar
		local iconWidth = barDB.showIcon and (barDB.height + 4) or 0
		slot.bar:SetStatusBarTexture(LSM:Fetch("statusbar", barDB.texture))
		slot.bar:SetStatusBarColor(r, g, b)
		slot.bar:SetSize(max(barDB.width - iconWidth, 1), barDB.height)
		slot.bar:ClearAllPoints()
		slot.bar:SetPoint("RIGHT", slot, "RIGHT")
		slot.barIconFrame:SetSize(barDB.height, barDB.height)
		slot.barIconFrame:ClearAllPoints()
		slot.barIconFrame:SetPoint("RIGHT", slot.bar, "LEFT", -4, 0)
		slot.barIconFrame:SetShown(barDB.showIcon)
		slot.time:ClearAllPoints()
		slot.time:SetJustifyH("CENTER")
		slot.time:SetPoint("CENTER", slot.bar, "CENTER")
		slot.time:SetShown(barDB.showTime)
	else
		if db.textFormat ~= "TIME" then
			slot.text:SetText(format(L["No %s"], slot.name))
			slot.text:Show()
		end
		LayoutText(slot, db)
	end
end

local function GetRemaining(widget, offset)
	return COUNTDOWN_LENGTH - (widget.time + offset) % COUNTDOWN_LENGTH
end

local function OnUpdate(frame, elapsed)
	local widget = frame.obj
	widget.time = widget.time + elapsed

	local db = E.db.mui.movementAlert
	local key = widget._key
	if key == "timeSpiral" then
		local tsDB = db.timeSpiral
		local remaining = GetRemaining(widget, 0)
		local text = tsDB.showTimer and (tsDB.text .. "\n" .. format("%.1f", remaining)) or tsDB.text
		widget.banner:SetText(text)
		return
	elseif key ~= "general" then
		return
	end

	for _, slot in ipairs(widget.slots) do
		local remaining = GetRemaining(widget, slot.offset)
		slot.time:SetText(FormatTime(remaining, db.decimals))
		slot.bar:SetValue(remaining)

		-- The icon swipe runs on its own, it starts over with the countdown
		if not slot.lastRemaining or remaining > slot.lastRemaining then
			slot.swipe:SetCooldown(GetTime() - (COUNTDOWN_LENGTH - remaining), COUNTDOWN_LENGTH)
		end
		slot.lastRemaining = remaining
	end
end

local function UpdateGeneral(widget, db)
	local _, height = GetSlotSize(db)
	local count = #widget.slots
	local total = count * height + (count - 1) * db.spacing
	widget.frame:SetHeight(max(MIN_HEIGHT, total + PADDING * 2))

	local up = db.growDirection == "UP"
	local last
	for _, slot in ipairs(widget.slots) do
		slot:Show()
		StyleSlot(slot, db)
		slot:ClearAllPoints()
		if not last then
			slot:SetPoint(
				up and "BOTTOM" or "TOP",
				widget.frame,
				up and "BOTTOM" or "TOP",
				0,
				up and PADDING or -PADDING
			)
		elseif up then
			slot:SetPoint("BOTTOM", last, "TOP", 0, db.spacing)
		else
			slot:SetPoint("TOP", last, "BOTTOM", 0, -db.spacing)
		end
		last = slot
		slot.lastRemaining = nil
	end

	widget.banner:Hide()
end

local function UpdateBanner(widget, sectionDB)
	for _, slot in ipairs(widget.slots) do
		slot:Hide()
	end

	local banner = widget.banner
	SetFont(banner, sectionDB.font)
	banner:SetTextColor(GetColor(sectionDB))
	banner:SetText(sectionDB.text)
	banner:Show()

	widget.frame:SetHeight(max(MIN_HEIGHT, sectionDB.font.size * 2 + 8 + PADDING * 2))
end

local function Build(widget)
	local frame = widget.frame
	frame.obj = widget
	frame:SetClipsChildren(true)

	widget.slots = {}
	for index, sample in ipairs(SAMPLE_SPELLS) do
		widget.slots[index] = CreateSlot(frame, sample)
	end

	widget.banner = frame:CreateFontString(nil, "OVERLAY")
	widget.banner:FontTemplate()
	widget.banner:SetPoint("CENTER")
	widget.banner:SetJustifyH("CENTER")

	widget.time = 0
	frame:SetScript("OnUpdate", OnUpdate)
end

local function Update(widget, key)
	local db = E.db.mui.movementAlert

	if key == "timeSpiral" then
		UpdateBanner(widget, db.timeSpiral)
		Preview.SetEnabled(widget, db.enable and db.timeSpiral.enable)
	elseif key == "gateway" then
		UpdateBanner(widget, db.gateway)
		Preview.SetEnabled(widget, db.enable and db.gateway.enable)
	else
		UpdateGeneral(widget, db)
		Preview.SetEnabled(widget, db.enable)
	end

	OnUpdate(widget.frame, 0)
end

Preview.Register("MERMovementAlertPreview", 1, MIN_HEIGHT, Build, Update)

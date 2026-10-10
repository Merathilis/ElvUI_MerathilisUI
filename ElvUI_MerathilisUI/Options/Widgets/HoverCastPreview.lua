local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local _G = _G
local ipairs, unpack = ipairs, unpack
local max, min = math.max, math.min
local CreateFrame = CreateFrame

-- Animated HoverCast scene, used as `dialogControl` on a description named
-- "hovercast" above the editor. A cursor moves over a few group frames and
-- clicks; the card next to them names the key and what it casts. The steps are
-- your own bindings (HC:GetSpecBindings, HC:GetGlobalBindings), read again on
-- every step, so changes in the editor show up without a rebuild. Harmful
-- bindings go to the enemy frame.

-- HoverCastPage.lua keeps this much room free above the editor
local HEIGHT = 130
local CURSOR_TEX = [[Interface\CURSOR\Point]]
local CURSOR_SIZE = 24

local FRAME_WIDTH, FRAME_HEIGHT, FRAME_GAP = 150, 22, 6
local FRAME_LEFT, FRAME_TOP = 16, 10
local CARD_GAP = 40
local ICON_SIZE = 30
local MAX_STEPS = 8

-- Step timeline in seconds: move, click, cast icon, next step
local MOVE_TIME = 0.6
local CLICK_TIME = 0.75
local FLASH_TIME = 0.3
local CAST_START, CAST_TIME = 0.8, 1
local STEP_TIME = 2.4

local SAMPLE_PARTY = { "PRIEST", "WARRIOR" }

-- Without own key bindings, the two defaults of a fresh setup
local DEFAULT_BINDINGS = {
	{ key = "BUTTON1", type = "target" },
	{ key = "BUTTON2", type = "menu" },
}

local function GetHoverCast()
	return MER:GetModule("MER_HoverCast")
end

local function OutCubic(p)
	p = p - 1
	return p * p * p + 1
end

-- Bindings that react to a key, spec bindings first like the editor lists them
local function GetSteps(HC)
	local steps = {}
	local function Add(list)
		for _, binding in ipairs(list) do
			if #steps < MAX_STEPS and binding.key and binding.key ~= "" and HC:IsBindingActive(binding) then
				steps[#steps + 1] = binding
			end
		end
	end

	Add(HC:GetSpecBindings())
	Add(HC:GetGlobalBindings())

	return #steps > 0 and steps or DEFAULT_BINDINGS
end

local function CreateUnitFrame(parent, index)
	local bar = Preview.CreateBar(parent)
	bar:SetPoint("TOPLEFT", parent, "TOPLEFT", FRAME_LEFT, -FRAME_TOP - (index - 1) * (FRAME_HEIGHT + FRAME_GAP))

	bar.name = bar:CreateFontString(nil, "OVERLAY")
	bar.name:FontTemplate(nil, 11)
	bar.name:SetPoint("LEFT", bar, "LEFT", 6, 0)

	bar.flash = bar:CreateTexture(nil, "OVERLAY")
	bar.flash:SetAllPoints()
	bar.flash:SetColorTexture(1, 1, 1)
	bar.flash:SetAlpha(0)

	return bar
end

-- Where the cursor tip rests on a frame, from the top left of the preview
local function FramePoint(index)
	return FRAME_LEFT + FRAME_WIDTH * 0.55, -FRAME_TOP - (index - 1) * (FRAME_HEIGHT + FRAME_GAP) - FRAME_HEIGHT * 0.5
end

local function PickFrame(widget, HC, binding)
	local unitType = HC:IsReactionBinding(binding) and HC:GetBindingUnitType(binding) or "friendly"
	local enemy = #widget.frames

	if unitType == "harmful" or (unitType == "both" and widget.step % 2 == 0) then
		return enemy
	end

	return (widget.step - 1) % (enemy - 1) + 1
end

local function ShowStep(widget)
	local HC = GetHoverCast()
	local steps = GetSteps(HC)

	widget.step = widget.step % #steps + 1
	local binding = steps[widget.step]

	widget.fromX, widget.fromY = widget.cursorX, widget.cursorY
	widget.target = PickFrame(widget, HC, binding)
	widget.toX, widget.toY = FramePoint(widget.target)

	local card = widget.card
	card.key:SetText(HC:FormatKey(binding.key))
	card.icon:SetTexture(HC:GetBindingIcon(binding))
	card.name:SetText(HC:GetBindingName(binding))
	card.counter:SetText(widget.step .. " / " .. #steps)
	widget.cast:SetTexture(HC:GetBindingIcon(binding))
end

local function SetCursor(widget, x, y, scale)
	widget.cursorX, widget.cursorY = x, y
	widget.cursor:SetSize(CURSOR_SIZE * scale, CURSOR_SIZE * scale)
	widget.cursor:SetPoint("TOPLEFT", widget.frame, "TOPLEFT", x, y)
end

local function Frame_OnUpdate(frame, elapsed)
	local widget = frame.widget
	widget.time = widget.time + elapsed
	if widget.time >= STEP_TIME then
		widget.time = 0
		ShowStep(widget)
	end

	local t = widget.time

	local move = OutCubic(min(t / MOVE_TIME, 1))
	local x = widget.fromX + (widget.toX - widget.fromX) * move
	local y = widget.fromY + (widget.toY - widget.fromY) * move
	-- A short press on the click
	local pressed = t >= CLICK_TIME and t < CLICK_TIME + 0.1
	SetCursor(widget, x, y, pressed and 0.85 or 1)

	for index, unitFrame in ipairs(widget.frames) do
		local alpha = 0
		if index == widget.target and t >= CLICK_TIME then
			alpha = 0.35 * max(1 - (t - CLICK_TIME) / FLASH_TIME, 0)
		end
		unitFrame.flash:SetAlpha(alpha)
	end

	-- The cast rises from the frame and fades out
	local cast = (t - CAST_START) / CAST_TIME
	if cast >= 0 and cast <= 1 then
		local _, targetY = FramePoint(widget.target)
		widget.cast:ClearAllPoints()
		widget.cast:SetPoint("CENTER", widget.frame, "TOPLEFT", FRAME_LEFT + FRAME_WIDTH + 14, targetY + cast * 14)
		widget.cast:SetAlpha(min(cast * 5, 1) * min((1 - cast) * 3, 1))
		widget.cast:Show()
	else
		widget.cast:Hide()
	end

	widget.card:SetAlpha(min(t / 0.25, 1))
end

local function Build(widget)
	local frame = widget.frame
	frame:SetClipsChildren(true)
	frame.widget = widget

	widget.frames = {}
	for index = 1, #SAMPLE_PARTY + 2 do
		widget.frames[index] = CreateUnitFrame(frame, index)
	end

	widget.cast = frame:CreateTexture(nil, "OVERLAY")
	widget.cast:SetSize(18, 18)
	widget.cast:SetTexCoord(unpack(E.TexCoords))

	local card = CreateFrame("Frame", nil, frame)
	card:SetPoint("TOPLEFT", frame, "TOPLEFT", FRAME_LEFT + FRAME_WIDTH + CARD_GAP, -FRAME_TOP - 8)
	card:SetPoint("RIGHT", frame, "RIGHT", -8, 0)
	card:SetHeight(HEIGHT - FRAME_TOP * 2 - 16)

	card.key = card:CreateFontString(nil, "OVERLAY")
	card.key:FontTemplate(nil, 16)
	card.key:SetPoint("TOPLEFT")
	card.key:SetPoint("RIGHT")
	card.key:SetJustifyH("LEFT")

	card.iconFrame = CreateFrame("Frame", nil, card, "BackdropTemplate")
	card.iconFrame:SetTemplate()
	card.iconFrame:SetSize(ICON_SIZE, ICON_SIZE)
	card.iconFrame:SetPoint("TOPLEFT", card.key, "BOTTOMLEFT", 0, -10)
	card.icon = card.iconFrame:CreateTexture(nil, "ARTWORK")
	card.icon:SetInside()
	card.icon:SetTexCoord(unpack(E.TexCoords))

	card.name = card:CreateFontString(nil, "OVERLAY")
	card.name:FontTemplate(nil, 13)
	card.name:SetPoint("LEFT", card.iconFrame, "RIGHT", 8, 0)
	card.name:SetPoint("RIGHT")
	card.name:SetJustifyH("LEFT")
	card.name:SetWordWrap(false)

	card.counter = card:CreateFontString(nil, "OVERLAY")
	card.counter:FontTemplate(nil, 10)
	card.counter:SetPoint("TOPLEFT", card.iconFrame, "BOTTOMLEFT", 0, -10)
	card.counter:SetTextColor(0.6, 0.6, 0.6)
	widget.card = card

	-- Above the frames and the card
	local cursorFrame = CreateFrame("Frame", nil, frame)
	cursorFrame:SetAllPoints()
	cursorFrame:SetFrameLevel(frame:GetFrameLevel() + 20)
	widget.cursor = cursorFrame:CreateTexture(nil, "OVERLAY")
	widget.cursor:SetTexture(CURSOR_TEX)

	widget.step = 0
	widget.time = 0
	widget.cursorX, widget.cursorY = FRAME_LEFT + FRAME_WIDTH + 10, -HEIGHT * 0.5
	ShowStep(widget)
	frame:SetScript("OnUpdate", Frame_OnUpdate)
end

local function Update(widget)
	local HC = GetHoverCast()
	local texture = E.db.unitframe.statusbar

	local values = { 0.85, 0.55, 0.3, 0.7 }
	for index, unitFrame in ipairs(widget.frames) do
		local r, g, b, name
		if index == 1 then
			local color = E:ClassColor(E.myclass)
			r, g, b, name = color.r, color.g, color.b, E.myname
		elseif index <= #SAMPLE_PARTY + 1 then
			local class = SAMPLE_PARTY[index - 1]
			local color = E:ClassColor(class)
			r, g, b, name = color.r, color.g, color.b, _G.LOCALIZED_CLASS_NAMES_MALE[class]
		else
			r, g, b = Preview.HostileColor()
			name = _G.ENEMY
		end

		Preview.UpdateBar(unitFrame, FRAME_WIDTH, FRAME_HEIGHT, values[index], texture, r, g, b)
		unitFrame.name:SetText(name)
	end

	widget.card.key:SetTextColor(F.r, F.g, F.b)

	local db = HC:GetDB()
	Preview.SetEnabled(widget, db and db.enabled)
end

Preview.Register("MERHoverCastPreview", 1, HEIGHT, Build, Update)

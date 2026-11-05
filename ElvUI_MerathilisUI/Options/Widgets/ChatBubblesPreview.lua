local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, max, min, unpack = ipairs, math.max, math.min, unpack
local CreateFrame = CreateFrame
local UnitName = UnitName

-- Three sample chat bubbles: a say line of the player, a party line and an NPC
-- yell. Used as `dialogControl` on a description named "bubbles". Backdrop,
-- style, shadow and the speaker name follow Modules/Chat/Bubbles.lua on top of
-- ElvUI's bubble style; switched off they show ElvUI's own look.

local HEIGHT = 130
-- Blizzard's bubble keeps this much room around the text, ElvUI's borderless
-- style draws its backdrop this far inside of it.
local BUBBLE_INSET = 16
local NOBORDER_INSET = 4
local TEXT_MAX_WIDTH = 140
local MIN_FONT_SIZE = 11

local SAMPLES = {
	{ text = "Anyone up for a key?", chatType = "SAY", x = -1, y = -6 },
	{ text = "On my way!", chatType = "PARTY", class = "PALADIN", group = true, x = 0, y = 10 },
	{ text = "Intruders! Seize them!", chatType = "MONSTER_YELL", npc = true, x = 1, y = -10 },
}

local function GetSpeaker(sample)
	if sample.npc then
		return L["Guard"], nil
	elseif sample.class then
		return _G.LOCALIZED_CLASS_NAMES_MALE[sample.class], sample.class
	end
	return UnitName("player"), E.myclass
end

local function Build(widget)
	widget.bubbles = {}
	for index in ipairs(SAMPLES) do
		local bubble = CreateFrame("Frame", nil, widget.frame)

		local backdrop = CreateFrame("Frame", nil, bubble)
		backdrop:SetTemplate("Transparent", nil, true)
		F.CreateStyle(backdrop)
		WS:CreateShadow(backdrop, nil, nil, nil, nil, true)
		bubble.backdrop = backdrop

		-- Text and name above the backdrop, like on the bubble's holder
		local top = CreateFrame("Frame", nil, bubble)
		top:SetAllPoints()
		top:SetFrameLevel(backdrop:GetFrameLevel() + 5)

		bubble.text = top:CreateFontString(nil, "OVERLAY")
		bubble.text:FontTemplate()
		bubble.text:SetJustifyH("CENTER")
		bubble.text:SetWordWrap(true)

		bubble.name = top:CreateFontString(nil, "OVERLAY")
		bubble.name:FontTemplate()
		bubble.name:SetWordWrap(false)

		widget.bubbles[index] = bubble
	end
end

local function UpdateName(bubble, sample, db, styleShown, fontSize)
	local label = bubble.name
	local elvOption = E.private.general.chatBubbles
	local showName = E.private.general.chatBubbleName and (not sample.group or db.enable and db.groupNames)
	label:SetShown(showName)
	if not showName then
		return
	end

	local name, classFile = GetSpeaker(sample)
	local chat = MER:GetModule("MER_Chat")
	label:ClearAllPoints()

	if db.enable then
		label:SetText(chat:ColorBubbleName(name, classFile, sample.npc, db.nameGradient))
		chat:SetBubbleNameFont(label, db.nameFontSize)
		label:SetJustifyH(db.nameJustify)
		local anchor = styleShown and bubble.backdrop or bubble
		local side = db.nameJustify == "CENTER" and "" or db.nameJustify
		label:SetPoint("BOTTOM" .. side, anchor, "TOP" .. side, db.nameXOffset, db.nameYOffset)
	else
		-- ElvUI's own name: flat class color, left above the bubble
		label:SetText(chat:ColorBubbleName(name, classFile, sample.npc, false))
		chat:SetBubbleNameFont(label, fontSize * 0.85)
		label:SetJustifyH("LEFT")
		local yOffset = (elvOption == "backdrop" and 2) or (elvOption == "backdrop_noborder" and -2) or 0
		label:SetPoint("BOTTOMLEFT", bubble, "TOPLEFT", 5, yOffset)
	end
end

local function Update(widget)
	local db = E.db.mui.chat.bubbles
	local elvOption = E.private.general.chatBubbles
	local hasBackdrop = elvOption == "backdrop" or elvOption == "backdrop_noborder"
	local inset = elvOption == "backdrop_noborder" and NOBORDER_INSET or 0

	widget.frame:SetHeight(HEIGHT)
	local width = widget.frame:GetWidth()

	local font, size, outline = _G.ChatBubbleFont:GetFont()
	local fontSize = max(size or MIN_FONT_SIZE, MIN_FONT_SIZE)

	for index, sample in ipairs(SAMPLES) do
		local bubble = widget.bubbles[index]
		local info = _G.ChatTypeInfo[sample.chatType]
		local r, g, b = 1, 1, 1
		if info then
			r, g, b = info.r, info.g, info.b
		end

		local text = bubble.text
		text:FontTemplate(font, fontSize, outline)
		text:SetTextColor(r, g, b)
		text:SetText(sample.text)
		text:SetWidth(min(text:GetUnboundedStringWidth() + 1, TEXT_MAX_WIDTH))

		bubble:SetShown(elvOption ~= "disabled")
		bubble:SetSize(text:GetWidth() + BUBBLE_INSET * 2, text:GetStringHeight() + BUBBLE_INSET * 2)
		bubble:ClearAllPoints()
		bubble:SetPoint("CENTER", widget.frame, "CENTER", sample.x * width / 3, sample.y)
		text:ClearAllPoints()
		text:SetPoint("CENTER", bubble, "CENTER")

		local backdrop = bubble.backdrop
		backdrop:ClearAllPoints()
		backdrop:SetPoint("TOPLEFT", bubble, "TOPLEFT", inset, -inset)
		backdrop:SetPoint("BOTTOMRIGHT", bubble, "BOTTOMRIGHT", -inset, inset)
		backdrop:SetShown(hasBackdrop)

		if elvOption == "backdrop" then
			backdrop:SetBackdropBorderColor(r, g, b)
		elseif elvOption == "backdrop_noborder" then
			backdrop:SetBackdropBorderColor(0, 0, 0, 0)
		else
			backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		if backdrop.MERStyle then
			backdrop.MERStyle:SetShown(db.enable and db.style)
		end
		if backdrop.shadow then
			backdrop.shadow:SetShown(db.enable and db.shadow)
		end

		UpdateName(bubble, sample, db, hasBackdrop, fontSize)
	end

	Preview.SetEnabled(widget, db.enable and elvOption ~= "disabled")
end

Preview.Register("MERChatBubblesPreview", 1, HEIGHT, Build, Update)

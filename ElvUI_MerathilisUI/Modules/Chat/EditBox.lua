local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local WS = W:GetModule("Skins")
local CH = E:GetModule("Chat")

local _G = _G
local ipairs, pairs, setmetatable, tonumber, unpack = ipairs, pairs, setmetatable, tonumber, unpack

local CreateFrame = CreateFrame
local GetChannelName = GetChannelName

local ACCENT_WIDTH = 2
local BADGE_PADDING = 4
local BADGE_ALPHA = 0.9
local FADE_DURATION = 0.2
local COUNT_THROTTLE = 0.05
local COUNT_ALPHA = 0.6
-- Remaining characters (ElvUI counts down from 255) below which the counter
-- turns orange, then red.
local COUNT_WARNING = 50
local COUNT_CRITICAL = 20

-- Everything we draw lives on our own overlay frames, so nothing but the
-- backdrop, the insets and the header's alpha is ever written onto Blizzard's
-- edit box. The table is keyed by the edit box instead of storing a field on it.
local overlays = setmetatable({}, { __mode = "k" })

local function GetDB()
	return module.chatDB and module.chatDB.editBox
end

local function IsEnabled()
	local db = GetDB()
	return db and db.enable and E.private.chat.enable
end

-- Same color ElvUI picks for its border: the chat type, or the numbered
-- channel for custom channels.
local function GetChatTypeColor(editbox)
	local chatType = editbox:GetAttribute("chatType")
	local info = chatType and _G.ChatTypeInfo[chatType]
	if not info then
		return nil
	end

	if chatType == "CHANNEL" then
		local channelTarget = editbox:GetAttribute("channelTarget")
		local channelIndex = channelTarget and GetChannelName(channelTarget)
		if not channelIndex or channelIndex == 0 then
			return nil
		end
		info = _G.ChatTypeInfo[chatType .. channelIndex] or info
	end

	return info.r, info.g, info.b
end

-- Bright chat colors (Say is white) need dark text on the badge.
local function GetBadgeTextColor(r, g, b)
	local luminance = 0.299 * r + 0.587 * g + 0.114 * b
	if luminance > 0.6 then
		return 0.05, 0.05, 0.05
	end
	return 1, 1, 1
end

-- ElvUI's remaining-characters counter sits on the edit box itself, below
-- our layers, so the top layer shows a copy of it and warns near the limit.
-- ElvUI updates its counter from a script hook we can't follow, so the copy
-- is synced on a light tick that only runs while the box is open.
local function Top_OnUpdate(top, elapsed)
	top.elapsed = (top.elapsed or 0) + elapsed
	if top.elapsed < COUNT_THROTTLE then
		return
	end
	top.elapsed = 0

	local source = top.countSource
	local text = source and source:GetText()
	if text == top.lastCount then
		return
	end
	top.lastCount = text

	local count = top.count
	count:SetText(text or "")

	local remaining = tonumber(text)
	if remaining and remaining <= COUNT_CRITICAL then
		count:SetTextColor(1, 0.2, 0.2, 1)
	elseif remaining and remaining <= COUNT_WARNING then
		count:SetTextColor(1, 0.6, 0.1, 1)
	else
		count:SetTextColor(1, 1, 1, COUNT_ALPHA)
	end
end

-- WindTools' input method skin gives the box its own dark shadow; it would
-- sit right under our class colored glow, so only one of them is shown.
local function SetWindToolsShadowShown(editbox, shown)
	local shadow = editbox.shadow
	if shadow and shadow.__wind then
		shadow:SetShown(shown)
	end
end

local function CreateOverlay(editbox)
	-- Style layer: stripes, gradient and glow, drawn with the box itself.
	local overlay = CreateFrame("Frame", nil, editbox)
	overlay:SetAllPoints()
	overlay:SetFrameLevel(editbox:GetFrameLevel())

	F.CreateStyle(overlay)

	-- Top layer above the box's own text: the accent and the header badge. The
	-- badge would cover Blizzard's header, so it carries its own copy of it.
	local top = CreateFrame("Frame", nil, overlay)
	top:SetAllPoints()
	top:SetFrameLevel(editbox:GetFrameLevel() + 2)
	overlay.top = top

	local accent = top:CreateTexture(nil, "ARTWORK")
	accent:SetTexture(E.media.blankTex)
	accent:Point("TOPLEFT", top, "TOPLEFT", 1, -1)
	accent:Point("BOTTOMLEFT", top, "BOTTOMLEFT", 1, 1)
	accent:Width(ACCENT_WIDTH)
	overlay.accent = accent

	local badge = top:CreateTexture(nil, "BACKGROUND")
	badge:SetTexture(E.media.blankTex)
	overlay.badge = badge

	local label = top:CreateFontString(nil, "OVERLAY")
	label:SetWordWrap(false)
	overlay.label = label

	local suffixLabel = top:CreateFontString(nil, "OVERLAY")
	suffixLabel:SetWordWrap(false)
	overlay.suffixLabel = suffixLabel

	local source = editbox.characterCount
	if source then
		local count = top:CreateFontString(nil, "OVERLAY")
		count:SetAllPoints(source)
		count:SetJustifyH("CENTER")
		top.count = count
		top.countSource = source
		top:SetScript("OnUpdate", Top_OnUpdate)
	end

	-- Class colored glow, only there while the box is open anyway.
	local cc = E.myClassColor
	WS:CreateShadow(overlay, 4, cc.r, cc.g, cc.b, true)

	local fadeIn = overlay:CreateAnimationGroup()
	local alpha = fadeIn:CreateAnimation("Alpha")
	alpha:SetFromAlpha(0)
	alpha:SetToAlpha(1)
	alpha:SetDuration(FADE_DURATION)
	alpha:SetSmoothing("OUT")
	local grow = fadeIn:CreateAnimation("Scale")
	grow:SetTarget(accent)
	grow:SetOrigin("CENTER", 0, 0)
	grow:SetScaleFrom(1, 0.1)
	grow:SetScaleTo(1, 1)
	grow:SetDuration(FADE_DURATION)
	grow:SetSmoothing("OUT")
	overlay.fadeIn = fadeIn

	-- The overlay is a child of the edit box, so this fires every time the box
	-- opens without hooking any of Blizzard's edit box scripts.
	overlay:SetScript("OnShow", function(self)
		local db = GetDB()
		if db and db.animation and IsEnabled() then
			self.fadeIn:Stop()
			self.fadeIn:Play()
		end
	end)

	overlays[editbox] = overlay
	return overlay
end

local function CopyFontString(copy, source)
	local font, size, flags = source:GetFont()
	if font then
		copy:SetFont(font, size, flags)
	end
	copy:SetText(source:GetText())
end

-- fromHeader: only a fresh header update resets the text insets, so only then
-- is it safe to add the badge's room on top of them.
function module:StyleEditBox(editbox, fromHeader)
	local overlay = overlays[editbox]
	local header, suffix = editbox.header, editbox.headerSuffix

	if not IsEnabled() then
		if overlay then
			overlay:Hide()
			if editbox.characterCount then
				editbox.characterCount:SetAlpha(1)
			end
			SetWindToolsShadowShown(editbox, true)
			if header then
				header:SetAlpha(1)
			end
			if suffix then
				suffix:SetAlpha(1)
			end
			editbox:SetTemplate(nil, true)
			local r, g, b = GetChatTypeColor(editbox)
			if r then
				editbox:SetBackdropBorderColor(r, g, b)
			end
		end
		return
	end

	local db = GetDB()
	overlay = overlay or CreateOverlay(editbox)
	overlay:Show()

	local r, g, b = GetChatTypeColor(editbox)
	if not r then
		r, g, b = unpack(E.media.bordercolor)
	end

	if db.style then
		-- ignoreUpdates keeps ElvUI's media sweep from resetting our alpha.
		editbox:SetTemplate("Transparent", nil, true)
		local fade = E.media.backdropfadecolor
		editbox:SetBackdropColor(fade[1], fade[2], fade[3], db.backdropAlpha)
	end
	if overlay.MERStyle then
		overlay.MERStyle:SetShown(db.style)
	end

	-- The accent takes over from ElvUI's colored border.
	if db.accent then
		editbox:SetBackdropBorderColor(unpack(E.media.bordercolor))
		overlay.accent:SetVertexColor(r, g, b)
	end
	overlay.accent:SetShown(db.accent)

	if overlay.shadow then
		overlay.shadow:SetShown(db.glow)
	end
	SetWindToolsShadowShown(editbox, not db.glow)

	local top, source = overlay.top, editbox.characterCount
	if top.count then
		local font, size, flags = source:GetFont()
		if font then
			top.count:SetFont(font, size, flags)
		end
		top.lastCount = nil
		source:SetAlpha(0)
	end

	local showBadge = db.badge and header and true or false
	if showBadge then
		local suffixShown = suffix and suffix:IsShown()
		local last = suffixShown and suffix or header
		local badge, label, suffixLabel = overlay.badge, overlay.label, overlay.suffixLabel

		-- Anchored to Blizzard's header, never the other way around, so the
		-- copy follows its width and truncation without reading any geometry.
		badge:ClearAllPoints()
		badge:SetPoint("TOP", overlay.top, "TOP", 0, -3)
		badge:SetPoint("BOTTOM", overlay.top, "BOTTOM", 0, 3)
		badge:SetPoint("LEFT", header, "LEFT", -BADGE_PADDING, 0)
		badge:SetPoint("RIGHT", last, "RIGHT", BADGE_PADDING, 0)
		badge:SetVertexColor(r, g, b, BADGE_ALPHA)

		local tr, tg, tb = GetBadgeTextColor(r, g, b)

		CopyFontString(label, header)
		label:ClearAllPoints()
		label:SetPoint("LEFT", header, "LEFT")
		label:SetPoint("RIGHT", header, "RIGHT")
		label:SetTextColor(tr, tg, tb)
		header:SetAlpha(0)

		if suffixShown then
			CopyFontString(suffixLabel, suffix)
			suffixLabel:ClearAllPoints()
			suffixLabel:SetPoint("LEFT", suffix, "LEFT")
			suffixLabel:SetTextColor(tr, tg, tb)
			suffix:SetAlpha(0)
		end
		suffixLabel:SetShown(suffixShown)

		-- Room between the badge and the typed text.
		if fromHeader then
			local left, right, insetTop, insetBottom = editbox:GetTextInsets()
			if E:NotSecretValue(left) then
				editbox:SetTextInsets(left + BADGE_PADDING * 2, right, insetTop, insetBottom)
			end
		end
	else
		if header then
			header:SetAlpha(1)
		end
		if suffix then
			suffix:SetAlpha(1)
		end
	end

	overlay.badge:SetShown(showBadge)
	overlay.label:SetShown(showBadge)
	if not showBadge then
		overlay.suffixLabel:Hide()
	end
end

-- ElvUI's own header hook recolors and re-templates the box on every chat
-- type switch; this runs right behind it.
function module:PostEditBoxHeader(_, editbox)
	if editbox then
		self:StyleEditBox(editbox, true)
	end
end

function module:UpdateEditBoxes()
	if not self.editBoxInitialized then
		return
	end

	for editbox in pairs(overlays) do
		self:StyleEditBox(editbox)
	end

	-- Boxes that were never styled yet pick it up on their next header update.
	if IsEnabled() then
		for _, frameName in ipairs(_G.CHAT_FRAMES) do
			local chat = _G[frameName]
			local editbox = chat and chat.editBox
			if editbox and not overlays[editbox] and editbox:GetAttribute("chatType") then
				self:StyleEditBox(editbox)
			end
		end
	end
end

function module:InitializeEditBox()
	self:SecureHook(CH, "ChatEdit_UpdateHeader", "PostEditBoxHeader")
	self.editBoxInitialized = true
end

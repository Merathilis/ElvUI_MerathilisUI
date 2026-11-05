local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local WS = W:GetModule("Skins")
local M = E:GetModule("Misc")

local _G = _G
local ipairs, max, pairs, setmetatable, unpack, wipe = ipairs, max, pairs, setmetatable, unpack, wipe
local gsub, strfind = gsub, strfind

local Ambiguate = Ambiguate
local CreateFrame = CreateFrame
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_SetCVar = C_CVar.SetCVar

-- ElvUI's own inset for the borderless style, in the bubble's space.
local NOBORDER_INSET = 4
-- Gradient for NPC speakers, close to Blizzard's NPC speech color.
local NPC_GRADIENT = "NPCNEUTRAL"
-- The sender cache is wiped once it holds this many lines, and on every loading screen.
local CACHE_MAX = 50

-- Chat event -> what kind of speaker it is. ElvUI only remembers the sender for say,
-- yell and NPC lines, so group chat bubbles stay without a name there.
local SENDER_EVENTS = {
	CHAT_MSG_SAY = "player",
	CHAT_MSG_YELL = "player",
	CHAT_MSG_MONSTER_SAY = "npc",
	CHAT_MSG_MONSTER_YELL = "npc",
	CHAT_MSG_MONSTER_PARTY = "npc",
	CHAT_MSG_PARTY = "group",
	CHAT_MSG_PARTY_LEADER = "group",
	CHAT_MSG_RAID = "group",
	CHAT_MSG_RAID_LEADER = "group",
	CHAT_MSG_INSTANCE_CHAT = "group",
	CHAT_MSG_INSTANCE_CHAT_LEADER = "group",
	CHAT_MSG_EMOTE = "player",
	CHAT_MSG_MONSTER_EMOTE = "npc",
	CHAT_MSG_MONSTER_WHISPER = "npc",
}

-- The client fills emote bubbles in itself, so their text only has to contain the
-- chat line instead of matching it.
local LOOSE_EVENTS = {
	CHAT_MSG_EMOTE = true,
	CHAT_MSG_MONSTER_EMOTE = true,
}

-- Blizzard's bubble switches, held at 0 inside instances when asked to.
local BUBBLE_CVARS = { "chatBubbles", "chatBubblesParty", "chatBubblesRaid" }

-- Everything is kept in side tables keyed by Blizzard's bubble frame, never as fields
-- on it: a bubble can turn forbidden on a zone change, and writing to one raises.
local WEAK_KEYS = { __mode = "k" }
local tracked = setmetatable({}, WEAK_KEYS) -- bubble -> true, once ElvUI skinned it
local overlays = setmetatable({}, WEAK_KEYS) -- bubble -> our backdrop frame
local styledNames = setmetatable({}, WEAK_KEYS) -- bubble -> true while we moved its name
local shownText = setmetatable({}, WEAK_KEYS) -- bubble -> its text before ElvUI recolors class names

local senders = {} -- message text -> { name, guid, kind }
local senderCount = 0
local savedCVars -- the player's values while we hold the switches at 0
local eventFrame

local function GetDB()
	return module.chatDB and module.chatDB.bubbles
end

local function IsEnabled()
	local db = GetDB()
	return db and db.enable and E.private.general.chatBubbles ~= "disabled"
end

-- Our backdrop replaces ElvUI's, so it only exists for ElvUI's two backdrop styles.
local function IsStyleActive()
	local option = E.private.general.chatBubbles
	return IsEnabled() and (option == "backdrop" or option == "backdrop_noborder")
end

local function AreNamesActive()
	return IsEnabled() and E.private.general.chatBubbleName
end

local function WindToolsTogglesBubbles()
	local wt = E.private.WT
	return wt and wt.misc and wt.misc.autoToggleChatBubble
end

-------------------------------------------------------------------------------
--  Backdrop
-------------------------------------------------------------------------------

-- Bubbles live in the WorldFrame, which does not follow the UI scale, so a border
-- drawn on the bubble itself comes out thicker or blurrier than the rest of the UI.
-- Our backdrop is its own frame scaled back to UIParent's effective scale, where
-- ElvUI's pixel units are exact. Scaling the bubble would take its text along.
local function CreateOverlay(bubble, holder)
	local overlay = CreateFrame("Frame", nil, holder)
	-- Below the bubble's own text and name, which are regions of the holder.
	overlay:SetFrameLevel(max(holder:GetFrameLevel() - 1, 0))
	overlay:SetTemplate("Transparent", nil, true)
	F.CreateStyle(overlay)
	WS:CreateShadow(overlay, nil, nil, nil, nil, true)

	overlays[bubble] = overlay
	return overlay
end

local function LayoutOverlay(overlay, holder)
	local holderScale = holder:GetEffectiveScale()
	local ratio = holderScale > 0 and _G.UIParent:GetEffectiveScale() / holderScale or 1
	overlay:SetScale(ratio)

	-- Offsets are in the overlay's own, rescaled space.
	local inset = (E.private.general.chatBubbles == "backdrop_noborder" and NOBORDER_INSET or 0) / ratio
	overlay:ClearAllPoints()
	overlay:SetPoint("TOPLEFT", holder, "TOPLEFT", inset, -inset)
	overlay:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -inset, inset)
end

-- ElvUI's template on the holder stays, only made invisible, so switching off
-- just has to color it again.
local function HideElvUIBackdrop(holder)
	holder:SetBackdropColor(0, 0, 0, 0)
	holder:SetBackdropBorderColor(0, 0, 0, 0)
	if holder.iborder then
		holder.iborder:Hide()
	end
	if holder.oborder then
		holder.oborder:Hide()
	end
end

-- The color Blizzard gave this bubble's text, which ElvUI's bordered style uses for the border.
local function GetTextColor(holder)
	local r, g, b = holder.String:GetTextColor()
	if E:IsSecretValue(r) or E:IsSecretValue(g) or E:IsSecretValue(b) then
		return nil
	end
	return r, g, b
end

-- The same template and border color ElvUI's M:SkinBubble and M:UpdateBubbleBorder
-- give the holder.
local function RestoreElvUIBackdrop(holder)
	local noBorder = E.private.general.chatBubbles == "backdrop_noborder"
	holder:SetTemplate("Transparent", nil, true, noBorder)
	holder.Center:SetDrawLayer("BACKGROUND")
	if noBorder then
		holder.Center:SetInside(holder, NOBORDER_INSET, NOBORDER_INSET)
	end
	if holder.iborder then
		holder.iborder:Show()
	end
	if holder.oborder then
		holder.oborder:Show()
	end

	if noBorder then
		holder:SetBackdropBorderColor(0, 0, 0, 0)
	else
		local r, g, b = GetTextColor(holder)
		if r then
			holder:SetBackdropBorderColor(r, g, b)
		end
	end
end

function module:UpdateBubble(bubble)
	if bubble:IsForbidden() then
		return
	end

	local holder = bubble.holder
	if not holder or holder:IsForbidden() then
		return
	end

	local overlay = overlays[bubble]
	if not IsStyleActive() then
		if overlay and overlay:IsShown() then
			overlay:Hide()
			RestoreElvUIBackdrop(holder)
		end
		return
	end

	local db = GetDB()
	overlay = overlay or CreateOverlay(bubble, holder)
	LayoutOverlay(overlay, holder)
	HideElvUIBackdrop(holder)
	overlay:Show()

	local r, g, b
	if E.private.general.chatBubbles == "backdrop" then
		r, g, b = GetTextColor(holder)
	end
	if r then
		overlay:SetBackdropBorderColor(r, g, b)
	elseif E.private.general.chatBubbles == "backdrop" then
		overlay:SetBackdropBorderColor(unpack(E.media.bordercolor))
	else
		overlay:SetBackdropBorderColor(0, 0, 0, 0)
	end

	if overlay.MERStyle then
		overlay.MERStyle:SetShown(db.style)
	end
	if overlay.shadow then
		overlay.shadow:SetShown(db.shadow)
	end
end

-------------------------------------------------------------------------------
--  Speaker name
-------------------------------------------------------------------------------

-- Also used by the options preview.
function module:ColorBubbleName(name, classFile, isNPC, gradient)
	if gradient then
		return F.GradientName(name, classFile or (isNPC and NPC_GRADIENT) or "PRIEST")
	end

	-- Same flat colors as ElvUI's own name
	local color = classFile and E:ClassColor(classFile) or _G.RAID_CLASS_COLORS.PRIEST
	return color:WrapTextInColorCode(name)
end

local function FormatName(entry, gradient)
	local classFile
	if entry.guid then
		local _, class = GetPlayerInfoByGUID(entry.guid)
		if class and E:NotSecretValue(class) then
			classFile = class
		end
	end

	return module:ColorBubbleName(entry.name, classFile, entry.kind == "npc", gradient)
end

-- Exact first; a loose entry (emote) is found when the bubble's text contains it.
local function MatchesEntry(text, line, entry)
	return text == line or (entry.loose and strfind(text, line, 1, true) ~= nil)
end

local function FindEntry(text)
	local entry = senders[text]
	if entry then
		return entry
	end

	for line, candidate in pairs(senders) do
		if candidate.loose and MatchesEntry(text, line, candidate) then
			return candidate
		end
	end
end

-- ElvUI's bubble font when it replaces Blizzard's, else the one of ChatBubbleFont.
-- Also used by the options preview.
function module:SetBubbleNameFont(label, size)
	local general = E.private.general
	if general.replaceBubbleFont then
		label:FontTemplate(general.chatBubbleFont, size, general.chatBubbleFontOutline)
	else
		local font, _, outline = _G.ChatBubbleFont:GetFont()
		label:SetFont(font, size, outline or "")
	end
end

local JUSTIFY_POINTS = {
	LEFT = { "BOTTOMLEFT", "TOPLEFT" },
	CENTER = { "BOTTOM", "TOP" },
	RIGHT = { "BOTTOMRIGHT", "TOPRIGHT" },
}

local function LayoutName(bubble, label)
	local db = GetDB()
	local points = JUSTIFY_POINTS[db.nameJustify] or JUSTIFY_POINTS.LEFT
	local overlay = overlays[bubble]
	local anchor = overlay and overlay:IsShown() and overlay or bubble

	module:SetBubbleNameFont(label, db.nameFontSize)
	label:SetJustifyH(db.nameJustify)
	-- Sized by its text, a long name can reach past a short bubble instead of being cut.
	label:SetSize(0, 0)
	label:ClearAllPoints()
	label:SetPoint(points[1], anchor, points[2], db.nameXOffset, db.nameYOffset)

	styledNames[bubble] = true
end

-- Puts the name back where ElvUI's M:SkinBubble created it.
local function RestoreName(bubble, label)
	if not styledNames[bubble] then
		return
	end
	styledNames[bubble] = nil

	local option = E.private.general.chatBubbles
	local yOffset = (option == "backdrop" and 2) or (option == "backdrop_noborder" and -2) or 0
	label:SetFontObject("ChatBubbleFont")
	local font, size, outline = label:GetFont()
	label:FontTemplate(font, size * 0.85, outline)
	label:SetJustifyH("LEFT")
	label:Height(10)
	label:ClearAllPoints()
	label:Point("BOTTOM", bubble, "TOP", 0, yOffset)
end

-- fromShow: ElvUI is showing the bubble right now and has not recolored the class
-- names in its text yet, so the text still matches the chat line it came from.
function module:UpdateBubbleName(bubble, fromShow)
	if bubble:IsForbidden() then
		return
	end

	local holder, label = bubble.holder, bubble.Name
	if not holder or not label or holder:IsForbidden() then
		return
	end

	if not AreNamesActive() then
		RestoreName(bubble, label)
		return
	end

	local text
	if fromShow then
		text = holder.String:GetText()
		if E:IsSecretValue(text) or not text then
			shownText[bubble] = nil
			return
		end
		shownText[bubble] = text
	else
		text = shownText[bubble]
	end

	local db = GetDB()
	local entry = text and FindEntry(text)
	if entry and (entry.kind ~= "group" or db.groupNames) then
		label:SetText(FormatName(entry, db.nameGradient))
	end

	LayoutName(bubble, label)
end

-------------------------------------------------------------------------------
--  Events
-------------------------------------------------------------------------------

local function ApplyInstanceHide()
	local db = GetDB()
	local wanted = db and db.enable and db.hideInInstances and not WindToolsTogglesBubbles() and IsInInstance()

	if wanted and not savedCVars then
		savedCVars = {}
		for _, name in ipairs(BUBBLE_CVARS) do
			savedCVars[name] = C_CVar_GetCVar(name)
			C_CVar_SetCVar(name, "0")
		end
	elseif not wanted and savedCVars then
		-- A switch the player turned on again in the meantime stays theirs.
		for _, name in ipairs(BUBBLE_CVARS) do
			if savedCVars[name] and C_CVar_GetCVar(name) == "0" then
				C_CVar_SetCVar(name, savedCVars[name])
			end
		end
		savedCVars = nil
	end
end

local function UpdateInstanceHide()
	if InCombatLockdown() then
		eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	ApplyInstanceHide()
end

local function CacheSender(event, text, sender, guid)
	if E:IsSecretValue(text) or E:IsSecretValue(sender) or not text or not sender then
		return
	end

	if senderCount >= CACHE_MAX then
		wipe(senders)
		senderCount = 0
	end

	local name = Ambiguate(sender, "none")
	-- NPC emotes come with a placeholder for the NPC's name.
	if event == "CHAT_MSG_MONSTER_EMOTE" then
		text = gsub(text, "%%s", name)
	end

	if not senders[text] then
		senderCount = senderCount + 1
	end
	local entry = {
		name = name,
		guid = E:NotSecretValue(guid) and guid and guid ~= "" and guid or nil,
		kind = SENDER_EVENTS[event],
		loose = LOOSE_EVENTS[event],
	}
	senders[text] = entry

	-- The bubble can show up before the chat event that belongs to it.
	for bubble in pairs(tracked) do
		if not bubble:IsForbidden() and bubble:IsShown() then
			local shown = shownText[bubble]
			if shown and MatchesEntry(shown, text, entry) then
				module:UpdateBubbleName(bubble)
			end
		end
	end
end

local function OnEvent(_, event, text, sender, _, _, _, _, _, _, _, _, _, guid)
	if event == "PLAYER_ENTERING_WORLD" then
		wipe(senders)
		senderCount = 0
		UpdateInstanceHide()
	elseif event == "PLAYER_REGEN_ENABLED" then
		eventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		ApplyInstanceHide()
	elseif event == "PLAYER_LOGOUT" then
		-- Hands the switches back even if the addon is gone on the next login.
		if savedCVars then
			for _, name in ipairs(BUBBLE_CVARS) do
				if savedCVars[name] then
					C_CVar_SetCVar(name, savedCVars[name])
				end
			end
			savedCVars = nil
		end
	else
		CacheSender(event, text, sender, guid)
	end
end

-- Only the events a setting actually needs are registered.
local function UpdateEvents()
	local db = GetDB()
	local names = AreNamesActive()
	local instanceHide = db and db.enable and db.hideInInstances

	if not eventFrame then
		if not names and not instanceHide and not savedCVars then
			return
		end
		eventFrame = CreateFrame("Frame")
		eventFrame:SetScript("OnEvent", OnEvent)
	end

	for event, kind in pairs(SENDER_EVENTS) do
		if names and (kind ~= "group" or db.groupNames) then
			eventFrame:RegisterEvent(event)
		else
			eventFrame:UnregisterEvent(event)
		end
	end

	if names or instanceHide then
		eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		wipe(senders)
		senderCount = 0
	end

	if instanceHide or savedCVars then
		eventFrame:RegisterEvent("PLAYER_LOGOUT")
	else
		eventFrame:UnregisterEvent("PLAYER_LOGOUT")
	end

	UpdateInstanceHide()
end

-------------------------------------------------------------------------------
--  Setup
-------------------------------------------------------------------------------

local function Bubble_OnShow(bubble)
	module:UpdateBubble(bubble)
end

function module:UpdateBubbles()
	UpdateEvents()

	for bubble in pairs(tracked) do
		self:UpdateBubble(bubble)
		self:UpdateBubbleName(bubble)
	end
end

-- Rides on ElvUI's bubble skin: ElvUI finds the bubbles and skins each one once,
-- we hook in right behind it. Blizzard reuses a small pool, so this runs only a
-- handful of times per session.
function module:InitializeBubbles()
	-- Called from ElvUI's OnShow script with the original text, before ElvUI
	-- recolors the class names in it.
	hooksecurefunc(M, "AddChatBubbleName", function(_, bubble)
		module:UpdateBubbleName(bubble, true)
	end)

	-- Hooked after ElvUI's own OnShow, so ours runs once ElvUI colored its border.
	hooksecurefunc(M, "SkinBubble", function(_, bubble)
		if tracked[bubble] then
			return
		end
		tracked[bubble] = true
		bubble:HookScript("OnShow", Bubble_OnShow)
		module:UpdateBubble(bubble)
		module:UpdateBubbleName(bubble)
	end)
end

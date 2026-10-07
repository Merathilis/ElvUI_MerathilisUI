local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local WS = W:GetModule("Skins")
local AFK = E:GetModule("AFK")

local _G = _G
local ipairs, tonumber, unpack = ipairs, tonumber, unpack
local format = string.format
local tremove = table.remove
local floor, max, random = math.floor, math.max, math.random
local date = date

local CreateAnimationGroup = _G.CreateAnimationGroup -- ElvUI LibAnim
local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local GetGuildInfo = GetGuildInfo
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local GetTime = GetTime
local hooksecurefunc = hooksecurefunc
local IsInGuild = IsInGuild
local GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime

local LOGOUT_TIME = 1800 -- the client logs out after 30 minutes AFK

local PANEL_HEIGHT = 80
local PANEL_OFFSET = 100

-- Intro, staggered: vignette, panel, model, then bubble and sleep Z's
local VIGNETTE_ALPHA = 0.85
local VIGNETTE_DURATION = 2
local INTRO_DELAY = 0.2
local INTRO_OFFSET = 40
local INTRO_DURATION = 1.2
local MODEL_DELAY = 0.6
local MODEL_FADE = 1.6
local DETAILS_DELAY = 1.8
local DETAILS_FADE = 1
local DETAILS_HIDE = 0.4
local DETAILS_RESHOW_DELAY = 0.8

-- Between naps the model wakes up for a random emote, bubble and Z's only show while it sleeps
local SLEEP_ANIMATION = 71
local EMOTE_MIN, EMOTE_MAX = 15, 30 -- seconds asleep before the next emote
local EMOTE_MIN_SHOW = 3 -- short emotes replay until this is reached
local EMOTE_TIMEOUT = 10 -- back to sleep even if the emote never reports its end

local EMOTES = {
	60, -- EmoteTalk
	66, -- EmoteBow
	67, -- EmoteWave
	68, -- EmoteCheer
	69, -- EmoteDance
	70, -- EmoteLaugh
	73, -- EmoteRude
	74, -- EmoteRoar
	75, -- EmoteKneel
	76, -- EmoteKiss
	77, -- EmoteCry
	78, -- EmoteChicken
	79, -- EmoteBeg
	80, -- EmoteApplaud
	81, -- EmoteShout
	82, -- EmoteFlex
	83, -- EmoteShy
	84, -- EmotePoint
	113, -- EmoteSalute
	185, -- EmoteYes
	186, -- EmoteNo
	195, -- EmoteTrain
	506, -- EmoteSniff
}

local BAR_HEIGHT = 3

local PHRASE_INTERVAL = 20
local PHRASE_FADE = 0.4

-- Sleep "Z"s rising from the model, offsets are relative to the model holder center
local ZZZ_SIZES = { 14, 18, 24 }
local ZZZ_X, ZZZ_Y = -60, 20
local ZZZ_DRIFT_X, ZZZ_DRIFT_Y = -25, 70
local ZZZ_RISE = 3
local ZZZ_STAGGER = 1

local phrases = {
	L["AFK ... maybe!?"],
	L["Just five more minutes..."],
	L["Do not disturb!"],
	L["Dreaming of loot..."],
	L["Brb, getting coffee"],
	L["Counting sheep..."],
}

local monthAbr = {
	L["Jan"],
	L["Feb"],
	L["Mar"],
	L["Apr"],
	L["May"],
	L["Jun"],
	L["Jul"],
	L["Aug"],
	L["Sep"],
	L["Oct"],
	L["Nov"],
	L["Dec"],
}

local daysAbr = {
	L["Sun"],
	L["Mon"],
	L["Tue"],
	L["Wed"],
	L["Thu"],
	L["Fri"],
	L["Sat"],
}

local function IsEnabled()
	return E.db.mui.general.AFK == true and MER:HasRequirements(I.Requirements.AFK, true)
end

local function Player_Model(self)
	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(1)
	self:SetCamDistanceScale(8)
	self:SetAlpha(1)
	self:SetAnimation(SLEEP_ANIMATION)
end

---Clock text following ElvUI's Time datatext settings (local/realm time, 12/24h)
local function FormatClock()
	local settings = E.global.datatexts.settings.Time

	local label, hour, minute
	if settings.localTime then
		label = TIMEMANAGER_TOOLTIP_LOCALTIME
		hour, minute = tonumber(date("%H")), tonumber(date("%M"))
	else
		label = TIMEMANAGER_TOOLTIP_REALMTIME
		hour, minute = GetGameTime()
	end

	if settings.time24 then
		return format("|cffb3b3b3%s|r %02d:%02d", label, hour, minute)
	end

	local suffix = hour >= 12 and "pm" or "am"
	hour = hour % 12
	if hour == 0 then
		hour = 12
	end

	return format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", label, hour, minute, suffix)
end

local function UpdateClock()
	local panel = AFK.AFKMode.Panel
	if not panel then
		return
	end

	panel.clock:SetText(FormatClock())

	local now = GetCurrentCalendarTime()
	panel.date:SetFormattedText("%s, %s %d, %d", daysAbr[now.weekday], monthAbr[now.month], now.monthDay, now.year)
end
hooksecurefunc(AFK, "UpdateTimer", UpdateClock)

local function CancelTimer(key)
	if AFK[key] then
		AFK:CancelTimer(AFK[key])
		AFK[key] = nil
	end
end

local function UpdateLogOff()
	local panel = AFK.AFKMode.Panel
	local remaining = max(LOGOUT_TIME - (GetTime() - AFK.startTime), 0)

	panel.logoutBar:SetValue(remaining)
	panel.count:SetFormattedText(
		"%s: |cfff0ff00%s%02d:%02d|r",
		L["Logout Timer"],
		remaining > 0 and "-" or "",
		floor(remaining / 60),
		remaining % 60
	)

	if remaining == 0 then
		CancelTimer("logoffTimer")
	end
end

---Random phrase, never the one currently shown
local function PickPhrase(current)
	local phrase
	repeat
		phrase = phrases[random(#phrases)]
	until phrase ~= current or #phrases < 2

	return phrase
end

local function RotatePhrase()
	AFK.AFKMode.Panel.bubbleText.fadeOut:Play()
end

---Native alpha animation that keeps its final alpha
local function CreateAlphaAnimation(region, fromAlpha, toAlpha, duration)
	local group = region:CreateAnimationGroup()
	group:SetToFinalAlpha(true)

	local alpha = group:CreateAnimation("Alpha")
	alpha:SetFromAlpha(fromAlpha)
	alpha:SetToAlpha(toAlpha)
	alpha:SetDuration(duration)

	return group
end

---LibAnim group that waits, then fades the frame in (optionally moving it by offsetY)
local function CreateDelayedIntro(frame, delay, duration, offsetY)
	local group = CreateAnimationGroup(frame)

	group.hold = group:CreateAnimation("Sleep")
	group.hold:SetDuration(delay)
	group.hold:SetOrder(1)

	group.fade = group:CreateAnimation("Fade")
	group.fade:SetChange(1)
	group.fade:SetDuration(duration)
	group.fade:SetEasing("out-quintic")
	group.fade:SetOrder(2)

	if offsetY then
		group.move = group:CreateAnimation("Move")
		group.move:SetOffset(0, offsetY)
		group.move:SetDuration(duration)
		group.move:SetEasing("out-quintic")
		group.move:SetOrder(2)
	end

	return group
end

local function CreateFadeOut(frame, duration)
	local group = CreateAnimationGroup(frame)

	group.fade = group:CreateAnimation("Fade")
	group.fade:SetChange(0)
	group.fade:SetDuration(duration)
	group.fade:SetEasing("out-quintic")

	return group
end

-- 3D models ignore the alpha of their parents, so the model gets its own fade
local function SetModelAlpha(model, alpha)
	model.modelAlpha = alpha
	model:SetModelAlpha(alpha)
end

local function Model_FadeOnUpdate(model, elapsed)
	model.fadeTimer = model.fadeTimer + elapsed

	local progress = (model.fadeTimer - MODEL_DELAY) / MODEL_FADE
	if progress <= 0 then
		return
	elseif progress >= 1 then
		SetModelAlpha(model, 1)
		model:SetScript("OnUpdate", nil)
		return
	end

	SetModelAlpha(model, progress * progress * (3 - 2 * progress)) -- smoothstep
end

local function StartModelFade(model)
	SetModelAlpha(model, 0)
	model.fadeTimer = 0
	model:SetScript("OnUpdate", Model_FadeOnUpdate)
end

---Emotes in random order, none repeats until all of them played
local emoteBag = {}
local lastEmote

local function NextEmote(model)
	if #emoteBag == 0 then
		for _, emote in ipairs(EMOTES) do
			if model:HasAnimation(emote) then
				emoteBag[#emoteBag + 1] = emote
			end
		end

		for i = #emoteBag, 2, -1 do
			local j = random(i)
			emoteBag[i], emoteBag[j] = emoteBag[j], emoteBag[i]
		end

		-- The new round shouldn't start with the emote that ended the last one
		if #emoteBag > 1 and emoteBag[#emoteBag] == lastEmote then
			emoteBag[1], emoteBag[#emoteBag] = emoteBag[#emoteBag], emoteBag[1]
		end
	end

	lastEmote = tremove(emoteBag)

	return lastEmote
end

local function ShowDetails(panel, show)
	for _, holder in ipairs(panel.details) do
		holder.intro:Stop()
		holder.reshow:Stop()
		holder.hide:Stop()

		if show then
			holder.reshow:Play()
		else
			holder.hide:Play()
		end
	end
end

local ScheduleEmote

local function FallAsleep()
	local panel = AFK.AFKMode.Panel
	local model = panel.playerModel

	CancelTimer("emoteEndTimer")
	model.emote = nil
	model:SetAnimation(SLEEP_ANIMATION)
	ShowDetails(panel, true)
	ScheduleEmote()
end

local function PlayEmote()
	AFK.emoteTimer = nil

	local panel = AFK.AFKMode.Panel
	local model = panel.playerModel

	-- Nothing playable yet (model still loading), try again after the next nap
	local emote = NextEmote(model)
	if not emote then
		ScheduleEmote()
		return
	end

	model.emote = emote
	model.emoteStart = GetTime()
	model:SetAnimation(emote)
	ShowDetails(panel, false)

	CancelTimer("emoteEndTimer")
	AFK.emoteEndTimer = AFK:ScheduleTimer(FallAsleep, EMOTE_TIMEOUT)
end

function ScheduleEmote()
	CancelTimer("emoteTimer")
	AFK.emoteTimer = AFK:ScheduleTimer(PlayEmote, random(EMOTE_MIN, EMOTE_MAX))
end

local function Model_OnAnimFinished(model)
	if not model.emote then
		return
	end

	if GetTime() - model.emoteStart < EMOTE_MIN_SHOW then
		model:SetAnimation(model.emote)
		return
	end

	FallAsleep()
end

local function AddZStep(group, order, share, fromAlpha, toAlpha)
	local duration = ZZZ_RISE * share

	local move = group:CreateAnimation("Translation")
	move:SetOffset(ZZZ_DRIFT_X * share, ZZZ_DRIFT_Y * share)
	move:SetDuration(duration)
	move:SetOrder(order)

	local alpha
	if fromAlpha then
		alpha = group:CreateAnimation("Alpha")
		alpha:SetFromAlpha(fromAlpha)
		alpha:SetToAlpha(toAlpha)
		alpha:SetDuration(duration)
		alpha:SetOrder(order)
	end

	return move, alpha
end

---One rising "Z", every Z loops with the same cycle length so the stagger holds
local function CreateSleepZ(parent, index, size)
	local z = parent:CreateFontString(nil, "OVERLAY")
	z:FontTemplate(nil, size, "SHADOWOUTLINE")
	z:SetText("Z")
	z:SetTextColor(unpack(E.media.rgbvaluecolor))
	z:SetPoint("CENTER", parent, "CENTER", ZZZ_X, ZZZ_Y)
	z:SetAlpha(0)

	local group = z:CreateAnimationGroup()
	group:SetLooping("REPEAT")
	group:SetToFinalAlpha(true)

	-- Fade in, drift, fade out, the steps add up to the full rise
	local delay = (index - 1) * ZZZ_STAGGER
	local firstMove, firstAlpha = AddZStep(group, 1, 0.25, 0, 1)
	firstMove:SetStartDelay(delay)
	firstAlpha:SetStartDelay(delay)
	AddZStep(group, 2, 0.35)
	local lastMove, lastAlpha = AddZStep(group, 3, 0.4, 1, 0)
	local endDelay = (#ZZZ_SIZES - index) * ZZZ_STAGGER
	lastMove:SetEndDelay(endDelay)
	lastAlpha:SetEndDelay(endDelay)

	z.anim = group

	return z
end

local function UpdateGuild(panel)
	if IsInGuild() then
		local guildName = GetGuildInfo("player")
		panel.guild:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
	else
		panel.guild:SetText(L["No Guild"])
	end
end

local function StartScreen(panel)
	local afkMode = AFK.AFKMode

	UpdateGuild(panel)
	UpdateClock()

	-- The vignette darkens the world, then panel, model and details follow one after another
	afkMode.Vignette:SetAlpha(0)
	afkMode.Vignette.fadeIn:Play()

	panel.intro:Stop()
	panel:ClearAllPoints()
	panel:SetPoint("BOTTOM", afkMode, "BOTTOM", 0, PANEL_OFFSET - INTRO_OFFSET)
	panel:SetAlpha(0)
	panel.intro:Play()

	StartModelFade(panel.playerModel)
	panel.playerModel.emote = nil
	ScheduleEmote()

	for _, holder in ipairs(panel.details) do
		holder.intro:Stop()
		holder:SetAlpha(0)
		holder.intro:Play()
	end

	-- ElvUI's SetAFK just set startTime
	CancelTimer("logoffTimer")
	UpdateLogOff()
	AFK.logoffTimer = AFK:ScheduleRepeatingTimer(UpdateLogOff, 1)

	panel.bubbleText:SetText(PickPhrase(panel.bubbleText:GetText()))
	panel.bubbleText:SetAlpha(1)
	CancelTimer("phraseTimer")
	AFK.phraseTimer = AFK:ScheduleRepeatingTimer(RotatePhrase, PHRASE_INTERVAL)

	for _, z in ipairs(panel.sleepZ) do
		z.anim:Play()
	end
end

local function StopScreen(panel)
	CancelTimer("logoffTimer")
	CancelTimer("phraseTimer")
	CancelTimer("emoteTimer")
	CancelTimer("emoteEndTimer")

	panel.intro:Stop()
	for _, holder in ipairs(panel.details) do
		holder.intro:Stop()
		holder.reshow:Stop()
		holder.hide:Stop()
	end
	panel.playerModel.emote = nil
	panel.playerModel:SetScript("OnUpdate", nil)
	panel.bubbleText.fadeOut:Stop()
	panel.bubbleText.fadeIn:Stop()

	for _, z in ipairs(panel.sleepZ) do
		z.anim:Stop()
		z:SetAlpha(0)
	end
end

AFK.SetAFKMER = AFK.SetAFK
function AFK:SetAFK(status)
	-- ElvUI's own SetAFK already clears isAFK when leaving, so the state from before its call decides
	local wasAFK = self.isAFK
	self:SetAFKMER(status)

	-- Only built on load while the MER screen is enabled
	local panel = self.AFKMode.Panel
	if not panel then
		return
	end

	if not status then
		if wasAFK then
			StopScreen(panel)
		end
		return
	end

	-- PLAYER_FLAGS_CHANGED calls this again while AFK, don't restart the screen then
	if wasAFK or not IsEnabled() then
		return
	end

	StartScreen(panel)
end

local function CreateText(parent, size)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size, "SHADOWOUTLINE")

	return text
end

function module:AFK()
	if E.db.general.afk ~= true or not IsEnabled() then
		return
	end

	local afkMode = AFK.AFKMode
	if afkMode.Panel then
		return
	end

	-- Hide ElvUI Elements
	afkMode.bottom:Hide()
	afkMode.bottom.LogoTop:Hide()
	afkMode.bottom.LogoBottom:Hide()

	-- Vignette, below the chat and the panel
	local vignette = afkMode:CreateTexture(nil, "BACKGROUND")
	vignette:SetAllPoints(afkMode)
	vignette:SetTexture(I.Media.Textures.AFKVignette)
	vignette:SetAlpha(0)
	vignette.fadeIn = CreateAlphaAnimation(vignette, 0, VIGNETTE_ALPHA, VIGNETTE_DURATION)
	afkMode.Vignette = vignette

	local panel = CreateFrame("Frame", nil, afkMode, "BackdropTemplate")
	panel:SetPoint("BOTTOM", afkMode, "BOTTOM", 0, PANEL_OFFSET)
	panel:Size(GetScreenWidth() / 2, PANEL_HEIGHT)
	panel:CreateBackdrop("Transparent")
	panel:SetFrameStrata("FULLSCREEN")
	WS:CreateBackdropShadow(panel)

	E.frames[panel] = true
	panel.ignoreFrameTemplates = true
	panel.ignoreBackdropColors = true
	afkMode.Panel = panel

	panel.intro = CreateDelayedIntro(panel, INTRO_DELAY, INTRO_DURATION, INTRO_OFFSET)

	panel.crest = panel:CreateTexture(nil, "ARTWORK")
	panel.crest:Point("BOTTOM", panel, "TOP", 0, -30)
	panel.crest:SetTexture(I.Media.Textures.PepoBedge)
	panel.crest:Size(64)

	-- Logout countdown, drains along the bottom edge
	local logoutBar = CreateFrame("StatusBar", nil, panel)
	logoutBar:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT")
	logoutBar:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT")
	logoutBar:Height(BAR_HEIGHT)
	logoutBar:SetStatusBarTexture(E.media.normTex)
	logoutBar:SetMinMaxValues(0, LOGOUT_TIME)
	logoutBar:SetValue(LOGOUT_TIME)
	F.Color.SetGradient(logoutBar:GetStatusBarTexture(), "HORIZONTAL", F.GradientColors(E.myclass))

	logoutBar.bg = logoutBar:CreateTexture(nil, "BACKGROUND")
	logoutBar.bg:SetAllPoints(logoutBar)
	logoutBar.bg:SetColorTexture(0, 0, 0, 0.4)
	panel.logoutBar = logoutBar

	-- Center
	panel.version = CreateText(panel, 24)
	panel.version:Point("CENTER", panel, "CENTER", 0, -10)
	panel.version:SetText(MER.Title .. "|cFF00c0fa" .. MER.DisplayVersion .. "|r")

	-- Right: date, clock, logout timer
	panel.date = CreateText(panel, 15)
	panel.date:Point("RIGHT", panel, "RIGHT", -5, 24)

	panel.clock = CreateText(panel, 20)
	panel.clock:Point("RIGHT", panel, "RIGHT", -5, 0)

	panel.count = CreateText(panel, 14)
	panel.count:Point("RIGHT", panel, "RIGHT", -5, -26)
	panel.count:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])

	-- Left: name, guild, level/faction/class
	local classColor = E:ClassColor(E.myclass)

	panel.playerName = CreateText(panel, 24)
	panel.playerName:Point("LEFT", panel, "LEFT", 5, 20)
	panel.playerName:SetText(E.myname)
	panel.playerName:SetTextColor(F.r, F.g, F.b)

	panel.guild = CreateText(panel, 16)
	panel.guild:Point("LEFT", panel, "LEFT", 5, 0)

	panel.playerInfo = CreateText(panel, 15)
	panel.playerInfo:Point("LEFT", panel, "LEFT", 5, -25)
	local className = E.myLocalizedClass:gsub("%-.+", "*")
	panel.playerInfo:SetFormattedText(
		"%s %d %s %s%s|r",
		_G.LEVEL,
		E.mylevel,
		E.myLocalizedFaction,
		E:RGBToHex(classColor.r, classColor.g, classColor.b),
		className
	)

	-- Player Model
	local modelHolder = CreateFrame("Frame", nil, panel)
	modelHolder:SetSize(150, 150)
	modelHolder:SetPoint("RIGHT", panel, "RIGHT", 250, 100)
	panel.modelHolder = modelHolder

	local playerModel = CreateFrame("PlayerModel", nil, modelHolder)
	-- Double the screen size on purpose, this prevents clipping of models.
	playerModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
	playerModel:SetPoint("CENTER", modelHolder, "CENTER")
	playerModel:SetScript("OnShow", Player_Model)
	-- Loading the model can reset its alpha, keep the fade going
	playerModel:SetScript("OnModelLoaded", function(model)
		model:SetModelAlpha(model.modelAlpha or 1)
	end)
	playerModel:SetScript("OnAnimFinished", Model_OnAnimFinished)
	playerModel:SetFrameLevel(3)
	panel.playerModel = playerModel

	-- Bubble and sleep Z's fade in once the model is there
	panel.details = {}

	-- Speech Bubble, below the model
	local bubbleHolder = CreateFrame("Frame", nil, modelHolder)
	bubbleHolder:SetAllPoints(modelHolder)
	bubbleHolder:SetFrameLevel(playerModel:GetFrameLevel() - 1)
	bubbleHolder.intro = CreateDelayedIntro(bubbleHolder, DETAILS_DELAY, DETAILS_FADE)
	bubbleHolder.reshow = CreateDelayedIntro(bubbleHolder, DETAILS_RESHOW_DELAY, DETAILS_FADE)
	bubbleHolder.hide = CreateFadeOut(bubbleHolder, DETAILS_HIDE)
	panel.details[1] = bubbleHolder

	local bubble = bubbleHolder:CreateTexture(nil, "BACKGROUND")
	bubble:SetPoint("TOP", modelHolder, "TOP", 30, 80)
	bubble:SetTexture(I.General.MediaPath .. "Textures\\bubble")
	panel.bubble = bubble

	local bubbleText = CreateText(bubbleHolder, 18)
	bubbleText:SetPoint("CENTER", bubble, "CENTER", 0, 10)
	bubbleText:SetWidth(200)
	bubbleText:SetJustifyH("CENTER")
	bubbleText:SetJustifyV("MIDDLE")
	bubbleText:SetTextColor(unpack(E.media.rgbvaluecolor))
	bubbleText:SetShadowOffset(2, -2)
	panel.bubbleText = bubbleText

	bubbleText.fadeIn = CreateAlphaAnimation(bubbleText, 0, 1, PHRASE_FADE)
	bubbleText.fadeOut = CreateAlphaAnimation(bubbleText, 1, 0, PHRASE_FADE)
	bubbleText.fadeOut:SetScript("OnFinished", function()
		bubbleText:SetText(PickPhrase(bubbleText:GetText()))
		bubbleText.fadeIn:Play()
	end)

	-- Sleep Z's, above the model
	local zzzHolder = CreateFrame("Frame", nil, modelHolder)
	zzzHolder:SetAllPoints(modelHolder)
	zzzHolder:SetFrameLevel(playerModel:GetFrameLevel() + 2)
	zzzHolder.intro = CreateDelayedIntro(zzzHolder, DETAILS_DELAY, DETAILS_FADE)
	zzzHolder.reshow = CreateDelayedIntro(zzzHolder, DETAILS_RESHOW_DELAY, DETAILS_FADE)
	zzzHolder.hide = CreateFadeOut(zzzHolder, DETAILS_HIDE)
	panel.details[2] = zzzHolder

	panel.sleepZ = {}
	for index, size in ipairs(ZZZ_SIZES) do
		panel.sleepZ[index] = CreateSleepZ(zzzHolder, index, size)
	end
end

module:AddCallback("AFK")

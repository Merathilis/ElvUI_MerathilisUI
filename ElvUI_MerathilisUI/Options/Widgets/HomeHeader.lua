local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

-- Start page header of the MerathilisUI options: the logo + description
-- (an embedded "MERNewFeatureLabel", so its trailing NEW badge keeps working)
-- on the left and a "What's New" card on the right, filling the empty space
-- next to the description text. The card lists the newest changelog entries,
-- rotates "Did you know?" tips and ends with a small status line (profile,
-- ElvUI and WindTools version).
--
-- One widget instead of two side-by-side options: AceConfigDialog's Flow
-- layout can't pin a second description to the right edge, it would either
-- wrap below or pull the buttons of the next row up next to it.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type, Version = "MERHomeHeader", 1

local floor, max, min = math.floor, math.max, math.min
local format, gsub = string.format, string.gsub
local ipairs, mod, pairs, random, tostring, unpack, wipe = ipairs, mod, pairs, math.random, tostring, unpack, wipe
local sort, tconcat, tremove = table.sort, table.concat, table.remove
local CreateFrame, UIParent = CreateFrame, UIParent
local GameTooltip = GameTooltip
local PlaySound = PlaySound

local CARD_MIN_WIDTH = 300
local CARD_MAX_WIDTH = 420
local CARD_WIDTH_RATIO = 0.38
local CARD_GAP = 16
-- Below this the description next to the 200px logo gets too narrow, so the
-- card is hidden and the label takes the full width again.
local LABEL_MIN_WIDTH = 560

local PADDING = 10
local LINE_HEIGHT = 16
local SPACING = 6
-- 3 changelog lines keep the card (with the tips) about as tall as the logo
local MAX_LINES = 3
local TIP_TEXT_HEIGHT = 28 -- two lines of GameFontHighlightSmall
local TIP_INTERVAL = 10
local TIP_FADE_DURATION = 0.2

local COLOR_LINK = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_LINK_HOVER = { 1, 1, 1 }

local tipIcon = format("|T%s:14:14|t", I.Media.Icons.Categories.Tips)

-- "Did you know?" tips; `path` is the option group the tip links to,
-- `retailOnly` drops the tip on WoW Forever, where that feature is off
local tips = {
	{ text = L["Type /mer status to open the Status Report. Post it when you report a bug."] },
	{
		text = L["/muidebug on turns off all other addons except ElvUI, WindTools, MerathilisUI and BugSack. /muidebug off turns them back on."],
	},
	{ text = L["Type /mer changelog to read what changed in every version."], path = { "information", "changelog" } },
	{ text = L["Type /mer install to run the installer again, e.g. to reapply the MerathilisUI profile."] },
	{
		text = L["Type /mer presets to pick a ready-made look. Every preset becomes a new ElvUI profile, so you can switch back at any time."],
		path = { "presets", "official" },
	},
	{
		text = L["More presets from the community wait on merathilisui.com/presets. Copy a code and paste it under Presets > Import."],
		path = { "presets", "import" },
	},
	{
		text = L["Presets > Export turns your setup into a code. Upload it with a few screenshots on merathilisui.com to share it."],
		path = { "presets", "export" },
	},
	{ text = L["Type /mlr to preview the Loot Roll bar with test rolls."], path = { "modules", "lootRoll" } },
	{
		text = L["Type /lsm to open the LootSpecManager. It switches your loot spec per boss in raids and Mythic+."],
		path = { "misc", "general" },
		retailOnly = true,
	},
	{
		text = L["Movement Alert shows the cooldown of your movement spells while they are not ready."],
		path = { "modules", "movementAlert" },
	},
	{
		text = L["The Tracker shows your group's battle res charges in Mythic+ keys and raid boss encounters."],
		path = { "modules", "tracker" },
	},
	{
		text = L["Cursor puts a colored ring around your mouse cursor, optionally with a GCD and cast ring."],
		path = { "modules", "cursor" },
	},
	{
		text = L["The Chat Sidebar gives quick access to friends, guild, copy chat and M+ portals."],
		path = { "modules", "chat" },
	},
	{
		text = L["Loot Roll replaces the roll frames with a movable bar. Its Test button shows a preview."],
		path = { "modules", "lootRoll" },
	},
	{ text = L["Buff Reminder shows icons for the raid buffs you are missing."], path = { "modules", "buffReminder" } },
	{
		text = L["HoverCast casts your spells on the unit frame or unit under your mouse and replaces Clique."],
		path = { "modules", "hoverCast" },
	},
	{
		text = L["HoverCast's Quickbind binds a spell in one step: hover it and press a key or click."],
		path = { "modules", "hoverCast" },
	},
	{
		text = L["Interrupt Ready colors enemy castbars while your interrupt is on cooldown and marks when it is ready again."],
		path = { "modules", "nameplates", "general" },
	},
	{
		text = L["In Mythic+, the nameplates can show how much Enemy Forces each enemy is worth."],
		path = { "modules", "nameplates", "general" },
	},
	{
		text = L["Cast on You marks the castbar of enemies whose cast targets you."],
		path = { "modules", "nameplates", "general" },
	},
	{
		text = L["Categorized Bags sorts your bags into groups like equipment, consumables and quest items."],
		path = { "modules", "bags", "categorizedBags" },
	},
	{
		text = L["The Armory warns you about missing enchants and sockets on your gear."],
		path = { "modules", "armory" },
		retailOnly = true,
	},
	{
		text = L["Mail adds checkboxes to open or delete several mails at once and saves recipient lists."],
		path = { "modules", "mail" },
	},
	{
		text = L["Right-click the Durability/Ilevel datatext to summon your repair mount."],
		path = { "modules", "datatexts" },
	},
	{
		text = L["The Minimap Buttons bar adds a Great Vault button and your M+ portals next to the Minimap."],
		path = { "modules", "maps" },
		retailOnly = true,
	},
	{
		text = L["Addon Buttons on the Minimap Buttons bar collects the minimap buttons of your addons into one grid."],
		path = { "modules", "maps" },
	},
	{
		text = L["Want an addon button to stay on the Minimap? Add its name to the Ignored Buttons of Addon Buttons."],
		path = { "modules", "maps" },
	},
	{
		text = L["The Location Panel above the Minimap can show your coordinates. Left-click it to open the World Map, right-click to link your location in chat."],
		path = { "modules", "maps" },
	},
	{
		text = L["The Specialization Bar switches your spec with a left click and your loot spec with a right click."],
		path = { "modules", "actionbars" },
		retailOnly = true,
	},
	{
		text = L["Auras can add a collapse button to your buffs that hides long-lasting ones until they are about to expire."],
		path = { "modules", "auras" },
	},
	{
		text = L["Item Level shows the item level on items in the merchant and trade windows."],
		path = { "modules", "itemLevel" },
	},
	{
		text = L["Singing Sockets adds a selection tool to the socketing frame."],
		path = { "misc", "singingSockets" },
		retailOnly = true,
	},
	{ text = L["The Game Menu can show random battle pets."], path = { "misc", "gameMenu" } },
	{ text = L["The Raid Info Frame lists the players in your raid by role."], path = { "misc", "raidInfo" } },
	{ text = L["MerathilisUI adds extra oUF tags you can use in the UnitFrames options."], path = { "misc", "tags" } },
}

if E.Forever then
	for i = #tips, 1, -1 do
		if tips[i].retailOnly then
			tremove(tips, i)
		end
	end
end

local sectionIcons = {
	NEW = F.GetIconString(I.Media.Icons.New, 12),
	IMPROVEMENTS = F.GetIconString(I.Media.Icons.Flash, 12),
	FIXES = F.GetIconString(I.Media.Icons.Warning, 12),
}

-- Order the card fills its lines in, new features first
local sectionOrder = { "NEW", "IMPROVEMENTS", "FIXES" }

local function FormatVersion(version)
	return format("%d.%02d", floor(version / 100), mod(version, 100))
end

-- Same "[Module]" highlight the changelog page uses
local function RenderLine(line)
	return (gsub(line, "%[[^%[]+%]", function(text)
		return C.StringByTemplate(text, "blue-500")
	end))
end

local function HasEntries(data)
	for _, section in ipairs(sectionOrder) do
		if data[section] and #data[section] > 0 then
			return true
		end
	end
end

-- Newest changelog that has entries; the in-development file stays empty
-- until the first entries land, so the card falls back to the last release.
local versions = {}
local function GetLatestChangelog()
	wipe(versions)
	for version, data in pairs(MER.Changelog) do
		if version ~= 999 and HasEntries(data) then
			versions[#versions + 1] = version
		end
	end
	sort(versions)

	local version = versions[#versions]
	return version, version and MER.Changelog[version]
end

local function GetStatusText()
	local profile
	local layoutVersion = E.db.mui.core.lastLayoutVersion
	if not F.IsMERProfile() then
		profile = F.String.Error(L["Not Installed"])
	elseif layoutVersion ~= MER.DisplayVersion then
		profile = F.String.Warning(layoutVersion)
	else
		profile = F.String.Good(layoutVersion)
	end

	local elvui = tostring(E.version)
	if MER.ElvUIVersion < MER.RequiredVersion then
		elvui = F.String.Error(elvui)
	elseif MER.ElvUIVersion > MER.RequiredVersion + 0.03 then
		elvui = F.String.Warning(elvui)
	else
		elvui = F.String.Good(elvui)
	end

	return format(
		"%s %s    %s %s    %s %s",
		F.String.Muted(L["Profile"] .. ":"),
		profile,
		F.String.Muted("ElvUI:"),
		elvui,
		F.String.Muted("WindTools:"),
		W.Version or "?"
	)
end

local function Line_OnEnter(line)
	if not line.fullText then
		return
	end

	GameTooltip:SetOwner(line, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(line.fullText, 1, 1, 1, true)
	GameTooltip:Show()
end

local function Line_OnLeave()
	GameTooltip:Hide()
end

local function Link_OnEnter(link)
	link.text:SetTextColor(unpack(COLOR_LINK_HOVER))
end

local function Link_OnLeave(link)
	link.text:SetTextColor(unpack(COLOR_LINK))
end

local function Link_OnClick(link)
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	local version = link.obj.changelogVersion
	if version then
		E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mui", "information", "changelog", tostring(version))
	else
		E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mui", "information", "changelog")
	end
end

local function SetTip(card, index)
	local tip = tips[index]
	card.tipIndex = index
	card.tipCounter:SetText(F.String.Muted(format("%d/%d", index, #tips)))

	local button = card.tipButton
	-- Every option page but the start page stays hidden until the installer
	-- ran, so the tip only links somewhere once it did
	local path = tip.path and F.IsMERProfile() and tip.path
	button.path = path or nil
	button:EnableMouse(path and true or false)

	if path then
		local link = L["Go to Option"] .. " >|r"
		button.normalText = tip.text .. "  " .. E:RGBToHex(unpack(COLOR_LINK)) .. link
		button.hoverText = tip.text .. "  " .. E:RGBToHex(unpack(COLOR_LINK_HOVER)) .. link
	else
		button.normalText = tip.text
		button.hoverText = tip.text
	end

	button.text:SetText(button:IsMouseOver() and button.hoverText or button.normalText)
end

local function ShowTip(card, index, instant)
	card.tipElapsed = 0

	if instant then
		-- A stopped fade-out never swaps its pending tip in, so drop it
		card.nextTipIndex = nil
		card.tipFadeOut:Stop()
		card.tipFadeIn:Stop()
		card.tipButton:SetAlpha(1)
		SetTip(card, index)
		return
	end

	-- Fade out, swap the text in OnFinished, fade back in
	card.nextTipIndex = index
	if not card.tipFadeOut:IsPlaying() then
		card.tipFadeIn:Stop()
		card.tipFadeOut:Play()
	end
end

local function StepTip(card, delta)
	local index = card.nextTipIndex or card.tipIndex
	-- Lua's % (floored), not WoW's mod (math.fmod), which stays negative and
	-- would step from the first tip to index -1 instead of the last one
	ShowTip(card, (index - 1 + delta) % #tips + 1)
end

local function TipFadeOut_OnFinished(group)
	local card = group.card
	SetTip(card, card.nextTipIndex)
	card.nextTipIndex = nil
	card.tipFadeIn:Play()
end

local function Card_OnUpdate(card, elapsed)
	-- Paused while the mouse is on the card, so a tip can be read in full
	if card:IsMouseOver() then
		return
	end

	card.tipElapsed = card.tipElapsed + elapsed
	if card.tipElapsed >= TIP_INTERVAL then
		StepTip(card, 1)
	end
end

local function Arrow_OnClick(arrow)
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	StepTip(arrow.card, arrow.delta)
end

local function Tip_OnEnter(button)
	button.text:SetText(button.hoverText)
end

local function Tip_OnLeave(button)
	button.text:SetText(button.normalText)
end

local function Tip_OnClick(button)
	if not button.path then
		return
	end

	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mui", unpack(button.path))
end

local function UpdateCard(self)
	local card = self.card
	local version, data = GetLatestChangelog()
	self.changelogVersion = version

	local title =
		format(L["What's New in %s"], F.String.MERATHILISUI(version and FormatVersion(version) or MER.Version))
	card.title:SetText(sectionIcons.NEW .. " " .. title)

	local releaseDate = data and data.RELEASE_DATE
	card.date:SetText(F.String.Muted((not releaseDate or releaseDate == "TBD") and L["In Development"] or releaseDate))

	local used = 0
	if data then
		for _, section in ipairs(sectionOrder) do
			local entries = data[section]
			if entries then
				for _, entry in ipairs(entries) do
					if used == MAX_LINES then
						break
					end
					used = used + 1

					local line = card.lines[used]
					local text = RenderLine(entry)
					line.text:SetText(sectionIcons[section] .. " " .. text)
					line.fullText = text
					line:Show()
				end
			end
		end
	end

	for i = used + 1, MAX_LINES do
		card.lines[i].fullText = nil
		card.lines[i]:Hide()
	end

	local counts = {}
	for _, section in ipairs(sectionOrder) do
		counts[#counts + 1] = sectionIcons[section] .. " " .. (data and data[section] and #data[section] or 0)
	end
	card.summary:SetText(tconcat(counts, "   "))

	-- Measured here rather than once in the constructor, the font object can
	-- change (ElvUI font settings) between two openings of the options
	card.link:SetWidth(card.link.text:GetStringWidth() + 4)
	-- The changelog page is hidden like every category until the installer ran
	card.link:SetShown(F.IsMERProfile())

	ShowTip(card, random(#tips), true)

	card.status:SetText(GetStatusText())

	-- Footer and status sit below the last used line, so the card shrinks
	-- when a version only has a couple of entries.
	local linesHeight = max(used, 1) * LINE_HEIGHT
	card.footer:ClearAllPoints()
	card.footer:SetPoint("TOPLEFT", card.title, "BOTTOMLEFT", 0, -(SPACING * 2 + 1 + linesHeight + SPACING))
	card.footer:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)

	local height = PADDING + LINE_HEIGHT + SPACING * 2 + 1 + linesHeight + SPACING + LINE_HEIGHT -- title, lines, footer
	height = height + SPACING + 1 + SPACING + LINE_HEIGHT + 2 + TIP_TEXT_HEIGHT -- tips
	height = height + SPACING + 1 + SPACING + LINE_HEIGHT + PADDING -- status
	card:SetHeight(height)
end

local function UpdateLayout(self)
	if self.resizing or not self.label then
		return
	end

	local frame = self.frame
	local width = frame.width or frame:GetWidth() or 0
	local card = self.card
	local label = self.label

	local cardWidth = min(CARD_MAX_WIDTH, max(CARD_MIN_WIDTH, floor(width * CARD_WIDTH_RATIO)))
	local showCard = (width - cardWidth - CARD_GAP) >= LABEL_MIN_WIDTH

	label.frame:ClearAllPoints()
	label.frame:SetPoint("TOPLEFT", frame, "TOPLEFT")
	label:SetWidth(showCard and (width - cardWidth - CARD_GAP) or width)

	local height = label.frame.height or label.frame:GetHeight() or 1
	card:ClearAllPoints()
	card:SetShown(showCard)
	if showCard then
		card:SetWidth(cardWidth)
		local cardHeight = card:GetHeight()
		height = max(height, cardHeight)
		-- Vertically centered next to the logo
		card:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -floor((height - cardHeight) / 2))
	end

	self.resizing = true
	frame:SetHeight(height)
	frame.height = height
	self.resizing = nil
end

local methods = {
	["OnAcquire"] = function(self)
		local label = AceGUI:Create("MERNewFeatureLabel")
		label.frame:SetParent(self.frame)
		label.frame:Show()
		self.label = label

		self.resizing = true
		self:SetWidth(200)
		self.resizing = nil

		UpdateCard(self)
		UpdateLayout(self)
	end,

	["OnRelease"] = function(self)
		if self.label then
			self.label:Release()
			self.label = nil
		end
		self.changelogVersion = nil
	end,

	["OnWidthSet"] = function(self)
		UpdateLayout(self)
	end,

	-- Everything AceConfigDialog sets on a description goes to the embedded
	-- label, followed by a relayout since the label's height may change.
	["SetText"] = function(self, ...)
		self.label:SetText(...)
		UpdateLayout(self)
	end,

	["SetColor"] = function(self, ...)
		self.label:SetColor(...)
	end,

	["SetImage"] = function(self, ...)
		self.label:SetImage(...)
		UpdateLayout(self)
	end,

	["SetImageSize"] = function(self, ...)
		self.label:SetImageSize(...)
		UpdateLayout(self)
	end,

	["SetFont"] = function(self, ...)
		self.label:SetFont(...)
		UpdateLayout(self)
	end,

	["SetFontObject"] = function(self, ...)
		self.label:SetFontObject(...)
		UpdateLayout(self)
	end,

	["SetJustifyH"] = function(self, ...)
		self.label:SetJustifyH(...)
	end,

	["SetJustifyV"] = function(self, ...)
		self.label:SetJustifyV(...)
	end,
}

local function CreateText(parent, fontObject)
	local text = parent:CreateFontString(nil, "OVERLAY", fontObject)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("MIDDLE")
	text:SetWordWrap(false)
	return text
end

local function CreateSeparator(card, anchor, offset)
	local separator = card:CreateTexture(nil, "ARTWORK")
	separator:SetHeight(1)
	separator:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -offset)
	separator:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)
	separator:SetColorTexture(1, 1, 1, 0.1)
	return separator
end

local function CreateArrow(card, parent, symbol, delta)
	local arrow = CreateFrame("Button", nil, parent)
	arrow:SetSize(12, LINE_HEIGHT)

	local text = CreateText(arrow, "GameFontHighlightSmall")
	text:SetAllPoints()
	text:SetJustifyH("CENTER")
	text:SetText(symbol)
	text:SetTextColor(unpack(COLOR_LINK))

	arrow.text = text
	arrow.card = card
	arrow.delta = delta
	arrow:SetScript("OnEnter", Link_OnEnter)
	arrow:SetScript("OnLeave", Link_OnLeave)
	arrow:SetScript("OnClick", Arrow_OnClick)

	return arrow
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local card = CreateFrame("Frame", nil, frame)
	card:SetSize(CARD_MAX_WIDTH, 1)
	-- ignoreUpdates=true keeps it out of E.frames, so ElvUI's async template
	-- sweep can't wipe the backdrop (see Button.lua)
	card:CreateBackdrop("Transparent", nil, true)

	local accent = card:CreateTexture(nil, "ARTWORK")
	accent:SetHeight(2)
	accent:SetPoint("TOPLEFT", card, "TOPLEFT", 1, -1)
	accent:SetPoint("TOPRIGHT", card, "TOPRIGHT", -1, -1)
	accent:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 0.8)

	local title = CreateText(card, "GameFontHighlight")
	title:SetHeight(LINE_HEIGHT)
	title:SetPoint("TOPLEFT", card, "TOPLEFT", PADDING, -PADDING)

	-- Anchored to the card, not the title: the title's right edge depends on
	-- the date, so anchoring back to the title would be a circular anchor
	local dateText = CreateText(card, "GameFontHighlightSmall")
	dateText:SetJustifyH("RIGHT")
	dateText:SetHeight(LINE_HEIGHT)
	dateText:SetPoint("TOPRIGHT", card, "TOPRIGHT", -PADDING, -PADDING)
	title:SetPoint("RIGHT", dateText, "LEFT", -SPACING, 0)

	local titleSeparator = CreateSeparator(card, title, SPACING)

	local lines = {}
	for i = 1, MAX_LINES do
		local line = CreateFrame("Frame", nil, card)
		line:SetHeight(LINE_HEIGHT)
		line:SetPoint("TOPLEFT", titleSeparator, "BOTTOMLEFT", 0, -(SPACING + (i - 1) * LINE_HEIGHT))
		line:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)
		line:EnableMouse(true)
		line:SetScript("OnEnter", Line_OnEnter)
		line:SetScript("OnLeave", Line_OnLeave)

		local text = CreateText(line, "GameFontHighlightSmall")
		text:SetAllPoints()
		line.text = text

		lines[i] = line
	end

	-- Footer: section counts on the left, changelog link on the right
	local footer = CreateFrame("Frame", nil, card)
	footer:SetHeight(LINE_HEIGHT)

	local link = CreateFrame("Button", nil, footer)
	link:SetPoint("TOPRIGHT")
	link:SetPoint("BOTTOMRIGHT")
	local linkText = CreateText(link, "GameFontHighlightSmall")
	linkText:SetPoint("RIGHT")
	linkText:SetText(L["Full Changelog"] .. " >")
	linkText:SetTextColor(unpack(COLOR_LINK))
	link.text = linkText
	link:SetScript("OnEnter", Link_OnEnter)
	link:SetScript("OnLeave", Link_OnLeave)
	link:SetScript("OnClick", Link_OnClick)

	local summary = CreateText(footer, "GameFontHighlightSmall")
	summary:SetPoint("TOPLEFT")
	summary:SetPoint("BOTTOMLEFT")
	summary:SetPoint("RIGHT", link, "LEFT", -SPACING, 0)

	local footerSeparator = CreateSeparator(card, footer, SPACING)

	-- Tips: title with prev/next arrows and counter, two lines of tip text below
	local tipHeader = CreateFrame("Frame", nil, card)
	tipHeader:SetHeight(LINE_HEIGHT)
	tipHeader:SetPoint("TOPLEFT", footerSeparator, "BOTTOMLEFT", 0, -SPACING)
	tipHeader:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)

	local tipNext = CreateArrow(card, tipHeader, ">", 1)
	tipNext:SetPoint("RIGHT", tipHeader, "RIGHT")

	local tipCounter = CreateText(tipHeader, "GameFontHighlightSmall")
	tipCounter:SetPoint("RIGHT", tipNext, "LEFT", -2, 0)

	local tipPrev = CreateArrow(card, tipHeader, "<", -1)
	tipPrev:SetPoint("RIGHT", tipCounter, "LEFT", -2, 0)

	local tipTitle = CreateText(tipHeader, "GameFontHighlight")
	tipTitle:SetPoint("TOPLEFT")
	tipTitle:SetPoint("BOTTOMLEFT")
	tipTitle:SetPoint("RIGHT", tipPrev, "LEFT", -SPACING, 0)
	tipTitle:SetText(tipIcon .. " " .. L["Did you know?"])

	local tipButton = CreateFrame("Button", nil, card)
	tipButton:SetHeight(TIP_TEXT_HEIGHT)
	tipButton:SetPoint("TOPLEFT", tipHeader, "BOTTOMLEFT", 0, -2)
	tipButton:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)
	tipButton:SetScript("OnEnter", Tip_OnEnter)
	tipButton:SetScript("OnLeave", Tip_OnLeave)
	tipButton:SetScript("OnClick", Tip_OnClick)

	local tipText = tipButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	tipText:SetAllPoints()
	tipText:SetJustifyH("LEFT")
	tipText:SetJustifyV("TOP")
	tipText:SetWordWrap(true)
	tipText:SetMaxLines(2)
	tipButton.text = tipText

	local tipFadeOut = tipButton:CreateAnimationGroup()
	tipFadeOut:SetToFinalAlpha(true)
	tipFadeOut.card = card
	tipFadeOut:SetScript("OnFinished", TipFadeOut_OnFinished)
	local fadeOutAlpha = tipFadeOut:CreateAnimation("Alpha")
	fadeOutAlpha:SetFromAlpha(1)
	fadeOutAlpha:SetToAlpha(0)
	fadeOutAlpha:SetDuration(TIP_FADE_DURATION)

	local tipFadeIn = tipButton:CreateAnimationGroup()
	tipFadeIn:SetToFinalAlpha(true)
	local fadeInAlpha = tipFadeIn:CreateAnimation("Alpha")
	fadeInAlpha:SetFromAlpha(0)
	fadeInAlpha:SetToAlpha(1)
	fadeInAlpha:SetDuration(TIP_FADE_DURATION)

	local tipSeparator = CreateSeparator(card, tipButton, SPACING)

	local status = CreateText(card, "GameFontHighlightSmall")
	status:SetHeight(LINE_HEIGHT)
	status:SetPoint("TOPLEFT", tipSeparator, "BOTTOMLEFT", 0, -SPACING)
	status:SetPoint("RIGHT", card, "RIGHT", -PADDING, 0)

	card.title = title
	card.date = dateText
	card.link = link
	card.lines = lines
	card.footer = footer
	card.summary = summary
	card.tipCounter = tipCounter
	card.tipButton = tipButton
	card.tipFadeOut = tipFadeOut
	card.tipFadeIn = tipFadeIn
	card.tipElapsed = 0
	card.status = status

	-- Only runs while the card is shown, so the rotation stops with the options
	card:SetScript("OnUpdate", Card_OnUpdate)

	local widget = {
		frame = frame,
		card = card,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	link.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)

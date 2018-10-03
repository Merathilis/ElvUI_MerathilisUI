local MER, E, L, V, P, G = unpack(select(2, ...))
local MB = MER:NewModule("MicroBar", "AceTimer-3.0", "AceEvent-3.0")
local MERS = MER:GetModule("muiSkins")

--Cache global variables
--Lua functions
local date = date
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local BNGetNumFriends = BNGetNumFriends
local GetGuildRosterInfo = GetGuildRosterInfo
local GetNumFriends = GetNumFriends
local GetNumGuildMembers = GetNumGuildMembers
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local LoadAddOn = LoadAddOn
local PlaySound = PlaySound
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local C_GarrisonIsPlayerInGarrison = C_Garrison.IsPlayerInGarrison

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local microBar

local DELAY = 5
local elapsed = DELAY - 5

local function OnHover(button)
	local buttonHighlight = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\highlight2"

	if button.tex then
		button.tex:SetVertexColor(unpack(E["media"].rgbvaluecolor))

		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		button.highlight:SetPoint("TOPLEFT", button.tex, "TOPLEFT", -4, 1)
		button.highlight:SetPoint("BOTTOMRIGHT", button.tex, "BOTTOMRIGHT", 4, -1)
		button.highlight:SetVertexColor(unpack(E["media"].rgbvaluecolor))
		button.highlight:SetTexture(buttonHighlight)
		button.highlight:SetBlendMode("ADD")
	end
end

local function OnLeave(button)
	if button.tex then
		button.tex:SetVertexColor(.6, .6, .6)
		button.highlight:Hide()
	end
end

function MB:OnClick(btn)
	if InCombatLockdown() then return end
	if btn == "LeftButton" then
		if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
		Calendar_Toggle()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
end

function MB:CreateMicroBar()
	microBar = CreateFrame("Frame", MER.Title.."MicroBar", E.UIParent)
	microBar:SetFrameStrata("HIGH")
	microBar:EnableMouse(true)
	microBar:SetSize(400, 26)
	microBar:SetScale(MB.db.scale or 1)
	microBar:Point("TOP", E.UIParent, "TOP", 0, -24)
	microBar:SetTemplate("Transparent")
	microBar:Styling()
	E.FrameLocks[microBar] = true

	local IconPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icons\\"

	--Character
	local charButton = CreateFrame("Button", nil, microBar)
	charButton:SetPoint("LEFT", microBar, 2, 0)
	charButton:SetSize(32, 32)
	charButton:SetFrameLevel(6)

	charButton.tex = charButton:CreateTexture(nil, "OVERLAY")
	charButton.tex:SetPoint("BOTTOMLEFT")
	charButton.tex:SetPoint("BOTTOMRIGHT")
	charButton.tex:SetSize(32, 32)
	charButton.tex:SetTexture(IconPath.."Character")
	charButton.tex:SetVertexColor(.6, .6, .6)
	charButton.tex:SetBlendMode("ADD")

	charButton.text = MER:CreateText(charButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		charButton.text:SetPoint("BOTTOM", charButton, 2, -15)
	else
		charButton.text:SetPoint("TOP", charButton, 2, 15)
	end
	charButton.text:SetText(CHARACTER_BUTTON)
	charButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	charButton:SetScript("OnEnter", function(self) OnHover(self) end)
	charButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	charButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleCharacter"]("PaperDollFrame") end)

	--Friends
	local friendsButton = CreateFrame("Button", nil, microBar)
	friendsButton:SetPoint("LEFT", charButton, "RIGHT", 2, 0)
	friendsButton:SetSize(32, 32)
	friendsButton:SetFrameLevel(6)

	friendsButton.tex = friendsButton:CreateTexture(nil, "OVERLAY")
	friendsButton.tex:SetPoint("BOTTOMLEFT")
	friendsButton.tex:SetPoint("BOTTOMRIGHT")
	friendsButton.tex:SetSize(32, 32)
	friendsButton.tex:SetTexture(IconPath.."Friends")
	friendsButton.tex:SetVertexColor(.6, .6, .6)
	friendsButton.tex:SetBlendMode("ADD")

	friendsButton.text = MER:CreateText(friendsButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		friendsButton.text:SetPoint("BOTTOM", friendsButton, 2, -15)
	else
		friendsButton.text:SetPoint("TOP", friendsButton, 2, 15)
	end
	friendsButton.text:SetText(SOCIAL_BUTTON)
	friendsButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	local function UpdateFriends()
		MB.db = E.db.mui.microBar
		local friendsTotal, friendsOnline = GetNumFriends()
		local bnTotal, bnOnline = BNGetNumFriends()
		local totalOnline = friendsOnline + bnOnline

		if MB.db.text.friends then
			if (bnOnline > 0) or (friendsOnline > 0) then
				if bnOnline > 0 then
					friendsButton.online:SetText(totalOnline)
				else
					friendsButton.online:SetText("0")
				end
			end
		end
	end

	friendsButton.online = friendsButton:CreateFontString(nil, "OVERLAY")
	friendsButton.online:FontTemplate(nil, 10, "OUTLINE")
	friendsButton.online:SetPoint("BOTTOMRIGHT", friendsButton, 0, 5)
	friendsButton.online:SetText("")
	friendsButton.online:SetTextColor(unpack(E["media"].rgbvaluecolor))

	friendsButton:SetScript("OnEnter", function(self) OnHover(self) end)
	friendsButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	friendsButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleFriendsFrame"]() end)
	friendsButton:SetScript("OnUpdate", function (self, elapse)
		elapsed = elapsed + elapse

		if elapsed >= DELAY then
			elapsed = 0
			UpdateFriends()
		end
	end)

	--Guild
	local guildButton = CreateFrame("Button", nil, microBar)
	guildButton:SetPoint("LEFT", friendsButton, "RIGHT", 2, 0)
	guildButton:SetSize(32, 32)
	guildButton:SetFrameLevel(6)

	guildButton.tex = guildButton:CreateTexture(nil, "OVERLAY")
	guildButton.tex:SetPoint("BOTTOMLEFT")
	guildButton.tex:SetPoint("BOTTOMRIGHT")
	guildButton.tex:SetSize(32, 32)
	guildButton.tex:SetTexture(IconPath.."Guild")
	guildButton.tex:SetVertexColor(.6, .6, .6)
	guildButton.tex:SetBlendMode("ADD")

	guildButton.text = MER:CreateText(guildButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		guildButton.text:SetPoint("BOTTOM", guildButton, 2, -15)
	else
		guildButton.text:SetPoint("TOP", guildButton, 2, 15)
	end
	guildButton.text:SetText(GUILD)
	guildButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	local function UpdateGuild()
		MB.db = E.db.mui.microBar
		if IsInGuild() then
			local guildTotal, online = GetNumGuildMembers()
			for i = 1, guildTotal do
				local _, _, _, _, _, _, _, _, connected, _, _, _, _, isMobile = GetGuildRosterInfo(i)
				if isMobile then
					online = online + 1
				end
			end

			if MB.db.text.guild then
				if online > 0 then
					guildButton.online:SetText(online)
				else
					guildButton.online:SetText("0")
				end
			end
		end
	end

	guildButton.online = guildButton:CreateFontString(nil, "OVERLAY")
	guildButton.online:FontTemplate(nil, 10, "OUTLINE")
	guildButton.online:SetPoint("BOTTOMRIGHT", guildButton, 0, 5)
	guildButton.online:SetText("")
	guildButton.online:SetTextColor(unpack(E["media"].rgbvaluecolor))

	guildButton:SetScript("OnEnter", function(self) OnHover(self) end)
	guildButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	guildButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleGuildFrame"]() end)
	guildButton:SetScript("OnUpdate", function (self, elapse)
		elapsed = elapsed + elapse

		if elapsed >= DELAY then
			elapsed = 0
			UpdateGuild()
		end
	end)

	--Achievements
	local achieveButton = CreateFrame("Button", nil, microBar)
	achieveButton:SetPoint("LEFT", guildButton, "RIGHT", 2, 0)
	achieveButton:SetSize(32, 32)
	achieveButton:SetFrameLevel(6)

	achieveButton.tex = achieveButton:CreateTexture(nil, "OVERLAY")
	achieveButton.tex:SetPoint("BOTTOMLEFT")
	achieveButton.tex:SetPoint("BOTTOMRIGHT")
	achieveButton.tex:SetSize(32, 32)
	achieveButton.tex:SetTexture(IconPath.."Achievement")
	achieveButton.tex:SetVertexColor(.6, .6, .6)
	achieveButton.tex:SetBlendMode("ADD")

	achieveButton.text = MER:CreateText(achieveButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		achieveButton.text:SetPoint("BOTTOM", achieveButton, 2, -15)
	else
		achieveButton.text:SetPoint("TOP", achieveButton, 2, 15)
	end
	achieveButton.text:SetText(ACHIEVEMENT_BUTTON)
	achieveButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	achieveButton:SetScript("OnEnter", function(self) OnHover(self) end)
	achieveButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	achieveButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleAchievementFrame"]() end)

	--EncounterJournal
	local encounterButton = CreateFrame("Button", nil, microBar)
	encounterButton:SetPoint("LEFT", achieveButton, "RIGHT", 2, 0)
	encounterButton:SetSize(32, 32)
	encounterButton:SetFrameLevel(6)

	encounterButton.tex = encounterButton:CreateTexture(nil, "OVERLAY")
	encounterButton.tex:SetPoint("BOTTOMLEFT")
	encounterButton.tex:SetPoint("BOTTOMRIGHT")
	encounterButton.tex:SetSize(32, 32)
	encounterButton.tex:SetTexture(IconPath.."EJ")
	encounterButton.tex:SetVertexColor(.6, .6, .6)
	encounterButton.tex:SetBlendMode("ADD")

	encounterButton.text = MER:CreateText(encounterButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		encounterButton.text:SetPoint("BOTTOM", encounterButton, 2, -15)
	else
		encounterButton.text:SetPoint("TOP", encounterButton, 2, 15)
	end
	encounterButton.text:SetText(ENCOUNTER_JOURNAL)
	encounterButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	encounterButton:SetScript("OnEnter", function(self) OnHover(self) end)
	encounterButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	encounterButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleEncounterJournal"]() end)

	-- Time
	local timeButton = CreateFrame("Button", nil, microBar)
	timeButton:SetPoint("LEFT", encounterButton, "RIGHT", 18, 0)
	timeButton:SetSize(32, 32)
	timeButton:SetFrameLevel(6)

	timeButton.text = MER:CreateText(timeButton, "OVERLAY", 16, "OUTLINE", "CENTER")
	timeButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
	timeButton.text:SetPoint("CENTER", 0, 0)

	timeButton.tex = timeButton:CreateTexture(nil, "OVERLAY") --dummy texture
	timeButton.tex:SetPoint("BOTTOMLEFT")
	timeButton.tex:SetPoint("BOTTOMRIGHT")
	timeButton.tex:SetSize(32, 32)
	timeButton.tex:SetBlendMode("ADD")

	local timer = timeButton:CreateAnimationGroup()

	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(1)

	timer:SetScript("OnFinished", function(self, requested)
		local euTime = date("%H|cFF00c0fa:|r%M")
		local ukTime = date("%I|cFF00c0fa:|r%M")

		if E.db.datatexts.time24 == true then
			timeButton.text:SetText(euTime)
		else
			timeButton.text:SetText(ukTime)
		end
		self:Play()
	end)
	timer:Play()

	timeButton:SetScript("OnEnter", function(self) OnHover(self) end)
	timeButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	timeButton:SetScript("OnMouseUp", MB.OnClick)

	--Pet/Mounts
	local petButton = CreateFrame("Button", nil, microBar)
	petButton:SetPoint("LEFT", timeButton, "RIGHT", 12, 0)
	petButton:SetSize(32, 32)
	petButton:SetFrameLevel(6)

	petButton.tex = petButton:CreateTexture(nil, "OVERLAY")
	petButton.tex:SetPoint("BOTTOMLEFT")
	petButton.tex:SetPoint("BOTTOMRIGHT")
	petButton.tex:SetSize(32, 32)
	petButton.tex:SetTexture(IconPath.."Pet")
	petButton.tex:SetVertexColor(.6, .6, .6)
	petButton.tex:SetBlendMode("ADD")

	petButton.text = MER:CreateText(petButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		petButton.text:SetPoint("BOTTOM", petButton, 2, -15)
	else
		petButton.text:SetPoint("TOP", petButton, 2, 15)
	end
	petButton.text:SetText(MOUNTS_AND_PETS)
	petButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	petButton:SetScript("OnEnter", function(self) OnHover(self) end)
	petButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	petButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleCollectionsJournal"](1)	end)

	--LFR
	local lfrButton = CreateFrame("Button", nil, microBar)
	lfrButton:SetPoint("LEFT", petButton, "RIGHT", 2, 0)
	lfrButton:SetSize(32, 32)
	lfrButton:SetFrameLevel(6)

	lfrButton.tex = lfrButton:CreateTexture(nil, "OVERLAY")
	lfrButton.tex:SetPoint("BOTTOMLEFT")
	lfrButton.tex:SetPoint("BOTTOMRIGHT")
	lfrButton.tex:SetSize(32, 32)
	lfrButton.tex:SetTexture(IconPath.."LFR")
	lfrButton.tex:SetVertexColor(.6, .6, .6)
	lfrButton.tex:SetBlendMode("ADD")

	lfrButton.text = MER:CreateText(lfrButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		lfrButton.text:SetPoint("BOTTOM", lfrButton, 2, -15)
	else
		lfrButton.text:SetPoint("TOP", lfrButton, 2, 15)
	end
	lfrButton.text:SetText(LFG_TITLE)
	lfrButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	lfrButton:SetScript("OnEnter", function(self) OnHover(self) end)
	lfrButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	lfrButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["PVEFrame_ToggleFrame"]() end)

	--Spellbook
	local spellBookButton = CreateFrame("Button", nil, microBar)
	spellBookButton:SetPoint("LEFT", lfrButton, "RIGHT", 2, 0)
	spellBookButton:SetSize(32, 32)
	spellBookButton:SetFrameLevel(6)

	spellBookButton.tex = spellBookButton:CreateTexture(nil, "OVERLAY")
	spellBookButton.tex:SetPoint("BOTTOMLEFT")
	spellBookButton.tex:SetPoint("BOTTOMRIGHT")
	spellBookButton.tex:SetSize(32, 32)
	spellBookButton.tex:SetTexture(IconPath.."Spellbook")
	spellBookButton.tex:SetVertexColor(.6, .6, .6)
	spellBookButton.tex:SetBlendMode("ADD")

	spellBookButton.text = MER:CreateText(spellBookButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		spellBookButton.text:SetPoint("BOTTOM", spellBookButton, 2, -15)
	else
		spellBookButton.text:SetPoint("TOP", spellBookButton, 2, 15)
	end
	spellBookButton.text:SetText(SPELLBOOK_ABILITIES_BUTTON)
	spellBookButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	spellBookButton:SetScript("OnEnter", function(self) OnHover(self) end)
	spellBookButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	spellBookButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleSpellBook"](BOOKTYPE_SPELL) end)

	--Specc Button
	local speccButton = CreateFrame("Button", nil, microBar)
	speccButton:SetPoint("LEFT", spellBookButton, "RIGHT", 2, 0)
	speccButton:SetSize(32, 32)
	speccButton:SetFrameLevel(6)

	speccButton.tex = speccButton:CreateTexture(nil, "OVERLAY")
	speccButton.tex:SetPoint("BOTTOMLEFT")
	speccButton.tex:SetPoint("BOTTOMRIGHT")
	speccButton.tex:SetSize(32, 32)
	speccButton.tex:SetTexture(IconPath.."Specc")
	speccButton.tex:SetVertexColor(.6, .6, .6)
	speccButton.tex:SetBlendMode("ADD")

	speccButton.text = MER:CreateText(speccButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		speccButton.text:SetPoint("BOTTOM", speccButton, 2, -15)
	else
		speccButton.text:SetPoint("TOP", speccButton, 2, 15)
	end
	speccButton.text:SetText(TALENTS_BUTTON)
	speccButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	speccButton:SetScript("OnEnter", function(self) OnHover(self) end)
	speccButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	speccButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end _G["ToggleTalentFrame"]() end)

	--Shop
	local shopButton = CreateFrame("Button", nil, microBar)
	shopButton:SetPoint("LEFT", speccButton, "RIGHT", 2, 0)
	shopButton:SetSize(32, 32)
	shopButton:SetFrameLevel(6)

	shopButton.tex = shopButton:CreateTexture(nil, "OVERLAY")
	shopButton.tex:SetPoint("BOTTOMLEFT")
	shopButton.tex:SetPoint("BOTTOMRIGHT")
	shopButton.tex:SetSize(32, 32)
	shopButton.tex:SetTexture(IconPath.."Store")
	shopButton.tex:SetVertexColor(.6, .6, .6)
	shopButton.tex:SetBlendMode("ADD")

	shopButton.text = MER:CreateText(shopButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.position == "BOTTOM" then
		shopButton.text:SetPoint("BOTTOM", shopButton, 2, -15)
	else
		shopButton.text:SetPoint("TOP", shopButton, 2, 15)
	end
	shopButton.text:SetText(BLIZZARD_STORE)
	shopButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	shopButton:SetScript("OnEnter", function(self) OnHover(self) end)
	shopButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	shopButton:SetScript("OnClick", function(self) if InCombatLockdown() then return end StoreMicroButton:Click() end)

	E:CreateMover(microBar, "MER_MicroBarMover", L["MicroBarMover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI')
end

function MB:Toggle()
	if MB.db.enable then
		microBar:Show()
		E:EnableMover(microBar.mover:GetName())
	else
		microBar:Hide()
		E:DisableMover(microBar.mover:GetName())
	end
	MB:UNIT_AURA(nil, "player")
end

function MB:PLAYER_REGEN_DISABLED()
	if MB.db.hideInCombat == true then microBar:SetAlpha(0) end
end

function MB:PLAYER_REGEN_ENABLED()
	if MB.db.enable then microBar:SetAlpha(1) end
end

function MB:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	if MB.db.enable and MB.db.hideInOrderHall then
		local inOrderHall = C_GarrisonIsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		if inOrderHall then
			microBar:SetAlpha(0)
		else
			microBar:SetAlpha(1)
		end
	end
end

function MB:Initialize()
	MB.db = E.db.mui.microBar
	if MB.db.enable ~= true then return end

	MER:RegisterDB(self, "microBar")

	self:CreateMicroBar()
	self:Toggle()

	function MB:ForUpdateAll()
		MB.db = E.db.mui.microBar

		self:Toggle()
	end

	self:ForUpdateAll()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("UNIT_AURA")
end

local function InitializeCallback()
	MB:Initialize()
end

MER:RegisterModule(MB:GetName(), InitializeCallback)
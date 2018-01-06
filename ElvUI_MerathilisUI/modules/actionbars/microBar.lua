local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:GetModule("mUIActionbars")
local MERS = E:GetModule("muiSkins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function OnHover(button)
	buttonHighlight = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\highlight2"

	if button.tex then
		button.tex:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		button.highlight:SetPoint("TOPLEFT", button.tex, "TOPLEFT", -4, 1)
		button.highlight:SetPoint("BOTTOMRIGHT", button.tex, "BOTTOMRIGHT", 4, -1)
		button.highlight:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .8)
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

function MAB:CreateMicroBar()
	if E.db.mui.actionbars.microBar ~= true then return end

	local microBar = CreateFrame("Frame", MER.Title.."MicroBar", E.UIParent)
	microBar:SetFrameLevel(6)
	microBar:SetSize(400, 26)
	microBar:Point("TOP", E.UIParent, "TOP", 0, -5)
	microBar:SetTemplate("Transparent")
	microBar:Styling()

	E:CreateMover(microBar, "MicroBarMover", L["MicroBarMover"], true, nil)

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
	charButton.text:SetPoint("BOTTOM", charButton, 2, -15)
	charButton.text:SetText(CHARACTER_BUTTON)
	charButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	charButton:SetScript("OnEnter", function(self) OnHover(self) end)
	charButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	charButton:SetScript("OnClick", function(self) ToggleCharacter("PaperDollFrame") end)

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
	friendsButton.text:SetPoint("BOTTOM", friendsButton, 2, -15)
	friendsButton.text:SetText(SOCIAL_BUTTON)
	friendsButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	friendsButton:SetScript("OnEnter", function(self) OnHover(self) end)
	friendsButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	friendsButton:SetScript("OnClick", function(self) ToggleFriendsFrame() end)

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
	guildButton.text:SetPoint("BOTTOM", guildButton, 2, -15)
	guildButton.text:SetText(GUILD)
	guildButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	guildButton:SetScript("OnEnter", function(self) OnHover(self) end)
	guildButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	guildButton:SetScript("OnClick", function(self) ToggleGuildFrame() end)

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
	achieveButton.text:SetPoint("BOTTOM", achieveButton, 2, -15)
	achieveButton.text:SetText(ACHIEVEMENT_BUTTON)
	achieveButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	achieveButton:SetScript("OnEnter", function(self) OnHover(self) end)
	achieveButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	achieveButton:SetScript("OnClick", function(self) ToggleAchievementFrame() end)

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
	encounterButton.text:SetPoint("BOTTOM", encounterButton, 2, -15)
	encounterButton.text:SetText(ENCOUNTER_JOURNAL)
	encounterButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	encounterButton:SetScript("OnEnter", function(self) OnHover(self) end)
	encounterButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	encounterButton:SetScript("OnClick", function(self) ToggleEncounterJournal() end)

	--Option
	local optionButton = CreateFrame("Button", nil, microBar)
	optionButton:SetPoint("LEFT", encounterButton, "RIGHT", 18, 0)
	optionButton:SetSize(32, 32)
	optionButton:SetFrameLevel(6)

	optionButton.text = optionButton:CreateFontString(nil, 'OVERLAY')
	optionButton.text:FontTemplate(nil, 11, "OUTLINE")
	optionButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	optionButton.text:SetText(MER.Title)
	optionButton.text:SetPoint("CENTER", 1, 0)
	optionButton.text:SetJustifyH('CENTER')

	optionButton.tex = optionButton:CreateTexture(nil, "OVERLAY") --dummy texture
	optionButton.tex:SetPoint("BOTTOMLEFT")
	optionButton.tex:SetPoint("BOTTOMRIGHT")
	optionButton.tex:SetSize(32, 32)
	optionButton.tex:SetBlendMode("ADD")

	optionButton.version = MER:CreateText(optionButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	optionButton.version:SetPoint("BOTTOM", optionButton, 2, -15)
	optionButton.version:SetText(MER.Version)
	optionButton.version:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	optionButton:SetScript("OnEnter", function(self) OnHover(self) end)
	optionButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	optionButton:SetScript("OnClick", function(self) E:ToggleConfig() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end)

	--Pet/Mounts
	local petButton = CreateFrame("Button", nil, microBar)
	petButton:SetPoint("LEFT", optionButton, "RIGHT", 10, 0)
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
	petButton.text:SetPoint("BOTTOM", petButton, 2, -15)
	petButton.text:SetText(MOUNTS_AND_PETS)
	petButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	petButton:SetScript("OnEnter", function(self) OnHover(self) end)
	petButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	petButton:SetScript("OnClick", function(self) ToggleCollectionsJournal(1) end)

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
	lfrButton.text:SetPoint("BOTTOM", lfrButton, 2, -15)
	lfrButton.text:SetText(LFG_TITLE)
	lfrButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	lfrButton:SetScript("OnEnter", function(self) OnHover(self) end)
	lfrButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	lfrButton:SetScript("OnClick", function(self) PVEFrame_ToggleFrame() end)

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
	spellBookButton.text:SetPoint("BOTTOM", spellBookButton, 2, -15)
	spellBookButton.text:SetText(SPELLBOOK_ABILITIES_BUTTON)
	spellBookButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	spellBookButton:SetScript("OnEnter", function(self) OnHover(self) end)
	spellBookButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	spellBookButton:SetScript("OnClick", function(self) ToggleSpellBook(BOOKTYPE_SPELL) end)

	--Shop
	local shopButton = CreateFrame("Button", nil, microBar)
	shopButton:SetPoint("LEFT", spellBookButton, "RIGHT", 2, 0)
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
	shopButton.text:SetPoint("BOTTOM", shopButton, 2, -15)
	shopButton.text:SetText(BLIZZARD_STORE)
	shopButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	shopButton:SetScript("OnEnter", function(self) OnHover(self) end)
	shopButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	shopButton:SetScript("OnClick", function(self) StoreMicroButton:Click() end)

	--Quest
	local questButton = CreateFrame("Button", nil, microBar)
	questButton:SetPoint("LEFT", shopButton, "RIGHT", 2, 0)
	questButton:SetSize(32, 32)
	questButton:SetFrameLevel(6)

	questButton.tex = questButton:CreateTexture(nil, "OVERLAY")
	questButton.tex:SetPoint("BOTTOMLEFT")
	questButton.tex:SetPoint("BOTTOMRIGHT")
	questButton.tex:SetSize(32, 32)
	questButton.tex:SetTexture(IconPath.."Quest")
	questButton.tex:SetVertexColor(.6, .6, .6)
	questButton.tex:SetBlendMode("ADD")

	questButton.text = MER:CreateText(questButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	questButton.text:SetPoint("BOTTOM", questButton, 2, -15)
	questButton.text:SetText(QUESTLOG_BUTTON)
	questButton.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	questButton:SetScript("OnEnter", function(self) OnHover(self) end)
	questButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	questButton:SetScript("OnClick", function(self) ToggleQuestLog() end)
end
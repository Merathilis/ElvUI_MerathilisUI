local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_MicroBar')
local S = MER:GetModule('MER_Skins')
local DT = E:GetModule('DataTexts')

-- Credits: fang2hou - ElvUI_Windtools (and me for the initial idea ^^)
local _G = _G
local date = date
local floor = floor
local format = format
local gsub = gsub
local ipairs = ipairs
local max = max
local min = min
local mod = mod
local pairs = pairs
local select = select
local strfind = strfind
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack

local BNGetNumFriends = BNGetNumFriends
local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local CreateFrame = CreateFrame
local CreateFromMixins = CreateFromMixins
local GetGameTime = GetGameTime
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetItemIcon = GetItemIcon
local GetNumGuildMembers = GetNumGuildMembers
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsModifierKeyDown = IsModifierKeyDown
local ItemMixin = ItemMixin
local PlaySound = PlaySound
local RegisterStateDriver = RegisterStateDriver
local Screenshot = Screenshot
local ShowUIPanel = ShowUIPanel
local ToggleAllBags = ToggleAllBags
local ToggleCalendar = ToggleCalendar
local ToggleCharacter = ToggleCharacter
local ToggleFrame = ToggleFrame
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleGuildFrame = ToggleGuildFrame
local ToggleSpellBook = ToggleSpellBook
local ToggleTimeManager = ToggleTimeManager
local UnregisterStateDriver = UnregisterStateDriver

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_SetCVar = C_CVar.SetCVar
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_Garrison_GetCompleteMissions = C_Garrison and C_Garrison.GetCompleteMissions
local C_Timer_After = C_Timer.After
local C_Timer_NewTicker = C_Timer.NewTicker

local FollowerType_8_0 = Enum.GarrisonFollowerType.FollowerType_8_0
local FollowerType_9_0 = Enum.GarrisonFollowerType.FollowerType_9_0

local NUM_PANEL_BUTTONS = 7
local IconString = '|T%s:16:18:0:0:64:64:4:60:7:57'
local LeftButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"
local RightButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t"
local ScrollButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t"

local friendOnline = gsub(_G.ERR_FRIEND_ONLINE_SS, "\124Hplayer:%%s\124h%[%%s%]\124h", "")
local friendOffline = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "")

local Heartstones = {
	6948,
}

if E.Retail then
	tinsert(Heartstones, 64488)
	tinsert(Heartstones, 93672)
	tinsert(Heartstones, 110560)
	tinsert(Heartstones, 140192)
	tinsert(Heartstones, 141605)
	tinsert(Heartstones, 142542)
	tinsert(Heartstones, 162973)
	tinsert(Heartstones, 163045)
	tinsert(Heartstones, 165669)
	tinsert(Heartstones, 165670)
	tinsert(Heartstones, 165802)
	tinsert(Heartstones, 166746)
	tinsert(Heartstones, 166747)
	tinsert(Heartstones, 168907)
	tinsert(Heartstones, 172179)
	tinsert(Heartstones, 48933)
	tinsert(Heartstones, 87215)
	tinsert(Heartstones, 132517)
	tinsert(Heartstones, 132524)
	tinsert(Heartstones, 151652)
	tinsert(Heartstones, 168807)
	tinsert(Heartstones, 168808)
	tinsert(Heartstones, 172924)
	tinsert(Heartstones, 180290)
	tinsert(Heartstones, 182773)
	tinsert(Heartstones, 183716)
	tinsert(Heartstones, 184353)
	tinsert(Heartstones, 188952) --	Dominated Hearthstone
end

local HeartstonesTable

local function AddDoubleLineForItem(itemID, prefix)
	if type(itemID) == "string" then
		itemID = tonumber(itemID)
	end

	prefix = prefix and prefix .. " " or ""

	local name = HeartstonesTable[tostring(itemID)]
	if not name then return end

	local texture = GetItemIcon(itemID)
	local icon = format(IconString .. ":255:255:255|t", texture)
	local startTime, duration = GetItemCooldown(itemID)
	local cooldownTime = startTime + duration - GetTime()
	local canUse = cooldownTime <= 0
	local cooldownTimeString
	if not canUse then
		local min = floor(cooldownTime / 60)
		local sec = floor(mod(cooldownTime, 60))
		cooldownTimeString = format("%02d:%02d", min, sec)
	end

	if itemID == 180817 then
		local charge = GetItemCount(itemID, nil, true)
		name = name .. format(" (%d)", charge)
	end

	DT.tooltip:AddDoubleLine(prefix .. icon .. " " .. name, canUse and L["Ready"] or cooldownTimeString, 1, 1, 1, canUse and 0 or 1, canUse and 1 or 0, 0)
end

local VirtualDTEvent = {
	Friends = nil,
	Guild = "GUILD_ROSTER_UPDATE"
}

local VirtualDT = {
	Friends = {
		text = {
			SetFormattedText = E.noop
		}
	},
	Guild = {
		text = {
			SetFormattedText = E.noop,
			SetText = E.noop
		},
		GetScript = function()
			return E.noop
		end
	}
}

local ButtonTypes = {
	ACHIEVEMENTS = {
		name = _G.ACHIEVEMENT_BUTTON,
		icon = MER.Media.Icons.barAchievements,
		macro = {
			LeftButton = _G.SLASH_ACHIEVEMENTUI1
		},
		tooltips = {
			_G.ACHIEVEMENT_BUTTON
		}
	},
	BAGS = {
		name = L["Bags"],
		icon = MER.Media.Icons.barBags,
		click = {
			LeftButton = ToggleAllBags
		},
		tooltips = "Bags"
	},
	BLIZZARD_SHOP = {
		name = _G.BLIZZARD_STORE,
		icon = MER.Media.Icons.barBlizzardShop,
		click = {
			LeftButton = function()
				_G.StoreMicroButton:Click()
			end
		},
		tooltips = {
			_G.BLIZZARD_STORE
		},
	},
	CHARACTER = {
		name = _G.CHARACTER_BUTTON,
		icon = MER.Media.Icons.barCharacter,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleCharacter("PaperDollFrame")
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end
		},
		tooltips = {
			_G.CHARACTER_BUTTON
		},
	},
	COLLECTIONS = {
		name = L["Collections"],
		icon = MER.Media.Icons.barCollections,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab1",
			RightButton = "/run CollectionsJournal_LoadUI()\n/click MountJournalSummonRandomFavoriteButton"
		},
		tooltips = {
			L["Collections"], "\n", LeftButtonIcon .. " " .. L["Show Collections"], RightButtonIcon .. " " .. L["Random Favorite Mount"]
		},
	},
	ENCOUNTER_JOURNAL = {
		name = _G.ENCOUNTER_JOURNAL,
		icon = MER.Media.Icons.barEncounterJournal,
		macro = {
			LeftButton = "/click EJMicroButton",
			RightButton = "/run WeeklyRewards_LoadUI(); WeeklyRewardsFrame:Show()"
		},
		tooltips = {
			LeftButtonIcon .. " " .. L["Encounter Journal"],
			RightButtonIcon .. " " .. L["Weekly Rewards"],
		},
	},
	FRIENDS = {
		name = _G.SOCIAL_BUTTON,
		icon = MER.Media.Icons.barFriends,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleFriendsFrame(1)
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end
		},
		additionalText = function()
			local friendsOnline = C_FriendList_GetNumFriends()
			local _, bnOnline = BNGetNumFriends()
			local totalOnline = friendsOnline + bnOnline
			return totalOnline
		end,
		tooltips = "Friends",
		events = {
			"BN_FRIEND_ACCOUNT_ONLINE",
			"BN_FRIEND_ACCOUNT_OFFLINE",
			"BN_FRIEND_INFO_CHANGED",
			"FRIENDLIST_UPDATE",
			"CHAT_MSG_SYSTEM"
		},
		eventHandler = function(button, event, message)
			if event == "CHAT_MSG_SYSTEM" then
				if not (strfind(message, friendOnline) or strfind(message, friendOffline)) then
					return
				end
			end
			button.additionalText:SetFormattedText(button.additionalTextFormat, button.additionalTextFunc())
		end,
		notification = true,
	},
	GAMEMENU = {
		name = L["Game Menu"],
		icon = MER.Media.Icons.barGameMenu,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					-- Open game menu | From ElvUI
					if not _G.GameMenuFrame:IsShown() then
						if _G.VideoOptionsFrame:IsShown() then
							_G.VideoOptionsFrameCancel:Click()
						elseif _G.AudioOptionsFrame:IsShown() then
							_G.AudioOptionsFrameCancel:Click()
						elseif _G.InterfaceOptionsFrame:IsShown() then
							_G.InterfaceOptionsFrameCancel:Click()
						end
						CloseMenus()
						CloseAllWindows()
						PlaySound(850) --IG_MAINMENU_OPEN
						ShowUIPanel(_G.GameMenuFrame)
					else
						PlaySound(854) --IG_MAINMENU_QUIT
						HideUIPanel(_G.GameMenuFrame)
					end
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end
		},
		tooltips = {
			L["Game Menu"]
		},
	},
	GROUP_FINDER = {
		name = _G.LFG_TITLE,
		icon = MER.Media.Icons.barGroupFinder,
		macro = {
			LeftButton = "/click LFDMicroButton"
		},
		tooltips = {
			_G.LFG_TITLE
		},
	},
	GUILD = {
		name = _G.ACHIEVEMENTS_GUILD_TAB,
		icon = MER.Media.Icons.barGuild,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleGuildFrame()
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end
		},
		--macro = {
			--LeftButton = "/click GuildMicroButton",
			--RightButton = "/script if not InCombatLockdown() then if not GuildFrame then GuildFrame_LoadUI() end ToggleFrame(GuildFrame) end"
		--},
		additionalText = function()
			return IsInGuild() and select(2, GetNumGuildMembers()) or ""
		end,
		tooltips = "Guild",
		events = {
			"GUILD_ROSTER_UPDATE",
			"PLAYER_GUILD_UPDATE"
		},
		eventHandler = function(button)
			button.additionalText:SetFormattedText(button.additionalTextFormat, button.additionalTextFunc())
		end
	},
	HOME = {
		name = L["Home"],
		icon = MER.Media.Icons.barHome,
		item = {},
		tooltips = function(button)
			DT.tooltip:ClearLines()
			DT.tooltip:SetText(L["Home"])
			DT.tooltip:AddLine("\n")
			AddDoubleLineForItem(module.db.home.left, LeftButtonIcon)
			AddDoubleLineForItem(module.db.home.right, RightButtonIcon)
			DT.tooltip:Show()

			button.tooltipsUpdateTimer = C_Timer_NewTicker(1, function()
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(L["Home"])
				DT.tooltip:AddLine("\n")
				AddDoubleLineForItem(module.db.home.left, LeftButtonIcon)
				AddDoubleLineForItem(module.db.home.right, RightButtonIcon)
				DT.tooltip:Show()
			end)
		end,
		tooltipsLeave = function(button)
			if button.tooltipsUpdateTimer and button.tooltipsUpdateTimer.Cancel then
				button.tooltipsUpdateTimer:Cancel()
			end
		end
	},
	MISSION_REPORTS = {
		name = _G.GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
		icon = MER.Media.Icons.barMissionReports,
		click = {
			LeftButton = function(button)
				DT.RegisteredDataTexts["Missions"].onClick(button)
			end
		},
		additionalText = function()
			local numMissions = C_Garrison and (#C_Garrison_GetCompleteMissions(FollowerType_9_0) + #C_Garrison_GetCompleteMissions(FollowerType_8_0))
			if numMissions == 0 then
				numMissions = ""
			end
			return numMissions
		end,
		tooltips = "Missions"
	},
	NONE = {
		name = L["None"]
	},
	PET_JOURNAL = {
		name = L["Pet Journal"],
		icon = MER.Media.Icons.barPetJournal,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab2",
			RightButton = "/run CollectionsJournal_LoadUI()\n/click PetJournalSummonRandomFavoritePetButton"
		},
		tooltips = {
			L["Pet Journal"], "\n", LeftButtonIcon .. " " .. L["Show Pet Journal"], RightButtonIcon .. " " .. L["Random Favorite Pet"]
		},
	},
	PROFESSION = {
		name = L["Profession"],
		icon = MER.Media.Icons.barProfession,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleSpellBook(_G.BOOKTYPE_PROFESSION)
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end
		},
		tooltips = {
			L["Profession"]
		},
	},
	SCREENSHOT = {
		name = L["Screenshot"],
		icon = MER.Media.Icons.barScreenShot,
		click = {
			LeftButton = Screenshot,
			RightButton = function()
				C_Timer_After(2, Screenshot)
			end
		},
		tooltips = {
			L["Screenshot"], "\n", LeftButtonIcon .. " " .. L["Screenshot immediately"], RightButtonIcon .. " " .. L["Screenshot after 2 secs"]
		},
	},
	SPELLBOOK = {
		name = _G.SPELLBOOK_ABILITIES_BUTTON,
		icon = MER.Media.Icons.barSpellBook,
		macro = {
			LeftButton = "/click SpellbookMicroButton"
		},
		tooltips = {
			_G.SPELLBOOK_ABILITIES_BUTTON
		},
	},
	TALENTS = {
		name = _G.TALENTS_BUTTON,
		icon = MER.Media.Icons.barTalents,
		macro = {
			LeftButton = "/click TalentMicroButton"
		},
		tooltips = {
			_G.TALENTS_BUTTON
		},
	},
	TOY_BOX = {
		name = L["Toy Box"],
		icon = MER.Media.Icons.barToyBox,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab3"
		},
		tooltips = {
			L["Toy Box"]
		},
	},
	VOLUME = {
		name = L["Volume"],
		icon = MER.Media.Icons.barVolume,
		click = {
			LeftButton = function()
				local vol = C_CVar_GetCVar("Sound_MasterVolume")
				vol = vol and tonumber(vol) or 0
				C_CVar_SetCVar("Sound_MasterVolume", min(vol + 0.1, 1))
			end,
			MiddleButton = function()
				local enabled = tonumber(C_CVar_GetCVar("Sound_EnableAllSound")) == 1
				C_CVar_SetCVar("Sound_EnableAllSound", enabled and 0 or 1)
			end,
			RightButton = function()
				local vol = C_CVar_GetCVar("Sound_MasterVolume")
				vol = vol and tonumber(vol) or 0
				C_CVar_SetCVar("Sound_MasterVolume", max(vol - 0.1, 0))
			end
		},
		tooltips = function(button)
			local vol = C_CVar_GetCVar("Sound_MasterVolume")
			vol = vol and tonumber(vol) or 0
			DT.tooltip:ClearLines()
			DT.tooltip:SetText(L["Volume"] .. format(": %d%%", vol * 100))
			DT.tooltip:AddLine("\n")
			DT.tooltip:AddLine(LeftButtonIcon .. " " .. L["Increase the volume"] .. " (+10%)", 1, 1, 1)
			DT.tooltip:AddLine(RightButtonIcon .. " " .. L["Decrease the volume"] .. " (-10%)", 1, 1, 1)
			DT.tooltip:AddLine(ScrollButtonIcon .. " " .. L["Sound ON/OFF"], 1, 1, 1)
			DT.tooltip:Show()

			button.tooltipsUpdateTimer = C_Timer_NewTicker( 0.3, function()
				local vol = C_CVar_GetCVar("Sound_MasterVolume")
				vol = vol and tonumber(vol) or 0
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(L["Volume"] .. format(": %d%%", vol * 100))
				DT.tooltip:AddLine("\n")
				DT.tooltip:AddLine(LeftButtonIcon .. " " .. L["Increase the volume"] .. " (+10%)", 1, 1, 1)
				DT.tooltip:AddLine(RightButtonIcon .. " " .. L["Decrease the volume"] .. " (-10%)", 1, 1, 1)
				DT.tooltip:AddLine(ScrollButtonIcon .. " " .. L["Sound ON/OFF"], 1, 1, 1)
				DT.tooltip:Show()
			end)
		end,
		tooltipsLeave = function(button)
			if button.tooltipsUpdateTimer and button.tooltipsUpdateTimer.Cancel then
				button.tooltipsUpdateTimer:Cancel()
			end
		end
	},
}

function module:ShowAdvancedTimeTooltip(panel)
	DT.RegisteredDataTexts["Time"].onEnter()
	DT.RegisteredDataTexts["Time"].onLeave()
end

function module:ConstructBar()
	if self.bar then return end

	local bar = CreateFrame("Frame", MER.Title .. "MicroBar", E.UIParent, 'BackdropTemplate')
	bar:SetSize(800, 60)
	bar:SetPoint("TOP", 0, -19)
	bar:SetFrameStrata("LOW")

	bar:SetScript("OnEnter", function(bar)
		if self.db and self.db.mouseOver then
			E:UIFrameFadeIn(bar, self.db.fadeTime, bar:GetAlpha(), 1)
		end
	end)

	bar:SetScript("OnLeave", function(bar)
		if self.db and self.db.mouseOver then
			E:UIFrameFadeOut(bar, self.db.fadeTime, bar:GetAlpha(), 0)
		end
	end)

	local middlePanel = CreateFrame("Button", "MicroBarMiddlePanel", bar, "SecureActionButtonTemplate")
	middlePanel:SetSize(81, 50)
	middlePanel:SetPoint("CENTER")
	middlePanel:CreateBackdrop("Transparent")
	middlePanel.backdrop:Styling()
	middlePanel:RegisterForClicks("AnyUp")
	bar.middlePanel = middlePanel

	local leftPanel = CreateFrame("Frame", "MicroBarLeftPanel", bar)
	leftPanel:SetSize(300, 40)
	leftPanel:SetPoint("RIGHT", middlePanel, "LEFT", -10, 0)
	leftPanel:CreateBackdrop("Transparent")
	leftPanel.backdrop:Styling()
	bar.leftPanel = leftPanel

	local rightPanel = CreateFrame("Frame", "MicroBarRightPanel", bar)
	rightPanel:SetSize(300, 40)
	rightPanel:SetPoint("LEFT", middlePanel, "RIGHT", 10, 0)
	rightPanel:CreateBackdrop("Transparent")
	rightPanel.backdrop:Styling()
	bar.rightPanel = rightPanel

	S:CreateShadowModule(leftPanel.backdrop)
	S:CreateShadowModule(middlePanel.backdrop)
	S:CreateShadowModule(rightPanel.backdrop)

	self.bar = bar

	E:CreateMover(self.bar, 'MicroBarAnchor', L['MicroBar'], nil, nil, nil, 'ALL,MERATHILISUI', function() return module.db and module.db.enable end, 'mui,modules,microBar,general')
end

function module:UpdateBar()
	if self.db and self.db.mouseOver then
		self.bar:SetAlpha(0)
	else
		self.bar:SetAlpha(1)
	end

	RegisterStateDriver(self.bar, "visibility", self.db.visibility)
end

function module:ConstructTimeArea()
	local colon = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(colon, self.db.time.font)
	colon:SetPoint("CENTER")
	self.bar.middlePanel.colon = colon

	local hour = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(hour, self.db.time.font)
	hour:SetPoint("RIGHT", colon, "LEFT", 1, 0)
	self.bar.middlePanel.hour = hour

	local hourHover = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(hourHover, self.db.time.font)
	hourHover:SetPoint("RIGHT", colon, "LEFT", 1, 0)
	hourHover:SetAlpha(0)
	self.bar.middlePanel.hourHover = hourHover

	local minutes = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(minutes, self.db.time.font)
	minutes:SetPoint("LEFT", colon, "RIGHT", 0, 0)
	self.bar.middlePanel.minutes = minutes

	local minutesHover = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(minutesHover, self.db.time.font)
	minutesHover:SetPoint("LEFT", colon, "RIGHT", 0, 0)
	minutesHover:SetAlpha(0)
	self.bar.middlePanel.minutesHover = minutesHover

	local text = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(text, self.db.additionalText.font)
	text:Point("TOP", self.bar, "BOTTOM", 0, -5)
	text:SetAlpha(0)
	self.bar.middlePanel.text = text

	self.bar.middlePanel:Size(self.db.timeAreaWidth, self.db.timeAreaHeight)

	self:UpdateTimeFormat()
	self:UpdateTime()
	self.timeAreaUpdateTimer = C_Timer_NewTicker(self.db.time.interval, function() module:UpdateTime() end)

	DT.RegisteredDataTexts["System"].onUpdate(self.bar.middlePanel, 10)

	self:HookScript(self.bar.middlePanel, "OnEnter", function(panel)
		if self.db and self.db.mouseOver then
			E:UIFrameFadeIn(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 1)
		end

		DT.RegisteredDataTexts["System"].onUpdate(panel, 10)

		E:UIFrameFadeIn(panel.hourHover, self.db.fadeTime, panel.hourHover:GetAlpha(), 1)
		E:UIFrameFadeIn(panel.minutesHover, self.db.fadeTime, panel.minutesHover:GetAlpha(), 1)
		E:UIFrameFadeIn(panel.text, self.db.fadeTime, panel.text:GetAlpha(), 1)

		if self.db.tooltipPosition == 'ANCHOR_BOTTOM' then
			DT.tooltip:SetOwner(panel.text, 'ANCHOR_BOTTOM', 0, -5)
		elseif self.db.tooltipPosition == 'ANCHOR_TOP' then
			DT.tooltip:SetOwner(panel.text, 'ANCHOR_TOP', 0, 50)
		end

		if IsModifierKeyDown() then
			DT.RegisteredDataTexts["System"].eventFunc()
			DT.RegisteredDataTexts["System"].onEnter()
			self.tooltipTimer = C_Timer_NewTicker(1, function()
				DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
				DT.RegisteredDataTexts["System"].eventFunc()
				DT.RegisteredDataTexts["System"].onEnter()
			end)
		else
			self:ShowAdvancedTimeTooltip(panel)
			self.tooltipTimer = C_Timer_NewTicker(1, function()
				DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
			end)
		end
	end)

	self:HookScript(self.bar.middlePanel, "OnLeave", function(panel)
		if self.db and self.db.mouseOver then
			E:UIFrameFadeOut(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 0)
		end
		E:UIFrameFadeOut(panel.hourHover, self.db.fadeTime, panel.hourHover:GetAlpha(), 0)
		E:UIFrameFadeOut(panel.minutesHover, self.db.fadeTime, panel.minutesHover:GetAlpha(), 0)
		E:UIFrameFadeOut(panel.text, self.db.fadeTime, panel.text:GetAlpha(), 0)

		DT.RegisteredDataTexts["System"].onLeave()
		DT.tooltip:Hide()
		self.tooltipTimer:Cancel()
	end)

	self.bar.middlePanel:SetScript("OnClick", function(_, mouseButton)
		if IsModifierKeyDown() then
			DT.RegisteredDataTexts["System"].eventFunc()
			DT.RegisteredDataTexts["System"].onEnter()
		elseif mouseButton == "LeftButton" then
			if E.Retail then
				if not InCombatLockdown() then
					ToggleCalendar()
				end
			elseif E.Classic then
				return
			else
				_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
			end
		elseif mouseButton == "RightButton" then
			if E.Retail then
				ToggleTimeManager()
			elseif E.Classic then
				ToggleFrame(_G.TimeManagerFrame)
			end
		end
	end)
end

function module:UpdateTimeTicker()
	self.timeAreaUpdateTimer:Cancel()
	self.timeAreaUpdateTimer = C_Timer_NewTicker(self.db.time.interval, function() module:UpdateTime() end)
end

function module:UpdateTimeFormat()
	local normalColor = {r = 1, g = 1, b = 1}
	local hoverColor = {r = 1, g = 1, b = 1}

	if self.db.normalColor == "CUSTOM" then
		normalColor = self.db.customNormalColor
	elseif self.db.normalColor == "CLASS" then
		normalColor = E:ClassColor(E.myclass, true)
	elseif self.db.normalColor == "VALUE" then
		normalColor = {
			r = E.media.rgbvaluecolor[1],
			g = E.media.rgbvaluecolor[2],
			b = E.media.rgbvaluecolor[3]
		}
	end

	if self.db.hoverColor == "CUSTOM" then
		hoverColor = self.db.customHoverColor
	elseif self.db.hoverColor == "CLASS" then
		hoverColor = E:ClassColor(E.myclass, true)
	elseif self.db.hoverColor == "VALUE" then
		hoverColor = {
			r = E.media.rgbvaluecolor[1],
			g = E.media.rgbvaluecolor[2],
			b = E.media.rgbvaluecolor[3]
		}
	end

	self.bar.middlePanel.hour.format = F.CreateColorString("%s", normalColor)
	self.bar.middlePanel.hourHover.format = F.CreateColorString("%s", hoverColor)
	self.bar.middlePanel.minutes.format = F.CreateColorString("%s", normalColor)
	self.bar.middlePanel.minutesHover.format = F.CreateColorString("%s", hoverColor)
	self.bar.middlePanel.colon:SetText(F.CreateColorString(":", hoverColor))
end

function module:UpdateTime()
	local panel = self.bar.middlePanel
	if not panel or not self.db then
		return
	end

	local hour, min

	if self.db.time then
		if self.db.time.localTime then
			hour = self.db.time.twentyFour and date("%H") or date("%I")
			min = date("%M")
		else
			hour, min = GetGameTime()
			hour = self.db.time.twentyFour and hour or mod(hour, 12)
			hour = format("%02d", hour)
			min = format("%02d", min)
		end
	else
		return
	end

	panel.hour:SetFormattedText(panel.hour.format, hour)
	panel.hourHover:SetFormattedText(panel.hourHover.format, hour)
	panel.minutes:SetFormattedText(panel.minutes.format, min)
	panel.minutesHover:SetFormattedText(panel.minutesHover.format, min)

	panel.colon:ClearAllPoints()
	local offset = (panel.hour:GetStringWidth() - panel.minutes:GetStringWidth()) / 2
	panel.colon:SetPoint("CENTER", offset, -1)
end

function module:UpdateTimeArea()
	local panel = self.bar.middlePanel

	F.SetFontDB(panel.hour, self.db.time.font)
	F.SetFontDB(panel.hourHover, self.db.time.font)
	F.SetFontDB(panel.minutes, self.db.time.font)
	F.SetFontDB(panel.minutesHover, self.db.time.font)
	F.SetFontDB(panel.colon, self.db.time.font)
	F.SetFontDB(panel.text, self.db.additionalText.font)

	if self.db.time.flash then
		E:Flash(panel.colon, 1, true)
	else
		E:StopFlash(panel.colon)
	end

	self:UpdateTime()
end

function module:ButtonOnEnter(button)
	if self.db and self.db.mouseOver then
		E:UIFrameFadeIn(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 1)
	end
	E:UIFrameFadeIn(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 1)
	if button.tooltips then
		if self.db.tooltipPosition == 'ANCHOR_BOTTOM' then
			DT.tooltip:SetOwner(button, 'ANCHOR_BOTTOM', 0, -10)
		elseif self.db.tooltipPosition == 'ANCHOR_TOP' then
			DT.tooltip:SetOwner(button, 'ANCHOR_TOP', 0, 5)
		end

		if type(button.tooltips) == "table" then
			DT.tooltip:ClearLines()
			for index, line in ipairs(button.tooltips) do
				if index == 1 then
					DT.tooltip:SetText(line)
				else
					DT.tooltip:AddLine(line, 1, 1, 1)
				end
			end
			DT.tooltip:Show()
		elseif type(button.tooltips) == "string" then
			local DTModule = DT.RegisteredDataTexts[button.tooltips]

			if VirtualDT[button.tooltips] and DTModule.eventFunc then
				DTModule.eventFunc(VirtualDT[button.tooltips], VirtualDTEvent[button.tooltips])
			end

			if DTModule and DTModule.onEnter then
				DTModule.onEnter()
			end

			if not DT.tooltip:IsShown() then
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(button.name or '')
				DT.tooltip:Show()
			end
		elseif type(button.tooltips) == "function" then
			button.tooltips(button)
		end
	end
end

function module:ButtonOnLeave(button)
	if self.db and self.db.mouseOver then
		E:UIFrameFadeOut(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 0)
	end
	E:UIFrameFadeOut(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 0)
	DT.tooltip:Hide()
	if button.tooltipsLeave then
		button.tooltipsLeave(button)
	end
end

function module:ConstructButton()
	if not self.bar then return end

	local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate")
	button:SetSize(self.db.buttonSize, self.db.buttonSize)
	button:RegisterForClicks("AnyUp")

	local normalTex = button:CreateTexture(nil, "ARTWORK")
	normalTex:SetPoint("CENTER")
	normalTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	button.normalTex = normalTex

	local hoverTex = button:CreateTexture(nil, "ARTWORK")
	hoverTex:SetPoint("CENTER")
	hoverTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	hoverTex:SetAlpha(0)
	button.hoverTex = hoverTex

	local notificationTex = button:CreateTexture(nil, "OVERLAY")
	notificationTex:SetAtlas("hud-microbutton-communities-icon-notification")
	notificationTex:SetPoint("TOPRIGHT", 4, 4)
	notificationTex:SetSize(0.6 * self.db.buttonSize, 0.6 * self.db.buttonSize)
	button.notificationTex = notificationTex

	local additionalText = button:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(additionalText, self.db.additionalText.font)
	additionalText:SetPoint(self.db.additionalText.anchor, self.db.additionalText.x, self.db.additionalText.y)
	additionalText:SetJustifyH("CENTER")
	additionalText:SetJustifyV("CENTER")
	button.additionalText = additionalText

	self:HookScript(button, "OnEnter", "ButtonOnEnter")
	self:HookScript(button, "OnLeave", "ButtonOnLeave")

	tinsert(self.buttons, button)
end

function module:UpdateButton(button, buttonType)
	if InCombatLockdown() then return end

	local config = ButtonTypes[buttonType]
	button:SetSize(self.db.buttonSize, self.db.buttonSize)
	button.type = buttonType
	button.name = config.name
	button.tooltips = config.tooltips
	button.tooltipsLeave = config.tooltipsLeave

	if config.macro then
		button:SetAttribute("type*", "macro")
		button:SetAttribute("macrotext1", config.macro.LeftButton or "")
		button:SetAttribute("macrotext2", config.macro.RightButton or config.macro.LeftButton or "")
	elseif config.click then
		function button:Click(mouseButton)
			local func = mouseButton and config.click[mouseButton] or config.click.LeftButton
			func(module.bar.middlePanel)
		end
		button:SetAttribute("type*", "click")
		button:SetAttribute("clickbutton", button)
	elseif config.item then
		button:SetAttribute("type*", "item")
		button:SetAttribute("item1", config.item.item1 or "")
		button:SetAttribute("item2", config.item.item2 or "")
	end

	local r, g, b = 1, 1, 1
	if self.db.normalColor == "CUSTOM" then
		r = self.db.customNormalColor.r
		g = self.db.customNormalColor.g
		b = self.db.customNormalColor.b
	elseif self.db.normalColor == "CLASS" then
		local classColor = E:ClassColor(E.myclass, true)
		r = classColor.r
		g = classColor.g
		b = classColor.b
	elseif self.db.normalColor == "VALUE" then
		r, g, b = unpack(E.media.rgbvaluecolor)
	end

	button.normalTex:SetTexture(config.icon)
	button.normalTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	button.normalTex:SetVertexColor(r, g, b)

	r, g, b = 1, 1, 1
	if self.db.hoverColor == "CUSTOM" then
		r = self.db.customHoverColor.r
		g = self.db.customHoverColor.g
		b = self.db.customHoverColor.b
	elseif self.db.hoverColor == "CLASS" then
		local classColor = E:ClassColor(E.myclass, true)
		r = classColor.r
		g = classColor.g
		b = classColor.b
	elseif self.db.hoverColor == "VALUE" then
		r, g, b = unpack(E.media.rgbvaluecolor)
	end

	button.hoverTex:SetTexture(config.icon)
	button.hoverTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	button.hoverTex:SetVertexColor(r, g, b)

	if button.registeredEvents then
		for _, event in pairs(button.registeredEvents) do
			button:UnregisterEvent(event)
		end
	end

	button:SetScript("OnEvent", nil)
	button.registeredEvents = nil
	button.additionalTextFunc = nil

	if button.additionalTextTimer and not button.additionalTextTimer:IsCancelled() then
		button.additionalTextTimer:Cancel()
	end

	button.additionalTextFormat = F.CreateColorString("%s", {r = r, g = g, b = b})

	if config.additionalText and self.db.additionalText.enable then
		button.additionalText:SetFormattedText(button.additionalTextFormat, config.additionalText and config.additionalText() or "")

		if config.events and config.eventHandler then
			button:SetScript("OnEvent", config.eventHandler)
			button.additionalTextFunc = config.additionalText
			button.registeredEvents = {}
			for _, event in pairs(config.events) do
				button:RegisterEvent(event)
				tinsert(button.registeredEvents, event)
			end
		else
			button.additionalTextTimer = C_Timer_NewTicker(self.db.additionalText.slowMode and 10 or 1, function()
				button.additionalText:SetFormattedText(button.additionalTextFormat, config.additionalText and config.additionalText() or "")
			end)
		end

		button.additionalText:ClearAllPoints()
		button.additionalText:SetPoint(self.db.additionalText.anchor, self.db.additionalText.x, self.db.additionalText.y)
		F.SetFontDB(button.additionalText, self.db.additionalText.font)
		button.additionalText:Show()
	else
		button.additionalText:Hide()
	end

	button.notificationTex:Hide()
end

function module:ConstructButtons()
	if self.buttons then return end

	self.buttons = {}
	for i = 1, NUM_PANEL_BUTTONS * 2 do
		self:ConstructButton()
	end
end

function module:UpdateButtons()
	for i = 1, NUM_PANEL_BUTTONS do
		self:UpdateButton(self.buttons[i], self.db.left[i])
		self:UpdateButton(self.buttons[i + NUM_PANEL_BUTTONS], self.db.right[i])
	end
	self:UpdateGuildButton()
end

function module:UpdateLayout()
	if self.db.backdrop then
		if self.bar.leftPanel.backdrop then self.bar.leftPanel.backdrop:Show() end
		if self.bar.middlePanel.backdrop then self.bar.middlePanel.backdrop:Show() end
		if self.bar.rightPanel.backdrop then self.bar.rightPanel.backdrop:Show() end
	else
		if self.bar.leftPanel.backdrop then self.bar.leftPanel.backdrop:Hide() end
		if self.bar.middlePanel.backdrop then self.bar.middlePanel.backdrop:Hide() end
		if self.bar.rightPanel.backdrop then self.bar.rightPanel.backdrop:Hide() end
	end

	if self.db.shadow then
		if self.bar.leftPanel.backdrop.shadow then self.bar.leftPanel.backdrop.shadow:Show() end
		if self.bar.middlePanel.backdrop.shadow then self.bar.middlePanel.backdrop.shadow:Show() end
		if self.bar.rightPanel.backdrop.shadow then self.bar.rightPanel.backdrop.shadow:Show() end
	else
		if self.bar.leftPanel.backdrop.shadow then self.bar.leftPanel.backdrop.shadow:Hide() end
		if self.bar.middlePanel.backdrop.shadow then self.bar.middlePanel.backdrop.shadow:Hide() end
		if self.bar.rightPanel.backdrop.shadow then self.bar.rightPanel.backdrop.shadow:Hide() end
	end

	local numLeftButtons, numRightButtons = 0, 0

	local lastButton = nil
	for i = 1, NUM_PANEL_BUTTONS do
		local button = self.buttons[i]
		if button.name ~= L["None"] then
			button:Show()
			button:ClearAllPoints()
			if not lastButton then
				button:SetPoint("LEFT", self.bar.leftPanel, "LEFT", self.db.backdropSpacing, 0)
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
			end
			lastButton = button
			numLeftButtons = numLeftButtons + 1
		else
			button:Hide()
		end
	end

	if numLeftButtons == 0 then
		self.bar.leftPanel:Hide()
	else
		self.bar.leftPanel:Show()
		local panelWidth =
			self.db.backdropSpacing * 2 + (numLeftButtons - 1) * self.db.spacing + numLeftButtons * self.db.buttonSize
		local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
		self.bar.leftPanel:SetSize(panelWidth, panelHeight)
	end

	lastButton = nil
	for i = 1, NUM_PANEL_BUTTONS do
		local button = self.buttons[i + NUM_PANEL_BUTTONS]
		if button.name ~= L["None"] then
			button:Show()
			button:ClearAllPoints()
			if not lastButton then
				button:SetPoint("LEFT", self.bar.rightPanel, "LEFT", self.db.backdropSpacing, 0)
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
			end
			lastButton = button
			numRightButtons = numRightButtons + 1
		else
			button:Hide()
		end
	end

	if numRightButtons == 0 then
		self.bar.rightPanel:Hide()
	else
		self.bar.rightPanel:Show()
		local panelWidth =
			self.db.backdropSpacing * 2 + (numRightButtons - 1) * self.db.spacing + numRightButtons * self.db.buttonSize
		local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
		self.bar.rightPanel:SetSize(panelWidth, panelHeight)
	end

	self.bar.middlePanel:SetSize(self.db.timeAreaWidth, self.db.timeAreaHeight)

	local areaWidth = 20 + self.bar.middlePanel:GetWidth()
	local leftWidth = self.bar.leftPanel:IsShown() and self.bar.leftPanel:GetWidth() or 0
	local rightWidth = self.bar.rightPanel:IsShown() and self.bar.rightPanel:GetWidth() or 0
	areaWidth = areaWidth + 2 * max(leftWidth, rightWidth)

	local areaHeight = self.bar.middlePanel:GetHeight()
	local leftHeight = self.bar.leftPanel:IsShown() and self.bar.leftPanel:GetHeight() or 0
	local rightHeight = self.bar.rightPanel:IsShown() and self.bar.rightPanel:GetHeight() or 0
	areaHeight = max(max(leftHeight, rightHeight), areaHeight)

	self.bar:SetSize(areaWidth, areaHeight)
end

function module:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:ProfileUpdate()
end

function module:PLAYER_ENTERING_WORLD()
	C_Timer_After(1, function()
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:ProfileUpdate()
		end
	end)
end

function module:UpdateGuildButton()
	if not self.db or not self.db.notification then
		return
	end

	if not _G.GuildMicroButton or not _G.GuildMicroButton.NotificationOverlay then
		return
	end

	local isShown = _G.GuildMicroButton.NotificationOverlay:IsShown()

	for i = 1, 2 * NUM_PANEL_BUTTONS do
		if self.buttons[i].type == "GUILD" then
			self.buttons[i].notificationTex:SetShown(isShown)
		end
	end
end

function module:UpdateHomeButton()
	ButtonTypes.HOME.item = {
		item1 = HeartstonesTable[self.db.home.left],
		item2 = HeartstonesTable[self.db.home.right]
	}
end

function module:UpdateHearthStoneTable()
	HeartstonesTable = {}

	local index = 0
	local itemEngine = CreateFromMixins(ItemMixin)

	local function GetNextHearthStoneInfo()
		index = index + 1
		if Heartstones[index] then
			itemEngine:SetItemID(Heartstones[index])
			itemEngine:ContinueOnItemLoad(function()
				HeartstonesTable[tostring(Heartstones[index])] = itemEngine:GetItemName()
				GetNextHearthStoneInfo()
			end)
		else
			self:UpdateHomeButton()
			if self.Initialized then
				self:UpdateButtons()
			end
		end
	end

	GetNextHearthStoneInfo()
end

function module:GetHearthStoneTable()
	return HeartstonesTable
end

function module:GetAvailableButtons()
	local buttons = {}

	for key, data in pairs(ButtonTypes) do
		buttons[key] = data.name
	end

	return buttons
end

function module:Initialize()
	self.db = E.db.mui.microBar
	if not self.db or not self.db.enable then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	self:UpdateHearthStoneTable()
	self:ConstructBar()
	self:ConstructTimeArea()
	self:ConstructButtons()
	self:UpdateTimeArea()
	self:UpdateButtons()
	self:UpdateLayout()
	self:UpdateBar()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	if E.Retail then
		self:SecureHook(_G.GuildMicroButton, "UpdateNotificationIcon", "UpdateGuildButton")
	end

	self.Initialized = true
end

function module:ProfileUpdate()
	self.db = E.db.mui.microBar
	if not self.db then
		return
	end

	if self.db.enable then
		if self.Initialized then
			self.bar:Show()
			self:UpdateHomeButton()
			self:UpdateTimeFormat()
			self:UpdateTimeArea()
			self:UpdateTime()
			self:UpdateButtons()
			self:UpdateLayout()
			self:UpdateBar()
		else
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			else
				self:Initialize()
			end
		end
	else
		if self.Initialized then
			UnregisterStateDriver(self.bar, "visibility")
			self.bar:Hide()
		end
	end
end

MER:RegisterModule(module:GetName())

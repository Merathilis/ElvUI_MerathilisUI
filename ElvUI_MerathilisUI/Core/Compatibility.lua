local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ES = E.Skins
local S = MER:GetModule("MER_Skins")

local _G = _G
local format = format
local gsub, ipairs, type = gsub, ipairs, type
local strlen, strsplit = strlen, strsplit

local CreateFrame = CreateFrame

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]

function MER:ConstructCompatibilityFrame()
	local frame = CreateFrame("Frame", "MERCompatibilityFrame", E.UIParent)
	frame:Size(550, 500)
	frame:SetPoint("CENTER")
	frame:CreateBackdrop("Transparent")
	S:CreateShadowModule(frame.backdrop)
	frame.numModules = 0
	frame:Hide()
	frame:SetScript("OnHide", function()
		if frame.configChanged then
			E:StaticPopup_Show("PRIVATE_RL")
		end
	end)

	frame:SetFrameStrata("TOOLTIP")
	frame:SetFrameLevel(9000)

	local close = F.Widgets.New("CloseButton", frame)
	close:SetPoint("TOPRIGHT", frame.backdrop, "TOPRIGHT")

	local title = frame:CreateFontString(nil, "ARTWORK")
	title:FontTemplate()
	F.SetFontOutline(title, nil, "2")
	title:SetText(MER.Title .. " " .. L["Compatibility Check"])
	title:SetPoint("TOP", frame, "TOP", 0, -10)

	local desc = frame:CreateFontString(nil, "ARTWORK")
	desc:FontTemplate()
	desc:SetJustifyH("LEFT")
	desc:Width(420)
	F.SetFontOutline(desc, nil, "-1")
	desc:SetText(
		L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."]
			.. " "
			.. format(L["Have a good time with %s!"], MER.Title)
	)
	desc:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)

	local largeTip = frame:CreateFontString(nil, "ARTWORK")
	largeTip:FontTemplate()
	largeTip:SetJustifyH("CENTER")
	largeTip:Width(500)
	F.SetFontOutline(largeTip, nil, "7")
	largeTip:SetText(
		format(
			"%s %s %s",
			F.CreateColorString("[", E.db.general.valuecolor),
			L["Choose the module you would like to |cff00ff00use|r"],
			F.CreateColorString("]", E.db.general.valuecolor)
		)
	)
	largeTip:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)

	local tex = frame:CreateTexture("MERCompatibilityFrameIllustration", "ARTWORK")
	tex:Size(64)
	tex:SetTexture(I.Media.Textures.PepeArt)
	tex:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -25)

	local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
	bottomDesc:FontTemplate()
	bottomDesc:SetJustifyH("LEFT")
	bottomDesc:Width(530)
	F.SetFontOutline(bottomDesc, nil, "-1")
	bottomDesc:SetText(
		newSignIgnored
			.. format(L["If you find the %s module conflicts with another addon, alert me via Discord."], MER.Title)
			.. "\n"
			.. L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."]
	)
	--bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
	bottomDesc:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

	local completeButton =
		CreateFrame("Button", "MERCompatibilityFrameCompleteButton", frame, "UIPanelButtonTemplate, BackdropTemplate")

	completeButton.Text:SetText(L["Complete"])
	completeButton.Text:SetJustifyH("CENTER")
	completeButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(completeButton.Text, E.db.general.font, "4")
	completeButton:Size(350, 35)
	completeButton:SetPoint("BOTTOM", bottomDesc, "TOP", 0, 10)
	ES:HandleButton(completeButton)
	completeButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	local scrollFrameParent =
		CreateFrame("ScrollFrame", "MERCompatibilityFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
	scrollFrameParent:CreateBackdrop("Transparent")
	scrollFrameParent:SetPoint("TOPLEFT", largeTip, "BOTTOMLEFT", 0, -10)
	scrollFrameParent:SetPoint("RIGHT", frame, "RIGHT", -32, 0)
	scrollFrameParent:SetPoint("BOTTOM", completeButton, "TOP", 0, 10)
	ES:HandleScrollBar(scrollFrameParent.ScrollBar)

	local scrollFrame = CreateFrame("Frame", "MERCompatibilityFrameScrollFrame", scrollFrameParent)
	scrollFrame:SetSize(scrollFrameParent:GetSize())

	scrollFrameParent:SetScrollChild(scrollFrame)
	frame.scrollFrameParent = scrollFrameParent
	frame.scrollFrame = scrollFrame

	MER.CompatibilityFrame = frame
end

local function AddButtonToCompatibilityFrame(data)
	local frame = MER.CompatibilityFrame
	frame.numModules = frame.numModules + 1

	local leftButton = CreateFrame(
		"Button",
		"MERCompatibilityFrameLeftButton" .. frame.numModules,
		frame.scrollFrame,
		"UIPanelButtonTemplate, BackdropTemplate"
	)

	leftButton.Text:SetText(format("%s\n%s", data.module1, data.plugin1))
	leftButton.Text:SetJustifyH("CENTER")
	leftButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(leftButton.Text, E.db.general.font)
	leftButton:Size(220, 40)
	leftButton:SetPoint("TOPLEFT", frame.scrollFrame, "TOPLEFT", 5, -frame.numModules * 50 + 45)
	ES:HandleButton(leftButton)
	leftButton:SetScript("OnClick", function(self)
		data.func1()
		frame.configChanged = true
		local name = gsub(self:GetName(), "LeftButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.left)
			_G[name]:SetVertexColor(0, 1, 0, 1)
		end
	end)

	local middleTexture =
		frame.scrollFrame:CreateTexture("MERCompatibilityFrameMiddleTexture" .. frame.numModules, "ARTWORK")
	middleTexture:SetPoint("CENTER")
	middleTexture:Size(20)
	middleTexture:SetTexture(I.Media.Icons.Convert)
	middleTexture:SetVertexColor(1, 1, 1, 1)
	middleTexture:SetPoint("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

	local rightButton = CreateFrame(
		"Button",
		"MERCompatibilityFrameRightButton" .. frame.numModules,
		frame.scrollFrame,
		"UIPanelButtonTemplate, BackdropTemplate"
	)

	rightButton.Text:SetText(format("%s\n%s", data.module2, data.plugin2))
	rightButton.Text:SetJustifyH("CENTER")
	rightButton.Text:SetJustifyV("MIDDLE")
	F.SetFontOutline(rightButton.Text, E.db.general.font)
	rightButton:Size(220, 40)
	rightButton:SetPoint("TOPRIGHT", frame.scrollFrame, "TOPRIGHT", -5, -frame.numModules * 50 + 45)
	ES:HandleButton(rightButton)
	rightButton:SetScript("OnClick", function(self)
		data.func2()
		frame.configChanged = true
		local name = gsub(self:GetName(), "RightButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.right)
			_G[name]:SetVertexColor(1, 0, 0, 1)
		end
	end)
end

local function GetDatabaseRealValue(path)
	local accessTable, accessKey, accessValue = nil, nil, E

	for _, key in ipairs({ strsplit(".", path) }) do
		if key and strlen(key) > 0 then
			if accessValue and accessValue[key] ~= nil then
				if type(accessValue[key]) == "boolean" then
					accessTable = accessValue
					accessKey = key
				end
				accessValue = accessValue[key]
			else
				F.Developer.LogWarning("[Compatibility] database path not found\n" .. path)
				return
			end
		end
	end

	return accessTable, accessKey, accessValue
end

local function GetCheckCompatibilityFunction(targetAddonName, targetAddonLocales)
	if not IsAddOnLoaded(targetAddonName) then
		return E.noop
	end

	return function(myModuleName, targetAddonModuleName, myDB, targetAddonDB)
		if not (myDB and targetAddonDB and type(myDB) == "string" and type(targetAddonDB) == "string") then
			return
		end

		local myTable, myKey, myValue = GetDatabaseRealValue(myDB)
		local targetTable, targetKey, targetValue = GetDatabaseRealValue(targetAddonDB)

		if myValue == true and targetValue == true then
			AddButtonToCompatibilityFrame({
				module1 = myModuleName,
				plugin1 = MER.Title,
				func1 = function()
					myTable[myKey] = true
					targetTable[targetKey] = false
				end,
				module2 = targetAddonModuleName,
				plugin2 = targetAddonLocales,
				func2 = function()
					myTable[myKey] = false
					targetTable[targetKey] = true
				end,
			})
		end
	end
end

local CheckBenikUI = GetCheckCompatibilityFunction("ElvUI_BenikUI", L["BenikUI"])
local CheckWindtools = GetCheckCompatibilityFunction("ElvUI_Windtools", L["Windtools"])
local CheckShadowAndLight = GetCheckCompatibilityFunction("ElvUI_SLE", L["Shadow & Light"])
local CheckEltruism = GetCheckCompatibilityFunction("ElvUI_EltreumUI", L["EltreumUI"])

function MER:CheckCompatibility()
	if not E.global.mui.core.compatibilityCheck then
		return
	end

	self:ConstructCompatibilityFrame()

	-- Windtools
	CheckWindtools(
		L["AutoButtons"],
		L["Extra Items Bar"],
		"db.mui.autoButtons.enable",
		"db.WT.item.extraItemsBar.enable"
	)

	CheckWindtools(L["Micro Bar"], L["Game Bar"], "db.mui.microBar.enable", "db.WT.misc.gameBar.enable")

	CheckWindtools(L["Mail"], L["Contacts"], "db.mui.mail.enable", "db.WT.item.contacts.enable")

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Tooltip Icons"]),
		format("%s-%s", L["Tooltip"], L["Add Icon"]),
		"db.mui.tooltip.icon",
		"private.WT.tooltips.icon"
	)

	CheckWindtools(
		L["Role Icon"],
		L["Role Icon"],
		"db.mui.unitframes.roleIcons",
		"private.WT.unitFrames.roleIcon.enable"
	)

	CheckWindtools(L["Combat Alert"], L["Combat Alert"], "db.mui.CombatAlert.enable", "db.WT.combat.combatAlert.enable")

	CheckWindtools(
		L["Minimap Ping"],
		L["Who Clicked Minimap"],
		"db.mui.maps.minimap.ping.enable",
		"db.WT.maps.whoClicked.enable"
	)

	CheckWindtools(
		L["Minimap Buttons"],
		L["Minimap Buttons"],
		"db.mui.smb.enable",
		"private.WT.maps.minimapButtons.enable"
	)

	CheckWindtools(L["Chat Bar"], L["Chat Bar"], "db.mui.chat.chatBar.enable", "db.WT.social.chatBar.enable")

	CheckWindtools(L["Chat Link"], L["Chat Link"], "db.mui.chat.chatLink.enable", "db.WT.social.chatLink.enable")

	CheckWindtools(L["Raid Markers"], L["Raid Markers"], "db.mui.raidmarkers.enable", "db.WT.combat.raidMarkers.enable")

	CheckWindtools(
		L["Super Tracker"],
		L["Super Tracker"],
		"db.mui.maps.superTracker.enable",
		"private.WT.maps.superTracker.enable"
	)

	CheckWindtools(
		L["Merchant"],
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		"db.mui.merchant.enable",
		"private.WT.item.extendMerchantPages.enable"
	)

	CheckWindtools(
		L["Heal Prediction"],
		L["Absorb"],
		"db.mui.unitframes.healPrediction.enable",
		"db.WT.unitFrames.absorb.enable"
	)

	CheckWindtools(
		L["Objective Tracker"],
		L["Objective Tracker"],
		"db.mui.blizzard.objectiveTracker.enable",
		"private.WT.quest.objectiveTracker.enable"
	)

	CheckWindtools(
		L["Button"],
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Button"]),
		"private.mui.skins.widgets.button.enable",
		"private.WT.skins.widgets.button.enable"
	)

	CheckWindtools(
		L["Check Box"],
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Check Box"]),
		"private.mui.skins.widgets.checkBox.enable",
		"private.WT.skins.widgets.checkBox.enable"
	)

	CheckWindtools(
		L["Tab"],
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tab"]),
		"private.mui.skins.widgets.tab.enable",
		"private.WT.skins.widgets.tab.enable"
	)

	CheckWindtools(
		L["Tree Group Button"],
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tree Group Button"]),
		"private.mui.skins.widgets.treeGroupButton.enable",
		"private.WT.skins.widgets.treeGroupButton.enable"
	)

	CheckWindtools(
		L["WeakAuras"],
		format("%s-%s-%s", L["Skins"], L["Addons"], L["WeakAuras"]),
		"private.mui.skins.addonSkins.wa",
		"private.WT.skins.addons.weakAuras"
	)

	CheckWindtools(
		L["WeakAuras Options"],
		format("%s-%s-%s", L["Skins"], L["Addons"], L["WeakAuras Options"]),
		"private.mui.skins.addonSkins.waOptions",
		"private.WT.skins.addons.weakAurasOptions"
	)

	CheckWindtools(
		L["Friends List"],
		L["Friend List"],
		"db.mui.blizzard.friendsList.enable",
		"db.WT.social.friendList.enable"
	)

	CheckWindtools(L["World Map"], L["World Map"], "db.mui.maps.worldMap.enable", "private.WT.maps.worldMap.enable")

	CheckWindtools(
		format("%s-%s", L["UnitFrames"], L["Role Icons"]),
		format("%s-%s", L["UnitFrames"], L["Role Icon"]),
		"db.mui.unitframes.roleIcons.enable",
		"private.WT.unitFrames.roleIcon.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Chat"], L["Role Icons"]),
		L["Chat Text"],
		"db.mui.chat.chatText.enable",
		"db.WT.social.chatText.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Misc"], L["Spell Alert Scale"]),
		format("%s-%s", L["Misc"], L["Spell Activation Alert"]),
		"db.mui.misc.spellAlert.enable",
		"db.WT.misc.spellActivationAlert.enable"
	)

	CheckWindtools(L["Announcement"], L["Announcement"], "db.mui.announcement.enable", "db.WT.announcement.enable")

	CheckWindtools(
		L["Event Tracker"],
		L["Event Tracker"],
		"db.mui.maps.eventTracker.enable",
		"db.WT.maps.eventTracker.enable"
	)

	CheckWindtools(
		format("%s-%s", L["AddOnSkins"], L["Auctionator"]),
		format("%s-%s", L["Skins"], L["Auctionator"]),
		"private.mui.skins.addonSkins.au",
		"private.WT.skins.addons.auctionator"
	)

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Group Info"]),
		format("%s-%s", L["Tooltip"], L["Group Info"]),
		"db.mui.tooltip.groupInfo.enable",
		"db.WT.tooltips.groupInfo.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Chat"], L["ChatText"]),
		format("%s-%s", L["Social"], L["ChatText"]),
		"db.mui.chat.chatText.enable",
		"db.WT.social.chatText.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Quest"], L["Turn In"]),
		format("%s-%s", L["Quest"], L["Turn In"]),
		"db.mui.quest.turnIn.enable",
		"db.WT.quest.turnIn.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Quest"], L["Switch Buttons"]),
		format("%s-%s", L["Quest"], L["Switch Buttons"]),
		"db.mui.quest.switchButtons.enable",
		"db.WT.quest.switchButtons.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Race Icon"]),
		format("%s-%s-%s-%s", L["Tooltips"], L["General"], L["ElvUI Tooltip Tweaks"], L["Race Icon"]),
		"db.mui.tooltip.raceIcon",
		"db.WT.tooltips.elvUITweaks.raceIcon"
	)

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Spec Icon"]),
		format("%s-%s-%s-%s", L["Tooltips"], L["General"], L["ElvUI Tooltip Tweaks"], L["Spec Icon"]),
		"db.mui.tooltip.specIcon",
		"db.WT.tooltips.elvUITweaks.specIcon"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Shadow"]),
		L["Enhanced Shadow"],
		"private.mui.skins.shadow",
		"private.sle.module.shadows.enable"
	)

	CheckShadowAndLight(L["Raid Markers"], L["Raid Markers"], "db.mui.raidmarkers.enable", "db.sle.raidmarkers.enable")

	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Key Timers"]),
		format("%s-%s", L["Skins"], L["Scenario"]),
		"private.mui.skins.blizzard.objectiveTracker",
		"private.sle.skins.objectiveTracker.keyTimers.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Objective Tracker"], L["Cosmetic Bar"]),
		format("%s-%s", L["Skins"], L["Underline"]),
		"db.mui.blizzard.objectiveTracker.enable",
		"db.sle.skins.objectiveTracker.underline"
	)

	CheckShadowAndLight(
		L["Merchant"],
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		"db.mui.merchant.enable",
		"private.sle.skins.merchant.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["UnitFrames"], L["Role Icons"]),
		format("%s-%s", L["UnitFrames"], L["Role Icon"]),
		"db.mui.unitframes.roleIcons.enable",
		"db.sle.unitframes.roleIcons.enable"
	)

	CheckEltruism(
		L["Gradient"],
		L["Enable Gradient Nameplates"],
		"db.mui.nameplates.gradient",
		"db.ElvUI_EltreumUI.unitframes.gradientmode.npenable"
	)

	CheckEltruism(
		L["Power"],
		format("%s-%s", L["Models"], L["Enable Models/Effects"]),
		"db.mui.unitframes.power.enable",
		"db.ElvUI_EltreumUI.unitframes.models.unitframe"
	)

	if self.CompatibilityFrame.numModules > 0 then
		self.CompatibilityFrame:Show()
	end
end

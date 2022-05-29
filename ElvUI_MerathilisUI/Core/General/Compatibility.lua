local MER, F, E, L, V, P, G = unpack(select(2, ...))
local ES = E.Skins

local _G = _G
local format = format
local gsub, ipairs, type = gsub, ipairs, type
local strlen, strsplit = strlen, strsplit

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

function MER:ConstructCompatibilityFrame()
	local frame = CreateFrame("Frame", "MERCompatibilityFrame", E.UIParent)
	frame:Size(550, 500)
	frame:Point("CENTER")
	frame:CreateBackdrop("Transparent")
	MER:CreateShadowModule(frame.backdrop)
	frame.backdrop:Styling()
	frame.numModules = 0
	frame:Hide()
	frame:SetScript("OnHide", function()
		if frame.configChanged then
			E:StaticPopup_Show("PRIVATE_RL")
		end
	end)

	frame:SetFrameStrata("TOOLTIP")
	frame:SetFrameLevel(9000)

	local close = CreateFrame("Button", "MERCompatibilityFrameCloseButton", frame, "UIPanelCloseButton, BackdropTemplate")
	close:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT")
	ES:HandleCloseButton(close)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	local title = frame:CreateFontString(nil, "ARTWORK")
	title:FontTemplate()
	F.SetFontOutline(title, nil, "2")
	title:SetText(MER.Title .. " " .. L["Compatibility Check"])
	title:Point("TOP", frame, "TOP", 0, -10)

	local desc = frame:CreateFontString(nil, "ARTWORK")
	desc:FontTemplate()
	desc:SetJustifyH("LEFT")
	desc:Width(420)
	F.SetFontOutline(desc, nil, "-1")
	desc:SetText(
		L[
			"There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."
		] ..
			" " .. format(L["Have a good time with %s!"], MER.Title)
	)
	desc:Point("TOPLEFT", frame, "TOPLEFT", 10, -40)

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
	largeTip:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)

	local tex = frame:CreateTexture("MERCompatibilityFrameIllustration", "ARTWORK")
	tex:Size(64)
	tex:SetTexture(MER.Media.Textures.PepeArt)
	tex:Point("TOPRIGHT", frame, "TOPRIGHT", -20, -25)

	local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
	bottomDesc:FontTemplate()
	bottomDesc:SetJustifyH("LEFT")
	bottomDesc:Width(530)
	F.SetFontOutline(bottomDesc, nil, "-1")
	bottomDesc:SetText(
		E.NewSign ..
			format(L["If you find the %s module conflicts with another addon, alert me via Discord."], MER.Title) ..
				"\n" ..
					L[
						"You can disable/enable compatibility check via the option in the bottom of [WindTools]-[Information]-[Help]."
					]
	)
	--bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
	bottomDesc:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

	local completeButton = CreateFrame("Button", "MERCompatibilityFrameCompleteButton", frame, "OptionsButtonTemplate, BackdropTemplate")
	completeButton.Text:SetText(L["Complete"])
	completeButton.Text:SetJustifyH("CENTER")
	completeButton.Text:SetJustifyV("CENTER")
	F.SetFontOutline(completeButton.Text, E.db.general.font, "4")
	completeButton:Size(350, 35)
	completeButton:Point("BOTTOM", bottomDesc, "TOP", 0, 10)
	ES:HandleButton(completeButton)
	completeButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	local scrollFrameParent = CreateFrame("ScrollFrame", "MERCompatibilityFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
	scrollFrameParent:CreateBackdrop("Transparent")
	scrollFrameParent:Point("TOPLEFT", largeTip, "BOTTOMLEFT", 0, -10)
	scrollFrameParent:Point("RIGHT", frame, "RIGHT", -32, 0)
	scrollFrameParent:Point("BOTTOM", completeButton, "TOP", 0, 10)
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

	local leftButton = CreateFrame("Button", "MERCompatibilityFrameLeftButton" .. frame.numModules, frame.scrollFrame, "OptionsButtonTemplate, BackdropTemplate")
	leftButton.Text:SetText(format("%s\n%s", data.module1, data.plugin1))
	leftButton.Text:SetJustifyH("CENTER")
	leftButton.Text:SetJustifyV("CENTER")
	F.SetFontOutline(leftButton.Text, E.db.general.font)
	leftButton:Size(220, 40)
	leftButton:Point("TOPLEFT", frame.scrollFrame, "TOPLEFT", 5, -frame.numModules * 50 + 45)
	ES:HandleButton(leftButton)
	leftButton:SetScript("OnClick", function(self)
		data.func1()
		frame.configChanged = true
		local name = gsub(self:GetName(), "LeftButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.left)
			_G[name]:SetVertexColor(0, 1, 0)
		end
	end)

	local middleTexture = frame.scrollFrame:CreateTexture("MERCompatibilityFrameMiddleTexture" .. frame.numModules, "ARTWORK")
	middleTexture:Point("CENTER")
	middleTexture:Size(20)
	middleTexture:SetTexture(MER.Media.Icons.convert)
	middleTexture:SetVertexColor(1, 1, 1)
	middleTexture:Point("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

	local rightButton = CreateFrame("Button", "MERCompatibilityFrameRightButton" .. frame.numModules, frame.scrollFrame, "OptionsButtonTemplate, BackdropTemplate")
	rightButton.Text:SetText(format("%s\n%s", data.module2, data.plugin2))
	rightButton.Text:SetJustifyH("CENTER")
	rightButton.Text:SetJustifyV("CENTER")
	F.SetFontOutline(rightButton.Text, E.db.general.font)
	rightButton:Size(220, 40)
	rightButton:Point("TOPRIGHT", frame.scrollFrame, "TOPRIGHT", -5, -frame.numModules * 50 + 45)
	ES:HandleButton(rightButton)
	rightButton:SetScript("OnClick", function(self)
		data.func2()
		frame.configChanged = true
		local name = gsub(self:GetName(), "RightButton", "MiddleTexture")
		if _G[name] then
			_G[name]:SetTexture(E.Media.Textures.ArrowUp)
			_G[name]:SetRotation(ES.ArrowRotation.right)
			_G[name]:SetVertexColor(1, 0, 0)
		end
	end)
end

local function GetDatabaseRealValue(path)
	local accessTable, accessKey, accessValue = nil, nil, E

	for _, key in ipairs {strsplit(".", path)} do
		if key and strlen(key) > 0 then
			if accessValue and accessValue[key] ~= nil then
				if type(accessValue[key]) == "boolean" then
					accessTable = accessValue
					accessKey = key
				end
				accessValue = accessValue[key]
			else
				F.DebugMessage("Compatibility", "DB Path Error: " .. path)
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
			AddButtonToCompatibilityFrame(
				{
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
					end
				}
			)
		end
	end
end

local CheckWindtools = GetCheckCompatibilityFunction("ElvUI_Windtools", L["Windtools"])
local CheckShadowAndLight = GetCheckCompatibilityFunction("ElvUI_SLE", L["Shadow & Light"])

function MER:CheckCompatibility()
	if not E.private.mui.core.compatibilityCheck then
		return
	end

	self:ConstructCompatibilityFrame()

	-- Merathilis UI
	CheckWindtools(
		L["Extra Items Bar"],
		L["AutoButtons"],
		"db.mui.autoButtons.enable",
		"db.WT.item.extraItemsBar.enable"
	)

	CheckWindtools(L["Game Bar"], L["Micro Bar"], "db.mui.microBar.enable", "db.WT.misc.gameBar.enable")

	CheckWindtools(L["Contacts"], L["Mail"], "db.mui.mail.enable", "db.WT.item.contacts.enable")

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Add Icon"]),
		format("%s-%s", L["Tooltip"], L["Tooltip Icons"]),
		"db.mui.tooltip.tooltipIcon",
		"private.WT.tooltips.icon"
	)

	CheckWindtools(
		format("%s-%s", L["Tooltip"], L["Domination Rank"]),
		format("%s-%s", L["Tooltip"], L["Domination Rank"]),
		"db.mui.tooltip.dominationRank",
		"private.WT.tooltips.dominationRank"
	)

	CheckWindtools(L["Group Info"], L["LFG Info"], "db.mui.misc.lfgInfo.enable", "db.WT.tooltips.groupInfo.enable")

	CheckWindtools(
		L["Paragon Reputation"],
		L["Paragon Reputation"],
		"db.mui.misc.paragon.enable",
		"db.WT.quest.paragonReputation.enable"
	)

	CheckWindtools(
		L["Role Icon"],
		L["Role Icon"],
		"db.mui.unitframes.roleIcons",
		"private.WT.unitFrames.roleIcon.enable"
	)

	CheckWindtools(
		L["Combat Alert"],
		L["Combat Alert"],
		"db.mui.CombatAlert.enable",
		"db.WT.combat.combatAlert.enable"
	)

	CheckWindtools(
		L["Who Clicked Minimap"],
		L["Minimap Ping"],
		"db.mui.maps.minimap.ping.enable",
		"db.WT.maps.whoClicked.enable"
	)

	CheckWindtools(
		L["Minimap Buttons"],
		L["Minimap Buttons"],
		"db.mui.smb.enable",
		"private.WT.maps.minimapButtons.enable"
	)

	CheckWindtools(
		L["Rectangle Minimap"],
		L["Rectangle Minimap"],
		"db.mui.maps.minimap.rectangleMinimap.enable",
		"db.WT.maps.rectangleMinimap.enable"
	)

	CheckWindtools(L["Chat Bar"], L["Chat Bar"], "db.mui.chat.chatBar.enable", "db.WT.social.chatBar.enable")

	CheckWindtools(L["Chat Link"], L["Chat Link"], "db.mui.chat.chatLink.enable", "db.WT.social.chatLink.enable")

	CheckWindtools(
		L["Raid Markers"],
		L["Raid Markers"],
		"db.mui.raidmarkers.enable",
		"db.WT.combat.raidMarkers.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Chat Text"], L["Remove Brackets"]),
		L["Hide Player Brackets"],
		"db.mui.chat.hidePlayerBrackets"
	)

	CheckWindtools(
		L["Super Tracker"],
		L["Super Tracker"],
		"db.mui.maps.superTracker.enable",
		"private.WT.maps.superTracker.enable"
	)

	CheckWindtools(
		L["Instance Difficulty"],
		L["Raid Difficulty"],
		"db.mui.maps.minimap.instanceDifficulty.enable",
		"private.WT.maps.instanceDifficulty.enable"
	)

	CheckWindtools(
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		L["Merchant"],
		"db.mui.merchant.enable",
		"private.WT.item.extendMerchantPages.enable"
	)

	CheckWindtools(
		L["Absorb"],
		L["Heal Prediction"],
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
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Button"]),
		L["Button"],
		"private.mui.skins.widgets.button.enable",
		"private.WT.skins.widgets.button.enable"
	)

	CheckWindtools(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Check Box"]),
		L["Check Box"],
		"private.mui.skins.widgets.checkBox.enable",
		"private.WT.skins.widgets.checkBox.enable"
	)

	CheckWindtools(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tab"]),
		L["Check Box"],
		"private.mui.skins.widgets.tab.enable",
		"private.WT.skins.widgets.tab.enable"
	)

	CheckWindtools(
		format("%s-%s-%s", L["Skins"], L["Widgets"], L["Tree Group Button"]),
		L["Check Box"],
		"private.mui.skins.widgets.treeGroupButton.enable",
		"private.WT.skins.widgets.treeGroupButton.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Shadow"]),
		L["Enhanced Shadow"],
		"private.mui.skins.shadow",
		"private.sle.module.shadows.enable"
	)

	CheckShadowAndLight(
		L["Rectangle Minimap"],
		L["Rectangle Minimap"],
		"db.mui.maps.rectangleMinimap.enable",
		"private.sle.minimap.rectangle"
	)

	CheckShadowAndLight(
		L["Raid Markers"],
		L["Raid Markers"],
		"db.mui.combat.raidmarkers.enable",
		"db.sle.raidmarkers.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Skins"], L["Scenario"]),
		format("%s-%s", L["Skins"], L["Key Timers"]),
		"private.mui.skins.blizzard.scenario",
		"private.sle.skins.objectiveTracker.keyTimers.enable"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Objective Tracker"], L["Cosmetic Bar"]),
		format("%s-%s", L["Skins"], L["Underline"]),
		"private.mui.quest.objectiveTracker.enable",
		"db.sle.skins.objectiveTracker.underline"
	)

	CheckShadowAndLight(
		format("%s-%s", L["Item"], L["Extend Merchant Pages"]),
		L["Merchant"],
		"private.mui.item.extendMerchantPages.enable",
		"private.sle.skins.merchant.enable"
	)

	if self.CompatibilityFrame.numModules > 0 then
		self.CompatibilityFrame:Show()
	end
end
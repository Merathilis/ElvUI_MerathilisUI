local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ES = E:GetModule("Skins")
local WS = W:GetModule("Skins") ---@type Skins
local MF = W:GetModule("MoveFrames")
local C = W.Utilities.Color

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
	WS:CreateShadowModule(frame.backdrop)
	frame.numModules = 0
	frame:Hide()
	frame:SetScript("OnHide", function()
		if frame.configChanged then
			E:StaticPopup_Show("PRIVATE_RL")
		end
	end)

	frame:SetFrameStrata("TOOLTIP")
	frame:SetFrameLevel(9000)

	MF:InternalHandle(frame)

	local close = WF.Widgets.New("CloseButton", frame)
	if close then
		close:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT")
		close:SetFrameLevel(frame:GetFrameLevel() + 1)
	end

	local title = frame:CreateFontString(nil, "ARTWORK")
	title:FontTemplate()
	WF.SetFont(title, nil, "2")
	title:SetText(MER.Title .. " " .. L["Compatibility Check"])
	title:SetPoint("TOP", frame, "TOP", 0, -10)

	local desc = frame:CreateFontString(nil, "ARTWORK")
	desc:FontTemplate()
	desc:SetJustifyH("LEFT")
	desc:Width(420)
	WF.SetFont(desc, nil, "-1")
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
	WF.SetFont(largeTip, nil, "7")
	largeTip:SetText(
		format(
			"%s %s %s",
			C.StringWithRGB("[", E.db.general.valuecolor),
			L["Choose the module you would like to |cff00ff00use|r"],
			C.StringWithRGB("]", E.db.general.valuecolor)
		)
	)
	largeTip:Point("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)

	local tex = frame:CreateTexture("MERCompatibilityFrameIllustration", "ARTWORK")
	tex:Size(64)
	tex:SetTexture(I.Media.Textures.PepeArt)
	tex:Point("TOPRIGHT", frame, "TOPRIGHT", -20, -25)

	local bottomDesc = frame:CreateFontString(nil, "ARTWORK")
	bottomDesc:FontTemplate()
	bottomDesc:SetJustifyH("LEFT")
	bottomDesc:Width(530)
	WF.SetFont(bottomDesc, nil, "-1")
	bottomDesc:SetText(
		newSignIgnored
			.. format(L["If you find the %s module conflicts with another addon, alert me via Discord."], MER.Title)
			.. "\n"
			.. L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."]
	)
	--bottomDesc:SetText("|cffff0000*|r " .. L["The feature is just a part of that module."])
	bottomDesc:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)

	local completeButton =
		CreateFrame("Button", "MERCompatibilityFrameCompleteButton", frame, "UIPanelButtonTemplate, BackdropTemplate")

	completeButton.Text:SetText(L["Complete"])
	completeButton.Text:SetJustifyH("CENTER")
	completeButton.Text:SetJustifyV("MIDDLE")
	WF.SetFont(completeButton.Text, E.db.general.font, "4")
	completeButton:Size(350, 35)
	completeButton:Point("BOTTOM", bottomDesc, "TOP", 0, 10)
	ES:HandleButton(completeButton)
	completeButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	local scrollFrameParent =
		CreateFrame("ScrollFrame", "MERCompatibilityFrameScrollFrameParent", frame, "UIPanelScrollFrameTemplate")
	scrollFrameParent:CreateBackdrop("Transparent")
	scrollFrameParent:Point("TOPLEFT", largeTip, "BOTTOMLEFT", 0, -10)
	scrollFrameParent:Point("RIGHT", frame, "RIGHT", -32, 0)
	scrollFrameParent:Point("BOTTOM", completeButton, "TOP", 0, 10)
	ES:HandleScrollBar(scrollFrameParent.ScrollBar)

	local scrollFrame = CreateFrame("Frame", "MERCompatibilityFrameScrollFrame", scrollFrameParent)
	scrollFrame:Size(scrollFrameParent:GetSize())

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
	WF.SetFont(leftButton.Text, E.db.general.font)
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
			_G[name]:SetVertexColor(0, 1, 0, 1)
		end
	end)

	local middleTexture =
		frame.scrollFrame:CreateTexture("MERCompatibilityFrameMiddleTexture" .. frame.numModules, "ARTWORK")
	middleTexture:Point("CENTER")
	middleTexture:Size(20)
	middleTexture:SetTexture(I.Media.Icons.Convert)
	middleTexture:SetVertexColor(1, 1, 1, 1)
	middleTexture:Point("CENTER", frame.scrollFrame, "TOP", 0, -frame.numModules * 50 + 25)

	local rightButton = CreateFrame(
		"Button",
		"MERCompatibilityFrameRightButton" .. frame.numModules,
		frame.scrollFrame,
		"UIPanelButtonTemplate, BackdropTemplate"
	)

	rightButton.Text:SetText(format("%s\n%s", data.module2, data.plugin2))
	rightButton.Text:SetJustifyH("CENTER")
	rightButton.Text:SetJustifyV("MIDDLE")
	WF.SetFont(rightButton.Text, E.db.general.font)
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
				WF.Developer.LogWarning("[Compatibility] database path not found\n" .. path)
				return
			end
		end
	end

	return accessTable, accessKey, accessValue
end

--- Creates a compatibility check function for a specific target addon
---@param targetAddonName string The name of the target addon to check compatibility with
---@param targetAddonLocales string The localized name of the target addon
---@return fun(myModuleName: string, targetAddonModuleName: string, myDB: string, targetAddonDB: string)
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
					---@diagnostic disable-next-line: need-check-nil
					myTable[myKey], targetTable[targetKey] = true, false
				end,
				module2 = targetAddonModuleName,
				plugin2 = targetAddonLocales,
				func2 = function()
					---@diagnostic disable-next-line: need-check-nil
					myTable[myKey], targetTable[targetKey] = false, true
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
		"private.mui.quest.objectiveTracker.enable",
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

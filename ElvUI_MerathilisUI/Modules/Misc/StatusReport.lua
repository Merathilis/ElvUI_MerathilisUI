local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

-- This is a changed version of ElvUIs StatusReport
-- Credits to ElvUI's Team
-- File: Core/StatusReport.lua

local wipe, sort, format = wipe, sort, string.format
local next, pairs, ipairs, tinsert = next, pairs, ipairs, tinsert

local CreateFrame = CreateFrame
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata
local GetRealZoneText = GetRealZoneText
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local UNKNOWN = UNKNOWN

local englishClassName = {
	DEATHKNIGHT = "Death Knight",
	DEMONHUNTER = "Demon Hunter",
	DRUID = "Druid",
	EVOKER = "Evoker",
	HUNTER = "Hunter",
	MAGE = "Mage",
	MONK = "Monk",
	PALADIN = "Paladin",
	PRIEST = "Priest",
	ROGUE = "Rogue",
	SHAMAN = "Shaman",
	WARLOCK = "Warlock",
	WARRIOR = "Warrior",
}

local englishSpecName = {
	[250] = "Blood",
	[251] = "Frost",
	[252] = "Unholy",
	[102] = "Balance",
	[103] = "Feral",
	[104] = "Guardian",
	[105] = "Restoration",
	[253] = "Beast Mastery",
	[254] = "Marksmanship",
	[255] = "Survival",
	[62] = "Arcane",
	[63] = "Fire",
	[64] = "Frost",
	[268] = "Brewmaster",
	[270] = "Mistweaver",
	[269] = "Windwalker",
	[65] = "Holy",
	[66] = "Protection",
	[70] = "Retribution",
	[256] = "Discipline",
	[257] = "Holy",
	[258] = "Shadow",
	[259] = "Assasination",
	[260] = "Combat",
	[261] = "Sublety",
	[262] = "Elemental",
	[263] = "Enhancement",
	[264] = "Restoration",
	[265] = "Affliction",
	[266] = "Demonoligy",
	[267] = "Destruction",
	[71] = "Arms",
	[72] = "Fury",
	[73] = "Protection",
	[577] = "Havoc",
	[581] = "Vengeance",
	[1467] = "Devastation",
	[1468] = "Preservation",
	[1473] = "Augmentation",
}

local function getSpecName()
	return englishSpecName[GetSpecializationInfo(GetSpecialization())] or UNKNOWN
end

function module:StatusReportCreateContent(num, width, parent, anchorTo, content)
	if not content then
		content = CreateFrame("Frame", nil, parent)
	end
	content:Size(width, (num * 20) + ((num - 1) * 5))
	content:Point("TOP", anchorTo, "BOTTOM")

	for i = 1, num do
		if not content["Line" .. i] then
			local line = CreateFrame("Frame", nil, content)
			line:Size(width, 20)

			local text = line:CreateFontString(nil, "ARTWORK")
			text:FontTemplate(nil, 14, "OUTLINE", true)
			text:SetAllPoints()
			text:SetJustifyH("LEFT")
			text:SetJustifyV("MIDDLE")
			line.Text = text

			if i == 1 then
				line:Point("TOP", content, "TOP")
			else
				line:Point("TOP", content["Line" .. (i - 1)], "BOTTOM", 0, -5)
			end

			content["Line" .. i] = line
		end
	end

	return content
end

function module:StatusReportCreateSection(
	width,
	height,
	headerWidth,
	headerHeight,
	parent,
	anchor1,
	anchorTo,
	anchor2,
	yOffset
)
	local parentWidth, parentHeight = parent:GetSize()

	if width > parentWidth then
		parent:SetWidth(width + 25)
	end
	if height then
		parent:SetHeight(parentHeight + height)
	end

	local section = CreateFrame("Frame", nil, parent)
	section:Size(width, height or 0)
	section:Point(anchor1, anchorTo, anchor2, 0, yOffset)

	local header = CreateFrame("Frame", nil, section)
	header:Size(headerWidth or width, headerHeight)
	header:Point("TOP", section)
	section.Header = header

	local text = section.Header:CreateFontString(nil, "ARTWORK")
	text:FontTemplate(nil, 18, "NONE", true)
	text:Point("TOP")
	text:Point("BOTTOM")
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	section.Header.Text = text

	local leftDivider = section.Header:CreateTexture(nil, "ARTWORK")
	leftDivider:SetHeight(2)
	leftDivider:Point("LEFT", section.Header, "LEFT", 5, 0)
	leftDivider:Point("RIGHT", section.Header.Text, "LEFT", -5, 0)
	leftDivider:SetTexture(E.media.blankTex)
	leftDivider:SetVertexColor(1, 1, 1, 1)
	F.SetGradientRGB(
		leftDivider,
		"HORIZONTAL",
		I.Strings.Branding.ColorRGBA.r,
		I.Strings.Branding.ColorRGBA.g,
		I.Strings.Branding.ColorRGBA.b,
		0,
		I.Strings.Branding.ColorRGBA.r,
		I.Strings.Branding.ColorRGBA.g,
		I.Strings.Branding.ColorRGBA.b,
		I.Strings.Branding.ColorRGBA.a
	)
	section.Header.LeftDivider = leftDivider

	local rightDivider = section.Header:CreateTexture(nil, "ARTWORK")
	rightDivider:SetHeight(2)
	rightDivider:Point("RIGHT", section.Header, "RIGHT", -5, 0)
	rightDivider:Point("LEFT", section.Header.Text, "RIGHT", 5, 0)
	rightDivider:SetTexture(E.media.blankTex)
	rightDivider:SetVertexColor(1, 1, 1, 1)
	F.SetGradientRGB(
		rightDivider,
		"HORIZONTAL",
		I.Strings.Branding.ColorRGBA.r,
		I.Strings.Branding.ColorRGBA.g,
		I.Strings.Branding.ColorRGBA.b,
		I.Strings.Branding.ColorRGBA.a,
		I.Strings.Branding.ColorRGBA.r,
		I.Strings.Branding.ColorRGBA.g,
		I.Strings.Branding.ColorRGBA.b,
		0
	)
	section.Header.RightDivider = rightDivider

	return section
end

function module:StatusReportCreate()
	-- Main frame
	local statusFrame = CreateFrame("Frame", "MER_StatusReport", E.UIParent)
	statusFrame:Point("CENTER", E.UIParent, "CENTER")
	statusFrame:SetFrameStrata("HIGH")
	statusFrame:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(statusFrame)
	statusFrame:CreateCloseButton()
	statusFrame:SetMovable(true)
	statusFrame:Size(0, 100)
	statusFrame:Hide()

	-- Plugin frame
	local pluginFrame = CreateFrame("Frame", nil, statusFrame)
	pluginFrame:Point("TOPLEFT", statusFrame, "TOPRIGHT", E:Scale(E.Border * 3 + 1), 0)
	pluginFrame:SetFrameStrata("HIGH")
	pluginFrame:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(pluginFrame)
	pluginFrame:Size(0, 25)
	statusFrame.AddOnFrame = pluginFrame

	-- Title logo (drag to move frame)
	local titleLogoFrame = CreateFrame("Frame", nil, statusFrame, "TitleDragAreaTemplate")
	titleLogoFrame:Point("CENTER", statusFrame, "TOP")
	titleLogoFrame:Size(240, 80)
	statusFrame.TitleLogoFrame = titleLogoFrame

	local logoTop = statusFrame.TitleLogoFrame:CreateTexture(nil, "ARTWORK")
	logoTop:Point("CENTER", titleLogoFrame, "TOP", 0, -65)
	logoTop:SetTexture(I.Media.Logos.Logo)
	logoTop:Size(128)
	titleLogoFrame.LogoTop = logoTop

	-- Sections
	statusFrame.Section1 =
		self:StatusReportCreateSection(300, (4 * 30) + 10, nil, 30, statusFrame, "TOP", statusFrame, "TOP", -90)
	statusFrame.Section2 = self:StatusReportCreateSection(
		300,
		(3 * 30) + 10,
		nil,
		30,
		statusFrame,
		"TOP",
		statusFrame.Section1,
		"BOTTOM",
		0
	)
	statusFrame.Section3 = self:StatusReportCreateSection(
		300,
		(5 * 30) + 10,
		nil,
		30,
		statusFrame,
		"TOP",
		statusFrame.Section2,
		"BOTTOM",
		0
	)
	statusFrame.Section4 = self:StatusReportCreateSection(
		300,
		(6 * 30) + 10,
		nil,
		30,
		statusFrame,
		"TOP",
		statusFrame.Section3,
		"BOTTOM",
		0
	)
	pluginFrame.SectionA =
		self:StatusReportCreateSection(280, nil, nil, 30, pluginFrame, "TOP", pluginFrame, "TOP", -10)
	pluginFrame.SectionP =
		self:StatusReportCreateSection(280, nil, nil, 30, pluginFrame, "TOP", pluginFrame.SectionA, "BOTTOM", -30)

	-- Section content
	statusFrame.Section1.Content =
		self:StatusReportCreateContent(4, 260, statusFrame.Section1, statusFrame.Section1.Header)
	statusFrame.Section2.Content =
		self:StatusReportCreateContent(3, 260, statusFrame.Section2, statusFrame.Section2.Header)
	statusFrame.Section3.Content =
		self:StatusReportCreateContent(5, 260, statusFrame.Section3, statusFrame.Section3.Header)
	statusFrame.Section4.Content =
		self:StatusReportCreateContent(6, 260, statusFrame.Section4, statusFrame.Section4.Header)

	-- Content lines
	statusFrame.Section3.Content.Line1.Text:SetFormattedText(
		"Version of WoW: %s",
		F.String.Good(format("%s (build %s)", E.wowpatch, E.wowbuild))
	)
	statusFrame.Section3.Content.Line2.Text:SetFormattedText("Client Language: %s", F.String.Good(E.locale))
	statusFrame.Section3.Content.Line5.Text:SetFormattedText(
		"Using Mac Client: %s",
		(E.isMacClient == true and F.String.Good("Yes") or F.String.Error("No"))
	)
	statusFrame.Section4.Content.Line1.Text:SetFormattedText("Faction: %s", F.String.Good(E.myfaction))
	statusFrame.Section4.Content.Line2.Text:SetFormattedText("Race: %s", F.String.Good(E.myrace))
	statusFrame.Section4.Content.Line3.Text:SetFormattedText("Class: %s", F.String.Good(englishClassName[E.myclass]))

	return statusFrame
end

local function pluginSort(a, b)
	local A, B = a.title or a.name, b.title or b.name
	if A and B then
		return F.String.Strip(A) < F.String.Strip(B)
	end
end

local addOnData = {}
local pluginData = {}

function module:StatusReportUpdate()
	local statusFrame = self.StatusReportFrame
	local addOnFrame = statusFrame.AddOnFrame

	-- Section headers
	statusFrame.Section1.Header.Text:SetText(F.String.ColorFirstLetter("AddOn Info"))
	statusFrame.Section2.Header.Text:SetText(MER.Title .. " " .. F.String.ColorFirstLetter("Settings"))
	statusFrame.Section3.Header.Text:SetText(F.String.ColorFirstLetter("WoW Info"))
	statusFrame.Section4.Header.Text:SetText(F.String.ColorFirstLetter("Character Info"))

	-- Section #1
	statusFrame.Section1.Content.Line1.Text:SetFormattedText("Version of %s: %s", MER.Title, F.String.Good(MER.Version))

	do
		local version = (not E.db.mui.core.lastLayoutVersion or E.db.mui.core.lastLayoutVersion == 0)
				and L["Not Installed"]
			or E.db.mui.core.lastLayoutVersion
		local versionString = (version == L["Not Installed"] or E.db.mui.core.lastLayoutVersion ~= MER.ProfileVersion)
				and F.String.Error(version)
			or F.String.Good(version)
		statusFrame.Section1.Content.Line2.Text:SetFormattedText("Last Profile Version: %s", versionString)
	end

	statusFrame.Section1.Content.Line3.Text:SetFormattedText(
		"Pixel Perfect Scale: %s",
		F.String.Good(E:PixelBestSize())
	)

	do
		local uiScale = E.global.general.UIScale
		local uiScaleString = uiScale == E:PixelBestSize() and F.String.Good(uiScale) or F.String.Error(uiScale)
		statusFrame.Section1.Content.Line4.Text:SetFormattedText("UI Scale Is: %s", uiScaleString)
	end

	-- Section #2
	do
		local Section2 = statusFrame.Section2
		local text

		-- Debug Mode
		do
			text = (not F.Table.IsEmpty(ElvDB.MER.DisabledAddOns)) and F.String.Good("On") or F.String.Error("Off")

			Section2.Content.Line1.Text:SetFormattedText("Debug Mode: %s", text)
		end
	end

	-- Section #3
	do
		local Section3 = statusFrame.Section3
		Section3.Content.Line3.Text:SetFormattedText("Display Mode: %s", F.String.Good(E:GetDisplayMode()))
		Section3.Content.Line4.Text:SetFormattedText("Resolution: %s", F.String.Good(E.resolution))
	end

	-- Section #4
	do
		local Section4 = statusFrame.Section4
		Section4.Content.Line4.Text:SetFormattedText("Specialization: %s", F.String.Good(getSpecName()))
		Section4.Content.Line5.Text:SetFormattedText("Level: %s", F.String.Good(E.mylevel))
		Section4.Content.Line6.Text:SetFormattedText("Zone: %s", F.String.Good(GetRealZoneText() or UNKNOWN))
	end

	-- AddOn Frame
	local AddOnSection = addOnFrame.SectionA
	AddOnSection.Header.Text:SetText(F.String.ColorFirstLetter("AddOns"))

	local PluginSection = addOnFrame.SectionP
	PluginSection.Header.Text:SetText(F.String.ColorFirstLetter("Plugins"))

	do
		wipe(addOnData)

		for _, addOn in ipairs({ "ElvUI", "Details", "BigWigs", "WeakAuras" }) do
			if E:IsAddOnEnabled(addOn) then
				local data = {}
				data.name = F.String.Strip(GetAddOnMetadata(addOn, "Title")) or UNKNOWN
				data.version = F.String.Strip(GetAddOnMetadata(addOn, "Version")) or UNKNOWN

				if data.version == UNKNOWN and addOn == "Details" then
					data.version = Details and Details.version or UNKNOWN
				end

				tinsert(addOnData, data)
			end
		end

		if next(addOnData) then
			sort(addOnData, pluginSort)

			local count = #addOnData
			AddOnSection.Content = self:StatusReportCreateContent(
				count,
				AddOnSection:GetWidth(),
				AddOnSection,
				AddOnSection.Header,
				AddOnSection.Content
			)

			for i = 1, count do
				local data = addOnData[i]
				local name = data.title or data.name
				AddOnSection.Content["Line" .. i].Text:SetFormattedText("%s %s", name, F.String.Good(data.version))
			end

			AddOnSection:SetHeight(count * 25)
		end
	end

	do
		wipe(pluginData)
		for _, data in pairs(E.Libs.EP.plugins) do
			if data and (not data.isLib and (not data.name or data.name ~= MER.AddOnName)) then
				tinsert(pluginData, data)
			end
		end

		if next(pluginData) then
			sort(pluginData, pluginSort)

			local count = #pluginData
			PluginSection.Content = self:StatusReportCreateContent(
				count,
				PluginSection:GetWidth(),
				PluginSection,
				PluginSection.Header,
				PluginSection.Content
			)

			for i = 1, count do
				local data = pluginData[i]
				local name = F.String.Strip(data.title or data.name) or UNKNOWN
				local version = F.String.Strip(data.version) or UNKNOWN
				local versionString = (data.old or version == UNKNOWN) and F.String.Error(version)
					or F.String.Good(version)
				PluginSection.Content["Line" .. i].Text:SetFormattedText("%s %s", name, versionString)
			end

			PluginSection:SetHeight(count * 25)
		end
	end

	if next(addOnData) or next(pluginData) then
		addOnFrame:SetHeight(
			(AddOnSection.Content and (AddOnSection.Content:GetHeight() + 50) or 0)
				+ (PluginSection.Content and (PluginSection.Content:GetHeight() + 50) or 0)
		)
		addOnFrame:Show()
	else
		addOnFrame:Hide()
	end
end

function module:StatusReportShow()
	if not self.StatusReportFrame then
		self.StatusReportFrame = self:StatusReportCreate()
	end

	if not self.StatusReportFrame:IsShown() then
		self:StatusReportUpdate()
		self.StatusReportFrame:Raise()
		self.StatusReportFrame:Show()
	else
		self.StatusReportFrame:Hide()
	end
end

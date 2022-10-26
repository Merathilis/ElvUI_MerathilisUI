local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function ReskinCheckButton(name)
	local gui = _G.TLDRMissionsFrame
	if not gui then
		return
	end

	local frame = gui[name .. "CheckButton"] or gui[name] or _G[name]
	if not frame then
		return
	end

	frame:SetSize(22, 22)
	S:HandleCheckBox(frame)
end

local function ReskinDropdownButton(name)
	local gui = _G.TLDRMissionsFrame
	if not gui then
		return
	end

	local dropDown = gui[name .. "DropDown"] or _G[name]
	if not dropDown then
		return
	end

	dropDown:StripTextures()
	local button = dropDown.Button
	S:HandleButton(button)

	local buttonWidth = button:GetWidth() or 24
	button:SetSize(buttonWidth - 4, buttonWidth - 4)

	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()

	normalTexture:SetTexture(E.Media.Textures.ArrowUp)
	normalTexture:SetRotation(S.ArrowRotation.down)
	normalTexture:SetInside(button, 2, 2)

	pushedTexture:SetTexture(E.Media.Textures.ArrowUp)
	pushedTexture:SetRotation(S.ArrowRotation.down)
	pushedTexture:SetInside(button, 2, 2)
end

local function ReskinMainPanel(gui)
	S:HandleTab(gui.MainTabButton, nil, "Transparent")
	gui.MainTabButton:ClearAllPoints()
	gui.MainTabButton:SetPoint("TOPLEFT", gui, "BOTTOMLEFT", 0, -1)

	local function handleOptionLine(name)
		ReskinCheckButton(name)
		ReskinDropdownButton(name)
		ReskinDropdownButton(name .. "AnimaCost")
	end

	handleOptionLine("Gold")
	handleOptionLine("Anima")
	handleOptionLine("FollowerXPItems")
	handleOptionLine("PetCharms")
	handleOptionLine("AugmentRunes")
	handleOptionLine("Reputation")
	handleOptionLine("FollowerXP")
	handleOptionLine("CraftingCache")
	handleOptionLine("Runecarver")
	handleOptionLine("Campaign")
	handleOptionLine("Gear")
	handleOptionLine("SanctumFeature")
	handleOptionLine("Sacrifice")
	handleOptionLine("AnythingForXP")

	S:HandleButton(gui.CalculateButton)
	S:HandleButton(gui.AbortButton)
	S:HandleButton(gui.SkipCalculationButton)
	S:HandleButton(gui.StartMissionButton)
	S:HandleButton(gui.SkipMissionButton)
	S:HandleButton(gui.CompleteMissionsButton)
end

local function ReskinAdvancedPanel(gui)
	S:HandleTab(gui.AdvancedTabButton, nil, "Transparent")

	S:HandleRadioButton(gui.HardestRadioButton)
	S:HandleRadioButton(gui.EasiestRadioButton)
	S:HandleRadioButton(gui.FewestRadioButton)
	S:HandleRadioButton(gui.MostRadioButton)
	S:HandleRadioButton(gui.LowestRadioButton)
	S:HandleRadioButton(gui.HighestRadioButton)
	S:HandleSliderFrame(gui.MinimumTroopsSlider)

	ReskinCheckButton("FollowerXPSpecialTreatment")
	ReskinDropdownButton("FollowerXPSpecialTreatment")
	ReskinDropdownButton("FollowerXPSpecialTreatmentAlgorithm")

	S:HandleSliderFrame(gui.LowerBoundLevelRestrictionSlider)
	S:HandleSliderFrame(gui.AnimaCostLimitSlider)
	S:HandleSliderFrame(gui.SimulationsPerFrameSlider)
	S:HandleEditBox(gui.MaxSimulationsEditBox)
	S:HandleSliderFrame(gui.DurationLowerSlider)
	S:HandleSliderFrame(gui.DurationHigherSlider)

	ReskinCheckButton("AutoShowButton")
	ReskinCheckButton("AllowProcessingAnywhereButton")
	ReskinCheckButton("AutoStartButton")
end

local function ReskinProfilePanel(gui)
	S:HandleTab(gui.ProfileTabButton, nil, "Transparent")
end

function module:TLDRDropdown(level)
	local bd = _G["L_TLDR_DropDownList" .. level .. "Backdrop"]
	local mbd = _G["L_TLDR_DropDownList" .. level .. "MenuBackdrop"]
	if bd and not bd.template then
		bd:SetTemplate("Transparent")
		module:CreateShadow(bd)
	end
	if mbd and not mbd.template then
		mbd:SetTemplate("Transparent")
		module:CreateShadow(mbd)
	end
end

function module:TLDRMissions()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.tldr then
		return
	end

	self:TLDRDropdown(1)
	self:TLDRDropdown(2)
	S:HandleButton(_G.TLDRMissionsToggleButton)

	-- Main GUI
	if _G.TLDRMissionsFrame then
		local gui = _G.TLDRMissionsFrame
		S:HandleButton(gui.shortcutButton)
		S:HandleCloseButton(gui.CloseButton)
		gui:StripTextures()
		gui:SetTemplate("Transparent")
		module:CreateShadow(gui)
		gui:Styling()

		-- Main
		ReskinMainPanel(gui)

		-- Advanced
		ReskinAdvancedPanel(gui)

		-- Profile
		ReskinProfilePanel(gui)
	end
end

module:AddCallbackForAddon("TLDRMissions")

-- Completely replace the 'AceGUI:Create' in TLDRMissions standalone libs
if _G.TLDRMissions then
	local aceGUIStandalone = _G.TLDRMissions.LibStub("AceGUI-3.0", true)
	local aceGUIGlobel = _G.LibStub("AceGUI-3.0", true)
	if aceGUIStandalone and aceGUIGlobel then
		aceGUIStandalone.Create = function(_, ...)
			return aceGUIGlobel:Create(...)
		end
	end
end

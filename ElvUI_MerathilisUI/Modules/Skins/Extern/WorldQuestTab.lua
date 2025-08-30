local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local MF = MER:GetModule("MER_MoveFrames") ---@type MoveFrames
local S = E:GetModule("Skins")

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function PositionTabIcons(icon, _, anchor)
	if anchor then
		icon:SetPoint("CENTER")
	end
end

-- Copy from ElvUI WorldMap skin
local function reskinTab(tab)
	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		tab.Icon:ClearAllPoints()
		tab.Icon:SetPoint("CENTER")

		hooksecurefunc(tab.Icon, "SetPoint", PositionTabIcons)
	end

	if tab.Background then
		tab.Background:SetAlpha(0)
	end

	if tab.SelectedTexture then
		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
		tab.SelectedTexture:SetAllPoints()
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.3)
			region:SetAllPoints()
		end
	end

	if tab.backdrop then
		module:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end
end

local function reskinContainer(container)
	container.BorderFrame:Hide()
	container.Background:Hide()
	container:CreateBackdrop("Transparent")
	container.backdrop:SetOutside(container.Background)
	S:HandleTrimScrollBar(container.ScrollBar)
end

local function reskinQuestContainer(container)
	reskinContainer(container)
	S:HandleDropDownBox(container.SortDropdown)
	S:HandleButton(container.FilterDropdown, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
	container.FilterBar:StripTextures()
end

local function reskinWhatsNew(container)
	reskinContainer(container)

	container.CloseButton:Size(20, 20)
	S:HandleCloseButton(container.CloseButton)
end

local function reskinSettings(container)
	reskinContainer(container)
end

local function reskinFlightMapContainer(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	frame.__MERSetPoint = frame.SetPoint
	hooksecurefunc(frame, "SetPoint", function(self)
		F.MoveFrameWithOffset(self, 15, 0)
	end)

	hooksecurefunc(frame, "SetParent", function(self, parent)
		MF:InternalHandle(self, parent)
	end)

	if _G.WQT_FlightMapContainerButton then
		S:HandleButton(_G.WQT_FlightMapContainerButton)
		_G.WQT_FlightMapContainerButton:SetTemplate("Transparent")
		module:CreateShadow(_G.WQT_FlightMapContainerButton)
	end
end

local function settingsCategory(frame)
	if frame.ExpandIcon then
		S:HandleButton(frame, true, nil, nil, true)
		local container = CreateFrame("Frame", nil, frame:GetParent())
		frame.Highlight:SetAlpha(0)
		frame.backdrop:SetInside(frame, 10, 5)

		F.MoveFrameWithOffset(frame.Title, 0, -2)
		return
	end

	if frame.BGRight then
		frame:StripTextures()
		frame:CreateBackdrop()

		frame.HighlightMiddle:SetTexture(E.media.blankTex)
		frame.HighlightMiddle:SetVertexColor(1, 1, 1, 0.2)
		frame.HighlightMiddle:SetAllPoints(frame.backdrop)

		frame.MERSelectedTexture = frame:CreateTexture(nil, "ARTWORK")
		frame.MERSelectedTexture:SetTexture(E.media.blankTex)
		frame.MERSelectedTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
		frame.MERSelectedTexture:SetAlpha(0.5)
		frame.MERSelectedTexture:SetAllPoints(frame.backdrop)
		frame.MERSelectedTexture:Hide()

		frame.BGRight:Hide()
		frame.backdrop:SetPoint("TOPLEFT", frame.BGLeft)
		frame.backdrop:SetPoint("BOTTOMRIGHT", frame.BGRight)
		hooksecurefunc(frame, "SetExpanded", function(self, expanded)
			self.MERSelectedTexture:SetShown(expanded)
		end)
	end
end

local function settingsCheckbox(frame)
	S:HandleCheckBox(frame.CheckBox)
end

local function settingsSlider(frame)
	S:HandleStepSlider(frame.SliderWithSteppers)
	S:HandleNextPrevButton(frame.SliderWithSteppers.Back, "left")
	S:HandleNextPrevButton(frame.SliderWithSteppers.Forward, "right")
	S:HandleEditBox(frame.TextBox)
end

local function settingsColor(frame)
	S:HandleButton(frame.Picker)
	S:HandleButton(frame.ResetButton)
end

local function settingsDropDown(frame)
	S:HandleDropDownBox(frame.Dropdown, frame:GetWidth())
end

local function settingsButton(frame)
	S:HandleButton(frame.Button)
end

local function settingsTextInput(frame)
	S:HandleEditBox(frame.TextBox)
end

local function listButton(button)
	button:CreateBackdrop("Transparent")
	button.Highlight:StripTextures()

	local tex = button.Highlight:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(F.r, F.g, F.b, 0.2)
	tex:SetAllPoints(button.backdrop)
	button.Highlight.MERTex = tex
end

function module:WorldQuestTab()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wqt then
		return
	end

	self:DisableAddOnSkins("WorldQuestTab", true)

	if _G.WQT_QuestMapTab then
		reskinTab(_G.WQT_QuestMapTab)
		_G.WQT_QuestMapTab.__MERSetPoint = _G.WQT_QuestMapTab.SetPoint
		hooksecurefunc(_G.WQT_QuestMapTab, "SetPoint", function()
			F.MoveFrameWithOffset(_G.WQT_QuestMapTab, 0, -2)
		end)
	end

	if _G.WQT_ListContainer then
		reskinQuestContainer(_G.WQT_ListContainer)
	end

	if _G.WQT_WhatsNewFrame then
		reskinWhatsNew(_G.WQT_WhatsNewFrame)
	end

	if _G.WQT_SettingsFrame then
		reskinSettings(_G.WQT_SettingsFrame)
	end

	if _G.WQT_FlightMapContainer then
		reskinFlightMapContainer(_G.WQT_FlightMapContainer)
	end
end

module:AddCallbackForAddon("WorldQuestTab")

local isLoaded, isFinished = C_AddOns_IsAddOnLoaded("WorldQuestTab")
if isLoaded and isFinished then
	local function wrap(func)
		return function(...)
			local args = { ... }
			F.TaskManager:AfterLogin(function()
				if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wqt then
					return
				end
				func(unpack(args))
			end)
		end
	end

	module:TryPostHook("WQT_SettingsCategoryMixin", "Init", wrap(settingsCategory))
	module:TryPostHook("WQT_SettingsCheckboxMixin", "Init", wrap(settingsCheckbox))
	module:TryPostHook("WQT_SettingsSliderMixin", "Init", wrap(settingsSlider))
	module:TryPostHook("WQT_SettingsColorMixin", "Init", wrap(settingsColor))
	module:TryPostHook("WQT_SettingsDropDownMixin", "Init", wrap(settingsDropDown))
	module:TryPostHook("WQT_SettingsButtonMixin", "Init", wrap(settingsButton))
	module:TryPostHook("WQT_SettingsConfirmButtonMixin", "Init", wrap(settingsButton))
	module:TryPostHook("WQT_SettingsTextInputMixin", "Init", wrap(settingsTextInput))
	module:TryPostHook("WQT_ListButtonMixin", "Update", wrap(listButton))
end

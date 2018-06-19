local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERS:UIPanelScrollBarButton(Button)
	Button:SetSize(17, 17)
	Button:SetNormalTexture("")
	Button:SetPushedTexture("")
	Button:SetHighlightTexture("")
end

function MERS:UIPanelScrollUpButtonTemplate(Button)
	MERS:UIPanelScrollBarButton(Button)

	local arrow = Button:CreateTexture(nil, "ARTWORK")
	arrow:SetPoint("TOPLEFT", 4, -6)
	arrow:SetPoint("BOTTOMRIGHT", -5, 7)

	Button._mUIHighlight = {arrow}
end

function MERS:UIPanelScrollDownButtonTemplate(Button)
	MERS:UIPanelScrollBarButton(Button)

	local arrow = Button:CreateTexture(nil, "ARTWORK")
	arrow:SetPoint("TOPLEFT", 4, -7)
	arrow:SetPoint("BOTTOMRIGHT", -5, 6)

	Button._mUIHighlight = {arrow}
end

function MERS:UIPanelScrollBarTemplate(Slider)
	MERS:UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
	MERS:UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)

	Slider.ThumbTexture:SetAlpha(0)
	Slider.ThumbTexture:SetSize(17, 24)

	local thumb = _G.CreateFrame("Frame", nil, Slider)
	thumb:SetPoint("TOPLEFT", Slider.ThumbTexture, 0, -2)
	thumb:SetPoint("BOTTOMRIGHT", Slider.ThumbTexture, 0, 2)
	Slider._mUIThumb = thumb

	Slider:SetWidth(Slider:GetWidth())
end

function MERS:NumericInputSpinnerTemplate(EditBox)
	EditBox:DisableDrawLayer("BACKGROUND")
end
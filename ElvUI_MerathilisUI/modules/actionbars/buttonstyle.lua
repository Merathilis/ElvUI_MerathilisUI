local MER, E, L, V, P, G = unpack(select(2, ...))
local BS = E:NewModule("mUIButtonStyle", "AceEvent-3.0")
local AB = E:GetModule("ActionBars")
local LSM = LibStub("LibSharedMedia-3.0")
BS.modName = L["ButtonStyle"]

--Cache global variables
local pairs, unpack = pairs, unpack
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

function BS:StyleButton(button, noBackdrop, useMasque)
	if (useMasque) then
		return
	end

	if E.db.mui.actionbars.buttonStyle.enabled then
		if not button.overlayGloss then
			local overlay = button:CreateTexture()
			overlay:SetBlendMode("ADD")
			overlay:SetDrawLayer("ARTWORK")
			overlay:SetInside()
			button.overlayGloss = overlay
		end

		button.overlayGloss:SetTexture(LSM:Fetch("statusbar", E.db.mui.actionbars.buttonStyle.texture))
		button.overlayGloss:SetAlpha(E.db.mui.actionbars.buttonStyle.alpha)
		button.overlayGloss:Show()
	else
		if (button.overlayGloss) then
			button.overlayGloss:Hide()
		end
	end
	BS.styledButtons[button] = true
end

function BS:StyleBorder(button, noBackdrop, useMasque)
	if (useMasque) then
		return
	end

	if E.db.mui.actionbars.buttonBorder.enabled then
		if not button.border then
			local border = button:CreateTexture()
			border:SetTexCoord(unpack(E.TexCoords))
			border:SetBlendMode("ADD")
			border:SetDrawLayer("ARTWORK", 0)
			border:SetOutside()
			button.border = border
		end

		button.border:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\abBorder.tga]])
		button.border:SetSize(button:GetSize())
		button.border:ClearAllPoints()
		button.border:SetPoint("CENTER", button, "CENTER", 0, 0)
	else
		if (button.border) then
			button.border:Hide()
		end
	end
	BS.styledButtons[button] = true
end

function BS:BorderColor()
	if E.db.mui.actionbars.buttonBorder.enabled ~= true then return end
	for button, _ in pairs(BS.styledButtons) do
		button.border:SetVertexColor(MER:unpackColor(E.db.mui.actionbars.buttonBorder.color))
	end
end

function BS:UpdateButtons()
	for button, _ in pairs(BS.styledButtons) do
		BS:StyleButton(button)
		BS:StyleBorder(button)
	end
end

BS.styledButtons = {}
function BS:Initialize()
	hooksecurefunc(AB, "StyleButton", BS.StyleButton)
	hooksecurefunc(AB, "StyleButton", BS.StyleBorder)

	AB:UpdateButtonSettings()
	BS:BorderColor()
end

E:RegisterModule(BS:GetName())
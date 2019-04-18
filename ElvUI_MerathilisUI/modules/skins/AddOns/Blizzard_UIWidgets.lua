local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleUIWidgets()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.muiSkins.blizzard.warboard ~= true then return end

	-- Used for Currency Fonts (Warfront only?)
	hooksecurefunc(UIWidgetBaseCurrencyTemplateMixin, "SetFontColor", function(self)
		self.Text:SetTextColor(1, 1, 1)
		self.LeadingText:SetTextColor(1, 1, 1)
	end)
end

S:AddCallbackForAddon("Blizzard_UIWidgets", "mUIUIWidgets", styleUIWidgets)

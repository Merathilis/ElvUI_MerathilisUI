local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

local function LoadAddOnSkin()
	if E.private.muiSkins.addonSkins.tb ~= true then return; end

	local frame = _G.TextureBrowser
	frame:StripTextures()

	frame:CreateBackdrop("Transparent")
	frame.backdrop:Styling()
	frame.outline:SetTemplate("Transparent")

	S:HandleCloseButton(frame.close)
	S:HandleScrollBar(_G.TextureBrowserScrollScrollBar)
	S:HandleButton(frame.btnFilter)
end

S:AddCallbackForAddon("TextureBrowser", "mUITextureBrowser", LoadAddOnSkin)

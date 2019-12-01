local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gbank ~= true or E.private.muiSkins.blizzard.gbank ~= true then return end

	_G.GuildBankFrame:Styling()

	--Popup
	_G.GuildBankPopupFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_GuildBankUI", "mUIGuildBank", LoadSkin)

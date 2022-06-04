local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildcontrol ~= true or E.private.mui.skins.blizzard.guildcontrol ~= true then return end

	_G.GuildControlUI:Styling()
	MER:CreateBackdropShadow(_G.GuildControlUI)
end

S:AddCallbackForAddon("Blizzard_GuildControlUI", LoadSkin)

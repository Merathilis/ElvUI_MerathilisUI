local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_GuildControlUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildcontrol ~= true or E.private.mui.skins.blizzard.guildcontrol ~= true then return end

	_G.GuildControlUI:Styling()
	MER:CreateBackdropShadow(_G.GuildControlUI)
end

module:AddCallbackForAddon("Blizzard_GuildControlUI")

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_GuildControlUI()
	if not module:CheckDB("guildcontrol", "guildcontrol") then
		return
	end

	module:CreateBackdropShadow(_G.GuildControlUI)
end

module:AddCallbackForAddon("Blizzard_GuildControlUI")

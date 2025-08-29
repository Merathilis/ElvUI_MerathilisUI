local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_GuildControlUI()
	if not module:CheckDB("guildcontrol", "guildcontrol") then
		return
	end

	module:CreateBackdropShadow(_G.GuildControlUI)
end

module:AddCallbackForAddon("Blizzard_GuildControlUI")

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_Soulbinds()
	if not module:CheckDB("soulbinds", "soulbinds") then
		return
	end

	local frame = _G.SoulbindViewer
	frame.Background:Hide()
	module:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon('Blizzard_Soulbinds')

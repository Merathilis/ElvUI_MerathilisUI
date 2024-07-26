local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_Soulbinds()
	if not module:CheckDB("soulbinds", "soulbinds") then
		return
	end

	local frame = _G.SoulbindViewer
	frame.Background:Hide()
	module:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon("Blizzard_Soulbinds")

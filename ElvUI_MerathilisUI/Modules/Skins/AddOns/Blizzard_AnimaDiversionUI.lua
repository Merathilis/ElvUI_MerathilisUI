local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_AnimaDiversionUI()
	if not module:CheckDB("animaDiversion", "animaDiversion") then
		return
	end

	local frame = _G.AnimaDiversionFrame
	module:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon("Blizzard_AnimaDiversionUI")

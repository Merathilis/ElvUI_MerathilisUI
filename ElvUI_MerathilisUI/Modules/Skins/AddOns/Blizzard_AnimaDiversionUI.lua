local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AnimaDiversionUI()
	if not module:CheckDB("animaDiversion", "animaDiversion") then
		return
	end

	local frame = _G.AnimaDiversionFrame
	module:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon("Blizzard_AnimaDiversionUI")

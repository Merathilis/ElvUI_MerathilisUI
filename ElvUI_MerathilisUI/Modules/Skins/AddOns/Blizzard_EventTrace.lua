local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_EventTrace()
	if not module:CheckDB("debug", "debug") then
		return
	end

	local EventTraceFrame = _G.EventTrace
	module:CreateBackdropShadow(EventTraceFrame)
end

module:AddCallbackForAddon("Blizzard_EventTrace")

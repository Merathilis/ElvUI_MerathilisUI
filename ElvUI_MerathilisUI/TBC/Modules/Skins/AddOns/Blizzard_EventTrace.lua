local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_EventTrace()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or not E.private.mui.skins.blizzard.debug then return end

	local EventTraceFrame = _G.EventTrace
	EventTraceFrame:Styling()
	MER:CreateBackdropShadow(EventTraceFrame)
end

module:AddCallbackForAddon("Blizzard_EventTrace")

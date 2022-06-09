local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("debug", "debug") then
		return
	end

	local EventTraceFrame = _G.EventTrace
	EventTraceFrame:Styling()
	MER:CreateBackdropShadow(EventTraceFrame)
end

S:AddCallbackForAddon("Blizzard_EventTrace", LoadSkin)

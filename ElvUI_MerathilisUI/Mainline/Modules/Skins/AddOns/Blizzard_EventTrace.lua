local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.debug ~= true or E.private.mui.skins.blizzard.debug ~= true then return end

	local EventTraceFrame = _G.EventTrace
	EventTraceFrame:Styling()
	MER:CreateBackdropShadow(EventTraceFrame)
end

S:AddCallbackForAddon("Blizzard_EventTrace", LoadSkin)

local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_TimeManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.mui.skins.blizzard.timemanager ~= true then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	TimeManagerFrame:Styling()
	MER:CreateBackdropShadow(TimeManagerFrame)

	local StopwatchFrame = _G.StopwatchFrame
	StopwatchFrame:Styling()
	MER:CreateBackdropShadow(StopwatchFrame)
end

module:AddCallbackForAddon("Blizzard_TimeManager")

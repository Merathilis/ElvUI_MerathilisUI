local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_TimeManager()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.timemanager) or not E.private.mui.skins.blizzard.timemanager then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	if TimeManagerFrame.backdrop then
		TimeManagerFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(TimeManagerFrame)

	local StopwatchFrame = _G.StopwatchFrame
	StopwatchFrame.backdrop:Styling()
	MER:CreateBackdropShadow(StopwatchFrame)
end

module:AddCallbackForAddon("Blizzard_TimeManager")

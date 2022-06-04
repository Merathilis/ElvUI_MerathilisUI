local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.timemanager) or not E.private.mui.skins.blizzard.timemanager then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	if TimeManagerFrame.backdrop then
		TimeManagerFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(TimeManagerFrame)

	local StopwatchFrame = _G.StopwatchFrame
	if StopwatchFrame.backdrop then
		StopwatchFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(StopwatchFrame)
end

S:AddCallbackForAddon("Blizzard_TimeManager", LoadSkin)

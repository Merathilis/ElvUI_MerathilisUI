local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or not E.private.mui.skins.blizzard.timemanager then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	TimeManagerFrame:Styling()
	MER:CreateBackdropShadow(TimeManagerFrame)

	local StopwatchFrame = _G.StopwatchFrame
	StopwatchFrame:Styling()
	MER:CreateBackdropShadow(StopwatchFrame)
end

S:AddCallbackForAddon("Blizzard_TimeManager", LoadSkin)

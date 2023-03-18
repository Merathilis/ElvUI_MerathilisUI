local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("timemanager", "timemanager") then
		return
	end

	local TimeManagerFrame = _G.TimeManagerFrame
	if TimeManagerFrame.backdrop then
		TimeManagerFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(TimeManagerFrame)

	local StopwatchFrame = _G.StopwatchFrame
	if StopwatchFrame.backdrop then
		StopwatchFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(StopwatchFrame)
end

S:AddCallbackForAddon("Blizzard_TimeManager", LoadSkin)

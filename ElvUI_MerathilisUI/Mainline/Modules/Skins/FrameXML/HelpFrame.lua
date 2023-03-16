local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("help", "help") then
		return
	end

	local frame = _G.HelpFrame
	if frame.backdrop then
		frame.backdrop:Styling()
	end
end

S:AddCallback("HelpFrame", LoadSkin)

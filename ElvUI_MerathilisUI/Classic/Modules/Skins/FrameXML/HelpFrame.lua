local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.help ~= true or E.private.muiSkins.blizzard.help ~= true then return end

	local frame = _G.HelpFrame
	if frame.backdrop then
		frame.backdrop:Styling()
	end
end

S:AddCallback("mUIHelp", LoadSkin)

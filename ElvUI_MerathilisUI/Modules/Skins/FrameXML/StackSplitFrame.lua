local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

function module:StackSplitFrame()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local StackSplitFrame = _G.StackSplitFrame
end

module:AddCallback("StackSplitFrame", LoadSkin)

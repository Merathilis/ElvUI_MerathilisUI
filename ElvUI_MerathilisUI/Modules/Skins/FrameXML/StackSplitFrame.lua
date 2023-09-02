local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local StackSplitFrame = _G.StackSplitFrame
	StackSplitFrame:Styling()
end

S:AddCallback("StackSplitFrame", LoadSkin)

local MER, F, E, L, V, P, G = unpack((select(2, ...)))
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

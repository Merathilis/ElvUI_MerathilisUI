local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local function LoadSkin()
	if not module:CheckDB("arena", "arena") then
		return
	end

	local ArenaFrame = _G.ArenaFrame
	ArenaFrame:Styling()
	module:CreateBackdropShadow(ArenaFrame)
end

S:AddCallback("AddonList", LoadSkin)

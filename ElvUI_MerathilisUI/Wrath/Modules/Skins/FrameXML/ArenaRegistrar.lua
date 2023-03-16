local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local function LoadSkins()
	if not module:CheckDB("arenaRegistrar", "arenaRegistrar") then
		return
	end

	local ArenaRegistrarFrame = _G.ArenaRegistrarFrame
	ArenaRegistrarFrame:Styling()
	module:CreateBackdropShadow(ArenaRegistrarFrame)
end

S:AddCallback("ArenaRegistar", LoadSkin)

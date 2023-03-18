local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local function LoadSkin()
	if not module:CheckDB("bgscore", "bgscore") then
		return
	end

	local WorldStateScoreFrame = _G.WorldStateScoreFrame
	WorldStateScoreFrame:Styling()
	module:CreateBackdropShadow(WorldStateScoreFrame)
end

S:AddCallback("WorldStateFrame", LoadSkin)

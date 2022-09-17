local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')

function module:UnitFrames_UpdateNameSettings(_, f)
	-- if f.shadow then return end

	S:CreateBackdropShadow(f.Health, true)
	if f.USE_PORTRAIT then
		S:CreateBackdropShadow(f.Portrait, true)
	end
end

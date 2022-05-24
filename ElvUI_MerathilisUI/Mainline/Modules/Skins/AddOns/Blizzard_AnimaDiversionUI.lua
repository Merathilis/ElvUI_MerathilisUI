local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AnimaDiversionUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.animaDiversion ~= true or E.private.mui.skins.blizzard.animaDiversion ~= true then return end

	local frame = _G.AnimaDiversionFrame
	frame:Styling()
	MER:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon("Blizzard_AnimaDiversionUI")

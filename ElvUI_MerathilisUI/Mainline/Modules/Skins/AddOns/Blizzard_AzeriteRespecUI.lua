local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.azeriteRespec ~= true or E.private.mui.skins.blizzard.AzeriteRespec ~= true then return end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	AzeriteRespecFrame:Styling()
	MER:CreateBackdropShadow(AzeriteRespecFrame)
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", LoadSkin)

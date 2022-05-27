local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_NewPlayerExperienceGuide()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guide ~= true or E.private.mui.skins.blizzard.guide ~= true then return end

	local frame = _G.GuideFrame
	frame:Styling()
	MER:CreateShadow(frame)
end

module:AddCallbackForAddon("Blizzard_NewPlayerExperienceGuide")

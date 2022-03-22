local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guide ~= true or E.private.muiSkins.blizzard.guide ~= true then return end

	local frame = _G.GuideFrame
	frame:Styling()
	MER:CreateShadow(frame)
end

S:AddCallbackForAddon("Blizzard_NewPlayerExperienceGuide", "muiGuide", LoadSkin)

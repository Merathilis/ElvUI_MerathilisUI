local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_NewPlayerExperienceGuide()
	if not module:CheckDB("guide", "guide") then
		return
	end

	local frame = _G.GuideFrame
	module:CreateShadow(frame)
end

module:AddCallbackForAddon("Blizzard_NewPlayerExperienceGuide")

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_NewPlayerExperienceGuide()
	if not module:CheckDB("guide", "guide") then
		return
	end

	local frame = _G.GuideFrame
	module:CreateShadow(frame)
end

module:AddCallbackForAddon("Blizzard_NewPlayerExperienceGuide")

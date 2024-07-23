local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:ProfessionsBookFrame()
	if not module:CheckDB("spellbook", "spellbook") then
		return
	end

	local ProfessionsBookFrame = _G.ProfessionsBookFrame
	module:CreateShadow(ProfessionsBookFrame)
end

module:AddCallback("ProfessionsBookFrame")

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_ProfessionsBook()
	if not module:CheckDB("spellbook", "professionBook") then
		return
	end

	local ProfessionsBookFrame = _G.ProfessionsBookFrame
	module:CreateShadow(ProfessionsBookFrame)
end

module:AddCallbackForAddon("Blizzard_ProfessionsBook")

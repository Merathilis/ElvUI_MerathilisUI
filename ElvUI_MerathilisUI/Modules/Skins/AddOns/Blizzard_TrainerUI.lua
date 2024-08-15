local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_TrainerUI()
	if not module:CheckDB("trainer", "trainer") then
		return
	end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	module:CreateShadow(ClassTrainerFrame)
end

module:AddCallbackForAddon("Blizzard_TrainerUI")

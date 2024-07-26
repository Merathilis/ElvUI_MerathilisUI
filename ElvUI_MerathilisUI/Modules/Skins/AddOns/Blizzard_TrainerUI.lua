local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_TrainerUI()
	if not module:CheckDB("trainer", "trainer") then
		return
	end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	module:CreateShadow(ClassTrainerFrame)

	hooksecurefunc(ClassTrainerFrame.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local button = select(i, self.ScrollTarget:GetChildren())
			if not button.isStyled then
				if button and button.backdrop then
					module:CreateGradient(button.backdrop)
				end
				button.isStyled = true
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_TrainerUI")

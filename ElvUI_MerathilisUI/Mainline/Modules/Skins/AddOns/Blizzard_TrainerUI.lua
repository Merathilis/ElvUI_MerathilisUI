local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("trainer", "trainer") then
		return
	end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	ClassTrainerFrame:Styling()
	module:CreateShadow(ClassTrainerFrame)

	hooksecurefunc(ClassTrainerFrame.ScrollBox, 'Update', function(self)
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

S:AddCallbackForAddon("Blizzard_TrainerUI", LoadSkin)

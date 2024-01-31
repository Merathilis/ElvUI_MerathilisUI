local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local hooksecurefunc = hooksecurefunc

function module:CinematicFrame()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc('CinematicFrame_UpdateLettboxForAspectRatio', function(s)
		if s and s.closeDialog and not s.closeDialog.__MERSkin then
			if s.closeDialog then
				module:CreateShadow(s.closeDialog)

				s.closeDialog.__MERSkin = true
			end
		end
	end)

	hooksecurefunc('MovieFrame_PlayMovie', function(s)
		if s and s.CloseDialog and not s.CloseDialog.__MERSkin then
			if s.CloseDialog then
				module:CreateShadow(s.closeDialog)

				s.CloseDialog.__MERSkin = true
			end
		end
	end)
end

module:AddCallback("CinematicFrame")

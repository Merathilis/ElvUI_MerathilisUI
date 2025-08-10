local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:LossOfControlFrame()
	if not self:CheckDB("losscontrol", "lossOfControl") then
		return
	end

	module:SecureHook(_G.LossOfControlFrame, "SetUpDisplay", function(s)
		if not s then
			return
		end
		s.Icon:ClearAllPoints()
		s.Icon:Point("LEFT", s, "LEFT", 0, 0)

		if not s.Icon.backdrop then
			s.Icon:CreateBackdrop()
		end
		self:CreateBackdropShadow(s.Icon, true)

		s.AbilityName:ClearAllPoints()
		s.AbilityName:Point("TOPLEFT", s.Icon, "TOPRIGHT", 10, 0)

		s.TimeLeft:ClearAllPoints()
		s.TimeLeft.NumberText:ClearAllPoints()
		s.TimeLeft.NumberText:Point("BOTTOMLEFT", s.Icon, "BOTTOMRIGHT", 10, 0)

		s.TimeLeft.SecondsText:ClearAllPoints()
		s.TimeLeft.SecondsText:Point("TOPLEFT", s.TimeLeft.NumberText, "TOPRIGHT", 3, 0)

		s:Size(s.Icon:GetWidth() + 10 + s.AbilityName:GetWidth(), s.Icon:GetHeight())
	end)
end

module:AddCallback("LossOfControlFrame")

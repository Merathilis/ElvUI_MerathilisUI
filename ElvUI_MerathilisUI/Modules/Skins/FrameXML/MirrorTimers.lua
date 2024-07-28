local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:MirrorTimers()
	if not self:CheckDB("mirrorTimers") then
		return
	end

	hooksecurefunc(_G.MirrorTimerContainer, "SetupTimer", function(container, timer)
		local bar = container:GetAvailableTimer(timer)
		if not bar then
			return
		end

		self:CreateShadow(bar)
	end)
end

module:AddCallback("MirrorTimers")

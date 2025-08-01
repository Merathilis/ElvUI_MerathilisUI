local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local TT = E:GetModule("Tooltip")

function module:LibQTip()
	-- Handle RareScanner's custom LibQTip-1.0RS tooltips
	local LQTRS = LibStub("LibQTip-1.0RS", true)
	if LQTRS then
		hooksecurefunc(LQTRS, "Acquire", function()
			for _, tooltip in LQTRS:IterateTooltips() do
				TT:SetStyle(tooltip)
			end
		end)
	end

	-- Handle LibQTip-1.0 tooltips
	local LQT = LibStub("LibQTip-1.0", true)
	if LQT then
		hooksecurefunc(LQT, "Acquire", function()
			for _, tooltip in LQT:IterateTooltips() do
				TT:SetStyle(tooltip)
			end
		end)
	end
end

module:AddCallback("LibQTip")

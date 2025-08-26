local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local TT = E:GetModule("Tooltip")

local _G = _G

local hooksecurefunc = hooksecurefunc

local function reskinLib(self)
	for _, tooltip in self:IterateTooltips() do
		TT:SetStyle(tooltip)
	end
end

function module:LibQTip()
	local LQT = _G.LibStub("LibQTip-1.0", true)
	if LQT then
		hooksecurefunc(LQT, "Acquire", reskinLib)
	end

	local LQTRS = _G.LibStub("LibQTip-1.0RS", true)
	if LQTRS then
		hooksecurefunc(LQTRS, "Acquire", reskinLib)
	end
end

module:AddCallback("LibQTip")

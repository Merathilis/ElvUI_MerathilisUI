local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:HelpFrame()
	if not module:CheckDB("help", "help") then
		return
	end

	local frame = _G.HelpFrame
	module:CreateBackdropShadow(frame)
end

module:AddCallback("HelpFrame")

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:RaidFrame()
	if not module:CheckDB("raid", "raid") then
		return
	end

	local RaidInfoFrame = _G.RaidInfoFrame
	module:CreateShadow(RaidInfoFrame)
end

module:AddCallback("RaidFrame")

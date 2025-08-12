local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:StackSplitFrame()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local StackSplitFrame = _G.StackSplitFrame
end

module:AddCallback("StackSplitFrame")

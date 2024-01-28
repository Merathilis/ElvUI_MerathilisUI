local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:HelpFrame()
	if not module:CheckDB("help", "help") then
		return
	end

	local frame = _G.HelpFrame
end

module:AddCallback("HelpFrame")

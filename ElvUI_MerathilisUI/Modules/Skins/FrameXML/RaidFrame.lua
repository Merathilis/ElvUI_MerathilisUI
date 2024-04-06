local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not module:CheckDB("raid", "raid") then
		return
	end

	local RaidInfoFrame = _G.RaidInfoFrame
	module:CreateShadow(RaidInfoFrame)
end

S:AddCallback("RaidFrame", LoadSkin)

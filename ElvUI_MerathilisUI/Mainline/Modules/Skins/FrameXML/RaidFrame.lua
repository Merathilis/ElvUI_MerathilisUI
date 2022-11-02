local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("raid", "raid") then
		return
	end

	local RaidInfoFrame = _G.RaidInfoFrame
	RaidInfoFrame:Styling()

	module:CreateShadow(RaidInfoFrame)
end

S:AddCallback("RaidFrame", LoadSkin)

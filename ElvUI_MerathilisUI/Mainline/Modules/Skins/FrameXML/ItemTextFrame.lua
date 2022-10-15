local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local ItemTextFrame = _G.ItemTextFrame
	ItemTextFrame:Styling()
end

S:AddCallback("ItemTextFrame", LoadSkin)

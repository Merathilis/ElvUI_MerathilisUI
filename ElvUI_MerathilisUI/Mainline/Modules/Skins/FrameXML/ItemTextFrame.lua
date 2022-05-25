local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:ItemTextFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or not E.private.mui.skins.blizzard.gossip then return end

	local ItemTextFrame = _G.ItemTextFrame
	ItemTextFrame:Styling()
end

module:AddCallback("ItemTextFrame")

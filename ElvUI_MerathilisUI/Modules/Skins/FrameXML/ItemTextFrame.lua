local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:ItemTextFrame()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local ItemTextFrame = _G.ItemTextFrame

	_G.ItemTextPageText:SetTextColor("P", 1, 1, 1)
	_G.ItemTextPageText.SetTextColor = E.noop
end

module:AddCallback("ItemTextFrame")

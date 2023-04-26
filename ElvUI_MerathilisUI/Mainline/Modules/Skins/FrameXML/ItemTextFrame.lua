local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local ItemTextFrame = _G.ItemTextFrame
	ItemTextFrame:Styling()

	_G.ItemTextPageText:SetTextColor("P", 1, 1, 1)
	_G.ItemTextPageText.SetTextColor = E.noop
end

S:AddCallback("ItemTextFrame", LoadSkin)

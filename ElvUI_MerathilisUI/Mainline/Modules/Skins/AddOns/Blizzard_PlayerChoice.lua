local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("playerChoice", "playerChoice") then
		return
	end

	local frame = _G.PlayerChoiceFrame
	-- frame:Styling()
end

module:AddCallbackForAddon("Blizzard_PlayerChoice", LoadSkin)

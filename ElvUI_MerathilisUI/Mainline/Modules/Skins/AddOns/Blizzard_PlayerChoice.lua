local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_PlayerChoice()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.playerChoice) or E.private.mui.skins.blizzard.playerChoice ~= true then return end

	local frame = _G.PlayerChoiceFrame

	if frame.backdrop then
		frame.backdrop:Styling()
	end
end

module:AddCallbackForAddon("Blizzard_PlayerChoice")

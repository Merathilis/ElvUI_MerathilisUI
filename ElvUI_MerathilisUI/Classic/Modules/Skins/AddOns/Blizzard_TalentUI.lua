local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_TalentUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.talent) or not E.private.mui.skins.blizzard.talent then return end

	local PlayerTalentFrame = _G.PlayerTalentFrame
	if PlayerTalentFrame.backdrop then
		PlayerTalentFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.PlayerTalentFrame)
end

module:AddCallbackForAddon("Blizzard_TalentUI")

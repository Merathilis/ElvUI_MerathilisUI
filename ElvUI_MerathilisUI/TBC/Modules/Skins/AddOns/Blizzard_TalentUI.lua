local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.talent) or E.private.mui.skins.blizzard.talent ~= true then return end

	local PlayerTalentFrame = _G.PlayerTalentFrame
	PlayerTalentFrame.backdrop:Styling()
	MER:CreateBackdropShadow(_G.PlayerTalentFrame)
end

S:AddCallbackForAddon("Blizzard_TalentUI", "mUITalents", LoadSkin)

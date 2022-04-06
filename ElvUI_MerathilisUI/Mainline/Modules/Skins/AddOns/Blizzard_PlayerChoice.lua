local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local next, select = next, select

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local IsInJailersTower = IsInJailersTower

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.playerChoice) or E.private.muiSkins.blizzard.playerChoice ~= true then return end

	local frame = _G.PlayerChoiceFrame

	if frame.backdrop then
		frame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_PlayerChoice", "mUIPlayerChoice", LoadSkin)

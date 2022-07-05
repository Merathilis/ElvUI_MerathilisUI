local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function SkinPlayerChoice(frame)
	if frame.MERStyle or not module:CheckDB("playerChoice", "playerChoice") then return end

	if not S.PlayerChoice_TextureKits[frame.uiTextureKit] then
		frame:Styling()
	end

	frame.MERStyle = true
end

local function LoadSkin()
	if not module:CheckDB("playerChoice", "playerChoice") then
		return
	end

	local frame = _G.PlayerChoiceFrame
	-- frame:Styling()
end

hooksecurefunc(S, 'PlayerChoice_SetupOptions', SkinPlayerChoice)
-- module:AddCallbackForAddon("Blizzard_PlayerChoice", LoadSkin)

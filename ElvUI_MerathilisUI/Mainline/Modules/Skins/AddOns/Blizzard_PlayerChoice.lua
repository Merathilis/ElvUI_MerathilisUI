local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local useTextureKit = {
	jailerstower = true,
	cypherchoice = true
}

local function ChangeOptions(frame)
	if frame.MERStyle then return end

	local kit = useTextureKit[frame.uiTextureKit]

	if not kit then
		frame:Styling()
	end

	frame.MERStyle = true
end

local function LoadSkin()
	if not module:CheckDB("playerChoice", "playerChoice") then
		return
	end

	local frame = _G.PlayerChoiceFrame
	hooksecurefunc(frame, 'SetupOptions', ChangeOptions)
end

S:AddCallbackForAddon("Blizzard_PlayerChoice", LoadSkin)

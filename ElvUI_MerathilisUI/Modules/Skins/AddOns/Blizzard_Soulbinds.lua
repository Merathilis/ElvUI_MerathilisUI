local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.soulbinds) or E.private.muiSkins.blizzard.soulbinds ~= true then return end

	local frame = _G.SoulbindViewer
	frame.Background:Hide()
	frame:Styling()
	MER:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon('Blizzard_Soulbinds', "mUISoulbinds", LoadSkin)

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("soulbinds", "soulbinds") then
		return
	end

	local frame = _G.SoulbindViewer
	frame.Background:Hide()
	frame:Styling()
	module:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon('Blizzard_Soulbinds', LoadSkin)

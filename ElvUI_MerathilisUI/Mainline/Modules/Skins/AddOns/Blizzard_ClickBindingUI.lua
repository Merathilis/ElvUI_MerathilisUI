local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("binding", "binding") then
		return
	end

	local frame = _G.ClickBindingFrame
	frame:Styling()
	module:CreateShadow(frame)
end

S:AddCallbackForAddon("Blizzard_ClickBindingUI", LoadSkin)

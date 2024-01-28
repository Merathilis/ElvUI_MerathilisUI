local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:Blizzard_ClickBindingUI()
	if not module:CheckDB("binding", "binding") then
		return
	end

	local frame = _G.ClickBindingFrame
	module:CreateShadow(frame)
end

module:AddCallbackForAddon("Blizzard_ClickBindingUI")

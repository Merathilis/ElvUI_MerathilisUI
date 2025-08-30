local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_ClickBindingUI()
	if not module:CheckDB("binding", "binding") then
		return
	end

	local frame = _G.ClickBindingFrame
	module:CreateShadow(frame)
end

module:AddCallbackForAddon("Blizzard_ClickBindingUI")

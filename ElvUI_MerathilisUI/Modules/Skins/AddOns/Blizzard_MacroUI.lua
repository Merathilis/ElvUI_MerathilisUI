local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_MacroUI()
	if not module:CheckDB("macro", "macro") then
		return
	end

	local MacroFrame = _G.MacroFrame
	module:CreateShadow(MacroFrame)

	local MacroPopupFrame = _G.MacroPopupFrame
	module:CreateShadow(MacroPopupFrame)
end

module:AddCallbackForAddon("Blizzard_MacroUI")

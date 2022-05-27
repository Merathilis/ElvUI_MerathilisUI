local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_MacroUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true or E.private.mui.skins.blizzard.macro ~= true then return end

	local MacroFrame = _G.MacroFrame
	if MacroFrame.backdrop then
		MacroFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.MacroFrame)

	_G.MacroPopupFrame:Styling()
	MER:CreateBackdropShadow(_G.MacroPopupFrame)
end

module:AddCallbackForAddon("Blizzard_MacroUI")

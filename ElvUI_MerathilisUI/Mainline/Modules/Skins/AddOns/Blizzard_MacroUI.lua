local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("macro", "macro") then
		return
	end

	local MacroFrame = _G.MacroFrame
	MacroFrame:Styling()
	module:CreateShadow(MacroFrame)

	local MacroPopupFrame = _G.MacroPopupFrame
	module:CreateShadow(MacroPopupFrame)
	MacroPopupFrame:HookScript('OnShow', function(frame)
		if not frame.__MERSkin then
			frame:Styling()
			frame.__MERSkin = true
		end
	end)
end

S:AddCallbackForAddon("Blizzard_MacroUI", LoadSkin)

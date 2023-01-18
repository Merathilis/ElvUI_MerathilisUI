local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local M = E:GetModule("Misc")

local _G = _G

function module:ElvUI_LootRoll()
	if not (E.private.general.lootRoll or E.private.mui.skins.shadow.enable) then
		return
	end

	module:SecureHook(M, "LootRoll_Create", function(_, index)
		local frame = _G["ElvUI_LootRollFrame" .. index]
		if frame and not frame.__MERSkin then
			module:CreateShadow(frame)
			frame.__MERSkin = true
		end
	end)
end

module:AddCallback("ElvUI_LootRoll")

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local M = E:GetModule("Misc")

local _G = _G
local pairs = pairs

function module:ElvUI_SkinLootRollFrame(frame)
	if not frame or frame:IsForbidden() or frame.__MERSkin then
		return
	end

	self:CreateBackdropShadow(frame.button)
	self:CreateBackdropShadow(frame.status)

	F.InternalizeMethod(frame.button, "SetPoint")
	F.Move(frame.button, -4, 0)
	hooksecurefunc(frame.button, "SetPoint", function()
		F.Move(frame.button, -4, 0)
	end)

	frame.__MERSkin = true
end

function module:ElvUI_LootRoll()
	if not (E.private.general.lootRoll or E.private.mui.skins.shadow.enable) then
		return
	end

	self:SecureHook(M, "LootRoll_Create", function(_, index)
		self:ElvUI_SkinLootRollFrame(_G["ElvUI_LootRollFrame" .. index])
	end)

	for _, bar in pairs(M.RollBars) do
		self:ElvUI_SkinLootRollFrame(bar)
	end
end

module:AddCallback("ElvUI_LootRoll")

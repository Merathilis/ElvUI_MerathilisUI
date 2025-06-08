local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local AB = E:GetModule("ActionBars")
local S = E:GetModule("Skins")

function module:tdBattlePetScript()
	if not E:IsAddOnEnabled("tdBattlePetScript") then
		return
	end

	local button = _G.tdBattlePetScriptAutoButton
	if button then
		S:HandleButton(button)
		print("Button is here")
	end
end

function module:Initialize()
	if not E.private.actionbar.enable then
		return
	end

	local db = E.db.mui.actionbars

	self:CreateSpecBar()
	self:ColorModifiers()
	self:tdBattlePetScript()
end

MER:RegisterModule(module:GetName())

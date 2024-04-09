local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Automation")

local _G = _G
local securecall = securecall

local AcceptResurrect = AcceptResurrect
local HideUIPanel = HideUIPanel
local UnitAffectingCombat = UnitAffectingCombat
local UnitExists = UnitExists
local PlayerCanTeleport = PlayerCanTeleport
local StaticPopup_Hide = StaticPopup_Hide

local C_SummonInfo_ConfirmSummon = C_SummonInfo.ConfirmSummon

local confirmSummonAfterCombat = false

function module:CANCEL_SUMMON()
	confirmSummonAfterCombat = false
end

function module:CONFIRM_SUMMON()
	if not self.db or not self.db.confirmSummon then
		return
	end

	if confirmSummonAfterCombat then
		return
	end

	if UnitAffectingCombat("player") or not PlayerCanTeleport() then
		confirmSummonAfterCombat = true
		return
	end

	E:Delay(0.6, function()
		C_SummonInfo_ConfirmSummon()
		StaticPopup_Hide("CONFIRM_SUMMON")
	end)
end

function module:PLAYER_REGEN_ENABLED()
	self.isInCombat = false

	if confirmSummonAfterCombat then
		confirmSummonAfterCombat = false
		if self.db and self.db.confirmSummon then
			C_SummonInfo_ConfirmSummon()
			StaticPopup_Hide("CONFIRM_SUMMON")
		end
	end
end

function module:PLAYER_REGEN_DISABLED()
	self.isInCombat = true

	if self.db.hideWorldMapAfterEnteringCombat and _G.WorldMapFrame:IsShown() then
		HideUIPanel(_G.WorldMapFrame)
	end

	if self.db.hideBagAfterEnteringCombat then
		securecall("CloseAllBags")
	end
end

function module:RESURRECT_REQUEST(_, inviterName)
	local inviterIsInCombat = UnitAffectingCombat(inviterName)
	local bossIsInCombat = UnitExists("boss1") and UnitAffectingCombat("boss1")

	if self.isInCombat or inviterIsInCombat or bossIsInCombat then
		if self.db.acceptCombatResurrect then
			AcceptResurrect()
		end
	else
		if self.db.acceptResurrect then
			AcceptResurrect()
		end
	end
end

function module:Initialize()
	self.db = E.db.mui.misc.automation
	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("CONFIRM_SUMMON")
	self:RegisterEvent("CANCEL_SUMMON")
end

function module:ProfileUpdate()
	self.db = E.db.mui.misc.automation

	if self.db and not self.db.enable and self.initialized then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("RESURRECT_REQUEST")
	end
end

MER:RegisterModule(module:GetName())

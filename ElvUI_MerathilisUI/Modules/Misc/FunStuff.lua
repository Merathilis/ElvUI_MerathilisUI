local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G
local random = math.random
local InCombatLockdown = InCombatLockdown
local UnitExists = UnitExists

--[[
##########################################################
	NPC Animations -- Credits SupervillianUI
##########################################################
]]
--

module.NPC = _G["MER_NPCFrame"]

local talkAnims = { 60, 64, 65, 67 }

local function NPCTalking()
	local timer = 0
	local sequence = random(1, #talkAnims)
	module.NPC.Model:ClearModel()
	module.NPC.Model:SetUnit("target")
	module.NPC.Model:SetCamDistanceScale(1.2)
	module.NPC.Model:SetPortraitZoom(0.95)
	module.NPC.Model:SetPosition(0, 0, 0)
	module.NPC.Model:SetAnimation(talkAnims[sequence], 0)
	module.NPC.Model:SetScript("OnUpdate", function(self, e)
		if timer < 2000 then
			timer = (timer + (e * 1000))
		else
			timer = 0
			self:ClearModel()
			self:SetUnit("player")
			self:SetCamDistanceScale(1)
			self:SetPortraitZoom(0.95)
			self:SetPosition(0.15, 0, 0)
			self:SetRotation(-1)
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
		end
	end)
end

local function PlayerTalking()
	local timer = 0
	local sequence = random(1, #talkAnims)
	module.NPC.Model:ClearModel()
	module.NPC.Model:SetUnit("player")
	module.NPC.Model:SetCamDistanceScale(1)
	module.NPC.Model:SetPortraitZoom(0.95)
	module.NPC.Model:SetPosition(0.15, 0, 0)
	module.NPC.Model:SetRotation(-1)
	module.NPC.Model:SetAnimation(talkAnims[sequence], 0)
	module.NPC.Model:SetScript("OnUpdate", function(self, e)
		if timer < 2000 then
			timer = (timer + (e * 1000))
		else
			timer = 0
			if UnitExists("target") then
				self:ClearModel()
				self:SetUnit("target")
				self:SetCamDistanceScale(1)
				self:SetPortraitZoom(0.95)
				self:SetPosition(0, 0, 0)
				self:SetRotation(0)
			end
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
		end
	end)
end

function module.NPC:NPCTalksFirst()
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then
		return
	end

	local timer = 0
	self.Model:ClearModel()
	self.Model:SetUnit("target")
	self.Model:SetCamDistanceScale(1.2)
	self.Model:SetPortraitZoom(0.95)
	self.Model:SetPosition(0, 0, 0)
	self.Model:SetRotation(0)
	self.Model:SetAnimation(67)
	self.Model:SetScript("OnUpdate", function(self, e)
		if timer < 2000 then
			timer = (timer + (e * 1000))
		else
			timer = 0
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
			PlayerTalking()
		end
	end)
end

function module.NPC:PlayerTalksFirst()
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then
		return
	end

	local timer = 0
	self.Model:ClearModel()
	self.Model:SetUnit("player")
	self.Model:SetCamDistanceScale(1)
	self.Model:SetPortraitZoom(0.95)
	self.Model:SetPosition(0.15, 0, 0)
	self.Model:SetRotation(-1)
	self.Model:SetAnimation(67)
	self.Model:SetScript("OnUpdate", function(self, e)
		if timer < 2000 then
			timer = (timer + (e * 1000))
		else
			timer = 0
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
			NPCTalking()
		end
	end)
end

local SetNPCText = function(self, text)
	self:Hide()
	module.NPC.InfoTop.Text:SetText(text)
	module.NPC.InfoTop:Show()
end

function module.NPC:Toggle(parentFrame)
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then
		return
	end

	local timer = 0
	if parentFrame then
		self:SetParent(parentFrame)
		self:ClearAllPoints()
		self:SetAllPoints(parentFrame)
		self:Show()
		self:SetAlpha(1)

		self.Model:ClearModel()
		self.Model:SetUnit("target")
		self.Model:SetCamDistanceScale(1)
		self.Model:SetPortraitZoom(0.95)
		self.Model:SetPosition(0, 0, 0)

		module.NPC:NPCTalksFirst()
	else
		self.Model:SetScript("OnUpdate", nil)
		self:SetAlpha(0)
		self:Hide()
	end
end

function module.NPC:Register(parentFrame, textFrame)
	parentFrame:HookScript("OnShow", function()
		module.NPC:Toggle(parentFrame)
	end)
	parentFrame:HookScript("OnHide", function()
		module.NPC:Toggle()
	end)

	if textFrame and textFrame.SetText then
		hooksecurefunc(textFrame, "SetText", SetNPCText)
	end
end

function module:FunStuff()
	if not E.db.mui.misc.funstuff then
		return
	end

	local npc = module.NPC
	npc.InfoTop = CreateFrame("Frame", nil, npc)
	npc.InfoTop:SetPoint("BOTTOMLEFT", npc.Model, "BOTTOMRIGHT", 2, 22)
	npc.InfoTop:SetSize(196, 98)

	npc.InfoTop.Text = npc.InfoTop:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	npc.InfoTop.Text:SetPoint("TOPLEFT", npc.InfoTop, "TOPLEFT", 0, -33)
	npc.InfoTop.Text:SetPoint("BOTTOMRIGHT", npc.InfoTop, "BOTTOMRIGHT", 0, 0)
end

module:AddCallback("FunStuff")

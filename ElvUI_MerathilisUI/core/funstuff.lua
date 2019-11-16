local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local _G = _G
local random = math.random
-- WoW API / Variables
local InCombatLockdown = InCombatLockdown
local UnitExists = UnitExists
-- GLOBALS:

--[[
##########################################################
NPC Animations -- Credits SupervillianUI
##########################################################
]]--

MER.NPC = _G["MER_NPCFrame"]

local talkAnims = {60, 64, 65, 67}

local function NPCTalking()
	local timer = 0;
	local sequence = random(1, #talkAnims);
	MER.NPC.Model:ClearModel()
	MER.NPC.Model:SetUnit('target')
	MER.NPC.Model:SetCamDistanceScale(1)
	MER.NPC.Model:SetPortraitZoom(0.95)
	MER.NPC.Model:SetPosition(0, 0, 0)
	MER.NPC.Model:SetAnimation(talkAnims[sequence],0)
	MER.NPC.Model:SetScript("OnUpdate", function(self, e)
		if(timer < 2000) then
			timer = (timer + (e*1000))
		else
			timer = 0;
			self:ClearModel()
			self:SetUnit('player')
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
	local timer = 0;
	local sequence = random(1, #talkAnims);
	MER.NPC.Model:ClearModel()
	MER.NPC.Model:SetUnit('player')
	MER.NPC.Model:SetCamDistanceScale(1)
	MER.NPC.Model:SetPortraitZoom(0.95)
	MER.NPC.Model:SetPosition(0.15, 0, 0)
	MER.NPC.Model:SetRotation(-1)
	MER.NPC.Model:SetAnimation(talkAnims[sequence], 0)
	MER.NPC.Model:SetScript("OnUpdate", function(self, e)
		if(timer < 2000) then
			timer = (timer + (e*1000))
		else
			timer = 0;
			if(UnitExists('target')) then
				self:ClearModel()
				self:SetUnit('target')
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

function MER.NPC:NPCTalksFirst()
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then return end
	local timer = 0;
	self.Model:ClearModel()
	self.Model:SetUnit('target')
	self.Model:SetCamDistanceScale(1)
	self.Model:SetPortraitZoom(0.95)
	self.Model:SetPosition(0, 0, 0)
	self.Model:SetRotation(0)
	self.Model:SetAnimation(67)
	self.Model:SetScript("OnUpdate",function(self, e)
		if(timer < 2000) then
			timer = (timer + (e*1000))
		else
			timer = 0;
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
			PlayerTalking()
		end
	end)
end

function MER.NPC:PlayerTalksFirst()
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then return end
	local timer = 0;
	self.Model:ClearModel()
	self.Model:SetUnit('player')
	self.Model:SetCamDistanceScale(1)
	self.Model:SetPortraitZoom(0.95)
	self.Model:SetPosition(0.15, 0, 0)
	self.Model:SetRotation(-1)
	self.Model:SetAnimation(67)
	self.Model:SetScript("OnUpdate",function(self, e)
		if(timer < 2000) then
			timer = (timer + (e*1000))
		else
			timer = 0;
			self:SetAnimation(0)
			self:SetScript("OnUpdate", nil)
			NPCTalking()
		end
	end)
end

function MER.NPC:Toggle(parentFrame)
	if InCombatLockdown() or not E.db.mui.misc.funstuff or not UnitExists("target") then return end
	local timer = 0;
	if(parentFrame) then
		self:SetParent(parentFrame)
		self:ClearAllPoints();
		self:SetAllPoints(parentFrame)
		self:Show();
		self:SetAlpha(1);

		self.Model:ClearModel()
		self.Model:SetUnit('target')
		self.Model:SetCamDistanceScale(1)
		self.Model:SetPortraitZoom(0.95)
		self.Model:SetPosition(0,0,0)

		MER.NPC:NPCTalksFirst()
	else
		self.Model:SetScript("OnUpdate", nil)
		self:SetAlpha(0);
		self:Hide();
	end
end

function MER.NPC:Register(parentFrame)
	parentFrame:HookScript('OnShow', function() MER.NPC:Toggle(parentFrame) end)
	parentFrame:HookScript('OnHide', function() MER.NPC:Toggle() end)
end

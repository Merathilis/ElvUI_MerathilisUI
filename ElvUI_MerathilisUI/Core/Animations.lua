------------------------------------------------------------------------
-- Animation Functions
------------------------------------------------------------------------
local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local assert = assert
local abs, max = math.abs, math.max
-- WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

local function OnUpdate(self)
	if self.parent:GetAlpha() == 0 then
		if InCombatLockdown() and self.lock then return end
		self:Hide()
		self.hiding = false
		self.parent:hide()
	end
end

local function to_hide(self)
	if self.hiding == true then return end
	if self:GetAlpha() == 0 then self:hide() return end
	E:UIFrameFadeOut(self, self.time, self.state_alpha, 0)
	self.hiding = true
	self.pl_watch_frame:Show()
end

local function to_show(self)
	if self:IsShown() and not(self.hiding) then return end
	if self.showing then return end
	self.hiding = false
	self.pl_watch_frame:Hide()
	E:UIFrameFadeIn(self, self.time, 0, self.state_alpha)
end

function MER.Make_plav(self, time, lock, alpha)
	if self.pl_watch_frame then return end

	self.pl_watch_frame = CreateFrame("Frame",nil,self)
	self.pl_watch_frame:Hide()
	self.pl_watch_frame.lock = lock
	self.pl_watch_frame.parent = self
	self.state_alpha = alpha or self:GetAlpha()
	self.hide = self.Hide
	self.time = time
	self.Hide = to_hide
	self.show = to_show
	self.pl_watch_frame:SetScript("OnUpdate", OnUpdate)
end

local function smooth(mode, x, y, z)
	return mode == true and 1 or max((10 + abs(x - y)) / (88.88888 * z), .2) * 1.1
end

function MER:CreatePulse(frame, speed, alpha, mult)
	assert(frame, "doesn't exist!")

	frame.speed = .02
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		elapsed = elapsed * (speed or 5/4)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha*(alpha or 3/5))
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

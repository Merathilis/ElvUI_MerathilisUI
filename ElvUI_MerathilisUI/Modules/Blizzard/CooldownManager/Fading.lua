local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local CM = MER:GetModule("MER_CooldownManager")
local UF = E:GetModule("UnitFrames")

local _G = _G
local pairs = pairs

function CM:SetCooldownFramesVisibility(enable)
	for _, frameName in pairs(self.frameNames) do
		local frame = _G[frameName]
		if frame then
			if enable then
				frame:Show()
			else
				frame:Hide()
			end
		end
	end
end

function CM:SetParent()
	if not self.Initialized then
		return
	end
	if not self.db or not self.db.enable or not self.db.fading then
		return
	end

	local playerFrame = _G["ElvUF_Player"]
	if not playerFrame then
		return
	end

	-- Set parent of cooldown manager frames to player unitframe
	-- This makes them fade together with the player frame
	-- Position is not affected since SetPoint is relative to their anchor, not their parent
	for _, frameName in pairs(self.frameNames) do
		local frame = _G[frameName]
		if frame and frame:GetParent() ~= playerFrame then
			frame:SetParent(playerFrame)
			frame:SetFrameStrata("MEDIUM")
		end
	end
end

function CM:EnableFading()
	if not self.Initialized then
		return
	end

	local playerFrame = _G["ElvUF_Player"]
	if not playerFrame then
		return
	end

	-- Set parent initially
	self:SetParent()

	-- Re-apply parent on zone changes since cooldown manager may reset it
	F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.SetParent, self)
	F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.SetParent, self)

	-- Hook SetAlpha to also toggle visibility when fading
	if not self:IsHooked(playerFrame, "SetAlpha") then
		self:SecureHook(playerFrame, "SetAlpha", function(_, alpha)
			self:SetCooldownFramesVisibility(alpha > 0.1)
		end)
	end
end

function CM:EnableFadingAfterUnitsLoaded()
	-- Enable after units are loaded
	if UF.unitstoload ~= nil then
		self:SecureHook(UF, "LoadUnits", "EnableFading")
	else
		self:EnableFading()
	end
end

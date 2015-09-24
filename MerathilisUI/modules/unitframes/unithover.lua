local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local UF = E:GetModule('UnitFrames');

-- mouseover classcolor
local function HoverClassColor(self, frame, db)
	if not E.db.mui.HoverClassColor then return; end
	if frame.isMouseOverHooked then return; end
	local health = frame.Health
	frame:HookScript("OnEnter", function(self)
		if (not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return; end
		local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
		if (not hover) then return; end
		health:SetStatusBarColor( hover.r, hover.g, hover.b )
		health.colorClass = true
	end)
	frame:HookScript("OnLeave", function(self)
		if (not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return; end
		local r, g, b = ElvUF.ColorGradient(UnitHealth(self.unit), UnitHealthMax(self.unit), 4.5, 0.1, 0.1, 0.6, 0.3, 0.3, 0.2, 0.2, 0.2)
		health:SetStatusBarColor(r, g, b)
		health.colorClass = false
	end)
	frame.isMouseOverHooked = true
end
hooksecurefunc(UF, 'Update_RaidFrames', HoverClassColor)

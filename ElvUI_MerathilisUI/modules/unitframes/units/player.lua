local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

-- Cache global variables
-- GLOBALS: hooksecurefunc
local _G = _G

function MUF:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]
	
	self:ArrangePlayer()
end

function MUF:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	-- RestIcon
	MUF:Configure_RestingIndicator(frame)
	
	frame:UpdateAllElements()
end


function MUF:InitPlayer()
	self:Construct_PlayerFrame()
	if not IsAddOnLoaded("ElvUI_SLE") then
		_G["ElvUF_Player"].Combat.PostUpdate = MUF.CombatIcon_PostUpdate
		hooksecurefunc(UF, "Configure_RestingIndicator", MUF.Configure_RestingIndicator)
	end
end
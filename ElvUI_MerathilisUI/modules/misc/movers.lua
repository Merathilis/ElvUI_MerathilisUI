local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local M = E:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: hooksecurefunc

function M:UpdateMoverTransparancy()
	local mover
	for name, _ in pairs(E.CreatedMovers) do
		mover = _G[name]
		if mover then
			mover:SetAlpha(E.db.mui.general.Movertransparancy)
		end
	end
end

function M:LoadMoverTransparancy()
	hooksecurefunc(E, 'CreateMover', function(self, parent)
		parent.mover:SetAlpha(E.db.mui.general.Movertransparancy)
	end)

	self:UpdateMoverTransparancy()
end
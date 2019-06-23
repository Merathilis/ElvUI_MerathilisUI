local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MI:UpdateMoverTransparancy()
	local mover
	for name, _ in pairs(E.CreatedMovers) do
		mover = _G[name]
		if mover then
			mover:SetAlpha(E.db.mui.general.Movertransparancy)
		end
	end
end

function MI:LoadMoverTransparancy()
	hooksecurefunc(E, "CreateMover", function(self, parent, name, text, overlay, snapOffset, postdrag, shouldDisable)
		if not parent then return end --If for some reason the parent isnt loaded yet
		if E.CreatedMovers[name].Created then return end
		parent.mover:SetAlpha(E.db.mui.general.Movertransparancy)
	end)

	self:UpdateMoverTransparancy()
end

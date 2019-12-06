local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins");

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.muiSkins.blizzard.orderhall ~= true then return end

	local OrderHallTalentFrame = _G.OrderHallTalentFrame

	OrderHallTalentFrame:HookScript("OnShow", function(self)
		if self.styled then return end
		self:Styling()
		self.styled = true
	end)
end

S:AddCallbackForAddon("Blizzard_OrderHallUI", "mUIOrderHall", LoadSkin)

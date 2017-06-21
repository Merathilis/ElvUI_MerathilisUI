local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = E:GetModule("mUIMisc")

--Cache global variables
--Lua functions
--WoW API / Variables
local Screenshot = Screenshot
local C_Timer = C_Timer

function MI:TakeScreenshot(event, ...)
	C_Timer.After(1, Screenshot)
end

function MI:LoadAutoScreenShoot()
	if not E.db.mui.misc.autoscreenshot then return end

	self:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreenshot")
	self:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED", "TakeScreenshot")
end

local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

----------------------------------------------------------------------------------------
--	Take screenshots of Achievements(Based on Achievement Screenshotter by Blamdarot)
----------------------------------------------------------------------------------------
local function TakeScreen(delay, func, ...)
	if not E.db.mui.Screenshot then return end
	local waitTable = {}
	local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
	waitFrame:SetScript("onUpdate", function (self, elapse)
		local count = #waitTable
		local i = 1
		while (i <= count) do
			local waitRecord = tremove(waitTable, i)
			local d = tremove(waitRecord, 1)
			local f = tremove(waitRecord, 1)
			local p = tremove(waitRecord, 1)
			if d > elapse then
				tinsert(waitTable, i, {d-elapse, f, p})
				i = i + 1
			else
				count = count - 1
				f(unpack(p))
			end
		end
	end)
	tinsert(waitTable, {delay, func, {...} })
end

local function TakeScreenshot()
	TakeScreen(1, TakeScreenshot)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ACHIEVEMENT_EARNED")
f:SetScript("OnEvent",function(self, event)
	if event == "ACHIEVEMENT_EARNED" then
		TakeScreenshot()
		f:UnregisterEvent("ACHIEVEMENT_EARNED")
	end
end)

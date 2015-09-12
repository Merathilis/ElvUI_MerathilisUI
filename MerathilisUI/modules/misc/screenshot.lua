local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Automatic achievement screenshot
local function TakeScreen(delay, func, ...)
	if not E.db.Merathilis.Screenshot then return end
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
	tinsert(waitTable, {delay, func, {...}})
end

local function OnEvent(...) TakeScreen(1, Screenshot) end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ACHIEVEMENT_EARNED")
frame:SetScript("OnEvent",function(self, event)
	if event == "ACHIEVEMENT_EARNED" then
		TakeScreen()
	end
end)

local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local MERS = MER:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert, strsplit = table.insert, string.split
local next, pairs, mod = next, pairs, mod
-- WoW API / Variables

function MI:RaidInfo()
	local header = CreateFrame("Button", nil, UIParent)
	header:SetSize(120, 28)
	header:SetFrameLevel(2)
	header:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 200, -15)
	header:CreateBackdrop("Transparent")
	header.backdrop:SetAllPoints()
	header.backdrop:Styling()

	header:RegisterEvent("GROUP_ROSTER_UPDATE")
	header:RegisterEvent("PLAYER_ENTERING_WORLD")
	header:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if IsInGroup() then
			self:Show()
		else
			self:Hide()
		end
	end)

	-- Role counts
	local function getRaidMaxGroup()
		local _, instType, difficulty = GetInstanceInfo()
		if (instType == "party" or instType == "scenario") and not IsInRaid() then
			return 1
		elseif instType ~= "raid" then
			return 8
		elseif difficulty == 8 or difficulty == 1 or difficulty == 2 or difficulty == 24 then
			return 1
		elseif difficulty == 14 or difficulty == 15 then
			return 6
		elseif difficulty == 16 then
			return 4
		elseif difficulty == 3 or difficulty == 5 then
			return 2
		elseif difficulty == 9 then
			return 8
		else
			return 5
		end
	end

	local roleTexCoord = {
		{.5, .75, 0, 1},
		{.75, 1, 0, 1},
		{.25, .5, 0, 1},
	}

	local roleFrame = CreateFrame("Frame", nil, header)
	roleFrame:SetAllPoints()

	local role = {}
	for i = 1, 3 do
		role[i] = roleFrame:CreateTexture(nil, "OVERLAY")
		role[i]:SetPoint("LEFT", 36*i-30, 0)
		role[i]:SetSize(15, 15)
		role[i]:SetTexture("Interface\\LFGFrame\\LFGROLE")
		role[i]:SetTexCoord(unpack(roleTexCoord[i]))
		role[i].text = MER:CreateText(roleFrame, "OVERLAY", 13, "0")
		role[i].text:ClearAllPoints()
		role[i].text:SetPoint("CENTER", role[i], "RIGHT", 12, 0)
	end

	local raidCounts
	roleFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	roleFrame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
	roleFrame:RegisterEvent("UNIT_FLAGS")
	roleFrame:RegisterEvent("PLAYER_FLAGS_CHANGED")
	roleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	roleFrame:SetScript("OnEvent", function()
		raidCounts = {totalTANK = 0, totalHEALER = 0, totalDAMAGER = 0}

		local maxgroup = getRaidMaxGroup()
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead, _, _, assignedRole = GetRaidRosterInfo(i)
			if name and online and subgroup <= maxgroup and not isDead and assignedRole ~= "NONE" then
				raidCounts["total"..assignedRole] = raidCounts["total"..assignedRole] + 1
			end
		end

		role[1].text:SetText(raidCounts.totalTANK)
		role[2].text:SetText(raidCounts.totalHEALER)
		role[3].text:SetText(raidCounts.totalDAMAGER)
	end)

	-- Battle resurrect
	local resFrame = CreateFrame("Frame", nil, header)
	resFrame:SetAllPoints()
	resFrame:SetAlpha(0)

	local res = CreateFrame("Frame", nil, resFrame)
	res:SetSize(20, 20)
	res:SetPoint("LEFT", 5, 0)

	res.Icon = res:CreateTexture(nil, "OVERLAY")
	res.Icon:SetTexture(GetSpellTexture(20484))
	res.Count = MER:CreateText(res, "OVERLAY", 16, "0")
	res.Count:ClearAllPoints()
	res.Count:SetPoint("LEFT", res, "RIGHT", 10, 0)
	res.Timer = MER:CreateText(resFrame, "OVERLAY", 16, "00:00", false, "RIGHT", -5, 0)

	res:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > .1 then
			local charges, _, started, duration = GetSpellCharges(20484)
			if charges then
				local timer = duration - (GetTime() - started)
				if timer < 0 then
					self.Timer:SetText("--:--")
				else
					self.Timer:SetFormattedText("%d:%.2d", timer/60, timer%60)
				end
				self.Count:SetText(charges)
				if charges == 0 then
					self.Count:SetTextColor(1, 0, 0)
				else
					self.Count:SetTextColor(0, 1, 0)
				end
				resFrame:SetAlpha(1)
				roleFrame:SetAlpha(0)
			else
				resFrame:SetAlpha(0)
				roleFrame:SetAlpha(1)
			end

			self.elapsed = 0
		end
	end)
end

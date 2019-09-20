local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local MERS = MER:GetModule("muiSkins")
local COMP = MER:GetModule("mUICompatibility")
-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetSpellCharges = GetSpellCharges
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local GetReadyCheckStatus = GetReadyCheckStatus
local C_Timer_After = C_Timer.After
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

local function GetRaidMaxGroup()
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

local RoleTexCoord = {
	{.5, .75, 0, 1},
	{.75, 1, 0, 1},
	{.25, .5, 0, 1},
}

local RaidCounts = {
	totalTANK = 0,
	totalHEALER = 0,
	totalDAMAGER = 0,
}

function MI:CreateRaidManager()
	if not E.db.mui.misc.raidInfo then return end

	local header = CreateFrame("Button", nil, E.UIParent)
	header:SetSize(120, 28)
	header:SetFrameLevel(2)
	header:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 214, -15)
	header:CreateBackdrop("Transparent")
	header.backdrop:SetAllPoints()
	header.backdrop:Styling()

	E.FrameLocks[header] = true

	E:CreateMover(header, "MER_RaidManager", L["Raid Manager"], nil, nil, nil, "ALL,SOLO,PARTY,RAID,MERATHILISUI", nil, 'mui,misc')

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

	if COMP.NUI then
		MER.raidManagerHeader = header; -- Export this so NihilistUI can add a shadow to it
	end

	local roleFrame = CreateFrame("Frame", nil, header)
	roleFrame:SetAllPoints()

	local role = {}
	for i = 1, 3 do
		role[i] = roleFrame:CreateTexture(nil, "OVERLAY")
		role[i]:SetPoint("LEFT", 36*i-30, 0)
		role[i]:SetSize(15, 15)
		role[i]:SetTexture("Interface\\LFGFrame\\LFGROLE")
		role[i]:SetTexCoord(unpack(RoleTexCoord[i]))
		role[i].text = MER:CreateText(roleFrame, "OVERLAY", 13, "OUTLINE", "0")
		role[i].text:ClearAllPoints()
		role[i].text:SetPoint("CENTER", role[i], "RIGHT", 12, 0)
	end

	roleFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	roleFrame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
	roleFrame:RegisterEvent("UNIT_FLAGS")
	roleFrame:RegisterEvent("PLAYER_FLAGS_CHANGED")
	roleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	roleFrame:SetScript("OnEvent", function()
		for k in pairs(RaidCounts) do
			RaidCounts[k] = 0
		end

		local maxgroup = GetRaidMaxGroup()
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead, _, _, assignedRole = GetRaidRosterInfo(i)
			if name and online and subgroup <= maxgroup and not isDead and assignedRole ~= "NONE" then
				RaidCounts["total"..assignedRole] = RaidCounts["total"..assignedRole] + 1
			end
		end

		role[1].text:SetText(RaidCounts.totalTANK)
		role[2].text:SetText(RaidCounts.totalHEALER)
		role[3].text:SetText(RaidCounts.totalDAMAGER)
	end)

	-- Battle resurrect
	local resFrame = CreateFrame("Frame", nil, header)
	resFrame:SetAllPoints()
	resFrame:SetAlpha(0)

	local res = CreateFrame("Frame", nil, resFrame)
	res:SetSize(22, 22)
	res:SetPoint("LEFT", 5, 0)
	MER:PixelIcon(res, GetSpellTexture(20484))
	res.Count = MER:CreateText(res, "OVERLAY", 16, "OUTLINE", "0")
	res.Count:ClearAllPoints()
	res.Count:SetPoint("LEFT", res, "RIGHT", 10, 0)
	res.Timer = MER:CreateText(resFrame, "OVERLAY", 16, "OUTLINE", "00:00", false, "RIGHT", -5, 0)

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

	-- Ready check indicator
	local rcFrame = CreateFrame("Frame", nil, header)
	rcFrame:SetPoint("TOP", header, "BOTTOM", 0, -2)
	rcFrame:SetSize(120, 50)
	rcFrame:Hide()

	rcFrame:CreateBackdrop("Transparent")
	rcFrame.backdrop:SetAllPoints()
	rcFrame.backdrop:Styling()
	MER:CreateText(rcFrame, "OVERLAY", 14, "OUTLINE", READY_CHECK, true, "TOP", 0, -8)

	local rc = MER:CreateText(rcFrame, "OVERLAY", 14, "OUTLINE", "", false, "TOP", 0, -28)

	local count, total
	local function hideRCFrame()
		rcFrame:Hide()
		rc:SetText("")
		count, total = 0, 0
	end

	rcFrame:RegisterEvent("READY_CHECK")
	rcFrame:RegisterEvent("READY_CHECK_CONFIRM")
	rcFrame:RegisterEvent("READY_CHECK_FINISHED")
	rcFrame:SetScript("OnEvent", function(self, event)
		if event == "READY_CHECK_FINISHED" then
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 0, 0)
			end
			C_Timer_After(5, hideRCFrame)
		else
			count, total = 0, 0
			self:Show()
			local maxgroup = GetRaidMaxGroup()
			for i = 1, GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, _, online = GetRaidRosterInfo(i)
				if name and online and subgroup <= maxgroup then
					total = total + 1
					local status = GetReadyCheckStatus(name)
					if status and status == "ready" then
						count = count + 1
					end
				end
			end
			rc:SetText(count.." / "..total)
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 1, 0)
			end
		end
	end)
	rcFrame:SetScript("OnMouseUp", function(self) self:Hide() end)
end

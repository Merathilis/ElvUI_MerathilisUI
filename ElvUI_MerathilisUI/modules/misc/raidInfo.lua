local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local MERS = MER:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, unpack = ipairs, unpack
local find, strsplit = string.find, string.split
local tinsert, tsort = table.insert, table.sort
local next, pairs, mod = next, pairs, mod
-- WoW API / Variables
local C_Timer_After = C_Timer.After
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetReadyCheckStatus = GetReadyCheckStatus
local GetSpellCharges = GetSpellCharges
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local members = {}
local lastUpdate = 0


function MI:RaidInfo()
	if E.db.mui.misc.raidInfo ~= true then return; end

	local header = CreateFrame("Button", nil, E.UIParent)
	header:SetFrameLevel(2)
	header:SetSize(120, 28)
	header:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 318, -17)
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

		local maxgroup = GetRaidMaxGroup()
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
	res.Timer = MER:CreateText(resFrame, "OVERLAY", 16, "00:00", "white", "RIGHT", -5, 0)

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
	rcFrame:SetSize(120, 100)
	rcFrame:CreateBackdrop("Transparent")
	rcFrame.backdrop:SetAllPoints()
	rcFrame.backdrop:Styling()
	rcFrame:Hide()

	-- Header Text
	rcFrame.text = rcFrame:CreateFontString(nil, "OVERLAY")
	rcFrame.text:SetPoint("TOP", rcFrame, 0, -8)
	rcFrame.text:FontTemplate(nil, 14, "OUTLINE")
	rcFrame.text:SetText(READY_CHECK)
	rcFrame.text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())

	-- Count
	local rc = MER:CreateText(rcFrame, "OVERLAY", 12, "", nil, "TOP", 0, -28)

	local function AddName(frame)
		-- Member Names
		local rcn = rcFrame:CreateFontString(nil, "OVERLAY")
		rcn:SetJustifyH("LEFT")
		rcn:FontTemplate(nil, 10, "OUTLINE")
		rcn:SetHeight(14)
		rcn:SetWidth(110)
		rcn:SetPoint("LEFT", frame)
		rcFrame.NameText = rcn
	end

	local function CreateMemberFrame()
		local num = #members + 1
		local f = CreateFrame("Frame", "MER_MemberFrame"..num, rcFrame)
		members[num] = f
		local xoff = num % 2 == 0 and 160 or 15
		local yoff = 0 - ((floor(num / 2) + (num % 2)) * 14) - 17
		f:SetWidth(150)
		f:SetHeight(14)
		f:SetPoint("TOPLEFT", rcFrame, "TOPLEFT", xoff, yoff)
		AddName(f)

		return f
	end

	local function SetMemberStatus(name, class)
		if not name or not class then return end
		local f

		f = members[num] or CreateMemberFrame()

		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, class = GetRaidRosterInfo(i)
			local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			local cleanName = name:gsub("%-.+", "*")
			rcFrame.NameText:SetText(cleanName)

			if UnitIsConnected(name) and not UnitIsDeadOrGhost(name) and UnitIsVisible(name) then
				rcFrame.NameText:SetTextColor(color.r, color.g, color.b)
			else
				rcFrame.NameText:SetTextColor(255, 0, 0)
			end
		end
	end

	-- Fix me
	local function UpdateWindow(force)
		for _, v in next, members do v:Hide() end

		local update = nil
		local t = GetTime()
		if t-lastUpdate > 1 or force then
			lastUpdate = t
			update = true
		end
	end

	local count, total
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
			C_Timer_After(5, function()
				self:Hide()
				rc:SetText("")
				count, total = 0, 0
			end)
			UpdateWindow(true)
		else
			count, total = 0, 0
			self:Show()
			local maxgroup = GetRaidMaxGroup()
			local height = 0
			local bottom, top = 0, 0

			for i = 1, GetNumGroupMembers() do
				local name, _, subgroup, _, class, _, _, online = GetRaidRosterInfo(i)
				if name and online and subgroup <= maxgroup then
					total = total + 1
					local status = GetReadyCheckStatus(name)
					if status and status == "ready" then
						count = count + 1
					end

					SetMemberStatus(name, class)
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

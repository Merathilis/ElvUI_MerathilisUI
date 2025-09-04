local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local UF = E:GetModule("UnitFrames")
local LFGPI = MER.Utilities.LFGPlayerInfo

local format = format
local ipairs = ipairs

--[[
	Credits: ElvUI_Windtools - fang2hou
--]]

local GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local scoreFormat = F.String.Grey("(%s) |r%s")

local factionStr = {
	[0] = "Horde",
	[1] = "Alliance",
}

local function GetIconString(role, mode)
	local template
	if mode == "NORMAL" then
		template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
	elseif mode == "COMPACT" then
		template = "|T%s:16:16:0:0:64:64:8:56:8:56|t"
	end

	return format(template, UF.RoleIconTextures[role])
end

function module:AddGroupInfo(tooltip, resultID)
	local config = E.db.mui.tooltip.groupInfo
	if not config or not config.enable then
		return
	end

	if config.hideBlizzard then
		local titleFound = false
		for i = 5, tooltip:NumLines() do
			local text = _G["GameTooltipTextLeft" .. i]
			local raw = text and text:GetText()

			if raw == _G.MEMBERS_COLON then
				text:SetText("")
				titleFound = true
			elseif titleFound and raw and strfind(raw, "^|A:groupfinder%-icon%-role%-micro") then
				text:SetText("")
			end
		end
	end

	LFGPI:SetClassIconStyle(config.classIconStyle)
	LFGPI:Update(resultID)

	-- split line
	if config.title then
		tooltip:AddLine(" ")
		tooltip:AddLine(MER.Title .. " " .. L["Party Info"])
	end

	-- compact Mode
	if config.mode == "COMPACT" then
		tooltip:AddLine(" ")
	end

	-- add info
	local data = LFGPI:GetPartyInfo(config.template)
	for _, role in ipairs(LFGPI:GetRoleOrder()) do
		if #data[role] > 0 and config.mode == "NORMAL" then
			tooltip:AddLine(" ")
			tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. LFGPI.GetColoredRoleName(role))
		end

		for _, line in ipairs(data[role]) do
			local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
			tooltip:AddLine(icon .. " " .. line)
		end
	end

	tooltip:Show()
end

function module:ShowLeaderOverallScore()
	local resultID = self.resultID
	local searchResultInfo = resultID and GetSearchResultInfo(resultID)
	local activityIDs = searchResultInfo and searchResultInfo.activityIDs[1] or nil
	if searchResultInfo then
		local activityInfo = GetActivityInfoTable(activityIDs)
		if activityInfo then
			local showScore = activityInfo.isMythicPlusActivity and searchResultInfo.leaderOverallDungeonScore
				or activityInfo.isRatedPvpActivity
					and searchResultInfo.leaderPvpRatingInfo
					and searchResultInfo.leaderPvpRatingInfo.rating
			if showScore then
				local oldName = self.ActivityName:GetText()
				oldName = gsub(oldName, ".-" .. HEADER_COLON, "") -- Tazavesh
				self.ActivityName:SetFormattedText(scoreFormat, module.GetDungeonScore(showScore), oldName)

				if not self.crossFactionLogo then
					local logo = self:CreateTexture(nil, "OVERLAY")
					logo:SetPoint("TOPLEFT", -6, 5)
					logo:SetSize(24, 24)
					self.crossFactionLogo = logo
				end
			end
		end

		if self.crossFactionLogo then
			if searchResultInfo.crossFactionListing then
				self.crossFactionLogo:Hide()
			else
				self.crossFactionLogo:SetTexture(
					"Interface\\Timer\\" .. factionStr[searchResultInfo.leaderFactionGroup] .. "-Logo"
				)
				self.crossFactionLogo:Show()
			end
		end
	end
end

function module:GroupInfo()
	if IsAddOnLoaded("PremadeGroupsFilter") then
		if E.db.mui.tooltip.groupInfo.enable then
			F.Print(
				format(
					L["%s detected, %s will be disabled automatically."],
					"|cffff3860" .. L["Premade Groups Filter"] .. "|r",
					"|cff00a8ff" .. L["Tooltips"] .. " - " .. L["Group Info"] .. "|r"
				)
			)
			E.db.mui.tooltip.groupInfo.enable = false
		end
	end

	self:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")
	self:SecureHook("LFGListSearchEntry_Update", "ShowLeaderOverallScore")
end

module:AddCallback("GroupInfo")

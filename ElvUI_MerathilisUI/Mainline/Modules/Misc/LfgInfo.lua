local MER, F, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local module = MER:GetModule('MER_LFGInfo')
local TT = MER:GetModule('MER_Tooltip')
local UF = E:GetModule("UnitFrames")

local _G = _G
local format = format
local pairs = pairs
local sort = sort
local wipe = wipe
local tinsert = table.insert
local tremove = table.remove

local HEADER_COLON = _G.HEADER_COLON
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local scoreFormat = MER.GreyColor.."(%s) |r%s"

local displayOrder = {
	[1] = "TANK",
	[2] = "HEALER",
	[3] = "DAMAGER"
}

local roleText = {
	TANK = "|cff00a8ff" .. L["Tank"] .. "|r",
	HEALER = "|cff2ecc71" .. L["Healer"] .. "|r",
	DAMAGER = "|cffe74c3c" .. L["DPS"] .. "|r"
}

local function GetIconString(role, mode)
	local template
	if mode == "NORMAL" then
		template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
	elseif mode == "COMPACT" then
		template = "|T%s:18:18:0:0:64:64:8:56:8:56|t"
	end

	return format(template, UF.RoleIconTextures[role])
end

function module:ReskinIcon(parent, icon, role, class)
	self.db = E.db.mui.misc.lfgInfo

	-- Beautiful square icons
	if role then
		if self.db.icon.reskin then
			icon:SetTexture(MER.Media.Textures.ROLES)
			icon:SetTexCoord(F.GetRoleTexCoord(role))
		end

		icon:Size(self.db.icon.size)

		if self.db.icon.border and not icon.backdrop then
			icon:CreateBackdrop("Transparent")
		end

		icon:SetAlpha(self.db.icon.alpha)
		if icon.backdrop then
			icon.backdrop:SetAlpha(self.db.icon.alpha)
		end
	else
		icon:SetAlpha(0)
		if icon.backdrop then
			icon.backdrop:SetAlpha(0)
		end
	end

	-- Create bar in class color behind
	if class and self.db.line.enable then
		if not icon.line then
			local line = parent:CreateTexture(nil, "ARTWORK")
			line:SetTexture(E.LSM:Fetch("statusbar", self.db.line.tex) or E.media.normTex)
			line:Size(self.db.line.width, self.db.line.height)
			line:Point("TOP", icon, "BOTTOM", self.db.line.offsetX, self.db.line.offsetY)
			icon.line = line
		end

		local color = E:ClassColor(class, false)
		icon.line:SetVertexColor(color.r, color.g, color.b)
		icon.line:SetAlpha(self.db.line.alpha)
	elseif icon.line then
		icon.line:SetAlpha(0)
	end
end

function module:UpdateEnumerate(Enumerate)
	local button = Enumerate:GetParent():GetParent()
	if not button.resultID then
		return
	end

	local result = C_LFGList_GetSearchResultInfo(button.resultID)

	if not result then
		return
	end

	local cache = {
		TANK = {},
		HEALER = {},
		DAMAGER = {}
	}

	for i = 1, result.numMembers do
		local role, class = C_LFGList_GetSearchResultMemberInfo(button.resultID, i)
		tinsert(cache[role], class)
	end

	for i = 5, 1, -1 do -- The index of icon starts from right
		local icon = Enumerate["Icon" .. i]
		if icon and icon.SetTexture then
			if #cache.TANK > 0 then
				module:ReskinIcon(Enumerate, icon, "TANK", cache.TANK[1])
				tremove(cache.TANK, 1)
			elseif #cache.HEALER > 0 then
				module:ReskinIcon(Enumerate, icon, "HEALER", cache.HEALER[1])
				tremove(cache.HEALER, 1)
			elseif #cache.DAMAGER > 0 then
				module:ReskinIcon(Enumerate, icon, "DAMAGER", cache.DAMAGER[1])
				tremove(cache.DAMAGER, 1)
			else
				module:ReskinIcon(Enumerate, icon)
			end
		end
	end
end

function module:UpdateRoleCount(RoleCount)
	if RoleCount.TankIcon then
		self:ReskinIcon(nil, RoleCount.TankIcon, "TANK")
	end
	if RoleCount.HealerIcon then
		self:ReskinIcon(nil, RoleCount.HealerIcon, "HEALER")
	end
	if RoleCount.DamagerIcon then
		self:ReskinIcon(nil, RoleCount.DamagerIcon, "DAMAGER")
	end
end

function module:AddGroupInfo(tooltip, resultID)
	local config = E.db.mui.misc.lfgInfo
	if not config or not config.enable then
		return
	end

	local result = C_LFGList_GetSearchResultInfo(resultID)

	if not result then
		return
	end

	local cache = {
		TANK = {},
		HEALER = {},
		DAMAGER = {}
	}

	local display = {
		TANK = false,
		HEALER = false,
		DAMAGER = false
	}

	for i = 1, result.numMembers do
		local role, class = C_LFGList_GetSearchResultMemberInfo(resultID, i)

		if not display[role] then
			display[role] = true
		end

		if not cache[role][class] then
			cache[role][class] = 0
		end

		cache[role][class] = cache[role][class] + 1
	end

	sort(cache, function(a, b)
		return displayOrder[a] > displayOrder[b]
	end)

	if config.title then
		tooltip:AddLine(" ")
		tooltip:AddLine(MER.Title .. " " .. L["LFG Info"])
	end

	if config.mode == "COMPACT" then
		tooltip:AddLine(" ")
	end

	for i = 1, #displayOrder do
		local role = displayOrder[i]
		local members = cache[role]
		if members and display[role] then
			if config.mode == "NORMAL" then
				tooltip:AddLine(" ")
				tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. roleText[role])
			end

			for class, counter in pairs(members) do
				local numberText = counter ~= 1 and format(" × %d", counter) or ""
				local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
				local className = F.CreateClassColorString(LOCALIZED_CLASS_NAMES_MALE[class], class)
				tooltip:AddLine(icon .. className .. numberText)
			end
		end
	end

	wipe(cache)

	tooltip:ClearAllPoints()
	tooltip:SetPoint("TOPLEFT", _G.LFGListFrame, "TOPRIGHT", 10, 0)
	tooltip:Show()
end

local factionStr = {
	[0] = "Horde",
	[1] = "Alliance",
}

function module:ShowLeaderOverallScore(self)
	local resultID = self.resultID
	local searchResultInfo = resultID and C_LFGList_GetSearchResultInfo(resultID)
	if searchResultInfo then
		local activityInfo = C_LFGList_GetActivityInfoTable(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
		if activityInfo then
			local showScore = activityInfo.isMythicPlusActivity and searchResultInfo.leaderOverallDungeonScore
				or activityInfo.isRatedPvpActivity and searchResultInfo.leaderPvpRatingInfo and searchResultInfo.leaderPvpRatingInfo.rating
			if showScore then
				local oldName = self.ActivityName:GetText()
				oldName = gsub(oldName, ".-"..HEADER_COLON, "") -- Tazavesh
				self.ActivityName:SetFormattedText(scoreFormat, TT.GetDungeonScore(showScore), oldName)

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
				self.crossFactionLogo:SetTexture("Interface\\Timer\\"..factionStr[searchResultInfo.leaderFactionGroup].."-Logo")
				self.crossFactionLogo:Show()
			end
		end
	end
end

function module:Initialize()
	local db = E.db.mui.misc.lfgInfo
	if not db.enable or IsAddOnLoaded('WindDungeonHelper') then return end

	module:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")
	module:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
	module:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")
	module:SecureHook("LFGListSearchEntry_Update", "ShowLeaderOverallScore")
end

MER:RegisterModule(module:GetName())

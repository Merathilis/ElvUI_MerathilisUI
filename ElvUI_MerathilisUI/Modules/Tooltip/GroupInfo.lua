local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Tooltip')
local UF = E:GetModule('UnitFrames')
local LFGPI = MER.Utilities.LFGPlayerInfo

local format = format
local ipairs = ipairs

--[[
	Credits: ElvUI_Windtools - fang2hou
--]]

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

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

function module:GroupInfo()
	if C_AddOns_IsAddOnLoaded("PremadeGroupsFilter") and E.db.mui.tooltip.groupInfo.enable then
		F.Print(
			format(
				L["%s detected, %s will be disabled automatically."],
				"|cffff3860" .. L["Premade Groups Filter"] .. "|r",
				"|cff00a8ff" .. L["Tooltips"] .. " - " .. L["Group Info"] .. "|r"
			)
		)
		E.db.mui.tooltip.groupInfo.enable = false
	end

	module:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")
end

module:AddCallback("GroupInfo")

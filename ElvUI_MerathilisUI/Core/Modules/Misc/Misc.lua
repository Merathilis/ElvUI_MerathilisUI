local MER, F, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local _G = _G
local pairs = pairs
local twipe = table.wipe
local tinsert = table.insert
local strfind = string.find
local gsub = gsub

local hooksecurefunc = hooksecurefunc
local C_FriendList_GetNumWhoResults = C_FriendList.GetNumWhoResults
local C_FriendList_GetWhoInfo = C_FriendList.GetWhoInfo
local GetGuildInfo = GetGuildInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetNumGroupMembers = GetNumGroupMembers
local GetRealZoneText = GetRealZoneText
local GetSpecialization = GetSpecialization
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole
local InCombatLockdown = InCombatLockdown
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local UIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

function module:SetRole()
	if not E.Retail then return end

	local spec = GetSpecialization()
	if UnitLevel("player") >= 10 and not InCombatLockdown() then
		if spec == nil and UnitGroupRolesAssigned("player") ~= "NONE" then
			UnitSetRole("player", "NONE")
		elseif spec ~= nil then
			if GetNumGroupMembers() > 0 then
				if UnitGroupRolesAssigned("player") ~= E:GetPlayerRole() then
					UnitSetRole("player", E:GetPlayerRole())
				end
			end
		end
	end
end

-- Colors
local function classColor(class, showRGB)
	local color = F.ClassColors[E.UnlocalizedClasses[class] or class]
	if not color then color = F.ClassColors['PRIEST'] end

	if showRGB then
		return color.r, color.g, color.b
	else
		return '|c'..color.colorStr
	end
end

local function diffColor(level)
	return F.RGBToHex(GetQuestDifficultyColor(level))
end

-- Whoframe
local columnTable = {}
local function UpdateWhoList()
	local scrollFrame = _G.WhoListScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numButtons = #buttons
	local numWhos = C_FriendList_GetNumWhoResults()

	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo('player')
	local playerRace = UnitRace('player')

	for i = 1, numButtons do
		local button = buttons[i]
		local index = offset + i
		if index <= numWhos then
			local nameText = button.Name
			local levelText = button.Level
			local variableText = button.Variable

			local info = C_FriendList_GetWhoInfo(index)
			local guild, level, race, zone, class = info.fullGuildName, info.level, info.raceStr, info.area, info.filename
			if zone == playerZone then zone = '|cff00ff00'..zone end
			if guild == playerGuild then guild = '|cff00ff00'..guild end
			if race == playerRace then race = '|cff00ff00'..race end

			twipe(columnTable)
			tinsert(columnTable, zone)
			tinsert(columnTable, guild)
			tinsert(columnTable, race)

			nameText:SetTextColor(classColor(class, true))
			levelText:SetText(diffColor(level)..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(_G.WhoFrameDropDown)])
		end
	end
end

function module:Misc()
	local db = E.db.mui.misc

	if E.Retail then
		E.RegisterCallback(module, "RoleChanged", "SetRole")
		module:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")

		module:CreateMawWidgetFrame()
		module:WowHeadLinks()
		module:AddAlerts()

		hooksecurefunc('WhoList_Update', UpdateWhoList)
		hooksecurefunc(_G.WhoListScrollFrame, 'update', UpdateWhoList)
	end

	module:LoadGMOTD()
	module:LoadQuest()
	module:LoadnameHover()
	module:ReputationInit()
end

module:AddCallback("Misc")

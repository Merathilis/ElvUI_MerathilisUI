local MER, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

-- All Credits belong to Lockslap (ElvUI_SystemDT)

--Cache global variables
local format = string.format
local join = string.join
local tsort = table.sort
--WoW API / Variables
local CastSpellByName = CastSpellByName
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local GetProfessionName = GetProfessionName
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: PROFESSIONS_FIRST_AID

local lastPanel
local profValues = {}
local displayString = ""
local tooltipString = ""

local function GetProfessionName(index)
	local name, _, _, _, _, _, _, _ = GetProfessionInfo(index)
	return name
end

local function OnEvent(self, event, ...)
	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()

	if E.db.mui.profdt.prof == "prof1" then
		if prof1 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof1)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end

	elseif E.db.mui.profdt.prof == "prof2" then
		if prof2 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof2)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end

	elseif E.db.mui.profdt.prof == "archy" then
		if archy ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(archy)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end

	elseif E.db.mui.profdt.prof == "fishing" then
		if fishing ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(fishing)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end

	elseif E.db.mui.profdt.prof == "cooking" then
		if cooking ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(cooking)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end

	elseif E.db.mui.profdt.prof == "firstaid" then
		if firstAid ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(firstAid)
			self.text:SetFormattedText(displayString, name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	end
end

local function Click(self, button)
	local prof1, prof2, archy, _, cooking, firstAid = GetProfessions()
	if button == "LeftButton" then
		if IsControlKeyDown() and firstAid ~= nil then
			CastSpellByName(PROFESSIONS_FIRST_AID)
		elseif not IsControlKeyDown() then
			if IsShiftKeyDown() and archy == nil then return
			elseif not IsShiftKeyDown() and prof1 == nil then return end
			local name, _, _, _, _, _, _, _ = GetProfessionInfo(IsShiftKeyDown() and archy or prof1)
			CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
		end
	elseif button == "RightButton" then
		if IsShiftKeyDown() and cooking == nil then return
		elseif not IsShiftKeyDown() and prof2 == nil then return end
		local name, _, _, _, _, _, _, _ = GetProfessionInfo(IsShiftKeyDown() and cooking or prof2)
		CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()
	local professions = {}

	if prof1 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof1)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if prof2 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof2)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if archy ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(archy)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if fishing ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(fishing)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if cooking ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(cooking)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if firstAid ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(firstAid)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end

	if #professions == 0 then return end
	tsort(professions, function(a, b) return a["name"] < b["name"] end)

	for i = 1, #professions do
		DT.tooltip:AddDoubleLine(join("", professions[i].texture, "  ", professions[i].name), tooltipString:format(professions[i].rank, professions[i].maxRank), 1, 1, 1, 1, 1, 1)
	end

	if E.db.mui.profdt.hint then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Open "] .. GetProfessionName(prof1), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["Open "] .. GetProfessionName(prof2), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Open Archaeology"], 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Right Click:"], L["Open Cooking"], 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Ctrl + Click:"], L["Open First Aid"], 1, 1, 1, 1, 1, 0)
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "%s: ", hex, "%d/", hex, "%d|r")
	tooltipString = join("" , hex, "%d/", hex, "%d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("MUI Professions", {"PLAYER_ENTERING_WORLD", "CHAT_MSG_SKILL", "TRADE_SKILL_UPDATE"}, OnEvent, nil, Click, OnEnter)

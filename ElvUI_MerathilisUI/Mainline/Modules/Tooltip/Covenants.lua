local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Tooltip')
local TT = E:GetModule('Tooltip')
local lib = MER.Libs.LOR

local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local UnitName = UnitName
local UnitIsPlayer = UnitIsPlayer
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local UnitInParty, UnitInRaid = UnitInParty, UnitInRaid

local covenants = {
	"|cff72cff8" .. L["Kyrian"] .. "|r",
	"|cff971243" .. L["Venthyr"] .. "|r",
	"|cff1e88e5" .. L["NightFae"] .. "|r",
	"|cff00897b" .. L["Necrolord"] .. "|r"
}

local icons = {
	[[Interface\Icons\UI_Sigil_Kyrian]], --kyrian
	[[Interface\Icons\UI_Sigil_Venthyr]], --venthyr
	[[Interface\Icons\UI_Sigil_NightFae]], --nightfae
	[[Interface\Icons\UI_Sigil_Necrolord]], --necrolords
}

function module:GetCovenant(unit)
	if unit == "player" then
		return C_Covenants_GetActiveCovenantID()
	end

	local name, realm = UnitName(unit)
	local fullName = name
	if realm then
		fullName = name.."-"..realm
	end

	local info = lib.GetAllUnitsInfo()

	if not info then
		return
	end
	local data = info[fullName]

	if not data then
		return
	end
	return data.covenantId
end

function module:AddCovenantTooltip()
	local _, unit = self:GetUnit()
	if not UnitIsPlayer(unit) then
		return
	end

	local inParty = IsInGroup()
	local inRaid = IsInRaid()
	local targetInOurGroup = UnitInParty(unit)
	local targetInOurRaid = UnitInRaid(unit)
	if not inParty and not inRaid or (not targetInOurGroup and not targetInOurRaid) then
		if module.db.showNotInGroup then
			self:AddLine(L["Covenant: <Not in Group>"], nil, nil, nil, true)
			return
		end
	end


	local covenantId = module:GetCovenant(unit)
	if not covenantId then
		self:AddLine(L["Covenant: <Checking...>"], nil, nil, nil, true)
		return
	end
	if covenantId == 0 then
		self:AddLine(L["Covenant: <None - Too low>"], nil, nil, nil, true)
		return
	end

	local message = "|T"..icons[covenantId]..":16|t"..covenants[covenantId]

	if message and message ~= "" and IsShiftKeyDown() then
		self:AddLine(L["Covenant: "]..message, nil, nil, nil, true)
	end
end

function module:HookTooltip()
	if _G.GameTooltip:IsForbidden() then
		return
	end

	self:HookScript("OnTooltipSetUnit", module.AddCovenantTooltip)
end

function module:CovenantInfo()
	module.db = E.db.mui.tooltip.covenant
	if not module.db.enable then
		return
	end

	module.HookTooltip(_G.GameTooltip)
end
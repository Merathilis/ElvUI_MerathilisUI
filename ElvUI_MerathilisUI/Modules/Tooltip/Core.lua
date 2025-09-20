local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local TT = E:GetModule("Tooltip")

local _G = _G
local assert = assert
local next = next
local xpcall = xpcall
local tinsert = table.insert
local strsplit = strsplit

local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor

module.load = {}
module.updateProfile = {}
module.modifierInspect = {}
module.normalInspect = {}
module.clearInspect = {}
module.eventCallback = {}

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallback(name, func)
	tinsert(self.load, func or self[name])
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

function module:AddInspectInfoCallback(priority, inspectFunc, useModifier, clearFunc)
	if type(inspectFunc) == "string" then
		inspectFunc = self[inspectFunc]
	end

	assert(type(inspectFunc) == "function", "Invalid inspect function")

	if useModifier then
		self.modifierInspect[priority] = inspectFunc
	else
		self.normalInspect[priority] = inspectFunc
	end

	if clearFunc then
		if type(clearFunc) == "string" then
			clearFunc = self[clearFunc]
		end

		assert(type(clearFunc) == "function", "Invalid clear function")

		self.clearInspect[priority] = clearFunc
	end
end

function module:ClearInspectInfo(tt)
	if tt:IsForbidden() then
		return
	end

	-- Run all registered callbacks (clear)
	for _, func in next, self.clearInspect do
		xpcall(func, F.Developer.ThrowError, self, tt)
	end
end

function module:CheckModifier()
	self.db = E.db.mui.tooltip

	if not self.db or self.db.modifier == "NONE" then
		return true
	end

	local modifierStatus = {
		SHIFT = IsShiftKeyDown(),
		ALT = IsAltKeyDown(),
		CTRL = IsControlKeyDown(),
	}

	local results = {}
	for _, modifier in next, { strsplit("_", self.db.modifier) } do
		tinsert(results, modifierStatus[modifier] or false)
	end

	for _, v in next, results do
		if not v then
			return false
		end
	end

	return true
end

function module:InspectInfo(tt, data, triedTimes)
	if tt ~= GameTooltip or (tt.IsForbidden and tt:IsForbidden()) or (TT.db and not TT.db.visibility) then
		return
	end

	if tt.MERInspectLoaded then
		return
	end

	triedTimes = triedTimes or 0

	local unit = select(2, tt:GetUnit())

	if not unit then
		local GMF = E:GetMouseFocus()
		local focusUnit = GMF and GMF.GetAttribute and GMF:GetAttribute("unit")
		if focusUnit then
			unit = focusUnit
		end
		if not unit or not UnitExists(unit) then
			return
		end
	end

	if not unit or not data or not data.guid then
		return
	end

	-- Run all registered callbacks (normal)
	for _, func in next, self.normalInspect do
		xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
	end

	-- General
	local inCombatLockdown = InCombatLockdown()
	local isShiftKeyDown = IsShiftKeyDown()
	local isPlayerUnit = UnitIsPlayer(unit)
	local isInspecting = _G.InspectPaperDollFrame and _G.InspectPaperDollFrame:IsShown()

	-- Item Level
	local itemLevelAvailable = isPlayerUnit and not inCombatLockdown and TT.db.inspectDataEnable

	if self.db.forceItemLevel and not isInspecting then
		if not isShiftKeyDown and itemLevelAvailable and not tt.ItemLevelShown then
			local _, class = UnitClass(unit)
			local color = class and E:ClassColor(class) or RAID_CLASS_COLORS_PRIEST
			TT:AddInspectInfo(tt, unit, 0, color.r, color.g, color.b)
		end
	end

	-- Modifier callbacks pre-check
	if not self:CheckModifier() or not CanInspect(unit) then
		return
	end

	-- It ElvUI Item Level is enabled, we need to delay the modifier callbacks
	if self.db.forceItemLevel or isShiftKeyDown and itemLevelAvailable then
		if not tt.ItemLevelShown and triedTimes <= 4 then
			E:Delay(0.33, module.InspectInfo, module, tt, data, triedTimes + 1)
			return
		end
	end

	-- Run all registered callbacks (modifier)
	for _, func in next, self.modifierInspect do
		xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
	end

	tt.MERInspectLoaded = true
end

function module:ElvUIRemoveTrashLines(_, tt)
	if tt:IsForbidden() then
		return
	end

	tt.MERInspectLoaded = false
end

function module:AddEventCallback(eventName, func)
	if type(func) == "string" then
		func = self[func]
	end
	if self.eventCallback[eventName] then
		tinsert(self.eventCallback[eventName], func)
	else
		self.eventCallback[eventName] = { func }
	end
end

function module:Event(event, ...)
	if self.eventCallback[event] then
		for _, func in next, self.eventCallback[event] do
			xpcall(func, F.Developer.ThrowError, self, event, ...)
		end
	end
end

module:SecureHook(TT, "GameTooltip_OnTooltipSetUnit", function(...)
	if not module or not module.initialized then
		return
	end

	module:InspectInfo(...)
end)

function module.GetDungeonScore(score)
	local color = GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
	return color:WrapTextInColorCode(score)
end

local genderTable = { _G.UNKNOWN .. " ", _G.MALE .. " ", _G.FEMALE .. " " }

function module:SetUnitText(_, tt, unit, isPlayerUnit)
	if not tt or (tt.IsForbidden and tt:IsForbidden()) or not isPlayerUnit then
		return
	end

	local db = self.db
	if not db or not db.specIcon and not db.raceIcon then
		return
	end

	local guildName = GetGuildInfo(unit)
	local levelLine, specLine = TT:GetLevelLine(tt, (guildName and 2) or 1)
	local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)

	if levelLine then
		local diffColor = GetCreatureDifficultyColor(level)
		local race, englishRace = UnitRace(unit)
		local gender = UnitSex(unit)
		local _, localizedFaction = E:GetUnitBattlefieldFaction(unit)
		if localizedFaction and (englishRace == "Pandaren" or englishRace == "Dracthyr") then
			race = localizedFaction .. " " .. race
		end
		local hexColor = E:RGBToHex(diffColor.r, diffColor.g, diffColor.b)
		local unitGender = TT.db.gender and genderTable[gender]

		if db.raceIcon then
			local raceIcon = F.GetRaceAtlasString(englishRace, gender or 1, TT.db.textFontSize, TT.db.textFontSize)
			if raceIcon then
				race = raceIcon .. " " .. race
			end
		end

		local levelText
		if level < realLevel then
			levelText = format(
				"%s%s|r |cffFFFFFF(%s)|r %s%s",
				hexColor,
				level > 0 and level or "??",
				realLevel,
				unitGender or "",
				race or ""
			)
		else
			levelText = format("%s%s|r %s%s", hexColor, level > 0 and level or "??", unitGender or "", race or "")
		end

		local specText = specLine and specLine:GetText()
		if specText then
			local localeClass, class, classID = UnitClass(unit)
			if not localeClass or not class then
				return
			end

			local nameColor = E:ClassColor(class) or _G.RAID_CLASS_COLORS_PRIEST

			local specIcon
			if db.specIcon and classID and MER.SpecializationInfo[classID] then
				for _, spec in next, MER.SpecializationInfo[classID] do
					if strfind(specText, spec.name) then
						specIcon = spec.icon
						break
					end
				end
			end

			if specIcon then
				local iconString = F.GetIconString(specIcon, TT.db.textFontSize, TT.db.textFontSize + 3, true)
				specText = iconString .. " " .. specText
			end

			specLine:SetFormattedText("|c%s%s|r", nameColor.colorStr, specText)
		end

		levelLine:SetFormattedText(levelText)
	end
end

function module:Initialize()
	self.db = E.db.mui.tooltip

	for index, func in next, self.load do
		xpcall(func, F.Developer.ThrowError, self)
		self.load[index] = nil
	end

	for name, _ in pairs(self.eventCallback) do
		self:RegisterEvent(name, "Event")
	end

	self:SecureHook(TT, "SetUnitText", "SetUnitText")
	self:SecureHook(TT, "RemoveTrashLines", "ElvUIRemoveTrashLines")
	self:SecureHookScript(GameTooltip, "OnTooltipCleared", "ClearInspectInfo")

	self.initialized = true
end

function module:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, F.Developer.ThrowError, self)
		self.updateProfile[index] = nil
	end
end

MER:RegisterModule(module:GetName())

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local T = MER:GetModule('MER_Tooltip')
local ET = E:GetModule('Tooltip')

local _G = _G
local next = next
local xpcall = xpcall
local tinsert = table.insert
local strsplit = strsplit

local C_ChallengeMode_GetDungeonScoreRarityColor = E.Retail and C_ChallengeMode.GetDungeonScoreRarityColor

T.load = {}
T.updateProfile = {}
T.modifierInspect = {}
T.normalInspect = {}
T.clearInspect = {}
T.eventCallback = {}

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function T:AddCallback(name, func)
	tinsert(self.load, func or self[name])
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function T:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

function T:AddInspectInfoCallback(priority, inspectFunction, useModifier, clearFunction)
	if type(inspectFunction) == "string" then
		inspectFunction = self[inspectFunction]
	end

	if useModifier then
		self.modifierInspect[priority] = inspectFunction
	else
		self.normalInspect[priority] = inspectFunction
	end

	if clearFunction then
		if type(clearFunction) == "string" then
			clearFunction = self[clearFunction]
		end
		self.clearInspect[priority] = clearFunction
	end
end

function T:ClearInspectInfo(tt)
	if tt:IsForbidden() then
		return
	end

	-- Run all registered callbacks (clear)
	for _, func in next, self.clearInspect do
		xpcall(func, F.Developer.ThrowError, self, tt)
	end
end

function T:CheckModifier()
	self.db = E.db.mui.tooltip

	if not self.db or self.db.modifier == "NONE" then
		return true
	end

	local modifierStatus = {
		SHIFT = IsShiftKeyDown(),
		ALT = IsAltKeyDown(),
		CTRL = IsControlKeyDown()
	}

	local results = {}
	for _, modifier in next, {strsplit("_", self.db.modifier)} do
		tinsert(results, modifierStatus[modifier] or false)
	end

	for _, v in next, results do
		if not v then
			return false
		end
	end

	return true
end

function T:InspectInfo(tt, data, triedTimes)
	if tt ~= GameTooltip or (tt.IsForbidden and tt:IsForbidden()) or (ET.db and not ET.db.visibility) then
		return
	end

	if tt.MERInspectLoaded then
		return
	end

	local unit = select(2, tt:GetUnit())

	if not unit or not data or not data.guid then
		return
	end

	-- Run all registered callbacks (normal)
	for _, func in next, self.normalInspect do
		xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
	end

	if not self:CheckModifier() or not CanInspect(unit) then
		return
	end

	-- If ElvUI is inspecting, just wait for 4 seconds
	triedTimes = triedTimes or 0
	if triedTimes > 20 then
		return
	end

	if not InCombatLockdown() and IsShiftKeyDown() and ET.db.inspectDataEnable then
		local isElvUITooltipItemLevelInfoAlreadyAdded = false
		for i = #(data.lines), tt:NumLines() do
			local leftTip = _G["GameTooltipTextLeft" .. i]
			local leftTipText = leftTip:GetText()
			if leftTipText and leftTipText == L["Item Level:"] and leftTip:IsShown() then
				isElvUITooltipItemLevelInfoAlreadyAdded = true
				break
			end
		end

		if not isElvUITooltipItemLevelInfoAlreadyAdded then
			return E:Delay(0.2, T.InspectInfo, T, ET, tt, data, triedTimes + 1)
		end
	end

	-- Run all registered callbacks (modifier)
	for _, func in next, self.modifierInspect do
		xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
	end

	tt.MERInspectLoaded = true
end

function T:ElvUIRemoveTrashLines(_, tt)
	tt.MERInspectLoaded = false
end

function T:AddEventCallback(eventName, func)
	if type(func) == "string" then
		func = self[func]
	end
	if self.eventCallback[eventName] then
		tinsert(self.eventCallback[eventName], func)
	else
		self.eventCallback[eventName] = { func }
	end
end

function T:Event(event, ...)
	if self.eventCallback[event] then
		for _, func in next, self.eventCallback[event] do
			xpcall(func, F.Developer.ThrowError, self, event, ...)
		end
	end
end

ET._MER_GameTooltip_OnTooltipSetUnit = ET.GameTooltip_OnTooltipSetUnit
function ET.GameTooltip_OnTooltipSetUnit(...)
	ET._MER_GameTooltip_OnTooltipSetUnit(...)

	if not T then
		return
	end

	T:InspectInfo(...)
end

function T.GetDungeonScore(score)
	local color = C_ChallengeMode_GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
	return color:WrapTextInColorCode(score)
end

function T:Initialize()
	self.db = E.db.mui.tooltip
	for index, func in next, self.load do
		xpcall(func, F.Developer.ThrowError, self)
		self.load[index] = nil
	end

	for name, _ in pairs(self.eventCallback) do
		T:RegisterEvent(name, "Event")
	end

	T:SecureHook(ET, "RemoveTrashLines", "ElvUIRemoveTrashLines")
	T:SecureHookScript(GameTooltip, "OnTooltipCleared", "ClearInspectInfo")

	T:ReskinTooltipIcons()

	T.initialized = true
end

function T:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, F.Developer.ThrowError, self)
		self.updateProfile[index] = nil
	end
end

MER:RegisterModule(T:GetName())

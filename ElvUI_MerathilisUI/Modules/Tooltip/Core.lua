local MER, W, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
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

function module:Initialize()
	self.db = E.db.mui.tooltip

	for index, func in next, self.load do
		xpcall(func, F.Developer.ThrowError, self)
		self.load[index] = nil
	end

	for name, _ in pairs(self.eventCallback) do
		self:RegisterEvent(name, "Event")
	end

	self.initialized = true
end

function module:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, F.Developer.ThrowError, self)
		self.updateProfile[index] = nil
	end
end

MER:RegisterModule(module:GetName())

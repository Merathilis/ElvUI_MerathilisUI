local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local _G = _G
local assert = assert
local format = format
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local IsAddOnLoaded = IsAddOnLoaded

module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.updateProfile = {}

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--[[
	@param {string} addonName
	@param {function} [func=module.addonName]
]]
function module:AddCallbackForAddon(addonName, func)
	if func and type(func) == "string" then
		func = self[func]
	end

	local addon = self.addonsToLoad[addonName]
	if not addon then
		self.addonsToLoad[addonName] = {}
		addon = self.addonsToLoad[addonName]
	end

	tinsert(addon, func or self[addonName])
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--[[
	@param {string} err
]]
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

--[[
	回调注册的插件函数
	@param {string} addonName 插件名
	@param {object} object 回调的函数
]]
function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler, self)
	end

	self.addonsToLoad[addonName] = nil
end

--[[
	@param {string} addonName
]]
function module:ADDON_LOADED(_, addonName)
	if not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function module:Initialize()
	for index, func in next, self.nonAddonsToLoad do
		xpcall(func, errorhandler, self)
		self.nonAddonsToLoad[index] = nil
	end

	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end
end

function module:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, errorhandler, self)
		self.updateProfile[index] = nil
	end
end

module:RegisterEvent("ADDON_LOADED")
MER:RegisterModule(module:GetName())
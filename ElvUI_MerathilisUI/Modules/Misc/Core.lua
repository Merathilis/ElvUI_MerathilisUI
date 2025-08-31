local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.updateProfile = {}

--- Register a callback function
---@param name string Function name
---@param func function|string? Callback function (defaults to module[name] if not provided)
function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--- Register an addon callback function
---@param addonName string Addon name
---@param func? function|string Addon callback function (defaults to module[addonName] if not provided)
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

--- Register an update callback function
---@param name string Function name
---@param func function|string? Callback function (defaults to self[name] if not provided)
function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--[[
	@param {string} err
]]
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

--- Call registered addon functions
---@param addonName string Addon name
---@param object function[] Array of callback functions
function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, F.Developer.LogDebug, self)
	end

	self.addonsToLoad[addonName] = nil
end

--- Trigger callbacks based on addon loading events
---@param _ any Unused parameter
---@param addonName string Addon name
function module:ADDON_LOADED(_, addonName)
	if not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function module:AddCallbackOrScale(AddOnName, func)
	if not IsAddOnLoaded(AddOnName) then
		module:AddCallbackForAddon(AddOnName, func)
	else
		func()
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

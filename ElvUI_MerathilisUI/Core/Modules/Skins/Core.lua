local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G
local next, type = next, type
local xpcall = xpcall
local tinsert = table.insert

local IsAddOnLoaded = IsAddOnLoaded

module.allowBypass = {}
module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.enteredLoad = {}
module.updateProfile = {}

--[[
	@param {string} addonName
]]
function module:ADDON_LOADED(_, addonName)
	if not E.initialized or not E.private.mui.skins.enable then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

--[[
	@param {string} addonName 插件名
	@param {function} [func=module.addonName] 插件回调函数
]]
function module:AddCallbackForAddon(addonName, func)
	local addon = self.addonsToLoad[addonName]
	if not addon then
		self.addonsToLoad[addonName] = {}
		addon = self.addonsToLoad[addonName]
	end

	if type(func) == "string" then
		func = self[func]
	end

	tinsert(addon, func or self[addonName])
end

--[[
	nonAddonsToLoad
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallback(name, func)  -- arg1: name is 'given name'
	tinsert(self.nonAddonsToLoad, func or self[name])
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

--[[
	@param {string} addonName
	@param {object} object
]]
function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler)
	end

	self.addonsToLoad[addonName] = nil
end

--[[
	@param {string} addonName
]]
function module:PLAYER_ENTERING_WORLD()
	if not E.initialized or not E.private.mui.skins.enable then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, errorhandler, self)
		self.enteredLoad[index] = nil
	end
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

function module:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

function module:Initialize()
	if not E.private.mui.skins.enable then
		return
	end
	self.db = E.private.mui.skins

	self:StyleElvUIConfig()

	if IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			module:ReskinAS(unpack(AddOnSkins))
		end
	end

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

-- Keep this outside, it's used for skinning addons before shit load
module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(module:GetName())
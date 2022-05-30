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
module.updateProfile = {}

function module:ADDON_LOADED(_, addonName)
	if not self.allowBypass[addonName] and not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		module:CallLoadedAddon(addonName, object)
	end
end

-- EXAMPLE:
--- module:AddCallbackForAddon('Details', 'MyAddon_Details', MyAddon.SkinDetails)
---- arg1: Addon name (same as the toc): MyAddon.toc (without extension)
---- arg2: Given name (try to use something that won't be used by someone else)
---- arg3: load function (preferably not-local)
-- this is used for loading skins that should be executed when the addon loads (including blizzard addons that load later).
-- please add a given name, non-given-name is specific for elvui core addon.
function module:AddCallbackForAddon(addonName, name, func, forceLoad, bypass, position) -- arg2: name is 'given name'; see example above.
	local load = (type(name) == 'function' and name) or (not func and (module[name] or module[addonName]))
	module:RegisterSkin(addonName, load or func, forceLoad, bypass, position)
end

-- nonAddonsToLoad:
--- this is used for loading skins when our skin init function executes.
--- please add a given name, non-given-name is specific for elvui core addon.
function module:AddCallback(name, func, position)  -- arg1: name is 'given name'
	local load = (type(name) == 'function' and name) or (not func and module[name])
	module:RegisterSkin('ElvUI_MerathilisUI', load or func, nil, nil, position)
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function module:RegisterSkin(addonName, func, forceLoad, bypass, position)
	if bypass then
		self.allowBypass[addonName] = true
	end

	if forceLoad then
		xpcall(func, errorhandler)
		self.addonsToLoad[addonName] = nil
	elseif addonName == 'ElvUI_MerathilisUI' then
		if position then
			tinsert(self.nonAddonsToLoad, position, func)
		else
			tinsert(self.nonAddonsToLoad, func)
		end
	else
		local addon = self.addonsToLoad[addonName]
		if not addon then
			self.addonsToLoad[addonName] = {}
			addon = self.addonsToLoad[addonName]
		end

		if position then
			tinsert(addon, position, func)
		else
			tinsert(addon, func)
		end
	end
end

function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler)
	end

	self.addonsToLoad[addonName] = nil
end

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
	self.Initialized = true
	self.db = E.private.mui.skins

	self:UpdateMedia()
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
MER:RegisterModule(module:GetName())
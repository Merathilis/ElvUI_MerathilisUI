local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local xpcall = xpcall
local tinsert = table.insert
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

module.addonsToLoad = {}

function module:AddCallbackForAddon(addonName, func)
	local addon = module.addonsToLoad[addonName]
	if not addon then
		module.addonsToLoad[addonName] = {}
		addon = module.addonsToLoad[addonName]
	end

	if type(func) == "string" then
		func = module[func]
	end

	tinsert(addon, func or module[addonName])
end

function module:ADDON_LOADED(_, addonName)
	if not E.initialized or not MER:HasRequirements(I.Requirements.AdditionalScaling) then
		return
	end

	local object = module.addonsToLoad[addonName]
	if object then
		module:CallLoadedAddon(addonName, object)
	end
end

function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, print, module)
	end

	module.addonsToLoad[addonName] = nil
end

function module:AddCallbackOrScale(AddOnName, func)
	if not C_AddOns_IsAddOnLoaded(AddOnName) then
		module:AddCallbackForAddon(AddOnName, func)
	else
		func()
	end
end

module:RegisterEvent("ADDON_LOADED")

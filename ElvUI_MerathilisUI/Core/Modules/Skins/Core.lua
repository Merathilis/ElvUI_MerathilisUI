local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

local _G = _G

module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.updateProfile = {}
module.aceWidgets = {}
module.enteredLoad = {}

local AceGUI

function module:CheckDB(elvuiKey, MERKey)
	if elvuiKey then
		MERKey = MERKey or elvuiKey
		if not (E.private.skins.blizzard.enable and E.private.skins.blizzard[elvuiKey]) then
			return false
		end
		if not (E.private.mui.skins.blizzard.enable and E.private.mui.skins.blizzard[MERKey]) then
			return false
		end
	else
		if not (E.private.mui.skins.blizzard.enable and E.private.mui.skins.blizzard[MERKey]) then
			return false
		end
	end

	return true
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--[[
	AceGUI Widget
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForAceGUIWidget(name, func)
	self.aceWidgets[name] = func or self[name]
end

--[[
	@param {string} addonName
	@param {function} [func=module.addonName]
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
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

--[[
	@param {string} addonName 插件名
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

--[[
	@param {string} addonName
	@param {object} object
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
	if not E.initialized or not E.private.mui.skins.enable then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function module:ReskinWidgets(AceGUI)
	for name, oldFunc in pairs(AceGUI.WidgetRegistry) do
		module:UpdateWidget(AceGUI, name, oldFunc)
	end
end

function module:UpdateWidget(lib, name, oldFunc)
	if self.aceWidgets[name] then
		lib.WidgetRegistry[name] = self.aceWidgets[name](self, oldFunc)
		self.aceWidgets[name] = nil
	end
end
do
	local alreadyWidgetHooked = false
	local alreadyDialogSkined = false
	function module:LibStub_NewLibrary(_, major)
		if major == "AceGUI-3.0" and not alreadyWidgetHooked then
			AceGUI = _G.LibStub("AceGUI-3.0")
			self:ReskinWidgets(AceGUI)
			self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
			alreadyWidgetHooked = true
		elseif major == "AceConfigDialog-3.0" and not alreadyDialogSkined then
			self:AceConfigDialog()
			alreadyDialogSkined = true
		end
	end

	function module:HookEarly()
		local AceGUI = _G.LibStub("AceGUI-3.0")
		if AceGUI and not alreadyWidgetHooked then
			self:ReskinWidgets(AceGUI)
			self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
			alreadyWidgetHooked = true
		end

		local AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")
		if AceConfigDialog and not alreadyDialogSkined then
			self:AceConfigDialog()
			alreadyDialogSkined = true
		end
	end
end

function module:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

function module:ShadowOverlay()
	-- Based on ncShadow
	if not E.private.mui.skins.shadowOverlay then return end

	self.f = CreateFrame("Frame", MER.Title.."ShadowBackground")
	self.f:Point("TOPLEFT")
	self.f:Point("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")

	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Overlay]])
	self.f.tex:SetAllPoints(self.f)

	self.f:SetAlpha(0.7)
end

function module:Initialize()
	if not E.private.mui.skins.enable then
		return
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

	self:HookEarly()
	self:SecureHook(_G.LibStub, "NewLibrary", "LibStub_NewLibrary")

	self:ShadowOverlay()
end

module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(module:GetName())
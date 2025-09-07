local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@class Skins

local _G = _G
local next = next
local xpcall = xpcall
local tonumber = tonumber
local strmatch = strmatch

local CreateFrame = CreateFrame
local GenerateClosure = GenerateClosure
local RunNextFrame = RunNextFrame
local Settings = Settings

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

module.settingFrames = {}
module.waitSettingFrames = {}
module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.libraryHandlers = {}
module.libraryHandledMinors = {}
module.updateProfile = {}
module.aceWidgetConfigs = {}
module.aceWidgetWaitingList = {}
module.enteredLoad = {}
module.texturePathFetcher = E.UIParent:CreateTexture(nil, "ARTWORK")
module.texturePathFetcher:Hide()

local RegisterCanvasLayoutCategory = Settings.RegisterCanvasLayoutCategory
Settings.RegisterCanvasLayoutCategory = function(frame, name)
	if frame and name then
		module.settingFrames[name] = frame
		if module.waitSettingFrames[name] then
			module.waitSettingFrames[name](frame)
			module.waitSettingFrames[name] = nil
		end
	end

	return RegisterCanvasLayoutCategory(frame, name)
end

function module:ShadowOverlay()
	-- Based on ncShadow
	if not E.private.mui.skins.shadowOverlay then
		return
	end

	local f = CreateFrame("Frame", MER.Title .. "ShadowBackground")
	f:Point("TOPLEFT")
	f:Point("BOTTOMRIGHT")
	f:SetFrameLevel(0)
	f:SetFrameStrata("BACKGROUND")

	f.tex = f:CreateTexture()
	f.tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Overlay]])
	f.tex:SetAllPoints(f)

	f:SetAlpha(0.7)
end

function module:IsTexturePathEqual(texture, path)
	local got = texture and texture.GetTextureFilePath and texture:GetTextureFilePath()
	if not got then
		return false
	end

	self.texturePathFetcher:SetTexture(path)
	return got == self.texturePathFetcher:GetTextureFilePath()
end

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

---Handle AceGUI widget styling
---@param lib table The AceGUI library
---@param name string The widget name
---@param constructor function The widget constructor
function module:HandleAceGUIWidget(lib, name, constructor)
	local config = self.aceWidgetConfigs[name]
	if not config then
		return
	end

	config.constructor = constructor

	if self.db then
		if self.db.enable and config.checker(self.db) then
			config.constructor = constructor
			lib.WidgetRegistry[name] = function()
				local widget = config.constructor()
				config.handler(widget)
				return widget
			end
		end
		return
	end

	if not self.aceWidgetWaitingList[name] then
		self.aceWidgetWaitingList[name] = {}
		lib.WidgetRegistry[name] = function()
			local widget = config.constructor()
			tinsert(self.aceWidgetWaitingList[name], widget)
			return widget
		end
	end
end

function module:ProcessWaitingAceGUIWidgets()
	local lib = LibStub:GetLibrary("AceGUI-3.0", true)
	assert(lib, "ProcessWaitingAceWidgets: AceGUI-3.0 not found")

	for name, widgets in pairs(self.aceWidgetWaitingList) do
		local config = self.aceWidgetConfigs[name]
		if self.db.enable and config.checker(self.db) then
			lib.WidgetRegistry[name] = function()
				local widget = config.constructor()
				config.handler(widget)
				return widget
			end

			for _, widget in ipairs(widgets) do
				config.handler(widget)
			end
		else
			lib.WidgetRegistry[name] = config.constructor
		end
	end

	self.aceWidgetWaitingList = nil
end

function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

---Add a callback function for AceGUI widget styling
---@param name string The widget name
--@param handler function|string? The callback function or method name
---@param checker function The checker for enabling the skin or not
function module:AddCallbackForAceGUIWidget(name, handler, checker)
	if type(handler) == "string" then
		handler = GenerateClosure(self[handler], self)
	end

	assert(type(handler) == "function", "AddCallbackForAceGUIWidget: handler must be a function or method name")

	self.aceWidgetConfigs[name] = {
		checker = checker,
		handler = handler,
	}
end

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

function module:AddCallbackForLibrary(name, func)
	local lib = self.libraryHandlers[name]
	if not lib then
		self.libraryHandlers[name] = {}
		lib = self.libraryHandlers[name]
	end

	if type(func) == "string" then
		func = self[func]
	end

	tinsert(lib, func or self[name])
end

function module:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

function module:PLAYER_ENTERING_WORLD()
	if not E.initialized or not E.private.mui.skins.enable then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, F.Developer.ThrowError, self)
		self.enteredLoad[index] = nil
	end
end

function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		if not xpcall(func, F.Developer.ThrowError, self) then
			self:Log("debug", format("Failed to run addon %s", addonName))
		end
	end

	self.addonsToLoad[addonName] = nil
end

function module:ADDON_LOADED(_, addonName)
	if not E.initialized or not E.private.mui.skins.enable then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function module:LibStub_NewLibrary(_, major, minor)
	if not self.libraryHandlers[major] then
		return
	end

	minor = minor and tonumber(strmatch(minor, "%d+"))
	local handledMinor = self.libraryHandledMinors[major]
	if not minor or handledMinor and handledMinor >= minor then
		return
	end

	self.libraryHandledMinors[major] = minor

	RunNextFrame(function()
		local lib, latestMinor = _G.LibStub(major, true)
		if not lib or not latestMinor or latestMinor ~= minor then
			return
		end
		for _, func in next, self.libraryHandlers[major] do
			if not xpcall(func, F.Developer.ThrowError, self, lib) then
				self:Log("debug", format("Failed to skin library %s", major, minor))
			end
		end
	end)
end

function module:TryPostHook(...)
	local frame, method, hookFunc = ...
	if frame and method and _G[frame] and _G[frame][method] then
		hooksecurefunc(_G[frame], method, function(f, ...)
			if not f.__MERSkin then
				hookFunc(f, ...)
				f.__MERSkin = true
			end
		end)
	else
		self:Log("debug", "Failed to hook: " .. tostring(frame) .. " " .. tostring(method))
	end
end

function module:ReskinSettingFrame(name, func)
	if type(func) == "string" and module[func] then
		func = GenerateClosure(module[func], S)
	end

	if not func then
		F.Developer.ThrowError("ReskinSettingFrame: func is nil")
		return
	end

	local frame = self.settingFrames[name]
	if frame then
		func(frame)
	else
		self.waitSettingFrames[name] = func
	end
end

function module:Initialize()
	self.db = E.private.mui.skins
	self:ProcessWaitingAceGUIWidgets()

	if not self.db.enable then
		return
	end

	for index, func in next, self.nonAddonsToLoad do
		if not xpcall(func, F.Developer.ThrowError, self) then
			self:Log("debug", "Failed to run skin function")
		end
		self.nonAddonsToLoad[index] = nil
	end

	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = C_AddOns_IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end

	self:ShadowOverlay()
end

module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(module:GetName())

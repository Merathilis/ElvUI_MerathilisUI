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
module.aceWidgets = {}
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

function module:HandleAceGUIWidget(lib, name, constructor)
	local handler = self.aceWidgets[name]
	if handler then
		lib.WidgetRegistry[name] = handler(self, constructor)
		self.aceWidgets[name] = nil
	end
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

function module:AddCallbackForAceGUIWidget(name, func)
	if type(func) == "string" then
		func = self[func]
	end

	self.aceWidgets[name] = func
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
		xpcall(func, errorhandler, self)
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
	if not E.private.mui.skins.enable then
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

	self:HookEarly()
	self:SecureHook(_G.LibStub, "NewLibrary", "LibStub_NewLibrary")
	for libName in pairs(_G.LibStub.libs) do
		local lib, minor = _G.LibStub(libName, true)
		if lib and self.libraryHandlers[libName] then
			self.libraryHandledMinors[libName] = minor
			for _, func in next, self.libraryHandlers[libName] do
				if not xpcall(func, F.Developer.ThrowError, self, lib) then
					self:Log("debug", format("Failed to skin library %s", libName, minor))
				end
			end
		end
	end

	self:ShadowOverlay()
end

module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(module:GetName())

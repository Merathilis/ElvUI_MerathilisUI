local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@class Skins

local _G = _G
local next, pairs = next, pairs
local xpcall = xpcall
local tinsert, format, type = tinsert, format, type

local CreateFrame = CreateFrame
local GenerateClosure = GenerateClosure

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

module.settingFrames = {}
module.waitSettingFrames = {}
module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.enteredLoad = {}
module.texturePathFetcher = E.UIParent:CreateTexture(nil, "ARTWORK")
module.texturePathFetcher:Hide()

function module:ShadowOverlay()
	-- Based on ncShadow
	if not E.private.mui.skins.shadowOverlay then
		return
	end

	local f = CreateFrame("Frame", "MER_ShadowOverlay")
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

function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
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

function module:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

function module:PLAYER_ENTERING_WORLD()
	if not E.Initialized or not E.private.mui.skins.enable then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, F.Developer.ThrowError, self)
		self.enteredLoad[index] = nil
	end
end

---Call all loaded addon callbacks
---@param addonName string The name of the addon
---@param callbacks table The callback functions table
function module:CallLoadedAddon(addonName, callbacks)
	for _, callback in next, callbacks do
		if not xpcall(callback, F.Developer.ThrowError, self) then
			self:Log("debug", format("Failed to run addon %s", addonName))
		end
	end

	self.addonsToLoad[addonName] = nil
end

function module:ADDON_LOADED(_, addonName)
	if not E.Initialized or not E.private.mui.skins.enable then
		return
	end

	local callbacks = self.addonsToLoad[addonName]
	if callbacks then
		self:CallLoadedAddon(addonName, callbacks)
	end
end

function module:ReskinSettingFrame(name, func)
	if type(func) == "string" and module[func] then
		func = GenerateClosure(module[func], module)
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

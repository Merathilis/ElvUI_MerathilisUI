local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_DamageMeter") ---@type DamageMeter

--[[
	Credits: ElvUI_ToxiUI
]]

local _G = _G

local hooksecurefunc = hooksecurefunc
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_CVar_GetCVarBool = C_CVar.GetCVarBool

local gradientOrientation
local fgMapNormal
local fgMapShift

local function EnsureGradientCache()
	if fgMapNormal then
		return true
	end

	local fgMap = F.Color.GetMap("classColorMap")
	if not fgMap then
		F.Color.GenerateCache()
		fgMap = F.Color.GetMap("classColorMap")
	end
	if not fgMap then
		return false
	end

	fgMapNormal = fgMap[I.Enum.GradientMode.Color.NORMAL]
	fgMapShift = fgMap[I.Enum.GradientMode.Color.SHIFT]
	gradientOrientation = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]

	return fgMapNormal ~= nil and fgMapShift ~= nil
end

local function InvalidateGradientCache()
	fgMapNormal = nil
	fgMapShift = nil
end

local function ApplyGradient(content)
	if not content then
		return
	end

	local classFilename = content.classFilename
	if not classFilename then
		return
	end
	if not EnsureGradientCache() then
		return
	end

	local normalColor = fgMapNormal[classFilename]
	local shiftColor = fgMapShift[classFilename]
	if not normalColor or not shiftColor then
		return
	end

	local texture = content.MERBarTexture
	if not texture then
		if not content.StatusBar then
			return
		end
		texture = content.StatusBar:GetStatusBarTexture()
		if not texture then
			return
		end
		content.MERBarTexture = texture
	end

	F.Color.SetGradient(texture, gradientOrientation, normalColor, shiftColor)
end

local function SkinMeter(content)
	if not content or not content.StatusBar then
		return
	end

	if not content.MERHooked then
		content.MERHooked = true

		local barTexture = content.StatusBar:GetStatusBarTexture()
		if barTexture and not barTexture.MERGradientHooked then
			barTexture.MERGradientHooked = true
			content.MERBarTexture = barTexture

			hooksecurefunc(barTexture, "SetVertexColor", function()
				if not content.classFilename then
					return
				end

				if not EnsureGradientCache() then
					return
				end

				local normalColor = fgMapNormal[content.classFilename]
				local shiftColor = fgMapShift[content.classFilename]
				if not normalColor or not shiftColor then
					return
				end

				F.Color.SetGradient(barTexture, gradientOrientation, normalColor, shiftColor)
			end)
		end
	end

	ApplyGradient(content)
end

local function HookScrollBox(scrollBox)
	if not scrollBox or scrollBox.MERHooked then
		return
	end
	scrollBox.MERHooked = true

	hooksecurefunc(scrollBox, "Update", function(self)
		if self.ForEachFrame then
			self:ForEachFrame(SkinMeter)
		end
	end)

	if scrollBox.ForEachFrame then
		scrollBox:ForEachFrame(SkinMeter)
	end
end

local function HookSessionWindow(window)
	local ScrollBox = window.GetScrollBox and window:GetScrollBox()
	if ScrollBox then
		HookScrollBox(ScrollBox)
	end

	if window.SourceWindow then
		local sourceScrollBox = window.SourceWindow.GetScrollBox and window.SourceWindow:GetScrollBox()
		if sourceScrollBox then
			HookScrollBox(sourceScrollBox)
		end
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", function()
		if not E.private.mui.skins.blizzard.damageMeter.enable then
			return
		end

		local function RefreshGradients()
			if not _G.DamageMeter then
				return
			end
			InvalidateGradientCache()

			F.Color.GenerateCache()
			_G.DamageMeter:ForEachSessionWindow(function(window)
				local ScrollBox = window.GetScrollBox and window:GetScrollBox()
				if ScrollBox and ScrollBox.ForEachFrame then
					ScrollBox:ForEachFrame(ApplyGradient)
				end
			end)
		end

		F.Event.RegisterCallback("MER_Theme.SettingsUpdate.Health", RefreshGradients, self)
		F.Event.RegisterCallback("MER_Theme.DatabaseUpdate", RefreshGradients, self)

		F.Event.ContinueOnAddOnLoaded("Blizzard_DamageMeter", function()
			if not _G.DamageMeter then
				return
			end

			hooksecurefunc(_G.DamageMeter, "SetupSessionWindow", function()
				_G.DamageMeter:ForEachSessionWindow(HookSessionWindow)
			end)

			_G.DamageMeter:ForEachSessionWindow(HookSessionWindow)
		end)
	end)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())

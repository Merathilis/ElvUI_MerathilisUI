local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc

local WeakAuras = _G.WeakAuras
local WeakAurasPrivate = _G.WeakAurasPrivate

function module:WeakAuras_PrintProfile()
	local frame = _G.WADebugEditBox.Background

	if frame and not frame.__MERSkin then
		local textArea = _G.WADebugEditBoxScrollFrame:GetRegions()
		S:HandleScrollBar(_G.WADebugEditBoxScrollFrameScrollBar)

		frame:StripTextures()
		frame:SetTemplate("Transparent")
		module:CreateShadow(frame)

		for _, child in pairs({ frame:GetChildren() }) do
			if child:GetNumRegions() == 3 then
				child:StripTextures()
				local subChild = child:GetChildren()
				subChild:ClearAllPoints()
				subChild:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
				S:HandleCloseButton(subChild)
			end
		end

		frame.__MERSkin = true
	end
end

function module:ProfilingWindow_UpdateButtons(frame)
	for _, button in pairs({ frame.statsFrame:GetChildren() }) do
		S:HandleButton(button)
	end

	for _, button in pairs({ frame.titleFrame:GetChildren() }) do
		if not button.__MERSkin and button.GetNormalTexture then
			local normalTextureID = button:GetNormalTexture():GetTexture()
			if normalTextureID == 252125 then
				button:StripTextures()
				button.SetNormalTexture = E.noop
				button.SetPushedTexture = E.noop
				button.SetHighlightTexture = E.noop

				button.Texture = button:CreateTexture(nil, "OVERLAY")
				button.Texture:SetPoint("CENTER")
				button.Texture:SetTexture(E.Media.Textures.ArrowUp)
				button.Texture:SetSize(14, 14)

				button:HookScript("OnEnter", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					end
				end)

				button:HookScript("OnLeave", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(1, 1, 1)
					end
				end)

				button:HookScript("OnClick", function(self)
					self.Texture:Show("")
					if self:GetParent():GetParent().minimized then
						button.Texture:SetRotation(S.ArrowRotation["down"])
					else
						button.Texture:SetRotation(S.ArrowRotation["up"])
					end
				end)

				button:SetHitRectInsets(6, 6, 7, 7)
				button:SetPoint("TOPRIGHT", frame.titleFrame, "TOPRIGHT", -19, 3)
			else
				S:HandleCloseButton(button)
				button:ClearAllPoints()
				button:SetPoint("TOPRIGHT", frame.titleFrame, "TOPRIGHT", 3, 1)
			end

			button.__MERSkin = true
		end
	end
end

local function Skin_WeakAuras(f, fType)
	if fType == "icon" then
		if not f.__MERStyle then
			f.icon.SetTexCoordOld_Changed = f.icon.SetTexCoord
			f.icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
				local cLeft, cRight, cTop, cDown
				if URx and URy and LRx and LRy then
					cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
				else
					cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
				end

				local left, right, top, down = unpack(E.TexCoords)
				if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
					local width, height = cRight - cLeft, cDown - cTop
					if width == height then
						self:SetTexCoordOld_Changed(left, right, top, down)
					elseif width > height then
						self:SetTexCoordOld_Changed(
							left,
							right,
							top + cTop * (right - left),
							top + cDown * (right - left)
						)
					else
						self:SetTexCoordOld_Changed(
							left + cLeft * (down - top),
							left + cRight * (down - top),
							top,
							down
						)
					end
				else
					self:SetTexCoordOld_Changed(cLeft, cRight, cTop, cDown)
				end
			end
			f.icon:SetTexCoord(f.icon:GetTexCoord())
			f:CreateBackdrop()
			module:CreateBackdropShadow(f, true)
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			hooksecurefunc(f, "SetFrameStrata", function()
				f.backdrop:SetFrameLevel(0)
			end)
			f.backdrop.icon = f.icon
			f.backdrop:HookScript("OnUpdate", function(self)
				self:SetAlpha(self.icon:GetAlpha())
				if self.MERshadow then
					self.MERshadow:SetAlpha(self.icon:GetAlpha())
				end
			end)

			f.__MERStyle = true
		end
	elseif fType == "aurabar" then
		if not f.__MERStyle then
			f:CreateBackdrop()
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
			hooksecurefunc(f, "SetFrameStrata", function()
				f.backdrop:SetFrameLevel(0)
			end)
			module:CreateBackdropShadow(f, true)
			f.icon:SetTexCoord(unpack(E.TexCoords))
			f.icon.SetTexCoord = E.noop
			f.iconFrame:SetAllPoints(f.icon)
			f.iconFrame:CreateBackdrop()
			hooksecurefunc(f.icon, "Hide", function()
				f.iconFrame.backdrop:SetShown(false)
			end)
			hooksecurefunc(f.icon, "Show", function()
				f.iconFrame.backdrop:SetShown(true)
			end)

			f.__MERStyle = true
		end
	end
end

function module:WeakAuras()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wa then
		return
	end

	-- Only for me, sorry boys
	if not F.IsDeveloper() then
		return
	end

	-- Only works for WeakAurasPatched
	if not WeakAuras or not WeakAuras.Private then
		local alertMessage = format(
			"%s: %s %s %s",
			MER.Title,
			L["You are using Official WeakAuras, the skin of WeakAuras will not be loaded due to the limitation."],
			L["If you want to use WeakAuras skin, please install |cffff0000WeakAurasPatched|r (https://wow-ui.net/wap)."],
			L["You can disable this alert via disabling WeakAuras Skin in Skins - Addons."]
		)
		E:Delay(10, print, alertMessage)
		return
	end

	-- Handle the options region type registration
	if WeakAuras.Private.RegisterRegionOptions then
		self:RawHook(WeakAuras.Private, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
	end

	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				Skin_WeakAuras(region, region.regionType)
			end
		end)
	end

	-- Real Time Profiling Window
	-- Fix me
	--[[local profilingWindow = WeakAuras.RealTimeProfilingWindow
	if profilingWindow then
		self:CreateShadow(profilingWindow)
		if profilingWindow.UpdateButtons then
			self:SecureHook(profilingWindow, "UpdateButtons", "ProfilingWindow_UpdateButtons")
		end
		if WeakAuras.PrintProfile then
			self:SecureHook(WeakAuras, "PrintProfile", "WeakAuras_PrintProfile")
		end
	end]]
end

module:AddCallbackForAddon("WeakAuras")

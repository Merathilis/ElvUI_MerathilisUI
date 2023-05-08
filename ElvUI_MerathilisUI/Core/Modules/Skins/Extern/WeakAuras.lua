local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local WeakAuras = _G.WeakAuras

local function Skin_RealTimeProfiling(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	frame:SetTemplate('Transparent')
	frame:Styling()
	module:CreateShadow(frame)

	--[[
		-- I dont get this -.-
	if frame.MaxMinButtonFrame.MinimizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MinimizeButton, "up", nil, true)
		frame.MaxMinButtonFrame.MinimizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MinimizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	if frame.MaxMinButtonFrame.MaximizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MaximizeButton, "down", nil, true)
		frame.MaxMinButtonFrame.MaximizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MaximizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end
	--]]
	S:HandleCloseButton(frame.CloseButton)

	--[[
		-- Also needs update
	local buttons = {
		frame.reportButton,
		frame.encounterButton,
		frame.combatButton,
		frame.toggleButton
	}

	for _, button in pairs(buttons) do
		if button then
			S:HandleButton(button)
		end
	end
	--]]
end

local function Skin_ProfilingReport(frame)
	if not frame.__MERSkin then
		return
	end

	frame:StripTextures()
	frame:SetTemplate('Transparent')
	frame:Styling()
	module:CreateShadow(frame)

	S:HandleCloseButton(frame.CloseButton)

	frame.__MERSkin = true
end

local function Skin_WeakAuras(f, fType, data)
	-- Modified from NDui WeakAuras Skins
	if fType == "icon" then
		if not f.MERStyle then
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
						self:SetTexCoordOld_Changed(left, right, top + cTop * (right - left), top + cDown * (right - left))
					else
						self:SetTexCoordOld_Changed(left + cLeft * (down - top), left + cRight * (down - top), top, down)
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
			f.backdrop.icon = f.icon
			f.backdrop:HookScript("OnUpdate", function(self)
				self:SetAlpha(self.icon:GetAlpha())
				if self.MERshadow then
					self.MERshadow:SetAlpha(self.icon:GetAlpha())
				end
			end)

			f.MERStyle = true
		end
	elseif fType == "aurabar" then
		if not f.MERStyle and data ~= nil and data.height>2 then
			f:CreateBackdrop()
			f:Styling()
			f.backdrop.Center:StripTextures()
			f.backdrop:SetFrameLevel(0)
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

			f.MERStyle = true
		end
	end
end

function module:WeakAuras()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wa then
		return
	end

	-- Handle the options region type registration
	if WeakAuras and WeakAuras.RegisterRegionOptions then
		module:RawHook(WeakAuras, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
	end

	local function OnPrototypeCreate(region)
		Skin_WeakAuras(region, region.regionType)
	end

	local function OnPrototypeModifyFinish(_, region, data)
		Skin_WeakAuras(region, region.regionType, data)
	end

	module:SecureHook(WeakAuras.regionPrototype, "create", OnPrototypeCreate)
	module:SecureHook(WeakAuras.regionPrototype, "modifyFinish", OnPrototypeModifyFinish)

	-- Real Time Profiling Window
	local profilingWindow = _G.WeakAurasRealTimeProfiling
	if profilingWindow then
		Skin_RealTimeProfiling(profilingWindow)
	end

	-- Real Time Profiling Report Window
	local profilingReport = WeakAurasProfilingReport
	if profilingReport then
		print("yes")
		Skin_ProfilingReport(profilingReport)
	end
end

module:AddCallbackForAddon("WeakAuras")

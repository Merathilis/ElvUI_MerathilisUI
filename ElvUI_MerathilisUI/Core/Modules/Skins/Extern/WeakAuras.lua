local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local function WeakAuras_PrintProfile()
	local frame = _G.WADebugEditBox.Background

	if frame and not frame.windStyle then
		local textArea = _G.WADebugEditBoxScrollFrame:GetRegions()
		S:HandleScrollBar(_G.WADebugEditBoxScrollFrameScrollBar)

		frame:StripTextures()
		frame:CreateBackdrop("Transparent")
		module:CreateShadow(frame)

		for _, child in pairs {frame:GetChildren()} do
			if child:GetNumRegions() == 3 then
				child:StripTextures()
				local subChild = child:GetChildren()
				S:HandleCloseButton(subChild)
				subChild:ClearAllPoints()
				subChild:Point("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
			end
		end

		frame.windStyle = true
	end
end

local function ProfilingWindow_UpdateButtons(frame)
	for _, button in pairs {frame.statsFrame:GetChildren()} do
		S:HandleButton(button)
	end

	for _, button in pairs {frame.titleFrame:GetChildren()} do
		if not button.MERStyle and button.GetNormalTexture then
			local normalTextureID = button:GetNormalTexture():GetTexture()
			if normalTextureID == 252125 then
				button:StripTextures()

				button.Texture = button:CreateTexture(nil, "OVERLAY")
				button.Texture:Point("CENTER")
				button.Texture:SetTexture(E.Media.Textures.ArrowUp)
				button.Texture:Size(14, 14)

				button:HookScript("OnEnter", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					end
				end)

				button:HookScript("OnLeave", function(self)
					if self.Texture then
						self.Texture:SetVertexColor(1, 1, 1, 1)
					end
				end)

				button:HookScript("OnClick", function(self)
					self:SetNormalTexture("")
					self:SetPushedTexture("")
					self.Texture:Show("")
					if self:GetParent():GetParent().minimized then
						button.Texture:SetRotation(S.ArrowRotation["down"])
					else
						button.Texture:SetRotation(S.ArrowRotation["up"])
					end
				end)

				button:SetHitRectInsets(6, 6, 7, 7)
				button:Point("TOPRIGHT", frame.titleFrame, "TOPRIGHT", -19, 3)
			else
				S:HandleCloseButton(button)
				button:ClearAllPoints()
				button:Point("TOPRIGHT", frame.titleFrame, "TOPRIGHT", 3, 5)
			end

			button.MERStyle = true
		end
	end
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
				if self.shadow then
					self.shadow:SetAlpha(self.icon:GetAlpha())
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

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wa then
		return
	end

	-- Handle the options region type registration
	if _G.WeakAuras and _G.WeakAuras.RegisterRegionOptions then
		module:RawHook(_G.WeakAuras, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
	end

	local function OnPrototypeCreate(region)
		Skin_WeakAuras(region, region.regionType)
	end

	local function OnPrototypeModifyFinish(_, region, data)
		Skin_WeakAuras(region, region.regionType, data)
	end

	hooksecurefunc(_G.WeakAuras.regionPrototype, "create", OnPrototypeCreate)
	hooksecurefunc(_G.WeakAuras.regionPrototype, "modifyFinish", OnPrototypeModifyFinish)
end

module:AddCallbackForAddon("WeakAuras", LoadSkin)

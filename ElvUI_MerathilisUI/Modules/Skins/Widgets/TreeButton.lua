local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = module.Widgets
local LSM = E.Libs.LSM

local _G = _G
local abs = abs
local type = type

function WS:HandleTreeGroup(widget)
	if not E.private.mui.skins.enable or not E.private.mui.skins.widgets.treeGroupButton.enable then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(widget, "HandleTreeGroup")
		return
	end

	local db = E.private.mui
		and E.private.mui.skins
		and E.private.mui.skins.widgets
		and E.private.mui.skins.widgets.treeGroupButton

	if widget.CreateButton and not widget.CreateButton_MER then
		widget.CreateButton_MER = widget.CreateButton
		widget.CreateButton = function(...)
			local button = widget.CreateButton_MER(...)

			button:SetPushedTextOffset(0, 0)

			if db.text.enable then
				local textObj = button.text
					or button.Text
					or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
				if textObj and textObj.GetTextColor then
					F.SetFontDB(textObj, db.text.font)

					textObj.SetPoint_MER = textObj.SetPoint
					textObj.SetPoint = function(text, point, arg1, arg2, arg3, arg4)
						if point == "LEFT" and type(arg2) == "number" and abs(arg2 - 2) < 0.1 then
							arg2 = -1
						end

						text.SetPoint_MER(text, point, arg1, arg2, arg3, arg4)
					end

					button.windWidgetText = textObj
				end
			end

			if db.backdrop.enable then
				-- Clear original highlight texture
				button:SetHighlightTexture("")
				if button.highlight then
					button.highlight:SetTexture("")
					button.highlight:Hide()
				end

				-- Create background
				local bg = button:CreateTexture()
				bg:SetInside(button, 2, 0)
				bg:SetAlpha(0)
				bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

				if button.Center then
					local layer, subLayer = button.Center:GetDrawLayer()
					subLayer = subLayer and subLayer + 1 or 0
					bg:SetDrawLayer(layer, subLayer)
				end

				F.SetVertexColorDB(bg, db.backdrop.classColor and E.myClassColor or db.backdrop.color)

				button.MERAnimation = self.Animation(bg, db.backdrop.animation)
				self.SetAnimationMetadata(button, button.MERAnimation)
				self:SecureHookScript(button, "OnEnter", button.MERAnimation.OnEnter)
				self:SecureHookScript(button, "OnLeave", button.MERAnimation.OnLeave)
				self:SecureHook(button, "Disable", button.MERAnimation.OnStatusChange)
				self:SecureHook(button, "Enable", button.MERAnimation.OnStatusChange)

				-- Avoid the hook is flushed
				self:SecureHook(button, "SetScript", function(frame, scriptType)
					if scriptType == "OnEnter" then
						self:Unhook(frame, "OnEnter")
						self:SecureHookScript(frame, "OnEnter", button.MERAnimation.OnEnter)
					elseif scriptType == "OnLeave" then
						self:Unhook(frame, "OnLeave")
						self:SecureHookScript(frame, "OnLeave", button.MERAnimation.OnLeave)
					end
				end)
			end

			if db.selected.enable then
				button:CreateBackdrop(
					nil,
					LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					true
				)
				button.backdrop:SetInside(button, 2, 0)
				local borderColor = db.selected.borderClassColor and E.myClassColor or db.selected.borderColor
				local backdropColor = db.selected.backdropClassColor and E.myClassColor or db.selected.backdropColor
				button.backdrop:SetBackdropBorderColor(
					borderColor.r,
					borderColor.g,
					borderColor.b,
					db.selected.borderAlpha
				)
				button.backdrop:SetBackdropColor(
					backdropColor.r,
					backdropColor.g,
					backdropColor.b,
					db.selected.backdropAlpha
				)
				button.backdrop:Hide()
			end

			if db.selected.enable or db.text.enable then
				button.LockHighlight_MER = button.LockHighlight
				button.LockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Show()
					end

					if frame.MERWidgetText then
						local color = db.text.selectedClassColor and E.myClassColor or db.text.selectedColor
						frame.MERWidgetText:SetTextColor(color.r, color.g, color.b)
					end
				end
				button.UnlockHighlight_MER = button.UnlockHighlight
				button.UnlockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Hide()
					end

					if frame.MERWidgetText then
						local color = db.text.normalClassColor and E.myClassColor or db.text.normalColor
						frame.MERWidgetText:SetTextColor(color.r, color.g, color.b)
					end
				end
			end

			button.MERWidgetSkinned = true
			return button
		end
	end
end

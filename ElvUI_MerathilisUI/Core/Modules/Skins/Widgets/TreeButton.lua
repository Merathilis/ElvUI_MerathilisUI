local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local module = MER.Modules.Skins
local WS = module.Widgets

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

	local db = E.private.mui and E.private.mui.skins and E.private.mui.skins.widgets and E.private.mui.skins.widgets.treeGroupButton

	if widget.CreateButton and not widget.CreateButton_Changed then
		widget.CreateButton_Changed = widget.CreateButton
		widget.CreateButton = function(...)
			local button = widget.CreateButton_Changed(...)

			if db.text.enable then
				local text = button.text or button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
				if text and text.GetTextColor then
					F.SetFontDB(text, db.text.font)

					text.SetPoint_Changed = text.SetPoint
					text.SetPoint = function(text, point, arg1, arg2, arg3, arg4)
						if point == "LEFT" and type(arg2) == "number" and abs(arg2 - 2) < 0.1 then
							arg2 = 0
						end

						text.SetPoint_Changed(text, point, arg1, arg2, arg3, arg4)
					end

					button.MERText = text
				end
			end

			if db.backdrop.enable then
				button:SetHighlightTexture("")
				if button.highlight then
					button.highlight:SetTexture("")
					button.highlight:Hide()
				end

				-- Create background
				button:SetHighlightTexture("")

				local bg = button:CreateTexture()
				bg:SetInside(button, 2, 0)
				bg:SetAlpha(0)
				bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

				if button.Center then
					local layer, subLayer = button.Center:GetDrawLayer()
					subLayer = subLayer and subLayer + 1 or 0
					bg:SetDrawLayer(layer, subLayer)
				end

				F.SetVertexColorDB(bg, db.backdrop.classColor and module.ClassColor or db.backdrop.color)

				button.MERAnimation = self.Animation(bg, db.backdrop.animationType, db.backdrop.animationDuration, db.backdrop.alpha)

				self:SecureHookScript(button, "OnEnter", button.MERAnimation.onEnter)
				self:SecureHookScript(button, "OnLeave", button.MERAnimation.onLeave)
				self:SecureHook(button, "Disable", button.MERAnimation.onStatusChange)
				self:SecureHook(button, "Enable", button.MERAnimation.onStatusChange)

				-- Avoid the hook is flushed
				self:SecureHook(button, "SetScript", function(frame, scriptType)
					if scriptType == "OnEnter" then
						self:Unhook(frame, "OnEnter")
						self:SecureHookScript(frame, "OnEnter", button.MERAnimation.onEnter)
					elseif scriptType == "OnLeave" then
						self:Unhook(frame, "OnLeave")
						self:SecureHookScript(frame, "OnLeave", button.MERAnimation.onLeave)
					end
				end)
			end

			if db.selected.enable then
				button:CreateBackdrop()
				button.backdrop:SetInside(button, 2, 0)
				local borderColor = db.selected.borderClassColor and module.ClassColor or db.selected.borderColor
				local backdropColor = db.selected.backdropClassColor and module.ClassColor or db.selected.backdropColor
				button.backdrop.Center:SetTexture(LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex)
				button.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, db.selected.borderAlpha)
				button.backdrop:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, db.selected.backdropAlpha)
				button.backdrop:Hide()
			end

			if db.selected.enable or db.text.enable then
				button.LockHighlight_Changed = button.LockHighlight
				button.LockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Show()
					end

					if frame.MERText then
						local color = db.text.selectedClassColor and module.ClassColor or db.text.selectedColor
						frame.MERText:SetTextColor(color.r, color.g, color.b)
					end
				end
				button.UnlockHighlight_Changed = button.UnlockHighlight
				button.UnlockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Hide()
					end

					if frame.MERText then
						local color = db.text.normalClassColor and module.ClassColor or db.text.normalColor
						frame.MERText:SetTextColor(color.r, color.g, color.b)
					end
				end
			end

			button.MERSkinned = true
			return button
		end
	end
end

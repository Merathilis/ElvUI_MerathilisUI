local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

local _G = _G

function module:HandleButton(_, button)
	if not button or button.MERSkin then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(button, function()
			self:HandleButton(nil, button)
		end)
		return
	end

	if not E.private.mui.skins.enable or not E.private.mui.skins.widgets.button.enable then
		return
	end

	local db = E.private.mui.skins.widgets.button

	if db.text.enable then
		local text = button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontDB(text, db.text.font)
		end
	end

	if db.backdrop.enable and (button.template or button.backdrop) then
		local parentFrame = button.backdrop or button

		-- Create background
		local bg = parentFrame:CreateTexture()
		bg:SetInside(parentFrame, 1, 1)
		bg:SetAlpha(0)
		bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

		if parentFrame.Center then
			local layer, subLayer = parentFrame.Center:GetDrawLayer()
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

		if db.backdrop.removeBorderEffect then
			parentFrame.SetBackdropBorderColor = E.noop
		end
	end

	button.MERSkin = true
end

function module:ElvUI_Config_SetButtonColor(_, btn)
	if not E.private.mui or not E.private.mui.skins.enable then
		return
	end

	if not E.private.mui.skins.widgets.button.enable or not E.private.mui.skins.widgets.button.selected.enable then
		return
	end

	if not btn.SetBackdropColor then
		return
	end

	local db = E.private.mui.skins.widgets.button

	if btn:IsEnabled() then
		local r1, g1, b1 = unpack(E.media.backdropcolor)
		btn:SetBackdropColor(r1, g1, b1, 1)

		local r2, g2, b2 = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r2, g2, b2, 1)
	else
		local borderColor = db.selected.borderClassColor and MER.ClassColor or db.selected.borderColor
		local backdropColor = db.selected.backdropClassColor and MER.ClassColor or db.selected.backdropColor
		btn:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, db.selected.borderAlpha)
		btn:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, db.selected.backdropAlpha)
	end
end

module:SecureHook(S, 'HandleButton')
module:SecureHook(E, 'Config_SetButtonColor', 'ElvUI_Config_SetButtonColor')

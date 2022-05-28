local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

local _G = _G
local strfind = strfind

function module:HandleButton(_, button)
	if not button or button.MERSkin then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(button, function()
			self:HandleButton(nil, button)
		end)
	end

	if not E.private.mui.skins.widgets.button.enable then
		return
	end

	local db = E.private.mui.skins.widgets.button

	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Arrow]])
			button.Icon:SetVertexColor(1, 1, 1)
			button.Icon:SetRotation(module.ArrowRotation['RIGHT'])
		end
	end

	if db.text.enable then
		local text = button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontDB(text, db.text.font)
		end
	end

	if button.template and (button.template or button.backdrop) then
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

		local group, onEnter, onLeave = self.Animation(bg, db.backdrop.animationType, db.backdrop.animationDuration, db.backdrop.alpha)
		button.MERAnimation = { bg = bg, group = group, onEnter = onEnter, onLeave = onLeave }

		self:SecureHookScript(button, "OnEnter", onEnter)
		self:SecureHookScript(button, "OnLeave", onLeave)

		-- Avoid the hook is flushed
		self:SecureHook(button, "SetScript", function(frame, scriptType)
			if scriptType == "OnEnter" then
				self:Unhook(frame, "OnEnter")
				self:SecureHookScript(frame, "OnEnter", onEnter)
			elseif scriptType == "OnLeave" then
				self:Unhook(frame, "OnLeave")
				self:SecureHookScript(frame, "OnLeave", onLeave)
			end
		end)

		if db.backdrop.removeBorderEffect then
			parentFrame.SetBackdropBorderColor = E.noop
		end
	end

	button.MERSkin = true
end

do
	S.Ace3_RegisterAsWidget_Changed = S.Ace3_RegisterAsWidget
	function S:Ace3_RegisterAsWidget(widget)
		S:Ace3_RegisterAsWidget_Changed(widget)
		module:HandleButton(nil, widget)
	end
end

module:SecureHook(S, 'HandleButton')

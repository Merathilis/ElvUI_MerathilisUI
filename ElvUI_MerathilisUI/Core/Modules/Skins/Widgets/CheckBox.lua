local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local module = MER.Modules.Skins
local WS = module.Widgets
local S = E.Skins

function WS:HandleAce3CheckBox(check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(check, "HandleAce3CheckBox")
		return
	end

	local db = E.private.mui and E.private.mui.skins and E.private.mui.skins.widgets and E.private.mui.skins.widgets.checkBox

	if not check or not db or not db.enable then
		return
	end

	if not check.MERSkin then
		check:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		check.SetTexture = E.noop
		check.MERSkin = true
	end

	if self.IsUglyYellow(check:GetVertexColor()) then
		F.SetVertexColorDB(check, db.classColor and module.ClassColor or db.color)
	end
end

do
	S.Ace3_CheckBoxSetDesaturated_Changed = S.Ace3_CheckBoxSetDesaturated
	function S.Ace3_CheckBoxSetDesaturated(check, value)
		S.Ace3_CheckBoxSetDesaturated_Changed(check, value)
		WS:HandleAce3CheckBox(check)
	end
end

function WS:HandleCheckBox(_, check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	local db = E.private.mui.skins.widgets.checkBox
	if not check or not db or not db.enable then
		return
	end

	if not check.MERSkin then
		if check.GetCheckedTexture then
			local tex = check:GetCheckedTexture()
			if tex then
				tex:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
				tex.SetTexture = E.noop
				F.SetVertexColorDB(tex, db.classColor and module.ClassColor or db.color)
				tex.SetVertexColor_Changed = tex.SetVertexColor
				tex.SetVertexColor = function(tex, ...)
					if self.IsUglyYellow(...) then
						local color = db.classColor and module.ClassColor or db.color
						tex:SetVertexColor_Changed(color.r, color.g, color.b, color.a)
					else
						tex:SetVertexColor_Changed(...)
					end
				end
			end
		end

		if check.GetDisabledTexture then
			local tex = check:GetDisabledTexture()
			if tex then
				tex.SetTexture_Changed = tex.SetTexture
				tex.SetTexture = function(tex, texPath)
					if not texPath then
						return
					end

					if texPath == "" then
						tex:SetTexture_Changed("")
					else
						tex:SetTexture_Changed(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
					end
				end
			end
		end

		check.MERSkin = true
	end
end

WS:SecureHook(S, 'HandleCheckBox')

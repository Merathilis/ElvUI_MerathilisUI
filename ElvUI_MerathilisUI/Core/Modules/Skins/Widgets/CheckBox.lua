local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

function module:HandleAce3CheckBox(check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	local db = E.private.mui.skins.widgets.checkBox

	if not check or not db or not db.enable then
		return
	end

	if not check.MERSkin then
		check:SetTexture(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
		check.SetTexture = E.noop
		check.MERSkin = true
	end

	if self.IsUglyYellow(check:GetVertexColor()) then
		F.SetVertexColorDB(check, db.elvUISkin.classColor and module.ClassColor or db.elvUISkin.color)
	end
end

do
	S.Ace3_CheckBoxSetDesaturated_ = S.Ace3_CheckBoxSetDesaturated
	function S.Ace3_CheckBoxSetDesaturated(check, value)
		S.Ace3_CheckBoxSetDesaturated_(check, value)
		module:HandleAce3CheckBox(check)
	end
end

function module:HandleCheckBox(_, check)
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
				tex:SetTexture(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
				tex.SetTexture = E.noop
				F.SetVertexColorDB(tex, db.elvUISkin.classColor and module.ClassColor or db.elvUISkin.color)
				tex.SetVertexColor_ = tex.SetVertexColor
				tex.SetVertexColor = function(tex, ...)
					if IsUglyYellow(...) then
						local color = db.elvUISkin.classColor and module.ClassColor or db.elvUISkin.color
						tex:SetVertexColor_(color.r, color.g, color.b, color.a)
					else
						tex:SetVertexColor_(...)
					end
				end
			end
		end

		if check.GetDisabledTexture then
			local tex = check:GetDisabledTexture()
			if tex then
				tex.SetTexture_ = tex.SetTexture
				tex.SetTexture = function(tex, texPath)
					if not texPath then
						return
					end

					if texPath == "" then
						tex:SetTexture_("")
					else
						tex:SetTexture_(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
					end
				end
			end
		end

		check.MERSkin = true
	end
end

module:SecureHook(S, 'HandleCheckBox')
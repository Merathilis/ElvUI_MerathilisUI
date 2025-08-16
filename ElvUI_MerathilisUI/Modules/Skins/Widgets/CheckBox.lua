local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local WS = module.Widgets
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

function WS:HandleAce3CheckBox(check)
	if not E.private.skins.checkBoxSkin then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(check, "HandleAce3CheckBox")
		return
	end

	local db = E.private.mui
		and E.private.mui.skins
		and E.private.mui.skins.widgets
		and E.private.mui.skins.widgets.checkBox

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
			local texture = check:GetCheckedTexture()
			if texture then
				texture:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
				texture.SetTexture = E.noop
				F.SetVertexColorDB(tex, db.classColor and module.ClassColor or db.color)
				texture.SetVertexColor_Changed = texture.SetVertexColor
				texture.SetVertexColor = function(tex, ...)
					local isDefaultColor = self.IsUglyYellow(...)
					if tex.__MERColorOverride and type(tex.__MERColorOverride) == "function" then
						local color = tex.__MERColorOverride(...)
						if type(color) == "table" and color.r and color.g and color.b then
							tex:SetVertexColor_Changed(color.r, color.g, color.b, color.a)
							return
						elseif type(color) == "string" and color == "DEFAULT" then
							isDefaultColor = true
						end
					end

					if isDefaultColor then
						local color = db.classColor and module.ClassColor or db.color
						tex:SetVertexColor_Changed(color.r, color.g, color.b, color.a)
					else
						tex:SetVertexColor_Changed(...)
					end
				end
			end
		end

		if check.GetDisabledTexture then
			local texture = check:GetDisabledTexture()
			if texture then
				texture.SetTexture_Changed = texture.SetTexture
				texture.SetTexture = function(tex, texPath)
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

WS:SecureHook(S, "HandleCheckBox")

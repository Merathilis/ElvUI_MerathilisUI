local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
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
		F.InternalizeMethod(check, "SetTexture", true)
		check.MERSkin = true
	end

	if self.IsUglyYellow(check:GetVertexColor()) then
		F.SetVertexColorDB(check, db.classColor and E.myClassColor or db.color)
	end
end

do
	S.Ace3_CheckBoxSetDesaturated_Changed = S.Ace3_CheckBoxSetDesaturated
	function S.Ace3_CheckBoxSetDesaturated(check, value)
		S.Ace3_CheckBoxSetDesaturated_Changed(check, value)
		WS:HandleAce3CheckBox(check)
	end
end

local function Tex_SetTexture(tex, texPath)
	if not texPath then
		return
	end

	if texPath == "" then
		F.CallMethod(tex, "SetTexture", "")
	else
		F.CallMethod(
			tex,
			"SetTexture",
			LSM:Fetch("statusbar", E.private.mui.skins.widgets.checkBox.texture) or E.media.normTex
		)
	end
end

local function Tex_SetVertexColor(tex, ...)
	local isDefaultColor = WS.IsUglyYellow(...)

	-- Let skin use its own logic to colorize the check texture
	if tex.__MERColorOverride and type(tex.__MERColorOverride) == "function" then
		local color = tex.__MERColorOverride(...)
		if type(color) == "table" and color.r and color.g and color.b then
			return F.CallMethod(tex, "SetVertexColor", color.r, color.g, color.b, color.a)
		elseif type(color) == "string" and color == "DEFAULT" then
			isDefaultColor = true
		end
	end

	if isDefaultColor then
		local color = E.private.mui.skins.widgets.checkBox.classColor and E.myClassColor
			or E.private.mui.skins.widgets.checkBox.color
		return F.CallMethod(tex, "SetVertexColor", color.r, color.g, color.b, color.a)
	end

	return F.CallMethod(tex, "SetVertexColor", ...)
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
				F.InternalizeMethod(texture, "SetTexture", true)
				F.SetVertexColorDB(tex, db.classColor and E.myClassColor or db.color)
				F.InternalizeMethod(texture, "SetVertexColor")
				texture.SetVertexColor = Tex_SetVertexColor
			end
		end

		if check.GetDisabledTexture then
			local texture = check:GetDisabledTexture()
			if texture then
				F.InternalizeMethod(texture, "SetTexture")
				texture.SetTexture = Tex_SetTexture
			end
		end

		check.MERSkin = true
	end
end

WS:SecureHook(S, "HandleCheckBox")

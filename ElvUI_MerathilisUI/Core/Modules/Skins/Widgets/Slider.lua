local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

function module:HandleSliderFrame(_, slider)
	local db = E.private.mui.skins.widgets.slider

	if not slider or not db or not db.enable then
		return
	end

	if not slider.MERSkinned then
		slider:SetThumbTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		slider.SetThumbTexture = E.noop
		slider.MERSkinned = true
	end

	F.SetVertexColorDB(slider:GetThumbTexture(), db.classColor and module.ClassColor or db.color)
end

module:SecureHook(S, "HandleSliderFrame")
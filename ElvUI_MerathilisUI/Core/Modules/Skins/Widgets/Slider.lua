local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local module = MER.Modules.Skins
local WS = module.Widgets
local S = E.Skins

function WS:HandleSliderFrame(_, slider)
	if not self:IsReady() then
		self:RegisterLazyLoad(slider, function()
			self:HandleSliderFrame(nil, slider)
		end)
		return
	end

	local db = E.private.mui and E.private.mui.skins and E.private.mui.skins.widgets and E.private.mui.skins.widgets.slider

	if not slider or not db or not db.enable then
		return
	end

	if not slider.MERSkinned and not slider.StripTextures_ and not slider.SetThumbTexture_ then
		slider:SetThumbTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		slider.StripTextures_ = slider.StripTextures
		slider.StripTextures = E.noop
		slider.SetThumbTexture_ = slider.SetThumbTexture
		slider.SetThumbTexture = E.noop
		slider.MERSkinned = true
	end

	F.SetVertexColorDB(slider:GetThumbTexture(), db.classColor and module.ClassColor or db.color)
end

WS:SecureHook(S, "HandleSliderFrame")

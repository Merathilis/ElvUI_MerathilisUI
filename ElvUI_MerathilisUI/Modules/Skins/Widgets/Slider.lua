local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = module.Widgets
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

function WS:HandleSliderFrame(_, slider)
	if not self:IsReady() then
		self:RegisterLazyLoad(slider, function()
			self:HandleSliderFrame(nil, slider)
		end)
		return
	end

	local db = E.private.mui
		and E.private.mui.skins
		and E.private.mui.skins.widgets
		and E.private.mui.skins.widgets.slider

	if not slider or not db or not db.enable then
		return
	end

	if not slider.MERSkinned and not slider.StripTextures_MER and not slider.SetThumbTexture_MER then
		slider:SetThumbTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		F.InternalizeMethod(slider, "StripTextures", true)
		F.InternalizeMethod(slider, "SetThumbTexture", true)
		slider.SetThumbTexture = E.noop

		slider.MERSkinned = true
	end

	F.SetVertexColorDB(slider:GetThumbTexture(), db.classColor and E.myClassColor or db.color)
end

WS:SecureHook(S, "HandleSliderFrame")

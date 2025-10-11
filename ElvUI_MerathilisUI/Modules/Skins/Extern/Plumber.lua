local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local unpack = unpack

local function OnScrollViewUpdateView(view)
	for _, line in pairs({ view:GetChildren() }) do
		if line.Icon and not line.Icon.backdrop then
			line.Icon:SetTexCoord(unpack(E.TexCoords))
			line.Icon:CreateBackdrop()
		end
	end
end

local function OnDefaultFrameShow(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child.Icon and not child.Icon.backdrop then
			child.Icon:SetTexCoord(unpack(E.TexCoords))
			child.Icon:CreateBackdrop()
		end

		if child.ScrollView and not child.__MERSkin then
			child:StripTextures()
			if child.ScrollView.UpdateView then
				hooksecurefunc(child.ScrollView, "UpdateView", OnScrollViewUpdateView)
				OnScrollViewUpdateView(child.ScrollView)
			end
			child.__MERSkin = true
		end
	end
end

function module:Plumber()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.plumber then
		return
	end

	local PlumberExpansionLandingPage = _G.PlumberExpansionLandingPage

	local LeftSection = PlumberExpansionLandingPage and PlumberExpansionLandingPage.LeftSection
	if LeftSection and LeftSection.NineSlice then
		LeftSection.NineSlice:StripTextures()
		LeftSection.NineSlice:CreateBackdrop("Transparent")
		LeftSection.NineSlice.backdrop:SetOutside(LeftSection.NineSlice, 30)
		self:CreateBackdropShadow(LeftSection.NineSlice)
		self:Reposition(LeftSection.NineSlice.backdrop, LeftSection.NineSlice, 30, 0, 0, 0, 0)
	end

	if LeftSection.DefaultFrame then
		LeftSection.DefaultFrame:HookScript("OnShow", OnDefaultFrameShow)
		PlumberExpansionLandingPage:HookScript("OnShow", function()
			OnDefaultFrameShow(LeftSection.DefaultFrame)
		end)
	end

	local RightSection = PlumberExpansionLandingPage and PlumberExpansionLandingPage.RightSection
	if RightSection and RightSection.NineSlice then
		RightSection.NineSlice:StripTextures()
		RightSection.NineSlice:CreateBackdrop("Transparent")
		RightSection.NineSlice.backdrop:SetOutside(RightSection.NineSlice, 30)
		self:CreateBackdropShadow(RightSection.NineSlice)
		self:Reposition(RightSection.NineSlice.backdrop, RightSection.NineSlice, 30, 0, 0, 0, 0)
		local CloseButton = RightSection.NineSlice.CloseButton
		if CloseButton then
			CloseButton.Texture = nil
			self:Proxy("HandleCloseButton", CloseButton)
		end
	end
end

module:AddCallbackForAddon("Plumber")

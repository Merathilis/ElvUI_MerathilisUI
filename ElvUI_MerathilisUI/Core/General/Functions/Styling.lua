local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G
local assert = assert
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable
local pairs, select, unpack = pairs, select, unpack

local CreateFrame = CreateFrame
local CreateColor = CreateColor

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

MER.Styling = {}

function MER:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
    gf:SetTexture(E.media.blankTex)

	if E.Retail then
		gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
	else
		gf:SetGradientAlpha(o, r1, g1, b1, a1, r2, g2, b2, a2)
	end
end

function MER:UpdateStyling()
	if E.private.mui.skins.style then
		for MERstyle in pairs(MER.Styling) do
			if MERstyle.stripes then MERstyle.stripes:Show() end
			if MERstyle.mshadow then MERstyle.mshadow:Show() end
		end
	else
		for MERstyle in pairs(MER.Styling) do
			if MERstyle.stripes then MERstyle.stripes:Hide() end
			if MERstyle.mshadow then MERstyle.mshadow:Hide() end
		end
	end
end

local function Styling(f, useStripes, useShadow)
	assert(f, "doesn't exist!")

	if not f or f.__style or f.MERstyle or f.style__MER then
		return
	end

	if not E.private.mui.skins.enable then
		return
	end

	if f:GetObjectType() == "Texture" then
		f = f:GetParent()
	end

	local frameName = f.GetName and f:GetName()

	local style = CreateFrame("Frame", frameName or nil, f, "BackdropTemplate")

	if not(useStripes) then
		local stripes = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER")
		stripes:ClearAllPoints()
		stripes:Point("TOPLEFT", 1, -1)
		stripes:Point("BOTTOMRIGHT", -1, 1)
		stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\stripes]], true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")

		style.stripes = stripes

		if not E.private.mui.skins.style then stripes:Hide() end
	end

	if not(useShadow) then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:Width(33)
		mshadow:Height(33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Overlay]])
		mshadow:SetVertexColor(1, 1, 1, 0.6)

		style.mshadow = mshadow

		if not E.private.mui.skins.style then mshadow:Hide() end
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(f:GetFrameLevel() + 1)
	style:SetAllPoints(f)
	style.__MER = true

	f.MERstyle = style
	f.__style = 1

	MER.Styling[style] = true
end

local BlizzardFrameRegions = {
	'Inset',
	'inset',
	'LeftInset',
	'RightInset',
	'NineSlice',
	'BorderFrame',
	'bottomInset',
	'BottomInset',
	'bgLeft',
	'bgRight',
}

local function StripFrame(Frame, Kill, Alpha)
	local FrameName = Frame:GetName()
	for _, Blizzard in pairs(BlizzardFrameRegions) do
		local BlizzFrame = Frame[Blizzard] or FrameName and _G[FrameName..Blizzard]
		if BlizzFrame then
			StripFrame(BlizzFrame, Kill, Alpha)
		end
	end
	if Frame.GetNumRegions then
		for i = 1, Frame:GetNumRegions() do
			local Region = select(i, Frame:GetRegions())
			if Region and Region:IsObjectType('Texture') then
				if Kill then
					Region:Hide()
					Region.Show = MER.dummy
				elseif Alpha then
					Region:SetAlpha(0)
				else
					Region:SetTexture(nil)
				end
			end
		end
	end
end

local function CreateOverlay(f)
	if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:Point("TOPLEFT", -E.mult, E.mult)
		border:Point("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:CreateBackdrop()

	if t == "Transparent" then
		backdropa = 0.45
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = 1
	end

	f.backdrop:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f.backdrop:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
	if not object.StripFrame then mt.StripFrame = StripFrame end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

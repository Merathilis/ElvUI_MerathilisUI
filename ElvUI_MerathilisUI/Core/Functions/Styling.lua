local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule("MER_Skins")

local _G = _G
local assert = assert
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable
local pairs, select, unpack = pairs, select, unpack

local CreateFrame = CreateFrame
local CreateColor = CreateColor

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

function MER:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(E.media.blankTex)
	gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

local function CreateOverlay(f)
	if f.overlay then
		return
	end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then
			return
		end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then
			return
		end
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
		S:CreateBackdropShadow(f.backdrop)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
		S:CreateBackdropShadow(f.backdrop)
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

	if not object.CreateOverlay then
		mt.CreateOverlay = CreateOverlay
	end
	if not object.CreateBorder then
		mt.CreateBorder = CreateBorder
	end
	if not object.CreatePanel then
		mt.CreatePanel = CreatePanel
	end
end

local handled = { ["Frame"] = true }
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())
addapi(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

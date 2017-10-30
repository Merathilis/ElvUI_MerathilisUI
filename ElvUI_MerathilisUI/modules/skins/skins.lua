local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = E:NewModule("muiSkins", "AceHook-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
MERS.modName = L["Skins/AddOns"]

-- Cache global variables
-- Lua functions
local _G = _G
local assert, pairs, select, unpack = assert, pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: stripes, StartGlow, StopGlow, ElvUI

local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]
local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local bordercolorr, bordercolorg, bordercolorb

-- Code taken from CodeNameBlaze
-- Copied from ElvUI
local function SetModifiedBackdrop(self)
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
end

-- Copied from ElvUI
local function SetOriginalBackdrop(self)
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E["media"].bordercolor))
end

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

-- BenikUI Styles
function MERS:StyleOutside(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Outside")
	end
end

function MERS:StyleInside(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Inside")
	end
end
function MERS:StyleSmall(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Small")
	end
end

function MERS:StyleUnder(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Under")
	end
end

-- Underlines
function MERS:Underline(frame, shadow, height)
	local line = CreateFrame("Frame", nil, frame)
	if line then
		line:SetPoint("BOTTOM", frame, -1, 1)
		line:SetSize(frame:GetWidth(), height or 1)
		line.Texture = line:CreateTexture(nil, "OVERLAY")
		line.Texture:SetTexture(flat)
		line.Texture:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		if shadow then
			if shadow == "backdrop" then
				line:CreateShadow()
			else
				line:CreateBackdrop()
			end
		end
		line.Texture:SetAllPoints(line)
	end
	return line
end

function MERS:CreateWideShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = f.shadow or CreateFrame("Frame", nil, f) -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 6, 6)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(6),
		insets = {left = E:Scale(8), right = E:Scale(8), top = E:Scale(8), bottom = E:Scale(8)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.5)
	f.shadow = shadow
end

function MERS:CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = f.shadow or CreateFrame("Frame", nil, f) -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 2, 2)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.shadow = shadow
end

-- Create shadow for textures
function MERS:CreateSD(f, m, s, n)
	if f.Shadow then return end
	local frame = f
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	end
	local lvl = frame:GetFrameLevel()

	f.Shadow = CreateFrame("Frame", nil, frame)
	f.Shadow:SetPoint("TOPLEFT", f, -m, m)
	f.Shadow:SetPoint("BOTTOMRIGHT", f, m, -m)
	f.Shadow:SetBackdrop({
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = s })
	f.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow:SetFrameLevel(n or lvl)
	return f.Shadow
end

function MERS:CreateBG(frame)
	assert(frame, "doesn't exist!")
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -1, 1)
	bg:Point("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(E["media"].blankTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- frame text
function MERS:CreateFS(f, size, text, classcolor, anchor, x, y)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(nil, nil, 'OUTLINE')
	fs:SetText(text)
	fs:SetWordWrap(false)
	if classcolor then
		fs:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	end
	if (anchor and x and y) then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
end

function MERS:CreateSoftGlow(f)
	if f.sglow then return end

	local sglow = CreateFrame("Frame", nil, f)
	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 2, 2)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	sglow:SetBackdropColor(MER:unpackColor(E.db.general.valuecolor), 0)
	sglow:SetBackdropBorderColor(MER:unpackColor(E.db.general.valuecolor), 0.4)
	f.sglow = sglow
end

-- Gradient Frame
function MERS:CreateGF(f, w, h, o, r, g, b, a1, a2)
	assert(f, "doesn't exist!")
	f:SetSize(w, h)
	f:SetFrameStrata("BACKGROUND")
	local gf = f:CreateTexture(nil, "BACKGROUND")
	gf:SetPoint("TOPLEFT", f, -1, 1)
	gf:SetPoint("BOTTOMRIGHT", f, 1, -1)
	gf:SetTexture(E["media"].muiNormTex)
	gf:SetVertexColor(r, g, b)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- Gradient Texture
function MERS:CreateGradient(f)
	assert(f, "doesn't exist!")
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gradient.tga]])
	tex:SetVertexColor(.3, .3, .3, .15)

	return tex
end

-- Taken from AddOnSkins 
function MERS:SkinTexture(frame)
	frame:SetTexCoord(unpack(E.TexCoords))
end

function MERS:SetTemplate(Frame, Template, UseTexture, TextureFile)
	local Texture = E["media"].muiBlank

	if UseTexture then
		Texture = TextureFile or E["media"].muiNormTex
	end

	Frame:SetBackdrop({
		bgFile = Texture,
		edgeFile = E["media"].muiBlank,
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0},
	})

	if not Frame.isInsetDone then
		Frame.InsetTop = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetTop:Point("TOPLEFT", Frame, "TOPLEFT", -1, 1)
		Frame.InsetTop:Point("TOPRIGHT", Frame, "TOPRIGHT", 1, -1)
		Frame.InsetTop:Height(1)
		Frame.InsetTop:SetColorTexture(0, 0, 0)
		Frame.InsetTop:SetDrawLayer("BORDER", -7)

		Frame.InsetBottom = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetBottom:Point("BOTTOMLEFT", Frame, "BOTTOMLEFT", -1, -1)
		Frame.InsetBottom:Point("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 1, -1)
		Frame.InsetBottom:Height(1)
		Frame.InsetBottom:SetColorTexture(0, 0, 0)
		Frame.InsetBottom:SetDrawLayer("BORDER", -7)

		Frame.InsetLeft = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetLeft:Point("TOPLEFT", Frame, "TOPLEFT", -1, 1)
		Frame.InsetLeft:Point("BOTTOMLEFT", Frame, "BOTTOMLEFT", 1, -1)
		Frame.InsetLeft:Width(1)
		Frame.InsetLeft:SetColorTexture(0, 0, 0)
		Frame.InsetLeft:SetDrawLayer("BORDER", -7)

		Frame.InsetRight = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetRight:Point("TOPRIGHT", Frame, "TOPRIGHT", 1, 1)
		Frame.InsetRight:Point("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -1, -1)
		Frame.InsetRight:Width(1)
		Frame.InsetRight:SetColorTexture(0, 0, 0)
		Frame.InsetRight:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideTop = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideTop:Point("TOPLEFT", Frame, "TOPLEFT", 1, -1)
		Frame.InsetInsideTop:Point("TOPRIGHT", Frame, "TOPRIGHT", -1, 1)
		Frame.InsetInsideTop:Height(1)
		Frame.InsetInsideTop:SetColorTexture(0, 0, 0)
		Frame.InsetInsideTop:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideBottom = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideBottom:Point("BOTTOMLEFT", Frame, "BOTTOMLEFT", 1, 1)
		Frame.InsetInsideBottom:Point("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -1, 1)
		Frame.InsetInsideBottom:Height(1)
		Frame.InsetInsideBottom:SetColorTexture(0, 0, 0)
		Frame.InsetInsideBottom:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideLeft = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideLeft:Point("TOPLEFT", Frame, "TOPLEFT", 1, -1)
		Frame.InsetInsideLeft:Point("BOTTOMLEFT", Frame, "BOTTOMLEFT", -1, 1)
		Frame.InsetInsideLeft:Width(1)
		Frame.InsetInsideLeft:SetColorTexture(0, 0, 0)
		Frame.InsetInsideLeft:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideRight = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideRight:Point("TOPRIGHT", Frame, "TOPRIGHT", -1, -1)
		Frame.InsetInsideRight:Point("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 1, 1)
		Frame.InsetInsideRight:Width(1)
		Frame.InsetInsideRight:SetColorTexture(0, 0, 0)
		Frame.InsetInsideRight:SetDrawLayer("BORDER", -7)

		Frame.isInsetDone = true
	end
	local R, G, B = unpack(E["media"].backdropcolor)
	local Alpha = (Template == "Transparent" and .8 or 1)

	Frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	Frame:SetBackdropColor(R, G, B, Alpha)
end

function MERS:CreateBackdrop(Frame, Template, UseTexture, TextureFile)
	if Frame.Backdrop then return end

	local Backdrop = CreateFrame("Frame", nil, Frame)
	Backdrop:SetOutside()
	MERS:SetTemplate(Backdrop, Template, UseTexture, TextureFile)

	if Frame:GetFrameLevel() - 1 >= 0 then
		Backdrop:SetFrameLevel(Frame:GetFrameLevel() - 1)
	else
		Backdrop:SetFrameLevel(0)
	end

	Frame.Backdrop = Backdrop
end

function MERS:CreateBDFrame(f, a, left, right, top, bottom)
	assert(f, "doesn't exist!")
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, left or -1, top or 1)
	bg:SetPoint("BOTTOMRIGHT", f, right or 1, bottom or -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	MERS:CreateBD(bg, a or .5)

	return bg
end

function MERS:CreateBD(f, a)
	assert(f, "doesn't exist!")
	f:SetBackdrop({
		bgFile = E["media"].blankTex,
		edgeFile = E["media"].blankTex,
		edgeSize = E.mult,
	})
	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
end

function MERS:Reskin(f, noGlow)
	assert(f, "doesn't exist!")
	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	f:StripTextures()
	f:SetTemplate("Transparent", true)
	f.backdropTexture:SetAlpha(0.75)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
				edgeFile = E["media"].muiglowTex,
				edgeSize = E:Scale(4),
			})
		f.glow:SetOutside(f, 4, 4)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end

	if not f.tex then
		f.tex = MERS:CreateGradient(f)
	else
		f.gradient = MERS:CreateGradient(f)
	end
end

function MERS:SkinBackdropFrame(frame, template, override, kill, setpoints)
	if not override then MERS:StripTextures(frame, kill) end
	MERS:CreateBackdrop(frame, template)
	if setpoints then
		frame.Backdrop:SetAllPoints()
	end
end

function MERS:StripTextures(Object, Kill, Alpha)
	for i = 1, Object:GetNumRegions() do
		local Region = select(i, Object:GetRegions())
		if Region and Region:GetObjectType() == "Texture" then
			if Kill then
				Region:Kill()
			elseif Alpha then
				Region:SetAlpha(0)
			else
				Region:SetTexture(nil)
			end
		end
	end
end

function MERS:SkinStatusBar(frame, ClassColor)
	MERS:SkinBackdropFrame(frame)
	frame:SetStatusBarTexture(AS.NormTex)
	if ClassColor then
		frame:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	end
	ElvUI[1]:RegisterStatusBar(_G["Frame"])
end

-- ClassColored ScrollBars
function MERS:ReskinScrollBar(frame, thumbTrim)
	if frame:GetName() then
		if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
			if frame.thumbbg and frame.thumbbg.backdropTexture then
				frame.thumbbg.backdropTexture.SetVertexColor = nil
				frame.thumbbg.backdropTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
				frame.thumbbg.backdropTexture.SetVertexColor = E.noop
			end
		end
	else
		if frame.ScrollUpButton and frame.ScrollDownButton then
			if frame.thumbbg and frame.thumbbg.backdropTexture then
				frame.thumbbg.backdropTexture.SetVertexColor = nil
				frame.thumbbg.backdropTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
				frame.thumbbg.backdropTexture.SetVertexColor = E.noop
			end
		end
	end
end
hooksecurefunc(S, "HandleScrollBar", MERS.ReskinScrollBar)

-- Overwrite ElvUI Tabs function to be transparent
function MERS:ReskinTab(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:Styling()
	end
end
hooksecurefunc(S, "HandleTab", MERS.ReskinTab)

function MERS:CreateBackdropTexture(f)
	assert(f, "doesn't exist!")
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture(E["media"].muiNormTex)
	tex:SetVertexColor(backdropcolorr, backdropcolorg, backdropcolorb)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

function MERS:CreatePulse(frame, speed, alpha, mult)
	assert(frame, "doesn't exist!")
	frame.speed = .02
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		elapsed = elapsed * ( speed or 5/4 )
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha*(alpha or 3/5))
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .5)
	f:SetBackdropBorderColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	if not E.PixelMode then
		f.glow:SetAlpha(1)
		MERS:CreatePulse(f.glow)
	end
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

function MERS:Reskin(f, noGlow)
	assert(f, "doesn't exist!")

	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end

	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	if f.backdrop then f.backdrop:Hide() end

	MERS:CreateBackdropTexture(f)
	f.backdropTexture:SetAlpha(0.75)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = E["media"].glow,
			edgeSize = E:Scale(4),
		})
		f.glow:SetOutside(f, 4, 4)
		f.glow:SetBackdropBorderColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end

	if not f.tex then
		f.tex = MERS:CreateGradient(f)
	else
		f.gradient = MERS:CreateGradient(f)
	end
end
hooksecurefunc(S, "HandleButton", MERS.Reskin)

function MERS:ReskinCheckBox(frame, noBackdrop, noReplaceTextures)
	assert(frame, "does not exist.")

	frame:SetNormalTexture("")
	frame:SetPushedTexture("")
	frame:SetHighlightTexture(E["media"].muiBlank)

	MERS:CreateBackdropTexture(frame)
	frame.backdropTexture:SetInside(frame, 5, 5)

	local bd = CreateFrame("Frame", nil, frame)
	bd:SetInside(frame, 4, 4)
	bd:SetFrameLevel(frame:GetFrameLevel())
	MERS:CreateBD(bd, 0)

	local tex = MERS:CreateGradient(frame)
	tex:SetInside(frame, 5, 5)

	local ch = frame:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
end
hooksecurefunc(S, "HandleCheckBox", MERS.ReskinCheckBox)

function MERS:ReskinIcon(icon)
	icon:SetTexCoord(unpack(E.TexCoords))
	return MERS:CreateBDFrame(icon)
end

function MERS:SmallItemButtonTemplate(button)
	local icon = button.Icon
	icon:SetSize(29, 29)
	button._mUIIconBorder = MERS:ReskinIcon(icon)

	local nameFrame = button.NameFrame
	nameFrame:SetAlpha(0)

	local bg = CreateFrame("Frame", nil, button)
	bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
	bg:SetPoint("BOTTOMRIGHT", nameFrame, 0, 0)
	MERS:CreateBD(bg, .2)
end

function MERS:LargeItemButtonTemplate(button)
	local icon = button.Icon
	button._mUIIconBorder = MERS:ReskinIcon(icon)

	local nameFrame = button.NameFrame
	nameFrame:SetAlpha(0)

	local bg = CreateFrame("Frame", nil, button)
	bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
	bg:SetPoint("BOTTOMRIGHT", -3, 1)
	MERS:CreateBD(bg, .2)
end

-- Reskin AddOnSkins
if not IsAddOnLoaded("AddOnSkins") then return end
local AS = unpack(AddOnSkins)

local BlizzardRegions = {
	"Left",
	"Middle",
	"Right",
	"Mid",
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
}

function AS:SkinTab(Tab, Strip)
	if Tab.isSkinned then return end
	local TabName = Tab:GetName()

	if TabName then
		for _, Region in pairs(BlizzardRegions) do
			if _G[TabName..Region] then
				_G[TabName..Region]:SetTexture(nil)
			end
		end
	end

	for _, Region in pairs(BlizzardRegions) do
		if Tab[Region] then
			Tab[Region]:SetAlpha(0)
		end
	end

	if Tab.GetHighlightTexture and Tab:GetHighlightTexture() then
		Tab:GetHighlightTexture():SetTexture(nil)
	else
		Strip = true
	end

	if Strip then
		AS:StripTextures(Tab)
	end

	AS:CreateBackdrop(Tab)

	if AS:CheckAddOn("ElvUI") and AS:CheckOption("ElvUISkinModule") then
		-- Check if ElvUI already provides the backdrop. Otherwise we have two backdrops (e.g. Auctionhouse)
		if Tab.backdrop then
			Tab.Backdrop:Hide()
		else
			AS:SetTemplate(Tab.Backdrop, "Transparent") -- Set it to transparent
			Tab.Backdrop:Styling()
		end
	end

	Tab.Backdrop:Point("TOPLEFT", 10, AS.PixelPerfect and -1 or -3)
	Tab.Backdrop:Point("BOTTOMRIGHT", -10, 3)

	Tab.isSkinned = true
end

function MERS:Initialize()
	self.db = E.private.muiSkins

	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(E["media"].backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(E["media"].backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(E["media"].bordercolor)
end

local function InitializeCallback()
	MERS:Initialize()
end

E:RegisterModule(MERS:GetName(), InitializeCallback)
local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins");
local MERS = E:NewModule("muiSkins", "AceHook-3.0", "AceEvent-3.0");

-- Cache global variables
-- Lua functions
local _G = _G
local select, type, unpack = select, type, unpack
-- WoW API / Variables
local InCombatLockdown = InCombatLockdown

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

-- Original close buttons, but desaturated. Like it used to be in ElvUI.
function MERS:HandleCloseButton(f, point, text)
	for i = 1, f:GetNumRegions() do
		local region = select(i, f:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
			for n = 1, #buttons do
				local texture = buttons[n]
				if region:GetTexture() == "Interface\\Buttons\\"..texture then
					f.noBackdrop = true
				end
			end
			if region:GetTexture() == "Interface\\DialogFrame\\UI-DialogBox-Corner" then
				region:Kill()
			end
		end
	end

	-- Create backdrop for the few close buttons that do not use original close button
	if not f.backdrop and not f.noBackdrop then
		f:CreateBackdrop("Default", true)
		f.backdrop:Point("TOPLEFT", 7, -8)
		f.backdrop:Point("BOTTOMRIGHT", -8, 8)
		f:HookScript("OnEnter", SetModifiedBackdrop)
		f:HookScript("OnLeave", SetOriginalBackdrop)
	end

	-- Have to create the text, ElvUI code expects the element to be there. It won"t show up for original close buttons anyway.
	if not f.text then
		f.text = f:CreateFontString(nil, "OVERLAY")
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, "OUTLINE")
		f.text:SetText(text)
		f.text:SetJustifyH("CENTER")
		f.text:SetPoint("CENTER", f, "CENTER")
	end

	-- Hide text if button is using original skin
	if f.text and f.noBackdrop then
		f.text:SetAlpha(0)
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

-- ClassColored ScrollBars
function MERS:HandleScrollBar(frame, thumbTrim)
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
hooksecurefunc(S, "HandleScrollBar", MERS.HandleScrollBar)

E:RegisterModule(MERS:GetName())
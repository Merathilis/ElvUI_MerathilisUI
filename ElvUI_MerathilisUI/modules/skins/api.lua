local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = MER:NewModule("muiSkins", "AceHook-3.0", "AceEvent-3.0")
MERS.modName = L["Skins/AddOns"]

-- Cache global variables
-- Lua functions
local _G = _G
local assert, pairs, select, unpack, type = assert, pairs, select, unpack, type
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AddOnSkins, stripes

local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]
local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local unitFrameColorR, unitFrameColorG, unitFrameColorB
local rgbValueColorR, rgbValueColorG, rgbValueColorB
local bordercolorr, bordercolorg, bordercolorb

local r, g, b = unpack(E["media"].rgbvaluecolor)

MERS.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MERS.TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

function S:HandleCloseButton(f, point, text)
	if not E.db.mui or not E.private.muiSkins then
		return
	end

	if E.private.muiSkins.closeButton then
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
	else
		f:StripTextures()
		if not text then text = 'x' end
	end

	-- Create backdrop for the few close buttons that do not use original close button
	if not f.backdrop then
		f:CreateBackdrop("Default", true)
		f.backdrop:Point("TOPLEFT", 5, -6)
		f.backdrop:Point("BOTTOMRIGHT", -6, 6)
		f.backdrop:SetFrameLevel(f:GetFrameLevel())
		f:HookScript("OnEnter", MERS.ColorButton)
		f:HookScript("OnLeave", MERS.ClearButton)
	end

	-- ElvUI code expects the element to be there. It won't show up for original close buttons.
	if not f.text then
		f.text = f:CreateFontString(nil, "OVERLAY")
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH("CENTER")
		f.text:Point("CENTER", f, "CENTER")
	end

	-- Use a own texture for the close button.
	if E.private.muiSkins.closeButton and not f.tex then
		f.tex = f:CreateTexture(nil, "OVERLAY")
		f.tex:Size(12)
		f.tex:Point("CENTER", -1, 0)
		f.tex:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\close.tga")
		f.tex:SetDrawLayer("OVERLAY")
	end

	-- Hide text if button is using original skin
	if f.text and f.noBackdrop then
		f.text:SetAlpha(0)
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

function MERS:ReskinEditBox(frame)
	if frame.backdrop then
		frame.backdrop:Hide()
	end

	local bg = MERS:CreateBDFrame(frame, 0)
	bg:SetAllPoints()
	MERS:CreateGradient(bg)
end

function MERS:ReskinDropDownBox(frame, width)
	local button = _G[frame:GetName().."Button"]
	if not button then return end

	if not width then width = 155 end

	-- Hide ElvUI's backdrop
	if frame.backdrop then
		frame.backdrop:Hide()
	end

	local bg = MERS:CreateBDFrame(frame, 0)
	bg:Point("TOPLEFT", 20, -2)
	bg:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	bg:Width(width)
	MERS:CreateGradient(bg)
end

function S:HandleDropDownFrame(frame, width)
	if not width then width = 155 end

	local left = frame.Left
	local middle = frame.Middle
	local right = frame.Right
	if left then
		left:SetAlpha(0)
		left:SetSize(25, 64)
		left:SetPoint("TOPLEFT", 0, 17)
	end
	if middle then
		middle:SetAlpha(0)
		middle:SetHeight(64)
	end
	if right then
		right:SetAlpha(0)
		right:SetSize(25, 64)
	end

	local button = frame.Button
	if button then
		button:SetSize(24, 24)
		button:ClearAllPoints()
		button:Point("RIGHT", right, "RIGHT", -20, 1)

		button.NormalTexture:SetTexture("")
		button.PushedTexture:SetTexture("")
		button.HighlightTexture:SetTexture("")

		hooksecurefunc(button, "SetPoint", function(btn, _, _, _, _, _, noReset)
			if not noReset then
				btn:ClearAllPoints()
				btn:SetPoint("RIGHT", frame, "RIGHT", E:Scale(-20), E:Scale(1), true)
			end
		end)

		self:HandleNextPrevButton(button, true)
	end

	local disabled = button and button.DisabledTexture
	if disabled then
		disabled:SetAllPoints(button)
		disabled:SetColorTexture(0, 0, 0, .3)
		disabled:SetDrawLayer("OVERLAY")
	end

	if middle and (not frame.noResize) then
		frame:SetWidth(40)
		middle:SetWidth(width)
	end

	if right and frame.Text then
		frame.Text:SetSize(0, 10)
		frame.Text:SetPoint("RIGHT", right, -43, 2)
	end

	-- Hide ElvUI's backdrop
	if frame.backdrop then
		frame.backdrop:Hide()
	end

	local bg = MERS:CreateBDFrame(frame, 0)
	bg:SetPoint("TOPLEFT", left, 20, -21)
	bg:SetPoint("BOTTOMRIGHT", right, -19, 23)
	bg:SetFrameLevel(frame:GetFrameLevel())
	bg:Width(width)
	MERS:CreateGradient(bg)
end

-- Create shadow for textures
function MERS:CreateSD(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		bgFile =  E.LSM:Fetch("background", "ElvUI Blank"),
		edgeFile = E.LSM:Fetch("border", "ElvUI GlowBorder"),
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetBackdropColor(r or 0, g or 0, b or 0, alpha or 0)

	return sd
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
		fs:SetTextColor(r, g, b)
	end
	if (anchor and x and y) then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
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
function MERS:SetTemplate(frame, texture)
	texture = E["media"].normTex

	if texture then
		texture = texture or E["media"].normTex
	end

	frame:SetBackdrop({
		bgFile = texture,
		edgeFile = E["media"].muiBlank,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0},
	})

	frame:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	frame:SetBackdropColor(backdropcolorr, backdropcolorg, backdropcolorb, .8 or 1)
end

function MERS:CreateBackdrop(frame, texture)
	if frame.backdrop then return end

	local parent = frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = CreateFrame("Frame", nil, parent)
	backdrop:SetOutside(frame)
	MERS:SetTemplate(backdrop, texture)

	if (parent:GetFrameLevel() - 1) >= 0 then
		backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		backdrop:SetFrameLevel(0)
	end

	frame.backdrop = backdrop
end

function MERS:CreateBDFrame(f, a, left, right, top, bottom)
	assert(f, "doesn't exist!")

	local frame
	if f:IsObjectType('Texture') then
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
		bgFile = E["media"].normTex,
		edgeFile = E["media"].normTex,
		edgeSize = E.mult,
	})

	f:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
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

-- ClassColored ScrollBars
function MERS:ReskinScrollBar(frame, thumbTrim)
	if frame:GetName() then
		if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
			if frame.thumbbg and frame.thumbbg.backdropTexture then
				frame.thumbbg.backdropTexture.SetVertexColor = nil
				frame.thumbbg.backdropTexture:SetVertexColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
				frame.thumbbg.backdropTexture.SetVertexColor = E.noop
			end
		end
	else
		if frame.ScrollUpButton and frame.ScrollDownButton then
			if frame.thumbbg and frame.thumbbg.backdropTexture then
				frame.thumbbg.backdropTexture.SetVertexColor = nil
				frame.thumbbg.backdropTexture:SetVertexColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
				frame.thumbbg.backdropTexture.SetVertexColor = E.noop
			end
		end
	end
end

function MERS:ReskinScrollSlider(Slider, thumbTrim)
	local parent = Slider:GetParent()

	if Slider.thumbbg then
		Slider.thumbbg.backdropTexture.SetVertexColor = nil
		Slider.thumbbg.backdropTexture:SetVertexColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
		Slider.thumbbg.backdropTexture.SetVertexColor = E.noop
	end
end

-- ClassColored Sliders
function MERS:ReskinSliderFrame(frame)
	assert(frame)

	local orientation = frame:GetOrientation()
	local SIZE = 12

	frame:StripTextures()
	if frame.backdrop then frame.backdrop:Hide() end

	MERS:CreateBDFrame(frame)
	MERS:CreateGradient(frame)

	hooksecurefunc(frame, "SetBackdrop", function(slider, backdrop)
		if backdrop ~= nil then slider:SetBackdrop(nil) end
	end)

	frame:SetThumbTexture(E["media"].normTex)
	frame:GetThumbTexture():SetVertexColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
	frame:GetThumbTexture():Size(SIZE-2,SIZE-2)

	if orientation == 'VERTICAL' then
		frame:Width(SIZE)
	else
		frame:Height(SIZE)

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region and region:GetObjectType() == 'FontString' then
				local point, anchor, anchorPoint, x, y = region:GetPoint()
				if anchorPoint:find('BOTTOM') then
					region:Point(point, anchor, anchorPoint, x, y - 4)
				end
			end
		end
	end
end

-- Overwrite ElvUI Tabs function to be transparent
function MERS:ReskinTab(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:Styling()
	end
end

function MERS:CreateBackdropTexture(f)
	assert(f, "doesn't exist!")
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", 1)
	tex:SetInside(f, 1, 1)
	tex:SetTexture(E["media"].normTex)
	tex:SetVertexColor(backdropcolorr, backdropcolorg, backdropcolorb)
	tex:SetAlpha(0.8)
	f.backdropTexture = tex
end

function MERS:ColorButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(r, g, b, .3)
	self:SetBackdropBorderColor(r, g, b)
end

function MERS:ClearButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(unitFrameColorR, unitFrameColorG, unitFrameColorB)
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

local blizzardRegions = {
	"Left",
	"Middle",
	"Right",
	"Mid",
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"LeftSeparator",
	"RightSeparator",
}

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	MER:CreatePulse(f.glow)
end

local function StopGlow(f)
	f.glow:SetScript("OnUpdate", nil)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetAlpha(0)
end

-- Buttons
function MERS:Reskin(f, strip, noHighlight, noGlow)
	assert(f, "doesn't exist!")

	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end

	local buttonName = f:GetName()

	for _, region in pairs(blizzardRegions) do
		if buttonName and _G[buttonName..region] then
			_G[buttonName..region]:SetAlpha(0)
		end
		if f[region] then
			f[region]:SetAlpha(0)
		end
	end

	if f.backdrop then f.backdrop:Hide() end
	if strip then f:StripTextures() end

	if f.template then
		f:SetBackdrop(nil)
		if f.oborder then f.oborder:SetBackdrop(nil) end
		if f.iborder then f.iborder:SetBackdrop(nil) end
		if f.backdropTexture then f.backdropTexture:SetTexture(nil) end

		f.ignoreFrameTemplates = true
		f.ignoreBackdropColors = true
	end

	MERS:CreateBD(f, 0)

	f.bgTex = MERS:CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", MERS.ColorButton)
		f:HookScript("OnLeave", MERS.ClearButton)
	end

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = E.LSM:Fetch("statusbar", "MerathilisFlat"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
		f.glow:SetPoint("TOPLEFT", -2, 2)
		f.glow:SetPoint("BOTTOMRIGHT", 2, -2)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end

	f:Styling()
end

function MERS:ReskinCheckBox(frame, noBackdrop, noReplaceTextures)
	assert(frame, "does not exist.")

	if frame.backdrop then frame.backdrop:Hide() end

	frame:SetNormalTexture("")
	frame:SetPushedTexture("")
	frame:SetHighlightTexture(E["media"].normTex)

	local hl = frame:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, frame)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(frame:GetFrameLevel() - 1)
	MERS:CreateBD(bd, 0)
	MERS:CreateGradient(bd)

	local ch = frame:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

function MERS:ReskinIcon(icon)
	assert(icon, "doesn't exist!")

	icon:SetTexCoord(unpack(E.TexCoords))
	return MERS:CreateBDFrame(icon)
end

function MERS:CropIcon(texture, parent)
	texture:SetTexCoord(unpack(E.TexCoords))
	if parent then
		local layer, subLevel = texture:GetDrawLayer()
		local iconBorder = parent:CreateTexture(nil, layer, nil, subLevel - 1)
		iconBorder:SetPoint("TOPLEFT", texture, -1, 1)
		iconBorder:SetPoint("BOTTOMRIGHT", texture, 1, -1)
		iconBorder:SetColorTexture(0, 0, 0)

		return iconBorder
	end
end

function MERS:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.LSM:Fetch("statusbar", "MerathilisFlat"))
	panel.tex:SetGradient("VERTICAL", unpack(E["media"].rgbvaluecolor))
	MERS:CreateSD(panel, 2, 0, 0, 0, 0, -1)
end

function MERS:ReskinGarrisonPortrait(self)
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	self.squareBG = MERS:CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(self:GetFrameLevel())
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)

	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

function MERS:SkinRadioButton(button)
	if button.IsSkinned then return; end

	button:SetCheckedTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\RadioCircleChecked")
	button:GetCheckedTexture():SetVertexColor(unpack(E["media"].rgbvaluecolor))
	button:GetCheckedTexture():SetTexCoord(0, 1, 0, 1)

	button:SetHighlightTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\RadioCircleChecked")
	button:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
	button:GetHighlightTexture():SetVertexColor(0, 192, 250, 1)

	button:SetNormalTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\Textures\\RadioCircle")
	button:GetNormalTexture():SetOutside()
	button:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	button:GetNormalTexture():SetVertexColor(unpack(E["media"].bordercolor))

	button:HookScript("OnDisable", function(self)
		if not self.SetDisabledTexture then return end

		if self:GetChecked() then
			self:SetDisabledTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\Textures\\RadioCircle")
			self:GetDisabledTexture():SetVertexColor(0, 192, 250, 1)
		else
			self:SetDisabledTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\Textures\\RadioCircle")
			self:GetDisabledTexture():SetVertexColor(unpack(E["media"].bordercolor))
		end
	end)

	button.SetNormalTexture = MER.dummy
	button.SetPushedTexture = MER.dummy
	button.SetHighlightTexture = MER.dummy
	button.isSkinned = true
end

function MERS:ReskinAS(AS)
	-- Reskin AddOnSkins
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
end

-- Replace the Recap button script re-set function
function S:UpdateRecapButton()
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", MERS.ColorButton)
		self.button4:SetScript("OnLeave", MERS.ClearButton)
	end
end

--[[ HOOK TO THE UIWIDGET TYPES ]]
function MERS:ReskinSkinTextWithStateWidget(widgetFrame)
	local text = widgetFrame.Text;
	if text then
		text:SetTextColor(1, 1, 1)
	end
end

-- hook the skin functions
hooksecurefunc(S, "HandleEditBox", MERS.ReskinEditBox)
hooksecurefunc(S, "HandleDropDownBox", MERS.ReskinDropDownBox)
hooksecurefunc(S, "HandleTab", MERS.ReskinTab)
hooksecurefunc(S, "HandleButton", MERS.Reskin)
hooksecurefunc(S, "HandleCheckBox", MERS.ReskinCheckBox)
hooksecurefunc(S, "HandleScrollBar", MERS.ReskinScrollBar)
hooksecurefunc(S, "HandleScrollSlider", MERS.ReskinScrollSlider)
hooksecurefunc(S, "HandleSliderFrame", MERS.ReskinSliderFrame)
-- New Widget Types
hooksecurefunc(S, "SkinTextWithStateWidget", MERS.ReskinSkinTextWithStateWidget)

-- keep the colors updated
local function updateMedia()
	rgbValueColorR, rgbValueColorG, rgbValueColorB = unpack(E["media"].rgbvaluecolor)
	unitFrameColorR, unitFrameColorG, unitFrameColorB = unpack(E["media"].unitframeBorderColor)
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(E["media"].backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(E["media"].backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(E["media"].bordercolor)
end
hooksecurefunc(E, "UpdateMedia", updateMedia)

local function pluginInstaller()
	local PluginInstallFrame = _G["PluginInstallFrame"]
	if PluginInstallFrame then
		PluginInstallFrame:Styling()
		PluginInstallTitleFrame:Styling()
	end
end

function MERS:Initialize()
	self.db = E.private.muiSkins

	updateMedia()
	pluginInstaller()

	if IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			MERS:ReskinAS(unpack(AddOnSkins))
		end
	end
end

local function InitializeCallback()
	MERS:Initialize()
end

MER:RegisterModule(MERS:GetName(), InitializeCallback)
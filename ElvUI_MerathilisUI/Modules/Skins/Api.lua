local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = MER:NewModule("muiSkins", "AceHook-3.0", "AceEvent-3.0")

-- Cache global variables
-- Lua functions
local _G = _G
local assert, pairs, select, unpack, type = assert, pairs, select, unpack, type
local find, lower, strfind = string.find, string.lower, strfind
-- WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AddOnSkins, stripes

local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local unitFrameColorR, unitFrameColorG, unitFrameColorB
local rgbValueColorR, rgbValueColorG, rgbValueColorB
local bordercolorr, bordercolorg, bordercolorb

local r, g, b = unpack(E["media"].rgbvaluecolor)

MERS.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MERS.TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")
TEXTURE_ITEM_QUEST_BANG = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\UI-Icon-QuestBang]]

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

-- Depends on the arrow texture to be down by default.
MERS.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}

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
		edgeFile = E.LSM:Fetch("border", "ElvUI GlowBorder"),
		edgeSize = E:Scale(s or 3)
	})
	f.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow:SetFrameLevel(n or lvl)

	return f.Shadow
end

function MERS:CreateBG(frame)
	assert(frame, "doesn't exist!")

	local f = frame
	if frame:IsObjectType('Texture') then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -E.mult, E.mult)
	bg:Point("BOTTOMRIGHT", frame, E.mult, -E.mult)
	bg:SetTexture(E.media.blankTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- Gradient Texture
function MERS:CreateGradient(f)
	assert(f, "doesn't exist!")

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gradient.tga]])
	tex:SetVertexColor(.3, .3, .3, .15)
	tex:SetSnapToPixelGrid(false)
	tex:SetTexelSnappingBias(0)

	return tex
end

function MERS:CreateBackdrop(frame)
	if frame.backdrop then return end

	local parent = frame.IsObjectType and frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = CreateFrame("Frame", nil, parent)
	backdrop:SetOutside(frame)
	backdrop:SetTemplate("Transparent")

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
		edgeSize = E.mult*1.1, -- latest Pixel Stuff changes 10.02.2019
		insets = {left = 0, right = 0, top = 0, bottom = 0},
	})

	f:SetBackdropColor(E.media.backdropfadecolor.r, E.media.backdropfadecolor.g, E.media.backdropfadecolor.b, a or alpha)
	f:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

-- ClassColored ScrollBars
local function GrabScrollBarElement(frame, element)
	local FrameName = frame:GetDebugName()
	return frame[element] or FrameName and (_G[FrameName..element] or strfind(FrameName, element)) or nil
end

function MERS:ReskinScrollBar(frame, thumbTrimY, thumbTrimX)
	local parent = frame:GetParent()

	local Thumb = GrabScrollBarElement(frame, 'ThumbTexture') or GrabScrollBarElement(frame, 'thumbTexture') or frame.GetThumbTexture and frame:GetThumbTexture()

	if Thumb and Thumb.backdrop then
		Thumb.backdrop:SetBackdropColor(unpack(E.media.rgbvaluecolor))
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

function MERS:ColorButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(r, g, b, .3)
	self:SetBackdropBorderColor(r, g, b)
end

function MERS:ClearButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(unpack(E.media.unitframeBorderColor))
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

local function onEnter(button)
	if not button then return end

	button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	button:SetBackdropColor(unpack(E.media.rgbvaluecolor))
end

local function onLeave(button)
	if not button then return end

	button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	button:SetBackdropColor(backdropcolorr, backdropcolorg, backdropcolorb)
end

-- Buttons
function MERS:Reskin(button, strip, noGlow)
	assert(button, "doesn't exist!")

	if strip then button:StripTextures() end

	if button.template then
		button:SetTemplate("Transparent", true)
	end

	MERS:CreateGradient(button)

	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Arrow]])
			button.Icon:SetVertexColor(1, 1, 1)
			button.Icon:SetRotation(MERS.ArrowRotation['RIGHT'])
		end
	end

	button:HookScript("OnEnter", onEnter)
	button:HookScript("OnLeave", onLeave)
end

function MERS:StyleButton(button)
	if button.isStyled then return end

	if button.SetHighlightTexture then
		button:SetHighlightTexture(E["media"].blankTex)
		button:GetHighlightTexture():SetVertexColor(1, 1, 1, .2)
		button:GetHighlightTexture():SetInside()
		button.SetHighlightTexture = E.noop
	end

	if button.SetPushedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetPushedTexture():SetVertexColor(.9, .8, .1, .5)
		button:GetPushedTexture():SetInside()
		button.SetPushedTexture = E.noop
	end

	if button.GetCheckedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetCheckedTexture():SetVertexColor(0, 1, 0, .5)
		button:GetCheckedTexture():SetInside()
		button.GetCheckedTexture = E.noop
	end

	local Cooldown = button:GetName() and _G[button:GetName()..'Cooldown'] or button.Cooldown or button.cooldown or nil

	if Cooldown then
		Cooldown:SetInside()
		if Cooldown.SetSwipeColor then
			Cooldown:SetSwipeColor(0, 0, 0, 1)
		end
	end

	button.isStyled = true
end

function MERS:ReskinIcon(icon, backdrop)
	assert(icon, "doesn't exist!")

	icon:SetTexCoord(unpack(E.TexCoords))

	if icon:GetDrawLayer() ~= 'ARTWORK' then
		icon:SetDrawLayer("ARTWORK")
	end

	icon:SetSnapToPixelGrid(false)
	icon:SetTexelSnappingBias(0)

	if backdrop then
		MERS:CreateBackdrop(icon)
	end
end

function MERS:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient("VERTICAL", unpack(E.media.rgbvaluecolor))
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

local buttons = {
	"ElvUIMoverNudgeWindowUpButton",
	"ElvUIMoverNudgeWindowDownButton",
	"ElvUIMoverNudgeWindowLeftButton",
	"ElvUIMoverNudgeWindowRightButton",
}

local function replaceConfigArrows(button)
	-- remove the default icons
	local tex = _G[button:GetName().."Icon"]
	if tex then
		tex:SetTexture(nil)
	end

	-- add the new icon
	if not button.img then
		button.img = button:CreateTexture(nil, 'ARTWORK')
		button.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow')
		button.img:SetSize(12, 12)
		button.img:Point('CENTER')
		button.img:SetVertexColor(1, 1, 1)

		button:HookScript('OnMouseDown', function(btn)
			if btn:IsEnabled() then
				btn.img:Point("CENTER", -1, -1);
			end
		end)

		button:HookScript('OnMouseUp', function(btn)
			btn.img:Point("CENTER", 0, 0);
		end)
	end
end

function MERS:ApplyConfigArrows()
	for _, btn in pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(MERS.ArrowRotation['UP'])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(MERS.ArrowRotation['DOWN'])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(MERS.ArrowRotation['LEFT'])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(MERS.ArrowRotation['RIGHT'])

end
hooksecurefunc(E, "CreateMoverPopup", MERS.ApplyConfigArrows)

function MERS:ReskinAS(AS)
	-- Reskin AddOnSkins
	function AS:SkinTab(Tab, Strip)
		if Tab.isSkinned then return end
		local TabName = Tab:GetName()

		if TabName then
			for _, Region in pairs(S.Blizzard.Regions) do
				if _G[TabName..Region] then
					_G[TabName..Region]:SetTexture(nil)
				end
			end
		end

		for _, Region in pairs(S.Blizzard.Regions) do
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
hooksecurefunc(S, "HandleTab", MERS.ReskinTab)
hooksecurefunc(S, "HandleButton", MERS.Reskin)
hooksecurefunc(S, "HandleScrollBar", MERS.ReskinScrollBar)
-- New Widget Types
hooksecurefunc(S, "SkinTextWithStateWidget", MERS.ReskinSkinTextWithStateWidget)

local function ReskinVehicleExit()
	if E.private.actionbar.enable ~= true then
		return
	end

	if MasqueGroup and E.private.actionbar.masque.actionbars then return end

	local f = _G.MainMenuBarVehicleLeaveButton
	f:SetNormalTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow")
	f:SetPushedTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow")
	f:SetHighlightTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow")

	f:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	f:GetPushedTexture():SetTexCoord(0, 1, 0, 1)

end

function MERS:SetOutside(obj, anchor, xOffset, yOffset, anchor2)
	xOffset = xOffset or 1
	yOffset = yOffset or 1
	anchor = anchor or obj:GetParent()

	assert(anchor)
	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

-- keep the colors updated
local function updateMedia()
	rgbValueColorR, rgbValueColorG, rgbValueColorB = unpack(E.media.rgbvaluecolor)
	unitFrameColorR, unitFrameColorG, unitFrameColorB = unpack(E.media.unitframeBorderColor)
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(E.media.backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(E.media.backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(E.media.bordercolor)
end
hooksecurefunc(E, "UpdateMedia", updateMedia)

function MERS:Initialize()
	self.db = E.private.muiSkins

	ReskinVehicleExit()
	updateMedia()
	self:StyleElvUIConfig()

	if IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			MERS:ReskinAS(unpack(AddOnSkins))
		end
	end
end

MER:RegisterModule(MERS:GetName())

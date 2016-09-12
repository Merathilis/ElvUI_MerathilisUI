local E, L, V, P, G = unpack(ElvUI);
local MERS = E:NewModule('MuiSkins', 'AceHook-3.0', 'AceEvent-3.0');
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select, tonumber, unpack = pairs, select, tonumber, unpack
-- WoW API / Variables
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded

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

-- Backdrop
function MER:BD(bu, a)
	local f = bu
	if bu:GetObjectType() == 'Texture' then
		f = bu:GetParent()
	end
	f:SetBackdrop(texture)
	f:SetBackdropColor(0, 0, 0, a or 1)
end

function MER:BU(bu, a, hover)
	MER:BD(bu, a)
	bu:SetNormalTexture('')
	bu:SetHighlightTexture('')
	bu:SetPushedTexture('')
	if not InCombatLockdown() then 
		bu:SetSize(21, 21)
	end
	bu:HookScript('OnEnter', function() 
		if hover then 
			highlight(bu, true) 
		end
	end)
	bu:HookScript('OnLeave', function()
		if hover then
			highlight(bu, false)
		end
	end)
end

function MER:BUElements(bu)
	local c = bu.Count or _G[bu:GetName()..'Count']
	local cd = bu.Cooldown or _G[bu:GetName()..'Cooldown']
	local i = bu.icon or bu.Icon or bu.IconTexture or _G[bu:GetName()..'Icon'] or _G[bu:GetName()..'IconTexture']

	for _, v in pairs({bu.Border, bu.FloatingBG, bu.IconBorder}) do
		if v then v:SetAlpha(0) end
	end

	if c then
		c:ClearAllPoints()
		c:SetPoint('BOTTOM', bu, 0, -1)
		c:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
		c:SetShadowOffset(0, 0)
		c:SetJustifyH('CENTER')
		c:SetDrawLayer('OVERLAY', 7)
	end

	if cd then
		--
	end

	if bu.HotKey then
		bu.HotKey:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
		bu.HotKey:SetShadowOffset(0, 0)
		bu.HotKey:ClearAllPoints()
		bu.HotKey:SetPoint('TOPRIGHT', bu, -2, 4)
		bu.HotKey:SetDrawLayer('OVERLAY')
		NumberFontNormalSmallGray:SetFontObject('GameFontHighlight')
	end

	if i then
		i:SetTexCoord(.1, .9, .1, .9)
		i:SetDrawLayer('ARTWORK')
	end

	if bu.JunkIcon then
		bu.JunkIcon:ClearAllPoints()
		bu.JunkIcon:SetPoint('CENTER')
	end

	if bu.Name then
		bu.Name:SetWidth(bu:GetWidth() + 15)
		bu.Name:SetFontObject('GameFontHighlight')
	end

	if bu.NewItemTexture then
		bu.NewItemTexture:SetTexture('')
		bu.NewItemTexture:SetSize(23, 23)
	end

	if bu.QuestIcomTexture then
		bu.QuestIconTexture:SetDrawLayer('BACKGROUND')
		bu.QuestIconTexture:SetSize(1, 1)
		bu.forQuest = true
	end
end

-- Original close buttons, but desaturated. Like it used to be in ElvUI.
function S:HandleCloseButton(f, point, text)
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
		f:CreateBackdrop('Default', true)
		f.backdrop:Point('TOPLEFT', 7, -8)
		f.backdrop:Point('BOTTOMRIGHT', -8, 8)
		f:HookScript('OnEnter', SetModifiedBackdrop)
		f:HookScript('OnLeave', SetOriginalBackdrop)
	end
	
	-- Have to create the text, ElvUI code expects the element to be there. It won't show up for original close buttons anyway.
	if not f.text then
		f.text = f:CreateFontString(nil, 'OVERLAY')
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH('CENTER')
		f.text:SetPoint('CENTER', f, 'CENTER')
	end
	
	-- Hide text if button is using original skin
	if f.text and f.noBackdrop then
		f.text:SetAlpha(0)
	end
	
	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

E:RegisterModule(MERS:GetName())
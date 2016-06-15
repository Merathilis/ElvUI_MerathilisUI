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

-- Set scrollbar thumb backdrop color to value color for better visibility
function MERS:HandleScrollBar(frame, thumbTrim)
	if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
		if frame.thumbbg and frame.thumbbg.backdropTexture then
			frame.thumbbg.backdropTexture.SetVertexColor = nil
			frame.thumbbg.backdropTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
			frame.thumbbg.backdropTexture.SetVertexColor = E.noop
		end
	end
end
hooksecurefunc(S, "HandleScrollBar", MERS.HandleScrollBar)

function MERS:MerathilisUISkins()
	-- ElvUI AddOn Styles
	if IsAddOnLoaded('ElvUI_SLE') and E.private.muiSkins.elvuiAddons.sle then
		if tonumber(GetAddOnMetadata("ElvUI_SLE", "Version")) >= 3.00 then
			local sleFrames = { _G["RaidMarkerBar"].backdrop, _G["SLE_LocationPanel_RightClickMenu1"], _G["SLE_LocationPanel_RightClickMenu2"], _G["SLE_LocationPanel"], _G["SLE_LocationPanel_X"], _G["SLE_LocationPanel_Y"], _G["SLE_SquareMinimapButtonBar"] }
			for _, frame in pairs(sleFrames) do
				if frame then
					MER:StyleOutside(frame)
				end
			end
		end
	end
end

function MERS:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'MerathilisUISkins')
end

E:RegisterModule(MERS:GetName())

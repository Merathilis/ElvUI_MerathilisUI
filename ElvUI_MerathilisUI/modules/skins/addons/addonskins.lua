local E, L, V, P, G = unpack(ElvUI);
if not IsAddOnLoaded("AddOnSkins") then return; end
local AS = unpack(AddOnSkins)

-- Cache global variables
-- Lua functions
local select, unpack = select, unpack
-- WoW API / Variables

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

function AS:SkinCloseButton(CloseButton, Reposition)
	if CloseButton.isSkinned then return end
	
	for i=1, CloseButton:GetNumRegions() do
		local region = select(i, CloseButton:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
			for n = 1, #buttons do
				local texture = buttons[n]
				if region:GetTexture() == "Interface\\Buttons\\"..texture then
					CloseButton.noBackdrop = true
				end
			end
			if region:GetTexture() == "Interface\\DialogFrame\\UI-DialogBox-Corner" then
				region:Kill()
			end
		end
	end
	
	if not CloseButton.noBackdrop then
		AS:StripTextures(CloseButton)
		AS:CreateBackdrop(CloseButton)
		AS:SetTemplate(CloseButton.Backdrop, nil, true)
		CloseButton.Backdrop:Point('TOPLEFT', 7, -8)
		CloseButton.Backdrop:Point('BOTTOMRIGHT', -8, 8)
	end
	
	CloseButton.Text = CloseButton:CreateFontString(nil, "OVERLAY")
	CloseButton.Text:SetFont([[Interface\AddOns\AddOnSkins\Media\Fonts\PTSansNarrow.TTF]], 12)
	CloseButton.Text:SetPoint("CENTER", CloseButton, 'CENTER')
	CloseButton.Text:SetText('x')
	
	if not CloseButton.noBackdrop then
		CloseButton:HookScript("OnEnter", function(self)
			self.Text:SetTextColor(1, .2, .2)
			self.Backdrop:SetBackdropBorderColor(1, .2, .2)
		end)
		
		CloseButton:HookScript("OnLeave", function(self)
			self.Text:SetTextColor(1, 1, 1)
			self.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
		end)
	end
	
	--Hide text if button is using original skin
	if CloseButton.Text and CloseButton.noBackdrop then
		CloseButton.Text:SetAlpha(0)
	end
	
	if Reposition then
		CloseButton:Point("TOPRIGHT", Reposition, "TOPRIGHT", 2, 2)
	end
	CloseButton.isSkinned = true
end

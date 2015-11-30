local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local AS = unpack(AddOnSkins)

-- Cache global variables
local select, unpack = select, unpack

local IsAddOnLoaded = IsAddOnLoaded

if not IsAddOnLoaded("AddOnSkins") then return; end

--Change some AddOnSkins defaults for ElvUI. Credit Blazeflack (AddOnSkinsTweaks)
V["addonskins"]['EmbedSystemDual'] = true
V["addonskins"]['EmbedBelowTop'] = false
V["addonskins"]['TransparentEmbed'] = true
V["addonskins"]['SkadaBackdrop'] = true
V["addonskins"]["EmbedMain"] = 'Skada'
V["addonskins"]["EmbedLeft"] = 'Skada'
V["addonskins"]["EmbedRight"] = 'Skada'
V["addonskins"]["EmbedLeftWidth"] = 170
V["addonskins"]['AuctionHouse'] = false
V['addonskins']['ParchmentRemover'] = true
V['addonskins']['WeakAuraBar'] = true
V['addonskins']['BigWigsHalfBar'] = true
V['addonskins']['CliqueSkin'] = true
V['addonskins']['Blizzard_ExtraActionButton'] = true
V['addonskins']['Blizzard_DraenorAbilityButton'] = true
V['addonskins']['Blizzard_WorldStateCaptureBar'] = true

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

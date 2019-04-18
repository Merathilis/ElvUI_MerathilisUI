local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("Clique") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, BugSack

local function styleClique(event, addon)
	if E.private.muiSkins.addonSkins.cl ~= true then return end

	CliqueConfig:StripTextures()
	CliqueConfig:CreateBackdrop("Transparent")
	CliqueConfig.backdrop:Styling()

	CliqueConfigPage1Column1:StripTextures()
	CliqueConfigPage1Column2:StripTextures()
	CliqueConfigInset:StripTextures()
	CliqueConfigPage1_VSlider:StripTextures()

	CliqueClickGrabber:StripTextures()
	CliqueClickGrabber:CreateBackdrop("Overlay")
	CliqueClickGrabber.backdrop:SetPoint("TOPLEFT", -1, 0)
	CliqueClickGrabber.backdrop:SetPoint("BOTTOMRIGHT", 2, 3)

	CliqueDialog:StripTextures()
	CliqueDialog:SetTemplate("Transparent")

	CliqueConfigCloseButton:StripTextures()
	S:HandleCloseButton(CliqueConfigCloseButton)
	if CliqueDialog.CloseButton then S:HandleCloseButton(CliqueDialog.CloseButton) end
	if CliqueDialogCloseButton then S:HandleCloseButton(CliqueDialogCloseButton) end

	MERS:Reskin(CliqueConfigPage1ButtonOptions)
	MERS:Reskin(CliqueConfigPage1ButtonOther)
	MERS:Reskin(CliqueConfigPage1ButtonSpell)
	MERS:Reskin(CliqueConfigPage2ButtonBinding)
	MERS:Reskin(CliqueConfigPage2ButtonSave)
	MERS:Reskin(CliqueConfigPage2ButtonCancel)
	MERS:Reskin(CliqueDialogButtonBinding)
	MERS:Reskin(CliqueDialogButtonAccept)

	CliqueSpellTab:GetRegions():SetSize(0.1, 0.1)
	CliqueSpellTab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CliqueSpellTab:GetNormalTexture():ClearAllPoints()
	CliqueSpellTab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	CliqueSpellTab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	CliqueSpellTab:CreateBackdrop("Default")
	CliqueSpellTab.backdrop:SetAllPoints()
	CliqueSpellTab:StyleButton()

	CliqueConfigPage1:SetScript("OnShow", function(self)
		for i = 1, 12 do
			if _G["CliqueRow"..i] then
				_G["CliqueRow"..i.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["CliqueRow"..i.."Bind"]:ClearAllPoints()
				if _G["CliqueRow"..i] == CliqueRow1 then
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8, 0)
				else
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -8, 0)
				end
			end
		end
		CliqueRow1:ClearAllPoints()
		CliqueRow1:SetPoint("TOPLEFT", 5, -(CliqueConfigPage1Column1:GetHeight() + 3))
	end)
end

S:AddCallbackForAddon("BugSack", "mUIClique", styleClique)

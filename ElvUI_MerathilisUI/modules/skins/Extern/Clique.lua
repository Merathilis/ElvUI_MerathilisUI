local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")
if not IsAddOnLoaded("Clique") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, BugSack

local function LoadAddOnSkin(event, addon)
	if E.private.muiSkins.addonSkins.cl ~= true then return end

	_G.CliqueConfig:StripTextures()
	_G.CliqueConfig:CreateBackdrop("Transparent")
	_G.CliqueConfig.backdrop:Styling()

	_G.CliqueConfigPage1Column1:StripTextures()
	_G.CliqueConfigPage1Column2:StripTextures()
	_G.CliqueConfigInset:StripTextures()
	_G.CliqueConfigPage1_VSlider:StripTextures()

	_G.CliqueClickGrabber:StripTextures()
	_G.CliqueClickGrabber:CreateBackdrop("Overlay")
	_G.CliqueClickGrabber.backdrop:SetPoint("TOPLEFT", -1, 0)
	_G.CliqueClickGrabber.backdrop:SetPoint("BOTTOMRIGHT", 2, 3)

	_G.CliqueDialog:StripTextures()
	_G.CliqueDialog:SetTemplate("Transparent")

	_G.CliqueConfigCloseButton:StripTextures()
	S:HandleCloseButton(_G.CliqueConfigCloseButton)
	if _G.CliqueDialog.CloseButton then S:HandleCloseButton(_G.CliqueDialog.CloseButton) end
	if _G.CliqueDialogCloseButton then S:HandleCloseButton(_G.CliqueDialogCloseButton) end

	MERS:Reskin(_G.CliqueConfigPage1ButtonOptions)
	MERS:Reskin(_G.CliqueConfigPage1ButtonOther)
	MERS:Reskin(_G.CliqueConfigPage1ButtonSpell)
	MERS:Reskin(_G.CliqueConfigPage2ButtonBinding)
	MERS:Reskin(_G.CliqueConfigPage2ButtonSave)
	MERS:Reskin(_G.CliqueConfigPage2ButtonCancel)
	MERS:Reskin(_G.CliqueDialogButtonBinding)
	MERS:Reskin(_G.CliqueDialogButtonAccept)

	_G.CliqueSpellTab:GetRegions():SetSize(0.1, 0.1)
	_G.CliqueSpellTab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	_G.CliqueSpellTab:GetNormalTexture():ClearAllPoints()
	_G.CliqueSpellTab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	_G.CliqueSpellTab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	_G.CliqueSpellTab:CreateBackdrop("Default")
	_G.CliqueSpellTab.backdrop:SetAllPoints()
	_G.CliqueSpellTab:StyleButton()

	_G.CliqueConfigPage1:SetScript("OnShow", function(self)
		for i = 1, 12 do
			if _G["CliqueRow"..i] then
				_G["CliqueRow"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords))
				_G["CliqueRow"..i.."Bind"]:ClearAllPoints()
				if _G["CliqueRow"..i] == _G.CliqueRow1 then
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8, 0)
				else
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -8, 0)
				end
			end
		end
		_G.CliqueRow1:ClearAllPoints()
		_G.CliqueRow1:SetPoint("TOPLEFT", 5, -(_G.CliqueConfigPage1Column1:GetHeight() + 3))
	end)
end

S:AddCallbackForAddon("BugSack", "mUIClique", LoadAddOnSkin)

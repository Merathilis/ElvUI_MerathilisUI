local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
-- GLOBALS:

local function LoadAddOnSkin()
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

	local CliqueButtons = {
		_G.CliqueConfigPage1ButtonSpell,
		_G.CliqueConfigPage1ButtonOther,
		_G.CliqueConfigPage1ButtonOptions,
		_G.CliqueConfigPage2ButtonBinding,
		_G.CliqueDialogButtonAccept,
		_G.CliqueDialogButtonBinding,
		_G.CliqueConfigPage2ButtonSave,
		_G.CliqueConfigPage2ButtonCancel,
	}

	for _, button in pairs(CliqueButtons) do
		S:HandleButton(button)
	end

	local Tab = _G.CliqueSpellTab
	Tab:SetNormalTexture("Interface\\ICONS\\Creatureportrait_RopeLadder01") --override the Texture to take account for Simpy's Icon pack
	Tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	Tab:GetNormalTexture():SetInside()

	Tab:SetPushedTexture("Interface\\ICONS\\Creatureportrait_RopeLadder01") -- override the Texture to take account for Simpy's Icon pack
	Tab:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	Tab:GetPushedTexture():SetInside()

	Tab:SetHighlightTexture("Interface\\ICONS\\Creatureportrait_RopeLadder01") -- override the Texture to take account for Simpy's Icon pack
	Tab:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	Tab:GetHighlightTexture():SetInside()

	Tab:CreateBackdrop("Transparent")
	Tab.backdrop:SetAllPoints()
	Tab:StyleButton()

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

S:AddCallbackForAddon("Clique", "mUIClique", LoadAddOnSkin)

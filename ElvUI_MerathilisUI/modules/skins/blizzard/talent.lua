local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo

-- GLOBALS: hooksecurefunc, MAX_TALENT_TIERS, NUM_TALENT_COLUMNS, MAX_PVP_TALENT_TIERS, MAX_PVP_TALENT_COLUMNS
-- GLOBALS: PlayerTalentFrameSpecialization

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.talent ~= true then return; end

	MERS:CreateGradient(_G["PlayerTalentFrame"])
	MERS:CreateStripes(_G["PlayerTalentFrame"])

	-- Specc
	for i = 1, GetNumSpecializations(false, nil) do
		local bu = PlayerTalentFrameSpecialization["specButton"..i]
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)

		bu.SelectedTexture = bu:CreateTexture(nil, "BACKGROUND")
		bu.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	end

	-- Talents
	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local button = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]

				if button.bg.backdrop then
					button.bg.backdrop:Hide()
				end
				MERS:CreateBD(button.bg, .25)

				if button.knownSelection:IsShown() then
					button.bg.SelectedTexture:Show()
					button.bg.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
				else
					button.bg.SelectedTexture:Hide()
				end
			end
		end
	end)

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}

	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]

			-- Hide the ElvUI backdrop (its default)
			if bu.backdrop then
				bu.backdrop:Hide()
			end

			-- Create own backdrop (transparent)
			bu:CreateBackdrop("Transparent")
			bu.backdrop:Point("TOPLEFT", 8, 2)
			bu.backdrop:Point("BOTTOMRIGHT", 10, -2)
			MERS:CreateGradient(bu.backdrop)
		end
	end

	-- PvP Talents
	hooksecurefunc("PVPTalentFrame_Update", function(self)
		for i = 1, MAX_PVP_TALENT_TIERS do
			for j = 1, MAX_PVP_TALENT_COLUMNS do
				local button = self.Talents["Tier"..i]["Talent"..j]

				if button.bg.backdrop then
					button.bg.backdrop:Hide()
				end
				MERS:CreateBD(button.bg, .25)

				if button.knownSelection then
					if button.knownSelection:IsShown() then
						button.bg.SelectedTexture:Show()
						button.bg.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
					else
						button.bg.SelectedTexture:Hide()
					end
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_TalentUI", "mUITalents", styleTalents)
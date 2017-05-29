local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = E:GetModule("muiSkins")

--Cache global variables
--Lua functions
local _G = _G
-- WoW API / Variables
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo

-- GLOBALS: hooksecurefunc, MAX_TALENT_TIERS, NUM_TALENT_COLUMNS, MAX_PVP_TALENT_TIERS, MAX_PVP_TALENT_COLUMNS
-- GLOBALS: PlayerTalentFrameSpecialization

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.talent ~= true then return; end

	if not PlayerTalentFrame.stripes then
		MERS:CreateStripes(PlayerTalentFrame)
	end
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
				if button.knownSelection:IsShown() then
					button.bg.SelectedTexture:Show()
					button.bg.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
				else
					button.bg.SelectedTexture:Hide()
				end
			end
		end
	end)

	-- PvP Talents
	hooksecurefunc("PVPTalentFrame_Update", function(self)
		for i = 1, MAX_PVP_TALENT_TIERS do
			for j = 1, MAX_PVP_TALENT_COLUMNS do
				local button = self.Talents["Tier"..i]["Talent"..j]
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
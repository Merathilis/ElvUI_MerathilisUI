local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins");

--Cache global variables
--Lua functions
local _G = _G

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.talent ~= true then return; end

	-- Specc
	for i = 1, GetNumSpecializations(false, nil) do
		local bu = PlayerTalentFrameSpecialization["specButton"..i]
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)

		bu.SelectedTexture = bu:CreateTexture(nil, "BACKGROUND")
		bu.SelectedTexture:SetColorTexture(MER.Color.r, MER.Color.g, MER.Color.b)
	end

	-- Talents
	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local button = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
				if button.knownSelection:IsShown() then
					button.bg.SelectedTexture:Show()
					button.bg.SelectedTexture:SetColorTexture(MER.Color.r, MER.Color.g, MER.Color.b)
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
						button.bg.SelectedTexture:SetColorTexture(MER.Color.r, MER.Color.g, MER.Color.b)
					else
						button.bg.SelectedTexture:Hide()
					end
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_TalentUI", "TalentRecolor", styleTalents)
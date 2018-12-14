local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local C_SpecializationInfo_GetSpellsDisplay = C_SpecializationInfo.GetSpellsDisplay
local GetSpecialization = GetSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationSpells = GetSpecializationSpells
local GetSpellTexture = GetSpellTexture
local UnitSex = UnitSex

-- GLOBALS: hooksecurefunc, MAX_TALENT_TIERS, NUM_TALENT_COLUMNS, MAX_PVP_TALENT_TIERS, MAX_PVP_TALENT_COLUMNS
-- GLOBALS: PlayerTalentFrameSpecialization, SPEC_SPELLS_DISPLAY

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.talent ~= true then return; end

	_G["PlayerTalentFrame"]:Styling()

	-- Specc
	for i = 1, GetNumSpecializations(false, nil) do
		local bu = PlayerTalentFrameSpecialization["specButton"..i]
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)

		bu.ring:Hide()

		bu.specIcon:SetTexture(icon)
		bu.specIcon:SetTexCoord(unpack(E.TexCoords))
		bu.specIcon:SetSize(50, 50)
		bu.specIcon:SetPoint("LEFT", bu, "LEFT", 15, 0)

		bu.SelectedTexture = bu:CreateTexture(nil, "BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .5)
	end

	-- Talents
	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local button = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]

				-- Hide ElvUI's "Default" backdrop
				if button.bg.backdrop then button.bg.backdrop:Hide() end

				-- Reapply a transparent backdrop
				button.bg:CreateBackdrop("Transparent")

				if button.knownSelection:IsShown() then
					button.bg.SelectedTexture:Show()
					button.bg.SelectedTexture:SetColorTexture(r, g, b, .5)
				else
					button.bg.SelectedTexture:Hide()
				end
			end
		end
	end)

	for _, frame in pairs({PlayerTalentFrameSpecialization, PlayerTalentFramePetSpecialization}) do
		local scrollChild = frame.spellsScroll.child

		scrollChild.ring:Hide()
		scrollChild.specIcon:SetTexCoord(unpack(E.TexCoords))
		scrollChild.specIcon:Size(70, 70)

		local roleIcon = scrollChild.roleIcon

		roleIcon:SetTexture(E["media"].roleIcons)

		local left = scrollChild:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(E["media"].normTex)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleIcon, 3, -3)
		left:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)

		local right = scrollChild:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(E["media"].normTex)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleIcon, -3, -3)
		right:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)

		local top = scrollChild:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(E["media"].normTex)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleIcon, 3, -3)
		top:SetPoint("TOPRIGHT", roleIcon, -3, -3)

		local bottom = scrollChild:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(E["media"].normTex)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)
		bottom:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, PlayerSpecTab2:GetChecked() and 2 or 1)
		local shownSpec = spec or playerTalentSpec or 1
		local numSpecs = GetNumSpecializations(nil, self.isPet);

		local sex = self.isPet and UnitSex("pet") or UnitSex("player")
		local id, _, _, icon = GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)
		local scrollChild = self.spellsScroll.child

		scrollChild.specIcon:SetTexture(icon)

		local index = 1
		local bonuses
		local bonusesIncrement = 1;
		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
			bonusesIncrement = 2;
		else
			bonuses = C_SpecializationInfo_GetSpellsDisplay(id)
		end

		if bonuses then
			for i = 1, #bonuses, bonusesIncrement do
				local frame = scrollChild["abilityButton"..index]
				local _, spellIcon = GetSpellTexture(bonuses[i])

				frame.icon:SetTexture(spellIcon)
				frame.subText:SetTextColor(.75, .75, .75)

				if not frame.styled and not frame.backdrop then
					frame.ring:Hide()
					frame.icon:SetTexCoord(unpack(E.TexCoords))
					MERS:CreateBG(frame.icon)

					frame.styled = true
				end
				index = index + 1
			end
		end

		for i = 1, numSpecs do
			local bu = self["specButton"..i]

			if bu.disabled then
				bu.roleName:SetTextColor(.5, .5, .5)
			else
				bu.roleName:SetTextColor(1, 1, 1)
			end
		end
	end)

	for i = 1, GetNumSpecializations(false, nil) do
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)
		PlayerTalentFrameSpecialization["specButton"..i].specIcon:SetTexture(icon)
	end

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}

	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]

			-- Hide the ElvUI backdrop
			if bu.backdrop then
				bu.backdrop:Hide()
			end

			-- Create own backdrop (transparent)
			bu:CreateBackdrop("Transparent")
			bu.backdrop:Point("TOPLEFT", 8, 2)
			bu.backdrop:Point("BOTTOMRIGHT", 10, -2)
			bu.backdrop:Styling()
		end
	end

	-- PvP Talents
	local PlayerTalentFrameTalentsPvpTalentFrameTalentList = _G["PlayerTalentFrameTalentsPvpTalentFrameTalentList"]
	PlayerTalentFrameTalentsPvpTalentFrameTalentList.backdrop:Styling()

	for i = 1, 10 do
		local bu = _G["PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameButton"..i]
		local icon = bu.Icon
		if bu then
			-- Hide ElvUI backdrop
			if bu.backdrop then
				bu.backdrop:Hide()
			end

			MERS:Reskin(bu)

			if bu.Selected then
				bu.Selected:SetTexture(nil)

				bu.selectedTexture = bu:CreateTexture(nil, "ARTWORK")
				bu.selectedTexture:SetInside(bu)
				bu.selectedTexture:SetColorTexture(r, g, b, .5)
				bu.selectedTexture:SetShown(bu.Selected:IsShown())

				hooksecurefunc(bu, "Update", function(selectedHere)
					if not bu.selectedTexture then return end
					if bu.Selected:IsShown() then
						bu.selectedTexture:SetShown(selectedHere)
					else
						bu.selectedTexture:Hide()
					end
				end)
			end

			bu.backdrop:SetAllPoints()

			if bu.Icon then
				bu.Icon:SetTexCoord(unpack(E.TexCoords))
				bu.Icon:SetDrawLayer("ARTWORK", 1)
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_TalentUI", "mUITalents", styleTalents)

local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, unpack = pairs, unpack

local C_SpecializationInfo_GetSpellsDisplay = C_SpecializationInfo.GetSpellsDisplay
local C_SpecializationInfo_IsInitialized = C_SpecializationInfo.IsInitialized
local GetSpecialization = GetSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationRole = GetSpecializationRole
local GetSpecializationSpells = GetSpecializationSpells
local GetSpellTexture = GetSpellTexture
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local UnitSex = UnitSex
local hooksecurefunc = hooksecurefunc

local MAX_TALENT_TIERS = 7

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local PlayerTalentFrame = _G.PlayerTalentFrame
	PlayerTalentFrame:Styling()
	MER:CreateShadow(PlayerTalentFrame)

	for i = 1, 3 do
		module:ReskinTab(_G["PlayerTalentFrameTab" .. i])
	end

	for _, Frame in pairs({ _G.PlayerTalentFrameSpecialization, _G.PlayerTalentFramePetSpecialization }) do
		Frame:StripTextures()

		for i = 1, 4 do
			local Button = Frame['specButton'..i]
			if Button.SelectedTexture then
				Button.SelectedTexture:SetColorTexture(r, g, b, .5)
			end
		end
	end

	do
	-- Talents
		for i = 1, MAX_TALENT_TIERS do
			local row = _G.PlayerTalentFrameTalents['tier'..i]
			for j = 1, _G.NUM_TALENT_COLUMNS do
				local bu = row['talent'..j]
				if bu.bg then
					module:CreateGradient(bu.bg)
					bu.bg:SetTemplate("Transparent")
					bu.bg.SelectedTexture:SetColorTexture(r, g, b, .5)
				end
			end
		end
	end

	for _, frame in pairs({ _G.PlayerTalentFrameSpecialization, _G.PlayerTalentFramePetSpecialization }) do
		local scrollChild = frame.spellsScroll.child

		scrollChild.ring:Hide()
		scrollChild.specIcon:SetTexCoord(unpack(E.TexCoords))
		scrollChild.specIcon:Size(70, 70)

		local roleIcon = scrollChild.roleIcon
		roleIcon:SetTexture(E.media.roleIcons)

		local left = scrollChild:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(E.media.normTex)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleIcon, 3, -3)
		left:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)

		local right = scrollChild:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(E.media.normTex)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleIcon, -3, -3)
		right:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)

		local top = scrollChild:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(E.media.normTex)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleIcon, 3, -3)
		top:SetPoint("TOPRIGHT", roleIcon, -3, -3)

		local bottom = scrollChild:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(E.media.normTex)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)
		bottom:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		if not C_SpecializationInfo_IsInitialized() then
			return
		end

		local playerTalentSpec = GetSpecialization(nil, self.isPet, _G.PlayerSpecTab2:GetChecked() and 2 or 1)
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

				if not frame.styled then
					frame.ring:Hide()
					frame.icon:SetTexCoord(unpack(E.TexCoords))
					module:CreateBG(frame.icon)
					module.bg = bg

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

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}
	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]

			if bu and bu.backdrop then
				bu.backdrop:SetTemplate("Transparent")
				module:CreateGradient(bu.backdrop)
			end

			local roleIcon = bu.roleIcon
			local role = GetSpecializationRole(i, false, bu.isPet)
			if role and roleIcon then
				if not roleIcon.backdrop then
					roleIcon:CreateBackdrop()
					roleIcon.backdrop:SetOutside(roleIcon)
				end
				roleIcon:SetTexture(E.media.roleIcons)
				roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
			end
		end
	end

	-- PvP Talents
	local PvpTalentFrame = _G.PlayerTalentFrameTalents.PvpTalentFrame

	for _, button in pairs(PvpTalentFrame.Slots) do
		button:CreateBackdrop()
		button.backdrop:SetOutside(button.Texture)

		hooksecurefunc(button, "Update", function(self)
			local selectedTalentID = self.predictedSetting:Get()
			if selectedTalentID then
				local _, _, texture = GetPvpTalentInfoByID(selectedTalentID)
				self.Texture:SetTexture(texture)
				self.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			else
				self.Texture:SetTexCoord(.15, .85, .15, .85)
			end
		end)
	end

	local PlayerTalentFrameTalentsPvpTalentFrameTalentList = _G.PlayerTalentFrameTalentsPvpTalentFrameTalentList
	PlayerTalentFrameTalentsPvpTalentFrameTalentList:Styling()
	MER:CreateShadow(PlayerTalentFrameTalentsPvpTalentFrameTalentList)

	for _, Button in pairs(PvpTalentFrame.TalentList.ScrollFrame.buttons) do
		if Button then
			-- Hide ElvUI backdrop
			if Button.backdrop then
				Button.backdrop:Hide()
			end

			if Button.Selected then
				Button.Selected:SetTexture(nil)

				Button.selectedTexture = Button:CreateTexture(nil, "ARTWORK")
				Button.selectedTexture:SetInside(Button)
				Button.selectedTexture:SetColorTexture(r, g, b, .5)
				Button.selectedTexture:SetShown(Button.Selected:IsShown())

				hooksecurefunc(Button, "Update", function(selectedHere)
					if not Button.selectedTexture then return end
					if Button.Selected:IsShown() then
						Button.selectedTexture:SetShown(selectedHere)
					else
						Button.selectedTexture:Hide()
					end
				end)
			end

			if Button.Icon then
				Button.Icon:SetTexCoord(unpack(E.TexCoords))
				Button.Icon:SetDrawLayer("ARTWORK", 1)
			end
		end
	end
end

S:AddCallbackForAddon('Blizzard_TalentUI', LoadSkin)

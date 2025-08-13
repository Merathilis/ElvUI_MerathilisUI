local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local AB = E:GetModule("ActionBars")

local _G = _G

local _G = _G
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS or 10
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS or 10
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function module:ElvUI_ActionBar_SkinButton(button, useBackdrop)
	module:CreateLowerShadow(button)

	if not button.__MERSkin then
		if button.MERshadow and button.MERshadow.__MER then
			module:BindShadowColorWithBorder(button)
		end

		button.__MERSkin = true
	end

	if useBackdrop then
		if button.MERshadow then
			button.MERshadow:Hide()
		end
	else
		if button.MERshadow then
			button.MERshadow:Show()
		end
	end
end

function module:ElvUI_ActionBar_SkinBar(bar, type)
	if not (E.private.mui.skins.shadow and bar and bar.backdrop) then
		return
	end

	bar.backdrop:SetTemplate("Transparent")

	if bar.db.backdrop then
		if not bar.backdrop.MERshadow then
			module:CreateBackdropShadow(bar, true)
		end
		if bar.backdrop.MERshadow then
			bar.backdrop.MERshadow:Show()
		end
	else
		if bar.backdrop.MERshadow then
			bar.backdrop.MERshadow:Hide()
		end
	end

	if type == "PLAYER" then
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = bar.buttons[i]
			module:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "PET" then
		for i = 1, NUM_PET_ACTION_SLOTS do
			local button = _G["PetActionButton" .. i]
			module:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "STANCE" then
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["ElvUI_StanceBarButton" .. i]
			module:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "MICRO" then
		for _, name in next, AB.MICRO_BUTTONS do
			local button = _G[name]
			self:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	end
end

function module:ElvUI_ActionBar_PositionAndSizeBar(actionBarModule, barName)
	local bar = actionBarModule.handledBars[barName]
	module:ElvUI_ActionBar_SkinBar(bar, "PLAYER")
end

function module:ElvUI_ActionBar_PositionAndSizeBarPet()
	module:ElvUI_ActionBar_SkinBar(_G.ElvUI_BarPet, "PET")
end

function module:ElvUI_ActionBar_PositionAndSizeBarShapeShift()
	module:ElvUI_ActionBar_SkinBar(_G.ElvUI_StanceBar, "STANCE")
end

function module:ElvUI_UpdateMicroButtons()
	module:ElvUI_ActionBar_SkinBar(_G.ElvUI_MicroBar, "MICRO")
end

function module:SkinZoneAbilities(button)
	for spellButton in button.SpellButtonContainer:EnumerateActive() do
		if spellButton and spellButton.IsSkinned then
			module:CreateShadow(spellButton)
		end
	end
end

function module:Skin_ElvUI_ActionBars()
	if not E.private.actionbar.enable then
		return
	end

	-- ElvUI action bar
	if not E.private.actionbar.masque.actionbars then
		for id = 1, 15 do
			local bar = _G["ElvUI_Bar" .. id]
			if bar then
				self:ElvUI_ActionBar_SkinBar(bar, "PLAYER")
			end
		end

		self:SecureHook(AB, "PositionAndSizeBar", "ElvUI_ActionBar_PositionAndSizeBar")
	end

	-- Pet bar
	if not E.private.actionbar.masque.petBar then
		self:ElvUI_ActionBar_SkinBar(_G.ElvUI_BarPet, "PET")
		self:SecureHook(AB, "PositionAndSizeBarPet", "ElvUI_ActionBar_PositionAndSizeBarPet")
	end

	-- Stance bar
	if not E.private.actionbar.masque.stanceBar then
		self:ElvUI_ActionBar_SkinBar(_G.ElvUI_StanceBar, "STANCE")
		self:SecureHook(AB, "PositionAndSizeBarShapeShift", "ElvUI_ActionBar_PositionAndSizeBarShapeShift")
	end

	-- Micro bar
	if not E.private.actionbar.masque.microBar then
		self:ElvUI_ActionBar_SkinBar(_G.ElvUI_BarMicro, "MICRO")
		self:SecureHook(AB, "UpdateMicroButtons", "ElvUI_UpdateMicroButtons")
	end

	-- Extra ActionBar/ ZoneAbility
	self:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", "SkinZoneAbilities")

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		if button and button.backdrop then
			self:CreateBackdropShadow(button.backdrop, true)
		end
	end

	-- Vehicle leave button
	do
		local button = _G.MainMenuBarVehicleLeaveButton
		if button.hover then
			button.hover:SetAlpha(0)
		end
		module:CreateBackdropShadow(button, true)

		local tex = button:GetNormalTexture()
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
			tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
			tex:SetTexture(I.Media.Textures.arrow)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetVertexColor(1, 1, 1, 1)
		end
	end
end

module:AddCallback("Skin_ElvUI_ActionBars")

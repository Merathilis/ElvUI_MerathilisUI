local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')
local AB = E:GetModule('ActionBars')

local _G = _G
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS or 10
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS or 10
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function module:ElvUI_ActionBar_SkinButton(button, useBackdrop)
	self:CreateLowerShadow(button)

	if not button.__MERSkin then
		if button.shadow and button.shadow.__MER then
			self:BindShadowColorWithBorder(button.shadow, button)
		end

		button.__MERSkin = true
	end

	if useBackdrop then
		button.shadow:Hide()
	else
		button.shadow:Show()
	end
end

function module:ElvUI_ActionBar_SkinBar(bar, type)
	if not (E.private.mui.skins.shadow and bar and bar.backdrop) then
		return
	end

	bar.backdrop:SetTemplate('Transparent')
	bar.backdrop:Styling()

	if bar.db.backdrop then
		if not bar.backdrop.shadow then
			self:CreateBackdropShadow(bar, true)
		end
		bar.backdrop.shadow:Show()
	else
		if bar.backdrop.shadow then
			bar.backdrop.shadow:Hide()
		end
	end

	if type == "PLAYER" then
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = bar.buttons[i]
			self:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "PET" then
		for i = 1, NUM_PET_ACTION_SLOTS do
			local button = _G["PetActionButton" .. i]
			self:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "STANCE" then
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["ElvUI_StanceBarButton" .. i]
			self:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
		end
	elseif type == "MICRO" then
		for _, name in next, AB.MICRO_BUTTONS do
			local button = _G[name]
			self:ElvUI_ActionBar_SkinButton(button, bar.db.backdrop)
			button:Styling()
		end
	end
end

function module:ElvUI_ActionBar_PositionAndSizeBar(actionBarModule, barName)
	local bar = actionBarModule.handledBars[barName]
	self:ElvUI_ActionBar_SkinBar(bar, "PLAYER")
end

function module:ElvUI_ActionBar_PositionAndSizeBarPet()
	self:ElvUI_ActionBar_SkinBar(_G.ElvUI_BarPet, "PET")
end

function module:ElvUI_ActionBar_PositionAndSizeBarShapeShift()
	self:ElvUI_ActionBar_SkinBar(_G.ElvUI_StanceBar, "STANCE")
end

function module:ElvUI_UpdateMicroButtons()
	self:ElvUI_ActionBar_SkinBar(_G.ElvUI_MicroBar, "MICRO")
end

function module:SkinZoneAbilities(button)
	if not E.Retail then return end

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
		for id = 1, 10 do
			local bar = _G["ElvUI_Bar" .. id]
			self:ElvUI_ActionBar_SkinBar(bar, "PLAYER")
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

	-- Zone Button
	module:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", "SkinZoneAbilities")

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		if button and button.backdrop then
			module:CreateBackdropShadow(button.backdrop, true)
		end
	end
end

module:AddCallback("Skin_ElvUI_ActionBars")

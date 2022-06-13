local MER, F, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Actionbars')
local S = MER:GetModule('MER_Skins')
local AB = E:GetModule('ActionBars')

local _G = _G

local C_TimerAfter = C_Timer.After
local hooksecurefunc = hooksecurefunc

function module:SkinButton(button, useBackdrop)
	S:CreateLowerShadow(button)

	if not button.__MERSkin then
		if button.shadow and button.shadow.__MER then
			S:BindShadowColorWithBorder(button.shadow, button)
		end

		button.__MERSkin = true
	end

	if useBackdrop then
		button.shadow:Hide()
	else
		button.shadow:Show()
	end
end

function module:SkinBar(bar, type)
	if not (E.private.mui.skins.shadow.enable and bar and bar.backdrop) then
		return
	end

	bar.backdrop:SetTemplate("Transparent")
	if bar.db.backdrop then
		if not bar.backdrop.shadow then
			S:CreateBackdropShadow(bar, true)
		end
		bar.backdrop:Styling()
		bar.backdrop.shadow:Show()
	else
		if bar.backdrop.shadow then
			bar.backdrop.shadow:Hide()
		end
	end

	if type == "PLAYER" then
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = bar.buttons[i]
			self:SkinButton(button, bar.db.backdrop)
		end
	elseif type == "PET" then
		for i = 1, NUM_PET_ACTION_SLOTS do
			local button = _G["PetActionButton" .. i]
			self:SkinButton(button, bar.db.backdrop)
		end
	elseif type == "STANCE" then
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["ElvUI_StanceBarButton" .. i]
			self:SkinButton(button, bar.db.backdrop)
		end
	end
end

function module:ElvUI_PositionAndSizeBar(actionBarModule, barName)
	local bar = actionBarModule.handledBars[barName]
	self:SkinBar(bar, "PLAYER")
end

function module:ElvUI_PositionAndSizeBarPet()
	self:SkinBar(_G.ElvUI_BarPet, "PET")
end

function module:ElvUI_PositionAndSizeBarShapeShift()
	self:SkinBar(_G.ElvUI_StanceBar, "STANCE")
end

function module:SkinZoneAbilities(button)
	for spellButton in button.SpellButtonContainer:EnumerateActive() do
		if spellButton and spellButton.IsSkinned then
			S:CreateShadow(spellButton)
		end
	end
end

function module:ElvUI_ActionBar_LoadKeyBinder()
	local frame = _G.ElvUIBindPopupWindow
	if not frame then
		self:SecureHook(AB, "LoadKeyBinder", "ElvUI_ActionBar_LoadKeyBinder")
		return
	end

	S:CreateShadow(frame)
	S:CreateBackdropShadow(frame.header, true)
end

function module:Initialize()
	if E.private.actionbar.enable ~= true then return; end

	local db = E.db.mui.actionbars

	if E.Retail then
		self:EquipSpecBar()
	end

	-- ElvUI action bar
	if not E.private.actionbar.masque.actionbars then
		for id = 1, 10 do
			local bar = _G["ElvUI_Bar" .. id]
			self:SkinBar(bar, "PLAYER")
		end

		self:SecureHook(AB, "PositionAndSizeBar", "ElvUI_PositionAndSizeBar")
	end

	-- Pet bar
	if not E.private.actionbar.masque.petBar then
		self:SkinBar(_G.ElvUI_BarPet, "PET")
		self:SecureHook(AB, "PositionAndSizeBarPet", "ElvUI_PositionAndSizeBarPet")
	end

	-- Stance bar
	if not E.private.actionbar.masque.stanceBar then
		self:ElvUI_ActionBar_SkinBar(_G.ElvUI_StanceBar, "STANCE")
		self:SecureHook(AB, "PositionAndSizeBarShapeShift", "ElvUI_PositionAndSizeBarShapeShift")
	end

	-- Extra action bar
	self:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", "SkinZoneAbilities")

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		if button then
			S:CreateShadow(button)
		end
	end

	-- Vehicle leave button
	do
		local button = _G.MainMenuBarVehicleLeaveButton
		self:CreateBackdropShadow(button, true)

		local tex = button:GetNormalTexture()
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
			tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
			tex:SetTexture(MER.Media.Textures.arrowDown)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetVertexColor(1, 1, 1)
		end

		tex = button:GetPushedTexture()
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
			tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
			tex:SetTexture(MER.Media.Textures.arrowDown)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetVertexColor(1, 0, 0)
		end

		tex = button:GetHighlightTexture()
		if tex then
			tex:SetTexture(nil)
			tex:Hide()
		end
	end

	-- Extra action bar
	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		S:CreateBackdropShadow(button.backdrop, true)
	end

	-- Flyout
	self:SecureHook(AB, "SetupFlyoutButton", function(_, button)
		S:CreateShadow(button)
	end)

	-- Keybind
	self:ElvUI_ActionBar_LoadKeyBinder()
end

MER:RegisterModule(module:GetName())

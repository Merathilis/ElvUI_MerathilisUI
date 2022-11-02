local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')
local AB = E:GetModule('ActionBars')

local _G = _G

function module:SkinButton(button, useBackdrop)
	module:CreateLowerShadow(button)

	if not button.__MERSkin then
		if button.shadow and button.shadow.__MER then
			module:BindShadowColorWithBorder(button.shadow, button)
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
			module:CreateBackdropShadow(bar, true)
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
			module:SkinButton(button, bar.db.backdrop)
		end
	elseif type == "PET" then
		for i = 1, NUM_PET_ACTION_SLOTS do
			local button = _G["PetActionButton" .. i]
			module:SkinButton(button, bar.db.backdrop)
		end
	elseif type == "STANCE" then
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["ElvUI_StanceBarButton" .. i]
			module:SkinButton(button, bar.db.backdrop)
		end
	end
end

function module:ElvUI_PositionAndSizeBar(actionBarModule, barName)
	local bar = actionBarModule.handledBars[barName]
	module:SkinBar(bar, "PLAYER")
end

function module:ElvUI_PositionAndSizeBarPet()
	module:SkinBar(_G.ElvUI_BarPet, "PET")
end

function module:ElvUI_PositionAndSizeBarShapeShift()
	module:SkinBar(_G.ElvUI_StanceBar, "STANCE")
end

function module:ElvUI_ActionBar_LoadKeyBinder()
	local frame = _G.ElvUIBindPopupWindow
	if not frame then
		module:SecureHook(AB, "LoadKeyBinder", "ElvUI_ActionBar_LoadKeyBinder")
		return
	end

	module:CreateShadow(frame)
	module:CreateBackdropShadow(frame.header, true)
end

function module:Skin_ElvUI_ActionBars()
	if not E.private.actionbar.enable then
		return
	end

	-- ElvUI action bar
	-- if not IsAddOnLoaded('Masque') and not E.private.actionbar.masque.actionbars then
		-- for id = 1, 10 do
			-- local bar = _G["ElvUI_Bar"..id]
			-- module:SkinBar(bar, "PLAYER")
			-- bar.backdrop:Styling()
		-- end
--
		-- module:SecureHook(AB, "PositionAndSizeBar", "ElvUI_PositionAndSizeBar")
	-- end

	-- Pet bar
	-- if not IsAddOnLoaded('Masque') and not E.private.actionbar.masque.petBar then
		-- module:SkinBar(_G.ElvUI_BarPet, "PET")
		-- module:SecureHook(AB, "PositionAndSizeBarPet", "ElvUI_PositionAndSizeBarPet")
	-- end

	-- Stance bar
	-- if not IsAddOnLoaded('Masque') and not E.private.actionbar.masque.stanceBar then
		-- module:SkinBar(_G.ElvUI_StanceBar, "STANCE")
		-- module:SecureHook(AB, "PositionAndSizeBarShapeShift", "ElvUI_PositionAndSizeBarShapeShift")
	-- end

	-- Vehicle leave button
	do
		local button = _G.MainMenuBarVehicleLeaveButton

		module:CreateBackdropShadow(button, true)

		local tex = button:GetNormalTexture()
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
			tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
			tex:SetTexture(MER.Media.Textures.arrow)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetVertexColor(1, 1, 1, 1)
		end

		tex = button:GetPushedTexture()
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
			tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
			tex:SetTexture(MER.Media.Textures.arrow)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetVertexColor(1, 0, 0, 1)
		end

		tex = button:GetHighlightTexture()
		if tex then
			tex:SetTexture(nil)
			tex:Hide()
		end
	end

	-- Flyout
	-- module:SecureHook(AB, "SetupFlyoutButton", function(_, button)
		-- module:CreateShadow(button)
	-- end)

	-- Keybind
	-- module:ElvUI_ActionBar_LoadKeyBinder()
end

module:AddCallback("Skin_ElvUI_ActionBars")

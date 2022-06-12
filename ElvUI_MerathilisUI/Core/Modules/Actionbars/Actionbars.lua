---@diagnostic disable: 211
local MER, F, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Actionbars')
local S = MER:GetModule('MER_Skins')
local AB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs

local C_TimerAfter = C_Timer.After
local hooksecurefunc = hooksecurefunc

function module:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(styleBacks) do
			if frame and frame.backdrop then
				frame.backdrop:Styling()
			end
		end
	end

	-- Other bar backdrops
	local styleOtherBacks = {_G.ElvUI_BarPet, _G.ElvUI_StanceBar}
	for _, frame in pairs(styleOtherBacks) do
		if frame and frame.backdrop then
			frame.backdrop:Styling()
		end
	end

	-- Pet Buttons
	for i = 1, _G.NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in pairs(petButtons) do
			if button then
				button:Styling()
			end
		end
	end
end

function module:ActionBar_Shadow(bar, type)
	if not bar and bar.backdrop then return end

	if bar.db.backdrop then
		if not bar.backdrop.shadow then
			S:CreateBackdropShadow(bar, true)
		end
		if bar.backdrop.shadow then
			bar.backdrop.shadow:Show()
		end
	else
		if bar.backdrop.shadow then
			bar.backdrop.shadow:Hide()
		end
	end

	if type == "PLAYER" then
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = bar.buttons[i]
			S:CreateBackdropShadow(button, true)
		end
	elseif type == "PET" then
		for i = 1, NUM_PET_ACTION_SLOTS do
			local button = _G["PetActionButton" .. i]
			S:CreateBackdropShadow(button, true)
		end
	elseif type == "STANCE" then
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["ElvUI_StanceBarButton" .. i]
			S:CreateBackdropShadow(button, true)
		end
	end
end

function module:ActionBar_PositionAndSizeBar(module, barName)
	local bar = module.handledBars[barName]
	self:ActionBar_Shadow(bar, "PLAYER")
end

function module:ActionBar_PositionAndSizeBarPet()
	self:ActionBar_Shadow(_G.ElvUI_BarPet, "PET")
end

function module:ActionBar_PositionAndSizeBarShapeShift()
	self:ActionBar_Shadow(_G.ElvUI_StanceBar, "STANCE")
end

function module:SkinZoneAbilities(button)
	for spellButton in button.SpellButtonContainer:EnumerateActive() do
		if spellButton and spellButton.IsSkinned then
			module:CreateShadow(spellButton)
		end
	end
end

function module:ActionBar_LoadKeyBinder()
	local frame = _G.ElvUIBindPopupWindow
	if not frame then
		self:SecureHook(AB, "LoadKeyBinder", "ActionBar_LoadKeyBinder")
		return
	end

	module:CreateShadow(frame)
	S:CreateBackdropShadow(frame.header, true)
end

local function ReskinVehicleExit()
	if E.private.actionbar.enable ~= true then
		return
	end

	local button = _G.MainMenuBarVehicleLeaveButton
	S:CreateBackdropShadow(button, true)
	local tex = button:GetNormalTexture()
	if tex then
		tex:SetTexture(MER.Media.Textures.arrow)
		tex:SetTexCoord(0, 1, 0, 1)
		tex:SetVertexColor(1, 1, 1)
	end

	tex = button:GetPushedTexture()
	if tex then
		tex:SetTexture(MER.Media.Textures.arrow)
		tex:SetTexCoord(0, 1, 0, 1)
		tex:SetVertexColor(1, 0, 0)
	end

	tex = button:GetHighlightTexture()
	if tex then
		tex:SetTexture(nil)
		tex:Hide()
	end
end

local function StyleKeybinder()
	if E.db.mui.general.style ~= true then return end

	local frame = _G.ElvUIBindPopupWindow
	if frame then
		frame:Styling()
	end
end
hooksecurefunc(AB, "LoadKeyBinder", StyleKeybinder)

function module:Initialize()
	if E.private.actionbar.enable ~= true then return; end

	local db = E.db.mui.actionbars

	if E.Retail then
		self:EquipSpecBar()
		ReskinVehicleExit()
	end

	C_TimerAfter(1, module.StyleBackdrops)

	for id = 1, 10 do
		local bar = _G["ElvUI_Bar" .. id]
		self:ActionBar_Shadow(bar, "PLAYER")
	end

	self:SecureHook(AB, "PositionAndSizeBar", "ActionBar_PositionAndSizeBar")

	self:ActionBar_Shadow(_G.ElvUI_BarPet, "PET")
	self:SecureHook(AB, "PositionAndSizeBarPet", "ActionBar_PositionAndSizeBarPet")

	self:ActionBar_Shadow(_G.ElvUI_StanceBar, "STANCE")
	self:SecureHook(AB, "PositionAndSizeBarShapeShift", "ActionBar_PositionAndSizeBarShapeShift")

	if E.Retail then
		self:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", "SkinZoneAbilities")

		for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
			local button = _G["ExtraActionButton" .. i]
			if button then
				module:CreateShadow(button)
			end
		end
	end

	self:SecureHook(AB, "SetupFlyoutButton", function(_, button)
		S:CreateBackdropShadow(button, true)
	end)

	-- Keybind
	self:ActionBar_LoadKeyBinder()
end

MER:RegisterModule(module:GetName())

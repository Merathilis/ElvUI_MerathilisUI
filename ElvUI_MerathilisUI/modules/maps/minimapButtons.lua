local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIMinimapButtons", 'AceTimer-3.0')
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select, tostring, unpack = pairs, select, tostring, unpack
local strfind, strlen, strlower, strsub = strfind, strlen, strlower, strsub
local tContains, tinsert = tContains, table.insert
--WoW API / Variables
local C_Timer_After = C_Timer.After
local InCombatLockdown = InCombatLockdown
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local C_PetBattles_IsInBattle = C_PetBattles.IsInBattle
local Minimap = Minimap
local CreateFrame = CreateFrame
-- GLOBALS:

local r, g, b = unpack(E.media.rgbvaluecolor)

module.Buttons = {}

module.IgnoreButton = {
	'GameTimeFrame',
	'HelpOpenWebTicketButton',
	'MiniMapVoiceChatFrame',
	'TimeManagerClockButton',
	'BattlefieldMinimap',
	'ButtonCollectFrame',
	'GameTimeFrame',
	'QueueStatusMinimapButton',
	'GarrisonLandingPageMinimapButton',
	'MiniMapMailFrame',
	'MiniMapTracking',
	'MinimapZoomIn',
	'MinimapZoomOut',
	'RecipeRadarMinimapButtonFrame',
}

module.GenericIgnore = {
	'Archy',
	'GatherMatePin',
	'GatherNote',
	'GuildInstance',
	'HandyNotesPin',
	'MiniMap',
	'Spy_MapNoteList_mini',
	'ZGVMarker',
	'poiMinimap',
	'GuildMap3Mini',
	'LibRockConfig-1.0_MinimapButton',
	'NauticusMiniIcon',
	'WestPointer',
	'Cork',
	'DugisArrowMinimapPoint',
	'QuestieFrame',
}

module.PartialIgnore = { 'Node', 'Note', 'Pin', 'POI' }

module.OverrideTexture = {
	BagSync_MinimapButton = [[Interface\AddOns\BagSync\media\icon]],
	DBMMinimapButton = [[Interface\Icons\INV_Helmet_87]],
	SmartBuff_MiniMapButton = [[Interface\Icons\Spell_Nature_Purge]],
	VendomaticButtonFrame = [[Interface\Icons\INV_Misc_Rabbit_2]],
	OutfitterMinimapButton = '',
}

module.UnrulyButtons = {}

local ButtonFunctions = { 'SetParent', 'ClearAllPoints', 'SetPoint', 'SetSize', 'SetScale', 'SetFrameStrata', 'SetFrameLevel' }

local RemoveTextureID = {
	[136430] = true,
	[136467] = true,
	[136468] = true,
	[130924] = true,
}

local RemoveTextureFile = {
	["interface/minimap/minimap-trackingborder"] = true,
	["interface/minimap/ui-minimap-border"] = true,
	["interface/minimap/ui-minimap-background"] = true,
}

function module:LockButton(Button)
	for _, Function in pairs(ButtonFunctions) do
		Button[Function] = E.noop
	end
end

function module:UnlockButton(Button)
	for _, Function in pairs(ButtonFunctions) do
		Button[Function] = nil
	end
end

local function HideButton()
	module.bin:Hide()
end

local function ClickFunc()
	UIFrameFadeOut(module.bin, .5, 1, 0)
	C_Timer_After(.5, HideButton)
end

function module:SkinMinimapButton(Button)
	if (not Button) or Button.isSkinned then return end

	local Name = Button.GetName and Button:GetName()
	if not Name then return end

	if tContains(module.IgnoreButton, Name) then return end

	for i = 1, #module.GenericIgnore do
		if strsub(Name, 1, strlen(module.GenericIgnore[i])) == module.GenericIgnore[i] then return end
	end

	for i = 1, #module.PartialIgnore do
		if strfind(Name, module.PartialIgnore[i]) ~= nil then return end
	end

	for i = 1, Button:GetNumRegions() do
		local Region = select(i, Button:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('Texture') then
			local Texture = Region.GetTextureFileID and Region:GetTextureFileID()

			if RemoveTextureID[Texture] then
				Region:SetTexture()
			else
				Texture = strlower(tostring(Region:GetTexture()))
				if RemoveTextureFile[Texture] or (strfind(Texture, [[interface\characterframe]]) or (strfind(Texture, [[interface\minimap]]) and not strfind(Texture, [[interface\minimap\tracking\]])) or strfind(Texture, 'border') or strfind(Texture, 'background') or strfind(Texture, 'alphamask') or strfind(Texture, 'highlight')) then
					Region:SetTexture()
					Region:SetAlpha(0)
				else
					if module.OverrideTexture[Name] then
						Region:SetTexture(module.OverrideTexture[Name])
					end

					Region:ClearAllPoints()
					Region:SetDrawLayer('ARTWORK')
					Region:SetInside()

					if not Button.ignoreCrop then
						Region:SetTexCoord(unpack(E.TexCoords))
						Button:HookScript('OnLeave', function() Region:SetTexCoord(unpack(E.TexCoords)) end)
					end

					Region.SetPoint = function() return end
				end
			end
		end
	end

	Button:SetFrameLevel(Minimap:GetFrameLevel() + 10)
	Button:SetFrameStrata(Minimap:GetFrameStrata())
	Button:SetSize(module.db.size, module.db.size)

	if not Button.ignoreTemplate then
		Button:CreateBackdrop("Transparent")
		Button.backdrop:Styling()
	end

	Button.isSkinned = true
	tinsert(module.Buttons, Button)
end

function module:GrabMinimapButtons()
	if (InCombatLockdown() or C_PetBattles and C_PetBattles_IsInBattle()) then return end

	for _, Button in pairs(module.UnrulyButtons) do
		if _G[Button] then
			_G[Button]:SetParent(Minimap)
		end
	end

	for _, Frame in pairs({ Minimap, _G.MinimapBackdrop }) do
		local NumChildren = Frame:GetNumChildren()
		if NumChildren < (Frame.moduleNumChildren or 0) then return end
		for i = 1, NumChildren do
			local object = select(i, Frame:GetChildren())
			if object then
				local name = object:GetName()
				local width = object:GetWidth()
				if name and width > 15 and width < 40 and (object:IsObjectType('Button') or object:IsObjectType('Frame')) then
					self:SkinMinimapButton(object)
				end
			end
		end

		Frame.moduleNumChildren = NumChildren
	end

	self:Update()
end

function module:Update()
	if E.db.mui.smb.enable ~= true then return end

	local AnchorX, AnchorY = 0, 1
	local ButtonsPerRow = module.db.perRow or 12
	local Spacing = module.db.spacing or 2
	local Size = module.db.size
	local ActualButtons, Maxed = 0

	local Anchor, DirMult = 'TOPRIGHT', -1

	for _, Button in pairs(module.Buttons) do
		if Button:IsShown() then
			local Name = Button:GetName()
			AnchorX, ActualButtons = AnchorX + 1, ActualButtons + 1

			if (AnchorX % (ButtonsPerRow + 1)) == 0 then
				AnchorY, AnchorX, Maxed = AnchorY + 1, 1, true
			end

			module:UnlockButton(Button)

			Button:SetParent(module.bin)
			Button:ClearAllPoints()
			Button:SetPoint(Anchor, self.bin, Anchor, DirMult * (Spacing + ((Size + Spacing) * (AnchorX - 1))), (- Spacing - ((Size + Spacing) * (AnchorY - 1))))
			Button:SetSize(Size, Size)
			Button:SetScale(1)
			Button:SetFrameStrata('MEDIUM')
			Button:SetFrameLevel(module.bin:GetFrameLevel()+1)

			if Button:HasScript("OnDragStart") then Button:SetScript("OnDragStart", nil) end
			if Button:HasScript("OnDragStop") then Button:SetScript("OnDragStop", nil) end

			module:LockButton(Button)

			if Maxed then ActualButtons = ButtonsPerRow end
		end
	end

	local BarWidth = Spacing + (Size * ActualButtons) + (Spacing * (ActualButtons - 1)) + Spacing
	local BarHeight = Spacing + (Size * AnchorY) + (Spacing * (AnchorY - 1)) + Spacing

	module.bin:SetSize(BarWidth, BarHeight)

	-- Styling
	local topLine = CreateFrame("Frame", nil, module.bin)
	topLine:SetPoint("BOTTOMRIGHT", module.bin, "TOPRIGHT", 1, 0)
	MER:CreateGradientFrame(topLine, BarWidth, 1, "Horizontal", r, g, b, 0, .7)

	local bottomLine = CreateFrame("Frame", nil, module.bin)
	bottomLine:SetPoint("TOPRIGHT", module.bin, "BOTTOMRIGHT", 1, 0)
	MER:CreateGradientFrame(bottomLine, BarWidth, 1, "Horizontal", r, g, b, 0, .7)

	local rightLine = CreateFrame("Frame", nil, module.bin)
	rightLine:SetPoint("LEFT", module.bin, "RIGHT", 0, 0)
	MER:CreateGradientFrame(rightLine, 1, BarHeight, "Vertical", r, g, b, .7, .7)
end

function module:Initialize()
	local db = E.db.mui.smb
	MER:RegisterDB(self, "smb")
	if db.enable ~= true then return end

	-- Compatibility
	if COMP.SLE and E.private.sle.minimap.mapicons.enable then return end

	-- Button Creation
	module.button = CreateFrame("Button", "MinimapButtonsToggleButton", E.UIParent)
	module.button:SetSize(28, 28)
	module.button:ClearAllPoints()
	module.button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 10, 20)
	module.button:SetFrameStrata("HIGH")

	module.button:SetNormalTexture("Interface\\HelpFrame\\ReportLagIcon-Loot")
	module.button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	module.button:GetNormalTexture():SetInside()

	module.button:SetHighlightTexture("Interface\\HelpFrame\\ReportLagIcon-Loot")
	module.button:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	module.button:GetHighlightTexture():SetInside()

	module.button:SetPushedTexture("Interface\\HelpFrame\\ReportLagIcon-Loot")
	module.button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	module.button:GetPushedTexture():SetInside()

	E:CreateMover(module.button, 'MinimapButtonsToggleButtonMover', 'MinimapButtonsToggleButtonAnchor', nil, nil, nil, 'ALL,GENERAL,MERATHILISUI', nil, 'mui,modules,minimap')

	module.bin = CreateFrame("Frame", "MinimapButtonFrame", E.UIParent)
	module.bin:SetPoint("BOTTOMRIGHT", module.button, "TOPLEFT", 0, -15)
	module.bin:SetSize(module.db.size, module.db.size)
	module.bin:SetFrameStrata("HIGH")
	module.bin:Hide()

	-- Button Scripts
	module.button:SetScript("OnClick", function()
		if module.bin:IsShown() then
			ClickFunc()
		else
			UIFrameFadeIn(module.bin, .5, 0, 1)
		end
	end)

	self:ScheduleRepeatingTimer('GrabMinimapButtons', 6)
end

MER:RegisterModule(module:GetName())

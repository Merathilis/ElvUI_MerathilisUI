local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIMinimapButtons", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local COMP = MER:GetModule("mUICompatibility")

-- Credits to Azilroka

--Cache global variables
--Lua functions
local _G = _G
local strfind, strlen, strlower, strsub = string.find, string.len, string.lower, string.sub
local pairs, select, tostring, tonumber, unpack = pairs, select, tostring, tonumber, unpack
local ceil = math.ceil
local tContains,tinsert = tContains, table.insert
--WoW API / Variables
local CreateFrame = CreateFrame
local C_PetBattles_IsInBattle = C_PetBattles.IsInBattle
local InCombatLockdown = InCombatLockdown
local UIParent = UIParent
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local RegisterStateDriver = RegisterStateDriver
local Minimap = Minimap
-- GLOBALS:

module.Buttons = {}

module.IgnoreButtons = {
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
	'TukuiMinimapZone',
	'TukuiMinimapCoord',
}

module.GenericIgnores = {
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

module.PartialIgnores = { 'Node', 'Note', 'Pin', 'POI' }

module.OverrideTexture = {
	BagSync_MinimapButton = [[Interface\AddOns\BagSync\media\icon]],
	DBMMinimapButton = [[Interface\Icons\INV_Helmet_87]],
	SmartBuff_MiniMapButton = [[Interface\Icons\Spell_Nature_Purge]],
	VendomaticButtonFrame = [[Interface\Icons\INV_Misc_Rabbit_2]],
}

local ButtonFunctions = { 'SetParent', 'ClearAllPoints', 'SetPoint', 'SetSize', 'SetScale', 'SetFrameStrata', 'SetFrameLevel' }

local RemoveTextureID = {
	[136430] = true,
	[136467] = true,
	[130924] = true,
}

function module:LockButton(Button)
	for _, Function in pairs(ButtonFunctions) do
		Button[Function] = MER.dummy
	end
end

function module:UnlockButton(Button)
	for _, Function in pairs(ButtonFunctions) do
		Button[Function] = nil
	end
end

function module:HandleBlizzardButtons()
	if not self.db['enable'] then return end

	if self.db["moveTracker"] and not _G.MiniMapTrackingButton.module then
		_G.MiniMapTracking.Show = nil

		_G.MiniMapTracking:Show()

		_G.MiniMapTracking:SetParent(self.Bar)
		_G.MiniMapTracking:SetSize(self.db['iconSize'], self.db['iconSize'])

		_G.MiniMapTrackingIcon:ClearAllPoints()
		_G.MiniMapTrackingIcon:SetPoint('CENTER')

		_G.MiniMapTrackingBackground:SetAlpha(0)
		_G.MiniMapTrackingIconOverlay:SetAlpha(0)
		_G.MiniMapTrackingButton:SetAlpha(0)

		_G.MiniMapTrackingButton:SetParent(_G.MinimapTracking)
		_G.MiniMapTrackingButton:ClearAllPoints()
		_G.MiniMapTrackingButton:SetAllPoints(_G.MiniMapTracking)

		_G.MiniMapTrackingButton:SetScript('OnMouseDown', nil)
		_G.MiniMapTrackingButton:SetScript('OnMouseUp', nil)

		_G.MiniMapTrackingButton:HookScript('OnEnter', function(self)
			MiniMapTracking:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
			if module.Bar:IsShown() then
				UIFrameFadeIn(module.Bar, 0.2, module.Bar:GetAlpha(), 1)
			end
		end)
		_G.MiniMapTrackingButton:HookScript('OnLeave', function(self)
			MiniMapTracking:SetTemplate()
			if module.Bar:IsShown() and module.db['barMouseOver'] then
				UIFrameFadeOut(module.Bar, 0.2, module.Bar:GetAlpha(), 0)
			end
		end)

		_G.MiniMapTrackingButton.module = true
		tinsert(self.Buttons, _G.MiniMapTracking)
	end

	if self.db["moveQueue"] and not QueueStatusMinimapButton.module then
		local Frame = CreateFrame('Frame', 'module_QueueFrame', self.Bar)
		Frame:SetTemplate()
		Frame:SetSize(module.db['iconSize'], module.db['iconSize'])
		Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
		Frame.Icon:SetSize(module.db['iconSize'], module.db['iconSize'])
		Frame.Icon:SetPoint('CENTER')
		Frame.Icon:SetTexture([[Interface\LFGFrame\LFG-Eye]])
		Frame.Icon:SetTexCoord(0, 64 / 512, 0, 64 / 256)
		Frame:SetScript('OnMouseDown', function()
			if PVEFrame:IsShown() then
				HideUIPanel(PVEFrame)
			else
				ShowUIPanel(PVEFrame)
				GroupFinderFrame_ShowGroupFrame()
			end
		end)
		Frame:HookScript('OnEnter', function(self)
			self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
			if module.Bar:IsShown() then
				UIFrameFadeIn(module.Bar, 0.2, module.Bar:GetAlpha(), 1)
			end
		end)
		Frame:HookScript('OnLeave', function(self)
			self:SetTemplate()
			if module.Bar:IsShown() and module.db['barMouseOver'] then
				UIFrameFadeOut(module.Bar, 0.2, module.Bar:GetAlpha(), 0)
			end
		end)

		QueueStatusMinimapButton:SetParent(self.Bar)
		QueueStatusMinimapButton:SetFrameLevel(Frame:GetFrameLevel() + 2)
		QueueStatusMinimapButton:ClearAllPoints()
		QueueStatusMinimapButton:SetPoint("CENTER", Frame, "CENTER", 0, 0)

		QueueStatusMinimapButton:SetHighlightTexture(nil)

		QueueStatusMinimapButton:HookScript('OnShow', function(self)
			Frame:EnableMouse(false)
		end)
		QueueStatusMinimapButton:HookScript('PostClick', QueueStatusMinimapButton_OnLeave)
		QueueStatusMinimapButton:HookScript('OnHide', function(self)
			Frame:EnableMouse(true)
		end)

		QueueStatusMinimapButton.module = true
		tinsert(self.Buttons, Frame)
	end

	self:Update()
end

function module:SkinMinimapButton(Button)
	if (not Button) or Button.isSkinned then return end

	local Name = Button:GetName()
	if not Name then return end

	if tContains(module.IgnoreButtons, Name) then return end

	for i = 1, #module.GenericIgnores do
		if strsub(Name, 1, strlen(module.GenericIgnores[i])) == module.GenericIgnores[i] then return end
	end

	for i = 1, #module.PartialIgnores do
		if strfind(Name, module.PartialIgnores[i]) ~= nil then return end
	end

	for i = 1, Button:GetNumRegions() do
		local Region = select(i, Button:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('Texture') then
			local Texture = strlower(tostring(Region:GetTexture()))

			if RemoveTextureID[tonumber(Texture)] then
				Region:SetTexture()
			elseif (strfind(Texture, [[interface\characterframe]]) or strfind(Texture, [[interface\minimap]]) and not strfind(Texture, [[interface\minimap\tracking\]]) or strfind(Texture, 'border') or strfind(Texture, 'background') or strfind(Texture, 'alphamask') or strfind(Texture, 'highlight')) then
				Region:SetTexture()
				Region:SetAlpha(0)
			else
				if module.OverrideTexture[Name] then
					Region:SetTexture(module.OverrideTexture[Name])
				elseif Name == 'OutfitterMinimapButton' and Texture == [[interface\addons\outfitter\textures\minimapbutton]] then
					Region:SetTexture()
				end

				Region:ClearAllPoints()
				Region:SetDrawLayer('ARTWORK')
				Region:SetInside()

				if not Button.ignoreCrop then
					Region:SetTexCoord(unpack(self.TexCoords))
					Button:HookScript('OnLeave', function() Region:SetTexCoord(unpack(self.TexCoords)) end)
				end

				Region.SetPoint = function() return end
			end
		end
	end

	Button:SetFrameLevel(Minimap:GetFrameLevel() + 5)
	Button:SetSize(module.db['iconSize'], module.db['iconSize'])
	Button:SetTemplate()
	Button:HookScript('OnEnter', function(self)
		if module.Bar:IsShown() then
			UIFrameFadeIn(module.Bar, 0.2, module.Bar:GetAlpha(), 1)
		end
	end)
	Button:HookScript('OnLeave', function(self)
		self:SetTemplate()
		if module.Bar:IsShown() and module.db['barMouseOver'] then
			UIFrameFadeOut(module.Bar, 0.2, module.Bar:GetAlpha(), 0)
		end
	end)

	Button.isSkinned = true
	tinsert(self.Buttons, Button)
end

function module:GrabMinimapButtons()
	if (InCombatLockdown() or C_PetBattles_IsInBattle()) then return end

	for _, Frame in pairs({ Minimap, MinimapBackdrop }) do
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
	if not module.db['enable'] then return end

	local AnchorX, AnchorY, MaxX = 0, 1, module.db['buttonsPerRow'] or 12
	local ButtonsPerRow = module.db['buttonsPerRow'] or 12
	local Spacing = module.db['buttonSpacing'] or 2
	local Size = module.db['iconSize'] or 27
	local ActualButtons, Maxed = 0

	local Anchor, DirMult = 'TOPLEFT', 1

	if module.db['reverseDirection'] then
		Anchor, DirMult = 'TOPRIGHT', -1
	end

	for _, Button in pairs(module.Buttons) do
		if Button:IsVisible() then
			AnchorX, ActualButtons = AnchorX + 1, ActualButtons + 1

			if (AnchorX % (ButtonsPerRow + 1)) == 0 then
				AnchorY, AnchorX, Maxed = AnchorY + 1, 1, true
			end

			module:UnlockButton(Button)

			Button:SetTemplate()
			Button:SetParent(self.Bar)
			Button:ClearAllPoints()
			Button:SetPoint(Anchor, self.Bar, Anchor, DirMult * (Spacing + ((Size + Spacing) * (AnchorX - 1))), (- Spacing - ((Size + Spacing) * (AnchorY - 1))))
			Button:SetSize(module.db['iconSize'], module.db['iconSize'])
			Button:SetScale(1)
			Button:SetFrameStrata('LOW')
			Button:SetFrameLevel(self.Bar:GetFrameLevel() + 1)
			Button:SetScript('OnDragStart', nil)
			Button:SetScript('OnDragStop', nil)

			module:LockButton(Button)

			if Maxed then ActualButtons = ButtonsPerRow end
		end
	end

	local BarWidth = Spacing + (Size * ActualButtons) + (Spacing * (ActualButtons - 1)) + Spacing
	local BarHeight = Spacing + (Size * AnchorY) + (Spacing * (AnchorY - 1)) + Spacing
	self.Bar:SetSize(BarWidth, BarHeight)

	if self.db.backdrop then
		self.Bar:SetTemplate('Transparent', true)
	else
		self.Bar:SetBackdrop(nil)
	end

	if ActualButtons == 0 then
		self.Bar:Hide()
	else
		self.Bar:Show()
	end

	if self.db['barMouseOver'] then
		UIFrameFadeOut(self.Bar, 0.2, self.Bar:GetAlpha(), 0)
	else
		UIFrameFadeIn(self.Bar, 0.2, self.Bar:GetAlpha(), 1)
	end
end

function module:Initialize()
	local db = E.db.mui.smb
	MER:RegisterDB(self, "smb")

	if E.private.general.minimap.enable ~= true or db.enable ~= true then return end
	if (COMP.SLE and E.private.sle.minimap.mapicons.enable) then return end

	module.Hider = CreateFrame("Frame", nil, UIParent)

	module.Bar = CreateFrame('Frame', 'SquareMinimapButtonBar', UIParent)
	module.Bar:Hide()
	module.Bar:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -28, 197)
	module.Bar:SetFrameStrata('LOW')
	module.Bar:SetClampedToScreen(true)
	module.Bar:SetMovable(true)
	module.Bar:EnableMouse(true)
	module.Bar:SetSize(module.db.iconSize, module.db.iconSize)

	module.Bar:SetScript('OnEnter', function(self) UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	module.Bar:SetScript('OnLeave', function(self)
		if db['barMouseOver'] then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	function module:ForUpdateAll()
		module.db = E.db.mui.smb
		module:Update()
	end
	module:ForUpdateAll()

	E:CreateMover(module.Bar, "MER_SquareMinimapButtonBarMover", "SquareMinimapButtonBar Anchor", nil, nil, nil, 'ALL,GENERAL,MERATHILISUI', nil, 'mui,modules,minimap')

	module.TexCoords = {unpack(E.TexCoords)}

	module:ScheduleRepeatingTimer('GrabMinimapButtons', 6)
	module:ScheduleTimer('HandleBlizzardButtons', 7)

	if module.db.hideInCombat then
		RegisterStateDriver(module.Bar, 'visibility', '[combat] hide;show')
	end
end

MER:RegisterModule(module:GetName())

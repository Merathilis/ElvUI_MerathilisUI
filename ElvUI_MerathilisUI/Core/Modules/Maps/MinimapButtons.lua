local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_MiniMapButtons')
local MM = E:GetModule('Minimap')
local S = MER:GetModule('MER_Skins')

local _G = _G
local ceil, floor, min = ceil, floor, min
local pairs, print, select, type, unpack = pairs, print, select, type, unpack
local strfind = strfind
local strlen = strlen
local strsub = strsub
local tinsert = tinsert

local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local IgnoreList = {
	full = {
		"AsphyxiaUIMinimapHelpButton",
		"AsphyxiaUIMinimapVersionButton",
		"ElvConfigToggle",
		"ElvUIConfigToggle",
		"ElvUI_ConsolidatedBuffs",
		"HelpOpenTicketButton",
		"MMHolder",
		"DroodFocusMinimapButton",
		"QueueStatusMinimapButton",
		"TimeManagerClockButton",
		"MinimapZoneTextButton",
		"MiniMapTracking",
		"MinimapZoomIn",
		"MinimapZoomOut",
		"TukuiMinimapZone",
		"TukuiMinimapCoord",
		"RecipeRadarMinimapButtonFrame",
		"InstanceDifficultyFrame",
		"BattlefieldMinimap",
	},
	startWith = {
		"Archy",
		"GatherMatePin",
		"GatherNote",
		"GuildInstance",
		"HandyNotesPin",
		"MinimMap",
		"Spy_MapNoteList_mini",
		"ZGVMarker",
		"poiMinimap",
		"GuildMap3Mini",
		"LibRockConfig-1.0_MinimapButton",
		"NauticusMiniIcon",
		"WestPointer",
		"Cork",
		"DugisArrowMinimapPoint",
		"QuestieFrame",
	},
	partial = {
		"Node",
		"Note",
		"Pin",
		"POI"
	}
}

local TexCoordIgnoreList = {
	["Narci_MinimapButton"] = true,
	["ZygorGuidesViewerMapIcon"] = true
}

local whiteList = {
	"LibDBIcon"
}

local acceptedFrames = {
	"BagSync_MinimapButton"
}

local moveButtons = {}

do
	local modified = false
	function module:UpdateGarrisonMinimapIcon(icon)
		icon = icon or _G.GarrisonLandingPageMinimapButton

		if not icon then
			return
		end
		icon:SetScale(E.uiscale)

		local box = _G.GarrisonLandingPageTutorialBox
		if box then
			box:SetScale(E.uiscale)
			box:SetClampedToScreen(true)
		end

		if not modified then
			icon.AlertText:Hide()
			icon.AlertText:SetAlpha(0)
			icon.AlertText.Show = E.noop
			icon.AlertText.Hide = E.noop

			icon.AlertBG:SetAlpha(0)
			icon.AlertBG:Hide()
			icon.AlertBG.Show = E.noop
			icon.AlertBG.Hide = E.noop

			icon.AlertText.SetText = function(_, text)
				if text then
					print(F.CreateColorString(icon.title or L["Garrison"], E.db.general.valuecolor) .. ": " .. text)
				end
			end

			modified = true
		end

		self:UpdateLayout()
	end
end

do
	local originalFunction = MM.HandleGarrisonButton
	function MM:HandleGarrisonButton()
		local icon = _G.GarrisonLandingPageMinimapButton

		if not icon or not icon.isMinimapButton or InCombatLockdown() then
			return originalFunction(self)
		else
			return module:UpdateGarrisonMinimapIcon(icon)
		end
	end
end

function module:SetButtonMouseOver(button, frame, rawhook)
	if not frame.HookScript then
		return
	end

	local function ButtonOnEnter()
		if button.backdrop.SetBackdropBorderColor then
			button.backdrop:SetBackdropBorderColor(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
		end
		if not self.db.mouseOver then
			return
		end
		E:UIFrameFadeIn(self.bar, (1 - self.bar:GetAlpha()) * 0.382, self.bar:GetAlpha(), 1)
	end

	local function ButtonOnLeave()
		if button.backdrop.SetBackdropBorderColor then
			button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		if not self.db.mouseOver then
			return
		end
		E:UIFrameFadeOut(self.bar, self.bar:GetAlpha() * 0.382, self.bar:GetAlpha(), 0)
	end

	if not rawhook then
		frame:HookScript("OnEnter", ButtonOnEnter)
		frame:HookScript("OnLeave", ButtonOnLeave)
	else
		local OriginalOnEnter = frame:GetScript("OnEnter") or E.noop
		local OriginalOnLeave = frame:GetScript("OnLeave") or E.noop
		frame:SetScript("OnEnter", function()
			OriginalOnEnter(frame)
			ButtonOnEnter()
		end)
		frame:SetScript("OnLeave", function()
			OriginalOnLeave(frame)
			ButtonOnLeave()
		end)
	end
end

function module:SkinButton(frame)
	if not self.db.calendar then
		tinsert(IgnoreList.full, "GameTimeFrame")
	end

	if frame == nil or frame:GetName() == nil or not frame:IsVisible() then
		return
	end

	local tmp
	local frameType = frame:GetObjectType()
	if frameType == "Button" then
		tmp = 1
	elseif frameType == "Frame" then
		for _, f in pairs(acceptedFrames) do
			if frame:GetName() == f then
				tmp = 2
				break
			end
		end
	end
	if not tmp then
		return
	end

	local name = frame:GetName()
	local validIcon = false

	for i = 1, #whiteList do
		if strsub(name, 1, strlen(whiteList[i])) == whiteList[i] then
			validIcon = true
			break
		end
	end

	if not validIcon then
		for _, ignoreName in pairs(IgnoreList.full) do
			if name == ignoreName then
				return
			end
		end
		for _, ignoreName in pairs(IgnoreList.startWith) do
			if strsub(name, 1, strlen(ignoreName)) == ignoreName then
				return
			end
		end

		for _, ignoreName in pairs(IgnoreList.partial) do
			if strfind(name, ignoreName) ~= nil then
				return
			end
		end
	end

	if name ~= "GarrisonLandingPageMinimapButton" and tmp ~= 2 then
		frame:SetPushedTexture(nil)
		frame:SetDisabledTexture(nil)
		frame:SetHighlightTexture(nil)
	elseif name == "DBMMinimapButton" then
		frame:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
	elseif name == "SmartBuff_MiniMapButton" then
		frame:SetNormalTexture(select(3, GetSpellInfo(12051)))
	elseif name == "GarrisonLandingPageMinimapButton" and self.db.garrison then
		if not frame.isMinimapButton then
			self:UpdateGarrisonMinimapIcon(_G.GarrisonLandingPageMinimapButton)
			frame.isMinimapButton = true
		end
	elseif name == "GRM_MinimapButton" then
		frame.GRM_MinimapButtonBorder:Hide()
		frame:SetPushedTexture(nil)
		frame:SetHighlightTexture(nil)
		frame.SetPushedTexture = E.noop
		frame.SetHighlightTexture = E.noop
		if frame:HasScript("OnEnter") then
			self:SetButtonMouseOver(frame, frame, true)
			frame.OldSetScript = frame.SetScript
			frame.SetScript = E.noop
		end
	end

	if not frame.isSkinned then
		if tmp ~= 2 then
			frame:HookScript("OnClick", self.DelayedUpdateLayout)
		end
		for _, region in pairs({frame:GetRegions()}) do
			local original = {}
			original.Width, original.Height = frame:GetSize()
			original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs = frame:GetPoint()
			original.Parent = frame:GetParent()
			original.FrameStrata = frame:GetFrameStrata()
			original.FrameLevel = frame:GetFrameLevel()
			original.Scale = frame:GetScale()
			if frame:HasScript("OnDragStart") then
				original.DragStart = frame:GetScript("OnDragStart")
			end
			if frame:HasScript("OnDragStop") then
				original.DragEnd = frame:GetScript("OnDragStop")
			end

			frame.original = original

			if name == "GameTimeFrame" and region:IsObjectType("FontString") then
				region:SetDrawLayer("ARTWORK")
				region:SetParent(frame)
				frame.MERToday = region
			end

			if region:IsObjectType("Texture") then
				local t = region:GetTexture()

				-- Remove rings and backdrops of LibDBIcon icons
				if t and strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
					if region ~= frame.icon then
						region:SetTexture(nil)
					end
				end

				if t and type(t) ~= "number" and (strfind(t, "Border") or strfind(t, "Background") or strfind(t, "AlphaMask")) then
					region:SetTexture(nil)
				else
					if name == "BagSync_MinimapButton" then
						region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon")
					end

					if not TexCoordIgnoreList[name] then
						region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					end

					region:ClearAllPoints()
					region:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
					region:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

					region:SetDrawLayer("ARTWORK")
					if (name == "GameTimeFrame") then
						if not frame.MERTex then
							local tex = frame:CreateTexture()
							tex:SetTexture(MER.Media.Icons.calendar)
							tex:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							frame.MERTex = tex
						end

						if (region:GetName() == "GameTimeCalendarInvitesTexture") then
							region:SetTexCoord(0.03125, 0.6484375, 0.03125, 0.8671875)
							region:SetDrawLayer("ARTWORK", 1)
						elseif (region:GetName() == "GameTimeCalendarInvitesGlow") then
							region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
						elseif (region:GetName() == "GameTimeCalendarEventAlarmTexture") then
							region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
						elseif (region:GetName() == "GameTimeTexture") then
							region:SetTexCoord(0.0, 0.390625, 0.0, 0.78125)
						else
							region:SetTexCoord(0.0, 0.390625, 0.0, 0.78125)
							if not frame.MERTex or frame.MERTex ~= region then
								if not frame.backdrop or frame.backdrop ~= region then
									region:SetTexture(nil)
								end
							end
						end
					end

					if (name == "PS_MinimapButton") then
						region.SetPoint = E.noop
					end
				end
			end
		end

		frame:CreateBackdrop("Tranparent")
		if E.private.mui.skins.enable and E.private.mui.skins.shadow.enable then
			S:CreateBackdropShadow(frame)
		end

		self:SetButtonMouseOver(frame, frame)

		if name == "Narci_MinimapButton" then
			self:SetButtonMouseOver(frame, frame.Panel)
			for _, child in pairs {frame.Panel:GetChildren()} do
				if child.SetScript and not child.Highlight then
					self:SetButtonMouseOver(frame, child, true)
				end
			end
		elseif name == "TomCats-MinimapButton" then
			if _G["TomCats-MinimapButtonBorder"] then
				_G["TomCats-MinimapButtonBorder"]:SetAlpha(0)
			end
			if _G["TomCats-MinimapButtonBackground"] then
				_G["TomCats-MinimapButtonBackground"]:SetAlpha(0)
			end
			if _G["TomCats-MinimapButtonIcon"] then
				_G["TomCats-MinimapButtonIcon"]:ClearAllPoints()
				_G["TomCats-MinimapButtonIcon"]:SetInside(frame.backdrop)
				_G["TomCats-MinimapButtonIcon"].SetPoint = E.noop
			end
		elseif name == "WIM3MinimapButton" then
			_G["WIM3MinimapButton"]:SetParent(Minimap)
		end

		tinsert(moveButtons, name)

		frame.isSkinned = true
	end
end

function module.DelayedUpdateLayout()
	if module.db.orientation ~= "NOANCHOR" then
		E:Delay(1, module.UpdateLayout, module)
	end
end

function module:UpdateLayout()
	if not self.db.enable then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")
		return
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	local buttonsPerRow = self.db.buttonsPerRow
	local numOfRows = ceil(#moveButtons / buttonsPerRow)
	local spacing = self.db.spacing
	local backdropSpacing = self.db.backdropSpacing
	local buttonSize = self.db.buttonSize
	local direction = not self.db.inverseDirection

	local buttonX, buttonY, anchor, offsetX, offsetY

	for i, moveButton in pairs(moveButtons) do
		local frame = _G[moveButton]

		if self.db.orientation == "NOANCHOR" then
			local original = frame.original
			frame:SetParent(original.Parent)
			if original.DragStart then
				frame:SetScript("OnDragStart", original.DragStart)
			end
			if original.DragEnd then
				frame:SetScript("OnDragStop", original.DragEnd)
			end

			frame:ClearAllPoints()
			frame:SetSize(original.Width, original.Height)

			if original.Point ~= nil then
				frame:SetPoint(original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs)
			else
				frame:SetPoint("CENTER", _G.Minimap, "CENTER", -80, -34)
			end
			frame:SetFrameStrata(original.FrameStrata)
			frame:SetFrameLevel(original.FrameLevel)
			frame:SetScale(original.Scale)
			frame:SetMovable(true)
		else
			buttonX = i % buttonsPerRow
			buttonY = floor(i / buttonsPerRow) + 1

			if buttonX == 0 then
				buttonX = buttonsPerRow
				buttonY = buttonY - 1
			end

			frame:SetParent(self.bar)
			frame:SetMovable(false)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnDragStop", nil)

			frame:ClearAllPoints()
			frame:SetFrameStrata("LOW")
			frame:SetFrameLevel(20)
			frame:SetSize(buttonSize, buttonSize)
			offsetX = backdropSpacing + (buttonX - 1) * (buttonSize + spacing)
			offsetY = backdropSpacing + (buttonY - 1) * (buttonSize + spacing)

			if self.db.orientation == "HORIZONTAL" then
				if direction then
					anchor = "TOPLEFT"
					offsetY = -offsetY
				else
					anchor = "TOPRIGHT"
					offsetX, offsetY = -offsetX, -offsetY
				end
			else
				if direction then
					anchor = "TOPLEFT"
					offsetX, offsetY = offsetY, -offsetX
				else
					anchor = "BOTTOMLEFT"
					offsetX, offsetY = offsetY, offsetX
				end
			end

			frame:ClearAllPoints()
			frame:SetPoint(anchor, self.bar, anchor, offsetX, offsetY)
		end

		if E.private.mui.skins.enable and E.private.mui.skins.shadow.enable then
			if not self.db.backdrop then
				frame.backdrop.shadow:Show()
			else
				frame.backdrop.shadow:Hide()
			end
		end

		if moveButton == "GameTimeFrame" then
			frame.MERToday:ClearAllPoints()
			frame.MERToday:SetPoint("CENTER", frame, "CENTER", 0, -0.15 * buttonSize)
		end
	end

	buttonsPerRow = min(buttonsPerRow, #moveButtons)

	if self.db.orientation ~= "NOANCHOR" and #moveButtons > 0 then
		local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow - 1) + backdropSpacing * 2
		local height = buttonSize * numOfRows + spacing * (numOfRows - 1) + backdropSpacing * 2

		if self.db.orientation == "VERTICAL" then
			width, height = height, width
		end

		self.bar:SetSize(width, height)
		self.barAnchor:SetSize(width, height)
		RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
		self.bar:Show()
	else
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
	end

	if self.db.orientation == "HORIZONTAL" then
		anchor = direction and "LEFT" or "RIGHT"
	else
		anchor = direction and "TOP" or "BOTTOM"
	end

	self.bar:SetPoint(anchor, self.barAnchor, anchor, 0, 0)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function module:SkinMinimapButtons()
	self:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for _, child in pairs({_G.Minimap:GetChildren()}) do
		self:SkinButton(child)
	end

	if self.db.garrison then
		self:SkinButton(_G.GarrisonLandingPageMinimapButton)
	end

	self:UpdateLayout()
end

function module:UpdateMouseOverConfig()
	if self.db.mouseOver then
		self.bar:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, (1 - self:GetAlpha()) * 0.382, self:GetAlpha(), 1)
		end)

		self.bar:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, self:GetAlpha() * 0.382, self:GetAlpha(), 0)
		end)

		self.bar:SetAlpha(0)
	else
		self.bar:SetScript("OnEnter", nil)
		self.bar:SetScript("OnLeave", nil)
		self.bar:SetAlpha(1)
	end
end

function module:StartSkinning()
	self:UnregisterEvent("ADDON_LOADED")
	E:Delay(5, self.SkinMinimapButtons, self)
end

function module:CreateFrames()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetPoint("BOTTOMRIGHT", _G.MMHolder, "TOPRIGHT", -2, 2)
	frame:SetFrameStrata("BACKGROUND")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
	self.bar = frame

	self:SkinMinimapButtons()
	self.bar:Styling()
	S:CreateShadowModule(self.bar.backdrop)

	E:CreateMover(self.barAnchor, "MERMinimapButtonBarAnchor", L["Minimap Buttons Bar"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", function() return E.db.mui.smb.enable end, "mui,modules,maps")
end

function module:SetUpdateHook()
	if not self.initialized then
		self:SecureHook(MM, "SetGetMinimapShape", "UpdateLayout")
		self:SecureHook(MM, "UpdateSettings", "UpdateLayout")
		self:SecureHook(E, "UpdateAll", "UpdateLayout")
		self.initialized = true
	end
end

function module:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetUpdateHook()
	E:Delay(1, self.SkinMinimapButtons, self)
end

function module:Initialize()
	self.db = E.db.mui.smb
	if not self.db.enable then
		return
	end

	self:CreateFrames()
	self:UpdateMouseOverConfig()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

MER:RegisterModule(module:GetName())

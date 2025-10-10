local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MiniMapButtons")
local S = MER:GetModule("MER_Skins")
local MM = E:GetModule("Minimap")
local C = MER.Utilities.Color

local _G = _G
local ceil = ceil
local floor = floor
local format = format
local gmatch = gmatch
local gsub = gsub
local min = min
local pairs = pairs
local select = select
local sort = sort
local strfind = strfind
local strlen = strlen
local strsub = strsub
local strtrim = strtrim
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture

local IgnoreList = {
	full = {
		"AsphyxiaUIMinimapHelpButton",
		"AsphyxiaUIMinimapVersionButton",
		"ElvConfigToggle",
		"ElvUIConfigToggle",
		"ElvUI_ConsolidatedBuffs",
		"HelpOpenTicketButton",
		"ElvUI_MinimapHolder",
		"DroodFocusMinimapButton",
		"TimeManagerClockButton",
		"MinimapZoneTextButton",
		"GameTimeFrame",
	},
	libDBIcon = {},
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
		"TTMinimapButton",
		"QueueStatusButton",
	},
	partial = {
		"Node",
		"Note",
		"Pin",
		"POI",
	},
}

local TexCoordIgnoreList = {
	["Narci_MinimapButton"] = true,
	["ZygorGuidesViewerMapIcon"] = true,
}

local whiteList = {}

local acceptedFrames = {
	"BagSync_MinimapButton",
	"WIM3MinimapButton",
}

local handledButtons = {} ---@type table<integer, {name: string, debugName: string, frame: Frame}>

local function isValidName(name)
	for _, ignoreName in pairs(IgnoreList.full) do
		if name == ignoreName then
			return false
		end
	end

	for _, ignoreName in pairs(IgnoreList.startWith) do
		if strsub(name, 1, strlen(ignoreName)) == ignoreName then
			return false
		end
	end

	for _, ignoreName in pairs(IgnoreList.partial) do
		if strfind(name, ignoreName) ~= nil then
			return false
		end
	end

	return true
end

function module:OnButtonSetShown(button, shown)
	local name, debugName = button:GetName(), button:GetDebugName()

	for i, names in pairs(handledButtons) do
		if name == names.name or debugName == names.debugName then
			if shown then
				return -- already in the list
			end
			tremove(handledButtons, i)
			break
		end
	end

	if shown then
		tinsert(handledButtons, { name = name, debugName = debugName, frame = button })
	end

	self:UpdateLayout()
end

function module:HandleLibDBIconButton(button, name)
	if not strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
		return true
	end

	if not button.Show or not button.Hide or not button.IsShown then
		return true
	end

	self:SecureHook(button, "Hide", function()
		self:OnButtonSetShown(button, false)
	end)

	self:SecureHook(button, "Show", function()
		self:OnButtonSetShown(button, true)
	end)

	self:SecureHook(button, "SetShown", "OnButtonSetShown")

	if button.icon and button.icon.SetTexCoord and not self:IsHooked(button.icon, "SetTexCoord") then
		F.InternalizeMethod(button.icon, "SetTexCoord")
		self:SecureHook(button.icon, "SetTexCoord", function(icon, arg1, arg2, arg3, arg4)
			local args = { arg1, arg2, arg3, arg4 }
			if F.IsAlmost(args, { 0.05, 0.95, 0.05, 0.95 }, 0.002) or F.IsAlmost(args, { 0, 1, 0, 1 }, 0.002) then
				F.CallMethod(icon, "SetTexCoord", unpack(E.TexCoords))
			end
		end)
		button.icon:SetTexCoord(unpack(E.TexCoords))
	end

	return button:IsShown()
end

function module:HandleExpansionButton(...)
	self.hooks[MM].HandleExpansionButton(...)
	self:Unhook(MM, "HandleExpansionButton")

	-- Run this post hook lazily and safely
	F.WaitFor(function()
		return module ~= nil and module.db ~= nil
	end, function()
		if not module.db.enable or not module.db.expansionLandingPage then
			return
		end

		local button = _G.ExpansionLandingPageMinimapButton
		if not button then
			return
		end

		self:SkinButton(button, true)

		MM:SetIconParent(button)
		MM:SetScale(button, 1)

		F.InternalizeMethod(button, "ClearAllPoints", true)
		F.InternalizeMethod(button, "SetPoint", true)
		F.InternalizeMethod(button, "SetParent", true)
		F.InternalizeMethod(button, "SetSize", true)
		F.InternalizeMethod(button, "SetScale", true)
		F.InternalizeMethod(button, "SetFrameStrata", true)
		F.InternalizeMethod(button, "SetFrameLevel", true)
		F.InternalizeMethod(button, "SetMovable", true)

		local box = _G.GarrisonLandingPageTutorialBox
		if box then
			box:SetScale(1)
			box:SetClampedToScreen(true)
		end

		button:SetHitRectInsets(0, 0, 0, 0)
		if button.AlertText then
			button.AlertText:Kill()
			button.AlertText.SetText = function(_, text)
				if text then
					local event = C.StringWithRGB(button.title or L["Garrison"], E.db.general.valuecolor)
					F.Print(event .. " " .. text)
				end
			end
		end

		if button.AlertBG then
			button.AlertBG:Kill()
		end

		RunNextFrame(function()
			F.TaskManager:OutOfCombat(module.UpdateLayout, module)
		end)
	end, 0.1, 100)
end

function module:SetButtonMouseOver(button, frame, rawhook)
	if not frame.HookScript then
		return
	end

	local function ButtonOnEnter()
		if button.backdrop.SetBackdropBorderColor then
			button.backdrop:SetBackdropBorderColor(
				E.db.general.valuecolor.r,
				E.db.general.valuecolor.g,
				E.db.general.valuecolor.b
			)
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

function module:SkinButton(button, force)
	if button == nil then
		return
	end

	local name = button:GetDebugName()
	if not force and (name == nil or not button:IsVisible() or button.isSkinned) then
		return
	end

	local buttonType, frameType = nil, button:GetObjectType()
	if frameType == "Button" then
		buttonType = 1
	elseif frameType == "Frame" then
		for _, f in pairs(acceptedFrames) do
			if button:GetName() == f then
				buttonType = 2
				break
			end
		end
	end

	if not buttonType then
		return
	end

	local valid = false
	for i = 1, #whiteList do
		if strsub(name, 1, strlen(whiteList[i])) == whiteList[i] then
			valid = true
			break
		end
	end

	if strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
		valid = true
		for _, ignoreName in pairs(IgnoreList.libDBIcon) do
			if strsub(name, strlen("LibDBIcon10_") + 1) == ignoreName then
				return
			end
		end
	end

	if not valid and not isValidName(name) then
		return
	end

	-- If the relative frame is Minimap, then replace it to fake Minimap
	-- It must run before FarmHud moving the Minimap
	if C_AddOns_IsAddOnLoaded("FarmHud") then
		if not self:IsHooked(button, "SetPoint") then
			self:RawHook(button, "SetPoint", function(...)
				local relativeTo = select(3, ...)
				if relativeTo and relativeTo == _G.Minimap then
					return
				end
				return self.hooks[button].SetPoint(...)
			end, true)
		end
	end

	-- Pre-skinning
	if name == "DBMMinimapButton" then
		button:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
	elseif name == "SmartBuff_MiniMapButton" then
		button:SetNormalTexture(C_Spell_GetSpellTexture(12051))
	elseif name == "GRM_MinimapButton" then
		button.GRM_MinimapButtonBorder:Hide()
		button:SetPushedTexture("")
		button:SetHighlightTexture("")
		F.InternalizeMethod(button, "SetPushedTexture", true)
		F.InternalizeMethod(button, "SetHighlightTexture", true)
		if button:HasScript("OnEnter") then
			self:SetButtonMouseOver(button, button, true)
			button.OldSetScript = button.SetScript
			button.SetScript = E.noop
		end
	elseif strsub(name, 1, strlen("TomCats-")) == "TomCats-" then
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
		button:GetHighlightTexture():Kill()
	elseif name == "BtWQuestsMinimapButton" and _G.BtWQuestsMinimapButtonIcon then
		for _, region in pairs({ button:GetRegions() }) do
			if region ~= _G.BtWQuestsMinimapButtonIcon then
				region:SetTexture(nil)
				region:SetAlpha(0)
				region:Hide()
			end
		end
	elseif name == "JST_MinimapButton" then
		button.anim:Stop()
		button.anim.Play = E.noop
		button.bg:Kill()
		button.icon:SetAlpha(1)
		button.icon:Show()
		button.icon.Hide = E.noop
		button.icon2:Kill()
		button.timer:SetScript("OnUpdate", nil)
		F.InternalizeMethod(button.timer, "SetScript", true)
	elseif name == "MRPMinimapButton" then
		for _, region in pairs({ button:GetRegions() }) do
			if region:GetTexture() > 0 then
				region:Hide()
			end
		end
	elseif buttonType ~= 2 then
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
		button:SetHighlightTexture("")
	end

	if buttonType ~= 2 then
		button:HookScript("OnClick", self.DelayedUpdateLayout)
	end

	-- Skin the textures
	for _, region in pairs({ button:GetRegions() }) do
		local original = {}
		original.Width, original.Height = button:GetSize()
		original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs = button:GetPoint()
		original.Parent = button:GetParent()
		original.FrameStrata = button:GetFrameStrata()
		original.FrameLevel = button:GetFrameLevel()
		original.Scale = button:GetScale()
		if button:HasScript("OnDragStart") then
			original.DragStart = button:GetScript("OnDragStart")
		end
		if button:HasScript("OnDragStop") then
			original.DragEnd = button:GetScript("OnDragStop")
		end

		button.original = original

		if region:IsObjectType("Texture") then
			local tex = region:GetTexture()

			-- Remove rings and backdrops of LibDBIcon icons
			if tex and strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
				if region ~= button.icon then
					region:SetTexture(nil)
				end
			end

			if
				tex
				and type(tex) ~= "number"
				and (strfind(tex, "Border") or strfind(tex, "Background") or strfind(tex, "AlphaMask"))
			then
				region:SetTexture(nil)
			else
				if name == "BagSync_MinimapButton" then
					region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon")
				end

				if not TexCoordIgnoreList[name] then
					-- Mask cleanup
					if region.GetNumMaskTextures and region.RemoveMaskTexture and region.GetMaskTexture then
						local numMaskTextures = region:GetNumMaskTextures()
						if numMaskTextures and numMaskTextures > 0 then
							for i = 1, numMaskTextures do
								region:RemoveMaskTexture(region:GetMaskTexture(i))
							end
						else
							region:SetMask("")
						end
					elseif region.SetMask then
						region:SetMask("")
					end

					region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end

				region:ClearAllPoints()
				region:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
				region:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
				region:SetDrawLayer("ARTWORK")

				if name == "PS_MinimapButton" then
					region.SetPoint = E.noop
				end
			end
		end
	end

	-- Create the backdrop
	if button.backdrop then
		if name == "LibDBIcon10_Musician" then
			button.backdrop:Kill()
			button.backdrop = nil
		end
	end

	button:CreateBackdrop()
	S:CreateShadowModule(button.backdrop)

	self:SetButtonMouseOver(button, button)

	-- After fix for some buttons
	if name == "Narci_MinimapButton" then
		self:SetButtonMouseOver(button, button.Panel)
		for _, child in pairs({ button.Panel:GetChildren() }) do
			if child.SetScript and not child.Highlight then
				self:SetButtonMouseOver(button, child, true)
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
			_G["TomCats-MinimapButtonIcon"]:SetInside(button.backdrop)
			F.InternalizeMethod(_G["TomCats-MinimapButtonIcon"], "SetPoint", true)
			_G["TomCats-MinimapButtonIcon"]:SetTexCoord(0, 0.65, 0, 0.65)
		end
	end

	if self:HandleLibDBIconButton(button, name) then
		local debugName = button:GetDebugName()
		tinsert(handledButtons, { name = name, debugName = debugName, frame = button })
	end

	button.isSkinned = true
end

function module.DelayedUpdateLayout()
	if module.db.orientation ~= "NOANCHOR" then
		E:Delay(1, module.UpdateLayout, module)
	end
end

function module:GetSortPriorityPatterns()
	local priorityPatterns = {}

	for pattern in gmatch(self.db.sortingPriority, "([^,]+)") do
		pattern = strtrim(pattern)
		if pattern ~= "" then
			tinsert(priorityPatterns, pattern)
		end
	end

	return priorityPatterns
end

function module:SortButtons()
	local numButtons = #handledButtons
	if numButtons <= 1 then
		return
	end

	local priorityPatterns = self:GetSortPriorityPatterns()
	local numPatterns = #priorityPatterns
	local defaultPriority = numPatterns + 1

	-- Pre-compute button metadata for efficient sorting
	local buttonData = {}
	for i = 1, numButtons do
		local button = handledButtons[i]
		local name = button.name or button.debugName or ""
		local priority = defaultPriority

		-- Find highest priority pattern match
		for p = 1, numPatterns do
			if strfind(name, priorityPatterns[p]) then
				priority = p
				break
			end
		end

		buttonData[i] = {
			button = button,
			name = name,
			priority = priority,
			originalIndex = i, -- For stable sort
		}
	end

	-- Single-pass sort: priority first, then alphabetically, then stable by original index
	sort(buttonData, function(a, b)
		if a.priority ~= b.priority then
			return a.priority < b.priority
		end
		if a.name ~= b.name then
			return a.name < b.name
		end
		return a.originalIndex < b.originalIndex -- Stable sort fallback
	end)

	-- Rebuild handledButtons array from sorted data
	for i = 1, numButtons do
		handledButtons[i] = buttonData[i].button
	end

	-- In-place reversal if needed
	if self.db.reverseOrder then
		local halfLen = floor(numButtons / 2)
		for i = 1, halfLen do
			local j = numButtons - i + 1
			handledButtons[i], handledButtons[j] = handledButtons[j], handledButtons[i]
		end
	end
end

function module:PrintAllButtonNames()
	F.PrintGradientLine()
	F.Print(L["Priority Patterns"] .. ":")
	for i, pattern in pairs(self:GetSortPriorityPatterns()) do
		F.Print(i, C.StringByTemplate(gsub(pattern, "\124", "\124\124"), "amber-300"))
	end
	F.Print(L["All handled minimap buttons:"])
	for i, button in pairs(handledButtons) do
		local name = button.name or button.debugName
		name = name and gsub(name, "\124", "\124\124") or format('"" (%s)', C.StringByTemplate(L["no name"], "red-300"))
		F.Print(i, C.StringByTemplate(name, "cyan-300"))
	end
	F.PrintGradientLine()
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

	module:SortButtons()

	local buttonsPerRow = self.db.buttonsPerRow
	local numOfRows = ceil(#handledButtons / buttonsPerRow)
	local spacing = self.db.spacing
	local backdropSpacing = self.db.backdropSpacing
	local buttonSize = self.db.buttonSize
	local direction = not self.db.inverseDirection

	local buttonX, buttonY, anchor, offsetX, offsetY

	for i, handledButton in pairs(handledButtons) do
		local frame = handledButton.frame
		F.CallMethod(frame, "ClearAllPoints")

		if self.db.orientation == "NOANCHOR" then
			local original = frame.original
			F.CallMethod(frame, "SetParent", original.Parent)
			if original.DragStart then
				F.CallMethod(frame, "SetScript", "OnDragStart", original.DragStart)
			end
			if original.DragEnd then
				F.CallMethod(frame, "SetScript", "OnDragStop", original.DragEnd)
			end

			F.CallMethod(frame, "SetSize", original.Width, original.Height)

			if original.Point ~= nil then
				F.CallMethod(
					frame,
					"SetPoint",
					original.Point,
					original.relativeTo,
					original.relativePoint,
					original.xOfs,
					original.yOfs
				)
			else
				F.CallMethod(frame, "SetPoint", "CENTER", _G.Minimap, "CENTER", -80, -34)
			end

			F.CallMethod(frame, "SetFrameStrata", original.FrameStrata)
			F.CallMethod(frame, "SetFrameLevel", original.FrameLevel)
			F.CallMethod(frame, "SetMovable", true)
			F.CallMethod(frame, "SetScale", original.Scale)
		else
			buttonX = i % buttonsPerRow
			buttonY = floor(i / buttonsPerRow) + 1

			if buttonX == 0 then
				buttonX = buttonsPerRow
				buttonY = buttonY - 1
			end

			F.CallMethod(frame, "SetParent", self.bar)
			F.CallMethod(frame, "SetFrameStrata", "LOW")
			F.CallMethod(frame, "SetFrameLevel", 20)
			F.CallMethod(frame, "SetMovable", false)
			F.CallMethod(frame, "SetScript", "OnDragStart", nil)
			F.CallMethod(frame, "SetScript", "OnDragStop", nil)

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

			F.CallMethod(frame, "SetSize", buttonSize, buttonSize)
			F.CallMethod(frame, "SetPoint", anchor, self.bar, anchor, offsetX, offsetY)
		end

		if E.private.mui.skins.enable and E.private.mui.skins.shadow.enable and frame.backdrop.MERshadow then
			frame.backdrop.MERshadow:SetShown(not self.db.backdrop)
		end
	end

	buttonsPerRow = min(buttonsPerRow, #handledButtons)

	if self.db.orientation ~= "NOANCHOR" and #handledButtons > 0 then
		local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow - 1) + backdropSpacing * 2
		local height = buttonSize * numOfRows + spacing * (numOfRows - 1) + backdropSpacing * 2

		if self.db.orientation == "VERTICAL" then
			width, height = height, width
		end

		self.bar:Size(width, height)
		self.barAnchor:Size(width, height)
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

	self.bar:Point(anchor, self.barAnchor, anchor, 0, 0)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function module:SkinMinimapButtons()
	self:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for _, child in pairs({ _G.Minimap:GetChildren() }) do
		self:SkinButton(child)
	end

	self:UpdateLayout()
end

function module:UpdateMouseOverConfig()
	if self.db.mouseOver then
		self.bar:SetScript("OnEnter", function(bar)
			E:UIFrameFadeIn(bar, (1 - bar:GetAlpha()) * 0.382, bar:GetAlpha(), 1)
		end)

		self.bar:SetScript("OnLeave", function(bar)
			E:UIFrameFadeOut(bar, bar:GetAlpha() * 0.382, bar:GetAlpha(), 0)
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
	frame:Point("TOPRIGHT", MM.MapHolder, "BOTTOMRIGHT", 0, -5)
	frame:SetFrameStrata("BACKGROUND")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:Point("CENTER", self.barAnchor, "CENTER", 0, 0)
	self.bar = frame

	self:SkinMinimapButtons()
	S:CreateShadowModule(self.bar.backdrop)

	E:CreateMover(
		self.barAnchor,
		"MER_MinimapButtonBarAnchor",
		MER.Title .. L["Minimap Buttons Bar"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		function()
			return E.db.mui.smb.enable
		end,
		"mui,modules,maps,smb"
	)
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
	if C_AddOns_IsAddOnLoaded("BasicMinimap") then
		self.StopRunning = "BasicMinimap"
		return
	end

	self.db = E.db.mui.smb
	if not self.db.enable then
		return
	end

	self:CreateFrames()
	self:UpdateMouseOverConfig()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	MER:AddCommand("minimapbuttons", "MERmmb", function(arg)
		if arg == "all" then
			module:PrintAllButtonNames()
		else
			F.Print(L["Updated minimap buttons layout."])
			module:UpdateLayout()
		end
	end)
end

module:RawHook(MM, "HandleExpansionButton")
MER:RegisterModule(module:GetName())

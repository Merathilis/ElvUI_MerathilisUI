local MAJOR, MINOR = "LibElv-UIButtons-1.0", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end
local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")

--GLOBALS: CreateFrame
local _G = _G
local pairs, type, tinsert = pairs, type, tinsert
local UnitName = UnitName
local GameTooltip = GameTooltip
local GetAddOnEnableState = GetAddOnEnableState

--Upon creation menu.db does not account for values missing in E.db = being default.
--We are using this to fix it.
local function EqualizeDB(db, default)
	for key, value in pairs(default) do
		if not db[key] and type(default[key]) ~= "table" then
			db[key] = default[key]
		elseif type(default[key]) == "table" then
			EqualizeDB(db[key], default[key])
		end
	end
end

--Sets the size of menu's mover
local function MoverSize(menu)
	local db = menu.db
	if db.orientation == "vertical" then
		menu:SetWidth(db.size + 2 + E.Spacing*2)
		menu:SetHeight((db.size*menu.NumBut)+((db.spacing + E.Spacing*2)*(menu.NumBut-1))+2)
	elseif db.orientation == "horizontal" then
		menu:SetWidth((db.size*menu.NumBut)+((db.spacing + E.Spacing*2)*(menu.NumBut-1))+2)
		menu:SetHeight(db.size + 2 + E.Spacing*2)
	end
end

--Creates a mover for the menu
local function SetupMover(menu, name, own)
	local exist = false
	for i = 1, #E.ConfigModeLayouts do
		if E.ConfigModeLayouts[i] == "UIButtons" then
			exist = true
			break
		end
	end
	if not exist then --Create a new config group for movers
		tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "UIButtons")
		E.ConfigModeLocalizedStrings["UIButtons"] = L["UI Buttons"]
	end
	E:CreateMover(menu, menu:GetName().."Mover", name, nil, nil, nil, own and own..",UIButtons" or "ALL,UIButtons")
end

--A function to toggle dropdown categories to show/hide then on button click
local function ToggleCats(menu)
	for i = 1, #menu.ToggleTable do
		if menu.ToggleTable[i].opened then
			menu.HoldersTable[i]:Show()
		else
			menu.HoldersTable[i]:Hide()
		end
	end
end

local function OnEnter(menu)
	menu:SetAlpha(1)
end

local function OnLeave(menu)
	if menu.db.mouse then
		menu:SetAlpha(0)
	end
end

--Creating main buttons to execute stuff in classic mode and toggle categories n dropdown
local function CreateCoreButton(menu, name, text, onClick)
	if _G[menu:GetName().."_Core_"..name] then return end
	local button, holder
	if menu.style == "classic" then
		menu[name] = CreateFrame("Button", menu:GetName().."_Core_"..name, menu)
		button = menu[name]
		if onClick then
			button:SetScript("OnClick", onClick)
		end
	elseif menu.style == "dropdown" then
		menu[name] = CreateFrame("Frame", menu:GetName().."_Core_"..name, menu)
		menu[name].Toggle = CreateFrame("Button", menu:GetName().."_Core_"..name.."Toggle", menu)
		holder = menu[name]
		holder.width = 0
		holder:CreateBackdrop("Transparent")
		button = menu[name].Toggle
		if not menu[name.."Table"] then
			menu[name.."Table"] = {}
		end
		menu:ToggleSetup(button, holder)
		tinsert(menu.HoldersTable, holder)
		tinsert(menu.GroupsTable, name)
	else
		lib:CustomStyleCoreButton(menu, name, text)
	end
	button:SetScript('OnEnter', function(self) menu:OnEnter() end)
	button:SetScript('OnLeave', function(self) menu:OnLeave() end)
	-- button:SetSize(17, 17) --For testing purposes
	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetPoint("CENTER", button, "CENTER", 0, 0)

	if menu.transparent == "Transparent" then
		button:CreateBackdrop("Transparent")
	elseif menu.transparent == "Default" then
		S:HandleButton(button)
	end

	if text then
		local t = button:CreateFontString(nil,"OVERLAY",button)
		t:FontTemplate()
		t:SetPoint("CENTER", button, 'CENTER', 0, -1)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		button:SetFontString(t)
	end

	tinsert(menu.ToggleTable, button)

	menu.NumBut = menu.NumBut + 1
end

--Creating buttons to populate dropdowns
local function CreateDropdownButton(menu, core, name, text, tooltip1, tooltip2, click, addon, always)
	if addon then --Check if addon specified as dependancy is enabled to load (not loaded cause it can start to load way after our code is executed)
		local enabled = GetAddOnEnableState(menu.myname, addon)
		if enabled == 0 then return end
	end
	if _G[menu:GetName().."_Core_"..core..name] or not menu[core.."Table"] then return end
	menu[core][name] = CreateFrame("Button", menu:GetName().."_Core_"..core..name, menu[core])
	local b = menu[core][name]
	local toggle = menu[core].Toggle

	b:SetScript("OnClick", function(self)
		click()
		toggle.opened = false
		menu:ToggleCats()
	end)

	if tooltip1 then
		b:SetScript("OnEnter", function(self)
			menu:OnEnter()
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine(tooltip1, 1, .96, .41, .6, .6, 1)
			if tooltip2 then GameTooltip:AddLine(tooltip2, 1, 1, 1, 1, 1, 1) end
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function(self)
			menu:OnLeave()
			GameTooltip:Hide() 
		end)
	else
		b:SetScript('OnEnter', function(self) menu:OnEnter() end)
		b:SetScript('OnLeave', function(self) menu:OnLeave() end)
	end
	if menu.transparent == "Transparent" then
		b:CreateBackdrop("Transparent")
	elseif menu.transparent == "Default" then
		S:HandleButton(b)
	end

	if text and type(text) == "string" then
		b.text = b:CreateFontString(nil,"OVERLAY",b)
		b.text:FontTemplate()
		b.text:SetPoint("CENTER", b, 'CENTER', 0, -1)
		b.text:SetJustifyH("CENTER")
		b.text:SetText(text)
		b:SetFontString(b.text)
	end

	tinsert(menu[core.."Table"], b)
end

--Creating separator frame
local function CreateSeparator(menu, core, name, size, space)
	if _G[menu:GetName().."_Core_"..core..name.."_Separator"] or not menu[core.."Table"] then return end
	menu[core][name] = CreateFrame("Frame", menu:GetName().."_Core_"..core..name.."_Separator", menu[core])
	local f = menu[core][name]
	f.isSeparator = true
	f.size = size or 1
	f.space = space or 2
	f:CreateBackdrop("Transparent")
	f:SetScript('OnEnter', function(self) menu:OnEnter() end)
	f:SetScript('OnLeave', function(self) menu:OnLeave() end)
	tinsert(menu[core.."Table"], f)
end

--Setup for core buttons in dropdown mode to act like toggles
local function ToggleSetup(menu, button, holder)
	local db = menu.db
	button.opened = false
	holder:Hide()
	button:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" then
			if self.opened then
				self.opened = false
			else
				self.opened = true
				for i = 1, #menu.ToggleTable do
					if menu.ToggleTable[i] ~= self then menu.ToggleTable[i].opened = false end
				end
			end
			menu:ToggleCats()
		end
	end)
	holder:SetScript('OnEnter', function(self) menu:OnEnter() end)
	holder:SetScript('OnLeave', function(self) menu:OnLeave() end)
end

--Updating the positioning and order of dropdown category
local function UpdateDropdownLayout(menu, group)
	local count = -1
	local sepS, sepC = 0, 0
	local header = menu[group]
	local db = menu.db
	header:ClearAllPoints()
	header:Point(db.point, header.Toggle, db.anchor, db.xoffset, db.yoffset)
	local T = menu[group.."Table"]
	for i = 1, #T do
		local button, prev, next = T[i], T[i-1], T[i+1]
		local y_offset = prev and (-(db.spacing + E.Spacing*2) - (prev.isSeparator and prev.space or 0) - (button.isSeparator and button.space or 0)) or 0
		button:Point("TOP", (prev or header), (prev and "BOTTOM" or "TOP"), 0, y_offset)
		count = button.isSeparator and count or count + 1
		sepS = (button.isSeparator and sepS + ((prev and 2 or 1)*button.space + button.size)) or sepS
		sepC = button.isSeparator and sepC + 1 or sepC
	end
	header:Size(header.width, (db.size * (count+1))+(db.spacing*(count))+sepS+(.5*sepC))
	if menu.db.dropdownBackdrop then
		header.backdrop:Show()
	else
		header.backdrop:Hide()
	end
end

local function UpdateMouseOverSetting(menu)
	if menu.db.mouse then
		menu:SetAlpha(0)
	else
		menu:SetAlpha(1)
	end
end

--Updating positions of the menu
local function Positioning(menu)
	local db = menu.db

	--position check
	local header = menu
	if db.orientation == "vertical" then
		for i = 1, #menu.ToggleTable do
			local button, prev = menu.ToggleTable[i], menu.ToggleTable[i-1]
			menu.ToggleTable[i]:ClearAllPoints()
			menu.ToggleTable[i]:Point("TOP", (prev or header), prev and "BOTTOM" or "TOP", 0, prev and -(db.spacing + E.Spacing*2) or -(1 + E.Spacing))
		end
	elseif db.orientation == "horizontal" then
		for i = 1, #menu.ToggleTable do
			local button, prev = menu.ToggleTable[i], menu.ToggleTable[i-1]
			menu.ToggleTable[i]:ClearAllPoints()
			menu.ToggleTable[i]:Point("LEFT", (prev or header), prev and "RIGHT" or "LEFT", prev and (db.spacing + E.Spacing*2) or (1 + E.Spacing), 0)
		end
	end
	--Calling for dropdown updates
	if menu.style == "dropdown" then
		for i = 1, #menu.GroupsTable do
			menu:UpdateDropdownLayout(menu.GroupsTable[i])
		end
	end
end

--Resizing frames. Need to run after a new button was created to let the menu know it exist
local function FrameSize(menu)
	local db = menu.db
	if not db.size then return end
	menu:MoverSize()

	for i = 1, #menu.ToggleTable do
		menu.ToggleTable[i]:Size(db.size)
	end

	if menu.style == "dropdown" then
		for i = 1, #menu.GroupsTable do
			local group = menu.GroupsTable[i]
			local mass = menu[group.."Table"]
			for w = 1, #mass do
				if mass[w].text and mass[w].text:GetWidth() > menu.HoldersTable[i].width and not menu.fixedDropdownWidth then
					menu.HoldersTable[i].width = mass[w].text:GetWidth() + 10
				elseif menu.fixedDropdownWidth then
					menu.HoldersTable[i].width = menu.fixedDropdownWidth
					if mass[w].text and mass[w].text:GetWidth() >  menu.fixedDropdownWidth then
						mass[w].text:SetWidth(menu.fixedDropdownWidth - 10)
						mass[w].text:SetWordWrap(false)
					end
				end
			end
			for n = 1, #mass do
				if mass[n].isSeparator then
					mass[n]:Size(menu.HoldersTable[i].width - 2, mass[n].size)
				else
					mass[n]:Size(menu.HoldersTable[i].width, db.size)
				end
			end
		end
	end

	menu:Positioning()
end

local function UpdateBackdrop(menu)
	if menu.db.menuBackdrop then
		menu.backdrop:Show()
	else
		menu.backdrop:Hide()
	end
end

--Enable/disable call
local function ToggleShow(menu)
	if not menu.db.enable then
		menu:Hide()
		E:DisableMover(menu.mover:GetName())
		UnregisterStateDriver(menu, "visibility")
	else
		menu:Show()
		menu:UpdateMouseOverSetting()
		menu:UpdateBackdrop()
		E:EnableMover(menu.mover:GetName())
		if menu.db.visibility then RegisterStateDriver(menu, "visibility", menu.db.visibility) end
	end
end

--Creating of the menu
function lib:CreateFrame(name, db, default, style, styleDefault, strata, level, transparent)
	--Checks to prevent a shitload of errors cause of wrong arguments passed
	if _G[name] then return end
	if not strata then strata = "MEDIUM" end
	local menu = CreateFrame("Frame", name, E.UIParent)
	menu.db = db --making menu db table so we can actually keep unified settings calls in other functions
	menu.default = default --same for defaults
	EqualizeDB(menu.db, menu.default)
	if not style and styleDefault then style = styleDefault end
	menu.style = style
	menu.transparent = transparent

	menu:SetFrameStrata(strata)
	menu:SetFrameLevel(level or 5)
	menu:SetClampedToScreen(true)
	menu:Point("LEFT", E.UIParent, "LEFT", -2, 0);
	menu:Size(17, 17); --Cause the damn thing doesn't want to show up without default size lol
	menu.myname = UnitName('player') --used in checks for addon deps
	menu:CreateBackdrop()

	menu.NumBut = 0
	menu.ToggleTable = {}
	menu.HoldersTable = {}
	menu.GroupsTable = {}

	--Setting API
	menu.CreateCoreButton = CreateCoreButton
	menu.CreateDropdownButton = CreateDropdownButton
	menu.CreateSeparator = CreateSeparator
	menu.ToggleSetup = ToggleSetup
	menu.ToggleCats = ToggleCats
	menu.UpdateDropdownLayout = UpdateDropdownLayout
	menu.Positioning = Positioning
	menu.MoverSize = MoverSize
	menu.UpdateMouseOverSetting = UpdateMouseOverSetting
	menu.FrameSize = FrameSize
	menu.SetupMover = SetupMover
	menu.ToggleShow = ToggleShow
	menu.UpdateBackdrop = UpdateBackdrop
	menu.OnEnter = OnEnter
	menu.OnLeave = OnLeave


	menu:SetScript('OnEnter', function(self) menu:OnEnter() end)
	menu:SetScript('OnLeave', function(self) menu:OnLeave() end)

	return menu
end

--Default options table structure
local function GenerateTable(menu, coreGroup, groupName, groupTitle)
	local positionValues = {
		TOPLEFT = 'TOPLEFT',
		LEFT = 'LEFT',
		BOTTOMLEFT = 'BOTTOMLEFT',
		RIGHT = 'RIGHT',
		TOPRIGHT = 'TOPRIGHT',
		BOTTOMRIGHT = 'BOTTOMRIGHT',
		CENTER = 'CENTER',
		TOP = 'TOP',
		BOTTOM = 'BOTTOM',
	};

	local isDefault = coreGroup == true and true or false
	if isDefault and not E.Options.args.uibuttons then
		E.Options.args.uibuttons = {
			type = "group",
			name = L["UI Buttons"],
			order = 77,
			childGroups = 'select',
			args = {
			},
		}
		coreGroup = E.Options.args.uibuttons
	end
	coreGroup.args[groupName] = {
		type = "group",
		name = groupTitle,
		order = 1,
		args = {
			header = {
				order = 1,
				type = "header",
				name = groupTitle,
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				desc = L["Show/Hide UI buttons."],
				get = function(info) return menu.db.enable end,
				set = function(info, value) menu.db.enable = value; menu:ToggleShow() end
			},
			style = {
				order = 4,
				name = L["UI Buttons Style"],
				type = "select",
				values = {
					["classic"] = L["Classic"],
					["dropdown"] = L["Dropdown"],
				},
				disabled = function() return not menu.db.enable end,
				get = function(info) return E.private.sle.uiButtonStyle end,
				set = function(info, value) E.private.sle.uiButtonStyle = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			space = {
				order = 5,
				type = 'description',
				name = "",
			},
			size = {
				order = 6,
				type = "range",
				name = L["Size"],
				desc = L["Sets size of buttons"],
				min = 12, max = 25, step = 1,
				disabled = function() return not menu.db.enable end,
				get = function(info) return menu.db.size end,
				set = function(info, value) menu.db.size = value; menu:FrameSize() end,
			},
			spacing = {
				order = 7,
				type = "range",
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = 1, max = 10, step = 1,
				disabled = function() return not menu.db.enable end,
				get = function(info) return menu.db.spacing end,
				set = function(info, value) menu.db.spacing = value; menu:FrameSize() end,
			},
			mouse = {
				order = 8,
				type = "toggle",
				name = L["Mouse Over"],
				desc = L["Show on mouse over."],
				disabled = function() return not menu.db.enable end,
				get = function(info) return menu.db.mouse end,
				set = function(info, value) menu.db.mouse = value; menu:UpdateMouseOverSetting() end
			},
			menuBackdrop = {
				order = 9,
				type = "toggle",
				name = L["Backdrop"],
				disabled = function() return not menu.db.enable end,
				get = function(info) return menu.db.menuBackdrop end,
				set = function(info, value) menu.db.menuBackdrop = value; menu:UpdateBackdrop() end
			},
			dropdownBackdrop = {
				order = 10,
				type = "toggle",
				name = L["Dropdown Backdrop"],
				disabled = function() return not menu.db.enable or E.private.sle.uiButtonStyle == "classic" end,
				get = function(info) return menu.db.dropdownBackdrop end,
				set = function(info, value) menu.db.dropdownBackdrop = value; menu:FrameSize() end
			},
			orientation = {
				order = 11,
				name = L["Buttons position"],
				desc = L["Layout for UI buttons."],
				type = "select",
				values = {
					["horizontal"] = L["Horizontal"],
					["vertical"] = L["Vertical"],
				},
				disabled = function() return not menu.db.enable end,
				get = function(info) return menu.db.orientation end,
				set = function(info, value) menu.db.orientation = value; menu:FrameSize() end,
			},
			point = {
				type = 'select',
				order = 13,
				name = L["Anchor Point"],
				desc = L["What point of dropdown will be attached to the toggle button."],
				disabled = function() return not menu.db.enable or E.private.sle.uiButtonStyle == "classic" end,
				get = function(info) return menu.db.point end,
				set = function(info, value) menu.db.point = value; menu:FrameSize() end,
				values = positionValues,
			},
			anchor = {
				type = 'select',
				order = 14,
				name = L["Attach To"],
				desc = L["What point to anchor dropdown on the toggle button."],
				disabled = function() return not menu.db.enable or E.private.sle.uiButtonStyle == "classic" end,
				get = function(info) return menu.db.anchor end,
				set = function(info, value) menu.db.anchor = value; menu:FrameSize() end,
				values = positionValues,
			},
			xoffset = {
				order = 15,
				type = "range",
				name = L["X-Offset"],
				desc = L["Horizontal offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not menu.db.enable or E.private.sle.uiButtonStyle == "classic" end,
				get = function(info) return menu.db.xoffset end,
				set = function(info, value) menu.db.xoffset = value; menu:FrameSize() end,
			},
			yoffset = {
				order = 16,
				type = "range",
				name = L["Y-Offset"],
				desc = L["Vertical offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not menu.db.enable or E.private.sle.uiButtonStyle == "classic" end,
				get = function(info) return menu.db.yoffset end,
				set = function(info, value) menu.db.yoffset = value; menu:FrameSize() end,
			},
		},
	}
end

function lib:CreateOptions(menu, default, groupName, groupTitle)
	menu:RegisterEvent("ADDON_LOADED")
	menu:SetScript("OnEvent", function(self, event, addon) 
		if addon ~= "ElvUI_Config" then return end
		self:UnregisterEvent("ADDON_LOADED")
		GenerateTable(self, default, groupName, groupTitle)
	end)
end

--This function is for creating own menu style. Replacing is not encouraged, hooking recommended.
function lib:CustomStyleCoreButton(menu, name, text)
end

if not LibStub("LibElvUIPlugin-1.0").plugins[MAJOR] then
	LibStub("LibElvUIPlugin-1.0"):RegisterPlugin(MAJOR, function() end, true)
end
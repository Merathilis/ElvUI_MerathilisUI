local MER, F, E, L, V, P, G = unpack(select(2, ...))
local RM = MER:GetModule('MER_RaidMarkers')

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
local format = string.format
-- WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--GLOBALS: CreateFrame

RM.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

local layouts = {
	[1] = {RT = 1, WM = 5}, -- Star
	[2] = {RT = 2, WM = 6}, -- Circle
	[3] = {RT = 3, WM = 3}, -- Diamond
	[4] = {RT = 4, WM = 2}, -- Triangle
	[5] = {RT = 5, WM = 7}, -- Moon
	[6] = {RT = 6, WM = 1}, -- Square
	[7] = {RT = 7, WM = 4}, -- Cross
	[8] = {RT = 8, WM = 8}, -- Skull
	[9] = {RT = 0, WM = 0}, -- clear target/worldmarker
}

function RM:Make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

function RM:Bar_OnEnter()
	RM.frame:SetAlpha(1)
end

function RM:Bar_OnLeave()
	if RM.db.mouseover then RM.frame:SetAlpha(0) end
end

function RM:CreateButton(index)
	local info = layouts[index]
	local target, worldmarker = info.RT, info.WM
	local button = CreateFrame("Button", format("RaidMarkerBarButton%d", index), RM.frame, "SecureActionButtonTemplate")
	button:SetHeight(E.db.mui.raidmarkers.buttonSize)
	button:SetWidth(E.db.mui.raidmarkers.buttonSize)
	button:EnableMouse("true")
	button:CreateBackdrop('Transparent')

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:Point('TOPLEFT', button, 'TOPLEFT', 2, -2)
	button.icon:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
	button.icon:SetTexture(index == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", index))

	if target then
		button:SetAttribute("type1", "macro")
		button:SetAttribute("macrotext1", format("/tm %d", index == 9 and 0 or index))
	end

	button:RegisterForClicks("AnyDown")

	return button
end

function RM:UpdateWorldMarkersAndTooltips()
	for index = 1, 9 do
		local target, worldmarker = layouts[index].RT, layouts[index].WM
		local button = self.frame.buttons[index]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				self.backdrop:SetBackdropBorderColor(.7, .7, 0)
				if E.db.mui.raidmarkers.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(index == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = E.db.mui.raidmarkers.modifier or "shift-"
			button:SetAttribute(format("%stype1", modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(format("%smacrotext1", modifier), worldmarker == 0 and "/cwm all" or format("/cwm %d\n/wm %d", worldmarker, worldmarker))

			button:SetScript("OnEnter", function(self)
				self.backdrop:SetBackdropBorderColor(.7, .7, 0)
				if E.db.mui.raidmarkers.notooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(index == 9 and format("%s\n%s", L["Click to clear the mark."], format(L["%sClick to remove all worldmarkers."], button.modifier:upper()))
					or format("%s\n%s", L["Click to mark the target."], format(L["%sClick to place a worldmarker."], button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)
		end

		button:SetScript("OnLeave", function(self)
			self.backdrop:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide()
			if RM.db.mouseover then
				RM.frame:SetAlpha(0)
			end
		end)
	end
end

function RM:UpdateBar(update)
	local height, width

	if E.db.mui.raidmarkers.orientation == "VERTICAL" then
		width = E.db.mui.raidmarkers.buttonSize + 4
		height = (E.db.mui.raidmarkers.buttonSize * 9) + (E.db.mui.raidmarkers.spacing * 8) + 4
	else
		width = (E.db.mui.raidmarkers.buttonSize * 9) + (E.db.mui.raidmarkers.spacing * 8) + 4
		height = E.db.mui.raidmarkers.buttonSize + 4
	end

	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
	local head, tail
	for index = 9, 1, -1 do
		local button = self.frame.buttons[index]
		local prev = self.frame.buttons[index + 1]
		button:ClearAllPoints()

		button:SetWidth(E.db.mui.raidmarkers.buttonSize)
		button:SetHeight(E.db.mui.raidmarkers.buttonSize)

		if E.db.mui.raidmarkers.orientation == "VERTICAL" then
			head = E.db.mui.raidmarkers.reverse and "BOTTOM" or "TOP"
			tail = E.db.mui.raidmarkers.reverse and "TOP" or "BOTTOM"
			if index == 9 then
				button:SetPoint(head, 0, (E.db.mui.raidmarkers.reverse and 2 or -2))
			else
				button:SetPoint(head, prev, tail, 0, E.db.mui.raidmarkers.spacing*(E.db.mui.raidmarkers.reverse and 1 or -1))
			end
		else
			head = E.db.mui.raidmarkers.reverse and "RIGHT" or "LEFT"
			tail = E.db.mui.raidmarkers.reverse and "LEFT" or "RIGHT"
			if index == 9 then
				button:SetPoint(head, (E.db.mui.raidmarkers.reverse and -2 or 2), 0)
			else
				button:SetPoint(head, prev, tail, E.db.mui.raidmarkers.spacing*(E.db.mui.raidmarkers.reverse and -1 or 1), 0)
			end
		end
	end

	if E.db.mui.raidmarkers.enable then self.frame:Show() else self.frame:Hide() end
end

function RM:Visibility()
	local db = E.db.mui.raidmarkers
	if db.enable then
		RegisterStateDriver(self.frame, "visibility", db.visibility == "CUSTOM" and db.customVisibility or RM.VisibilityStates[db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RM:UpdateMouseover()
	RM:Bar_OnEnter()
	RM:Bar_OnLeave()
end

function RM:Backdrop()
	if E.db.mui.raidmarkers.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end
end

function RM:Initialize()
	RM.db = E.db.mui.raidmarkers
	MER:RegisterDB(RM, "raidmarkers")

	RM:Make("mUI_RaidFlare1", "/clearworldmarker 1\n/worldmarker 1", "Blue Flare")
	RM:Make("mUI_RaidFlare2", "/clearworldmarker 2\n/worldmarker 2", "Green Flare")
	RM:Make("mUI_RaidFlare3", "/clearworldmarker 3\n/worldmarker 3", "Purple Flare")
	RM:Make("mUI_RaidFlare4", "/clearworldmarker 4\n/worldmarker 4", "Red Flare")
	RM:Make("mUI_RaidFlare5", "/clearworldmarker 5\n/worldmarker 5", "Yellow Flare")
	RM:Make("mUI_RaidFlare6", "/clearworldmarker 6\n/worldmarker 6", "Orange Flare")
	RM:Make("mUI_RaidFlare7", "/clearworldmarker 7\n/worldmarker 7", "White Flare")
	RM:Make("mUI_RaidFlare8", "/clearworldmarker 8\n/worldmarker 8", "Skull Flare")

	RM:Make("mUI_ClearRaidFlares", "/clearworldmarker 0", "Clear All Flares")

	self.frame = CreateFrame("Frame", "mui_RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate, BackdropTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 225)
	self.frame.buttons = {}

	self:HookScript(self.frame, 'OnEnter', 'Bar_OnEnter')
	self:HookScript(self.frame, 'OnLeave', 'Bar_OnLeave')

	for index = 1, 9 do
		self.frame.buttons[index] = RM:CreateButton(index)
	end

	self.frame.backdrop:SetAllPoints()
	self:UpdateWorldMarkersAndTooltips()

	E:CreateMover(self.frame, "MER_RaidMarkerBarAnchor", L["Raid Marker Bar"], nil, nil, nil, "ALL,PARTY,RAID,MERATHILISUI", nil, 'mui,modules,raidmarkers')

	function RM:ForUpdateAll()
		local db = E.db.mui.raidmarkers
		self:Visibility()
		self:Backdrop()
		--self:UpdateWorldMarkersAndTooltips()
		self:UpdateBar()
		self:UpdateMouseover()
	end

	self:ForUpdateAll()
end

MER:RegisterModule(RM:GetName())

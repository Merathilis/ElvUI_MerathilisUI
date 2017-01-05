local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local RMA = E:NewModule("RaidMarkers");

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs = ipairs
local format = string.format
-- WoW API / Variables
local GameTooltip = GameTooltip
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

--GLOBALS: CreateFrame

RMA.VisibilityStates = {
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

function RMA:Make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

function RMA:CreateButtons()
	for k, layout in ipairs(layouts) do
		local button = CreateFrame("Button", format("RaidMarkerBarButton%d", k), RMA.frame, "SecureActionButtonTemplate")
		button:SetHeight(E.db.mui.raidmarkers.buttonSize)
		button:SetWidth(E.db.mui.raidmarkers.buttonSize)
		button:SetTemplate('Transparent')

		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()
		image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", k))

		local target, worldmarker = layout.RT, layout.WM

		if target then
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", format("/tm %d", k == 9 and 0 or k))
		end

		button:RegisterForClicks("AnyDown")
		self.frame.buttons[k] = button
	end
end

function RMA:UpdateWorldMarkersAndTooltips()
	for i = 1, 9 do
		local target, worldmarker = layouts[i].RT, layouts[i].WM
		local button = self.frame.buttons[i]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = E.db.mui.raidmarkers.modifier or "shift-"
			button:SetAttribute(format("%stype1", modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(format("%smacrotext1", modifier), worldmarker == 0 and "/cwm all" or format("/cwm %d\n/wm %d", worldmarker, worldmarker))

			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and format("%s\n%s", L["Click to clear the mark."], format(L["%sClick to remove all worldmarkers."], button.modifier:upper()))
					or format("%s\n%s", L["Click to mark the target."], format(L["%sClick to place a worldmarker."], button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)
		end

		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide() 
		end)
	end
end

function RMA:UpdateBar(update)
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
	for i = 9, 1, -1 do
		local button = self.frame.buttons[i]
		local prev = self.frame.buttons[i + 1]
		button:ClearAllPoints()

		button:SetWidth(E.db.mui.raidmarkers.buttonSize)
		button:SetHeight(E.db.mui.raidmarkers.buttonSize)
		
		if E.db.mui.raidmarkers.orientation == "VERTICAL" then
			head = E.db.mui.raidmarkers.reverse and "BOTTOM" or "TOP"
			tail = E.db.mui.raidmarkers.reverse and "TOP" or "BOTTOM"
			if i == 9 then
				button:SetPoint(head, 0, (E.db.mui.raidmarkers.reverse and 2 or -2))
			else
				button:SetPoint(head, prev, tail, 0, E.db.mui.raidmarkers.spacing*(E.db.mui.raidmarkers.reverse and 1 or -1))
			end
		else
			head = E.db.mui.raidmarkers.reverse and "RIGHT" or "LEFT"
			tail = E.db.mui.raidmarkers.reverse and "LEFT" or "RIGHT"
			if i == 9 then
				button:SetPoint(head, (E.db.mui.raidmarkers.reverse and -2 or 2), 0)
			else
				button:SetPoint(head, prev, tail, E.db.mui.raidmarkers.spacing*(E.db.mui.raidmarkers.reverse and -1 or 1), 0)
			end
		end
	end

	if E.db.mui.raidmarkers.enable then self.frame:Show() else self.frame:Hide() end
end

function RMA:Visibility()
	local db = E.db.mui.raidmarkers
	if db.enable then
		RegisterStateDriver(self.frame, "visibility", db.visibility == 'CUSTOM' and db.customVisibility or RMA.VisibilityStates[db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RMA:Backdrop()
	if E.db.mui.raidmarkers.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end
end

function RMA:Initialize()

	RMA:Make("mUI_RaidFlare1", "/clearworldmarker 1\n/worldmarker 1", "Blue Flare")
	RMA:Make("mUI_RaidFlare2", "/clearworldmarker 2\n/worldmarker 2", "Green Flare")
	RMA:Make("mUI_RaidFlare3", "/clearworldmarker 3\n/worldmarker 3", "Purple Flare")
	RMA:Make("mUI_RaidFlare4", "/clearworldmarker 4\n/worldmarker 4", "Red Flare")
	RMA:Make("mUI_RaidFlare5", "/clearworldmarker 5\n/worldmarker 5", "Yellow Flare")
	RMA:Make("mUI_RaidFlare6", "/clearworldmarker 6\n/worldmarker 6", "Orange Flare")
	RMA:Make("mUI_RaidFlare7", "/clearworldmarker 7\n/worldmarker 7", "White Flare")
	RMA:Make("mUI_RaidFlare8", "/clearworldmarker 8\n/worldmarker 8", "Skull Flare")

	RMA:Make("mUI_ClearRaidFlares", "/clearworldmarker 0", "Clear All Flares")

	self.frame = CreateFrame("Frame", "mui_RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 164)
	self.frame.buttons = {}

	self.frame.backdrop:SetAllPoints()

	E:CreateMover(self.frame, "mUI_RaidMarkerBarAnchor", L["Raid Marker Bar"], nil, nil, nil, "ALL,PARTY,RAID")

	self:CreateButtons()

	function RMA:ForUpdateAll()
		RMA.db = E.db.mui.quests
		self:Visibility()
		self:Backdrop()
		self:UpdateBar()
		self:UpdateWorldMarkersAndTooltips()
	end

	self:ForUpdateAll()
end

E:RegisterModule(RMA:GetName())
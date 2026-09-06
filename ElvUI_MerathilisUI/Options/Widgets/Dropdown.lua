local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERDropdown"
local Version = 1

local pairs, ipairs, select, type, tostring, tonumber = pairs, ipairs, select, type, tostring, tonumber
local tsort = table.sort
local CreateFrame, UIParent = CreateFrame, UIParent
local error, unpack = error, unpack

-- Same box thickness/offset as MERSlider's track (18px from the frame's top,
-- 16px tall, 40px total frame height) so a select option sitting in the same
-- AceConfig row as a range option lines up without any Blizzard-template
-- offset math - both widgets just agree on the same numbers up front.
local BOX_HEIGHT = 16
local BOX_TOP_OFFSET = 18
local LABEL_HEIGHT = 16
local FRAME_HEIGHT = 40

local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { 0.22, 0.22, 0.22, 1 }
local COLOR_ARROW = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1 }
local COLOR_ARROW_DISABLED = { 0.55, 0.55, 0.55, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

local function Fixlevels(parent, ...)
	local i = 1
	local child = select(i, ...)
	while child do
		child:SetFrameLevel(parent:GetFrameLevel() + 1)
		Fixlevels(child, child:GetChildren())
		i = i + 1
		child = select(i, ...)
	end
end

local function UpdateVisual(self)
	local box = self.box
	box.backdrop:SetBackdropColor(unpack(self.hover and not self.disabled and COLOR_BOX_HOVER or COLOR_BOX))
	self.arrow:SetVertexColor(unpack(self.disabled and COLOR_ARROW_DISABLED or COLOR_ARROW))
	self.valueText:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
	self.label:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
end

local function Box_OnEnter(frame)
	local self = frame.obj
	self.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")
end

local function Box_OnLeave(frame)
	local self = frame.obj
	self.hover = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function OnPulloutOpen(this)
	local self = this.userdata.obj
	local value = self.value

	if not self.multiselect then
		for _, item in this:IterateItems() do
			item:SetValue(item.userdata.value == value)
		end
	end

	self.open = true
	self:Fire("OnOpened")
end

local function OnPulloutClose(this)
	local self = this.userdata.obj
	self.open = nil
	self:Fire("OnClosed")
end

local function ShowMultiText(self)
	local text
	for _, widget in self.pullout:IterateItems() do
		if widget.type == "Dropdown-Item-Toggle" then
			if widget:GetValue() then
				text = text and (text .. ", " .. widget:GetText()) or widget:GetText()
			end
		end
	end
	self:SetText(text)
end

local function OnItemValueChanged(this, event, checked)
	local self = this.userdata.obj

	if self.multiselect then
		self:Fire("OnValueChanged", this.userdata.value, checked)
		ShowMultiText(self)
	else
		if checked then
			self:SetValue(this.userdata.value)
			self:Fire("OnValueChanged", this.userdata.value)
		else
			this:SetValue(true)
		end
		if self.open then
			self.pullout:Close()
		end
	end
end

local function Box_OnClick(frame)
	local self = frame.obj
	if self.disabled then
		return
	end

	if self.open then
		self.open = nil
		self.pullout:Close()
		AceGUI:ClearFocus()
	else
		self.open = true
		self.pullout:SetWidth(self.pulloutWidth or self.box:GetWidth())
		self.pullout:Open("TOPLEFT", self.box, "BOTTOMLEFT", 0, 0)
		AceGUI:SetFocus(self)
	end
end

local sortlist = {}
local function SortObject(x, y)
	local num1, num2 = tonumber(x), tonumber(y)
	if num1 and num2 then
		return num1 < num2
	else
		return tostring(x) < tostring(y)
	end
end

local function SortValue(a, b)
	if a and b and a[2] and b[2] then
		return a[2] < b[2]
	end
end

local function AddListItem(self, value, text, itemType)
	if not itemType then
		itemType = "Dropdown-Item-Toggle"
	end
	local exists = AceGUI:GetWidgetVersion(itemType)
	if not exists then
		error(("The given item type, %q, does not exist within AceGUI-3.0"):format(tostring(itemType)), 2)
	end

	local item = AceGUI:Create(itemType)
	item:SetText(text)
	item.userdata.obj = self
	item.userdata.value = value
	item:SetCallback("OnValueChanged", OnItemValueChanged)
	self.pullout:AddItem(item)
end

local function AddCloseButton(self)
	if not self.hasClose then
		local close = AceGUI:Create("Dropdown-Item-Execute")
		close:SetText(_G.CLOSE)
		self.pullout:AddItem(close)
		self.hasClose = true
	end
end

local methods = {
	["OnAcquire"] = function(self)
		local pullout = AceGUI:Create("Dropdown-Pullout")
		self.pullout = pullout
		pullout.userdata.obj = self
		pullout:SetCallback("OnClose", OnPulloutClose)
		pullout:SetCallback("OnOpen", OnPulloutOpen)
		self.pullout.frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)
		Fixlevels(self.pullout.frame, self.pullout.frame:GetChildren())

		self.list = {}
		self.hasClose = nil
		self:SetLabel("")
		self:SetText("")
		self:SetDisabled(false)
		self:SetMultiselect(false)
		self:SetPulloutWidth(nil)
		self:SetWidth(200)
		self:SetHeight(FRAME_HEIGHT)
	end,

	["OnRelease"] = function(self)
		if self.open then
			self.pullout:Close()
		end
		AceGUI:Release(self.pullout)
		self.pullout = nil

		self.value = nil
		self.list = nil
		self.open = nil
		self.hasClose = nil

		self.frame:ClearAllPoints()
		self.frame:Hide()
	end,

	["ClearFocus"] = function(self)
		if self.open then
			self.pullout:Close()
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.box:EnableMouse(not disabled)
		UpdateVisual(self)
	end,

	["SetText"] = function(self, text)
		self.valueText:SetText(text or "")
	end,

	["SetLabel"] = function(self, text)
		self.label:SetText(text or "")
	end,

	["SetValue"] = function(self, value)
		self:SetText(self.list[value] or "")
		self.value = value
	end,

	["GetValue"] = function(self)
		return self.value
	end,

	["SetItemValue"] = function(self, item, value)
		if not self.multiselect then
			return
		end
		for _, widget in self.pullout:IterateItems() do
			if widget.userdata.value == item and widget.SetValue then
				widget:SetValue(value)
			end
		end
		ShowMultiText(self)
	end,

	["SetItemDisabled"] = function(self, item, disabled)
		for _, widget in self.pullout:IterateItems() do
			if widget.userdata.value == item then
				widget:SetDisabled(disabled)
			end
		end
	end,

	["SetList"] = function(self, list, order, itemType, sortByValue)
		self.list = list or {}
		self.pullout:Clear()
		self.hasClose = nil
		if not list then
			return
		end

		if type(order) ~= "table" then
			if sortByValue then
				for k, v in pairs(list) do
					sortlist[#sortlist + 1] = { k, v }
				end
				tsort(sortlist, SortValue)

				for i, sorted in ipairs(sortlist) do
					AddListItem(self, sorted[1], sorted[2], itemType)
					sortlist[i] = nil
				end
			else
				for v in pairs(list) do
					sortlist[#sortlist + 1] = v
				end
				tsort(sortlist, SortObject)

				for i, key in ipairs(sortlist) do
					AddListItem(self, key, list[key], itemType)
					sortlist[i] = nil
				end
			end
		else
			for _, key in ipairs(order) do
				AddListItem(self, key, list[key], itemType)
			end
		end

		if self.multiselect then
			ShowMultiText(self)
			AddCloseButton(self)
		end
	end,

	["AddItem"] = function(self, value, text, itemType)
		self.list[value] = text
		AddListItem(self, value, text, itemType)
	end,

	["SetMultiselect"] = function(self, multi)
		self.multiselect = multi
		if multi then
			ShowMultiText(self)
			AddCloseButton(self)
		end
	end,

	["GetMultiselect"] = function(self)
		return self.multiselect
	end,

	["SetPulloutWidth"] = function(self, width)
		self.pulloutWidth = width
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetHeight(LABEL_HEIGHT)
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

	local box = CreateFrame("Button", nil, frame)
	box:SetHeight(BOX_HEIGHT)
	box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -BOX_TOP_OFFSET)
	box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -BOX_TOP_OFFSET)
	-- ignoreUpdates=true keeps this out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option)
	-- re-templates it a few frames later and wipes the colors UpdateVisual() just
	-- set, leaving the box blank until something calls SetDisabled again.
	box:CreateBackdrop("Transparent", nil, true)

	local arrow = box:CreateTexture(nil, "ARTWORK")
	arrow:SetTexture(E.Media.Textures.ArrowUp)
	arrow:SetRotation(3.14)
	arrow:SetSize(12, 12)
	arrow:SetPoint("RIGHT", box, "RIGHT", -4, 0)

	local valueText = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	valueText:SetJustifyH("LEFT")
	valueText:SetWordWrap(false)
	valueText:SetPoint("LEFT", box, "LEFT", 6, 0)
	valueText:SetPoint("RIGHT", arrow, "LEFT", -4, 0)

	local widget = {
		frame = frame,
		label = label,
		box = box,
		arrow = arrow,
		valueText = valueText,
		type = Type,
		-- See MERSlider - matches its alignoffset (BOX_TOP_OFFSET + BOX_HEIGHT / 2)
		-- so a select sitting next to a range option in the same row lines up.
		alignoffset = BOX_TOP_OFFSET + (BOX_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	box.obj = widget

	box:EnableMouse(true)
	box:RegisterForClicks("LeftButtonUp")
	box:SetScript("OnClick", Box_OnClick)
	box:SetScript("OnEnter", Box_OnEnter)
	box:SetScript("OnLeave", Box_OnLeave)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)

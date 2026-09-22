local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local CH = E:GetModule("Chat")

local _G = _G
local ipairs, strfind, unpack = ipairs, strfind, unpack
local floor, max, min = math.floor, math.max, math.min

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition

local GRIP_SIZE = 14
local GRIP_ALPHA = 0.35
local GRIP_ALPHA_HOVER = 0.9
local UPDATE_THROTTLE = 0.1

-- Same limits as ElvUI's own panel size sliders.
local MIN_WIDTH, MAX_WIDTH = 50, 2000
local MIN_HEIGHT, MAX_HEIGHT = 60, 1000

local PANELS = {
	{ name = "LeftChatPanel", width = "panelWidth", height = "panelHeight" },
	{ name = "RightChatPanel", width = "panelWidthRight", height = "panelHeightRight", separate = true },
}

-- The grip texture points to the bottom right; tex coords mirror it into the
-- other corners.
local TEXCOORDS = {
	BOTTOMRIGHT = { 0, 1, 0, 1 },
	BOTTOMLEFT = { 1, 0, 0, 1 },
	TOPRIGHT = { 0, 1, 1, 0 },
	TOPLEFT = { 1, 0, 1, 0 },
}

local function GetSizeKeys(entry)
	if entry.separate and not CH.db.separateSizes then
		return PANELS[1].width, PANELS[1].height
	end

	return entry.width, entry.height
end

-- The panel keeps its anchored corner in place, so the grip sits on the
-- opposite one and a centered anchor grows to both sides at once.
local function GetGrowth(panel)
	local point = panel:GetPoint(1) or "BOTTOMLEFT"
	local x = strfind(point, "LEFT") and 1 or strfind(point, "RIGHT") and -1 or 2
	local y = strfind(point, "BOTTOM") and 1 or strfind(point, "TOP") and -1 or 2
	return x, y
end

local function GetCursor(frame)
	local x, y = GetCursorPosition()
	local scale = frame:GetEffectiveScale()
	return x / scale, y / scale
end

local function Grip_OnUpdate(grip, elapsed)
	if grip.sizing then
		local x, y = GetCursor(grip.panel)
		local width = floor(grip.startWidth + (x - grip.startX) * grip.growX + 0.5)
		local height = floor(grip.startHeight + (y - grip.startY) * grip.growY + 0.5)
		width = max(MIN_WIDTH, min(MAX_WIDTH, width))
		height = max(MIN_HEIGHT, min(MAX_HEIGHT, height))

		local widthKey, heightKey = GetSizeKeys(grip.entry)
		if CH.db[widthKey] ~= width or CH.db[heightKey] ~= height then
			CH.db[widthKey], CH.db[heightKey] = width, height
			CH:PositionChats()
		end
		return
	end

	grip.elapsed = (grip.elapsed or 0) + elapsed
	if grip.elapsed < UPDATE_THROTTLE then
		return
	end
	grip.elapsed = 0

	-- Only visible while the panel is hovered, to keep the corner clean.
	local alpha = (grip:IsMouseOver() and GRIP_ALPHA_HOVER) or (grip.panel:IsMouseOver() and GRIP_ALPHA) or 0
	if grip:GetAlpha() ~= alpha then
		grip:SetAlpha(alpha)
	end
end

local function Grip_OnMouseDown(grip, button)
	if button ~= "LeftButton" then
		return
	end

	local widthKey, heightKey = GetSizeKeys(grip.entry)
	grip.startX, grip.startY = GetCursor(grip.panel)
	grip.startWidth, grip.startHeight = CH.db[widthKey], CH.db[heightKey]
	grip.sizing = true
end

local function Grip_OnMouseUp(grip)
	grip.sizing = nil
end

local function Grip_OnEnter(grip)
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(grip, "ANCHOR_TOP")
	tooltip:AddLine(L["Drag to resize the chat panel"])
	tooltip:Show()
end

local function Grip_OnLeave()
	_G.GameTooltip:Hide()
end

function module:CreateResizeGrip(entry)
	local panel = _G[entry.name]
	local grip = CreateFrame("Button", "MER_" .. entry.name .. "ResizeGrip", panel)
	grip:Size(GRIP_SIZE)
	grip:SetAlpha(0)
	grip.panel = panel
	grip.entry = entry

	local texture = grip:CreateTexture(nil, "OVERLAY")
	texture:SetAllPoints()
	texture:SetTexture(I.Media.Icons.Chat.resize)
	grip.Texture = texture

	grip:SetScript("OnUpdate", Grip_OnUpdate)
	grip:SetScript("OnMouseDown", Grip_OnMouseDown)
	grip:SetScript("OnMouseUp", Grip_OnMouseUp)
	grip:SetScript("OnEnter", Grip_OnEnter)
	grip:SetScript("OnLeave", Grip_OnLeave)

	return grip
end

function module:UpdateResizeGrips()
	if not self.resizeInitialized then
		return
	end

	local enabled = not self.chatDB.lockSize

	for _, entry in ipairs(PANELS) do
		local panel = _G[entry.name]
		local grip = self.resizeGrips[entry.name]

		if enabled and not grip then
			grip = self:CreateResizeGrip(entry)
			self.resizeGrips[entry.name] = grip
		end

		if grip then
			if enabled then
				local growX, growY = GetGrowth(panel)
				local corner = (growY == -1 and "BOTTOM" or "TOP") .. (growX == -1 and "LEFT" or "RIGHT")

				grip.growX, grip.growY = growX, growY
				grip:SetFrameLevel(panel:GetFrameLevel() + 20)
				grip:ClearAllPoints()
				grip:Point(corner, panel, corner, strfind(corner, "LEFT") and 1 or -1, strfind(corner, "TOP") and -1 or 1)
				grip.Texture:SetTexCoord(unpack(TEXCOORDS[corner]))
			end

			grip.sizing = nil
			grip:SetShown(enabled)
		end
	end
end

function module:InitializeResizeGrips()
	self.resizeGrips = {}
	self.resizeInitialized = true
end

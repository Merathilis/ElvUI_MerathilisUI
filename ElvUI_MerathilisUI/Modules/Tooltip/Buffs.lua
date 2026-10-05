local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local TT = E:GetModule("Tooltip")

local next = next

local UnitGUID = UnitGUID
local UnitIsPlayer = UnitIsPlayer

local GameTooltip = GameTooltip
local TooltipDataProcessor = _G.TooltipDataProcessor

local GROUP_KEY = "buffs"
local GROUP_FILTER = "HELPFUL"
local GROUP_DATA = { filter = GROUP_FILTER }
local EDGE_GAP = 2

-- point: container point, relativePoint: point on the tooltip (or its health bar),
-- growth: E.AuraGrowthMap key, its anchor has to match the container point
local POSITIONS = {
	BOTTOM = { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", growth = "RIGHT_DOWN", x = 0, y = -1 },
	TOP = { point = "BOTTOMLEFT", relativePoint = "TOPLEFT", growth = "RIGHT_UP", x = 0, y = 1 },
	LEFT = { point = "TOPRIGHT", relativePoint = "TOPLEFT", growth = "LEFT_DOWN", x = -1, y = 0 },
	RIGHT = { point = "TOPLEFT", relativePoint = "TOPRIGHT", growth = "RIGHT_DOWN", x = 1, y = 0 },
}

local function GetDB()
	return E.db.mui.tooltip.buffs
end

-- ElvUI places its health bar outside the tooltip, on the same side the icons would go
local function GetAnchorFrame(position)
	local bar = _G.GameTooltipStatusBar
	if not bar or not E.private.tooltip.enable then
		return GameTooltip
	end

	local statusPosition = E.db.tooltip.healthBar and E.db.tooltip.healthBar.statusPosition
	if statusPosition == position then
		return bar
	end

	return GameTooltip
end

local function UpdateAnchor(container)
	local db = GetDB()
	local position = POSITIONS[db.position] and db.position or "BOTTOM"
	local anchor = GetAnchorFrame(position)

	local key = position .. (anchor == GameTooltip and "" or "_bar") .. db.xOffset .. ":" .. db.yOffset
	if container.anchorKey == key then
		return
	end
	container.anchorKey = key

	local info = POSITIONS[position]
	container:ClearAllPoints()
	container:Point(
		info.point,
		anchor,
		info.relativePoint,
		info.x * EDGE_GAP + db.xOffset,
		info.y * EDGE_GAP + db.yOffset
	)
end

-- Same look as ElvUI's own aura buttons, minus the mouse (the icons sit on a tooltip that
-- often follows the cursor, so they must never eat clicks or open their own tooltip) and
-- minus the countdown numbers, which are unreadable at tooltip icon sizes
local function InitializeButton(button)
	local container = module.buffContainer
	container.buttons[button] = container

	button.key = GROUP_KEY
	button.data = GROUP_DATA
	button.filter = GROUP_FILTER
	button.container = container

	E:Auras_CreateButton(button)
	E:Auras_UpdateButton(container, button)

	button:EnableMouse(false)
	button.cooldown:SetHideCountdownNumbers(true)
end

local function ApplySettings(container)
	local db = GetDB()

	container.size = db.size
	container.spacing = db.spacing
	container.lineSpacing = db.spacing
	container.numAuras = db.perRow
	container.maxFrameCount = db.maxIcons
	container.growthDirection = (POSITIONS[db.position] or POSITIONS.BOTTOM).growth
	container.countFontSize = db.countFontSize
	container.countFontOutline = "OUTLINE"
	container.countPosition = "BOTTOMRIGHT"
	container.countXOffset = 1
	container.countYOffset = 1

	local layout = E:Auras_UpdateLayout(container)
	if container.known[GROUP_KEY] then
		container:SetAuraGroupMaxFrameCount(GROUP_KEY, db.maxIcons)
		container:SetAuraGroupLayout(GROUP_KEY, layout)
	else
		container:AddAuraGroup(GROUP_KEY, GROUP_FILTER, {
			initializeFrame = InitializeButton,
			maxFrameCount = db.maxIcons,
			layout = layout,
		})
		container.known[GROUP_KEY] = GROUP_FILTER
	end

	E:Auras_SetFlowLayout(container)
	E:Auras_SetLineSize(container)

	container.anchorKey = nil
	UpdateAnchor(container)
end

local function CreateContainer()
	-- Parented to the tooltip so the icons share its scale, strata and visibility
	local container = E:Auras_Create(GameTooltip, nil, "MER_TooltipBuffs")
	container.noMouse = true
	container.layout = {}
	module.buffContainer = container

	GameTooltip:HookScript("OnTooltipCleared", function()
		container:Hide() -- the unit post call shows it again for the next unit
	end)

	GameTooltip:HookScript("OnHide", function()
		container.guid = nil
		container.unit = nil
	end)

	return container
end

local function OnTooltipSetUnit(tt)
	if tt ~= GameTooltip or tt:IsForbidden() then
		return
	end

	local db = GetDB()
	if not db.enable then
		return
	end

	local unit = TT:GetUnitToken(tt)
	if not unit or (db.playersOnly and not UnitIsPlayer(unit)) then
		return
	end

	local container = module.buffContainer or CreateContainer()

	-- A secret GUID can't be compared, so then every refresh rebinds the unit
	local guid = UnitGUID(unit)
	guid = E:NotSecretValue(guid) and guid or nil

	container:Show()

	-- Like ElvUI, the group is only added once the container is shown
	if container.known[GROUP_KEY] then
		UpdateAnchor(container)
	else
		ApplySettings(container)
	end

	if not guid or guid ~= container.guid or unit ~= container.unit then
		container.guid = guid
		E:Auras_SetUnit(container, unit)
		container:UpdateAllAuras()
	end
end

function module:UpdateBuffs()
	local container = self.buffContainer
	if not container then
		return
	end

	if not GetDB().enable then
		container:Hide()
		return
	end

	-- Settings are read when the group is added on the first show. ElvUI doesn't touch aura
	-- containers while auras are restricted either
	if not container.known[GROUP_KEY] or E:IsRestrictedAuras() then
		return
	end

	ApplySettings(container)
	E:Auras_UpdateButtons(container)

	for button in next, container.buttons do
		button:EnableMouse(false)
		button.cooldown:SetHideCountdownNumbers(true)
	end
end

function module:InitializeBuffs()
	-- AuraContainers are a 12.1 widget, ElvUI's helpers for them only exist where it does
	if not (E.Auras_Create and TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall) then
		return
	end

	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipSetUnit)
end

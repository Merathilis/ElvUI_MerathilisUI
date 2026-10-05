local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local LSM = E.LSM or E.Libs.LSM

local ceil, max, min = math.ceil, math.max, math.min
local CreateFrame = CreateFrame
local C_Spell_GetSpellTexture = C_Spell and C_Spell.GetSpellTexture

-- Sample unit tooltip with the buff icons of the Tooltip module. Used as
-- `dialogControl` on a description named "tooltip". Position, growth, size,
-- spacing, icons per row, max icons, stack font and offsets follow
-- Modules/Tooltip/Buffs.lua; icons on the side of ElvUI's tooltip health bar
-- are anchored to the bar like in the game. The preview grows with the grid.

local MIN_HEIGHT, MAX_HEIGHT = 100, 320
local PADDING = 8
local MAX_ICONS = 40
local TOOLTIP_WIDTH = 200
local LINE_HEIGHT = 15
local EDGE_GAP = 2
-- ElvUI keeps its health bar a few pixels off the tooltip
local BAR_GAP = 3

-- Common raid buffs, consumables and the like
local SAMPLE_SPELLS = { 21562, 1459, 1126, 6673, 462854, 381748, 19705, 431972, 1022, 10060, 2825, 465 }
local FALLBACK_ICON = 134400

local POSITIONS = {
	BOTTOM = { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", x = 0, y = -1, dirX = 1, dirY = -1 },
	TOP = { point = "BOTTOMLEFT", relativePoint = "TOPLEFT", x = 0, y = 1, dirX = 1, dirY = 1 },
	LEFT = { point = "TOPRIGHT", relativePoint = "TOPLEFT", x = -1, y = 0, dirX = -1, dirY = -1 },
	RIGHT = { point = "TOPLEFT", relativePoint = "TOPRIGHT", x = 1, y = 0, dirX = 1, dirY = -1 },
}

local function CreateLine(tooltip, index, text, r, g, b)
	local line = tooltip:CreateFontString(nil, "OVERLAY")
	line:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 8, -6 - (index - 1) * LINE_HEIGHT)
	line:SetFont(F.GetFontPath(), 12, "OUTLINE")
	line:SetTextColor(r, g, b)
	line:SetText(text)
	return line
end

local function Build(widget)
	local frame = widget.frame
	frame:SetClipsChildren(true)

	local tooltip = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	tooltip:SetTemplate("Transparent")
	tooltip:SetSize(TOOLTIP_WIDTH, LINE_HEIGHT * 3 + 12)
	widget.tooltip = tooltip

	local classColor = E:ClassColor(E.myclass, true)
	CreateLine(tooltip, 1, E.myname, classColor.r, classColor.g, classColor.b)
	CreateLine(tooltip, 2, "<" .. L["Guild"] .. ">", 0.25, 1, 0.25)
	CreateLine(tooltip, 3, L["Level"] .. " " .. E.mylevel .. " " .. (E.myLocalizedRace or ""), 1, 1, 1)

	widget.bar = Preview.CreateBar(frame)

	widget.icons = {}
	for index = 1, MAX_ICONS do
		local button = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		button:SetTemplate()

		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetPoint("TOPLEFT", 1, -1)
		button.icon:SetPoint("BOTTOMRIGHT", -1, 1)
		button.icon:SetTexCoord(unpack(E.TexCoords))
		local spell = SAMPLE_SPELLS[(index - 1) % #SAMPLE_SPELLS + 1]
		button.icon:SetTexture(C_Spell_GetSpellTexture and C_Spell_GetSpellTexture(spell) or FALLBACK_ICON)

		-- A few icons carry stacks
		if index % 4 == 2 then
			-- A font before the first SetText, Update applies the stack font size
			button.count = button:CreateFontString(nil, "OVERLAY")
			button.count:FontTemplate()
			button.count:SetPoint("BOTTOMRIGHT", 1, 1)
			button.count:SetText(tostring(index % 5 + 2))
		end

		widget.icons[index] = button
	end
end

-- The health bar of ElvUI's tooltip, only where its settings show it
local function GetBarInfo()
	local healthBar = E.private.tooltip.enable and E.db.tooltip.healthBar
	local position = healthBar and healthBar.statusPosition
	if position == "TOP" or position == "BOTTOM" then
		return position, max(healthBar.height or 7, 2)
	end
end

local function Update(widget)
	local db = E.db.mui.tooltip.buffs
	local position = POSITIONS[db.position] and db.position or "BOTTOM"
	local info = POSITIONS[position]
	local barPosition, barHeight = GetBarInfo()

	local count = min(db.maxIcons, MAX_ICONS)
	local columns = min(count, db.perRow)
	local rows = ceil(count / db.perRow)
	local blockWidth = columns * db.size + (columns - 1) * db.spacing
	local blockHeight = rows * db.size + (rows - 1) * db.spacing

	local tooltip = widget.tooltip
	local tooltipHeight = tooltip:GetHeight()
	local barSpace = barPosition and barHeight + BAR_GAP or 0
	local vertical = position == "TOP" or position == "BOTTOM"

	-- The preview grows with the grid, up to a limit
	local height
	if vertical then
		height = tooltipHeight + barSpace + EDGE_GAP + blockHeight + math.abs(db.yOffset) + PADDING * 2
	else
		height = max(tooltipHeight + barSpace, blockHeight + math.abs(db.yOffset)) + PADDING * 2
	end
	widget.frame:SetHeight(min(max(height, MIN_HEIGHT), MAX_HEIGHT))

	-- Tooltip at the edge opposite of the icons; side icons shift it off center
	local shift = vertical and 0 or (blockWidth + EDGE_GAP) / 2 * -info.x
	tooltip:ClearAllPoints()
	if position == "TOP" then
		tooltip:SetPoint("BOTTOM", widget.frame, "BOTTOM", 0, PADDING + (barPosition == "BOTTOM" and barSpace or 0))
	else
		tooltip:SetPoint("TOP", widget.frame, "TOP", shift, -PADDING - (barPosition == "TOP" and barSpace or 0))
	end

	local bar = widget.bar
	bar:SetShown(barPosition ~= nil)
	local anchor = tooltip
	if barPosition then
		local r, g, b = Preview.HostileColor()
		Preview.UpdateBar(bar, TOOLTIP_WIDTH, barHeight, 0.85, E.private.general.normTex, r, g, b)
		bar:ClearAllPoints()
		if barPosition == "BOTTOM" then
			bar:SetPoint("TOP", tooltip, "BOTTOM", 0, -BAR_GAP)
		else
			bar:SetPoint("BOTTOM", tooltip, "TOP", 0, BAR_GAP)
		end
		-- Icons on the bar's side go next to the bar instead
		if barPosition == position then
			anchor = bar
		end
	end

	-- First icon at the container point, the grid grows away from the tooltip
	local fontPath = LSM:Fetch("font", E.db.general.font)
	for index, button in ipairs(widget.icons) do
		local shown = index <= count
		button:SetShown(shown)
		if shown then
			local column = (index - 1) % db.perRow
			local row = (index - 1 - column) / db.perRow
			local x = info.x * EDGE_GAP + db.xOffset + info.dirX * column * (db.size + db.spacing)
			local y = info.y * EDGE_GAP + db.yOffset + info.dirY * row * (db.size + db.spacing)

			button:SetSize(db.size, db.size)
			button:ClearAllPoints()
			button:SetPoint(info.point, anchor, info.relativePoint, x, y)

			if button.count then
				button.count:SetFont(fontPath, db.countFontSize, "OUTLINE")
			end
		end
	end

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERTooltipBuffsPreview", 1, MIN_HEIGHT, Build, Update)

local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local CreateFrame = CreateFrame
local UnitFactionGroup = UnitFactionGroup

-- Sample health bar with the Faction Indicator. Used as `dialogControl` on a
-- description whose name is "nameplates", "unitframes" (style only, shown on
-- the target frame) or "unitframes:<unit>". The icon is placed like the module
-- does it: outside the plate's click area on nameplates, inside the health bar
-- on unitframes.

local MAX_WIDTH = 300
local HEIGHT = 110

-- The preview shows the faction the player would see the icon for
local function GetOpposingFaction()
	return UnitFactionGroup("player") == "Horde" and "Alliance" or "Horde"
end

local function Build(widget)
	local frame = widget.frame
	-- Large offsets would draw over the options around the preview
	frame:SetClipsChildren(true)

	widget.bar = Preview.CreateBar(frame)
	widget.bar:SetPoint("CENTER")

	-- The nameplate's click area, the anchor of the nameplate icon
	widget.plate = CreateFrame("Frame", nil, frame)
	widget.plate:SetPoint("CENTER", widget.bar)

	widget.icon = widget.bar:CreateTexture(nil, "OVERLAY", nil, 2)
end

local function Update(widget, key)
	local isPlate = key == "nameplates"
	local unit = not isPlate and (key:match("^unitframes:(.+)$") or "target")

	local style, position, enabled, width, height, statusbar
	if isPlate then
		local db = E.db.mui.nameplates.factionIndicator
		style, position, enabled = db.style, db, db.enable
		width, height = Preview.NameplateSize(MAX_WIDTH)
		statusbar = E.db.nameplates.statusbar
	else
		local db = E.db.mui.unitframes.factionIndicator
		position = db.units[unit]
		style = db.style
		enabled = db.enable and (key == "unitframes" or position.enable)
		width, height = Preview.UnitFrameSize(unit, MAX_WIDTH)
		statusbar = E.db.unitframe.statusbar
	end

	Preview.UpdateBar(widget.bar, width, height, 0.7, statusbar, Preview.HostileColor())

	local atlases = MER.FactionIndicatorAtlases
	atlases = atlases and (atlases[style] or atlases.crest)
	local icon = widget.icon
	icon:SetShown(atlases ~= nil)
	if not atlases then
		return
	end

	icon:SetAtlas(atlases[GetOpposingFaction()])
	icon:SetSize(position.size, position.size)
	icon:ClearAllPoints()

	if isPlate then
		local clickSize = E.db.nameplates.clickSize
		widget.plate:SetSize(clickSize.enemyWidth, clickSize.enemyHeight)
		icon:SetPoint(
			E.InversePoints[position.position],
			widget.plate,
			position.position,
			position.xOffset,
			position.yOffset
		)
	else
		icon:SetPoint(position.position, widget.bar, position.position, position.xOffset, position.yOffset)
	end

	Preview.SetEnabled(widget, enabled)
end

Preview.Register("MERFactionIndicatorPreview", 1, HEIGHT, Build, Update)

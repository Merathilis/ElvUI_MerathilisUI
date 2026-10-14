local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local ipairs = ipairs
local min = math.min
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

-- The Raid Icon and Highlight toggles of the UnitFrames General tab: the raid
-- icons MerathilisUI puts on the unitframes and a sample target frame with the
-- mouseover highlight. Used as `dialogControl` on a description named
-- "unitframes"; each part is dimmed while its toggle is off.

local MAX_WIDTH = 240
local HEIGHT = 110
local ICON_SIZE = 22
local ICON_SPACING = 6
local NUM_MARKERS = 8
local RAID_ICONS = I.General.MediaPath .. "Textures\\RaidIcons\\UI-RaidTargetingIcons"
local HIGHLIGHT_TEXTURE = [[Interface\PETBATTLES\PetBattle-SelectedPetGlow]]

local function Build(widget)
	local frame = widget.frame

	widget.icons = {}
	for index = 1, NUM_MARKERS do
		local icon = frame:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetTexture(RAID_ICONS)
		SetRaidTargetIconTexture(icon, index)
		icon:SetPoint("TOP", frame, "TOP", (index - (NUM_MARKERS + 1) / 2) * (ICON_SIZE + ICON_SPACING), -2)
		widget.icons[index] = icon
	end

	widget.bar = Preview.CreateBar(frame)

	-- Same texture and color as module:CreateHighlight
	local highlight = widget.bar:CreateTexture(nil, "OVERLAY")
	highlight:SetAllPoints()
	highlight:SetTexture(HIGHLIGHT_TEXTURE)
	highlight:SetTexCoord(0, 1, 0.5, 1)
	highlight:SetVertexColor(1, 1, 0.6, 1)
	highlight:SetBlendMode("ADD")
	widget.highlight = highlight
end

local function Update(widget)
	local db = E.db.mui.unitframes
	local width, height = Preview.UnitFrameSize("target", MAX_WIDTH)
	height = min(height, HEIGHT - ICON_SIZE - 20)

	local bar = widget.bar
	bar:ClearAllPoints()
	bar:SetPoint("TOP", widget.frame, "TOP", 0, -(ICON_SIZE + 14))
	Preview.UpdateBar(bar, width, height, 0.7, E.db.unitframe.statusbar, Preview.HostileColor())

	local iconAlpha = db.raidIcons and 1 or 0.4
	for _, icon in ipairs(widget.icons) do
		icon:SetAlpha(iconAlpha)
	end

	bar:SetAlpha(db.highlight and 1 or 0.4)
end

Preview.Register("MERUnitFrameStylePreview", 1, HEIGHT, Build, Update)

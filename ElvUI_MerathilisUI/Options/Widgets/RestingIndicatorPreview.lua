local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

-- Sample player frame with the animated Resting Indicator. Used as
-- `dialogControl` on a description named "unitframes". The icon follows the
-- Rest Icon settings of ElvUI's player frame, the loop on top of it comes from
-- the module itself, so color mode and speed match the game.

local MAX_WIDTH = 240
local HEIGHT = 90
local DEFAULT_TEXTURE = [[Interface\CharacterFrame\UI-StateIcon]]

local function Build(widget)
	widget.bar = Preview.CreateBar(widget.frame)
	widget.bar:SetPoint("CENTER", 0, -8)

	local icon = widget.bar:CreateTexture(nil, "OVERLAY")

	-- Only what Configure_RestingIndicator asks of an ElvUI unitframe
	widget.owner = {
		RestingIndicator = icon,
		db = { RestIcon = { enable = true } },
	}
end

-- ElvUI's own texture choice for the icon (UF:Configure_RestingIndicator)
local function ApplyIconTexture(icon, iconDb)
	if iconDb.texture == "CUSTOM" and iconDb.customTexture then
		icon:SetTexture(iconDb.customTexture)
		icon:SetTexCoord(0, 1, 0, 1)
	elseif iconDb.texture ~= "DEFAULT" and E.Media.RestIcons[iconDb.texture] then
		icon:SetTexture(E.Media.RestIcons[iconDb.texture])
		icon:SetTexCoord(0, 1, 0, 1)
	else
		icon:SetTexture(DEFAULT_TEXTURE)
		icon:SetTexCoord(0, 0.5, 0, 0.421875)
	end

	if iconDb.defaultColor then
		icon:SetVertexColor(1, 1, 1, 1)
		icon:SetDesaturated(false)
	else
		icon:SetVertexColor(iconDb.color.r, iconDb.color.g, iconDb.color.b, iconDb.color.a)
		icon:SetDesaturated(true)
	end
end

local function Update(widget)
	local playerDb = E.db.unitframe.units.player
	local iconDb = playerDb.RestIcon
	local width, height = Preview.UnitFrameSize("player", MAX_WIDTH)

	local color = E:ClassColor(E.myclass, true)
	Preview.UpdateBar(widget.bar, width, height, 1, E.db.unitframe.statusbar, color.r, color.g, color.b)

	local icon = widget.owner.RestingIndicator
	ApplyIconTexture(icon, iconDb)
	icon:SetSize(iconDb.size, iconDb.size)
	icon:ClearAllPoints()
	icon:SetPoint("CENTER", widget.bar, iconDb.anchorPoint, iconDb.xOffset, iconDb.yOffset)
	icon:Show()

	widget.owner.db.RestIcon.enable = iconDb.enable
	widget.owner.db.RestIcon.size = iconDb.size
	MER:GetModule("MER_UnitFrames"):Configure_RestingIndicator(widget.owner)

	Preview.SetEnabled(widget, E.db.mui.unitframes.restingIndicator.enable and iconDb.enable)
end

Preview.Register("MERRestingIndicatorPreview", 1, HEIGHT, Build, Update)

local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local ElvUF = E.oUF

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local GetRaidTargetIndex = GetRaidTargetIndex

--[[
	oUF element: MER_MarkerColor

	Tints the filled part of the health bar of a nameplate with a raid marker in
	the color of that marker.

	Widget: nameplate.MER_MarkerColor - a Texture on the fill of the health bar

	Secret-safe: the marker index is secret and no color can be looked up with
	it. The texture is a sheet with one plain colored cell per marker, the index
	only picks the cell - the same way the marker icon itself is picked.
--]]

-- One row with a cell per marker, in the colors of MER.RaidMarkerColors
local SHEET = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\RaidMarkerColors]]
local SHEET_ROWS = 1
local SHEET_COLUMNS = 8

-- Star, Circle, Diamond, Triangle, Moon, Square, Cross, Skull
MER.RaidMarkerColors = {
	{ r = 1.00, g = 0.92, b = 0.00 },
	{ r = 0.98, g = 0.57, b = 0.00 },
	{ r = 0.83, g = 0.22, b = 0.90 },
	{ r = 0.04, g = 0.95, b = 0.00 },
	{ r = 0.70, g = 0.82, b = 0.88 },
	{ r = 0.00, g = 0.71, b = 1.00 },
	{ r = 1.00, g = 0.24, b = 0.17 },
	{ r = 0.98, g = 0.98, b = 0.98 },
}

local function Update(self)
	local element = self.MER_MarkerColor

	if element.PreUpdate then
		element:PreUpdate()
	end

	local index = self.__unit and GetRaidTargetIndex(self.__unit)
	if index then
		element:SetSpriteSheetCell(index, SHEET_ROWS, SHEET_COLUMNS)
		element:Show()
	else
		element:Hide()
	end

	if element.PostUpdate then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.MER_MarkerColor.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_MarkerColor
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("RAID_TARGET_UPDATE", Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.MER_MarkerColor
	if element then
		element:Hide()

		self:UnregisterEvent("RAID_TARGET_UPDATE", Path)
	end
end

ElvUF:AddElement("MER_MarkerColor", Path, Enable, Disable)

-- Nameplate integration
function module:Configure_MarkerColor(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local db = E.db.mui.nameplates.markerColor
	local enabled = db and db.enable and nameplate.frameType ~= "PLAYER"

	if not enabled then
		if nameplate.MER_MarkerColor and nameplate:IsElementEnabled("MER_MarkerColor") then
			nameplate:DisableElement("MER_MarkerColor")
		end
		return
	end

	local health = nameplate.Health
	local element = nameplate.MER_MarkerColor
	if not element then
		element = health:CreateTexture(nil, "ARTWORK", nil, 5)
		-- Unfiltered, the neighbour cells must not bleed into the picked one
		element:SetTexture(SHEET, "CLAMP", "CLAMP", "NEAREST")
		element:Hide()
		nameplate.MER_MarkerColor = element
	end

	-- Clients without sprite sheet cells can't pick the color
	if not element.SetSpriteSheetCell then
		return
	end

	-- A texture change on the health bar can hand out a new fill region
	element:SetAllPoints(health:GetStatusBarTexture())
	element:SetAlpha(db.alpha)

	if not nameplate:IsElementEnabled("MER_MarkerColor") then
		nameplate:EnableElement("MER_MarkerColor")
	end

	if nameplate.__unit then
		element:ForceUpdate()
	end
end

function module:UpdateMarkerColors()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_MarkerColor(nameplate)
	end
end

function module:MarkerColor()
	-- Runs for every plate that gets (re)configured
	hooksecurefunc(NP, "Update_Health", function(_, nameplate)
		module:Configure_MarkerColor(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateMarkerColors()
end

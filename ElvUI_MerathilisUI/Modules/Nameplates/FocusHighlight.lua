local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local ElvUF = E.oUF
local LSM = E.LSM or E.Libs.LSM

local hooksecurefunc = hooksecurefunc
local pairs = pairs

--[[
	oUF element: MER_FocusHighlight

	A texture over the health bar of the focus target's nameplate.

	Widget: nameplate.MER_FocusHighlight - a Texture on the health bar, so
	name-only plates (health bar reparented to a hidden frame) never show it
--]]

local function Update(self)
	local element = self.MER_FocusHighlight

	if element.PreUpdate then
		element:PreUpdate()
	end

	local isFocus = self.__unit and E:UnitIsUnit(self.__unit, "focus")
	element:SetShown(isFocus and true or false)

	if element.PostUpdate then
		return element:PostUpdate(isFocus)
	end
end

local function Path(self, ...)
	return (self.MER_FocusHighlight.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_FocusHighlight
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_FOCUS_CHANGED", Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.MER_FocusHighlight
	if element then
		element:Hide()

		self:UnregisterEvent("PLAYER_FOCUS_CHANGED", Path)
	end
end

ElvUF:AddElement("MER_FocusHighlight", Path, Enable, Disable)

-- Nameplate integration
local function GetColor(db)
	if db.colorMode == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	end

	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

function module:Configure_FocusHighlight(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local db = E.db.mui.nameplates.focusHighlight
	local enabled = db and db.enable and nameplate.frameType ~= "PLAYER"

	if not enabled then
		if nameplate.MER_FocusHighlight and nameplate:IsElementEnabled("MER_FocusHighlight") then
			nameplate:DisableElement("MER_FocusHighlight")
		end
		return
	end

	local element = nameplate.MER_FocusHighlight
	if not element then
		-- Above the fill and the Raid Marker Color
		element = nameplate.Health:CreateTexture(nil, "ARTWORK", nil, 6)
		element:SetAllPoints(nameplate.Health)
		element:Hide()
		nameplate.MER_FocusHighlight = element
	end

	local r, g, b = GetColor(db)
	element:SetTexture(LSM:Fetch("statusbar", db.texture))
	element:SetVertexColor(r, g, b, db.alpha)

	if not nameplate:IsElementEnabled("MER_FocusHighlight") then
		nameplate:EnableElement("MER_FocusHighlight")
	end

	if nameplate.__unit then
		element:ForceUpdate()
	end
end

function module:UpdateFocusHighlights()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_FocusHighlight(nameplate)
	end
end

function module:FocusHighlight()
	-- Runs for every plate that gets (re)configured
	hooksecurefunc(NP, "Update_Health", function(_, nameplate)
		module:Configure_FocusHighlight(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateFocusHighlights()
end

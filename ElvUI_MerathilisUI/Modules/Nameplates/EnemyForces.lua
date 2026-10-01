local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local ElvUF = E.oUF
local LSM = E.LSM or E.Libs.LSM

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local pairs, tonumber = pairs, tonumber

local C_ChallengeMode_IsChallengeModeActive = C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive
local C_ScenarioInfo_GetUnitCriteriaProgressValues = C_ScenarioInfo and C_ScenarioInfo.GetUnitCriteriaProgressValues

--[[
	oUF element: MER_EnemyForces

	During a Mythic+ run, the share of the Enemy Forces an enemy gives, as a text
	next to its health bar.

	Widget: nameplate.MER_EnemyForces - a Frame parented to the health bar, so
	name-only plates (health bar reparented to a hidden frame) never show it
	Options: element.format - "PERCENT", "NUMBER" or "BOTH"

	Secret-safe: the values are secret in a run, they only go into
	SetFormattedText. Asked once per unit, the share of a unit never changes.
--]]

local FORMATS = {
	PERCENT = "+%s%%",
	NUMBER = "+%s",
	BOTH = "+%s (%s%%)",
}

local function Update(self)
	local element = self.MER_EnemyForces

	if element.PreUpdate then
		element:PreUpdate()
	end

	local count, percent, _
	if self.__unit and C_ChallengeMode_IsChallengeModeActive() then
		count, _, percent = C_ScenarioInfo_GetUnitCriteriaProgressValues(self.__unit)
	end

	-- Readable values tell which units give nothing, secret ones are shown as they come
	local hasForces = E:IsSecretValue(count)
	if not hasForces then
		local number = tonumber(count)
		hasForces = number ~= nil and number > 0
	end

	if hasForces then
		local text = element.text
		if element.format == "NUMBER" then
			text:SetFormattedText(FORMATS.NUMBER, count)
		elseif element.format == "BOTH" then
			text:SetFormattedText(FORMATS.BOTH, count, percent)
		else
			text:SetFormattedText(FORMATS.PERCENT, percent)
		end
		element:Show()
	else
		element:Hide()
	end

	if element.PostUpdate then
		return element:PostUpdate(hasForces)
	end
end

local function Path(self, ...)
	return (self.MER_EnemyForces.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_EnemyForces
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		-- Plates that are already up when the key starts or ends
		self:RegisterEvent("CHALLENGE_MODE_START", Path, true)
		self:RegisterEvent("CHALLENGE_MODE_COMPLETED", Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.MER_EnemyForces
	if element then
		element:Hide()

		self:UnregisterEvent("CHALLENGE_MODE_START", Path)
		self:UnregisterEvent("CHALLENGE_MODE_COMPLETED", Path)
	end
end

ElvUF:AddElement("MER_EnemyForces", Path, Enable, Disable)

-- Nameplate integration
local function IsSupported()
	return C_ChallengeMode_IsChallengeModeActive and C_ScenarioInfo_GetUnitCriteriaProgressValues and true
end

function module:Configure_EnemyForces(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local db = E.db.mui.nameplates.enemyForces
	local enabled = db and db.enable and nameplate.frameType == "ENEMY_NPC" and IsSupported()

	if not enabled then
		if nameplate.MER_EnemyForces and nameplate:IsElementEnabled("MER_EnemyForces") then
			nameplate:DisableElement("MER_EnemyForces")
		end
		return
	end

	local health = nameplate.Health
	local element = nameplate.MER_EnemyForces
	if not element then
		element = CreateFrame("Frame", nil, health)
		element:SetAllPoints(health)
		element:Hide()
		element.text = element:CreateFontString(nil, "OVERLAY")
		nameplate.MER_EnemyForces = element
	end

	element:SetFrameLevel(health:GetFrameLevel() + 5)
	element.format = db.format

	local text = element.text
	text:SetFont(LSM:Fetch("font", NP.db.font), db.fontSize, NP.db.fontOutline)
	text:SetTextColor(db.color.r, db.color.g, db.color.b)
	text:ClearAllPoints()
	text:Point(E.InversePoints[db.position], health, db.position, db.xOffset, db.yOffset)

	if not nameplate:IsElementEnabled("MER_EnemyForces") then
		nameplate:EnableElement("MER_EnemyForces")
	end

	if nameplate.__unit then
		element:ForceUpdate()
	end
end

function module:UpdateEnemyForces()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_EnemyForces(nameplate)
	end
end

function module:EnemyForces()
	-- Runs for every plate that gets (re)configured
	hooksecurefunc(NP, "Update_Health", function(_, nameplate)
		module:Configure_EnemyForces(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateEnemyForces()
end

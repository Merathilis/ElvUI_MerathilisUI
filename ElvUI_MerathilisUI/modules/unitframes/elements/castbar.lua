local MER, E, L, V, P, G = unpack(select(2, ...))
local MCA = MER:NewModule("mUICastbar", "AceTimer-3.0", "AceEvent-3.0")
local UF = E:GetModule("UnitFrames")
local LSM = E.LSM

--Cache global variables
local _G = _G

--WoW API / Variables
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

--Configure castbar text position and alpha
local function ConfigureText(unit, castbar)
	local db = E.db.mui.unitframes.castbar.text

	if db.castText then
		castbar.Text:Show()
		castbar.Time:Show()
	else
		if (unit == "target" and db.forceTargetText) then
			castbar.Text:Show()
			castbar.Time:Show()
		else
			castbar.Text:Hide()
			castbar.Time:Hide()
		end
	end

	-- Set position of castbar text according to chosen offsets
	castbar.Text:ClearAllPoints()
	castbar.Time:ClearAllPoints()
	if db.yOffset ~= 0 then
		if unit == "player" then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.player.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.player.yOffset)
		elseif unit == "target" then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.target.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.target.yOffset)
		end
	else
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	end
end

local function changeCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("LOW")
	unitframe.Castbar:SetFrameLevel(unitframe.InfoPanel:GetFrameLevel() + 10)
end

local function resetCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("HIGH")
	unitframe.Castbar:SetFrameLevel(6)
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar

	if unit == "player" or unit == "target" then
		ConfigureText(unit, castbar)
		if unitframe.USE_INFO_PANEL and db.insideInfoPanel then
			if E.db.mui.unitframes.castbar.text.ShowInfoText then
				changeCastbarLevel(unit, unitframe)
			else
				resetCastbarLevel(unit, unitframe)
			end
		else
			resetCastbarLevel(unit, unitframe)
		end
	end
end

--Initiate update of unit
function MCA:UpdateSettings(unit)
	if unit == "player" or unit == "target" then
		local unitFrameName = "ElvUF_"..E:StringTitle(unit)
		local unitframe = _G[unitFrameName]
		ConfigureCastbar(unit, unitframe)
	end
end

-- Function to be called when registered events fire
function MCA:UpdateAllCastbars()
	MCA:UpdateSettings("player")
	MCA:UpdateSettings("target")
	MCA:UpdateSettings("focus")
	MCA:UpdateSettings("pet")
	MCA:UpdateSettings("arena")
	MCA:UpdateSettings("boss")
end

--Castbar texture
function MCA:PostCast(unit, unitframe)
	local castTexture = LSM:Fetch("statusbar", E.db.mui.unitframes.textures.castbar)
	local pr, pg, pb, pa = MER:unpackColor(E.db.mui.unitframes.castbar.text.player.textColor)
	local tr, tg, tb, ta = MER:unpackColor(E.db.mui.unitframes.castbar.text.target.textColor)
	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end
	if unit == "player" then
		self.Text:SetTextColor(pr, pg, pb, pa)
		self.Time:SetTextColor(pr, pg, pb, pa)
	elseif unit == "target" then
		self.Text:SetTextColor(tr, tg, tb, ta)
		self.Time:SetTextColor(tr, tg, tb, ta)
	end
end

function MCA:CastBarHooks()
	local units = {"Player", "Target", "Focus", "Pet"}
	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastUpdate", MCA.PostCast)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastUpdate", MCA.PostCast)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", MCA.PostCast)
			hooksecurefunc(castbar, "PostCastUpdate", MCA.PostCast)
		end
	end
end

function MCA:Initialize()
	if E.private.unitframe.enable ~= true then return end

	hooksecurefunc(E, "UpdateAll", function()
		self:ScheduleTimer("UpdateAllCastbars", 0.5)
	end)

	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end

		local unit = frame.unitframeType
		if unit and (unit == "player" or unit == "target") then
			MCA:UpdateSettings(unit)
		end
	end)

	MCA:CastBarHooks()
end

local function InitializeCallback()
	MCA:Initialize()
end

MER:RegisterModule(MCA:GetName(), InitializeCallback)

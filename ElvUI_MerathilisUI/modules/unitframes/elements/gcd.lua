local MER, E, L, V, P, G = unpack(select(2, ...))
local MGCD = MER:NewModule("GCDBar", "AceEvent-3.0")

--Cache global variables
-- LUA Variables
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
-- GLOBALS:

local gcdbar, starttime, duration

local function OnUpdate()
	if not starttime then return gcdbar:Hide() end
	gcdbar.spark:ClearAllPoints()
	local perc = (GetTime() - starttime) / duration
	local width = gcdbar:GetWidth()
	if perc > 1 then
		return gcdbar:Hide()
	else
		gcdbar.spark:SetPoint("RIGHT", gcdbar, "LEFT", width * perc, 0)
	end
end

function MGCD:CheckGCD(event, unit, guid, spell)
	if unit == "player" then
		local start, dur = GetSpellCooldown(spell)
		if dur and dur > 0 and dur <= 1.5 then
			starttime = start
			duration = dur
			gcdbar:Show()
		end
	end
end

function MGCD:LoadGCDBar(frame)
	self:RegisterEvent("UNIT_SPELLCAST_START", "CheckGCD")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CheckGCD")

	gcdbar = CreateFrame("Frame", "MER_GCDBar", frame)
	gcdbar:SetFrameStrata("HIGH")
	gcdbar.Color = {1, 1, 1}

	local width = _G["ElvUF_Player"]:GetWidth()
	gcdbar:SetWidth(width)
	gcdbar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0)

	gcdbar:Height(2)
	gcdbar.width = 3
	gcdbar.height = 2
	gcdbar:Hide()

	gcdbar.spark = gcdbar:CreateTexture(nil, "DIALOG")
	gcdbar.spark:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	gcdbar.spark:SetVertexColor(unpack(gcdbar.Color))
	gcdbar.spark:SetWidth(gcdbar.width)
	gcdbar.spark:SetHeight(gcdbar.height)
	gcdbar.spark:SetBlendMode("ADD")
	gcdbar:SetScript("OnUpdate", OnUpdate)
end

function MGCD:Initialize()
	if E.db.mui.unitframes.units.player.gcd.enable ~= true or E.private.unitframe.enable ~= true or E.db.unitframe.units.player.enable ~= true then return end;

	self:LoadGCDBar(_G["ElvUF_Player"])
end

MER:RegisterModule(MGCD:GetName())

local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub('LibSharedMedia-3.0');

-- Credits nightcracker (ncHoverName)
-- Cache global variables
-- Lua functions
local format = string.format
local tostring = tostring
-- WoW API / Variables
local GetCursorPosition = GetCursorPosition
local GetMouseFocus = GetMouseFocus
local GetQuestDifficultyColor = GetQuestDifficultyColor
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapped, UnitIsTappedByPlayer = UnitIsTapped, UnitIsTappedByPlayer
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitReaction = UnitReaction

-- GLOBALS: CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS, UIParent

local function getcolor(unit)
	local reaction = UnitReaction(unit, "player") or 5

	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
		return color.r, color.g, color.b
	elseif UnitCanAttack("player", unit) then
		if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or UnitIsDead(unit) then
			return 136/255, 136/255, 136/255
		else
			if reaction <4 then
				return 1, 68/255, 68/255
			elseif reaction == 4 then
				return 1, 1, 68/255
			end
		end
	else
		if reaction <4 then
			return 48/255, 113/255, 191/255
		else
			return 1, 1, 1
		end
	end
end


local f = CreateFrame("Frame")
f:SetFrameStrata("TOOLTIP")
f.text = f:CreateFontString(nil, "OVERLAY")
f.text:SetFont(LSM:Fetch('font', 'Merathilis Tukui'), 10, "OUTLINE")

f:SetScript("OnUpdate", function(self)
	if not UnitExists("mouseover") then self:Hide() return end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	self.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y+15)
end)
f:SetScript("OnEvent", function(self)
	local focus = GetMouseFocus()
	if focus and focus:GetName() ~= "WorldFrame" then return end

	local name = UnitName("mouseover")
	local level = UnitLevel("mouseover")
	local target = UnitName("mouseovertarget")
	local prefix = ""

	if level and level ~= UnitLevel("player") then
		local difficulty = GetQuestDifficultyColor(level)

		prefix = format("|cFF%02x%02x%02x%s |r ", difficulty.r*255, difficulty.g*255, difficulty.b*255, tostring(level))
	end

	self.text:SetTextColor(getcolor("mouseover"))
	if target then
		local r, g, b = getcolor("mouseovertarget")
		self.text:SetText(prefix..name..(("|cFFFFFFFF > |cFF%02x%02x%02x"):format(r*255, g*255, b*255))..target)
	else
		self.text:SetText(prefix..name)
	end

	self:Show()
	if IsAddOnLoaded('ncHoverName') or E.db['mui']['misc']['hoverName'] ~= true then
		self:Hide()
	end
end)
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

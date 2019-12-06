local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetMouseFocus = GetMouseFocus
local IsAddOnLoaded = IsAddOnLoaded
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitReaction = UnitReaction
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local UIParent = UIParent
local UNKNOWN = UNKNOWN
-- GLOBALS:

local function Getcolor()
	local reaction = UnitReaction("mouseover", "player") or 5

	if UnitIsPlayer("mouseover") then
		local _, class = UnitClass("mouseover")
		local color = E:ClassColor(class)
		return color.r, color.g, color.b
	elseif UnitCanAttack("player", "mouseover") then
		if UnitIsDead("mouseover") then
			return 136/255, 136/255, 136/255
		else
			if reaction < 4 then
				return 1, 68/255, 68/255
			elseif reaction == 4 then
				return 1, 1, 68/255
			end
		end
	else
		if reaction < 4 then
			return 48/255, 113/255, 191/255
		else
			return 1, 1, 1
		end
	end
end

function MI:LoadnameHover()
	if E.db.mui.nameHover.enable ~= true or IsAddOnLoaded("bdNameHover") then return end

	local db = E.db.mui.nameHover
	local tooltip = CreateFrame("frame", nil)
	tooltip:SetFrameStrata("TOOLTIP")
	tooltip.text = tooltip:CreateFontString(nil, "OVERLAY")
	tooltip.text:FontTemplate(nil, db.fontSize or 7, db.fontOutline or "OUTLINE")

	-- Show unit name at mouse
	tooltip:SetScript("OnUpdate", function(tt)
		if GetMouseFocus() and GetMouseFocus():IsForbidden() then tt:Hide() return end
		if GetMouseFocus() and GetMouseFocus():GetName() ~= "WorldFrame" then tt:Hide() return end
		if not UnitExists("mouseover") then tt:Hide() return end

		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		tt.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y+15)
	end)

	tooltip:SetScript("OnEvent", function(tt)
		if GetMouseFocus():GetName() ~= "WorldFrame" then return end

		local name = UnitName("mouseover") or UNKNOWN
		local AFK = UnitIsAFK("mouseover")
		local DND = UnitIsDND("mouseover")
		local prefix = ""

		if AFK then prefix = "|cffff0000<AFK>|r " end
		if DND then prefix = "|cffffce00<DND>|r " end

		tt.text:SetTextColor(Getcolor())
		tt.text:SetText(prefix..name)

		tt:Show()
	end)

	tooltip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

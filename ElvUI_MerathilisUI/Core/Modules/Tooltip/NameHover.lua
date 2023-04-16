local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local MI = MER:GetModule('MER_Misc')

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

local function AddTargetInfos(self, unit)
	local unitTarget = unit..'target'
	if unit ~= 'player' and UnitExists(unitTarget) then
		local targetColor
		if UnitIsPlayer(unitTarget) and (not E.Retail or not UnitHasVehicleUI(unitTarget)) then
			local _, class = UnitClass(unitTarget)
			targetColor = E:ClassColor(class) or _G.PRIEST_COLOR
		else
			local reaction = UnitReaction(unitTarget, 'player')
			targetColor = _G.FACTION_BAR_COLORS[reaction] or _G.PRIEST_COLOR
		end

		self.target:SetText(' |cffffffff>|r '..' '..UnitName(unitTarget))
		self.target:SetTextColor(targetColor.r, targetColor.g, targetColor.b)
	else
		self.target:SetText('')
	end
end

function MI:LoadnameHover()
	if not E.db.mui.nameHover.enable or IsAddOnLoaded("bdNameHover") then return end

	local db = E.db.mui.nameHover
	local tooltip = CreateFrame("frame", nil)
	tooltip:SetFrameStrata("TOOLTIP")
	tooltip.text = tooltip:CreateFontString(nil, "OVERLAY")
	tooltip.text:FontTemplate(nil, db.fontSize or 7, db.fontOutline or "OUTLINE")

	tooltip.target = tooltip:CreateFontString(nil, "OVERLAY")
	tooltip.target:FontTemplate(nil, db.fontSize or 7, db.fontOutline or "OUTLINE")

	-- Show unit name at mouse
	tooltip:SetScript("OnUpdate", function(tt)
		if GetMouseFocus() and GetMouseFocus():IsForbidden() then tt:Hide() return end
		if GetMouseFocus() and GetMouseFocus():GetName() ~= "WorldFrame" then tt:Hide() return end
		if not UnitExists("mouseover") then tt:Hide() return end

		local x, y = GetCursorPosition()
		tt.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y + 15)

		if E.db.mui.nameHover.targettarget then
			tt.target:SetPoint("LEFT", tt.text, "RIGHT", 0, 0)
		end
	end)

	tooltip:SetScript("OnEvent", function(tt)
		if GetMouseFocus() and GetMouseFocus():GetName() ~= "WorldFrame" then return end

		local name = UnitName("mouseover") or UNKNOWN
		local AFK = UnitIsAFK("mouseover")
		local DND = UnitIsDND("mouseover")
		local prefix = ""

		if AFK then prefix = "|cffFF9900<AFK>|r " end
		if DND then prefix = "|cffFF3333<DND>|r " end

		tt.text:SetTextColor(Getcolor())
		tt.text:SetText(prefix .. name)

		if E.db.mui.nameHover.targettarget then
			AddTargetInfos(tt, "mouseover")
		end

		tt:Show()
	end)

	tooltip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

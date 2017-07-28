local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
local select = select
local floor = math.floor
--WoW API / Variables
local CreateFrame = CreateFrame
local UnitAlternatePowerInfo = UnitAlternatePowerInfo
-- GLOBALS: ElvUF, LeftChatDataPanel, RightChatDataPanel

function MUF:Construct_AltPowerBar(frame)
	local altpower = CreateFrame("StatusBar", nil, frame)
	altpower:SetStatusBarTexture(E["media"].blankTex)
	UF['statusbars'][altpower] = true
	altpower:GetStatusBarTexture():SetHorizTile(false)

	altpower.PostUpdate = UF.AltPowerBarPostUpdate
	altpower:CreateBackdrop("Transparent", true, true)

	altpower.text = altpower:CreateFontString(nil, "OVERLAY")
	altpower.text:Point("CENTER")
	altpower.text:SetJustifyH("CENTER")
	UF:Configure_FontString(altpower.text)

	altpower:SetScript("OnShow", UF.ToggleResourceBar)
	altpower:SetScript("OnHide", UF.ToggleResourceBar)
	
	return altpower
end

function MUF:AltPowerBarPostUpdate(unit, cur, min, max)
	if not self.barType then return end
	local perc = (cur and max and max > 0) and floor((cur/max)*100) or 0
	local parent = self:GetParent()
	local name

	local r, g, b = ElvUF.ColorGradient(cur, max, 0,0.8,0, 0.8,0.8,0, 0.8,0,0)
	self.backdrop:SetBackdropColor(r*0.25, g*0.25, b*0.25)
	self:SetStatusBarColor(r, g, b)
	self:SetMinMaxValues(0, max)
	self:SetValue(cur)

	if unit and unit == "player" and self.text then
		name = self.powerName or "AlternativePower"
		self.text:SetFormattedText("%s: %d%%", name, perc > 0 and perc or 0);
	elseif unit and unit:find("boss%d") and self.text then
		name = parent.Power.value:GetText()
		if not name or name == "" then
			self.text:Point("CENTER", self, "CENTER", 0, E.mult)
		else
			self.text:Point("RIGHT", parent.Power.value, "LEFT", 2, E.mult)
		end
		if perc > 0 then
			self.text:SetTextColor(self:GetStatusBarColor())
			self.text:SetFormattedText("|cffD7BEA5[|r%d%%|cffD7BEA5]|r", perc)
		else
			self.text:SetText(nil)
		end
	end
end

function MUF:Configure_AltPower(frame)
	if not frame.VARIABLES_SET then return end
	local altpower = frame.AlternativePower

	if frame.USE_POWERBAR then
		frame:EnableElement("AlternativePower")
		altpower.text:SetAlpha(1)
		altpower:Point("BOTTOMLEFT", frame.Health.backdrop, "TOPLEFT", frame.BORDER, frame.SPACING+frame.BORDER)
		if not frame.USE_PORTRAIT_OVERLAY then
			altpower:Point("TOPRIGHT", frame, "TOPRIGHT", -(frame.PORTRAIT_WIDTH+frame.BORDER), -frame.BORDER)
		else
			altpower:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.BORDER, -frame.BORDER)
		end
		altpower.Smooth = UF.db.smoothbars
	else
		frame:DisableElement("AlternativePower")
		altpower.text:SetAlpha(0)
		altpower:Hide()
	end
end

function MUF:Configure_AltPowerBar(frame)
	if not frame.VARIABLES_SET then return end
	local altenable = true
	local altpower = frame.AlternativePower

	if E.db.general.threat.position ~= "RIGHTCHAT" then
		altpower:SetInside(RightChatDataPanel)
	else
		altpower:SetInside(LeftChatDataPanel)
	end

	if altenable and not frame:IsElementEnabled("AlternativePower") then
		frame:EnableElement("AlternativePower")
		altpower.Smooth = UF.db.smoothbars
		altpower:SetFrameLevel(4)
		altpower.text:SetAlpha(1)
	elseif not altenable and frame:IsElementEnabled("AlternativePower") then
		frame:DisableElement("AlternativePower")
		altpower.text:SetAlpha(0)
		altpower:Hide()
	end
end
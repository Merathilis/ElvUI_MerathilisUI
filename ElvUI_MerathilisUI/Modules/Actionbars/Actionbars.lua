local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local AB = E:GetModule("ActionBars")

local pairs = pairs

local PixelUtil = PixelUtil

-- LAB anchors the swipe frames with SetAllPoints(icon). The icon texture snaps
-- to the pixel grid, the cooldown swipe does not, so on a UI scale that is not
-- pixel perfect a sub-pixel column of the icon peeks out next to the swipe.
-- Pushing the swipe one physical pixel outward covers that seam; the extra pixel
-- only lies on the (dark) button border.
local function FitCooldown(cooldown, icon)
	if not (cooldown and icon) then
		return
	end

	local scale = cooldown:GetEffectiveScale()
	local pixel = (scale and scale > 0) and (PixelUtil.GetPixelToUIUnitFactor() / scale) or E.mult

	cooldown:ClearAllPoints()
	cooldown:SetPoint("TOPLEFT", icon, "TOPLEFT", -pixel, pixel)
	cooldown:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", pixel, -pixel)
end

function module:FitButtonCooldowns(button)
	if not button or button.useMasque then
		return
	end

	local icon = button.icon
	FitCooldown(button.cooldown, icon)
	FitCooldown(button.lossOfControlCooldown, icon)
end

function module:StyleButton(_, button)
	self:FitButtonCooldowns(button)
end

function module:Initialize()
	if not F.IsElvUIActionBarsEnabled() then
		return
	end

	-- buttons styled before this module loaded, then every later one
	for button in pairs(AB.handledbuttons) do
		self:FitButtonCooldowns(button)
	end
	self:SecureHook(AB, "StyleButton")

	self:CreateSpecBar()
	self:CreateAssistedRotation()
end

MER:RegisterModule(module:GetName())

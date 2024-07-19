local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local min, sqrt = math.min, math.sqrt

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetEffectiveScale = GetEffectiveScale
local UIParent = UIParent

local x, y, speed = 0, 0, 0
local MAX_SPEED = 1024
local SPEED_DECAY = 2048
local SIZE_MODIFIER = 6
local MIN_SIZE = 16

local function isNan(value)
	return value ~= value
end

local function OnUpdate(_, elapsed)
	if isNan(speed) then
		speed = 0
	end
	if isNan(x) then
		x = 0
	end
	if isNan(y) then
		y = 0
	end

	local prevX, prevY = x, y
	x, y = GetCursorPosition()
	local dX, dY = x - prevX, y - prevY

	local distance = sqrt(dX * dX + dY * dY)
	local decayFactor = SPEED_DECAY ^ -elapsed
	speed = min(decayFactor * speed + (1 - decayFactor) * distance / elapsed, MAX_SPEED)

	local size = speed / SIZE_MODIFIER - MIN_SIZE
	if size > 0 then
		local scale = UIParent:GetEffectiveScale()
		module.Texture:SetHeight(size)
		module.Texture:SetWidth(size)
		module.Texture:SetPoint("CENTER", E.UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
		module.Texture:Show()
	else
		module.Texture:Hide()
	end

	module:UpdateColor()
end

function module:UpdateColor()
	local db = E.db.mui.misc.cursor
	local colorDB = { r = 1, g = 1, b = 1, a = 1 }

	if db.colorType == "DEFAULT" then
		colorDB = { r = 0, g = 0.75, b = 0.98 }
	elseif db.colorType == "CLASS" then
		colorDB = _G.RAID_CLASS_COLORS[E.myclass]
	elseif db.colorType == "CUSTOM" then
		colorDB = db.customColor
	end

	module.Texture:SetVertexColor(colorDB.r, colorDB.g, colorDB.b, 1)
end

function module:Cursor()
	if not E.db.mui.misc.cursor.enable then
		return
	end

	module.Frame = CreateFrame("Frame", nil, E.UIParent)
	module.Frame:SetFrameStrata("TOOLTIP")

	module.Texture = module.Frame:CreateTexture(nil, "OVERLAY")
	module.Texture:SetTexture([[Interface\Cooldown\star4]])
	module.Texture:SetBlendMode("ADD")
	module.Texture:SetAlpha(0.5)

	module.Frame:SetScript("OnUpdate", OnUpdate)
	self:UpdateColor()
end

module:AddCallback("Cursor")

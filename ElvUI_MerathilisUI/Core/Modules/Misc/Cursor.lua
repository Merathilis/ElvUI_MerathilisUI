local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Cursor')

local min, sqrt = math.min, math.sqrt

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetEffectiveScale = GetEffectiveScale
local UIParent = UIParent

local x = 0
local y = 0
local speed = 0

local function OnUpdate(_, elapsed)
	if speed + 1 == speed then
		speed = 0
	end
	if x + 1 == x then
		x = 0
	end
	if y + 1 == y then
		y = 0
	end

	local dX = x
	local dY = y

	x, y = GetCursorPosition()
	dX = x - dX
	dY = y - dY

	local weight = 2048 ^ -elapsed
	speed = min(weight * speed + (1 - weight) * sqrt(dX * dX + dY * dY) / elapsed, 1024)

	local size = speed / 6 - 16
	if size > 0 then
		local scale = UIParent:GetEffectiveScale()
		module.Texture:Height(size)
		module.Texture:Width(size)
		module.Texture:Point("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
		module.Texture:Show()
	else
		module.Texture:Hide()
	end

	module:UpdateColor()
end

function module:UpdateColor()
	local db = E.db.mui.misc.cursor
	local colorDB = {r = 1, g = 1, b = 1, a = 1}

	if db.colorType == "DEFAULT" then
		colorDB = {r = 0, g = .75, b = .98}
	elseif db.colorType == "CLASS" then
		colorDB = _G.RAID_CLASS_COLORS[E.myclass]
	elseif db.colorType == "CUSTOM" then
		colorDB = db.customColor
	end

	module.Texture:SetVertexColor(colorDB.r, colorDB.g, colorDB.b, 1)
end

function module:Initialize()
	if not E.db.mui.misc.cursor.enable then return end

	module.Frame = CreateFrame("Frame", nil, E.UIParent)
	module.Frame:SetFrameStrata("TOOLTIP")

	module.Texture = module.Frame:CreateTexture(nil, "OVERLAY")
	module.Texture:SetTexture([[Interface\Cooldown\star4]])
	module.Texture:SetBlendMode("ADD")
	module.Texture:SetAlpha(0.5)

	module.Frame:SetScript("OnUpdate", OnUpdate)
	self:UpdateColor()
end

MER:RegisterModule(module:GetName())

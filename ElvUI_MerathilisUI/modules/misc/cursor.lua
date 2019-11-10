local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("Cursor")

--Cache global variables
--Lua functions
local min, sqrt = math.min, math.sqrt
--WoW API / Variables
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetEffectiveScale = GetEffectiveScale
local UIParent = UIParent
-- GLOBALS:

local x = 0
local y = 0
local speed = 0
local r, g, b = unpack(E.media.rgbvaluecolor)

local function OnUpdate(_, elapsed)
	local dX = x
	local dY = y

	x, y = GetCursorPosition()
	dX = x - dX
	dY = y - dY

	local weight = 2048 ^ -elapsed
	speed = min(weight * speed + (1 - weight) * sqrt(dX * dX + dY * dY) / elapsed, 1024)

	local size = speed / 6 - 16
	if (size > 0) then
		local scale = UIParent:GetEffectiveScale()
		module.Texture:SetHeight(size)
		module.Texture:SetWidth(size)
		module.Texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
		module.Texture:Show()
		module.Texture:SetVertexColor(r, g, b, 0.6)
	else
		module.Texture:Hide()
	end
end

function module:Initialize()
	if E.db.mui.misc.cursor ~= true then return end

	module.Frame = CreateFrame("Frame", nil, UIParent)
	module.Frame:SetFrameStrata("TOOLTIP")

	module.Texture = module.Frame:CreateTexture()
	module.Texture:SetTexture([[Interface\Cooldown\star4]])
	module.Texture:SetBlendMode("ADD")
	module.Texture:SetAlpha(0.5)

	module.Frame:SetScript("OnUpdate", OnUpdate)
end

MER:RegisterModule(module:GetName())

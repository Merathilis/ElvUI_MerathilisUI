local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E.UnitFrames

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MUF:PostUpdateDebuffs(unit, button)
	if not button.pixelBorders then return end

	button:GetParent().spacing = E:Scale(4)
	local r, g, b = E:GetBackdropBorderColor(button)
	local br, bg, bb = E:GrabColorPickerValues(unpack(E.media.unitframeBorderColor))

	if not button.shadow then button:CreateShadow() end

	if button.isDebuff then
		if(not button.isFriend and not button.isPlayer) then
			button.shadow:SetBackdropBorderColor(0.9, 0.1, 0.1)
		else
			if E.BadDispels[button.spellID] and E:IsDispellableByMe(button.dtype) then
				button.shadow:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				local color = (button.dtype and _G.DebuffTypeColor[button.dtype]) or _G.DebuffTypeColor.none
				button.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	else
		if button.isStealable and not button.isFriend then
			button.shadow:SetBackdropBorderColor(0.93, 0.91, 0.55, 1.0)
		else
			button.shadow:SetBackdropBorderColor(unpack(E.media.unitframeBorderColor))
		end
	end
end

function MUF:LoadAuras()
	if E.private.unitframe.enable ~= true then return end

	for _, object in pairs(_G.ElvUF.objects) do
		if object.Debuffs and object.Debuffs.PostUpdateIcon then
			hooksecurefunc(object.Debuffs, "PostUpdateIcon", MUF.PostUpdateDebuffs)
		end
	end
end

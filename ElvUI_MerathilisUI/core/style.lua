local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

-- Cache global varables
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- BenikUI Styles
function MER:StyleOutside(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Outside")
	end
end

function MER:StyleInside(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Inside")
	end
end
function MER:StyleSmall(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Small")
	end
end

function MER:StyleUnder(frame)
	if frame and not frame.style and IsAddOnLoaded("ElvUI_BenikUI") then
		frame:Style("Under")
	end
end

-- Underlines
function MER:Underline(frame, shadow, height)
	local line = CreateFrame("Frame", nil, frame)
	if line then
		line:SetPoint('BOTTOM', frame, -1, 1)
		line:SetSize(frame:GetWidth(), height or 1)
		line.Texture = line:CreateTexture(nil, 'OVERLAY')
		line.Texture:SetTexture(flat)
		line.Texture:SetVertexColor(classColor.r, classColor.g, classColor.b)
		if shadow then
			if shadow == "backdrop" then
				line:CreateShadow()
			else
				line:CreateBackdrop()
			end
		end
		line.Texture:SetAllPoints(line)
	end
	return line
end

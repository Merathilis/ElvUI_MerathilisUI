local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

-- Cache global varables
local IsAddOnLoaded = IsAddOnLoaded
local classColor = RAID_CLASS_COLORS[E.myclass]
local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- BenikUI Styles
if not IsAddOnLoaded("ElvUI_BenikUI") then return end

function MER:StyleOutside(frame)
	if frame and not frame.style then
		frame:Style("Outside")
	end
end

function MER:StyleInside(frame)
	if frame and not frame.style then
		frame:Style("Inside")
	end
end
function MER:StyleSmall(frame)
	if frame and not frame.style then
		frame:Style("Small")
	end
end

function MER:StyleUnder(frame)
	if frame and not frame.style then
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

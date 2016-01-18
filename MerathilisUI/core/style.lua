local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

-- Cache global varables
local IsAddOnLoaded = IsAddOnLoaded

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

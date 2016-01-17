local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

function MER:StyleOutside(frame)
	if not IsAddOnLoaded("ElvUI_BenikUI") then return end
	if frame and not frame.style then
		frame:Style("Outside")
	end
end

function MER:StyleInside(frame)
	if not IsAddOnLoaded("ElvUI_BenikUI") then return end
	if frame and not frame.style then
		frame:Style("Inside")
	end
end
function MER:StyleSmall(frame)
	if not IsAddOnLoaded("ElvUI_BenikUI") then return end
	if frame and not frame.style then
		frame:Style("Small")
	end
end

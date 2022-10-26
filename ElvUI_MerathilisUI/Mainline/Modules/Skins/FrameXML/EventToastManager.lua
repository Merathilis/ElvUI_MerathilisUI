local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("misc", "eventToast") then
		return
	end

	-- e.g. The Torghast Alert thing in the middle.
	hooksecurefunc(_G.EventToastManagerFrame, 'DisplayToast', function(self)
		local toast = self.currentDisplayingToast
		local title = toast and toast.Title
		local gLine = toast and toast.GLine
		local gLine2 = toast and toast.GLine2
		if title then
			title:FontTemplate(nil, 22, 'OUTLINE')
		end
		if gLine then
			gLine:SetVertexColor(F.r, F.g, F.b, 1)
		end
		if gLine2 then
			gLine2:SetVertexColor(F.r, F.g, F.b, 1)
		end
	end)
end

S:AddCallback("EventToastManager", LoadSkin)

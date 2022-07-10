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
		if title then
			title:FontTemplate(nil, 22, 'OUTLINE')
		end
	end)
end

S:AddCallback("EventToastManager", LoadSkin)
local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E.Skins

local _G = _G

function module:EventToastManager()
	if not E.private.skins.blizzard.enable or not E.private.mui.skins.enable or not E.private.mui.skins.blizzard.eventToast then return end

	-- e.g. The Torghast Alert thing in the middle.
	hooksecurefunc(_G.EventToastManagerFrame, 'DisplayToast', function(self)
		local toast = self.currentDisplayingToast
		local title = toast and toast.Title
		if title then
			title:FontTemplate(nil, 22, 'OUTLINE')
		end
	end)
end

module:AddCallback("EventToastManager")
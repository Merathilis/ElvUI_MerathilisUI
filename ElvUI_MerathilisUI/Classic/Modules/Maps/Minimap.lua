local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Minimap')

local _G = _G

function module:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	local db = E.db.mui.maps

	_G.MinimapToggleButton:Kill()

	-- Add a check if the backdrop is there
	if not _G.Minimap.backdrop then
		_G.Minimap:CreateBackdrop("Default", true)
	end
end

MER:RegisterModule(module:GetName())

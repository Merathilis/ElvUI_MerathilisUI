local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERS:ObjectPoolMixin_Acquire(self)
	local template = self.frameTemplate or self.textureTemplate or self.fontStringTemplate or self.actorTemplate
	if template and MERS[template] then
		for obj in self:EnumerateActive() do
			if not obj._auroraSkinned then
				MERS[template](obj)
				obj.Skinned = true
			end
		end
	end
end
local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.animaDiversion ~= true or E.private.muiSkins.blizzard.animaDiversion ~= true then return end

	local frame = _G.AnimaDiversionFrame
	if frame.backdrop then
		frame.backdrop:Styling()
	end

end

S:AddCallbackForAddon("Blizzard_AnimaDiversionUI", "mUIAnimaDiversio", LoadSkin)

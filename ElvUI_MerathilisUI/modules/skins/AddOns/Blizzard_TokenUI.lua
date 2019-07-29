local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function styleToken()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	local function UpdateToken()
		local TokenFramePopup = _G.TokenFramePopup

		if TokenFramePopup.backdrop then
			if not TokenFramePopup.backdrop.styling then
				TokenFramePopup.backdrop:Styling()

				TokenFramePopup.backdrop.styling = true
			end
		end
	end

	hooksecurefunc("TokenFrame_Update", UpdateToken)
	hooksecurefunc(_G.TokenFrameContainer, "update", UpdateToken)
end

S:AddCallbackForAddon("Blizzard_TokenUI", "mUITokenUI", styleToken)

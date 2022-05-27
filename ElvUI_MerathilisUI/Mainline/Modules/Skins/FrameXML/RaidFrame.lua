local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:RaidFrame()
	if E.private.skins.blizzard.enable ~= true then return; end

	local RaidInfoFrame = _G.RaidInfoFrame
	if RaidInfoFrame.backdrop then
		RaidInfoFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(RaidInfoFrame)
end

module:AddCallback("RaidFrame")

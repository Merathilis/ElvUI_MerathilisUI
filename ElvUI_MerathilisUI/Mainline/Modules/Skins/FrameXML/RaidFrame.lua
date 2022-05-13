local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return; end

	local RaidInfoFrame = _G.RaidInfoFrame
	if RaidInfoFrame.backdrop then
		RaidInfoFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(RaidInfoFrame)
end

S:AddCallback("mUIRaidFrame", LoadSkin)

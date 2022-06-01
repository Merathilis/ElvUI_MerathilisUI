local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return; end

	local ReportFrame = _G.ReportFrame
	if not ReportFrame.backdrop then
		ReportFrame:CreateBackdrop('Transparent')
		ReportFrame.backdrop:Styling()
	end
end

S:AddCallback("mUIReportFrame", LoadSkin)

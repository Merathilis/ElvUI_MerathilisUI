local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local ReportFrame = _G.ReportFrame
	ReportFrame:Styling()

	local ShadowContainer = CreateFrame("Frame", nil, ReportFrame)
	ShadowContainer:SetAllPoints(ReportFrame)
	module:CreateShadow(ShadowContainer)
end

S:AddCallback("mUIReportFrame", LoadSkin)

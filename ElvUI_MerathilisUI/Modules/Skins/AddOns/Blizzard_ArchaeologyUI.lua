local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local select, unpack = select, unpack

function module:Blizzard_ArchaeologyUI()
	if not module:CheckDB("archaeology", "Archaeology") then
		return
	end

	local ArchaeologyFrame = _G.ArchaeologyFrame
	module:CreateShadow(ArchaeologyFrame)

	_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameCompletedPageTitle:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameCompletedPageTitleTop:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameCompletedPageTitleMid:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameCompletedPagePageText:SetTextColor(1, 1, 1)
	_G.ArchaeologyFrameSummaryPagePageText:SetTextColor(1, 1, 1)

	for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
		_G["ArchaeologyFrameSummaryPageRace" .. i]:GetRegions():SetTextColor(1, 1, 1)
	end

	for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local bu = _G["ArchaeologyFrameCompletedPageArtifact" .. i]
		bu:GetRegions():Hide()
		select(2, bu:GetRegions()):Hide()
		select(3, bu:GetRegions()):SetTexCoord(unpack(E.TexCoords))
		select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
		select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
		bu:SetTemplate("Transparent")
	end

	_G.ArchaeologyFrameArtifactPageIcon:SetTexCoord(unpack(E.TexCoords))
end

module:AddCallbackForAddon("Blizzard_ArchaeologyUI")

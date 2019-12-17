local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.archaeology ~= true or E.private.muiSkins.blizzard.Archaeology ~= true then return end

	local ArchaeologyFrame = _G.ArchaeologyFrame
	-- Hide the Parchment
	ArchaeologyFrame:DisableDrawLayer("BACKGROUND")

	if ArchaeologyFrame.backdrop then
		ArchaeologyFrame.backdrop:Styling()
	end

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
		_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
	end

	for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
		bu:GetRegions():Hide()
		select(2, bu:GetRegions()):Hide()
		select(3, bu:GetRegions()):SetTexCoord(unpack(E.TexCoords))
		select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
		select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
		bu:CreateBackdrop("Transparent")
		MERS:CreateGradient(bu)
	end

	_G.ArchaeologyFrameArtifactPageIcon:SetTexCoord(unpack(E.TexCoords))
end

S:AddCallbackForAddon("Blizzard_ArchaeologyUI", "mUIArchaeology", LoadSkin)

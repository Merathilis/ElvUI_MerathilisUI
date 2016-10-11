local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local assert, unpack = assert, unpack
local tremove = table.remove
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: UIParent, BigWigs

-- Based on AddOnSkins for BigWigs

local FreeBG = {}
local BigWigsLoaded

local buttonsize = 19

local CreateBG = function()
	local BG = CreateFrame('Frame')
	BG:SetTemplate('Transparent')
	return BG
end

local function freestyle(bar)
	local bg = bar:Get("bigwigs:elvui:barbg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		FreeBG[#FreeBG + 1] = bg
	end

	local ibg = bar:Get("bigwigs:elvui:iconbg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		FreeBG[#FreeBG + 1] = ibg
	end

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame.SetWidth = nil
	bar.candyBarIconFrame:SetPoint('TOPLEFT')
	bar.candyBarIconFrame:SetPoint('BOTTOMLEFT')

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar.SetPoint = nil
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")
end

local function applystyle(bar)
	bar:SetHeight(buttonsize)

	local bg
	if #FreeBG > 0 then
		bg = tremove(FreeBG)
	else
		bg = CreateBG()
	end

	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	bg:SetOutside(bar)
	bg:SetTemplate('Transparent')
	bg:Show()
	bar:Set("bigwigs:elvui:barbg", bg)

	if bar.candyBarIconFrame:GetTexture() then
		local ibg
		if #FreeBG > 0 then
			ibg = tremove(FreeBG)
		else
			ibg = CreateBG()
		end
		ibg:SetParent(bar)
		ibg:SetFrameStrata(bar:GetFrameStrata())
		ibg:SetFrameLevel(bar:GetFrameLevel() - 1)
		ibg:ClearAllPoints()
		ibg:SetOutside(bar.candyBarIconFrame)
		ibg:SetBackdropColor(0, 0, 0, 0)
		ibg:Show()
		bar:Set("bigwigs:elvui:iconbg", ibg)
	end

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = function() end
	bar.candyBarBar:SetStatusBarTexture(LSM:Fetch('statusbar', 'MerathilisFlat'))
	MER:CreateSoftShadow(bar.candyBarBar)

	bar.candyBarBackground:SetTexture(unpack(E['media'].backdropcolor))

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame.SetWidth = function() end

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 0)

	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", 2, 0)
	bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", -2, 0)
end

local function StyleBigWigs(event, addon)
	assert(BigWigs, "AddOn Not Loaded")
	if (IsAddOnLoaded('BigWigs_Plugins') or event == "ADDON_LOADED" and addon == 'BigWigs_Plugins' and E.private.muiSkins.addonSkins.bw) then
		local styleName = MER.Title
		local BigWigsBars = BigWigs:GetPlugin('Bars')
		if BigWigsLoaded then return end
		BigWigsLoaded = true
		BigWigsBars:RegisterBarStyle(styleName, {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return 8 end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return styleName end,
		})
		BigWigsBars:SetBarStyle(styleName)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "BigWigs_Plugins" then
			StyleBigWigs()
			f:UnregisterEvent("ADDON_LOADED")
		end
	end
end)
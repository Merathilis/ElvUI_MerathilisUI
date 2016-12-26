local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local assert, unpack = assert, unpack
local tremove = table.remove
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: UIParent, BigWigs, BigWigsLoader, BigWigsProximityAnchor, BigWigsInfoBox

-- Based on AddOnSkins HalfBar Style. Credits Azilroka

local FreeBackgrounds = {}
local buttonsize = 19
local texture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\MerathilisFeint]]

local barcolor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function CreateBG()
	local BG = CreateFrame('Frame')
	BG:SetTemplate('Transparent')
	return BG
end

local function FreeStyle(bar)
	local bg = bar:Get('bigwigs:MerathilisUI:bg')
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = bg
	end

	local ibg = bar:Get('bigwigs:MerathilisUI:ibg')
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = ibg
	end

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame.SetWidth = nil
    
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar.SetPoint = nil
end

local function ApplyStyleHalfBar(bar)
	local bg
	if #FreeBackgrounds > 0 then
		bg = tremove(FreeBackgrounds)
	else
		bg = CreateBG()
	end

	bar:SetScale(1)
	bar.OldSetScale = bar.SetScale
	bar.SetScale = function() end

	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	bg:SetOutside(bar)
	bg:SetTemplate('Transparent')
	bg:Show()
	bar:Set('bigwigs:MerathilisUI:bg', bg)

	if bar.candyBarIconFrame:GetTexture() then
		local ibg
		if #FreeBackgrounds > 0 then
			ibg = tremove(FreeBackgrounds)
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
		bar:Set('bigwigs:MerathilisUI:ibg', ibg)
	end

	bar:SetHeight(buttonsize / 2)

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = function() end
	bar.candyBarBar:SetStatusBarTexture(texture)
	if not bar.data["bigwigs:emphasized"] == true then
		bar.candyBarBar:SetStatusBarColor(barcolor.r, barcolor.g, barcolor.b, 1)
	end

	bar.candyBarBackground:SetAllPoints()
	bar.candyBarBackground:SetTexture(unpack(E["media"].bordercolor))

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -7, 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = function() end
	bar.candyBarIconFrame:SetTexCoord(unpack(E.TexCoords))

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 10)
	bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 10)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, 10)
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, 10)

	S:HandleIcon(bar.candyBarIconFrame)
end

local function StyleBigWigs(event, addon)
	assert(BigWigs, "AddOn Not Loaded")
	if (IsAddOnLoaded('BigWigs_Plugins') or event == "ADDON_LOADED" and addon == 'BigWigs_Plugins' and E.private.muiSkins.addonSkins.bw) then
		local styleName = MER.Title
		local BigWigsBars = BigWigs:GetPlugin('Bars', true)
		local BigWigsProx = BigWigs:GetPlugin("Proximity", true)
		local BigWigsInfo = BigWigs:GetPlugin("InfoBox", true)
		if BigWigsBars then
			BigWigsBars:RegisterBarStyle(styleName, {
				apiVersion = 1,
				version = 1,
				GetSpacing = function() return 20 end,
				ApplyStyle = ApplyStyleHalfBar,
				BarStopped = FreeStyle,
				GetStyleName = function() return styleName end,
			})
			BigWigsBars:SetBarStyle(styleName)
		end
		if BigWigsProx then
			BigWigsLoader.RegisterMessage("Proximity", "BigWigs_FrameCreated", function()
				BigWigsProximityAnchor:SetTemplate("Transparent")
			end)
		end
		if BigWigsInfo then
			BigWigsLoader.RegisterMessage("InfoBox", "BigWigs_FrameCreated", function()
				BigWigsInfoBox:SetTemplate("Transparent")
			end)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "BigWigs_Plugins" then
			StyleBigWigs()
			f:UnregisterEvent("ADDON_LOADED")
		end
	end
end)
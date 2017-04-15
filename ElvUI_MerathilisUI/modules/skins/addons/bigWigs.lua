local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local S = E:GetModule("Skins");

-- Cache global variables
-- Lua functions
local assert, unpack = assert, unpack
local tremove = table.remove
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: UIParent, BigWigs, BigWigsLoader, BigWigsProximityAnchor, BigWigsInfoBox

local FreeBackgrounds = {}
local buttonsize = 18

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

	-- replace dummies with original method functions
	bar.candyBarBar.SetPoint = bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame.SetWidth = bar.candyBarIconFrame.OldSetWidth
	bar.SetScale = bar.OldSetScale
end

local function ApplyStyle(bar)
	local bg = nil
	if #FreeBackgrounds > 0 then
		bg = tremove(FreeBackgrounds)
	else
		bg = CreateBG()
	end
	bar:SetScale(1)
	bar:SetHeight(buttonsize)
	bar.OldSetScale = bar.SetScale
	bar.SetScale = MER.dummy
	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
	bg:SetTemplate('Transparent')
	bg:Show()
	bar:Set('bigwigs:MerathilisUI:bg', bg)
	if bar.candyBarIconFrame:GetTexture() then
		local ibg = nil
		if #FreeBackgrounds > 0 then
			ibg = tremove(FreeBackgrounds)
		else
			ibg = CreateBG()
		end
		ibg:SetParent(bar)
		ibg:SetFrameStrata(bar:GetFrameStrata())
		ibg:SetFrameLevel(bar:GetFrameLevel() - 1)
		ibg:ClearAllPoints()
		ibg:SetPoint("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -2, 2)
		ibg:SetPoint("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 2, -2)
		ibg:SetBackdropColor(0, 0, 0, 0)
		ibg:Show()
		bar:Set('bigwigs:MerathilisUI:ibg', ibg)
	end

	-- setup bar positions and look
	bar:SetHeight(buttonsize)
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = MER.dummy
	bar.candyBarBar:SetStatusBarTexture(E['media'].muiFlat)
	if not bar.data["bigwigs:emphasized"] == true then
		bar.candyBarBar:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, 1)
	end

	-- setup icon positions and other things
	bar.candyBarBackground:SetAllPoints()
	bar.candyBarBackground:SetTexture(unpack(E["media"].bordercolor))
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -buttonsize - buttonsize/3 , 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = MER.dummy
	bar.candyBarIconFrame:SetTexCoord(unpack(E.TexCoords))

	-- setup timer and bar name fonts and positions
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 2, -14)
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", -2, -14)
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
				GetSpacing = function() return 10 end,
				ApplyStyle = ApplyStyle,
				BarStopped = FreeStyle,
				GetStyleName = function() return styleName end,
			})
			BigWigsBars.defaultDB.barStyle = styleName
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

		local profile = BigWigs3DB["profileKeys"][E.myname.." - "..E.myrealm]
		local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profile]
		path.texture = "MerathilisLight"
		path.barStyle = styleName
		path.font = "Merathilis Roboto-Bold"
		path.outline = "OUTLINE"

		local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profile]
		path.font = "Merathilis Roboto-Bold"
		path.outline = "OUTLINE"

		local path = BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profile]
		path.font = "Merathilis Roboto-Bold"
		path.outline = "OUTLINE"

	elseif event == "PLAYER_ENTERING_WORLD" then
		LoadAddOn("BigWigs")
		LoadAddOn("BigWigs_Core")
		LoadAddOn("BigWigs_Plugins")
		LoadAddOn("BigWigs_Options")
		if not BigWigs then return end
		BigWigs:Enable()
		BigWigsOptions:SendMessage("BigWigs_StartConfigureMode", true)
		BigWigsOptions:SendMessage("BigWigs_StopConfigureMode")
	end
end

S:AddCallbackForAddon("BigWigs_Plugins", "mUIBigWigs", StyleBigWigs)
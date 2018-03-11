local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local assert, select, unpack = assert, select, unpack
local tremove = table.remove
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: UIParent, BigWigs, BigWigsLoader, BigWigsProximityAnchor, BigWigsInfoBox

local FreeBackgrounds = {}
local buttonsize = 18

local function CreateBG()
	local BG = CreateFrame("Frame")
	BG:SetTemplate("Transparent")
	BG:Styling()
	return BG
end

local function FreeStyle(bar)
	local bg = bar:Get("bigwigs:MerathilisUI:bg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = bg
	end

	local ibg = bar:Get("bigwigs:MerathilisUI:ibg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = ibg
	end

	--Reset Positions
	--Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame.SetWidth = nil
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	--Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar.SetPoint = nil
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	--BG
	bar.candyBarBackground:SetAllPoints()

	-- Duration
	-- bar.candyBarDuration:ClearAllPoints()
	-- bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

	-- Name
	-- bar.candyBarLabel:ClearAllPoints()
	-- bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	-- bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
end

local function ApplyStyle(bar)
	-- general bar settings
	bar:SetHeight(buttonsize)

	local bg
	if #FreeBackgrounds > 0 then
		bg = tremove(FreeBackgrounds)
	else
		bg = CreateBG()
	end

	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	bg:SetOutside(bar)
	bg:SetTemplate("Transparent")
	bg:Show()
	bar:Set("bigwigs:MerathilisUI:bg", bg)

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
		bar:Set("bigwigs:MerathilisUI:ibg", ibg)
	end

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = MER.dummy
	if not bar.data["bigwigs:emphasized"] == true then
		bar.candyBarBar:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, 1)
	end

	bar.candyBarBackground:SetTexture(unpack(E["media"].backdropcolor))

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -3, 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame.SetWidth = MER.dummy
	bar.candyBarIconFrame:SetTexCoord(unpack(E.TexCoords))

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 0)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, 0)
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
end

local f = CreateFrame("Frame")
local function RegisterStyle()
	if not BigWigs then return end
	local styleName = MER.Title or "MerathilisUI"
	local bars = BigWigs:GetPlugin("Bars", true)
	if not bars then return end
	bars:RegisterBarStyle(styleName, {
		apiVersion = 1,
		version = 1,
		GetSpacing = function() return 4 end,
		ApplyStyle = ApplyStyle,
		BarStopped = FreeStyle,
		GetStyleName = function() return styleName end,
	})
	bars.defaultDB.barStyle = styleName
end
f:RegisterEvent("ADDON_LOADED")

local reason = nil
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		if not reason then reason = (select(6, GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and msg == "BigWigs") or msg == "BigWigs_Plugins" then
			RegisterStyle()
		end
	end
end)

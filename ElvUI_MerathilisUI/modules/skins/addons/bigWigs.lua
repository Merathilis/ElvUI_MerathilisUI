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
	local BG = CreateFrame("Frame")
	BG:SetTemplate("Transparent")
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
end

local function ApplyStyle(bar)
	local bg = nil
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
	bg:SetTemplate('Transparent')
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

	bar:SetHeight(buttonsize / 2)

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = MER.dummy
	bar.candyBarBar:SetStatusBarTexture(E["media"].muiBlank)
	if not bar.data["bigwigs:emphasized"] == true then
		bar.candyBarBar:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, 1)
	end

	bar.candyBarBackground:SetTexture(unpack(E["media"].backdropcolor))

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
	bar.candyBarIconFrame.SetWidth = MER.dummy

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 10)
	bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 10)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, 10)
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, 10)

	S:HandleIcon(bar.candyBarIconFrame)
end

local f = CreateFrame("Frame")
local function StyleBigWigs()
	if not BigWigs then return end
	if E.private.muiSkins.addonSkins.bw ~= true then return end

	local styleName = MER.Title
	local bars = BigWigs:GetPlugin("Bars", true)
	if not bars then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:UnregisterEvent("PLAYER_LOGIN")
	bars:RegisterBarStyle(styleName, {
		apiVersion = 1,
		version = 1,
		GetSpacing = function() return 18 end,
		ApplyStyle = ApplyStyle,
		BarStopped = FreeStyle,
		GetStyleName = function() return styleName end,
	})
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")

local reason = nil
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		if not reason then reason = (select(6, GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and msg == "BigWigs") or msg == "BigWigs_Plugins" then
			StyleBigWigs()
		end
	elseif event == "PLAYER_LOGIN" then
		StyleBigWigs()
	end
end)
local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local assert, next, unpack = assert, next, unpack
local tremove = table.remove
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: UIParent, BigWigs, BigWigsLoader

local BigWigsLoaded
local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local textureNormal = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Normal"

local backdropbc = {
	bgFile = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Flat",
	insets = {top = 1, left = 1, bottom = 1, right = 1},
}

local function createBorder(self)
	local border = UIParent:CreateTexture(nil, "OVERLAY")
	border:SetParent(self)
	border:SetTexture(textureNormal)
	border:SetWidth(10)
	border:SetHeight(10)
	border:SetVertexColor(classColor.r, classColor.g, classColor.b)
	return border
end

local freeBorderSets = {}

local function freeStyle(bar)
	local borders = bar:Get("bigwigs:MerathilisUI:borders")
	if borders then
		for i, border in next, borders do
			border:SetParent(UIParent)
			border:Hide()
		end
		freeBorderSets[#freeBorderSets + 1] = borders
	end
end

local function styleBar(bar)
	local bd = bar.candyBarBackdrop

	bd:SetBackdrop(backdropbc)
	bd:SetBackdropColor(0, 0, 0, 0.8)

	bd:SetFrameStrata(bar:GetFrameStrata())
	bd:SetFrameLevel(bar:GetFrameLevel() - 1)
	bd:ClearAllPoints()
	bd:SetOutside(bar)
	bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
	bd:Show()

	local borders = nil
	if #freeBorderSets > 0 then
		borders = tremove(freeBorderSets)
		for i, border in next, borders do
			border:SetParent(bar.candyBarBar)
			border:ClearAllPoints()
			border:Show()
		end
	else
		borders = {}
		for i = 1, 8 do
			borders[i] = createBorder(bar.candyBarBar)
		end
	end
	for i, border in next, borders do
		if i == 1 then
			border:SetTexCoord(0, 1/3, 0, 1/3)
			border:SetPoint("TOPLEFT", -18, 4)
		elseif i == 2 then
			border:SetTexCoord(2/3, 1, 0, 1/3)
			border:SetPoint("TOPRIGHT", 4, 4)
		elseif i == 3 then
			border:SetTexCoord(0, 1/3, 2/3, 1)
			border:SetPoint("BOTTOMLEFT", -18, -4)
		elseif i == 4 then
			border:SetTexCoord(2/3, 1, 2/3, 1)
			border:SetPoint("BOTTOMRIGHT", 4, -4)
		elseif i == 5 then
			border:SetTexCoord(1/3, 2/3, 0, 1/3)
			border:SetPoint("TOPLEFT", borders[1], "TOPRIGHT")
			border:SetPoint("TOPRIGHT", borders[2], "TOPLEFT")
		elseif i == 6 then
			border:SetTexCoord(1/3, 2/3, 2/3, 1)
			border:SetPoint("BOTTOMLEFT", borders[3], "BOTTOMRIGHT")
			border:SetPoint("BOTTOMRIGHT", borders[4], "BOTTOMLEFT")
		elseif i == 7 then
			border:SetTexCoord(0, 1/3, 1/3, 2/3)
			border:SetPoint("TOPLEFT", borders[1], "BOTTOMLEFT")
			border:SetPoint("BOTTOMLEFT", borders[3], "TOPLEFT")
		elseif i == 8 then
			border:SetTexCoord(2/3, 1, 1/3, 2/3)
			border:SetPoint("TOPRIGHT", borders[2], "BOTTOMRIGHT")
			border:SetPoint("BOTTOMRIGHT", borders[4], "TOPRIGHT")
		end
	end

	bar:Set("bigwigs:MerathilisUI:borders", borders)
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
			ApplyStyle = styleBar,
			BarStopped = freeStyle,
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
	if event == 'PLAYER_ENTERING_WORLD' then
		if BigWigsLoader then
			BigWigsLoader.RegisterMessage('ElvUI_MerathilisUI', "BigWigs_FrameCreated", function(event, frame, name)
				if name == "QueueTimer" then
					S:HandleStatusBar(frame)
					frame:ClearAllPoints()
					frame:SetPoint('TOP', '$parent', 'BOTTOM', 0, -(E.PixelMode and 2 or 4))
					frame:SetHeight(16)
				end
			end)
		end
	end
end)
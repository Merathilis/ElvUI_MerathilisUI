local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local pairs, select, unpack = pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: WeakAuras, hooksecurefunc

-- WEAKAURAS SKIN
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	if not IsAddOnLoaded("WeakAuras") or not E.private.muiSkins.addonSkins.wa then return end

	local function SkinWeakAuras(frame)
		if frame.SetBackdropColor then
			frame:SetBackdrop({bgFile = E.media.normTex, edgeFile = E.media.normTex, edgeSize = 1})
			frame:SetBackdropColor(0, 0, 0, 0.1)
			frame:SetBackdropBorderColor(0, 0, 0, 1)
		end

		if frame.icon then
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame.icon.SetTexCoord = MER.dummy
		end

		if frame.cooldown then
			frame.cooldown:GetRegions():Point("CENTER", 1, 1)
		end
	end

	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	local CreateIcon = WeakAuras.regionTypes.icon.create
	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = CreateIcon(parent, data)
		SkinWeakAuras(region, "icon")
		return region
	end

	local ModifyIcon = WeakAuras.regionTypes.icon.modify
	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		ModifyIcon(parent, region, data)
		SkinWeakAuras(region, "icon")
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' then
			SkinWeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end)
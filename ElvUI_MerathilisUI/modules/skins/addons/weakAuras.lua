local MER, E, L, V, P, G = unpack(select(2, ...))
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

	local flat = "Interface\\Buttons\\WHITE8x8"
	local font = E.media.normFont

	local function SkinWeakAuras(frame)
		if frame.SetBackdropColor then
			frame:SetBackdrop({bgFile = flat, edgeFile = flat, edgeSize = 1})
			frame:SetBackdropColor(0, 0, 0, 0.1)
			frame:SetBackdropBorderColor(0, 0, 0, 1)
		end

		if frame.icon then
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame.icon.SetTexCoord = MER.dummy
			if frame.border and not frame.bar then
				frame.border:Hide()
			end
		end

		if frame.bar then
			if not frame.bar.shadow then
				frame.bar:CreateShadow("Background")
				frame.iconFrame:CreateShadow("Background")
				frame.iconFrame:SetAllPoints(frame.icon)
				frame.icon:SetTexCoord(unpack(E.TexCoords))
				frame.icon.SetTexCoord = MER.dummy
			end
		end

		if frame.stacks then
			local fontHeight = select(3, frame.stacks:GetFont())
			if (not tonumber(fontHeight) or not fontHeight >0) then fontHeight = 14 end
			frame.stacks:SetFont(font, fontHeight, "OUTLINE")
		end

		if frame.timer then
			local fontHeight = select(3, frame.timer:GetFont())
			if (not tonumber(fontHeight) or not fontHeight >0) then fontHeight = 14 end
			frame.timer:SetFont(font, fontHeight, "OUTLINE")
		end

		if frame.text then
			local fontHeight = select(3, frame.text:GetFont())
			if (not tonumber(fontHeight) or not fontHeight >0) then fontHeight = 18 end
			frame.text:SetFont(font, fontHeight, "OUTLINE")
		end

		if frame.cooldown then
			local fontHeight = select(3, frame.cooldown:GetRegions():GetFont())
			if (not tonumber(fontHeight) or not fontHeight >0) then fontHeight = 22 end
			frame.cooldown:GetRegions():SetFont(font, fontHeight, "OUTLINE")
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

	local CreateAuraBar = WeakAuras.regionTypes.aurabar.create
	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = CreateAuraBar(parent)
		SkinWeakAuras(region, "aurabar")
		return region
	end

	local ModifyAuraBar = WeakAuras.regionTypes.aurabar.modify
	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		ModifyAuraBar(parent, region, data)
		SkinWeakAuras(region, "aurabar")
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' or WeakAuras.regions[weakAura].regionType == 'aurabar' then
			SkinWeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end)
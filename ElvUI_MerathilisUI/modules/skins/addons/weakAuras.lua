local MER, E, L, V, P, G = unpack(select(2, ...))

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

	local function SkinWeakAuras(frame, ftype)
		if ftype == "icon" then
			if not frame.shadow then
				frame:CreateShadow("Background")
				frame.icon:SetTexCoord(unpack(E.TexCoords))
				frame.icon.SetTexCoord = MER.dummy
				E:RegisterCooldown(frame.cooldown)
			end
		end

		if ftype == "aurabar" then
			if not frame.bar.shadow then
				frame.bar:CreateShadow("Background")
				frame.iconFrame:CreateShadow("Background")
				frame.iconFrame:SetAllPoints(frame.icon)
				frame.icon:SetTexCoord(unpack(E.TexCoords))
				frame.icon.SetTexCoord = MER.dummy
				hooksecurefunc(frame.bar, "SetForegroundColor", function(self, r, g, b, a)
					self.fg:SetGradient("VERTICAL", MER:GetGradientColor(r, g, b))
				end)
				hooksecurefunc(frame.bar, "SetBackgroundColor", function(self, r, g, b, a)
					self.bg:SetGradient("VERTICAL", MER:GetGradientColor(r, g, b))
				end)
			end
		end
	end


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

	for aura, _ in pairs(WeakAuras.regions) do
		local ftype = WeakAuras.regions[aura].regionType

		if ftype == "icon" or ftype == "aurabar" then
			SkinWeakAuras(WeakAuras.regions[aura].region, ftype)
		end
	end
end)
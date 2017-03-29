local E, L, V, P, G = unpack(ElvUI);
local MERS = E:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables

-- GLOBALS: WeakAuras

-- WEAKAURAS SKIN
local WeakAura_Skin = CreateFrame("Frame")
WeakAura_Skin:RegisterEvent("PLAYER_LOGIN")
WeakAura_Skin:SetScript("OnEvent", function(self, event)
	local function Skin_WeakAuras(frame, ftype)
		if not frame.Backdrop then
			MERS:CreateBackdrop(frame, "Transparent")
			MERS:SkinTexture(frame.icon)

			if frame.icon then
				frame.icon:SetTexCoord(unpack(E.TexCoords))
				frame.icon.SetTexCoord = function () end
			end

			if ftype == "icon" then
				frame.Backdrop:HookScript("OnUpdate", function(self)
					self:SetAlpha(self:GetParent().icon:GetAlpha())
				end)
			end
		end

		if ftype == "aurabar" then
			frame.Backdrop:Hide()
		end

		if frame.border then
			frame.border:Hide()
		end

		if frame.bar then
			frame.bar.fg:SetTexture(E["media"].normTex)
			frame.bar.bg:SetTexture(E["media"].blankTex)
		end
	end

	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == "icon" or WeakAuras.regions[weakAura].regionType == "aurabar" then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end)
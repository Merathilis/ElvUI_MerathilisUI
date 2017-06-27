local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local pairs, select, unpack = pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: WeakAuras

-- WEAKAURAS SKIN
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	if not IsAddOnLoaded("WeakAuras") or not E.private.muiSkins.addonSkins.wa then return end

	local function CreateBackdrop(frame)
		if frame.backdrop then return end

		local backdrop = CreateFrame("Frame", nil, frame)
		backdrop:ClearAllPoints()
		backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
		backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

		backdrop:SetBackdrop({
			edgeFile = E["media"].muiFlat,
			edgeSize = E.mult,
			insets = { left = E.mult, right = E.mult, top = E.mult, bottom = E.mult },
		})

		backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		backdrop:SetBackdropColor(0, 0, 0, 1)

		if frame:GetFrameLevel() - 1 >= 0 then
			backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
		else
			backdrop:SetFrameLevel(0)
		end

		frame.backdrop = backdrop
	end

	local function SkinWeakAuras(frame, ftype)
		if not frame.backdrop then
			CreateBackdrop(frame, "Transparent")

			if ftype == "icon" then
				frame.backdrop:HookScript("OnUpdate", function(self)
					self:SetAlpha(self:GetParent().icon:GetAlpha())
				end)
			end
		end

		if ftype == "aurabar" then
			frame.backdrop:Hide()
		end

		if ftype == "icon" then
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			E:RegisterCooldown(frame.cooldown)
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
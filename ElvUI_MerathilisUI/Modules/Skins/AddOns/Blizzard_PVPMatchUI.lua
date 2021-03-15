local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
--Lua Variables
local _G = _G
local pairs, type, unpack = pairs, type, unpack
local format = string.format
local setmetatable = setmetatable
local strsplit = string.split
--WoW API / Variables
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local hooksecurefunc = hooksecurefunc
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local UnitName = UnitName
-- GLOBALS:

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local function Hex(r, g, b)
	if type(r) == "table" then
		if (r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end

	if not r or not g or not b then
		r, g, b = 1, 1, 1
	end

	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local WHITE_HEX = "|cffffffff"

local classColor = setmetatable({}, {
	__index = function(t, i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if c then
			t[i] = Hex(c)
			return t[i]
		else
			return WHITE_HEX
		end
	end
})

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.pvp ~= true or E.private.muiSkins.blizzard.pvp ~= true then return end

	local PVPMatchScoreboard = _G.PVPMatchScoreboard
	PVPMatchScoreboard.backdrop:Styling()
	MER:CreateBackdropShadow(PVPMatchScoreboard)

	local PVPMatchResults = _G.PVPMatchResults
	PVPMatchResults.backdrop:Styling()
	MER:CreateBackdropShadow(PVPMatchResults)

	-- PVPMatchResults -- Credits ShestakUI
	hooksecurefunc(_G.PVPCellNameMixin, "Populate", function(self, rowData)
		local name = rowData.name
		local className = rowData.className or ""
		local n, r = strsplit("-", name, 2)
		n = classColor[className]..n.."|r"

		if name == UnitName("player") then
			n = ">>> "..n.." <<<"
		end

		if r then
			local color
			local faction = rowData.faction
			local inArena = IsActiveBattlefieldArena()
			if inArena then
				if faction == 1 then
					color = "|cffffd100"
				else
					color = "|cff19ff19"
				end
			else
				if faction == 1 then
					color = "|cff00adf0"
				else
					color = "|cffff1919"
				end
			end
			r = color..r.."|r"
			n = n.."|cffffffff - |r"..r
		end

		local text = self.text
		text:SetText(n)
	end)
end

S:AddCallbackForAddon("Blizzard_PVPMatch", "mUIPVPMatch", LoadSkin)

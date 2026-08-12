local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local format = format
local GetTime = GetTime
local strfind = strfind
local date = date
local utf8sub = string.utf8sub or utf8sub

local GetAtlasInfo = C_Texture.GetAtlasInfo
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local GetVignettePosition = C_VignetteInfo.GetVignettePosition
local InCombatLockdown = InCombatLockdown
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local IsPartyWalkIn = C_PartyInfo.IsPartyWalkIn
local PlaySound = PlaySound

local function isUsefulAtlas(info)
	local atlas = info.atlasName
	if not atlas then
		return false
	end
	return strfind(atlas, "[Vv]ignette") or atlas == "nazjatar-nagaevent"
end

local VignetteExclusionMapIDs = {
	[579] = true, -- Lunarfall: Alliance garrison
	[585] = true, -- Frostwall: Horde garrison
	[646] = true, -- Scenario: The Broken Shore
}

function module:VIGNETTE_MINIMAP_UPDATED(_, vignetteGUID, onMinimap)
	if not onMinimap then
		return
	end

	local db = E.db.mui.notification
	if not db or not db.enable or not db.vignette or not db.vignette.enable or InCombatLockdown() then
		return
	end

	local mapID = GetBestMapForUnit("player")
	if VignetteExclusionMapIDs[mapID] then
		return
	end

	if IsInGroup() or IsInRaid() or IsPartyLFG() or IsPartyWalkIn() then
		return
	end

	local vignetteInfo = GetVignetteInfo(vignetteGUID)
	if not vignetteInfo then
		return
	end

	if db.vignette.blacklist[vignetteInfo.vignetteID] or not isUsefulAtlas(vignetteInfo) then
		return
	end

	local atlasInfo = GetAtlasInfo(vignetteInfo.atlasName)
	if not atlasInfo then
		return
	end

	local tex = F.GetTextureStrByAtlas(atlasInfo, 15, 15)
	if not tex then
		return
	end

	if vignetteGUID == self.lastMinimapRare.id then
		return
	end

	local time = GetTime()
	if time <= (self.lastMinimapRare.time + (db.timeOut or 20)) then
		self.lastMinimapRare.id = vignetteGUID
		return
	end

	local displayName = format("|cff00c0fa%s|r", utf8sub(vignetteInfo.name, 1, 28))
	self:DisplayToast(displayName, L["has appeared on the MiniMap!"], nil, vignetteInfo.atlasName)

	if db.vignette.debugPrint then
		F.DebugPrint(
			"Vignette-ID: " .. vignetteInfo.vignetteID .. " Vignette-Name: " .. vignetteInfo.name,
			"warning"
		)
	end

	if db.vignette.print then
		local currentTime = E.db.chat.timeStampFormat == 1 and ("|cff00ff00[" .. date("%H:%M:%S") .. "]|r") or ""
		local nameString
		local position = mapID and GetVignettePosition(vignetteInfo.vignetteGUID, mapID)
		if position then
			local x, y = position:GetXY()
			nameString = format(
				"|Hworldmap:%d+:%d+:%d+|h[%s (%.1f, %.1f)%s]|h|r",
				mapID,
				x * 10000,
				y * 10000,
				vignetteInfo.name,
				x * 100,
				y * 100,
				""
			)
		end
		F.Print(currentTime .. " -> " .. tex .. F.String.MERATHILISUI(nameString or vignetteInfo.name or ""))
	end

	if not db.noSound then
		PlaySound(_G.SOUNDKIT.RAID_WARNING)
	end

	self.lastMinimapRare.time = time
	self.lastMinimapRare.id = vignetteGUID
end

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local format = string.format
local GetTime = GetTime
local utf8sub = utf8sub

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
	if atlas then
		return strfind(atlas, "[Vv]ignette") or (atlas == "nazjatar-nagaevent")
	end
end

local VignetteExclusionMapIDs = {
	[579] = true, -- Lunarfall: Alliance garrison
	[585] = true, -- Frostwall: Horde garrison
	[646] = true, -- Scenario: The Broken Shore
}

local SOUND_TIMEOUT = 20
function module:VIGNETTE_MINIMAP_UPDATED(event, vignetteGUID, onMinimap)
	local db = E.db.mui.notification
	if
		db and not db.enable
		or (not db.vignette or not db.vignette.enable)
		or InCombatLockdown()
		or VignetteExclusionMapIDs[GetBestMapForUnit("player")]
	then
		return
	end

	local inGroup, inRaid, inPartyLFG = IsInGroup(), IsInRaid(), IsPartyLFG() or IsPartyWalkIn()
	if inGroup or inRaid or inPartyLFG then
		return
	end

	if onMinimap then
		local vignetteInfo = GetVignetteInfo(vignetteGUID)
		if not vignetteInfo then
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

		if db.vignette and db.vignette.blacklist[vignetteInfo.vignetteID] or not isUsefulAtlas(vignetteInfo) then
			return
		end

		if vignetteInfo and vignetteGUID ~= self.lastMinimapRare.id then
			vignetteInfo.name = format("|cff00c0fa%s|r", vignetteInfo.name:utf8sub(1, 28))
			self:DisplayToast(vignetteInfo.name, L["has appeared on the MiniMap!"], nil, vignetteInfo.atlasName)
			self.lastMinimapRare.id = vignetteGUID

			if db.vignette.debugPrint then
				F.DebugPrint(
					"Vignette-ID: " .. vignetteInfo.vignetteID .. " Vignette-Name: " .. vignetteInfo.name,
					"warning"
				)
			end

			if db.vignette and db.vignette.enable and db.vignette.print then
				local currentTime = E.db.chat.timeStampFormat == 1 and "|cff00ff00[" .. date("%H:%M:%S") .. "]|r" or ""
				local nameString
				local mapID = GetBestMapForUnit("player")
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

			local time = GetTime()
			if time > (self.lastMinimapRare.time + SOUND_TIMEOUT) then
				if db.noSound ~= true then
					PlaySound(_G.SOUNDKIT.RAID_WARNING)
					self.lastMinimapRare.time = time
				end
			end
		end
	end
end

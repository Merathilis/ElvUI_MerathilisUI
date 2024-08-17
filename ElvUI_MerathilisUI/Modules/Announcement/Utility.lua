local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Announcement")

local gsub = gsub
local tostring = tostring

local GetSpellLink = C_Spell.GetSpellLink

local BotList = {
	[22700] = true,
	[44389] = true,
	[54711] = true,
	[67826] = true,
	[126459] = true,
	[157066] = true,
	[161414] = true,
	[199109] = true,
	[200061] = true,
	[200204] = true,
	[200205] = true,
	[200210] = true,
	[200211] = true,
	[200212] = true,
	[200214] = true,
	[200215] = true,
	[200216] = true,
	[200217] = true,
	[200218] = true,
	[200219] = true,
	[200220] = true,
	[200221] = true,
	[200222] = true,
	[200223] = true,
	[200225] = true,
	[226241] = true,
	[256230] = true,
	[298926] = true,
	[324029] = true,
}

local FeastList = {
	[104958] = true,
	[126492] = true,
	[126494] = true,
	[126495] = true,
	[126496] = true,
	[126497] = true,
	[126498] = true,
	[126499] = true,
	[126500] = true,
	[126501] = true,
	[126502] = true,
	[126503] = true,
	[126504] = true,
	[145166] = true,
	[145169] = true,
	[145196] = true,
	[188036] = true,
	[201351] = true,
	[201352] = true,
	[259409] = true,
	[259410] = true,
	[276972] = true,
	[286050] = true,
	[297048] = true,
	[298861] = true,
	[307157] = true,
	[308458] = true,
	[308462] = true,
	[359336] = true,
	[382423] = true,
	[382427] = true,
	[383063] = true,
}

local PortalList = {
	[10059] = true,
	[11416] = true,
	[11419] = true,
	[32266] = true,
	[33691] = true,
	[49360] = true,
	[88345] = true,
	[132620] = true,
	[176246] = true,
	[281400] = true,

	[11417] = true,
	[11418] = true,
	[11420] = true,
	[32267] = true,
	[35717] = true,
	[49361] = true,
	[88346] = true,
	[132626] = true,
	[176244] = true,
	[281402] = true,

	[53142] = true,
	[120146] = true,
	[224871] = true,
	[344597] = true,
	[395289] = true,
}

local ToyList = {
	[61031] = true,
	[49844] = true,
}

local HeroList = {
	[2825] = true, -- Bloodlust
	[32182] = true, -- Heroism
	[80353] = true, -- Time Warp
	[264667] = true, -- Primal Rage
	[390386] = true, -- Fury of the Aspects(Dracthyr Evoker DF)
	[1626] = true, -- Primal Rage
	[275200] = true, -- Primal Rage
	[204276] = true, -- Primal Rage
	[357650] = true, -- Primal Rage | Raiva Primeva(PTBR)
	[272678] = true, -- Primal Rage
	[293076] = true, -- Mallet of Thunderous Skins

	[178207] = true, -- Drums of Fury
	[256740] = true, -- Drums of the Maelstrom
	[230935] = true, -- Drums of the Mountain
	[309658] = true, -- Drums of Deathly Ferocity
	[146613] = true, -- Drums of Rage
}

local function FormatMessage(message, name, id)
	message = gsub(message, "%%player%%", name)
	message = gsub(message, "%%spell%%", GetSpellLink(id))
	return message
end

local function TryAnnounce(spellId, sourceName, id, list, type)
	if not module.db or not module.db.utility then
		return
	end

	local channelConfig = module.db.utility.channel
	local spellConfig = (type and module.db.utility.spells[type]) or (id and module.db.utility.spells[tostring(id)])

	if not spellConfig or not channelConfig then
		return
	end

	if (id and spellId == id) or (type and list[spellId]) then
		if spellConfig.enable and (sourceName ~= E.myname or spellConfig.includePlayer) then
			module:SendMessage(
				FormatMessage(spellConfig.text, sourceName, spellId),
				module:GetChannel(channelConfig),
				spellConfig.raidWarning
			)
		end
		return true
	end

	return false
end

function module:Utility(event, sourceName, spellId)
	local config = self.db.utility

	if not config or not config.enable then
		return
	end

	if not event or not spellId or not sourceName then
		return
	end

	local groupStatus = self:IsGroupMember(sourceName)
	if not groupStatus or groupStatus == 3 then
		return
	end

	if not self:CheckAuthority("UTILITY") then
		return
	end

	sourceName = sourceName:gsub("%-[^|]+", "")

	if event == "SPELL_CAST_SUCCESS" then
		if TryAnnounce(spellId, sourceName, 190336) then
			return
		end
		if TryAnnounce(spellId, sourceName, nil, FeastList, "feasts") then
			return
		end
		if TryAnnounce(spellId, sourceName, nil, HeroList, "hero") then
			return
		end
	elseif event == "SPELL_SUMMON" then
		if TryAnnounce(spellId, sourceName, nil, BotList, "bots") then
			return
		end

		if TryAnnounce(spellId, sourceName, 261602) then
			return
		end
		if TryAnnounce(spellId, sourceName, 376664) then
			return
		end
		if TryAnnounce(spellId, sourceName, 195782) then
			return
		end
	elseif event == "SPELL_CREATE" then
		if TryAnnounce(spellId, sourceName, 698) then
			return
		end
		if TryAnnounce(spellId, sourceName, 54710) then
			return
		end -- MOLL-E
		if TryAnnounce(spellId, sourceName, 29893) then
			return
		end
		if TryAnnounce(spellId, sourceName, nil, ToyList, "toys") then
			return
		end
		if TryAnnounce(spellId, sourceName, nil, PortalList, "portals") then
			return
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		if TryAnnounce(spellId, sourceName, 384911) then
			return
		end
		if TryAnnounce(spellId, sourceName, 290154) then
			return
		end
	end
end

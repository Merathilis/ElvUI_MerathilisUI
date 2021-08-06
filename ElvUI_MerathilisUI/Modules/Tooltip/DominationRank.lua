local MER, E, L, V, P, G = unpack(select(2, ...))
local MT = MER:GetModule('MER_Tooltip')
local TT = E:GetModule('Tooltip')

-- modified from NDui
local _G = _G
local format = format
local pairs, tonumber, select, unpack = pairs, tonumber, select, unpack
local strfind = strfind
local strmatch = strmatch

local GetItemInfo = GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink

local DOMI_RANK_STRING = "%s (%d/5)"

local DomiDataByGroup = {
	[1] = {
		[187079] = 1,
		[187292] = 2,
		[187301] = 3,
		[187310] = 4,
		[187320] = 5,
	},
	[2] = {
		[187076] = 1,
		[187291] = 2,
		[187300] = 3,
		[187309] = 4,
		[187319] = 5,
	},
	[3] = {
		[187073] = 1,
		[187290] = 2,
		[187299] = 3,
		[187308] = 4,
		[187318] = 5
	},
	[4] = {
		[187071] = 1,
		[187289] = 2,
		[187298] = 3,
		[187307] = 4,
		[187317] = 5,
	},
	[5] = {
		[187065] = 1,
		[187288] = 2,
		[187297] = 3,
		[187306] = 4,
		[187316] = 5,
	},
	[6] = {
		[187063] = 1,
		[187287] = 2,
		[187296] = 3,
		[187305] = 4,
		[187315] = 5,
	},
	[7] = {
		[187061] = 1,
		[187286] = 2,
		[187295] = 3,
		[187304] = 4,
		[187314] = 5,
	},
	[8] = {
		[187059] = 1,
		[187285] = 2,
		[187294] = 3,
		[187303] = 4,
		[187313] = 5,
	},
	[9] = {
		[187057] = 1,
		[187284] = 2,
		[187293] = 3,
		[187302] = 4,
		[187312] = 5,
	}
}

local DomiRankData = {}
local DomiIndexData = {}

for index, value in pairs(DomiDataByGroup) do
	for itemID, rank in pairs(value) do
		DomiRankData[itemID] = rank
		DomiIndexData[itemID] = index
	end
end

local domiTextureIDs = {
	[457655] = true,
	[1003591] = true,
	[1392550] = true
}

local nameCache = {}
local function GetDomiName(itemID)
	local name = nameCache[itemID]
	if not name then
		name = GetItemInfo(itemID)
		nameCache[itemID] = name
	end

	return name
end

local function Domination_UpdateText(tt, name, rank)
	local tex = _G[tt:GetName() .. "Texture1"]

	tex:SetTexCoord(unpack(E.TexCoords)) -- make the icon looks good
	local texture = tex and tex:IsShown() and tex:GetTexture()
	if texture and domiTextureIDs[texture] then
		local textLine = select(2, tex:GetPoint())
		local text = textLine and textLine:GetText()
		if text then
			textLine:SetText(text .. "|n" .. format(DOMI_RANK_STRING, name, rank))
		end
	end
end

local function Domination_CheckStatus(tt)
	local _, link = tt:GetItem()

	if not link then
		return
	end

	local itemID = GetItemInfoFromHyperlink(link)
	local rank = itemID and DomiRankData[itemID]

	if rank then
		-- Domi rank on gems
		local textLine = _G[tt:GetName() .. "TextLeft2"]
		local text = textLine and textLine:GetText()
		if text and strfind(text, "|cFF66BBFF") then
			textLine:SetFormattedText(DOMI_RANK_STRING, text, rank)
		end
	else
		-- Domi rank on gears
		local gemID = strmatch(link, "item:%d+:%d*:(%d*):")
		itemID = tonumber(gemID)
		rank = itemID and DomiRankData[itemID]
		if rank then
			local name = GetDomiName(itemID)
			Domination_UpdateText(tt, name, rank)
		end
	end
end

function MT:DominationRank()
	if not E.db.mui.tooltip.dominationRank then
		return
	end

	_G.GameTooltip:HookScript("OnTooltipSetItem", Domination_CheckStatus)
	_G.ItemRefTooltip:HookScript("OnTooltipSetItem", Domination_CheckStatus)
	_G.ShoppingTooltip1:HookScript("OnTooltipSetItem", Domination_CheckStatus)
	_G.EmbeddedItemTooltip:HookScript("OnTooltipSetItem", Domination_CheckStatus)
end

MT:AddCallback('DominationRank')

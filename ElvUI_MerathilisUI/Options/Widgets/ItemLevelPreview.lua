local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local CreateFrame = CreateFrame
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = C_Item.GetItemInfo

-- Merchant rows with the item level on the item buttons, like the Item Level
-- module draws it (bottom right, in the quality color). Used as `dialogControl`
-- on a description named "itemLevel". The samples are items you have equipped.

local HEIGHT = 60
local NUM_ROWS = 3
local ROW_WIDTH = 160
local ICON_SIZE = 37
local GAP = 12

-- Head, chest, main hand, legs, shoulders, back
local SAMPLE_SLOTS = { 1, 5, 16, 7, 3, 15 }
local FALLBACK_ICON = 134400

local function CreateRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(ROW_WIDTH, ICON_SIZE)

	row.button = CreateFrame("Frame", nil, row, "BackdropTemplate")
	row.button:SetTemplate()
	row.button:SetSize(ICON_SIZE, ICON_SIZE)
	row.button:SetPoint("LEFT")

	row.icon = row.button:CreateTexture(nil, "ARTWORK")
	row.icon:SetInside()
	row.icon:SetTexCoord(unpack(E.TexCoords))

	-- Same font and spot as ItemLevel_Update
	row.iLvl = row.button:CreateFontString(nil, "OVERLAY")
	row.iLvl:FontTemplate(nil, 11)
	row.iLvl:SetPoint("BOTTOMRIGHT", 0, 0)

	row.name = row:CreateFontString(nil, "OVERLAY")
	row.name:FontTemplate(nil, 12)
	row.name:SetPoint("TOPLEFT", row.button, "TOPRIGHT", 6, -2)
	row.name:SetPoint("RIGHT", row, "RIGHT")
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(true)

	return row
end

-- Equipped items above common quality, the ones the module labels
local function GetSamples()
	local samples = {}
	for _, slot in ipairs(SAMPLE_SLOTS) do
		local link = GetInventoryItemLink("player", slot)
		if link then
			local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(link)
			if name and quality and quality > 1 then
				samples[#samples + 1] = { link = link, name = name, quality = quality, icon = icon }
				if #samples == NUM_ROWS then
					break
				end
			end
		end
	end
	return samples
end

local function Build(widget)
	widget.rows = {}
	for index = 1, NUM_ROWS do
		widget.rows[index] = CreateRow(widget.frame)
	end
end

local function Update(widget)
	local samples = GetSamples()
	local count = #samples
	local total = count * ROW_WIDTH + (count - 1) * GAP

	for index, row in ipairs(widget.rows) do
		local sample = samples[index]
		row:SetShown(sample ~= nil)
		if sample then
			local color = E:GetQualityColor(sample.quality)
			row.icon:SetTexture(sample.icon or FALLBACK_ICON)
			row.name:SetText(sample.name)
			row.name:SetTextColor(color.r, color.g, color.b)
			row.iLvl:SetText(F.GetItemLevel(sample.link) or "")
			row.iLvl:SetTextColor(color.r, color.g, color.b)
			row.iLvl:SetShown(E.db.mui.itemLevel.enable)

			row:ClearAllPoints()
			row:SetPoint("LEFT", widget.frame, "CENTER", -total / 2 + (index - 1) * (ROW_WIDTH + GAP), 0)
		end
	end

	-- Off, the item buttons look like Blizzard's: no number on them
	Preview.SetEnabled(widget, E.db.mui.itemLevel.enable)
end

Preview.Register("MERItemLevelPreview", 1, HEIGHT, Build, Update)

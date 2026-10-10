local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local CreateFrame = CreateFrame

-- The inbox with the Mail Selection: the select all box and the Open/Delete
-- bar above the list, a numbered checkbox in front of every mail. Used as
-- `dialogControl` on a description named "mail". Built with the same helpers
-- as Modules/Mail/Mail.lua (F.CreateCheckBox, the MerathilisUI button skin).
-- Display only, nothing in it opens or deletes mail.

local HEIGHT = 170
local WIDTH = 300
local ROW_HEIGHT = 34
local NUM_ROWS = 3
local CHECKED = { true, false, true }

local SAMPLE_ICONS = {
	[[Interface\Icons\INV_Misc_Coin_01]],
	[[Interface\Icons\INV_Misc_Note_01]],
	[[Interface\Icons\INV_Misc_Bag_10]],
}
local SAMPLE_SENDERS = { _G.BUTTON_LAG_AUCTIONHOUSE or "Auction House", E.myname, _G.GUILD or "Guild" }

local function Build(widget)
	local frame = widget.frame
	local MS = MER:GetModule("MER_Skins")

	local holder = CreateFrame("Frame", nil, frame)
	holder:SetSize(WIDTH, HEIGHT - 10)
	holder:SetPoint("CENTER")
	widget.holder = holder

	-- Button bar between the title and the list
	local topBar = CreateFrame("Frame", nil, holder)
	topBar:SetHeight(20)
	topBar:SetPoint("TOPLEFT", 20, 0)
	topBar:SetPoint("TOPRIGHT", 0, 0)
	widget.topBar = topBar

	local selectAll = F.CreateCheckBox(topBar)
	selectAll:SetSize(18, 18)
	selectAll:SetPoint("LEFT", topBar, "LEFT", 2, 0)
	selectAll:EnableMouse(false)
	widget.selectAll = selectAll

	local open = MS.CreateButton(topBar, 1, 20)
	open:SetText(L["Open"])
	open:SetPoint("TOPLEFT", selectAll, "TOPRIGHT", 4, 0)
	open:SetPoint("BOTTOMRIGHT", topBar, "BOTTOM", -3, 0)
	open:EnableMouse(false)

	local delete = MS.CreateButton(topBar, 1, 20)
	delete:SetText(L["Delete"])
	delete:SetPoint("TOPRIGHT", topBar, "TOPRIGHT", 0, 0)
	delete:SetPoint("BOTTOMLEFT", topBar, "BOTTOM", 3, 0)
	delete:EnableMouse(false)

	widget.rows = {}
	for index = 1, NUM_ROWS do
		local row = CreateFrame("Frame", nil, holder, "BackdropTemplate")
		row:SetTemplate("Transparent")
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", topBar, "BOTTOMLEFT", 0, -10 - (index - 1) * (ROW_HEIGHT + 8))
		row:SetPoint("RIGHT", topBar, "RIGHT")

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ROW_HEIGHT - 6, ROW_HEIGHT - 6)
		icon:SetPoint("LEFT", 3, 0)
		icon:SetTexture(SAMPLE_ICONS[index])
		icon:SetTexCoord(unpack(E.TexCoords))

		local sender = row:CreateFontString(nil, "OVERLAY")
		sender:FontTemplate(nil, 12)
		sender:SetPoint("TOPLEFT", icon, "TOPRIGHT", 6, -1)
		sender:SetText(SAMPLE_SENDERS[index])

		local subject = row:CreateFontString(nil, "OVERLAY")
		subject:FontTemplate(nil, 11)
		subject:SetTextColor(0.8, 0.8, 0.8)
		subject:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 6, 1)
		subject:SetText(_G.MAIL_SUBJECT_LABEL and _G.MAIL_SUBJECT_LABEL:gsub(":$", "") or "Subject")

		-- Same box and number as CreateSelectionCheckboxes
		local box = F.CreateCheckBox(row)
		box:SetSize(18, 18)
		box:SetPoint("RIGHT", row, "LEFT", 4, 0)
		box:SetFrameLevel(row:GetFrameLevel() + 5)
		box:SetChecked(CHECKED[index])
		box:EnableMouse(false)

		local number = box:CreateFontString(nil, "OVERLAY")
		F.SetFontSize(number, 10)
		number:SetTextColor(1, 0.82, 0)
		number:SetPoint("BOTTOM", box, "TOP", 0, 0)
		number:SetText(index)

		row.box = box
		widget.rows[index] = row
	end
end

local function Update(widget)
	local db = E.db.mui.mail
	local shown = db.selection.enable

	widget.topBar:SetShown(shown)
	for _, row in ipairs(widget.rows) do
		row.box:SetShown(shown)
	end

	Preview.SetEnabled(widget, db.enable and shown)
end

Preview.Register("MERMailPreview", 1, HEIGHT, Build, Update)

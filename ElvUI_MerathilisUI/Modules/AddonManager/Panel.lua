local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

-- Profile panel docked to the right of the addon list: one card per profile with
-- Load and a menu for overwrite, rename and delete, plus "Save Current As".

local _G = _G
local format, ipairs, max, unpack = format, ipairs, max, unpack

local CreateFrame = CreateFrame
local MenuUtil = MenuUtil

local PANEL_WIDTH = 250
local INSET = 12
local HEADER_HEIGHT = 44
local CARD_HEIGHT = 40
local CARD_GAP = 6
local SCROLLBAR_WIDTH = 20
local IMPORT_WIDTH = 70

local panel
local cards = {}

local function CardMenu(owner, root)
	local name = owner.profile
	root:CreateTitle(name)
	root:CreateButton(L["Overwrite With Current"], function()
		module:SaveProfile(name)
	end)
	root:CreateButton(L["Rename"], function()
		module:ShowRenameProfilePopup(name)
	end)
	root:CreateButton(L["Export"], function()
		module:ShowExportPopup(name)
	end)
	root:CreateButton(_G.DELETE, function()
		module:ShowDeleteProfilePopup(name)
	end)
end

local function Card_OnEnter(card)
	card:SetBackdropBorderColor(unpack(module.colors.accent))
end

local function Card_OnLeave(card)
	if not card:IsMouseOver() then
		card:SetBackdropBorderColor(unpack(module.colors.border))
	end
end

local function CreateCard(index)
	local colors = module.colors
	local card = CreateFrame("Frame", nil, panel.content, "BackdropTemplate")
	card:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	card:SetBackdropColor(unpack(colors.box))
	card:SetBackdropBorderColor(unpack(colors.border))
	card:SetHeight(CARD_HEIGHT)
	card:EnableMouse(true)
	card:SetScript("OnEnter", Card_OnEnter)
	card:SetScript("OnLeave", Card_OnLeave)

	card.more = CreateFrame("Button", nil, card)
	card.more:SetSize(16, 16)
	card.more:SetPoint("RIGHT", -8, 0)
	card.more:SetNormalTexture(I.Media.Icons.Categories.More)
	card.more:SetHighlightTexture(I.Media.Icons.Categories.More)
	card.more:GetHighlightTexture():SetAlpha(0.4)
	card.more:SetScript("OnClick", function(button)
		MenuUtil.CreateContextMenu(card, CardMenu)
		Card_OnLeave(button:GetParent())
	end)
	card.more:HookScript("OnEnter", function()
		Card_OnEnter(card)
	end)
	card.more:HookScript("OnLeave", function()
		Card_OnLeave(card)
	end)

	card.load = module.CreateFlatButton(card, L["Load"], 56, 22, true, function()
		module:LoadProfile(card.profile)
	end)
	card.load:SetPoint("RIGHT", card.more, "LEFT", -6, 0)
	card.load.tooltip = L["Switches the addons of this character to the profile. Click Reload UI afterwards."]
	card.load:HookScript("OnEnter", function()
		Card_OnEnter(card)
	end)
	card.load:HookScript("OnLeave", function()
		Card_OnLeave(card)
	end)

	card.name = module.CreateText(card, 12, nil, "LEFT")
	card.name:SetPoint("TOPLEFT", 10, -7)
	card.name:SetPoint("RIGHT", card.load, "LEFT", -6, 0)
	card.name:SetWordWrap(false)

	card.count = module.CreateText(card, 10, colors.muted, "LEFT")
	card.count:SetPoint("TOPLEFT", card.name, "BOTTOMLEFT", 0, -3)
	card.count:SetPoint("RIGHT", card.name, "RIGHT")

	cards[index] = card
	return card
end

---Rebuilds the cards from the profiles
function module:UpdateProfilePanel()
	if not panel or not panel:IsShown() then
		return
	end

	local names = self:GetProfileNames()
	local overflow = (#names * (CARD_HEIGHT + CARD_GAP)) > panel.scroll:GetHeight()
	local width = PANEL_WIDTH - INSET * 2 - (overflow and SCROLLBAR_WIDTH or 0)

	for index, name in ipairs(names) do
		local card = cards[index] or CreateCard(index)
		card.profile = name
		card.name:SetText(name)
		card.count:SetText(format(L["%d |4addon:addons;"], self:GetProfileSize(name)))
		card:SetWidth(width)
		card:ClearAllPoints()
		card:SetPoint("TOPLEFT", 0, -(index - 1) * (CARD_HEIGHT + CARD_GAP))
		card:Show()
	end

	for index = #names + 1, #cards do
		cards[index]:Hide()
	end

	panel.content:SetSize(width, max(1, #names * (CARD_HEIGHT + CARD_GAP)))
	panel.scroll.ScrollBar:SetShown(overflow)
	panel.empty:SetShown(#names == 0)
end

local function CreatePanel(list)
	local colors = module.colors

	panel = CreateFrame("Frame", nil, list)
	panel:SetWidth(PANEL_WIDTH)
	panel:SetPoint("TOPLEFT", list, "TOPRIGHT", 4, 0)
	panel:SetPoint("BOTTOMLEFT", list, "BOTTOMRIGHT", 4, 0)
	panel:SetTemplate("Transparent")
	WS:CreateShadow(panel)
	panel:EnableMouse(true)
	panel:Hide()

	-- Header like the section headers of the options
	panel.title = module.CreateText(panel, 15, nil, "LEFT")
	panel.title:SetPoint("TOPLEFT", INSET, -INSET)
	panel.title:SetText(L["Addon Profiles"])

	local underline = panel:CreateTexture(nil, "ARTWORK")
	underline:SetSize(24, 2)
	underline:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT", 0, -5)
	underline:SetColorTexture(unpack(colors.accent))

	panel.close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
	panel.close:SetPoint("TOPRIGHT", 2, 2)
	panel.close:SetScript("OnClick", function()
		module:SetProfilePanelShown(false)
	end)
	S:HandleCloseButton(panel.close)

	-- Footer: save the current addons as a new profile, or import one
	local footerWidth = PANEL_WIDTH - INSET * 2
	panel.import = module.CreateFlatButton(panel, L["Import"], IMPORT_WIDTH, 26, false, function()
		module:ShowImportPopup()
	end)
	panel.import:SetPoint("BOTTOMRIGHT", -INSET, INSET)
	panel.import.tooltip = L["Adds a profile from an addon profile code."]

	panel.save = module.CreateFlatButton(
		panel,
		L["Save Current As..."],
		footerWidth - IMPORT_WIDTH - 6,
		26,
		true,
		function()
			module:ShowSaveProfilePopup()
		end
	)
	panel.save:SetPoint("BOTTOMLEFT", INSET, INSET)

	-- Above it the search for a faulty addon
	panel.bisect = module.CreateFlatButton(panel, L["Find Faulty Addon"], footerWidth, 22, false, function()
		module:ShowBisectStartPopup()
	end)
	panel.bisect:SetPoint("BOTTOMLEFT", panel.save, "TOPLEFT", 0, 6)
	panel.bisect.tooltip =
		L["Turns off half of your addons per reload until the one behind a problem is found. Your addons come back at the end."]

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", INSET, -HEADER_HEIGHT)
	scroll:SetPoint("BOTTOMRIGHT", panel.bisect, "TOPRIGHT", 0, 10)
	S:HandleScrollBar(scroll.ScrollBar)

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(1, 1)
	scroll:SetScrollChild(content)

	panel.scroll = scroll
	panel.content = content

	panel.empty = module.CreateText(panel, 12, colors.muted)
	panel.empty:SetPoint("TOPLEFT", scroll, "TOPLEFT", 4, -8)
	panel.empty:SetPoint("RIGHT", scroll, "RIGHT", -4, 0)
	panel.empty:SetWordWrap(true)
	panel.empty:SetText(L["No profiles yet. Save the addons that are on right now as your first one."])

	panel:SetScript("OnShow", function()
		module:UpdateProfilePanel()
	end)
	panel:SetScript("OnSizeChanged", function()
		module:UpdateProfilePanel()
	end)
end

---@param shown boolean
function module:SetProfilePanelShown(shown)
	self.db.profilePanel = shown
	if panel then
		panel:SetShown(shown and self.db.enable)
	end
	if self.profileButton then
		self.profileButton.MERActive = shown or nil
		self.UpdateFlatBox(self.profileButton)
	end
end

---Profiles button in the bottom bar and the panel, called once from SetupList
---@param list Frame AddonList
function module:CreateProfilePanel(list)
	CreatePanel(list)

	-- Built like Blizzard's buttons next to it, so it gets the same skin and look
	local button = CreateFrame("Button", nil, list, "SharedButtonSmallTemplate")
	button:SetSize(120, 22)
	button:SetPoint("TOPLEFT", list.DisableAllButton, "TOPRIGHT", 0, 0)
	button:SetText(L["Profiles"])
	button:SetScript("OnClick", function()
		module:SetProfilePanelShown(not module.db.profilePanel)
	end)
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.addonManager then
		S:HandleButton(button, nil, nil, nil, true, nil, nil, nil, true)
	end
	self.profileButton = button

	self:SetProfilePanelShown(self.db.profilePanel)
end

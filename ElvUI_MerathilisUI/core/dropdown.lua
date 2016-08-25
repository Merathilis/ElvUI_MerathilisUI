local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local DD = E:NewModule("Dropdown", "AceEvent-3.0")

DD.RegisteredMenus = {}

--Cache global variables
local _G = _G
local format = string.format
local pairs = pairs
local tinsert = table.insert
--WoW API / Variables
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local ToggleFrame = ToggleFrame

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent, UISpecialFrames,

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local TITLE_OFFSET = 10

local function OnClick(btn)
	if btn.func then btn.func() end

	btn:GetParent():Hide()
end

local function OnEnter(btn)
	if not btn.nohighlight then btn.hoverTex:Show() end
	if btn.UseTooltip then
		_G["GameTooltip"]:SetOwner(btn, "ANCHOR_BOTTOMLEFT", -9)
		if btn.TooltipText then
			_G["GameTooltip"]:SetText(btn.TooltipText)
		elseif btn.secure.isToy then
			_G["GameTooltip"]:SetToyByItemID(btn.secure.ID)
		elseif btn.secure.buttonType == "item" then
			_G["GameTooltip"]:SetItemByID(btn.secure.ID)
		elseif btn.secure.buttonType == "spell" then
			_G["GameTooltip"]:SetSpellByID(btn.secure.ID)
		end
		_G["GameTooltip"]:Show()
	end
end

local function OnLeave(btn)
	_G["GameTooltip"]:Hide()
	btn.hoverTex:Hide()
end

local function CreateListButton(frame)
	local button = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")

	button.hoverTex = button:CreateTexture(nil, 'OVERLAY')
	button.hoverTex:SetAllPoints()
	button.hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
	button.hoverTex:SetBlendMode("ADD")
	button.hoverTex:Hide()

	button.text = button:CreateFontString(nil, 'BORDER')
	button.text:SetAllPoints()
	button.text:FontTemplate()

	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)

	return button
end

function MER:DropDown(list, frame, MenuAnchor, FramePoint, xOffset, yOffset, parent, customWidth, justify)
	if InCombatLockdown() then return end
	if not frame:IsShown() then
		if not frame.buttons then
			frame.buttons = {}
			frame:SetFrameStrata("DIALOG")
			frame:SetClampedToScreen(true)
			tinsert(UISpecialFrames, frame:GetName())
			frame:Hide()
		end

		xOffset = xOffset or 0
		yOffset = yOffset or 0
		local TitleCount = 0
		local AddOffset = 0

		for i=1, #frame.buttons do
			frame.buttons[i].UseTooltip = false
			frame.buttons[i]:Hide()
		end
		if not parent then FramePoint = "CURSOR" end

		for i=1, #list do
			frame.buttons[i] = frame.buttons[i] or CreateListButton(frame)
			local btn = frame.buttons[i]

			btn.func = list[i].func or nil
			btn.nohighlight = list[i].nohighlight
			btn.text:SetJustifyH(justify or "LEFT")
			btn:Show()
			btn:Height(BUTTON_HEIGHT)
			btn:Width(customWidth or BUTTON_WIDTH)
			local icon = ""
			if list[i].icon then
				icon = "|T"..list[i].icon..":14:14|t "
			end

			btn.text:SetText(icon..list[i].text)
			if list[i].title then
				TitleCount = TitleCount + 1
				btn.text:SetTextColor(0.98, 0.95, 0.05)
				if list[i].ending or i == 1 or list[i-1].title then
					AddOffset = AddOffset + 1
				end
			else
				btn.text:SetTextColor(1, 1, 1)
			end
			if list[i].secure then
				btn.secure = list[i].secure
				btn:SetAttribute("type", btn.secure.buttonType)
				if btn.secure.buttonType == "item" then
					local name = GetItemInfo(btn.secure.ID)
					btn:SetAttribute("item", name)
				elseif btn.secure.buttonType == "spell" then
					local name = GetSpellInfo(btn.secure.ID)
					btn:SetAttribute("spell", name)
				elseif btn.secure.buttonType == "macro" then
					btn:SetAttribute("macrotext", btn.secure.ID)
				else
					MER:Print("Wrong argument for button type: "..btn.secure.buttonType)
				end
				btn:HookScript("OnClick", OnClick)
			else
				btn:SetScript("OnClick", OnClick)
			end
			btn.UseTooltip = list[i].UseTooltip
			if list[i].TooltipText then btn.TooltipText = list[i].TooltipText end

			local MARGIN = 10
			if justify then
				if justify == "RIGHT" then MARGIN = -10 end
				if justify == "CENTER" then MARGIN = 0 end
			end

			if i == 1 then
				btn:Point("TOPLEFT", frame, "TOPLEFT", MARGIN, -PADDING)
			else
				btn:Point("TOPLEFT", frame.buttons[i-1], "BOTTOMLEFT", 0, -((list[i-1].title or list[i].title) and TITLE_OFFSET or 0))
			end
		end

		frame:Height((#list * BUTTON_HEIGHT) + PADDING * 2 + TitleCount * (2 * TITLE_OFFSET) - AddOffset * TITLE_OFFSET)
		frame:Width(customWidth or (BUTTON_WIDTH + PADDING * 2))

		frame:ClearAllPoints()
		if FramePoint == "CURSOR" then
			local UIScale = UIParent:GetScale();
			local x, y = GetCursorPosition();
			x = x/UIScale
			y = y/UIScale
			frame:Point(MenuAnchor, UIParent, "BOTTOMLEFT", x + xOffset, y + yOffset)
		else
			frame:Point(MenuAnchor, parent, FramePoint, xOffset, yOffset)
		end
	end
	ToggleFrame(frame)
end

function DD:GetCooldown(CDtype, id)
	local cd, formatID
	local start, duration = _G["Get"..CDtype.."Cooldown"](id)
	if start > 0 then
		cd = duration - (GetTime() - start)
		cd, formatID = E:GetTimeInfo(cd, 0)
		cd = format(E.TimeFormats[formatID][2], cd)
		return cd
	end
	return nil
end


function DD:HideMenus()
	for name, menu in pairs(DD.RegisteredMenus) do
		menu:Hide()
	end
end

function DD:RegisterMenu(menu)
	local name = menu:GetName()
	if name then
		DD.RegisteredMenus[name] = menu
	else
		MER:Print("Dropdown not registered. Please check if it has a name.")
	end
end

function DD:Initialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HideMenus")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "HideMenus")
end

E:RegisterModule(DD:GetName())
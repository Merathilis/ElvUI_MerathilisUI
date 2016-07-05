local MAJOR, MINOR = "LibElv-GameMenu-1.0", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
--GLOBALS: CreateFrame
if not lib then return end
local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")
local _G = _G
local tinsert = tinsert
local menuWidth = _G["GameMenuFrame"]:GetWidth()
local columns
local newColumn = {
	[10] = true,
	[19] = true,
	[24] = true,
}
local spaceCount = {
	[4] = 5,
	[13] = 8,
	[22] = 16,
}

local width, height = _G["GameMenuButtonHelp"]:GetWidth(), _G["GameMenuButtonHelp"]:GetHeight()
local LibHolder = CreateFrame("Frame", "LibGameMenuHolder", _G["GameMenuFrame"])
LibHolder:SetSize(width, 1)
LibHolder:SetPoint("TOP", _G["GameMenuFrame"].ElvUI, "BOTTOM", 0, 0)

lib.buttons = {}
lib.skincheck = false

lib.Header = CreateFrame("Frame", "GameMenuAddonHeader", _G["GameMenuFrame"])
lib.Header:SetSize(256, 64)
lib.Header:SetPoint("BOTTOM", LibHolder, "TOP", 0, -25)
lib.Header:Hide()
lib.Header.Text = lib.Header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lib.Header.Text:SetPoint("TOP", lib.Header, "TOP", 0, -14)
lib.Header.Text:SetText(_G["ADDONS"])
lib.Header.Art = lib.Header:CreateTexture(nil, "OVERLAY")
lib.Header.Art:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
lib.Header.Art:SetAllPoints()

function lib:CheckForSkin()
	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then lib.Header.Art:Hide() end
	lib.skincheck = true
end

function lib:UpdateHolder()
	if not lib.skincheck then lib:CheckForSkin() end
	local total = #lib.buttons
	LibHolder:SetSize(width, 1 + (height * total))
	if total > 0 and total <= 5 then
		lib.Header:Hide()
		LibHolder:ClearAllPoints()
		LibHolder:SetPoint("TOP", _G["GameMenuFrame"].ElvUI, "BOTTOM", 0, -1)
	elseif total > 5 then
		lib.Header:Show()
		LibHolder:ClearAllPoints()
		LibHolder:SetPoint("TOPLEFT", _G["GameMenuButtonHelp"], "TOPRIGHT", 1, 1)
	end
	columns = 1
	for i = 1, total do
		local button = lib.buttons[i]
		local space
		if (spaceCount[i] and total > spaceCount[i]) then space = true end
		if lib.buttons[i-1] then
			if newColumn[i] then
				button:SetPoint("TOPLEFT", lib.buttons[i-9], "TOPRIGHT", 1 , 0)
				columns = columns + 1
			else
				button:SetPoint("TOP", lib.buttons[i-1], "BOTTOM", 0 , space and -16 or -1)
			end
		else
			button:SetPoint("TOPLEFT", LibHolder, "TOPLEFT", 0 , -1)
		end
		
	end
end

--[[data is the table of:
- name - button name
- text - text on button
- func - function to execute on click
]]
function lib:AddMenuButton(data)
	if not data then return end
	if _G[data.name] then return end
	local button = CreateFrame("Button", data.name, _G["GameMenuFrame"], "GameMenuButtonTemplate")
	button:Size(width, height)
	button:SetScript("OnClick", data.func)
	button:SetText(data.text)

	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
		S:HandleButton(button)
	end

	tinsert(lib.buttons, button)
end

_G["GameMenuFrame"]:HookScript("OnShow", function()
	if #lib.buttons <= 5 then
		_G["GameMenuButtonLogout"]:ClearAllPoints()
		_G["GameMenuButtonLogout"]:SetPoint("TOP", LibHolder, "BOTTOM", 0, -16)
		_G["GameMenuFrame"]:Height(_G["GameMenuFrame"]:GetHeight() + 17 + (height * #lib.buttons))
	else
		LibHolder:SetWidth((width + 1) * columns)
		_G["GameMenuFrameHeader"]:ClearAllPoints()
		_G["GameMenuFrameHeader"]:SetPoint("BOTTOM", _G["GameMenuButtonHelp"], "TOP", 0, -25)
		_G["GameMenuButtonHelp"]:ClearAllPoints()
		_G["GameMenuButtonHelp"]:SetPoint("TOPLEFT", _G["GameMenuFrame"], "TOPLEFT", 25.5, -31.5)
		_G["GameMenuFrame"]:Width(menuWidth + 1 + width * columns)
		_G["GameMenuButtonLogout"]:ClearAllPoints()
		_G["GameMenuButtonLogout"]:SetPoint("TOP", _G["GameMenuButtonAddons"], "BOTTOMLEFT", _G["GameMenuFrame"]:GetWidth()/2 - 25.5, -29)
	end
end)


if not LibStub("LibElvUIPlugin-1.0").plugins[MAJOR] then
	LibStub("LibElvUIPlugin-1.0"):RegisterPlugin(MAJOR, function() end, true)
end
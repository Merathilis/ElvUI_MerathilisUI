local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI")
local MERS = E:GetModule("mUISkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local gmatch, gsub, find, sub = string.gmatch, string.gsub, string.find, string.sub
local tinsert = table.insert
local pairs, tostring = pairs, tostring
-- WoW API / Variables
local CreateFrame = CreateFrame

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MERData, PlaySound, UISpecialFrames

-- Don't show the frame if my install isn't finished
if E.db.mui.installed == nil then return; end

local ChangeLog = CreateFrame("frame")
local ChangeLogData = {
	"Changes:",
		"• Add a skin for Premade Group Filter",
		"• Add an auctionhouse skin, its now more transparent",
		"• Remove some code to position the AlwaysUpFrame",
		"• Update BigWigs skin (now half-bar)",
		"• Hide the Notifications if you are in combat",
		"• Use the new method from ElvUI to register modules",
		"• Add bindings for the RaidMarkBar",
		"• The tabs from ElvUI are now transparent",
		"• Fix a rar nil error in CoolDownFlash with Dual Profiles enabled",
		"• Update profile creation for the AddOns. It now uses char specific profiles",
		--"• ",
	" ",
	"Notes:",
		"• Have a nice day! ^o^",
}

local function ModifiedString(string)
	local count = find(string, ":")
	local newString = string

	if count then
		local prefix = sub(string, 0, count)
		local suffix = sub(string, count + 1)
		local subHeader = find(string, "•")

		if subHeader then newString = tostring("|cFFFFFF00".. prefix .. "|r" .. suffix) else newString = tostring("|cffff7d0a" .. prefix .. "|r" .. suffix) end
	end

	for pattern in gmatch(string, "('.*')") do newString = newString:gsub(pattern, "|cFFFF8800" .. pattern:gsub("'", "") .. "|r") end
	return newString
end

local function GetChangeLogInfo(i)
	for line, info in pairs(ChangeLogData) do
		if line == i then return info end
	end
end

function ChangeLog:CreateChangelog()
	local frame = CreateFrame("Frame", "MerathilisUIChangeLog", E.UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(445, 245)
	frame:SetTemplate("Transparent")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetClampedToScreen(true)

	local icon = CreateFrame("Frame", nil, frame)
	icon:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 3)
	icon:SetSize(20, 20)
	icon:SetTemplate("Transparent")
	icon.bg = icon:CreateTexture(nil, "ARTWORK")
	icon.bg:Point("TOPLEFT", 2, -2)
	icon.bg:Point("BOTTOMRIGHT", -2, 2)
	icon.bg:SetTexture(MER.LogoSmall)

	local title = CreateFrame("Frame", nil, frame)
	title:SetPoint("LEFT", icon, "RIGHT", 3, 0)
	title:SetSize(422, 20)
	title:SetTemplate("Transparent")
	title.text = title:CreateFontString(nil, "OVERLAY")
	title.text:SetPoint("CENTER", title, 0, -1)
	title.text:SetFont(E["media"].normFont, 15)
	title.text:SetText("|cffff7d0aMerathilisUI|r - ChangeLog " .. MER.Version)

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:Point("TOPRIGHT", frame, "TOPRIGHT", 0, 26)
	close:SetSize(24, 24)
	close:SetScript("OnClick", function() frame:Hide() end)
	S:HandleCloseButton(close)

	local offset = 4
	for i = 1, #ChangeLogData do
		local button = CreateFrame("Frame", "Button"..i, frame)
		button:SetSize(375, 16)
		button:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -offset)

		if i <= #ChangeLogData then
			local string = ModifiedString(GetChangeLogInfo(i))

			button.Text = button:CreateFontString(nil, "OVERLAY")
			button.Text:SetFont(E["media"].normFont, 11)
			button.Text:SetText(string)
			button.Text:SetPoint("LEFT", 0, 0)
		end
		offset = offset + 16
	end
end

function MER:ToggleChangeLog()
	ChangeLog:CreateChangelog()
	PlaySound("igMainMenuOptionCheckBoxOff")
	tinsert(UISpecialFrames, "MerathilisUIChangeLog")
end

function ChangeLog:OnCheckVersion(self)
	if not MERData["Version"] or (MERData["Version"] and MERData["Version"] ~= MER.Version) then
		MERData["Version"] = MER.Version
		ChangeLog:CreateChangelog()
	end
end

ChangeLog:RegisterEvent("ADDON_LOADED")
ChangeLog:RegisterEvent("PLAYER_ENTERING_WORLD")
ChangeLog:SetScript("OnEvent", function(self, event, ...)
	if MERData == nil then MERData = {} end
	ChangeLog:OnCheckVersion()
end)
local MER, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs = print, pairs
local tinsert = table.insert
-- WoW API / Variables
local GetAddOnEnableState = GetAddOnEnableState

-- GLOBALS: ElvDB, hooksecurefunc, BINDING_HEADER_MER
-- GLOBALS: MERData, MERDataPerChar, ElvDB

-- Masque support
MER.MSQ = _G.LibStub('Masque', true)

MER["styling"] = {}
MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mUI1.tga]]

_G.BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"
for i = 1, 5 do
	_G["BINDING_HEADER_AUTOBUTTONBAR"..i] = L["Auto Button Bar"..' '..i]
	for j = 1, 12 do
		_G[format("BINDING_NAME_CLICK AutoButtonBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
	end
end

local function PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function MER:cOption(name, color)
	local hex
	if color == 'orange' then
		hex = '|cffff7d0a%s |r'
	elseif color == 'blue' then
		hex = '|cFF00c0fa%s |r'
	elseif color == 'gradient' then
		hex = E:TextGradient(name, 1, 0.65, 0, 1, 0.65, 0, 1, 1, 1)
	else
		hex = '|cFFFFFFFF%s |r'
	end

	return (hex):format(name)
end

function MER:DasOptions()
	E:ToggleOptionsUI(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui")
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
	self:RegisterChatCommand('muierror', 'LuaError')
end

function MER:RegisterMedia()
	--Fonts
	E.media.muiFont = LSM:Fetch("font", "Merathilis Prototype")
	E.media.muiVisitor = LSM:Fetch("font", "Merathilis Visitor1")
	E.media.muiVisitor2 = LSM:Fetch("font", "Merathilis Visitor2")
	E.media.muiTuk = LSM:Fetch("font", "Merathilis Tukui")
	E.media.muiRoboto = LSM:Fetch("font", "Merathilis Roboto-Black")
	E.media.muiGothic = LSM:Fetch("font", "Merathilis Gothic-Bold")

	-- Background
	-- Border

	--Textures
	E.media.muiBlank = LSM:Fetch("statusbar", "MerathilisBlank")
	E.media.muiBorder = LSM:Fetch("statusbar", "MerathilisBorder")
	E.media.muiEmpty = LSM:Fetch("statusbar", "MerathilisEmpty")
	E.media.muiMelli = LSM:Fetch("statusbar", "MerathilisMelli")
	E.media.muiMelliDark = LSM:Fetch("statusbar", "MerathilisMelliDark")
	E.media.muiOnePixel = LSM:Fetch("statusbar", "MerathilisOnePixel")
	E.media.muiNormTex = LSM:Fetch("statusbar", "MerathilisnormTex")
	E.media.muiGradient = LSM:Fetch("statusbar", "MerathilisGradient")

	-- Custom Textures
	E.media.roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\UI-LFG-ICON-ROLES]]
	E.media.checked = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\checked]]

	E:UpdateMedia()
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

function MER:DBCleanup()
	if E.db["datatexts"]["panels"]["MER_BottomPanel"] then
		E.db["datatexts"]["panels"]["MER_BottomPanel"] = nil
	end
	if E.global["datatexts"]["customPanels"]["MER_BottomPanel"] then
		E.global["datatexts"]["customPanels"]["MER_BottomPanel"] = nil
	end

	local db = E.db.mui.chat.chatBar
	if type(db) ~= 'table' then
		E.db.mui.chat.chatBar = {}
	end
end

function MER:Initialize()
	self:RegisterMedia()
	self:LoadCommands()
	self:AddMoverCategories()
	self:LoadDataTexts()
	self:DBCleanup()

	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	-- Create empty saved vars if they doesn't exist
	if not MERData then
		MERData = {}
	end

	if not MERDataPerChar then
		MERDataPerChar = {}
	end

	hooksecurefunc(E, "PLAYER_ENTERING_WORLD", function(self, _, initLogin)
		if initLogin or not ElvDB.MERErrorDisabledAddOns then
			ElvDB.MERErrorDisabledAddOns = {}
		end
	end)

	self:SetupProfileCallbacks()

	E:Delay(6, function() MER:CheckVersion() end)

	-- run the setup when ElvUI install is finished and again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if (E.private.install_complete == E.version and E.db.mui.installed == nil) or (ElvDB.profileKeys and profileKey == nil) then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	local icon = MER:GetIconString(MER.Media.Textures.pepeSmall, 14)
	if E.db.mui.installed and E.db.mui.general.LoginMsg then
		print(icon..''..MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/issues"))
	end
end

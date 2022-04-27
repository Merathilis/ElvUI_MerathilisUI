local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G
local format = string.format
local ipairs, print, pairs, tonumber, type, select, unpack = ipairs, print, pairs, tonumber, type, select, unpack
local assert = assert
local strsplit = strsplit
local tinsert = table.insert
local getmetatable = getmetatable
local EnumerateFrames = EnumerateFrames

local CreateFrame = CreateFrame
local GetAddOnEnableState = GetAddOnEnableState
local GetAddOnMetadata = GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local hooksecurefunc = hooksecurefunc

-- Masque support
MER.MSQ = _G.LibStub('Masque', true)

MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\mUI1.tga]]

MER.dummy = function() return end
MER.Title = format("|cffffffff%s|r|cffff7d0a%s|r ", "Merathilis", "UI")
MER.Version = GetAddOnMetadata("ElvUI_MerathilisUI", "Version")
MER.ElvUIV = tonumber(E.version)
MER.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvVersion"))
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

MER_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MER_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

--Info Color RGB: 0, 191/255, 250/255
MER.InfoColor = "|cFF00c0fa"
MER.GreyColor = "|cffB5B5B5"
MER.RedColor = "|cffff2735"
MER.GreenColor = "|cff3a9d36"

MER.LineString = MER.GreyColor.."---------------"

MER.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
MER.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
MER.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

_G.BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"
for i = 1, 5 do
	_G["BINDING_HEADER_AUTOBUTTONBAR"..i] = L["Auto Button Bar"..' '..i]
	for j = 1, 12 do
		_G[format("BINDING_NAME_CLICK AutoButtonBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
	end
end

-- Whiro's code magic
function MER:SetupProfileCallbacks()
	E.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
end

function MER:UpdateRegisteredDBs()
	if (not MER["RegisteredDBs"]) then
		return
	end

	local dbs = MER["RegisteredDBs"]

	for tbl, path in pairs(dbs) do
		self:UpdateRegisteredDB(tbl, path)
	end
end

function MER:OnProfileChanged()
	MER:Hook(E, "UpdateEnd", "UpdateAll")
end

function MER:UpdateAll()
	self:UpdateRegisteredDBs()
	for _, module in ipairs(self:GetRegisteredModules()) do
		local mod = MER:GetModule(module)
		if (mod and mod.ForUpdateAll) then
			mod:ForUpdateAll()
		end
	end
	MER:Unhook(E, "UpdateEnd")
end

function MER:UpdateRegisteredDB(tbl, path)
	local path_parts = {strsplit(".", path)}
	local _db = E.db.mui
	for _, path_part in ipairs(path_parts) do
		_db = _db[path_part]
	end
	tbl.db = _db
end

function MER:RegisterDB(tbl, path)
	if (not MER["RegisteredDBs"]) then
		MER["RegisteredDBs"] = {}
	end
	self:UpdateRegisteredDB(tbl, path)
	MER["RegisteredDBs"][tbl] = path
end
--Whiro's Magic end

do
	local template = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local s = 14
	function MER:GetIconString(icon, size)
		return format(template, icon, size or s, size or s)
	end
end

function MER:Print(...)
	print("|cffff7d0a".."mUI:|r", ...)
end

function MER:PrintURL(url)
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
	E.media.roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\UI-LFG-ICON-ROLES]]
	E.media.checked = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\checked]]

	E:UpdateMedia()
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

function MER:Initialize()
	self:DBConvert()
	self:RegisterMedia()
	self:LoadCommands()
	self:AddMoverCategories()
	self:LoadDataTexts()

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
		print(icon..''..MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://github.com/Merathilis/ElvUI_MerathilisUI/issues"))
	end
end

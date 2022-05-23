local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G
local format = string.format
local ipairs, print, pairs = ipairs, print, pairs
local pcall = pcall
local tinsert = table.insert

local GetAddOnEnableState = GetAddOnEnableState

-- Masque support
MER.MSQ = _G.LibStub('Masque', true)

MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\mUI1.tga]]

--Info Color RGB: 0, 192, 250
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

-- Register own Modules
function MER:RegisterModule(name)
	if not name then
		return
	end
	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end

function MER:GetRegisteredModules()
	return MER.RegisteredModules
end

function MER:InitializeModules()
	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.Initialize then
			pcall(module.Initialize, module)
		end
	end
end

function MER:UpdateModules()
	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.ProfileUpdate then
			pcall(module.ProfileUpdate, module)
		end
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

function MER:AddOptions()
	for _, func in ipairs(MER.Config) do
		func()
	end
end

function MER:DasOptions()
	E:ToggleOptionsUI(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui")
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "DasOptions")
	self:RegisterChatCommand('muierror', 'LuaError')
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

function MER:CheckVersion()
	-- ElvUI versions check
	if MER.ElvUIV < MER.ElvUIX then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	self:DBConvert()
	self:LoadCommands()
	self:AddMoverCategories()
	self:LoadDataTexts()

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

	E:Delay(6, function() MER:ChangeLog() end)

	-- run the setup when ElvUI install is finished and again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if (E.private.install_complete == E.version and E.db.mui.installed == nil) or (ElvDB.profileKeys and profileKey == nil) then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	end

	local icon = F.GetIconString(MER.Media.Textures.pepeSmall, 14)
	if E.db.mui.installed and E.db.mui.general.LoginMsg then
		print(icon..''..MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://github.com/Merathilis/ElvUI_MerathilisUI/issues"))
	end
end
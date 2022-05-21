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

MER_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MER_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

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

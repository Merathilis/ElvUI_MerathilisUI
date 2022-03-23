local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G
local format = string.format
local print, pairs = print, pairs
local tinsert = table.insert

local GetAddOnEnableState = GetAddOnEnableState

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

-- Masque support
MER.MSQ = _G.LibStub('Masque', true)

MER["styling"] = {}
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

function MER:CreateGradientFrame(frame, w, h, o, r, g, b, a1, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(E.media.blankTex)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

function MER:UpdateStyling()
	if E.db.mui.general.style then
		for style in pairs(MER["styling"]) do
			if style.stripes then style.stripes:Show() end
			if style.gradient then style.gradient:Show() end
			if style.mshadow then style.mshadow:Show() end
		end
	else
		for style in pairs(MER["styling"]) do
			if style.stripes then style.stripes:Hide() end
			if style.gradient then style.gradient:Hide() end
			if style.mshadow then style.mshadow:Hide() end
		end
	end
end

function MER:CreateShadow(frame, size, force)
	if not (E.db.mui.general.shadow and E.db.mui.general.shadow.enable) and not force then return end

	if not frame or frame.MERShadow or frame.shadow then return end

	if frame:GetObjectType() == "Texture" then
		frame = frame:GetParent()
	end

	size = size or 3
	size = size + E.db.mui.general.shadow.increasedSize or 0

	local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetFrameLevel(frame:GetFrameLevel() or 1)
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = size + 1})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.618)

	frame.shadow = shadow
	frame.MERShadow = true
end

function MER:CreateBackdropShadow(frame, defaultTemplate)
	if not frame or frame.MERShadow then return end

	if frame.backdrop then
		if not defaultTemplate then
			frame.backdrop:SetTemplate("Transparent")
		end
		self:CreateShadow(frame.backdrop)
		frame.MERShadow = true
	elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
		self:SecureHook(frame, "CreateBackdrop", function()
			if self:IsHooked(frame, "CreateBackdrop") then
				self:Unhook(frame, "CreateBackdrop")
			end
			if frame.backdrop then
				if not defaultTemplate then
					frame.backdrop:SetTemplate("Transparent")
				end
				self:CreateShadow(frame.backdrop)
				frame.MERShadow = true
			end
		end)
	end
end

function MER:CreateShadowModule(frame)
	if not frame then return end

	MER:CreateShadow(frame)
end

local function Styling(f, useStripes, useGradient, useShadow, shadowOverlayWidth, shadowOverlayHeight, shadowOverlayAlpha)
	assert(f, "doesn't exist!")

	if f:GetObjectType() == "Texture" then
		f = f:GetParent()
	end

	local frameName = f.GetName and f:GetName()
	if f.styling then return end

	local style = CreateFrame("Frame", frameName or nil, f)

	if not(useStripes) then
		local stripes = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		stripes:ClearAllPoints()
		stripes:Point("TOPLEFT", 1, -1)
		stripes:Point("BOTTOMRIGHT", -1, 1)
		stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\stripes]], true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")

		style.stripes = stripes

		if not E.db.mui.general.style then stripes:Hide() end
	end

	if not(useGradient) then
		local gradient = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		gradient:ClearAllPoints()
		gradient:Point("TOPLEFT", 1, -1)
		gradient:Point("BOTTOMRIGHT", -1, 1)
		gradient:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\gradient]])
		gradient:SetVertexColor(.3, .3, .3, .15)

		style.gradient = gradient

		if not E.db.mui.general.style then gradient:Hide() end
	end

	if not(useShadow) then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		mshadow:SetInside(f, 0, 0)
		mshadow:Width(shadowOverlayWidth or 33)
		mshadow:Height(shadowOverlayHeight or 33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Overlay]])
		mshadow:SetVertexColor(1, 1, 1, shadowOverlayAlpha or 0.6)

		style.mshadow = mshadow

		if not E.db.mui.general.style then mshadow:Hide() end
	end

	style:SetFrameLevel(f:GetFrameLevel() + 1)
	f.styling = style

	MER["styling"][style] = true
end

local BlizzardFrameRegions = {
	'Inset',
	'inset',
	'LeftInset',
	'RightInset',
	'NineSlice',
	'BorderFrame',
	'bottomInset',
	'BottomInset',
	'bgLeft',
	'bgRight',
}

local function StripFrame(Frame, Kill, Alpha)
	local FrameName = Frame:GetName()
	for _, Blizzard in pairs(BlizzardFrameRegions) do
		local BlizzFrame = Frame[Blizzard] or FrameName and _G[FrameName..Blizzard]
		if BlizzFrame then
			StripFrame(BlizzFrame, Kill, Alpha)
		end
	end
	if Frame.GetNumRegions then
		for i = 1, Frame:GetNumRegions() do
			local Region = select(i, Frame:GetRegions())
			if Region and Region:IsObjectType('Texture') then
				if Kill then
					Region:Hide()
					Region.Show = MER.dummy
				elseif Alpha then
					Region:SetAlpha(0)
				else
					Region:SetTexture(nil)
				end
			end
		end
	end
end

local function CreateOverlay(f)
	if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:Point("TOPLEFT", -E.mult, E.mult)
		border:Point("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:CreateBackdrop()

	if t == "Transparent" then
		backdropa = 0.45
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = 1
	end

	f.backdrop:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f.backdrop:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
	if not object.StripFrame then mt.StripFrame = StripFrame end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
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
		print(icon..''..MER.Title..format("v|cff00c0fa%s|r", MER.Version)..L[" is loaded. For any issues or suggestions, please visit "]..MER:PrintURL("https://github.com/Merathilis/ElvUI_MerathilisUI/issues"))
	end
end

local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local next = next

local Details = _G.Details

local classes = {
	["WARRIOR"] = true,
	["PALADIN"] = true,
	["HUNTER"] = true,
	["MONK"] = true,
	["ROGUE"] = true,
	["PRIEST"] = true,
	["DEATHKNIGHT"] = true,
	["SHAMAN"] = true,
	["MAGE"] = true,
	["WARLOCK"] = true,
	["DRUID"] = true,
	["DEMONHUNTER"] = true,
	["EVOKER"] = true,
}

local function GetActorClass(actor)
	local class = actor and actor.class and actor:class()
	if class and E:NotSecretValue(class) then
		return class
	end
end

local function SetBarGradient(row, r, g, b)
	if E:IsSecretValue(r) then
		return
	end

	local class = GetActorClass(row.minha_tabela)
	if class and classes[class] then
		row.textura:SetGradient("Horizontal", F.GradientColorsDetails(class))
	else
		row.textura:SetGradient(
			"Horizontal",
			CreateColor(r - 0.5, g - 0.5, b - 0.5, 0.9),
			CreateColor(r + 0.2, g + 0.2, b + 0.2, 0.9)
		)
	end
end

local function GradientBars()
	hooksecurefunc(Details, "InstanceRefreshRows", function(instancia)
		if instancia.barras and instancia.barras[1] then
			for _, row in next, instancia.barras do
				if row and row.textura and not row.textura.__MERSkin then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						SetBarGradient(row, r, g, b)
					end)
					row.textura.__MERSkin = true
				end
			end
		end
	end)
end

-- In combat Details shows secret names, those can't be stripped or shortened
local function SetGradientName(line, db)
	local fontString = line and line.lineText1
	local class = line and GetActorClass(line.minha_tabela)
	if not fontString or not class then
		return
	end

	local name = fontString:GetText()
	if E:NotSecretValue(name) then
		if not name then
			return
		end

		name = E:StripString(name)
		if db.use_multi_fontstrings and db.use_auto_align_multi_fontstrings then
			name = F:ShortenString(name, 10, true)
		end
	end

	fontString:SetText(F.GradientName(name, class))
	fontString:SetShadowOffset(2, -2)
end

local function GradientNames()
	hooksecurefunc(Details.atributo_damage, "RefreshLine", function(_, instance, lineContainer, whichRowLine)
		SetGradientName(lineContainer[whichRowLine], instance)
	end)

	hooksecurefunc(Details.atributo_heal, "RefreshLine", function(_, instance, _, whichRowLine)
		SetGradientName(instance.barras[whichRowLine], instance)
	end)
end

local WINDOW_BASE_Y = 49
local WINDOW_GAP = 20
local MAX_WINDOWS = 5
local DEFAULT_WIDTH = 340
local DEFAULT_HEIGHT = 144

local function MigrateEmbedSizes()
	local db = E.private.mui.skins.embed
	if not (db.width or db.height) then
		return
	end

	local width, height = db.width or DEFAULT_WIDTH, db.height or DEFAULT_HEIGHT
	db.sizes = db.sizes or {}
	for index = 1, MAX_WINDOWS do
		db.sizes[index] = db.sizes[index] or {}
		db.sizes[index].width = db.sizes[index].width or width
		db.sizes[index].height = db.sizes[index].height or height
	end

	db.width = nil
	db.height = nil
end

local function GetEmbedWindowCount()
	return E.private.mui.skins.embed.windows or 1
end

local function GetEmbedWindowSize(index)
	local size = E.private.mui.skins.embed.sizes and E.private.mui.skins.embed.sizes[index]
	return (size and size.width) or DEFAULT_WIDTH, (size and size.height) or DEFAULT_HEIGHT
end

local function GetWindowOffset(index)
	local offset = WINDOW_BASE_Y
	for i = 1, index - 1 do
		local _, height = GetEmbedWindowSize(i)
		offset = offset + height + WINDOW_GAP
	end
	return offset
end

local function SetupInstance(instance)
	if instance.skinned then
		return
	end

	if not instance.baseframe then
		instance:ShowWindow()
		instance.wasHidden = true
	end

	instance.baseframe:CreateBackdrop("Transparent")
	instance.baseframe.backdrop:SetPoint("TOPLEFT", -1, 18)
	WS:CreateBackdropShadow(instance.baseframe)

	if instance:GetId() <= GetEmbedWindowCount() then
		local open, close = module:CreateToggle(instance.baseframe)
		open:HookScript("OnClick", function()
			instance:ShowWindow()
		end)
		close:HookScript("OnClick", function()
			instance:HideWindow()
		end)
		if instance.wasHidden then
			close:Click()
		end
	end

	instance.skinned = true
end

local function EmbedWindow(instance, x, y, width, height)
	if not instance.baseframe then
		return
	end

	instance.baseframe:ClearAllPoints()
	instance.baseframe:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", x, y)
	instance:SetSize(width, height)
	instance:SaveMainWindowPosition()
	instance:RestoreMainWindowPosition()
	instance:LockInstance(true)
end

local function isDefaultOffset(offset)
	return offset and abs(offset) < 10
end

local function IsDefaultAnchor(instance)
	local frame = instance and instance.baseframe
	if not frame then
		return
	end
	local relF, _, relT, x, y = frame:GetPoint()

	return (relF == "CENTER" and relT == "CENTER" and isDefaultOffset(x) and isDefaultOffset(y))
end

function module:ResetDetailsAnchor(force)
	if not Details then
		return
	end

	local instance1 = Details:GetInstance(1)
	if not instance1 or not (force or IsDefaultAnchor(instance1)) then
		return instance1
	end

	local windows = GetEmbedWindowCount()

	for index = 1, windows do
		local instance = Details:GetInstance(index)
		if instance then
			local width, height = GetEmbedWindowSize(index)
			EmbedWindow(instance, -3, GetWindowOffset(index), width, height)
		end
	end

	return instance1
end

function module:ResetEmbedDefaults()
	local db = E.private.mui.skins.embed
	db.windows = 1
	db.sizes = {}
	for index = 1, MAX_WINDOWS do
		db.sizes[index] = { width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT }
	end

	self:ResetDetailsAnchor(true)
end

local function ReskinDetails()
	MigrateEmbedSizes()

	local windows = GetEmbedWindowCount()

	Details.tabela_instancias = Details.tabela_instancias or {}
	Details.instances_amount = max(Details.instances_amount or 5, windows)

	local index = 1
	local instance = Details:GetInstance(index)
	while instance do
		SetupInstance(instance)
		index = index + 1
		instance = Details:GetInstance(index)
	end

	-- Reanchor
	local instance1 = module:ResetDetailsAnchor()

	local listener = Details:CreateEventListener()
	listener:RegisterEvent("DETAILS_INSTANCE_OPEN")
	function listener:OnDetailsEvent(event, openedInstance)
		if event == "DETAILS_INSTANCE_OPEN" then
			if not openedInstance.skinned then
				local id = openedInstance:GetId()
				if id > 1 and id <= GetEmbedWindowCount() then
					local width, height = GetEmbedWindowSize(id)
					EmbedWindow(openedInstance, -3, GetWindowOffset(id), width, height)
				end
			end
			SetupInstance(openedInstance)
		end
	end

	-- Reset to one window
	Details.OpenWelcomeWindow = function()
		if instance1 then
			local width, height = GetEmbedWindowSize(1)
			EmbedWindow(instance1, -3, 24, width, height)
		end
	end
end

function module:Details()
	if not E.private.mui.skins.addonSkins.enable then
		return
	end

	local db = E.private.mui.skins.addonSkins.dt
	if db and db.enable then
		if db.gradientBars then
			GradientBars()
		end
		if db.gradientName then
			GradientNames()
		end
	end

	if E.private.mui.skins.embed and E.private.mui.skins.embed.enable then
		ReskinDetails()
	end
end

module:AddCallbackForAddon("Details")

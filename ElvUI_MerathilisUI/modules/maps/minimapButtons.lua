local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIMinimapButtons")
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua functions
local _G = _G
local ipairs, pairs, select, tonumber, unpack = ipairs, pairs, select, tonumber, unpack
local strfind, strmatch, strupper = strfind, strmatch, strupper
local tinsert = table.insert
--WoW API / Variables
local C_Timer_After = C_Timer.After
local InCombatLockdown = InCombatLockdown
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local C_PetBattles_IsInBattle = C_PetBattles.IsInBattle
local Minimap = Minimap
local CreateFrame = CreateFrame
-- GLOBALS:

local r, g, b = unpack(E.media.rgbvaluecolor)

module.Buttons = {}
module.BlackList = {
	["GameTimeFrame"] = true,
	["MiniMapLFGFrame"] = true,
	["BattlefieldMinimap"] = true,
	["MinimapBackdrop"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
	["HelpOpenTicketButton"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["QueueStatusMinimapButton"] = true,
	["GarrisonLandingPageMinimapButton"] = true,
	["MinimapZoneTextButton"] = true,
	["MinimapButtonFrame"] = true,
	["MinimapButtonsToggleButton"] = true,
}

module.OverrideTexture = {
	BagSync_MinimapButton = [[Interface\AddOns\BagSync\media\icon]],
	DBMMinimapButton = [[Interface\Icons\INV_Helmet_87]],
	SmartBuff_MiniMapButton = [[Interface\Icons\Spell_Nature_Purge]],
	VendomaticButtonFrame = [[Interface\Icons\INV_Misc_Rabbit_2]],
}

local RemoveTextureID = {
	[136430] = true,
	[136467] = true,
	[130924] = true,
}

local function HideButton()
	module.bin:Hide()
end

local function ClickFunc()
	UIFrameFadeOut(module.bin, .5, 1, 0)
	C_Timer_After(.5, HideButton)
end

function module:CollectButtons()
	if (InCombatLockdown() or C_PetBattles and C_PetBattles_IsInBattle()) then return end

	local size = module.db.size or 34

	for _, child in ipairs({ Minimap:GetChildren() }) do
		local name = child:GetName()
		if name and not module.BlackList[name] and not strmatch(strupper(name), "HANDYNOTES") then
			if child:GetObjectType() == "Button" or strmatch(strupper(name), "BUTTON") then
				child:SetParent(module.bin)
				child:SetSize(size, size)

				for j = 1, child:GetNumRegions() do
					local region = select(j, child:GetRegions())
					if region.IsObjectType and region:IsObjectType("Texture") then
						local texture = region:GetTexture() or ""

						if RemoveTextureID[tonumber(texture)] then
							region:SetTexture()
						elseif strfind(texture, "Interface\\CharacterFrame") or strfind(texture, "Interface\\Minimap") then
							region:SetTexture()
							region:SetAlpha(0)
						elseif texture == 136430 or texture == 136467 then
							region:SetTexture()
						else
							if module.OverrideTexture[name] then
								region:SetTexture(module.OverrideTexture[name])
							elseif name == 'OutfitterMinimapButton' and texture == [[interface\addons\outfitter\textures\minimapbutton]] then
								region:SetTexture()
							end
						end
						region:ClearAllPoints()
						region:SetAllPoints()
						region:SetTexCoord(unpack(E.TexCoords))
					end
				end

				if child:HasScript("OnDragStart") then child:SetScript("OnDragStart", nil) end
				if child:HasScript("OnDragStop") then child:SetScript("OnDragStop", nil) end
				if child:HasScript("OnClick") then child:HookScript("OnClick", ClickFunc) end

				if child:GetObjectType() == "Button" then
					child:SetHighlightTexture("Interface\\ChatFrame\\ChatFrameBackground") -- prevent nil function
					child:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				elseif child:GetObjectType() == "Frame" then
					child.highlight = child:CreateTexture(nil, "HIGHLIGHT")
					child.highlight:SetAllPoints()
					child.highlight:SetColorTexture(1, 1, 1, .25)
				end

				child:CreateBackdrop("Transparent")
				child.backdrop:Styling()

				-- Naughty Addons
				if name == "DBMMinimapButton" then
					child:SetScript("OnMouseDown", nil)
					child:SetScript("OnMouseUp", nil)
				elseif name == "BagSync_MinimapButton" then
					child:HookScript("OnMouseUp", ClickFunc)
				end

				tinsert(module.Buttons, child)
			end
		end
	end
end

function module:SortButtons()
	if #module.Buttons == 0 then return end

	local lastbutton
	for _, button in pairs(module.Buttons) do
		if button:IsShown() then
			button:ClearAllPoints()
			if not lastbutton then
				button:SetPoint("RIGHT", module.bin, -3, 0)
			else
				button:SetPoint("RIGHT", lastbutton, "LEFT", -3, 0)
			end
			lastbutton = button
		end
	end
end

function module:Initialize()
	local db = E.db.mui.smb
	MER:RegisterDB(self, "smb")
	if db.enable ~= true then return end

	-- Compatibility
	if COMP.SLE and E.private.sle.minimap.mapicons.enable then return end

	local pos = db.position or "TOPRIGHT"
	local x = db.xOffset or 10
	local y = db.yOffset or 20

	-- Button Creation
	module.button = CreateFrame("Button", "MinimapButtonsToggleButton", Minimap)
	module.button:SetSize(28, 28)
	module.button:SetPoint(pos, x, y)
	module.button.Icon = module.button:CreateTexture(nil, "ARTWORK")
	module.button.Icon:SetAllPoints()
	module.button.Icon:SetTexture("Interface\\HelpFrame\\ReportLagIcon-Loot")
	module.button:SetHighlightTexture("Interface\\HelpFrame\\ReportLagIcon-Loot")

	module.bin = CreateFrame("Frame", "MinimapButtonFrame", E.UIParent)
	module.bin:SetPoint("BOTTOMRIGHT", module.button, "TOPLEFT", 0, -15)
	module.bin:Hide()
	MER:CreateGradientFrame(module.bin, 220, 40, "Horizontal", 0, 0, 0, 0, .7)

	-- Styling
	local topLine = CreateFrame("Frame", nil, module.bin)
	topLine:SetPoint("BOTTOMRIGHT", module.bin, "TOPRIGHT", 1, 0)
	MER:CreateGradientFrame(topLine, 220, 1, "Horizontal", r, g, b, 0, .7)

	local bottomLine = CreateFrame("Frame", nil, module.bin)
	bottomLine:SetPoint("TOPRIGHT", module.bin, "BOTTOMRIGHT", 1, 0)
	MER:CreateGradientFrame(bottomLine, 220, 1, "Horizontal", r, g, b, 0, .7)

	local rightLine = CreateFrame("Frame", nil, module.bin)
	rightLine:SetPoint("LEFT", module.bin, "RIGHT", 0, 0)
	MER:CreateGradientFrame(rightLine, 1, 40, "Vertical", r, g, b, .7, .7)
	module.bin:SetFrameStrata("HIGH")

	-- Button Scripts
	module.button:SetScript("OnClick", function()
		self:SortButtons()
		if module.bin:IsShown() then
			ClickFunc()
		else
			UIFrameFadeIn(module.bin, .5, 0, 1)
		end
	end)

	C_Timer_After(.3, function()
		self:CollectButtons()
		self:SortButtons()
	end)
end

MER:RegisterModule(module:GetName())

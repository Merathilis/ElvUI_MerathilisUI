local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("RandomToy", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select = pairs, select
local format = string.format
local tinsert = table.insert
local random = random
--WoW API / Variables
local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local C_ToyBox_IsToyUsable = C_ToyBox.IsToyUsable
local GetItemCooldown = GetItemCooldown
local CreateMacro = CreateMacro
local EditMacro = EditMacro
local GetMacroInfo = GetMacroInfo
local GetNumMacros = GetNumMacros
local PickupMacro = PickupMacro
local InCombatLockdown = InCombatLockdown
local PlayerHasToy = PlayerHasToy
local SlashCmdList = SlashCmdList
-- GLOBALS:

local macroName = "RANDOMTOY"
local macroTemplate =
"#showtooltip %s\n" ..
"/randomtoy check\n" ..
"/cast %s"

local function IsMyToyUsable(itemID)
	local startTime, duration, enable = GetItemCooldown(itemID)

	if enable == 1 and duration > 0 then
		return false
	end

	return true
end

function module:UpdateMacro()
	if not E.db.mui.actionbars.randomToy.enable then return end

	if InCombatLockdown() then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	local macroIcon = select(2, C_ToyBox_GetToyInfo(130209))
	local toyname = ""
	local templist = {}

	for k, v in pairs(E.db.mui.actionbars.randomToy.toyList) do
		if v and PlayerHasToy(k) and C_ToyBox_IsToyUsable(k) and IsMyToyUsable(k) and C_ToyBox_GetToyInfo(k) then
			tinsert(templist, k)
		end
	end

	if #templist > 0 then
		toyname = select(2, C_ToyBox_GetToyInfo(templist[random(#templist)]))
	else
		MER:Print(L["It seems that this toy are on cooldown"])
	end

	local text = format(macroTemplate, macroIcon, toyname)
	local name = GetMacroInfo(macroName)

	if not name then
		local numGlobal = GetNumMacros()
		if numGlobal < 72 then
			CreateMacro(macroName, "INV_MISC_QUESTIONMARK", text)
		end
	else
		EditMacro(macroName, nil, nil, text)
	end
end

function module:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UpdateMacro()
end

function module:Initialize()
	self:RegisterEvent("NEW_TOY_ADDED", "UpdateMacro")
	SlashCmdList["RANDOMTOY"] = function(msg)
		if msg == "check" then
			self:UpdateMacro()
		else
			self:UpdateMacro()
			local name = GetMacroInfo(macroName)
			if name then
				MER:Print(L["A random toy macro has created, please put it in your Actionbar!"])
				PickupMacro("RANDOMTOY")
			end
		end
	end
	_G.SLASH_RANDOMTOY1 = "/randomtoy"
end

MER:RegisterModule(module:GetName())

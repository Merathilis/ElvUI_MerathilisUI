local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G

local format = format
local next, pairs, print, type = next, pairs, print, type
local strlower = strlower
local strsub = strsub
local strupper = strupper
local wipe = table.wipe

local SetCVar = C_CVar.SetCVar
local Reload = C_UI.Reload
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local DisableAddOn = C_AddOns.DisableAddOn
local EnableAddOn = C_AddOns.EnableAddOn
local GetNumAddOns = C_AddOns.GetNumAddOns

---Registers a new command with the MerathilisUI addon system
---@param name string The name/identifier for the command
---@param keys string|table The command key(s) or aliases that will trigger this command
---@param func function The callback function to execute when the command is invoked
function MER:AddCommand(name, keys, func)
	name = strupper(name)
	if not _G.SlashCmdList["MERATHILISUI_" .. name] then
		_G.SlashCmdList["MERATHILISUI_" .. name] = func

		if type(keys) == "table" then
			for i, key in next, keys do
				if strsub(key, 1, 1) ~= "/" then
					key = "/" .. key
				end
				_G["SLASH_MERATHILISUI_" .. name .. i] = key
			end
		else
			if strsub(keys, 1, 1) ~= "/" then
				keys = "/" .. keys
			end
			_G["SLASH_MERATHILISUI_" .. name .. "1"] = keys
		end
	end
end

do
	local AcceptableAddons = {
		["ElvUI"] = true,
		["ElvUI_Libraries"] = true,
		["ElvUI_Options"] = true,
		["ElvUI_CPU"] = true,
		["ElvUI_MerathilisUI"] = true,
		["ElvUI_WindTools"] = true,
		["Blinkiis_Portraits"] = true,
		["ElvUI_mMediaTag"] = true,
		["!BugGrabber"] = true,
		["BugSack"] = true,
		["DevTool"] = true, -- used by /muidev dump
	}

	-- Addons disabled by debug mode, kept in ElvDB across logins
	local function GetDisabledAddOns()
		_G.ElvDB.MER = _G.ElvDB.MER or {}
		_G.ElvDB.MER.DisabledAddOns = _G.ElvDB.MER.DisabledAddOns or {}
		return _G.ElvDB.MER.DisabledAddOns
	end

	MER:AddCommand("ERROR", "/muidebug", function(msg)
		local switch = strlower(msg or "")
		if switch == "on" or switch == "1" then
			local disabled = GetDisabledAddOns()
			for i = 1, GetNumAddOns() do
				local name = GetAddOnInfo(i)
				if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
					DisableAddOn(name, E.myguid)
					disabled[name] = i
				end
			end

			SetCVar("scriptErrors", 1)
			Reload()
		elseif switch == "off" or switch == "0" then
			SetCVar("scriptProfile", 0)
			SetCVar("scriptErrors", 0)
			E:Print("Lua errors off.")

			if E:IsAddOnEnabled("ElvUI_CPU") then
				DisableAddOn("ElvUI_CPU", E.myguid)
			end

			local disabled = GetDisabledAddOns()
			if next(disabled) then
				for name in pairs(disabled) do
					EnableAddOn(name, E.myguid)
				end
				wipe(disabled)
				Reload()
			end
		else
			WF.PrintGradientLine()
			F.Print(L["Usage"] .. ": /muidebug [on|off]")
			print("on  ", L["Enable debug mode"])
			print("      ", format(L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."], MER.Title))
			print("off ", L["Disable debug mode"])
			print("      ", L["Reenable the addons that disabled by debug mode."])
			WF.PrintGradientLine()
		end
	end)

	function MER.PrintDebugEnviromentTip()
		WF.PrintGradientLine()
		F.Print(L["Debug Enviroment"])
		print(L["You can use |cff00ff00/muidebug off|r command to exit debug mode."])
		print(format(L["After you stop debuging, %s will reenable the addons automatically."], MER.Title))
		WF.PrintGradientLine()
	end
end

function MER:ShowStatusReport()
	if not F.IsMERProfile() then
		F.Print("You are not using a " .. MER.Title .. " Profile")
		return
	end

	self:GetModule("MER_Misc"):StatusReportShow()
end

function MER:HandleChatCommand(msg)
	local category = self:GetArgs(msg)

	if not category then
		E:ToggleOptions("mui")
	elseif category == "changelog" or category == "cl" then
		E:ToggleOptions("mui,changelog")
	elseif category == "settings" then
		E:ToggleOptions("mui")
	elseif category == "status" or category == "info" then
		self:ShowStatusReport()
	elseif category == "install" or category == "i" then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	else
		if not F.IsMERProfile() then
			F.Print("You are not using a " .. MER.Title .. " profile. Please install " .. MER.Title .. " first.")
		end
		F.Print("Usage: /mer [changelog|cl] [install|i] [status|info] [settings]")
		F.Print("Debugging: /muidebug [on|off], /muidev")
	end
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "HandleChatCommand")
	self:RegisterChatCommand("mer", "HandleChatCommand")
	self:RegisterChatCommand("merathilis", "HandleChatCommand")
	self:RegisterChatCommand("merathilisui", "HandleChatCommand")

	self:AddCommand("DEV", "/muidev", F.Developer.HandleCommand)

	self:AddCommand("WOWVERSION", { "/patch", "/version" }, function()
		print(
			format(
				"Patch: %s, Build: %s, Released %s, Interface: %s",
				MER.WoWPatch,
				MER.WoWBuild,
				MER.WoWPatchReleaseDate,
				MER.TocVersion
			)
		)
	end)
end

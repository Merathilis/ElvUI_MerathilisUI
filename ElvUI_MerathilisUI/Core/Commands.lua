local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G

local format = format
local next, pairs, print, type = next, pairs, print, type
local strlower = strlower
local strsub = strsub
local wipe = table.wipe

local SetCVar = C_CVar.SetCVar
local Reload = C_UI.Reload
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local DisableAddOn = C_AddOns.DisableAddOn
local EnableAddOn = C_AddOns.EnableAddOn
local GetNumAddOns = C_AddOns.GetNumAddOns

function MER:AddCommand(name, keys, func)
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
		["!BugGrabber"] = true,
		["BugSack"] = true,
	}

	MER:AddCommand("ERROR", "/muidebug", function(msg)
		local switch = strlower(msg)
		if switch == "on" or switch == "1" then
			for i = 1, GetNumAddOns() do
				local name = GetAddOnInfo(i)
				if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
					DisableAddOn(name, E.myname)
					_G.ElvDB.MER.DisabledAddOns[name] = i
				end
			end

			SetCVar("scriptErrors", 1)
			Reload()
		elseif switch == "off" or switch == "0" then
			SetCVar("scriptProfile", 0)
			SetCVar("scriptErrors", 0)
			E:Print("Lua errors off.")

			if E:IsAddOnEnabled("ElvUI_CPU") then
				DisableAddOn("ElvUI_CPU")
			end

			if next(ElvDB.MER.DisabledAddOns) then
				for name in pairs(ElvDB.MER.DisabledAddOns) do
					EnableAddOn(name, E.myname)
				end
				wipe(ElvDB.MER.DisabledAddOns)
				Reload()
			end
		else
			F.PrintGradientLine()
			F.Print(L["Usage"] .. ": /muidebug [on|off]")
			print("on  ", L["Enable debug mode"])
			print("      ", format(L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."], MER.Title))
			print("off ", L["Disable debug mode"])
			print("      ", L["Reenable the addons that disabled by debug mode."])
			F.PrintGradientLine()
		end
	end)

	function MER.PrintDebugEnviromentTip()
		F.PrintGradientLine()
		F.Print(L["Debug Enviroment"])
		print(L["You can use |cff00ff00/muidebug off|r command to exit debug mode."])
		print(format(L["After you stop debuging, %s will reenable the addons automatically."], MER.Title))
		F.PrintGradientLine()
	end
end

function MER:ShowStatusReport()
	if not F.IsMERProfile() then
		F.Developer.LogInfo("You are not using a " .. MER.Title .. " Profile")
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
	elseif (category == "status" or category == "info") and F.IsMERProfile() then
		self:ShowStatusReport()
	elseif category == "install" or category == "i" then
		E:GetModule("PluginInstaller"):Queue(MER.installTable)
	elseif F.IsMERProfile() then
		self:LogInfo("Usage: /tx cl; changelog; install; i; info; settings; status; wb; debug")
	else
		F.Developer.LogWarning("Usage: /mer cl; changelog; install; i; settings")
	end
end

function MER:LoadCommands()
	self:RegisterChatCommand("mui", "HandleChatCommand")
	self:RegisterChatCommand("mer", "HandleChatCommand")
	self:RegisterChatCommand("merathilis", "HandleChatCommand")
	self:RegisterChatCommand("merathilisui", "HandleChatCommand")
end

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G

local format = format
local next, pairs, print, type = next, pairs, print, type
local strlower = strlower
local strsub = strsub
local wipe = table.wipe

local C_CVar_SetCVar = C_CVar.SetCVar
local C_UI_Reload = C_UI.Reload
local C_AddOns_GetAddOnInfo = C_AddOns.GetAddOnInfo
local C_AddOns_DisableAddOn = C_AddOns.DisableAddOn
local C_AddOns_EnableAddOn = C_AddOns.EnableAddOn
local C_AddOns_GetNumAddOns = C_AddOns.GetNumAddOns

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
			for i = 1, C_AddOns_GetNumAddOns() do
				local name = C_AddOns_GetAddOnInfo(i)
				if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
					C_AddOns_DisableAddOn(name, E.myname)
					_G.ElvDB.MER.DisabledAddOns[name] = i
				end
			end

			C_CVar_SetCVar("scriptErrors", 1)
			C_UI_Reload()
		elseif switch == "off" or switch == "0" then
			C_CVar_SetCVar("scriptProfile", 0)
			C_CVar_SetCVar("scriptErrors", 0)
			E:Print("Lua errors off.")

			if E:IsAddOnEnabled("ElvUI_CPU") then
				C_AddOns_DisableAddOn("ElvUI_CPU")
			end

			if next(ElvDB.MER.DisabledAddOns) then
				for name in pairs(ElvDB.MER.DisabledAddOns) do
					C_AddOns_EnableAddOn(name, E.myname)
				end
				wipe(ElvDB.MER.DisabledAddOns)
				C_UI_Reload()
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

local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local next, pairs, print = next, pairs, print
local twipe = table.wipe
-- WoW API / Variables
local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local ReloadUI = ReloadUI
local SetCVar = SetCVar
-- GLOBALS: ElvDB

function MER:LuaError(msg)
	local switch = strlower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if (name ~= 'ElvUI' and name ~= 'ElvUI_OptionsUI' and name ~= 'ElvUI_MerathilisUI') and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				ElvDB.MERErrorDisabledAddOns[name] = i
			end
		end

		SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == '0' then
		if switch == 'off' then
			SetCVar('scriptErrors', 0)
			MER:Print('Lua errors off.')
		end

		if next(ElvDB.MERErrorDisabledAddOns) then
			for name in pairs(ElvDB.MERErrorDisabledAddOns) do
				EnableAddOn(name, E.myname)
			end

			twipe(ElvDB.MERErrorDisabledAddOns)
			ReloadUI()
		end
	else
		MER:Print('/muierror on - /muierror off')
	end
end

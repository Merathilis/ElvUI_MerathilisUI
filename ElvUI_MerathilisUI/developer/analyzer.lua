--Cache global variables
local _G = _G
local ipairs = ipairs
--WoW API / Variables
local GetCVar = GetCVar
local SetCVar = SetCVar
local ReloadUI = ReloadUI
local GetMouseFocus = GetMouseFocus
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SLASH_ANALYZE1, SLASH_PROFILE1, ChatFrame1, FRAME

SLASH_ANALYZE1 = "/analyze"

SlashCmdList["ANALYZE"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil then FRAME = arg end --Set the global variable FRAME to = whatever we are mousing over to simplify messing with frames that have no name.
	if arg ~= nil and arg:GetName() ~= nil then
		local name = arg:GetName()
		
		local childFrames = { arg:GetChildren() }
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage(name)
		for _, child in ipairs(childFrames) do
			if child:GetName() then
				ChatFrame1:AddMessage("+="..child:GetName())
			end
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")	
	end
end

SLASH_PROFILE1 = "/profile"
SlashCmdList["PROFILE"] = function(arg)
	local cpuProfiling = GetCVar("scriptProfile") == "1"
	if cpuProfiling then
		SetCVar("scriptProfile", "0")
	else
		SetCVar("scriptProfile", "1")
	end
	ReloadUI()
end
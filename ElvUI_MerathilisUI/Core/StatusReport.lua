local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local _G = _G
local hooksecurefunc = hooksecurefunc

local function CreateStatusFrame()
	local StatusFrame = _G["ElvUIStatusReport"]
	local PluginFrame = _G["ElvUIStatusPlugins"]
end
hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)

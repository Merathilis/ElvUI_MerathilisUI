local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G
local hooksecurefunc = hooksecurefunc

local function CreateStatusFrame()
	local StatusFrame = _G["ElvUIStatusReport"]
	local PluginFrame = _G["ElvUIStatusPlugins"]
end
hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)

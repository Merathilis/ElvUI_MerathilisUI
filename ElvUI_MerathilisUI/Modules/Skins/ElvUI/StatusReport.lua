local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function CreateStatusFrame()
	local StatusFrame = _G.ElvUIStatusReport
	local PluginFrame = _G.ElvUIStatusPlugins

	module:CreateShadow(StatusFrame)
	module:CreateShadow(PluginFrame)
end

hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)

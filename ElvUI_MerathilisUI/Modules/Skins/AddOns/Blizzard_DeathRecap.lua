local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("deathRecap", "deathRecap") then
		return
	end

	local DeathRecapFrame = _G.DeathRecapFrame
	module:CreateShadow(DeathRecapFrame)
end

S:AddCallbackForAddon("Blizzard_DeathRecap", LoadSkin)

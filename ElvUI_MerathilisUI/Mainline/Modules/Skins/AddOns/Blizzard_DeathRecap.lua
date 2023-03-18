local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("deathRecap", "deathRecap") then
		return
	end

	local DeathRecapFrame = _G.DeathRecapFrame
	DeathRecapFrame:Styling()
	module:CreateBackdropShadow(DeathRecapFrame)
end

S:AddCallbackForAddon("Blizzard_DeathRecap", LoadSkin)

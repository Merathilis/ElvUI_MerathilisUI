local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("azeriteRespec", "AzeriteRespec") then
		return
	end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	AzeriteRespecFrame:Styling()
	module:CreateBackdropShadow(AzeriteRespecFrame)
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", LoadSkin)

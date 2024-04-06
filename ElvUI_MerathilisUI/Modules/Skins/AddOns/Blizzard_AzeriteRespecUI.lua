local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AzeriteRespecUI()
	if not module:CheckDB("azeriteRespec", "AzeriteRespec") then
		return
	end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	module:CreateBackdropShadow(AzeriteRespecFrame)
end

module:AddCallbackForAddon("Blizzard_AzeriteRespecUI")

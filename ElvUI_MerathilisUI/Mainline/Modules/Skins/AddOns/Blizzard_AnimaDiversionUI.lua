local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("animaDiversion", "animaDiversion") then
		return
	end

	local frame = _G.AnimaDiversionFrame
	frame:Styling()
	module:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon("Blizzard_AnimaDiversionUI", LoadSkin)

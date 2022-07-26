local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("bgmap", "bgmap") then
		return
	end

	local BattlefieldMapFrame = _G.BattlefieldMapFrame
	BattlefieldMapFrame:Styling()
	module:CreateShadow(BattlefieldMapFrame)
end

S:AddCallbackForAddon("Blizzard_BattlefieldMap", LoadSkin)

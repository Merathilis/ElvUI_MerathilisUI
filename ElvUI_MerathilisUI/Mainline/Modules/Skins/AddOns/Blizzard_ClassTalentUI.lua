local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local ClassTalentFrame = _G.ClassTalentFrame
	ClassTalentFrame:Styling()
	module:CreateShadow(ClassTalentFrame)
end

S:AddCallbackForAddon('Blizzard_ClassTalentUI', LoadSkin)

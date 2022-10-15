local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("dressingroom", "dressingroom") then
		return
	end

	local DressUpFrame = _G.DressUpFrame
	if DressUpFrame.backdrop then
		DressUpFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(DressUpFrame)
end

S:AddCallback("DressUpFrames", LoadSkin)

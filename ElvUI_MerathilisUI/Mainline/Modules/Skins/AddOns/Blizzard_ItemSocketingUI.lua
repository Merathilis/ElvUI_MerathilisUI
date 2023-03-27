local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select, unpack = select, unpack

local function LoadSkin()
	if not module:CheckDB("socket", "socket") then
		return
	end

	local ItemSocketingFrame = _G["ItemSocketingFrame"]
	ItemSocketingFrame:Styling()
	module:CreateBackdropShadow(ItemSocketingFrame)

	local title = select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -5)
end

S:AddCallbackForAddon("Blizzard_ItemSocketingUI", LoadSkin)

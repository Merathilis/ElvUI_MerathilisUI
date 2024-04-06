local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

local _G = _G
local select = select

function module:Blizzard_ItemSocketingUI()
	if not module:CheckDB("socket", "socket") then
		return
	end

	local ItemSocketingFrame = _G["ItemSocketingFrame"]
	module:CreateBackdropShadow(ItemSocketingFrame)

	local title = select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -5)
end

S:AddCallbackForAddon("Blizzard_ItemSocketingUI")

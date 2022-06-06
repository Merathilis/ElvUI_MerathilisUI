local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("voidstorage", "voidstorage") then
		return
	end

	local VoidStorageFrame = _G.VoidStorageFrame
	VoidStorageFrame:Styling()
	MER:CreateShadow(VoidStorageFrame)

	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("LEFT", VoidStorageFrame, "TOPRIGHT", 2, -60)
end

S:AddCallbackForAddon("Blizzard_VoidStorageUI", LoadSkin)

local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_VoidStorageUI()
	if not module:CheckDB("voidstorage", "voidstorage") then
		return
	end

	local VoidStorageFrame = _G.VoidStorageFrame
	module:CreateShadow(VoidStorageFrame)

	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("LEFT", VoidStorageFrame, "TOPRIGHT", 2, -60)
end

module:AddCallbackForAddon("Blizzard_VoidStorageUI")

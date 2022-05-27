local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_VoidStorageUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.voidstorage ~= true or not E.private.mui.skins.blizzard.voidstorage then return end

	local VoidStorageFrame = _G.VoidStorageFrame
	VoidStorageFrame:Styling()
	MER:CreateShadow(VoidStorageFrame)

	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("LEFT", VoidStorageFrame, "TOPRIGHT", 2, -60)
end

module:AddCallbackForAddon("Blizzard_VoidStorageUI")

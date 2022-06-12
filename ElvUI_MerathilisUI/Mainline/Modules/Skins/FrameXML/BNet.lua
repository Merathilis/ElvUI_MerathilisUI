local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local BNToastFrame = _G.BNToastFrame
	BNToastFrame:Styling()
	module:CreateShadow(BNToastFrame)

	-- /run BNToastFrame:AddToast(BN_TOAST_TYPE_ONLINE, 1)
	hooksecurefunc(BNToastFrame, 'ShowToast', function(self)
		if not self.IsSkinned then
			S:HandleCloseButton(self.CloseButton)
			self.IsSkinned = true
		end
	end)
end

S:AddCallback("BNet", LoadSkin)

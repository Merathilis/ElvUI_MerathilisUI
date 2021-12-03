local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local BNToastFrame = _G.BNToastFrame
	BNToastFrame:Styling()
	MER:CreateShadow(BNToastFrame)

	-- /run BNToastFrame:AddToast(BN_TOAST_TYPE_ONLINE, 1)
	hooksecurefunc(BNToastFrame, 'ShowToast', function(self)
		if not self.IsSkinned then
			S:HandleCloseButton(self.CloseButton)
			self.IsSkinned = true
		end
	end)
end

S:AddCallback("mUIBNet", LoadSkin)

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

function module:BNet()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local BNToastFrame = _G.BNToastFrame
	module:CreateShadow(BNToastFrame)

	-- /run BNToastFrame:AddToast(BN_TOAST_TYPE_ONLINE, 1)
	hooksecurefunc(BNToastFrame, "ShowToast", function(self)
		if not self.__MERSkin then
			S:HandleCloseButton(self.CloseButton)
			self.__MERSkin = true
		end
	end)

	module:CreateShadow(_G.BattleTagInviteFrame)
end

module:AddCallback("BNet")

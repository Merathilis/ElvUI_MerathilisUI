local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("lfguild", "lfguild") then
		return
	end

	local function SkinLFGuild(self)
		self:Styling()
		MER:CreateBackdropShadow(self)
	end
	hooksecurefunc("LookingForGuildFrame_OnShow", SkinLFGuild)

	local styled
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end
		F.ReskinRole(_G.LookingForGuildTankButton, "TANK")
		F.ReskinRole(_G.LookingForGuildHealerButton, "HEALER")
		F.ReskinRole(_G.LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end

S:AddCallbackForAddon("Blizzard_LookingForGuildUI", LoadSkin)

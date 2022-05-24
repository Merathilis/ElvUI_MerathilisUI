local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

function module:Blizzard_LookingForGuildUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfguild ~= true or E.private.mui.skins.blizzard.lfguild ~= true then return end

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

module:AddCallbackForAddon("Blizzard_LookingForGuildUI")

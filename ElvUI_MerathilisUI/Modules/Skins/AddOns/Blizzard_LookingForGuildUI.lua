local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SkinLFGuild(self)
	module:CreateBackdropShadow(self)
end

function module:Blizzard_LookingForGuildUI()
	if not module:CheckDB("lfguild", "lfguild") then
		return
	end

	hooksecurefunc("LookingForGuildFrame_OnShow", SkinLFGuild)

	local styled
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then
			return
		end
		F.ReskinRole(_G.LookingForGuildTankButton, "TANK")
		F.ReskinRole(_G.LookingForGuildHealerButton, "HEALER")
		F.ReskinRole(_G.LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end

module:AddCallbackForAddon("Blizzard_LookingForGuildUI")

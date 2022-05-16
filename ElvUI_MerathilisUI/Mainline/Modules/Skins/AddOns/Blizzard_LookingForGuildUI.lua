local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function LoadSkin()
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

S:AddCallbackForAddon("Blizzard_LookingForGuildUI", "mUILookingForGuild", LoadSkin)

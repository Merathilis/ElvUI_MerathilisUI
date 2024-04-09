local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local ipairs = ipairs

function module:Blizzard_CovenantSanctum()
	if not module:CheckDB("covenantSanctum", "covenantSanctum") then
		return
	end

	local frame = _G.CovenantSanctumFrame

	frame:HookScript("OnShow", function()
		if not frame.__MERSkin then
			module:CreateBackdropShadow(frame)

			local UpgradesTab = frame.UpgradesTab
			local TalentList = frame.UpgradesTab.TalentsList

			frame.LevelFrame.Background:SetAlpha(0)
			UpgradesTab.Background:SetAlpha(0)
			TalentList.Divider:SetAlpha(0)
			TalentList.BackgroundTile:SetAlpha(0)

			for _, frame in ipairs(UpgradesTab.Upgrades) do
				if frame.RankBorder then
					frame.RankBorder:SetAlpha(0)
				end
			end

			frame.__MERSkin = true
		end
	end)
end

module:AddCallbackForAddon("Blizzard_CovenantSanctum")

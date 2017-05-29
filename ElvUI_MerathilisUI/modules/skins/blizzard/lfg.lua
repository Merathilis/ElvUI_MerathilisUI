local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions

--WoW API / Variables

local function styleLFG()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true then return end

	if not PVEFrame.stripes then
		MERS:CreateStripes(PVEFrame)
	end

	-- Category selection

	local CategorySelection = LFGListFrame.CategorySelection

	CategorySelection.Inset.Bg:Hide()
	select(10, CategorySelection.Inset:GetRegions()):Hide()
	CategorySelection.Inset:DisableDrawLayer("BORDER")

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 2, 0)
			bg:SetPoint("BOTTOMRIGHT", -1, 2)
			MERS:CreateBD(bg, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)

			local tex = MERS:CreateGradient(bu)
			tex:SetDrawLayer("BACKGROUND")
			tex:SetPoint("TOPLEFT", 3, -1)
			tex:SetPoint("BOTTOMRIGHT", -2, 3)
		end
	end)
end

S:AddCallback("mUILFG", styleLFG)
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

	local function onEnter(self)
		self:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .4)
	end

	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, 0)
	end

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]
		bu:StripTextures()

		bu.ring:Hide()
		bu.bg:SetTexture(E["media"].normTex)
		bu.bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		bu.bg:SetAllPoints()

		MERS:Reskin(bu, true)
		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.icon:ClearAllPoints()
		bu.icon:Point("LEFT", bu, "LEFT", 10, 0)
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon.bg = MERS:CreateBG(bu.icon)
		bu.icon.bg:SetDrawLayer("ARTWORK")
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = GroupFinderFrame
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)

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
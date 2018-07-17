local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select = select
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAzerite()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AzeriteUI ~= true or E.private.muiSkins.blizzard.AzeriteUI ~= true then return end

	--[[ AddOns\Blizzard_AzeriteUI.lua ]]
	function MERS.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers(self, numTiers)
		if numTiers == 3 then
			self:SetSize(474, 460)
		else
			self:SetSize(615, 612)
		end
		self.transformTree:GetRoot():SetLocalPosition(CreateVector2D(self.ClipFrame.BackgroundFrame:GetWidth() * .5, self.ClipFrame.BackgroundFrame:GetHeight() * .5));
	end

	--[[ AddOns\Blizzard_AzeriteUI.xml ]]

	--[[ Blizzard_AzeriteEmpoweredItemUITemplates.xml ]]
	function MERS:AzeriteEmpoweredItemUITemplate(Frame)
		hooksecurefunc(Frame, "AdjustSizeForTiers", MERS.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers)

		Frame:SetClipsChildren(true)

		Frame.ClipFrame:SetPoint("TOPLEFT")
		Frame.ClipFrame:SetPoint("BOTTOMRIGHT")

		local holder = CreateFrame("Frame", nil, Frame.ClipFrame.BackgroundFrame.KeyOverlay)
		holder:SetFrameLevel(holder:GetFrameLevel() + 1)
		holder:SetAllPoints(Frame.BorderFrame.TopBorder)
		Frame.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:SetParent(holder)
		Frame.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:SetAllPoints(holder)
	end

	----====####$$$$%%%%$$$$####====----
	--  AzeriteEmpowedItemDataSource  --
	----====####$$$$%%%%$$$$####====----

	-------------
	-- Section --
	-------------

	--[[ Scale ]]--

	----====####$$$$%%%%%%%%%%%%%%$$$$####====----
	-- Blizzard_AzeriteEmpoweredItemUITemplates --
	----====####$$$$%%%%%%%%%%%%%%$$$$####====----

	----====####$$$$%%%%$$$$####====----
	--     AzeritePowerLayoutInfo     --
	----====####$$$$%%%%$$$$####====----

	----====####$$$$%%%%%$$$$####====----
	--      AzeritePowerModelInfo      --
	----====####$$$$%%%%%$$$$####====----

	----====####$$$$%%%%$$$$####====----
	-- AzeriteEmpoweredItemPowerMixin --
	----====####$$$$%%%%$$$$####====----

	----====####$$$$%%%%%$$$$####====----
	--  AzeriteEmpoweredItemTierMixin  --
	----====####$$$$%%%%%$$$$####====----

	----====####$$$$%%%%%$$$$####====----
	--  AzeriteEmpoweredItemSlotMixin  --
	----====####$$$$%%%%%$$$$####====----

	----====####$$$$%%%%%$$$$####====----
	-- Blizzard_AzeriteEmpoweredItemUI --
	----====####$$$$%%%%%$$$$####====----
	MERS:AzeriteEmpoweredItemUITemplate(AzeriteEmpoweredItemUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteUI", "mUIAzerite", styleAzerite)
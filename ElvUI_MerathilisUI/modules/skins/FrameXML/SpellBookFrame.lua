local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local GetSpellAvailableLevel = GetSpellAvailableLevel
local GetProfessionInfo = GetProfessionInfo
local UnitLevel = UnitLevel
local hooksecurefunc = hooksecurefunc
local SpellBook_GetSpellBookSlot = SpellBook_GetSpellBookSlot
local IsPassiveSpell = IsPassiveSpell
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return end

	local SpellBookFrame = _G.SpellBookFrame

	SpellBookFrame:Styling()
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	for i = 1, _G.SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]

		_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
		bu.EmptySlot:SetAlpha(0)
		bu.TextBackground:Hide()
		bu.TextBackground2:Hide()
		bu.UnlearnedFrame:SetAlpha(0)
		bu:SetCheckedTexture("")
		bu:SetPushedTexture("")
	end

	_G.SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

		local slot, slotType = SpellBook_GetSpellBookSlot(self)
		local isPassive = IsPassiveSpell(slot, SpellBookFrame.bookType)
		local name = self:GetName()
		local highlightTexture = _G[name.."Highlight"]
		if isPassive then
			highlightTexture:SetColorTexture(1, 1, 1, 0)
		else
			highlightTexture:SetColorTexture(1, 1, 1, .25)
		end

		local subSpellString = _G[name.."SubSpellName"]
		local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
		subSpellString:SetTextColor(1, 1, 1)

		if slotType == "FUTURESPELL" then
			local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
			if level and level > UnitLevel("player") then
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		else
			if slotType == "SPELL" and isOffSpec then
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end
		self.RequiredLevelString:SetTextColor(.7, .7, .7)

		local ic = _G[name.."IconTexture"]
		if ic.bg then
			ic.bg:SetShown(ic:IsShown())
		end
	end)

	-- Professions
	local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3"}

	for _, button in pairs(professions) do
		local bu = _G[button]
		bu.professionName:SetTextColor(1, 1, 1)
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)

		bu.statusBar:SetHeight(10)
		bu.statusBar.rankText:SetPoint("CENTER")

		local _, p = bu.statusBar:GetPoint()
		bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 1, -3)
		MERS:CreateBDFrame(bu.statusBar, .25)
	end

	local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight"}

	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local bu = _G[button]
		_G[button.."NameFrame"]:SetAlpha(0)
		bu:SetPushedTexture("")

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			MERS:CreateBG(icon)
			bu.highlightTexture:SetAllPoints(icon)
		end
	end

	for i = 1, 2 do
		local bu = _G["PrimaryProfession"..i]

		_G["PrimaryProfession"..i.."IconBorder"]:Hide()

		bu.professionName:ClearAllPoints()
		bu.professionName:SetPoint("TOPLEFT", 100, -4)

		bu.icon:SetAlpha(1)
		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.icon:SetDesaturated(false)
		MERS:CreateBG(bu.icon)

		bu:CreateBackdrop("Transparent")
		bu.backdrop:SetOutside(bu, 5, 5)

		MERS:CreateGradient(bu.backdrop)
	end

	hooksecurefunc("FormatProfession", function(frame, index)
		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)

	local function SecondaryProfession(button)
		button:CreateBackdrop("Transparent")
		button.backdrop:SetOutside(button, 5, 5)

		MERS:CreateGradient(button.backdrop)

		button.statusBar:ClearAllPoints()
		button.statusBar:SetPoint("BOTTOMLEFT", 0, 0)
		button.rank:SetPoint("BOTTOMLEFT", button.statusBar, "TOPLEFT", 3, 4)
	end

	_G.SpellBookPageText:SetTextColor(.8, .8, .8)

	SecondaryProfession(_G.SecondaryProfession1)
	SecondaryProfession(_G.SecondaryProfession2)
	SecondaryProfession(_G.SecondaryProfession3)

	hooksecurefunc("UpdateProfessionButton", function(self)
		local spellIndex = self:GetID() + self:GetParent().spellOffset
		local isPassive = IsPassiveSpell(spellIndex, SpellBookFrame.bookType)
		if isPassive then
			self.highlightTexture:SetColorTexture(1, 1, 1, 0)
		else
			self.highlightTexture:SetColorTexture(1, 1, 1, .25)
		end
		self.spellString:SetTextColor(1, 1, 1);
		self.subSpellString:SetTextColor(1, 1, 1)
	end)
end

S:AddCallback("mUISpellbook", styleSpellBook)

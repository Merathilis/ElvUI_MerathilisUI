local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local SpellBookFrame = _G["SpellBookFrame"]
local SpellBookPageText = _G["SpellBookPageText"]
local GetSpellAvailableLevel = GetSpellAvailableLevel
local UnitLevel = UnitLevel
-- GLOBALS: hooksecurefunc

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return end

	SpellBookFrame:Styling()
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))

	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}

	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 0.8, 0)
		_G[header.."Missing"]:SetShadowColor(0, 0, 0)
		_G[header.."Missing"]:SetShadowOffset(1, -1)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then return end

		local slot, slotType = SpellBook_GetSpellBookSlot(self);
		local name = self:GetName();
		local subSpellString = _G[name.."SubSpellName"]

		local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == BOOKTYPE_SPELL

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
	end)

	-- Profession Tab
	local professions = {
		PrimaryProfession1 = true,
		PrimaryProfession2 = true,

		SecondaryProfession1 = false,
		SecondaryProfession2 = false,
		SecondaryProfession3 = false,
		SecondaryProfession4 = false
	}

	for name, isPrimary in next, professions do
		local prof = _G[name]
		MERS:CreateBD(prof, .25)

		prof.professionName:SetTextColor(1, 1, 1)
		prof.missingHeader:SetTextColor(1, 1, 1)
		prof.missingText:SetTextColor(1, 1, 1)

		for i = 1, 2 do
			local button = prof["button"..i]
			button:SetSize(41, 41)
			button.Icon = button.iconTexture
			button.NameFrame = _G[button:GetName().."NameFrame"]
			MERS:ReskinItemFrame(button)
		end

		prof.statusBar:SetSize(115, 12)
		prof.statusBar:ClearAllPoints()
		prof.statusBar:SetStatusBarTexture(E["media"].normTex)
		prof.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
		prof.statusBar.rankText:SetPoint("CENTER")

		_G[name.."StatusBarLeft"]:Hide()
		prof.statusBar.capRight:SetAlpha(0)
		_G[name.."StatusBarBGLeft"]:Hide()
		_G[name.."StatusBarBGMiddle"]:Hide()
		_G[name.."StatusBarBGRight"]:Hide()
		MERS:CreateBDFrame(prof.statusBar, .25)

		if isPrimary then
			prof:SetSize(441, 93)
			prof.professionName:SetPoint("TOPLEFT", prof.icon, "TOPRIGHT", 4, 0)
			prof.rank:SetPoint("BOTTOMLEFT", prof.statusBar, "TOPLEFT", 0, 3)
			_G[name.."IconBorder"]:Hide()

			prof.icon:ClearAllPoints()
			prof.icon:SetPoint("TOPLEFT", 6, -6)
			prof.icon:SetSize(81, 81)
			MERS:ReskinIcon(prof.icon)

			prof.button2:SetPoint("TOPRIGHT", -108, -4)
			prof.button1:SetPoint("TOPLEFT", prof.button2, "BOTTOMLEFT", 0, -3)
			prof.statusBar:SetPoint("BOTTOMLEFT", prof.icon, "BOTTOMRIGHT", 4, 0)
			prof.unlearn:ClearAllPoints()
			prof.unlearn:SetPoint("BOTTOMRIGHT", prof.icon)
		else
			prof:SetSize(441, 49)
			prof.professionName:SetPoint("TOPLEFT", 4, -3)
			prof.button1:SetPoint("TOPRIGHT", -108, -4)
			prof.button2:SetPoint("TOPRIGHT", prof.button1, "TOPLEFT", -107, 0)
			prof.statusBar:SetPoint("TOPLEFT", prof.rank, "BOTTOMLEFT", 0, -3)
		end
	end
	hooksecurefunc("FormatProfession", function(frame, index)
		if index then
			local _, texture = GetProfessionInfo(index)
			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)
end

S:AddCallback("mUISpellbook", styleSpellBook)
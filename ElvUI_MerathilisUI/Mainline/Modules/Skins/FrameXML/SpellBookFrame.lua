local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function HandleSpellButton(self)
	if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

	local slot, slotType = SpellBook_GetSpellBookSlot(self)
	local isPassive = IsPassiveSpell(slot, _G.SpellBookFrame.bookType)
	local name = self:GetName()
	local highlightTexture = _G[name .. "Highlight"]
	if isPassive then
		highlightTexture:SetColorTexture(1, 1, 1, 0)
	else
		highlightTexture:SetColorTexture(1, 1, 1, .25)
	end

	local subSpellString = _G[name .. "SubSpellName"]
	local isOffSpec = self.offSpecID ~= 0 and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
	subSpellString:SetTextColor(1, 1, 1)

	if slotType == "FUTURESPELL" then
		local level = GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
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

	local ic = _G[name .. "IconTexture"]
	if ic.bg then
		ic.bg:SetShown(ic:IsShown())
	end

	if self.ClickBindingIconCover and self.ClickBindingIconCover:IsShown() then
		self.SpellName:SetTextColor(.7, .7, .7)
	end
end

local function LoadSkin()
	if not module:CheckDB("spellbook", "spellbook") then
		return
	end

	local SpellBookFrame = _G.SpellBookFrame
	SpellBookFrame:Styling()
	module:CreateShadow(SpellBookFrame)

	--Parchment
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	-- Bottom Tabs
	for i = 1, 5 do
		module:ReskinTab(_G['SpellBookFrameTabButton' .. i])
	end

	for i = 1, _G.SPELLS_PER_PAGE do
		local bu = _G["SpellButton" .. i]

		_G["SpellButton" .. i .. "SlotFrame"]:SetAlpha(0)
		bu.EmptySlot:SetAlpha(0)
		bu.TextBackground:Hide()
		bu.TextBackground2:Hide()
		bu.UnlearnedFrame:SetAlpha(0)

		hooksecurefunc(bu, "UpdateButton", HandleSpellButton)
	end

	_G.SpellBookSkillLineTab1:SetPoint("TOPLEFT", _G.SpellBookSideTabsFrame, "TOPRIGHT", 2, -36)

	local professions = { "PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2",
		"SecondaryProfession3" }

	for i, button in pairs(professions) do
		local bu = _G[button]
		bu.professionName:SetTextColor(1, 1, 1)
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)

		bu.statusBar:SetHeight(10)
		bu.statusBar:SetStatusBarTexture(E.media.normTex)
		bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", CreateColor(0, .6, 0, 1), CreateColor(0, .8, 0, 1))

		bu.statusBar.rankText:SetPoint("CENTER")

		if i > 2 then
			bu.statusBar:ClearAllPoints()
			bu.statusBar:SetPoint("BOTTOMLEFT", 16, 3)
		end
	end

	for i = 1, 2 do
		local bu = _G["PrimaryProfession" .. i]
		_G["PrimaryProfession" .. i .. "IconBorder"]:Hide()

		bu.professionName:ClearAllPoints()
		bu.professionName:SetPoint("TOPLEFT", 100, -4)
		bu.icon:SetAlpha(1)
		bu.icon:SetDesaturated(false)

		bu:CreateBackdrop('Transparent')
		bu.backdrop:SetAlpha(0.45) -- why????
		bu.backdrop:SetPoint("TOPLEFT")
		bu.backdrop:SetPoint("BOTTOMRIGHT", 0, -5)
		module:CreateGradient(bu.backdrop)
	end

	hooksecurefunc("FormatProfession", function(frame, index)
		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)

	_G.SecondaryProfession1:CreateBackdrop('Transparent')
	_G.SecondaryProfession1.backdrop:SetPoint("TOPLEFT", 0, 10)
	_G.SecondaryProfession1.backdrop:SetPoint("BOTTOMRIGHT", 0, -5)
	module:CreateGradient(_G.SecondaryProfession1.backdrop)
	_G.SecondaryProfession2:CreateBackdrop('Transparent')
	_G.SecondaryProfession2.backdrop:SetPoint("TOPLEFT", 0, 10)
    _G.SecondaryProfession2.backdrop:SetPoint("BOTTOMRIGHT", 0, -5)
	module:CreateGradient(_G.SecondaryProfession2.backdrop)
	_G.SecondaryProfession3:CreateBackdrop('Transparent')
	_G.SecondaryProfession3.backdrop:SetPoint("TOPLEFT", 0, 10)
    _G.SecondaryProfession3.backdrop:SetPoint("BOTTOMRIGHT", 0, -5)
	module:CreateGradient(_G.SecondaryProfession3.backdrop)

	_G.SpellBookPageText:SetTextColor(.8, .8, .8)

	hooksecurefunc("UpdateProfessionButton", function(self)
		local spellIndex = self:GetID() + self:GetParent().spellOffset
		local isPassive = IsPassiveSpell(spellIndex, SpellBookFrame.bookType)
		if isPassive then
			self.highlightTexture:SetColorTexture(1, 1, 1, 0)
		else
			self.highlightTexture:SetColorTexture(1, 1, 1, .25)
		end
		if self.spellString then
			self.spellString:SetTextColor(1, 1, 1)
		end
		if self.subSpellString then
			self.subSpellString:SetTextColor(1, 1, 1)
		end
		if self.SpellName then
			self.SpellName:SetTextColor(1, 1, 1)
		end
		if self.SpellSubName then
			self.SpellSubName:SetTextColor(1, 1, 1)
		end
	end)

end

S:AddCallback("SpellBookFrame", LoadSkin)

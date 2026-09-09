local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")

local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local SetLootSpecialization = SetLootSpecialization
local GetSpecialization = C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local SetSpecialization = C_SpecializationInfo.SetSpecialization

-- Border colors (module-level constants)
local COLOR_ACTIVE_R, COLOR_ACTIVE_G, COLOR_ACTIVE_B = 0, 0.44, 0.87
local COLOR_LOOT_R, COLOR_LOOT_G, COLOR_LOOT_B = 1, 0.44, 0.4
-- Shown when the active spec is also the loot spec (explicitly, or via "Current Specialization")
local COLOR_ACTIVE_LOOT_R, COLOR_ACTIVE_LOOT_G, COLOR_ACTIVE_LOOT_B = 0.6, 0.44, 0.75

local function SpecBar_OnEnter(self)
	UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
end

local function SpecBar_OnLeave(self)
	if E.db.mui.actionbars.specBar.mouseover then
		UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
	end
end

local function SpecButton_OnEnter(self)
	local bar = self:GetParent()
	_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	_G.GameTooltip:AddLine(self.SpecName)
	_G.GameTooltip:AddLine(" ")
	_G.GameTooltip:AddLine(self.SpecDescription, 1, 1, 1, true)
	_G.GameTooltip:Show()

	if bar:IsShown() then
		UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
	end
end

local function SpecButton_OnLeave(self)
	GameTooltip_Hide()
	local bar = self:GetParent()
	if bar:IsShown() and E.db.mui.actionbars.specBar.mouseover then
		UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
	end
end

local function SpecButton_OnClick(self, button)
	if button == "LeftButton" then
		if self:GetID() ~= self.Spec then
			SetSpecialization(self:GetID())
		end
	elseif button == "RightButton" then
		SetLootSpecialization(self.LootID == self.SpecID and 0 or self.SpecID)
	end
end

---Update border highlight for all buttons (once per event, not once per button)
local function SpecBar_UpdateButtons(bar)
	local currentSpec = GetSpecialization()
	local lootID = GetLootSpecialization()
	local borderR, borderG, borderB = unpack(E.media.bordercolor)

	for i = 1, #bar.Button do
		local btn = bar.Button[i]
		btn.Spec = currentSpec
		btn.LootID = lootID

		local isActive = currentSpec == btn:GetID()
		-- lootID is 0 when Loot Specialization is set to "Current Specialization",
		-- which always resolves to whichever spec is currently active
		local isLootSpec = lootID == btn.SpecID or (lootID == 0 and isActive)

		if isActive and isLootSpec then
			btn.backdrop:SetBackdropBorderColor(COLOR_ACTIVE_LOOT_R, COLOR_ACTIVE_LOOT_G, COLOR_ACTIVE_LOOT_B)
		elseif isActive then
			btn.backdrop:SetBackdropBorderColor(COLOR_ACTIVE_R, COLOR_ACTIVE_G, COLOR_ACTIVE_B)
		elseif isLootSpec then
			btn.backdrop:SetBackdropBorderColor(COLOR_LOOT_R, COLOR_LOOT_G, COLOR_LOOT_B)
		else
			btn.backdrop:SetBackdropBorderColor(borderR, borderG, borderB)
		end
	end
end

local function SpecBar_OnEvent(self)
	SpecBar_UpdateButtons(self)
end

function module:CreateSpecBar()
	local db = F.GetDBFromPath("mui.actionbars.specBar") or E.db.mui.actionbars.specBar
	if not db.enable then
		return
	end

	local Spacing = 4
	local Size = db.size or 24
	local Specs = GetNumSpecializations()

	local specBar = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	specBar:SetFrameStrata(db.frameStrata or "BACKGROUND")
	specBar:OffsetFrameLevel(db.frameLevel or 1)
	specBar:CreateBackdrop("Transparent")
	specBar:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 177)
	specBar:Hide()
	E.FrameLocks[specBar] = true

	specBar.Button = {}

	E:CreateMover(
		specBar,
		"MER_SpecializationBarMover",
		MER.Title .. L["SpecializationBarMover"],
		nil,
		nil,
		nil,
		"ALL,ACTIONBARS,MERATHILISUI",
		nil,
		"mui,modules,actionbars"
	)

	specBar:SetScript("OnEnter", SpecBar_OnEnter)
	specBar:SetScript("OnLeave", SpecBar_OnLeave)

	-- Register events once on the bar instead of once per button
	specBar:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	specBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	specBar:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	specBar:SetScript("OnEvent", SpecBar_OnEvent)

	for i = 1, Specs do
		local SpecID, SpecName, Description, Icon = GetSpecializationInfo(i)

		local Button = CreateFrame("Button", nil, specBar)
		Button:Size(Size, Size)
		Button:SetID(i)
		Button.SpecID = SpecID
		Button.SpecName = SpecName
		Button.SpecDescription = Description
		-- ignoreUpdates: keep this backdrop out of E.frames so ElvUI's async
		-- template sweep (E:UpdateFrameTemplates) can't silently reset our
		-- manually-painted border color (e.g. right after login)
		Button:CreateBackdrop(nil, nil, true)
		Button:OffsetFrameLevel(1, specBar)
		Button:StyleButton()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture(Icon)
		Button:GetPushedTexture():SetInside()
		Button:RegisterForClicks("AnyDown")
		Button:SetScript("OnEnter", SpecButton_OnEnter)
		Button:SetScript("OnLeave", SpecButton_OnLeave)
		Button:SetScript("OnClick", SpecButton_OnClick)

		if i == 1 then
			Button:SetPoint("LEFT", specBar, "LEFT", Spacing, 0)
		else
			Button:SetPoint("LEFT", specBar.Button[i - 1], "RIGHT", Spacing, 0)
		end

		specBar.Button[i] = Button
	end

	-- Size: outer spacing + buttons + gaps between buttons
	specBar:Size(Spacing * 2 + Size * Specs + Spacing * (Specs - 1), Spacing * 2 + Size)

	-- Initial border state
	SpecBar_UpdateButtons(specBar)

	if db.mouseover then
		UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), 0)
	else
		UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
	end

	module.specBar = specBar
end

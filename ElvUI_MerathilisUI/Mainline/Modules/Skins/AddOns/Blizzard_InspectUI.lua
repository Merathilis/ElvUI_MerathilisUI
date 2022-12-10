local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local select, unpack = select, unpack

local hooksecurefunc = hooksecurefunc
local GetInspectSpecialization = GetInspectSpecialization
local GetSpecializationRoleByID = GetSpecializationRoleByID
local GetSpecializationInfoByID = GetSpecializationInfoByID
local UnitGUID = UnitGUID

local function updateIcon(self)
	local spec = nil

	if INSPECTED_UNIT ~= nil then
		spec = GetInspectSpecialization(INSPECTED_UNIT)
	end

	if spec ~= nil and spec > 0 then
		local role1 = GetSpecializationRoleByID(spec)
		if role1 ~= nil then
			local _, _, _, icon = GetSpecializationInfoByID(spec)
			self.specIcon:SetTexture(icon)
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("inspect", "inspect") then
		return
	end

	_G.InspectModelFrame:DisableDrawLayer("OVERLAY")

	_G.InspectFrame:Styling()
	module:CreateShadow(_G.InspectFrame)

	for i = 1, 4 do
		module:ReskinTab(_G["InspectFrameTab" .. i])
	end

	if _G.InspectModelFrame.backdrop then
		_G.InspectModelFrame.backdrop:Hide()
	end

	for i = 1, 5 do
		select(i, _G.InspectModelFrame:GetRegions()):Hide()
	end

	_G.InspectPaperDollFrame.ViewButton:ClearAllPoints()
	_G.InspectPaperDollFrame.ViewButton:SetPoint("TOP", _G.InspectFrame, 0, -45)

	-- Character
	select(11, _G.InspectMainHandSlot:GetRegions()):Hide()

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		local border = slot.IconBorder

		_G["Inspect"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot.icon:SetTexCoord(unpack(E.TexCoords))

		border:SetDrawLayer("BACKGROUND")
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.IconBorder:SetTexture(E["media"].normTex)
		button.icon:SetShown(button.hasItem)
	end)

	-- Talents
	local inspectSpec = _G.InspectTalentFrame.InspectSpec
	inspectSpec.ring:Hide()

	for i = 1, 7 do
		local row = _G.InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]

			bu.Slot:Hide()
			bu.border:SetTexture("")

			bu.icon:SetDrawLayer("ARTWORK")
			bu.icon:SetTexCoord(unpack(E.TexCoords))

			module:CreateBG(bu.icon)
		end
	end

	inspectSpec.specIcon:SetTexCoord(unpack(E.TexCoords))
	module:CreateBG(inspectSpec.specIcon)

	inspectSpec:HookScript("OnShow", updateIcon)
	_G.InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
		if not _G.InspectFrame:IsShown() then return end
		if event == "INSPECT_READY" and _G.InspectFrame.unit and UnitGUID(_G.InspectFrame.unit) == unit then
			updateIcon(self.InspectSpec)
		end
	end)

	local roleIcon = inspectSpec.roleIcon
	roleIcon:SetTexture(E["media"].roleIcons)
	local bg = module:CreateBDFrame(roleIcon, 1)
	bg:SetPoint("TOPLEFT", roleIcon, 2, -1)
	bg:SetPoint("BOTTOMRIGHT", roleIcon, -1, 2)

	for i = 1, 3 do
		local tab = _G["InspectFrameTab"..i]
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end
end

S:AddCallbackForAddon("Blizzard_InspectUI", LoadSkin)

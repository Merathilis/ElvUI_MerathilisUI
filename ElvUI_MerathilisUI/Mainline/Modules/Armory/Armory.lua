local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local M = E:GetModule('Misc')

local _G = _G
local select = select
local strlower = strlower
local gsub = gsub

local GetItemGem = GetItemGem
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local InCombatLockdown = InCombatLockdown
local hooksecurefunc = hooksecurefunc
local UnitSex = UnitSex

local initialized = false

module.Constants = {}

module.Constants.Character_Defaults_Cached = false
module.Constants.Inspect_Defaults_Cached = false
module.Constants.Character_Defaults = {}
module.Constants.Inspect_Defaults = {}

module.Constants.Gradiation = 'Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\textures\\Gradation'
module.Constants.WarningTexture = 'Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Minimalist'

module.Constants.maxGemSlots = 5

module.Constants.gearList = {
	'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
	'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
}

module.Constants.slots = {
	["HeadSlot"] = { true, true },
	["NeckSlot"] = { true, false },
	["ShoulderSlot"] = { true, true },
	["BackSlot"] = { true, false },
	["ChestSlot"] = { true, true },
	["WristSlot"] = { true, true },
	["MainHandSlot"] = { true, true },
	["SecondaryHandSlot"] = { true, true },
	["HandsSlot"] = { true, true },
	["WaistSlot"] = { true, true },
	["LegsSlot"] = { true, true },
	["FeetSlot"] = { true, true },
	["Finger0Slot"] = { true, false },
	["ShirtSlot"] = { false, false },
	["Finger1Slot"] = { true, false },
	["TabardSlot"] = { false, false },
	["Trinket0Slot"] = { true, false },
	["Trinket1Slot"] = { true, false },
}

module.Constants.slotIDs = { -- Not the actual Char Frame IDs
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[5] = "ChestSlot",
	[6] = "ShirtSlot",
	[7] = "TabardSlot",
	[8] = "WaistSlot",
	[9] = "LegsSlot",
	[10] = "FeetSlot",
	[11] = "WristSlot",
	[12] = "HandsSlot",
	[13] = "Finger0Slot",
	[14] = "Finger1Slot",
	[15] = "Trinket0Slot",
	[16] = "Trinket1Slot",
	[17] = "BackSlot",
	[18] = "MainHandSlot",
	[19] = "SecondaryHandSlot",
}

module.Constants.enchantSlots = {
	['HeadSlot'] = false,
	['NeckSlot'] = false,
	['ShoulderSlot'] = false,
	['WaistSlot'] = false,
	['LegsSlot'] = false,
	['Finger0Slot'] = true,
	['Finger1Slot'] = true,
	['MainHandSlot'] = true,
	['SecondaryHandSlot'] = false,
	['ChestSlot'] = true,
	['BackSlot'] = true,
	['FeetSlot'] = 2,
	['WristSlot'] = 4,
	['HandsSlot'] = 1,
	['Trinket0Slot'] = false,
	['Trinket1Slot'] = false,
}

function module:Transmog_OnEnter()
	if self.Link and self.Link ~= '' then
		self.Texture:SetVertexColor(1, .8, 1, 1)
		_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')

		self:SetScript('OnUpdate', function()
			_G["GameTooltip"]:ClearLines()
			_G["GameTooltip"]:SetHyperlink(self.Link)

			_G["GameTooltip"]:Show()
		end)
	end
end

function module:Transmog_OnLeave()
	self.Texture:SetVertexColor(1, .5, 1, 1)

	self:SetScript('OnUpdate', nil)
	_G["GameTooltip"]:Hide()
end

function module:Illusion_OnEnter()
	_G["GameTooltip"]:SetOwner(self, 'ANCHOR_BOTTOM')
	_G["GameTooltip"]:AddLine(self.Link, 1, 1, 1)
	_G["GameTooltip"]:Show()
end

function module:Tooltip_OnLeave()
	_G["GameTooltip"]:Hide()
end

function module:Warning_OnEnter()
	if module.db.character.enable and self.Reason then
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:AddLine(self.Reason, 1, 1, 1)
		_G['GameTooltip']:Show()
	end
end

function module:Gem_OnEnter()
	if module.db.character.enable and self.Link then
		_G['GameTooltip']:SetOwner(self, 'ANCHOR_RIGHT')
		_G['GameTooltip']:SetHyperlink(self.Link)
		_G['GameTooltip']:Show()
	end
end

function module:CheckForMissing(which, Slot, iLvl, gems, essences, enchant, primaryStat)
	if not Slot.Warning then return end
	Slot.Warning.Reason = nil
	local window = strlower(which)
	if not (E.db.mui.armory[window] and E.db.mui.armory[window].enable and E.db.mui.armory[window].warning and E.db.mui.armory[window].warning.enable) then Slot['Warning']:Hide(); return end --if something is disdbled
	local SlotName = gsub(Slot:GetName(), which, '')
	if not SlotName then return end --No slot?
	local noChant, noGem = false, false

	if iLvl and (module.Constants.enchantSlots[SlotName] == true or module.Constants.enchantSlots[SlotName] == primaryStat) and not enchant then --Item should be enchanted, but no string actually sent. This bastard is slacking
		local classID, subclassID = select(12, GetItemInfo(Slot.itemLink))
		if (classID == 4 and subclassID == 6) or (classID == 4 and subclassID == 0 and Slot.ID == 17) then --Shields are special
			noChant = false
		else
			noChant = true
		end
	end

	if gems and Slot.ID ~= 2 then --If gems found and not neck
		for i = 1, module.Constants.maxGemSlots do
			local texture = Slot['textureSlot'..i]
			if (texture and texture:GetTexture()) and (Slot['MER_Gem'..i] and not Slot['MER_Gem'..i].Link) then noGem = true; break end --If there is a texture (e.g. actual slot), but no link = no gem installed
		end
	end

	if (noChant or noGem) then --If anything else is missing
		local message = ''
		if noGem then
			message = message..'|cffff0000'..L["Empty Socket"]..'|r\n'
		end

		if noChant then
			message = message..'|cffff0000'..L["Not Enchanted"]..'|r\n'
		end
		Slot.Warning.Reason = message or nil
		Slot.Warning:Show()
		Slot.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.character.gradient.warningColor))
	else
		Slot.Warning:Hide()
	end
end

function module:UpdateGemInfo(Slot, which)
	local unit = which == 'Character' and 'player' or (_G['InspectFrame'] and _G['InspectFrame'].unit)
	if not unit then return end
	module.db = E.db.mui.armory

	for i = 1, module.Constants.maxGemSlots do
		local GemLink
		if not Slot['MER_Gem'..i] then return end
		if Slot.itemLink then
			if Slot.ID == 2 then
				local window = strlower(which)
				if module.db[window].warning.enable then
					if which == 'Character' and Slot['textureSlotEssenceType'..i] then
						Slot['textureSlotEssenceType'..i]:Hide()
					elseif which == 'Inspect' and Slot['textureSlotBackdrop'..i] then
						Slot['textureSlotBackdrop'..i]:Hide()
					end
				end
			else
				GemLink = select(2, GetItemGem(Slot.itemLink, i))
			end
		end
		Slot['MER_Gem'..i].Link = GemLink
	end
end

function module:UpdatePageInfo(frame, which, guid, event)
	if not (frame and which) then return end
	if not module:CheckOptions(which) then return end
	local window = strlower(which)
	local unit = (which == 'Character' and 'player') or frame.unit
	if which == 'Character' then
		module.CharacterPrimaryStat = select(6, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex('player')))
	end
end

function module:UpdatePageStrings(i, iLevelDB, Slot, slotInfo, which)
	if not module:CheckOptions(which) then return end
	Slot.itemLink = GetInventoryItemLink((which == 'Character' and 'player') or _G['InspectFrame'].unit, Slot.ID)
	if not Slot.itemLink then return end

	module:UpdateGemInfo(Slot, which)
	module:CheckForMissing(which, Slot, slotInfo.iLvl, slotInfo.gems, slotInfo.essences, slotInfo.enchantTextShort, module[which.."PrimaryStat"])
end

function module:UpdateInspectInfo()
	if not _G['InspectFrame'] then return end --In case update for frame is called before it is actually created
	if not module.Constants.Inspect_Defaults_Cached then
		module:LoadAndSetupInspect()
	end

	if E.db.mui.armory.inspect.enable then
		M:UpdatePageInfo(_G['InspectFrame'], 'Inspect')
	end

	if not E.db.general.itemLevel.displayInspectInfo then
		M:ClearPageInfo(_G['InspectFrame'], 'Inspect')
	end
end

function module:UpdateCharacterInfo(event)
	if event == 'CRITERIA_UPDATE' and InCombatLockdown() then return end

	M:UpdatePageInfo(_G['CharacterFrame'], 'Character')

	if not E.db.general.itemLevel.displayCharacterInfo then
		M:ClearPageInfo(_G['CharacterFrame'], 'Character')
	end
end

function module:firstGarrisonToast()
	module:UnregisterEvent("GARRISON_MISSION_FINISHED")
	self:ScheduleTimer("UpdatePaperDoll", 7)
end

function module:CheckOptions(which)
	if not E.private.skins.blizzard.enable then return false end
	if (which == 'Character' and not E.private.skins.blizzard.character) or (which == 'Inspect' and not E.private.skins.blizzard.inspect) then return false end
	return true
end

function module:Initialize()
	module.db = E.db.mui.armory

	if not E.db.general.itemLevel.displayCharacterInfo or not E.private.skins.blizzard.character then return end

	module:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdatePaperDoll", false)
	module:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdatePaperDoll", false)
	module:RegisterEvent("SOCKET_INFO_UPDATE", "UpdatePaperDoll", false)
	module:RegisterEvent("COMBAT_RATING_UPDATE", "UpdatePaperDoll", false)
	module:RegisterEvent("MASTERY_UPDATE", "UpdatePaperDoll", false)
	module:RegisterEvent("GARRISON_MISSION_FINISHED", "firstGarrisonToast", false)

	hooksecurefunc(M, 'UpdatePageInfo', module.UpdatePageInfo)
	hooksecurefunc(M, 'UpdatePageStrings', module.UpdatePageStrings)

	if module:CheckOptions('Character') then
		module:LoadAndSetupCharacter()

		hooksecurefunc(M, 'UpdateCharacterInfo', module.UpdateCharacterInfo)
		module:UpdateCharacterInfo()
	end

	if module:CheckOptions('Inspect') then
		hooksecurefunc(M, 'UpdateInspectInfo', module.UpdateInspectInfo)
		module:PreSetup()
	end

	-- Stats
	module:InitStats()

	initialized = true
end

MER:RegisterModule(module:GetName())

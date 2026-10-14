local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown
local pi = math.pi

local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetMountInfoByID = C_MountJournal.GetMountInfoByID
local SummonByID = C_MountJournal.SummonByID

local hexColor = "|cffffffff"
local mText = L["Durability/ Ilevel"]

local REPAIR_COST = REPAIR_COST
local tooltipString = "%d%%"
local totalDurability = 0
local invDurability = {}
local totalRepairCost

local slots = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
	[10] = _G.INVTYPE_HAND,
	[16] = _G.INVTYPE_WEAPONMAINHAND,
	[17] = _G.INVTYPE_WEAPONOFFHAND,
	[18] = _G.INVTYPE_RANGED,
}

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end

local function colorText(value, color)
	if color then
		return color.hex .. value .. "|r"
	elseif E.db.mui.datatexts.durabilityIlevel.whiteText then
		return value
	else
		return hexColor .. value .. "|r"
	end
end

local function OnEnter(self)
	local tip = select(7, F.mColorDatatext())
	DT.tooltip:ClearLines()

	for slot, durability in pairs(invDurability) do
		DT.tooltip:AddDoubleLine(
			format(
				"|T%s:14:14:0:0:64:64:4:60:4:60|t %s",
				GetInventoryItemTexture("player", slot),
				GetInventoryItemLink("player", slot)
			),
			format(tooltipString, durability),
			1,
			1,
			1,
			E:ColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
		)
	end

	if totalRepairCost > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
	end

	local avg, avgEquipped, avgPvp = GetAverageItemLevel()
	DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
	DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
	DT.tooltip:AddDoubleLine(
		LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT,
		format("%0.2f", avgPvp),
		1,
		1,
		1,
		colorize(avgPvp - avg)
	)

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(
		format("%s |CFFFFFFFF%s|r", F.Icon(MER.Media.Mouse["LEFT"]), L["Left Click:"]),
		format("%s%s|r", tip, L["Open Character Frame"])
	)
	local mountID = tonumber(E.db.mui.datatexts.durabilityIlevel.mount)
	if mountID then
		local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
		if name and isUsable then
			DT.tooltip:AddDoubleLine(
				format("%s |CFFFFFFFF%s|r", F.Icon(MER.Media.Mouse["RIGHT"]), L["Right Click:"]),
				format("%s%s|r  %s", tip, name, F.Icon(icon))
			)
		end
	end

	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

---Text of the datatext, also drawn by the options preview (Options/Widgets/DurabilityPreview.lua)
---@param db table E.db.mui.datatexts.durabilityIlevel
---@param durability number lowest durability in percent
---@param avgEquipped number? equipped item level
---@return string
function MER.DurabilityIlevelText(db, durability, avgEquipped)
	local shieldIcon =
		"|TInterface\\AddOns\\ElvUI_MerathilisUI\\Media\\Icons\\Datatext\\shield.tga:14:14:0:0:64:64:5:59:5:59"
	local armorIcon =
		"|TInterface\\AddOns\\ElvUI_MerathilisUI\\Media\\Icons\\Datatext\\armor.tga:14:14:0:0:64:64:5:59:5:59|t"
	local text = db.icon and "%s %s  %s %s" or "%s%s | %s%s"
	local colorDurability = nil

	if db.colored.enable then
		if durability <= db.colored.b.value then
			colorDurability = db.colored.b.color
		elseif durability <= db.colored.a.value then
			colorDurability = db.colored.a.color
		end
	elseif durability <= 15 then
		colorDurability = { r = 1, g = 0.78, b = 0, hex = "|CFFFFC900" }
	end

	if not db.whiteIcon and colorDurability then
		shieldIcon = shieldIcon
			.. ":"
			.. tostring(F.RoundNumber(colorDurability.r * 255))
			.. ":"
			.. tostring(F.RoundNumber(colorDurability.g * 255))
			.. ":"
			.. tostring(F.RoundNumber(colorDurability.b * 255))
			.. "|t"
	else
		shieldIcon = shieldIcon .. "|t"
	end

	armorIcon = db.icon and armorIcon or ""
	local totalDurabilityString = format("%." .. E.db.general.decimalLength .. "f%%", durability)

	shieldIcon = db.icon and shieldIcon or ""
	local avgEquippedString = format("%." .. E.db.general.decimalLength .. "f", avgEquipped or 0)
	text = format(
		text,
		shieldIcon,
		colorText(totalDurabilityString, colorDurability),
		armorIcon,
		colorText(avgEquippedString)
	)

	return text
end

local function OnEvent(self)
	local db = E.db.mui and E.db.mui.datatexts and E.db.mui.datatexts.durabilityIlevel
	if not db then
		return
	end

	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc = (currentDura / maxDura) * 100
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			E.ScanTooltip:SetInventoryItem("player", index)
			E.ScanTooltip:Show()

			local data = E.ScanTooltip:GetTooltipData()
			totalRepairCost = totalRepairCost + (data and data.repairCost or 0)
		end
	end

	local _, avgEquipped = GetAverageItemLevel()
	self.text:SetText(MER.DurabilityIlevelText(db, totalDurability or 0, avgEquipped))
end

-- ElvUI calls this whenever the value color changes and runs OnEvent right after
local function ApplySettings(_, hex)
	hexColor = hex
end

local function OnClick(_, button)
	local db = E.db.mui and E.db.mui.datatexts and E.db.mui.datatexts.durabilityIlevel
	if not db then
		return
	end

	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	else
		if button == "LeftButton" then
			_G.ToggleCharacter("PaperDollFrame")
		elseif button == "RightButton" then
			local mountID = tonumber(db.mount)
			if mountID then
				local isUsable = select(5, GetMountInfoByID(mountID))
				if isUsable then
					SummonByID(mountID)
				end
			end
		end
	end
end

DT:RegisterDatatext(
	"DurabilityIlevel",
	MER.DatatextString,
	{ "UPDATE_INVENTORY_DURABILITY", "PLAYER_AVG_ITEM_LEVEL_UPDATE" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	ApplySettings
)

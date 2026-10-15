local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local pcall = pcall
local strsub = strsub

local C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local CreateFrame = CreateFrame
local UnitAffectingCombat = UnitAffectingCombat
local UnitIsTapDenied = UnitIsTapDenied

--[[
	Neutral Name Only

	ElvUI has no plate type for neutral units, UpdatePlateType files them under
	ENEMY_NPC. The post-hook moves idle neutral NPCs over to FRIENDLY_NPC, so they
	use that type's settings (name only by default). Targeted or fighting you or
	your group (in combat and not tapped by someone else), they go back to
	ENEMY_NPC and get their full plate.

	Swapped plates are flagged with MER_NeutralNameOnly, so their name can use
	the gradient tag instead of the Friendly NPC name format.
--]]

local GRADIENT_TAG = "[name:MER:gradient]"

local eventFrame
local hooked

local function GetDB()
	return E.db.mui.nameplates.neutralNameOnly
end

local function IsActive(nameplate, db)
	local unit = nameplate.__unit
	if not unit then
		return false
	end

	if db.target and E:UnitIsUnit(unit, "target") then
		return true
	end

	return db.combat and UnitAffectingCombat(unit) and not UnitIsTapDenied(unit) or false
end

local function ShouldBeNameOnly(nameplate)
	local db = GetDB()
	if not db.enable or nameplate.isPlayer or nameplate.isEnemy or nameplate.reaction ~= 4 then
		return false
	end

	return not IsActive(nameplate, db)
end

-- Same refresh ElvUI runs for UNIT_FACTION, the type change rebuilds the plate
local function RefreshPlate(nameplate)
	NP:UpdatePlateType(nameplate)

	if nameplate.frameType == nameplate.previousType then
		return
	end

	NP:UpdatePlateSize(nameplate)
	NP:UpdatePlateBase(nameplate)

	-- EnableElement doesn't update, oUF only runs this after NAME_PLATE_UNIT_ADDED.
	-- Without it a health bar enabled by the switch keeps no color (white).
	nameplate:UpdateAllElements("MER_NeutralNameOnly")

	-- isTarget may still be stale while PLAYER_TARGET_CHANGED runs
	if E:UnitIsUnit(nameplate.__unit, "target") then
		NP:SetupTarget(nameplate)
	end
end

local function UpdateGradientName(nameplate)
	if not nameplate.MER_NeutralNameOnly or not GetDB().gradientName then
		return
	end

	local plateDB = NP:PlateDB(nameplate)
	if not plateDB.nameOnly or not (plateDB.name and plateDB.name.enable) then
		return
	end

	nameplate:Tag(nameplate.Name, GRADIENT_TAG)
	nameplate.Name:UpdateTag()
end

local function IsNeutralPlate(nameplate)
	return nameplate ~= NP.TestFrame
		and nameplate.__unit
		and not nameplate.widgetsOnly
		and not nameplate.isGameObject
		and not nameplate.isPlayer
		and not nameplate.isEnemy
		and nameplate.reaction == 4
end

local function RefreshNeutralPlates()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		if IsNeutralPlate(nameplate) then
			RefreshPlate(nameplate)
		end
	end
end

local function OnEvent(_, event, unit)
	if event == "UNIT_FLAGS" then
		-- Fires for every unit, only nameplate units matter
		if not unit or strsub(unit, 1, 9) ~= "nameplate" then
			return
		end

		-- Same lookup ElvUI uses, guarded for restricted units
		local success, plate = pcall(C_NamePlate_GetNamePlateForUnit, unit)
		local nameplate = success and plate and plate.unitFrame
		if nameplate and NP.Plates[nameplate] and IsNeutralPlate(nameplate) then
			RefreshPlate(nameplate)
		end
	else
		RefreshNeutralPlates()
	end
end

function module:UpdateNeutralNameOnly()
	local db = GetDB()

	if db.enable and not hooked then
		hooked = true
		hooksecurefunc(NP, "UpdatePlateType", function(_, nameplate)
			local swap = nameplate.frameType == "ENEMY_NPC" and ShouldBeNameOnly(nameplate)
			if swap then
				nameplate.frameType = "FRIENDLY_NPC"
			end

			nameplate.MER_NeutralNameOnly = swap
		end)

		-- Runs after ElvUI tagged the name with the Friendly NPC format
		hooksecurefunc(NP, "Update_Tags", function(_, nameplate)
			UpdateGradientName(nameplate)
		end)
	end

	if db.enable then
		if not eventFrame then
			eventFrame = CreateFrame("Frame")
			eventFrame:SetScript("OnEvent", OnEvent)
		end

		if db.target then
			eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		else
			eventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		end

		if db.combat then
			eventFrame:RegisterEvent("UNIT_FLAGS")
		else
			eventFrame:UnregisterEvent("UNIT_FLAGS")
		end
	elseif eventFrame then
		eventFrame:UnregisterAllEvents()
	end

	-- Also undoes the swap on existing plates once the option is turned off
	RefreshNeutralPlates()

	-- The name format changes without a type change, so the tags need a refresh
	if NP.Plates then
		for nameplate in pairs(NP.Plates) do
			if nameplate.MER_NeutralNameOnly then
				NP:Update_Tags(nameplate)
			end
		end
	end
end

function module:NeutralNameOnly()
	module:UpdateNeutralNameOnly()
end

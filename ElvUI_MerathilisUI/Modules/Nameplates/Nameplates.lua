local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NamePlates')
local NP = E:GetModule('NamePlates')

local _G = _G
local pairs, select = pairs, select
local format = string.format

local hooksecurefunc = hooksecurefunc
local C_Scenario_GetCriteriaInfo = C_Scenario.GetCriteriaInfo
local C_Scenario_GetInfo = C_Scenario.GetInfo
local C_Scenario_GetStepInfo = C_Scenario.GetStepInfo

-- Dungeon Progress for AngryKeystones
function module:AddDungeonProgress(nameplate)
	if not E.db.mui.nameplates.progressText then return end

	self.progressText = nameplate:CreateFontString(nil, 'OVERLAY')
	self.progressText:FontTemplate()
	self.progressText:Point('LEFT', nameplate, 'RIGHT', 5, 0)
end

local cache = {}
function module:UpdateDungeonProgress(unit)
	if not self.progressText or not AngryKeystones_Data then return end
	if unit ~= self.unit then return end
	self.progressText:SetText("")

	local name, _, _, _, _, _, _, _, _, scenarioType = C_Scenario_GetInfo()
	if scenarioType == _G.LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local npcID = self.npcID
		local info = AngryKeystones_Data.progress[npcID]
		if info then
			local numCriteria = select(3, C_Scenario_GetStepInfo())
			local total = cache[name]
			if not total then
				for criteriaIndex = 1, numCriteria do
					local _, _, _, _, totalQuantity, _, _, _, _, _, _, _, isWeightedProgress = C_Scenario_GetCriteriaInfo(criteriaIndex)
					if isWeightedProgress then
						cache[name] = totalQuantity
						total = cache[name]
						break
					end
				end
			end

			local value, valueCount
			for amount, count in pairs(info) do
				if not valueCount or count > valueCount or (count == valueCount and amount < value) then
					value = amount
					valueCount = count
				end
			end

			if value and total then
				self.progressText:SetText(format("+%.2f", value/total*100))
			end
		end
	end
end

function module:PostUpdatePlates(nameplate, event, unit)
	if event ~= 'NAME_PLATE_UNIT_REMOVED' then
		module.UpdateDungeonProgress(self, unit)
	end
end

function module:Initialize()
	if E.private.nameplates.enable ~= true then return end

	-- Castbar Shield
	if E.db.mui.nameplates.castbarShield then
		hooksecurefunc(NP, 'Castbar_CheckInterrupt', module.Castbar_CheckInterrupt)
	end

	hooksecurefunc(NP, 'StylePlate', module.AddDungeonProgress)
	hooksecurefunc(NP, 'NamePlateCallBack', module.PostUpdatePlates)
end

MER:RegisterModule(module:GetName())

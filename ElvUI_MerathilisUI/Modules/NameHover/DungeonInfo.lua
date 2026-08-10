local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local CONTRIBUTION_COLOR = { r = 1, g = 1, b = 1 }
local CONTEXT_COLOR = { r = 0.7, g = 0.7, b = 0.7 } -- light gray: pull progress

local function InMythicPlus()
	if not (C_ChallengeMode and C_ChallengeMode.IsChallengeModeActive) then
		return false
	end
	local ok, active = pcall(C_ChallengeMode.IsChallengeModeActive)
	return ok and active == true
end

local function Present(v)
	if issecretvalue(v) then
		return true
	end
	return v ~= nil and v ~= ""
end

local function NumberStr(v)
	if not Present(v) then
		return nil
	end
	return "" .. v
end

local function Compose(mode, numberStr, percentStr)
	if mode == "NUMBER" then
		return numberStr or percentStr
	elseif mode == "BOTH" then
		if numberStr and percentStr then
			return numberStr .. " (" .. percentStr .. ")"
		end
		return numberStr or percentStr
	end
	return percentStr or numberStr -- default: PERCENT
end

local function GetForcesCriteria()
	if not (C_Scenario and C_Scenario.GetStepInfo and C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo) then
		return nil
	end

	local _, _, numCriteria = C_Scenario.GetStepInfo()
	if not numCriteria or issecretvalue(numCriteria) or numCriteria <= 0 then
		return nil
	end

	for i = 1, numCriteria do
		local info = C_ScenarioInfo.GetCriteriaInfo(i)
		if info and info.isWeightedProgress then
			return info.quantity, info.totalQuantity
		end
	end

	return nil
end

local function Build(unit)
	if not E.db.mui.nameHover.mythicPlus_ShowForces then
		return nil
	end
	if UnitIsPlayer(unit) then
		return nil
	end
	if not InMythicPlus() then
		return nil
	end
	if not (C_ScenarioInfo and C_ScenarioInfo.GetUnitCriteriaProgressValues) then
		return nil
	end

	-- actualValue = raw count (int), percentValueString = preformatted percent.
	-- percentValue (the float) is intentionally ignored: using it requires math.
	local actualValue, _, percentValueString = C_ScenarioInfo.GetUnitCriteriaProgressValues(unit)

	-- Bail only when we can *safely* prove there is nothing to show. When the
	-- value is secret it is present by definition, so we display it.
	if not issecretvalue(actualValue) then
		local n = tonumber(actualValue)
		if not n or n <= 0 then
			return nil
		end
	end

	local mode = E.db.mui.nameHover.mythicPlus_ContributionFormat or "PERCENT"
	local pctPart = Present(percentValueString) and (percentValueString .. "%") or nil
	local contrib = Compose(mode, NumberStr(actualValue), pctPart)
	if not contrib then
		return nil
	end

	local line = F.GetTextWithColor("+" .. contrib, CONTRIBUTION_COLOR)

	if E.db.mui.nameHover.mythicPlus_ShowProgress then
		local currentQ, totalQ = GetForcesCriteria()
		if Present(currentQ) then
			local pMode = E.db.mui.nameHover.mythicPlus_ProgressFormat or "PERCENT"

			local curNum
			if not issecretvalue(currentQ) and not issecretvalue(totalQ) then
				local cp, tr = tonumber(currentQ), tonumber(totalQ)
				if cp and tr then
					curNum = tostring(math.floor((cp / 100) * tr + 0.5))
				end
			end

			local currentStr = Compose(pMode, curNum, NumberStr(currentQ))

			local totalStr = Compose(pMode, NumberStr(totalQ), "100%")

			if currentStr and totalStr then
				local ctx = "(" .. currentStr .. " / " .. totalStr .. ")"
				line = line .. " " .. F.GetTextWithColor(ctx, CONTEXT_COLOR)
			end
		end
	end

	return { line }
end

function module:GetReserveText()
	local mode = "PERCENT"
	local reserve
	if mode == "NUMBER" then
		reserve = "+999"
	elseif mode == "BOTH" then
		reserve = "+999 (100%)"
	else
		reserve = "+100%"
	end

	if E.db.mui.nameHover.mythicPlus_ShowProgress then
		local pMode = "PERCENT"
		local ctx
		if pMode == "NUMBER" then
			ctx = "(999 / 999)"
		elseif pMode == "BOTH" then
			ctx = "(999 (100%) / 999 (100%))"
		else
			ctx = "(999 / 100%)"
		end
		reserve = reserve .. " " .. ctx
	end

	return reserve
end

-- Public: array of colored strings (one line) for the given unit, or nil.
function module:GetForcesText(unit)
	local ok, result = pcall(Build, unit)
	if ok then
		return result
	end
	return nil
end

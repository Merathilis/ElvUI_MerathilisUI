local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local pairs = pairs
local format = format

local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local InCombatLockdown = InCombatLockdown

-- currencyID -> already warned this time above threshold (reset once it drops back below)
local warned = {}

local function GetCurrencyProgress(info)
	if info.maxWeeklyQuantity and info.maxWeeklyQuantity > 0 then
		return info.quantityEarnedThisWeek, info.maxWeeklyQuantity
	elseif info.maxQuantity and info.maxQuantity > 0 then
		return info.quantity, info.maxQuantity
	end
end

function module:CURRENCY_DISPLAY_UPDATE()
	local db = E.db.mui.notification
	if not db or not db.enable or not (db.currencyWarning and db.currencyWarning.enable) or InCombatLockdown() then
		return
	end

	local threshold = (db.currencyWarning.threshold or 90) / 100

	for currencyID in pairs(db.currencyWarning.list) do
		local info = GetCurrencyInfo(currencyID)
		if info and info.name and info.name ~= "" then
			local current, max = GetCurrencyProgress(info)
			if current and max then
				if current / max >= threshold then
					if not warned[currencyID] then
						warned[currencyID] = true
						self:DisplayToast(
							info.name,
							format(L["You are close to the cap: %d / %d"], current, max),
							nil,
							info.iconFileID
						)
					end
				else
					warned[currencyID] = nil
				end
			end
		end
	end
end

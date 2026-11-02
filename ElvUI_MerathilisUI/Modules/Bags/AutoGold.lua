local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local format = format
local min = math.min

local C_Bank = C_Bank
local C_CurrencyInfo_GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString
local CreateFrame = CreateFrame
local GetMoney = GetMoney

local COPPER_PER_GOLD = 10000

-------------------------------------------------------------------------------
--  Auto Deposit/Withdraw Gold: on bank open, moves gold to or from the warband
--  bank so the character carries the set amount. Account-wide, so a shared
--  profile never moves anyone's gold, and independent of the categorized bags.
--  Nothing listens while it is off or no amount is set, an empty amount must
--  never read as "keep nothing".
-------------------------------------------------------------------------------

local eventFrame

---@return table
local function Settings()
	return E.global.mui.bags.autoGold
end

local function Announce(text, copper)
	if Settings().chat then
		F.Print(format(text, C_CurrencyInfo_GetCoinTextureString(copper)))
	end
end

local function Balance()
	local bankType = Enum.BankType.Account
	local difference = GetMoney() - Settings().amount * COPPER_PER_GOLD

	if difference > 0 then
		if C_Bank.CanDepositMoney(bankType) then
			C_Bank.DepositMoney(bankType, difference)
			Announce(L["Deposited %s to the warband bank."], difference)
		end
	elseif difference < 0 and C_Bank.CanWithdrawMoney(bankType) then
		-- Never ask for more than the warband bank holds
		local amount = min(-difference, C_Bank.FetchDepositedMoney(bankType) or 0)
		if amount > 0 then
			C_Bank.WithdrawMoney(bankType, amount)
			Announce(L["Withdrew %s from the warband bank."], amount)
		end
	end
end

---Called on load and from the options
function module:UpdateAutoGold()
	local db = Settings()
	if not E.Forever and db.enable and db.amount then
		if not eventFrame then
			eventFrame = CreateFrame("Frame")
			eventFrame:SetScript("OnEvent", Balance)
		end

		eventFrame:RegisterEvent("BANKFRAME_OPENED")
	elseif eventFrame then
		eventFrame:UnregisterEvent("BANKFRAME_OPENED")
	end
end

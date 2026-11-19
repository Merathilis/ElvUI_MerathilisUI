local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local _G = _G
local type, pairs, ipairs = type, pairs, ipairs
local tinsert, wipe = tinsert, wipe
local tsort = table.sort
local format, strlower = format, strlower
local CreateFrame = CreateFrame
local CreateAtlasMarkup = CreateAtlasMarkup
local GetMoney = GetMoney
local GetTime = GetTime
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown

local FetchDepositedMoney = C_Bank and C_Bank.FetchDepositedMoney
local WARBAND_BANK_TYPE = (Enum.BankType and Enum.BankType.Account) or 2

-- WoW Forever has neither the warband bank nor a WoW Token market
local TokenAPI = not E.Forever and C_WowTokenPublic
local TOKEN_PRICE_THROTTLE = 60

-------------------------------------------------------------------------------
--  Gold display (bag + bank footer)
-------------------------------------------------------------------------------
-- Mirrors ElvUI's Gold DataText: session earned/spent, every character on
-- ElvDB.gold, faction/server totals, warband bank, WoW Token price, plus
-- Ctrl + Right Click to reset the session and Shift + Right Click for the
-- delete-character menu. The DataText keeps its session counters private,
-- so we count our own, from the moment the categorized bags came up.

-- ElvUI keys the character by E.mynameFull ("First Last" on WoW Forever,
-- plain name on Retail), see DT:PLAYER_ENTERING_WORLD in DataTexts.lua.
local function CharacterKey()
	return E.mynameFull or E.myname
end

local session = { profit = 0, spent = 0 }
local tracker, lastTokenRequest
local menuList = {}

local function SortGoldDescending(a, b)
	return a.amount > b.amount
end

local function TooltipIcon(atlas)
	return module.TooltipIcon and module.TooltipIcon(atlas) or (CreateAtlasMarkup(atlas, 14, 14) .. " ")
end

-- Same raw ElvDB.gold/class/faction tables ElvUI's own Gold DataText
-- maintains (and e.g. WindTools' GameBar reads) - one shared source of
-- cross-character data instead of a second, redundant MerathilisUI-only
-- copy. We write to it ourselves too (not just read), so this stays accurate
-- even if the user doesn't have the Gold DataText assigned to any panel.
function module:UpdateGoldTracking()
	local db = _G.ElvDB
	if not db then
		return
	end

	local realm, name = E.myrealm, CharacterKey()

	db.gold = db.gold or {}
	db.gold[realm] = db.gold[realm] or {}
	db.gold[realm][name] = GetMoney()

	db.class = db.class or {}
	db.class[realm] = db.class[realm] or {}
	db.class[realm][name] = E.myclass

	db.faction = db.faction or {}
	db.faction[realm] = db.faction[realm] or {}
	db.faction[realm][name] = E.myfaction

	-- Older versions keyed the character by E.myname, which on WoW Forever
	-- is only the first name - a second entry next to ElvUI's own one.
	if name ~= E.myname then
		db.gold[realm][E.myname] = nil
		db.class[realm][E.myname] = nil
		db.faction[realm][E.myname] = nil
	end
end

local function RefreshGoldDataText()
	local DT = E:GetModule("DataTexts", true)
	if DT and DT.ForceUpdate_DataText then
		DT:ForceUpdate_DataText("Gold")
	end
end

local function DeleteCharacter(realm, name)
	local db = _G.ElvDB
	for _, key in ipairs({ "gold", "class", "faction" }) do
		local realmTable = db and db[key] and db[key][realm]
		if realmTable then
			realmTable[name] = nil
		end
	end

	RefreshGoldDataText()
end

local function DeleteRealm(realm)
	local goldDB = _G.ElvDB and _G.ElvDB.gold
	local chars = goldDB and goldDB[realm]
	if not chars then
		return
	end

	-- The current character stays: it would just be written back on the
	-- next money change anyway.
	for name in pairs(chars) do
		if not (realm == E.myrealm and name == CharacterKey()) then
			DeleteCharacter(realm, name)
		end
	end
end

local function BuildDeleteMenu()
	wipe(menuList)

	local goldDB = _G.ElvDB and _G.ElvDB.gold or {}
	local realms = {}
	for realm in pairs(goldDB) do
		tinsert(realms, realm)
	end
	tsort(realms)

	tinsert(menuList, { text = L["Delete Character"], isTitle = true, notCheckable = true })

	for _, realm in ipairs(realms) do
		local names = {}
		for name in pairs(goldDB[realm]) do
			if not (realm == E.myrealm and name == CharacterKey()) then
				tinsert(names, name)
			end
		end
		tsort(names)

		if #names > 0 then
			tinsert(menuList, {
				text = format(L["Delete All - %s"], realm),
				notCheckable = true,
				func = function()
					DeleteRealm(realm)
				end,
			})

			for _, name in ipairs(names) do
				tinsert(menuList, {
					text = format("%s - %s", name, realm),
					notCheckable = true,
					func = function()
						DeleteCharacter(realm, name)
					end,
				})
			end
		end
	end

	return #menuList > 1
end

-------------------------------------------------------------------------------
--  Session counters
-------------------------------------------------------------------------------
local function OnTrackerEvent(_, event)
	if event == "PLAYER_MONEY" then
		local money = GetMoney()
		local change = money - (session.lastMoney or money)
		if change > 0 then
			session.profit = session.profit + change
		elseif change < 0 then
			session.spent = session.spent - change
		end
		session.lastMoney = money
	elseif event == "TOKEN_MARKET_PRICE_UPDATED" then
		local owner = not _G.GameTooltip:IsForbidden() and _G.GameTooltip:GetOwner()
		if owner and owner.isMERGoldButton and owner:IsMouseOver() then
			module:ShowGoldTooltip(owner)
		end
	end
end

-- Only runs while the categorized bags are active, the gold display only
-- exists there. Counters survive a toggle, the baseline is taken fresh.
function module:UpdateGoldSession()
	local enabled = module:IsCategorizedBagsActive()

	if not enabled then
		if tracker then
			tracker:UnregisterAllEvents()
		end
		return
	end

	if not tracker then
		tracker = CreateFrame("Frame")
		tracker:SetScript("OnEvent", OnTrackerEvent)
	end

	session.lastMoney = GetMoney()
	tracker:RegisterEvent("PLAYER_MONEY")
	if TokenAPI then
		tracker:RegisterEvent("TOKEN_MARKET_PRICE_UPDATED")
	end
end

function module:ResetGoldSession()
	session.profit, session.spent = 0, 0
	session.lastMoney = GetMoney()
end

-------------------------------------------------------------------------------
--  Tooltip
-------------------------------------------------------------------------------
local function AddMoneyLine(tooltip, label, amount, r, g, b)
	tooltip:AddDoubleLine(label, E:FormatMoney(amount, "SMART"), r or 1, g or 1, b or 1, 1, 1, 1)
end

local function GetTokenPrice()
	if not TokenAPI then
		return
	end

	-- The price arrives with TOKEN_MARKET_PRICE_UPDATED, an open tooltip
	-- refreshes itself then (OnTrackerEvent).
	local now = GetTime()
	if not lastTokenRequest or now - lastTokenRequest > TOKEN_PRICE_THROTTLE then
		lastTokenRequest = now
		TokenAPI.UpdateMarketPrice()
	end

	return TokenAPI.GetCurrentMarketPrice()
end

function module:ShowGoldTooltip(anchor)
	local tooltip = _G.GameTooltip
	if tooltip:IsForbidden() then
		return
	end

	module:UpdateGoldTracking()

	local goldDB = _G.ElvDB and _G.ElvDB.gold or {}
	local classDB = _G.ElvDB and _G.ElvDB.class or {}
	local factionDB = _G.ElvDB and _G.ElvDB.faction or {}
	local myName = CharacterKey()

	local characters = {}
	local total, alliance, horde = 0, 0, 0
	for realm, chars in pairs(goldDB) do
		for name, amount in pairs(chars) do
			if type(amount) == "number" then
				local faction = factionDB[realm] and factionDB[realm][name]
				tinsert(characters, {
					name = name,
					realm = realm,
					amount = amount,
					class = classDB[realm] and classDB[realm][name],
					isMe = realm == E.myrealm and name == myName,
				})
				total = total + amount
				if faction == "Alliance" then
					alliance = alliance + amount
				elseif faction == "Horde" then
					horde = horde + amount
				end
			end
		end
	end
	tsort(characters, SortGoldDescending)

	tooltip:SetOwner(anchor, "ANCHOR_TOPLEFT")
	tooltip:ClearLines()

	-- Session
	tooltip:AddLine(L["Session:"])
	AddMoneyLine(tooltip, L["Earned:"], session.profit)
	AddMoneyLine(tooltip, L["Spent:"], session.spent)
	if session.spent ~= 0 then
		local gained = session.profit > session.spent
		AddMoneyLine(
			tooltip,
			gained and L["Profit:"] or L["Deficit:"],
			gained and (session.profit - session.spent) or (session.spent - session.profit),
			gained and 0 or 1,
			gained and 1 or 0,
			0
		)
	end

	-- Characters
	tooltip:AddLine(" ")
	tooltip:AddLine(L["Character: "])
	for _, data in ipairs(characters) do
		local color = (data.class and E:ClassColor(data.class)) or _G.HIGHLIGHT_FONT_COLOR
		local nameLine = data.realm ~= E.myrealm and format("%s - %s", data.name, data.realm) or data.name
		if data.class then
			nameLine = TooltipIcon("classicon-" .. strlower(data.class)) .. nameLine
		end
		if data.isMe then
			-- Same marker ElvUI's Gold DataText puts next to the current character
			nameLine = nameLine .. [[ |TInterface\COMMON\Indicator-Green:14|t]]
		end
		AddMoneyLine(tooltip, nameLine, data.amount, color.r, color.g, color.b)
	end

	-- Totals
	tooltip:AddLine(" ")
	if alliance > 0 and horde > 0 then
		AddMoneyLine(tooltip, L["Alliance: "], alliance, 0, 0.376, 1)
		AddMoneyLine(tooltip, L["Horde: "], horde, 1, 0.2, 0.2)
	end
	AddMoneyLine(tooltip, TooltipIcon("coin-gold") .. (_G.TOTAL or L["Total"]), total)

	if not E.Forever and FetchDepositedMoney then
		local ok, warbandGold = pcall(FetchDepositedMoney, WARBAND_BANK_TYPE)
		if ok and warbandGold then
			AddMoneyLine(tooltip, TooltipIcon("warbands-icon") .. L["Warband Bank"], warbandGold)
		end
	end

	local tokenPrice = GetTokenPrice()
	if tokenPrice and tokenPrice > 0 then
		tooltip:AddLine(" ")
		AddMoneyLine(tooltip, L["WoW Token:"], tokenPrice, 0, 0.8, 1)
	end

	local junkValue = module.GetJunkValue and module:GetJunkValue() or 0
	if junkValue > 0 then
		tooltip:AddLine(" ")
		local title = module.IsJunkMarkerEnabled and module:IsJunkMarkerEnabled() and L["Sell Junk"] or L["Grays"]
		AddMoneyLine(tooltip, title, junkValue)
	end

	tooltip:AddLine(" ")
	tooltip:AddLine(L["Reset Session Data: Hold Ctrl + Right Click"], 0.67, 0.67, 0.67)
	tooltip:AddLine(L["Reset Character Data: Hold Shift + Right Click"], 0.67, 0.67, 0.67)

	tooltip:Show()
end

-------------------------------------------------------------------------------
--  Button
-------------------------------------------------------------------------------
local function OnGoldClick(self, button)
	if button ~= "RightButton" then
		return
	end

	if IsShiftKeyDown() then
		if BuildDeleteMenu() then
			_G.GameTooltip:Hide()
			E:SetEasyMenuAnchor(E.EasyMenu, self)
			E:ComplicatedMenu(menuList, E.EasyMenu, nil, nil, nil, "MENU")
		end
	elseif IsControlKeyDown() then
		module:ResetGoldSession()
		if self:IsMouseOver() then
			module:ShowGoldTooltip(self)
		end
	end
end

-- Invisible hit-box over a gold FontString (a FontString can't take mouse
-- input itself), shared by the bag and the bank footer.
function module:CreateGoldButton(parent, text)
	local button = CreateFrame("Button", nil, parent)
	button:SetAllPoints(text)
	button:RegisterForClicks("RightButtonUp")
	button.isMERGoldButton = true
	button:SetScript("OnEnter", function(self)
		module:ShowGoldTooltip(self)
	end)
	button:SetScript("OnLeave", _G.GameTooltip_Hide)
	button:SetScript("OnClick", OnGoldClick)

	return button
end

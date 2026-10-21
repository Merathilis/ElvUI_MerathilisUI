local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local S = E:GetModule("Skins")

local _G = _G
local format = string.format
local ipairs = ipairs
local max = math.max

local BuyTrainerService = BuyTrainerService
local CreateFrame = CreateFrame
local GetMoney = GetMoney
local GetMoneyString = GetMoneyString
local GetNumTrainerServices = GetNumTrainerServices
local GetTrainerServiceCost = GetTrainerServiceCost
local GetTrainerServiceInfo = GetTrainerServiceInfo
local hooksecurefunc = hooksecurefunc

local button

---Indices of the services the player can learn and pay for right now, from the last one on:
---buying a service moves the ones behind it up. New professions are left out, Blizzard asks
---before it learns one of those.
---@return number[] services
---@return number cost
local function GetAffordableServices()
	local money, cost, services = GetMoney(), 0, {}
	for index = GetNumTrainerServices(), 1, -1 do
		local _, serviceType = GetTrainerServiceInfo(index)
		if serviceType == "available" then
			local moneyCost, isProfession = GetTrainerServiceCost(index)
			moneyCost = moneyCost or 0
			if not isProfession and moneyCost <= money then
				money = money - moneyCost
				cost = cost + moneyCost
				services[#services + 1] = index
			end
		end
	end

	return services, cost
end

local function UpdateButton()
	button:SetEnabled(#GetAffordableServices() > 0)
end

local function Button_OnClick(self)
	for _, index in ipairs(GetAffordableServices()) do
		BuyTrainerService(index)
	end

	-- The next TRAINER_UPDATE enables it again, until then a second click would buy twice
	self:Disable()
	_G.GameTooltip:Hide()
end

local function Button_OnEnter(self)
	local services, cost = GetAffordableServices()
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(self, "ANCHOR_TOP")
	tooltip:AddLine(L["Train All"], 1, 1, 1)
	if #services > 0 then
		tooltip:AddLine(
			format(L["Learns %d available entries for %s."], #services, GetMoneyString(cost, true)),
			1,
			0.82,
			0,
			true
		)
	else
		tooltip:AddLine(L["Nothing to learn that you can afford."], 1, 0.82, 0, true)
	end
	tooltip:Show()
end

function module:TrainAll()
	if not E.db.mui.misc.trainAll or button then
		return
	end

	local trainButton = _G.ClassTrainerTrainButton
	if not trainButton then
		return
	end

	button = CreateFrame("Button", "MER_TrainAllButton", _G.ClassTrainerFrame, "UIPanelButtonTemplate")
	button:SetText(L["Train All"])
	-- Fits between the money frame and the train button
	button:SetSize(max(trainButton:GetWidth(), button:GetFontString():GetStringWidth() + 24), trainButton:GetHeight())
	button:SetPoint("RIGHT", trainButton, "LEFT", -2, 0)
	button:SetMotionScriptsWhileDisabled(true)
	button:SetScript("OnClick", Button_OnClick)
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", _G.GameTooltip_Hide)
	S:HandleButton(button)

	-- Runs on every TRAINER_UPDATE, buying included
	hooksecurefunc("ClassTrainerFrame_Update", UpdateButton)
	UpdateButton()
end

module:AddCallbackForAddon("Blizzard_TrainerUI", module.TrainAll)

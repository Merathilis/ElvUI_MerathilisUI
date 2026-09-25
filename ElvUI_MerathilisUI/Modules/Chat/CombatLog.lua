local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")

local _G = _G
local ipairs = ipairs

local C_AddOns = C_AddOns
local hooksecurefunc = hooksecurefunc

local INACTIVE_ALPHA = 0.6

-- Buttons we already hooked; kept here instead of as a field on Blizzard's frames.
local hookedButtons = {}

local function IsEnabled()
	local db = module.chatDB
	return db and db.combatLog.enable and E.private.chat.enable
end

local function IsActiveFilter(button)
	local filters = _G.Blizzard_CombatLog_Filters
	local settings = _G.Blizzard_CombatLog_CurrentSettings
	return filters and filters.currentFilter == button:GetID() and not (settings and settings.isTemp)
end

-- The active filter reads in the class color, the others stay dimmed until
-- hovered. Switched off, the colors of Blizzard's own font objects come back.
local function ColorButton(button)
	local text = button and button:GetFontString()
	if not text then
		return
	end

	local active = IsActiveFilter(button)

	if not IsEnabled() then
		local fontObject = active and _G.GameFontHighlight or _G.GameFontDisable
		text:SetTextColor(fontObject:GetTextColor())
	elseif active then
		local cc = E.myClassColor
		text:SetTextColor(cc.r, cc.g, cc.b)
	elseif button:IsMouseOver() then
		text:SetTextColor(1, 1, 1, 1)
	else
		text:SetTextColor(1, 1, 1, INACTIVE_ALPHA)
	end
end

function module:UpdateCombatLog()
	local filters = _G.Blizzard_CombatLog_Filters
	if not filters then
		return
	end

	for index in ipairs(filters.filters) do
		local button = _G["CombatLogQuickButtonFrameButton" .. index]
		if button then
			-- Hover swaps Blizzard's font object, which resets the color.
			if not hookedButtons[button] then
				hookedButtons[button] = true
				button:HookScript("OnEnter", ColorButton)
				button:HookScript("OnLeave", ColorButton)
			end

			ColorButton(button)
		end
	end
end

function module:SetupCombatLog()
	hooksecurefunc("Blizzard_CombatLog_Update_QuickButtons", function()
		module:UpdateCombatLog()
	end)

	self:UpdateCombatLog()
end

function module:InitializeCombatLog()
	if C_AddOns.IsAddOnLoaded("Blizzard_CombatLog") then
		self:SetupCombatLog()
		return
	end

	self:RegisterEvent("ADDON_LOADED", function(_, addon)
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetupCombatLog()
		end
	end)
end

local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local format = string.format
local tinsert = table.insert
local strlen = strlen
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetGuildRosterMOTD = GetGuildRosterMOTD
local GetGuildInfo = GetGuildInfo
local GetScreenHeight = GetScreenHeight
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local PlaySound = PlaySound
local UISpecialFrames = UISpecialFrames
-- GLOBALS:

local gmotd

function MI:GMOTD()
	-- MainFrame
	if not gmotd then
		if not IsInGuild() then return; end

		local gmotd = CreateFrame("Frame", "MER.GMOTD", E.UIParent)
		gmotd:SetPoint("CENTER", 0, GetScreenHeight()/5)
		gmotd:SetSize(350, 150)
		gmotd:SetToplevel(true)
		gmotd:SetMovable(true)
		gmotd:EnableMouse(true)
		gmotd:SetClampedToScreen(true)
		gmotd:SetFrameStrata("TOOLTIP")
		gmotd:SetScript("OnMouseDown", gmotd.StartMoving)
		gmotd:SetScript("OnMouseUp", gmotd.StopMovingOrSizing)
		gmotd:CreateBackdrop("Transparent")
		gmotd.backdrop:SetAllPoints()

		gmotd:Styling()
		gmotd:Hide()

		gmotd.button = CreateFrame("Button", nil, gmotd, "UIPanelButtonTemplate")
		gmotd.button:SetText(L["Ok"])
		gmotd.button:SetPoint("TOP", gmotd, "BOTTOM", 0, -3)
		S:HandleButton(gmotd.button)
		gmotd.button:SetScript("OnClick", function(self)
			gmotd:Hide()
		end)

		gmotd.header = MER:CreateText(gmotd, "OVERLAY", 14, "OUTLINE")
		gmotd.header:SetPoint("BOTTOM", gmotd, "TOP", 0, 4)
		gmotd.header:SetTextColor(1, 1, 0)

		gmotd.text = MER:CreateText(gmotd, "OVERLAY", 12, "OUTLINE", nil, "CENTER", 0, 0)
		gmotd.text:SetHeight(130)
		gmotd.text:SetTextColor(1, 1, 1)
		gmotd.text:CanWordWrap(true)
		gmotd.text:SetWordWrap(true)

		gmotd:SetScript("OnEvent", function(self, event, message)
			local icon = "|TInterface\\CHATFRAME\\UI-ChatIcon-Share:18:18|t"

			local guild = false
			local msg = false
			if (event == "GUILD_MOTD") then
				msg = message
				guild = select(1, GetGuildInfo("player"))
			else
				msg = GetGuildRosterMOTD()
				guild = select(1, GetGuildInfo("player"))
			end

			if (strlen(msg) > 0 and guild and not InCombatLockdown()) then
				gmotd.msg = msg
				gmotd.text:SetText(msg)
				gmotd.header:SetText(icon..(format("|cff00c0fa%s|r", guild))..": ".._G.GUILD_MOTD_LABEL2)
				gmotd:Show()
				PlaySound(12867) --Sound\Interface\alarmclockwarning2.ogg

				local numLines = gmotd.text:GetNumLines()
				gmotd:SetHeight(20 + (12.2*numLines))
			else
				gmotd:Hide()
			end
		end)
		gmotd:RegisterEvent("PLAYER_LOGIN")
		gmotd:RegisterEvent("GUILD_MOTD")
	end
end

function MI:LoadGMOTD()
	if E.db.mui.misc.gmotd then
		self:GMOTD()
		tinsert(UISpecialFrames, "MER.GMOTD")
	end
end

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
		gmotd:SetFrameStrata("TOOLTIP")
		gmotd:SetMovable(true)
		gmotd:EnableMouse(true)
		gmotd:SetScript("OnMouseDown", gmotd.StartMoving)
		gmotd:SetScript("OnMouseUp", gmotd.StopMovingOrSizing)
		gmotd:CreateBackdrop("Transparent")
		gmotd.backdrop:SetAllPoints()

		gmotd:Styling()
		gmotd:Hide()

		gmotd.header = gmotd:CreateFontString(nil)
		gmotd.header:FontTemplate(nil, 14, "OUTLINE")
		gmotd.header:SetPoint("BOTTOM", gmotd, "TOP", 0, 2)
		gmotd.header:SetTextColor(1, 1, 0)

		gmotd.text = gmotd:CreateFontString(nil)
		gmotd.text:FontTemplate(nil, 13, "OUTLINE")
		gmotd.text:SetHeight(130)
		gmotd.text:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 10, -10)
		gmotd.text:SetPoint("TOPRIGHT", gmotd, "TOPRIGHT", -10, -10)
		gmotd.text:SetJustifyV("TOP")
		gmotd.text:SetTextColor(0, 1, 0)
		gmotd.text:CanWordWrap(true)
		gmotd.text:SetWordWrap(true)

		gmotd.button = CreateFrame("Button", nil, gmotd, "UIPanelButtonTemplate")
		gmotd.button:SetText(L["Ok"])
		gmotd.button:SetPoint("TOP", gmotd, "BOTTOM", 0, -4)
		S:HandleButton(gmotd.button)

		gmotd.button:SetScript("OnClick", function(self)
			MER.gmotd[gmotd.msg] = true
			gmotd:Hide()
		end)

		local icon = "|TInterface\\CHATFRAME\\UI-ChatIcon-Share:18:18|t"
		gmotd:SetScript("OnEvent", function(self, event, message)
			local guild = false
			local msg = false
			if (event == "GUILD_MOTD") then
				msg = message
				guild = select(1, GetGuildInfo("player"))
			else
				msg = GetGuildRosterMOTD()
				guild = select(1, GetGuildInfo("player"))
			end

			MER.gmotd = MER.gmotd or {}
			if (strlen(msg) > 0 and guild and not MER.gmotd[msg]) then
				if InCombatLockdown() then return end
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

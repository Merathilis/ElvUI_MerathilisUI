local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local S = E:GetModule("Skins");
local LSM = LibStub("LibSharedMedia-3.0");

-- Cache global variables
-- Lua functions
local tinsert = table.insert
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetGuildRosterMOTD = GetGuildRosterMOTD
local GetScreenHeight = GetScreenHeight
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsInGuild = IsInGuild
local PlaySoundFile = PlaySoundFile
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: GMOTD, gmotd, GUILD_MOTD_LABEL2

local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- Code taken from bitbyte - SayGMOTD
if IsAddOnLoaded("SayGMOTD") then return end;

GMOTD = ""

function MER:GMOTD()
	-- MainFrame
	if not gmotd then
		local gmotd = CreateFrame("Frame", "MER.GMOTD", E.UIParent)
		gmotd:SetPoint("CENTER", 0, GetScreenHeight()/5)
		gmotd:SetWidth(300)
		gmotd:SetHeight(65)
		gmotd:SetToplevel(true)
		gmotd:SetMovable(true)
		gmotd:EnableMouse(true)
		gmotd:SetClampedToScreen(true)
		gmotd:SetFrameStrata("TOOLTIP")
		gmotd:SetScript("OnMouseDown", gmotd.StartMoving)
		gmotd:SetScript("OnMouseUp", gmotd.StopMovingOrSizing)
		gmotd:CreateBackdrop("Transparent")
		gmotd.backdrop:SetAllPoints()
		MER:CreateSoftShadow(gmotd)
		gmotd:Hide()
		if IsAddOnLoaded("ElvUI_BenikUI") then
			MER:StyleOutside(gmotd)
		else
			gmotd.style = CreateFrame("Frame", nil, gmotd)
			gmotd.style:SetTemplate("Default", true)
			gmotd.style:SetWidth(300)
			gmotd.style:SetHeight(5)
			gmotd.style:Point("TOP", gmotd, 0, 1)

			gmotd.style.color = gmotd.style:CreateTexture(nil, "OVERLAY")
			gmotd.style.color:SetVertexColor(MER.Color.r, MER.Color.g, MER.Color.b)
			gmotd.style.color:SetInside()
			gmotd.style.color:SetTexture(flat)
		end

		gmotd.button = CreateFrame("Button", nil, gmotd, "UIPanelCloseButton")
		gmotd.button:SetPoint("TOPRIGHT", 0, 0)
		S:HandleCloseButton(gmotd.button)
		gmotd.button:SetScript("OnClick", function()
			gmotd:Hide()
		end)

		gmotd.header = gmotd:CreateFontString(nil, "OVERLAY")
		gmotd.header:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 0, -10)
		gmotd.header:SetWidth(gmotd:GetRight() - gmotd:GetLeft())
		gmotd.header:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, "OUTLINE")
		gmotd.header:SetTextColor(1, 1, 0)
		gmotd.header:SetText(GUILD_MOTD_LABEL2)

		gmotd.text = gmotd:CreateFontString(nil, "OVERLAY")
		gmotd.text:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 22, -40)
		gmotd.text:SetWidth(gmotd:GetRight() - gmotd:GetLeft() - 40)
		gmotd.text:FontTemplate()
		gmotd.text:SetTextColor(1, 1, 1)
		gmotd.text:SetJustifyH("LEFT")

		gmotd:SetScript("OnEvent", function(_, event, arg1)
			if (event == "GUILD_MOTD") then
				GMOTD = arg1
			else
				GMOTD = IsInGuild() and GetGuildRosterMOTD() or ""
			end
			if (GMOTD ~= "") and not InCombatLockdown() then
				PlaySoundFile([[Sound\Interface\alarmclockwarning2.ogg]])
				gmotd.text:SetText(GMOTD)
				gmotd:SetHeight(gmotd.text:GetHeight() + 65)
				gmotd:Show()
			else
				gmotd:Hide()
			end
		end)
	gmotd:RegisterEvent("PLAYER_LOGIN")
	gmotd:RegisterEvent("GUILD_MOTD")
	end
end

function MER:LoadGMOTD()
	if E.db.mui.misc.gmotd then
		self:GMOTD()
		tinsert(UISpecialFrames, "MER.GMOTD");
	end
end
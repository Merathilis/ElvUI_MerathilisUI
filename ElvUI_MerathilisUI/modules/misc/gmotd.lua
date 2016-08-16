local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetGuildRosterMOTD = GetGuildRosterMOTD
local IsAddOnLoaded = IsAddOnLoaded
local IsInGuild = IsInGuild
local PlaySoundFile = PlaySoundFile
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GMOTD

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
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
			gmotd.style:SetFrameStrata("TOOLTIP")
			gmotd.style:SetInside()
			gmotd.style:Point("TOPLEFT", gmotd, "BOTTOMLEFT", 0, 1)
			gmotd.style:Point("BOTTOMRIGHT", gmotd, "BOTTOMRIGHT", 0, (E.PixelMode and -4 or -7))
			
			gmotd.style.color = gmotd.style:CreateTexture(nil, "OVERLAY")
			gmotd.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
			gmotd.style.color:SetInside()
			gmotd.style.color:SetTexture(flat)
		end

		gmotd.button = CreateFrame("Button", nil, gmotd, "UIPanelCloseButton")
		gmotd.button:SetPoint("TOPRIGHT", 0, 0)
		S:HandleCloseButton(gmotd.button)
		gmotd.button:SetScript("OnClick", function()
			gmotd:Hide()
		end)

		gmotd.header = gmotd:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		gmotd.header:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 0, -10)
		gmotd.header:SetWidth(gmotd:GetRight() - gmotd:GetLeft())
		gmotd.header:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, "OUTLINE")
		gmotd.header:SetText(L["Guild Message Of The Day"])

		gmotd.text = gmotd:CreateFontString(nil, "OVERLAY", "GameFontWhite")
		gmotd.text:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 22, -40)
		gmotd.text:SetWidth(gmotd:GetRight() - gmotd:GetLeft() - 40)
		gmotd.text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 10, "OUTLINE")
		gmotd.text:SetJustifyH("LEFT")

		gmotd:SetScript("OnEvent", function(self, event, arg1)
			if (event == "GUILD_MOTD") then
				GMOTD = arg1
			else
				GMOTD = IsInGuild() and GetGuildRosterMOTD() or ""
			end
			if (GMOTD ~= "") then
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
	end
end
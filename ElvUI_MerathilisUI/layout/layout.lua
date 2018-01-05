local MER, E, L, V, P, G = unpack(select(2, ...))
local MERL = E:NewModule("mUILayout", "AceHook-3.0", "AceEvent-3.0")
local MERS = E:GetModule("muiSkins")
local LSM = LibStub("LibSharedMedia-3.0")
local CH = E:GetModule("Chat")
local LO = E:GetModule("Layout")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local GameTooltip = _G["GameTooltip"]
--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: RightChatTab, RightChatPanel, ChatTab_Datatext_Panel

function MERL:LoadLayout()
	--Create extra panels
	MERL:CreateExtraDataBarPanels()
end
hooksecurefunc(LO, "Initialize", MERL.LoadLayout)

function MERL:CreateExtraDataBarPanels()
	local chattab = CreateFrame("Frame", "ChatTab_Datatext_Panel", RightChatPanel)
	chattab:SetScript("OnShow", function(self)
		chattab:SetPoint("TOPRIGHT", RightChatTab, "TOPRIGHT", 0, 0)
		chattab:SetPoint("BOTTOMLEFT", RightChatTab, "BOTTOMLEFT", 0, 0)
	end)
	chattab:Hide()
	E.FrameLocks["ChatTab_Datatext_Panel"] = true
	E:GetModule("DataTexts"):RegisterPanel(chattab, 3, "ANCHOR_TOPLEFT", -3, 4)
end

function MER:ToggleDataPanels()
	if E.db.mui.datatexts.rightChatTabDatatextPanel then
		ChatTab_Datatext_Panel:Show()
	else
		ChatTab_Datatext_Panel:Hide()
	end
end

-- Panels
function MERL:CreatePanels()
	if E.db.mui.general.panel then
		local topPanel = CreateFrame("Frame", MER.Title.."TopPanel", E.UIParent)
		topPanel:SetFrameStrata("BACKGROUND")
		topPanel:SetPoint("TOP", 0, 3)
		topPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
		topPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
		topPanel:SetHeight(15)
		topPanel:SetTemplate("Transparent")
		topPanel:Styling()

		local bottomPanel = CreateFrame("Frame", MER.Title.."BottomPanel", E.UIParent)
		bottomPanel:SetFrameStrata("BACKGROUND")
		bottomPanel:SetPoint("BOTTOM", 0, -3)
		bottomPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
		bottomPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
		bottomPanel:SetHeight(15)
		bottomPanel:SetTemplate("Transparent")
		bottomPanel:Styling()

		local topLeftStyle = CreateFrame("Frame", MER.Title.."TopLeftStyle", E.UIParent)
		topLeftStyle:SetFrameStrata("BACKGROUND")
		topLeftStyle:SetFrameLevel(2)
		topLeftStyle:SetSize(E.screenwidth*2/9, 4)
		topLeftStyle:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
		MERS:SkinPanel(topLeftStyle)

		local topRightStyle = CreateFrame("Frame", MER.Title.."TopRightStyle", E.UIParent)
		topRightStyle:SetFrameStrata("BACKGROUND")
		topRightStyle:SetFrameLevel(2)
		topRightStyle:SetSize(E.screenwidth*2/9, 4)
		topRightStyle:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -10)
		MERS:SkinPanel(topRightStyle)

		local bottomLeftSytle = CreateFrame("Frame", MER.Title.."BottomLeftStyle", E.UIParent)
		bottomLeftSytle:SetFrameStrata("BACKGROUND")
		bottomLeftSytle:SetFrameLevel(2)
		bottomLeftSytle:SetSize(E.screenwidth*2/9, 4)
		bottomLeftSytle:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 10)
		MERS:SkinPanel(bottomLeftSytle)

		local bottomRightStyle = CreateFrame("Frame", MER.Title.."BottomRightStyle", E.UIParent)
		bottomRightStyle:SetFrameStrata("BACKGROUND")
		bottomRightStyle:SetFrameLevel(2)
		bottomRightStyle:SetSize(E.screenwidth*2/9, 4)
		bottomRightStyle:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 10)
		MERS:SkinPanel(bottomRightStyle)
	end
end

function MERL:Initialize()
	MER:ToggleDataPanels()
	self:CreatePanels()
end

local function InitializeCallback()
	MERL:Initialize()
end

E:RegisterModule(MERL:GetName(), InitializeCallback)
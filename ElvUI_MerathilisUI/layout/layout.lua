local MER, E, L, V, P, G = unpack(select(2, ...))
local MERL = E:NewModule("mUILayout", "AceHook-3.0", "AceEvent-3.0")
local LO = E:GetModule("Layout")
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: RightChatTab, RightChatPanel, ChatTab_Datatext_Panel

function MER:LoadLayout()
	--Create extra panels
	MER:CreateExtraDataBarPanels()
end
hooksecurefunc(LO, "Initialize", MER.LoadLayout)

function MER:CreateExtraDataBarPanels()
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

function MERL:CreateChatButton()
	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"])
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", 3, -5)
	ChatButton:Size(14, 14)
	ChatButton:SetAlpha(0.35)
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\chatButton.blp]])

	ChatButton:SetScript("OnEnter", function(self) self:SetAlpha(0.65) end)
	ChatButton:SetScript("OnLeave", function(self) self:SetAlpha(0.35) end)

	ChatButton:SetScript("OnMouseUp", function (self, btn)
		if btn == "LeftButton" then
			if InCombatLockdown() then return end

			if E.db.chat.panelHeight == 368 then
					if panelBackdrop == 'LEFT' then
						E.db.chat.panelHeight = 155
					else
						E.db.chat.panelHeight = 155
					end
				E:GetModule("Chat"):PositionChat(true)
			else
				E.db.chat.panelHeight = 368
				E:GetModule("Chat"):PositionChat(true)
			end
		end
	end)
end

function MERL:Initialize()
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		MER:ToggleDataPanels()
	end)
	self:CreateChatButton()
end

local function InitializeCallback()
	MERL:Initialize()
end

E:RegisterModule(MERL:GetName(), InitializeCallback)
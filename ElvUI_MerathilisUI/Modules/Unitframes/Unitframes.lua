local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc
local ipairs = ipairs

-- Every unit and group frame gets the same mouseover highlight
local HIGHLIGHT_UPDATES = {
	"Update_PlayerFrame",
	"Update_TargetFrame",
	"Update_TargetTargetFrame",
	"Update_PetFrame",
	"Update_FocusFrame",
	"Update_FocusTargetFrame",
	"Update_PartyFrames",
	"Update_RaidFrames",
	"Update_BossFrames",
}

local function Highlight_OnEnter(frame)
	if E.db.mui.unitframes.highlight then
		frame.MER_Highlight:Show()
	end
end

local function Highlight_OnLeave(frame)
	frame.MER_Highlight:Hide()
end

-- ElvUI's update functions run again and again, the highlight is only built once
function module:CreateHighlight(frame)
	if not frame or frame.MER_Highlight then
		return
	end
	if not E.db.mui.unitframes.highlight then
		return
	end

	local hl = frame:CreateTexture(nil, "BACKGROUND")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, 0.5, 1)
	hl:SetVertexColor(1, 1, 0.6, 1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	frame.MER_Highlight = hl

	frame:HookScript("OnEnter", Highlight_OnEnter)
	frame:HookScript("OnLeave", Highlight_OnLeave)
end

function module:Initialize()
	if not E.private.unitframe.enable then
		return
	end

	-- Highlight
	local function UpdateFrame(_, frame)
		module:CreateHighlight(frame)
	end
	for _, update in ipairs(HIGHLIGHT_UPDATES) do
		hooksecurefunc(UF, update, UpdateFrame)
	end
	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)
	-- Faction Indicator
	module:FactionIndicator()
	-- Interrupt Ready
	module:InterruptReady()
	-- Castbar Shield
	module:CastbarShield()
	-- Execute Line
	module:ExecuteLine()
	-- Resting Indicator
	module:RestingIndicator()
	-- Rounded Corners
	module:RoundedCorners()
end

-- The settings are read on every configure, the frames that exist just need a refresh
function module:ProfileUpdate()
	if not E.private.unitframe.enable then
		return
	end

	module:UpdateFactionIndicators()
	module:UpdateInterruptReady()
	module:UpdateCastbarShield()
	module:UpdateExecuteLines()
	module:UpdateRestingIndicator()
	module:UpdateRoundedCorners()
end

MER:RegisterModule(module:GetName())

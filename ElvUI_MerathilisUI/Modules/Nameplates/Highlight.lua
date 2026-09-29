local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local LSM = E.LSM or E.Libs.LSM

local hooksecurefunc = hooksecurefunc
local pairs = pairs

-- Restyles ElvUI's mouseover highlight on plates with a health bar. ElvUI sets
-- its flat color texture again in every Update_Highlight, so the hook reapplies ours.

local FADE_DURATION = 0.15

local function Highlight_OnShow(highlight)
	local db = E.db.mui.nameplates.highlight
	if db and db.enable and db.fade and highlight.MER_Styled then
		highlight.MER_Fade:Stop()
		highlight.MER_Fade:Play()
	end
end

local function GetHighlightColor(db)
	if db.colorMode == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	end

	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

local function ResetHighlight(highlight)
	if not highlight.MER_Styled then
		return
	end

	highlight.MER_Styled = nil
	highlight.texture:SetVertexColor(1, 1, 1, 1)
	highlight.texture:SetBlendMode("BLEND")
end

function module:Configure_Highlight(nameplate)
	local highlight = nameplate and nameplate.Highlight
	if not highlight or not highlight.texture then
		return
	end

	local db = E.db.mui.nameplates.highlight
	local plateDb = NP:PlateDB(nameplate)
	-- The name-only highlight is a spark behind the name, only the bar highlight gets restyled
	local hasBar = plateDb and plateDb.health and plateDb.health.enable and not plateDb.nameOnly

	if not (db and db.enable and hasBar) then
		ResetHighlight(highlight)
		return
	end

	if not highlight.MER_Fade then
		local fade = highlight:CreateAnimationGroup()
		local alpha = fade:CreateAnimation("Alpha")
		alpha:SetFromAlpha(0)
		alpha:SetToAlpha(1)
		alpha:SetDuration(FADE_DURATION)
		alpha:SetSmoothing("OUT")
		highlight.MER_Fade = fade
		highlight:HookScript("OnShow", Highlight_OnShow)
	end

	local r, g, b = GetHighlightColor(db)
	local texture = highlight.texture
	texture:SetTexture(LSM:Fetch("statusbar", db.texture))
	texture:SetVertexColor(r, g, b, 1)
	texture:SetBlendMode(db.additive and "ADD" or "BLEND")
	texture:SetAlpha(db.alpha)
	highlight.MER_Styled = true
end

function module:UpdateHighlights()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		NP:Update_Highlight(nameplate)
	end
end

function module:Highlight()
	hooksecurefunc(NP, "Update_Highlight", function(_, nameplate)
		module:Configure_Highlight(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateHighlights()
end

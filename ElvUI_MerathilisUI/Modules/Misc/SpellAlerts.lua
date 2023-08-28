local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_SpellAlert')

local _G = _G
local pairs = pairs
local tonumber = tonumber

local SpellActivationOverlay_ShowOverlay = SpellActivationOverlay_ShowOverlay
local C_CVar_GetCVar = C_CVar.GetCVar

function module:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:Update()
end

function module:Update()
	if not E.db.mui.misc.spellAlert then
		return
	end

	local scale = 1
	if E.db.mui.misc.spellAlert.enable then
		scale = E.db.mui.misc.spellAlert.scale or scale
	end

	local opacity = tonumber(C_CVar_GetCVar("spellActivationOverlayOpacity"))

	_G.SpellActivationOverlayFrame:SetAlpha(opacity)
	_G.SpellActivationOverlayFrame:SetScale(scale)
end

function module:Preview()
	self.previewID = (self.previewID or 0) + 1
	local _previewID = self.previewID

	local examples = {
		["TOP"] = { false, true, 449488 },
		["BOTTOM"] = { true, false, 449487 },
		["RIGHT"] = { true, true, 450929 },
		["LEFT"] = { false, false, 449490 }
	}

	for position, data in pairs(examples) do
		SpellActivationOverlay_ShowOverlay(_G.SpellActivationOverlayFrame, 123986, data[3], position, 1, 255, 255, 255, data[1], data[2])

	end

	E:Delay(2,function()
		if _previewID == self.previewID then
			_G.SpellActivationOverlay_HideAllOverlays(_G.SpellActivationOverlayFrame)
		end
	end)
end

function module:Initialize()
	if not E.db.mui.misc.spellAlert.enable then
		return
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function module:ProfileUpdate()
	self:Update()
end

MER:RegisterModule(module:GetName())

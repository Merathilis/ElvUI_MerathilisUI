local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_SpellAlert")

local _G = _G
local pairs = pairs
local tonumber = tonumber

local C_CVar_GetCVar = C_CVar.GetCVar
local Enum_ScreenLocationType = Enum.ScreenLocationType

function module:Update()
	if not self.db then
		return
	end

	local scale = self.db.enable and self.db.scale or 1
	_G.SpellActivationOverlayFrame:SetScale(scale)

	local opacityCVar = C_CVar_GetCVar("spellActivationOverlayOpacity")
	local opacity = opacityCVar and tonumber(opacityCVar)
	if opacity then
		_G.SpellActivationOverlayFrame:SetAlpha(opacity)
	end
end

---@type table<Enum.ScreenLocationType, {spellID: number, textureID: number}>
local previewData = {
	[Enum_ScreenLocationType.Top] = { spellID = 123986, textureID = 449488 },
	[Enum_ScreenLocationType.Bottom] = { spellID = 123986, textureID = 449487 },
	[Enum_ScreenLocationType.Left] = { spellID = 123986, textureID = 450929 },
	[Enum_ScreenLocationType.LeftOutside] = { spellID = 123986, textureID = 449490 },
	[Enum_ScreenLocationType.Right] = { spellID = 123986, textureID = 449490 },
	[Enum_ScreenLocationType.RightOutside] = { spellID = 123986, textureID = 450929 },
}

function module:Preview()
	for position, data in pairs(previewData) do
		_G.SpellActivationOverlayFrame:ShowOverlay(data.spellID, data.textureID, position, 1, 255, 255, 255)
	end

	self.previewID = (self.previewID or 0) + 1
	local previewID = self.previewID
	E:Delay(3, function()
		if previewID == self.previewID then
			_G.SpellActivationOverlayFrame:HideAllOverlays()
		end
	end)
end

function module:Initialize()
	self.db = E.db.mui.misc.spellActivationAlert

	if not self.db.enable then
		return
	end

	F.TaskManager:AfterLogin(self.Update, self)
end

module.ProfileUpdate = module.Update

MER:RegisterModule(module:GetName())

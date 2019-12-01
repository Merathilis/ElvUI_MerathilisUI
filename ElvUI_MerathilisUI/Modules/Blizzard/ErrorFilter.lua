local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIErrors")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local INTERRUPTED = INTERRUPTED
local SPELL_FAILED_INTERRUPTED = SPELL_FAILED_INTERRUPTED
local SPELL_FAILED_INTERRUPTED_COMBAT = SPELL_FAILED_INTERRUPTED_COMBAT
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local UIErrorsFrame =_G["UIErrorsFrame"]
local mUI_ErrorsFrame = CreateFrame("Frame", nil)
local ERR_FILTERS = {}

local function ErrorFrameHandler(self, event, msgType, msg)
	if(event == "PLAYER_REGEN_DISABLED") then
		self:UnregisterEvent("UI_ERROR_MESSAGE")
	elseif(event == "PLAYER_REGEN_ENABLED") then
		self:RegisterEvent("UI_ERROR_MESSAGE")
	elseif(msg and (not ERR_FILTERS[msg])) then
		UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0)
	end
end

local function CacheFilters()
	for k, v in pairs(E.db.mui.errorFilters) do
		ERR_FILTERS[k] = v
	end

	if(ERR_FILTERS[INTERRUPTED]) then
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED] = true
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED_COMBAT] = true
	end
end

function module:UpdateErrorFilters()
	if(E.db.mui.general.filterErrors) then
		CacheFilters()
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		mUI_ErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		if(E.db.mui.general.hideErrorFrame) then
			mUI_ErrorsFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			mUI_ErrorsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		mUI_ErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		mUI_ErrorsFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		mUI_ErrorsFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function module:Initialize()
	if(E.db.mui.general.filterErrors) then
		CacheFilters()
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		mUI_ErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		if(E.db.mui.general.hideErrorFrame) then
			mUI_ErrorsFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			mUI_ErrorsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		mUI_ErrorsFrame:SetScript("OnEvent", ErrorFrameHandler)
	end
end

MER:RegisterModule(module:GetName())

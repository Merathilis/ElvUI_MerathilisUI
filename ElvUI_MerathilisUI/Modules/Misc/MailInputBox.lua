local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule('MER_Misc')

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- EditBox width: default: 224
local editbox_width = 220

-- Money display position, default: {"RIGHT", "SendMailFrame", "RIGHT", -74, -94,}
local moneyframe_pos = {
	"RIGHT",
	"SendMailFrame",
	"RIGHT",
	-74,
	-94,
}

local function MailInputBox()
	local c = _G["SendMailCostMoneyFrame"]
	c:ClearAllPoints()
	c:SetPoint(unpack(moneyframe_pos))
end

function MI:LoadMailInputBox()
	if IsAddOnLoaded("MailinputboxResizer") or E.db.mui.misc.MailInputbox ~= true then return; end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_ENTERING_WORLD" then
			MailInputBox()
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

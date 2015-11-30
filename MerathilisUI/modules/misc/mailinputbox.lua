local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')

-- Cache global variables
local _G = _G
local unpack = unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- Credits Tonyleila (Mail Inputbox Reziser)
if IsAddOnLoaded("MailinputboxResizer") then return end

-- EditBox width: default: 224
local editbox_width = 218

-- Money display position, default: {"RIGHT", "SendMailFrame", "RIGHT", -74, -94,}
local moneyframe_pos = {
	"RIGHT",
	"SendMailFrame",
	"RIGHT",
	-74,
	-94,
}

local function MailInputBox()
	if not E.db.muiMisc.MailInputbox then return end
	
	local c = SendMailCostMoneyFrame
	c:ClearAllPoints()
	c:SetPoint(unpack(moneyframe_pos))
	local f = "SendMailNameEditBox" 
	_G[f]:SetSize(editbox_width or 224, 20)
	local r = _G[f.."Right"]
	r:ClearAllPoints()
	r:SetPoint("TOPRIGHT", 0, 0)
	local m = _G[f.."Middle"]
	m:SetSize(0, 20)
	m:ClearAllPoints()
	m:SetPoint("LEFT" ,f.. "Left", "LEFT", 8, 0)
	m:SetPoint("RIGHT", r, "RIGHT", -8, 0)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent",function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		MailInputBox()
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

local MER, E, L, V, P, G = unpack(select(2, ...))
local MNP = MER:GetModule('mUINamePlates')
local NP = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
local _G = _G
local strjoin = strjoin
--WoW API / Variables
local UnitChannelInfo = UnitChannelInfo
local UnitClass = UnitClass
local UnitCastingInfo = UnitCastingInfo
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MNP:CastbarPostCastStart(unit)
	self:CheckInterrupt(unit)
	NP:StyleFilterUpdate(self.__owner, "FAKE_Casting")

	local name, _, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo(unit)
	if(not name) then
		name, _, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo(unit)
	end
	local _, class = UnitClass (unit .. "target")
	if class then
		local colors = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class]) or _G.RAID_CLASS_COLORS[class]
		class = colors and colors.colorStr
		local targetName = UnitName (unit .. "target")
		targetName = (class and strjoin("", "|c", class, targetName)) or targetName
		self.Text:SetText(name .. " > " .. targetName)
	end
end

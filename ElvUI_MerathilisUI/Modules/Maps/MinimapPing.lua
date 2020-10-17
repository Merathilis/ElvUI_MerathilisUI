local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Minimap')
local LSM = E.LSM

local _G = _G
local max = max
local select = select

local UnitClass = UnitClass
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown

local C_Timer_After = C_Timer.After

local hideTimes = 0
function module:TryFadeOut()
	if hideTimes == 1 then
		if self.db.fadeOutTime == 0 then
			self.text:Hide()
		else
			E:UIFrameFadeOut(self.text, self.db.fadeOutTime, 1, 0)
		end
	end
	hideTimes = max(hideTimes - 1, 0)
end

function module:MINIMAP_PING(_, unit)
	if self.db and self.db.onlyInCombat and not InCombatLockdown() then
		return
	end

	local englishClass = select(2, UnitClass(unit))
	local name, realm = UnitName(unit)

	if realm and self.db.addRealm and realm ~= E.myrealm then
		name = name .. " - " .. realm
	end

	if self.db.classColor then
		name = MER:CreateClassColorString(name, englishClass)
	else
		name = MER:CreateColorString(name, self.db.customColor)
	end

	self.text:SetText(name)
	if self.db.fadeInTime == 0 then
		self.text:Show()
	else
		E:UIFrameFadeIn(self.text, self.db.fadeInTime, 0, 1)
	end
	hideTimes = hideTimes + 1

	C_Timer_After(self.db.stayTime, function()
		module:TryFadeOut()
	end)
end

function module:UpdateText()
	if not self.text then
		local text = _G.Minimap:CreateFontString(nil, "OVERLAY")
		self.text = text
	end

	self.text:FontTemplate(LSM:Fetch("font", self.db.font.name), self.db.font.size, self.db.font.style)
	self.text:ClearAllPoints()
	self.text:Point("CENTER", _G.Minimap, "CENTER", self.db.xOffset, self.db.yOffset)
end

function module:UpdatePing()
	self.db = E.db.mui.maps.minimap.ping

	if self.db and self.db.enable then
		self:UpdateText()
		if not self.Initialized then
			self:RegisterEvent("MINIMAP_PING")
			self.Initialized = true
		end
	else
		if self.Initialized then
			self:UnregisterEvent("MINIMAP_PING")
			self.Initialized = false
		end
	end
end

function module:MinimapPing()
	self.db = E.db.mui.maps.minimap.ping
	if not self.db or not self.db.enable then
		return
	end

	self:UpdateText()
	self:RegisterEvent("MINIMAP_PING")
end

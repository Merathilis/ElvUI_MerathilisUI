local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MiniMapPing")
local C = MER.Utilities.Color

local _G = _G
local max = max
local select = select

local UnitClass = UnitClass
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown

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

do
	local temp = {}
	function module:MINIMAP_PING(_, unit, x, y)
		if self.db and self.db.onlyInCombat and not InCombatLockdown() then
			return
		end

		local time = time()
		if temp then
			if temp.unit == unit and temp.x == x and temp.y == y then
				if time < 3 + temp.time then
					return
				end
			end
		end

		temp = {
			unit = unit,
			x = x,
			y = y,
			time = time,
		}

		local englishClass = select(2, UnitClass(unit))
		local name, realm = UnitName(unit)

		if realm and self.db.addRealm and realm ~= E.myrealm then
			name = name .. " - " .. realm
		end

		if self.db.classColor then
			name = C.StringWithClassColor(name, englishClass)
		else
			name = C.StringWithRGB(name, self.db.customColor)
		end

		self.text:SetText(name)
		if self.db.fadeInTime == 0 then
			self.text:Show()
		else
			E:UIFrameFadeIn(self.text, self.db.fadeInTime, 0, 1)
		end
		hideTimes = hideTimes + 1

		E:Delay(module.db.stayTime, module.TryFadeOut, module)
	end
end

function module:UpdateText()
	if not self.text then
		local text = _G.Minimap:CreateFontString(nil, "OVERLAY")
		self.text = text
	end

	F.SetFontWithDB(self.text, self.db.font)
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

function module:Initialize()
	self.db = E.db.mui.maps.minimap.ping

	if not self.db or not self.db.enable then
		return
	end

	self:UpdateText()
	self:RegisterEvent("MINIMAP_PING")
	self.initialized = true
end

function module:ProfileUpdate()
	self.db = E.db.mui.maps.minimap.ping

	if self.db and self.db.enable then
		self:UpdateText()
		if not self.initialized then
			self:RegisterEvent("MINIMAP_PING")
			self.initialized = true
		end
	else
		if self.initialized then
			self:UnregisterEvent("MINIMAP_PING")
			self.initialized = false
		end
	end
end

MER:RegisterModule(module:GetName())

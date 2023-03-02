local oUF = ElvUF or oUF
local UnitIsDead, UnitIsGhost = UnitIsDead, UnitIsGhost

-- Credits: Darth Predator - ElvUI_Shadow & Light

local function Update(self)
	local element = self.DeathIndicator
	local unit = self.unit
	local isDead = UnitIsDead(unit) or UnitIsGhost(unit)

	if element.PreUpdate then
		element:PreUpdate()
	end

	if (self.isForced or UnitIsConnected(self.unit)) and isDead then
		element:Show()
	else
		element:Hide()
	end
end

local function Path(self, ...)
	return (self.DeathIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.DeathIndicator

	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.ForceUpdate(element)

		self:RegisterEvent('UNIT_FLAGS', Path)
		self:RegisterEvent('PLAYER_FLAGS_CHANGED', Path)
		self:RegisterEvent('PLAYER_ALIVE', Path, true)
		self:RegisterEvent('PLAYER_DEAD', Path, true)
		self:RegisterEvent('PLAYER_UNGHOST', Path, true)
		self:RegisterEvent('UNIT_CONNECTION', Path)

		if element:IsObjectType('Texture') and not element:GetTexture() then
			element:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.DeathIndicator
	if element then
		element:Hide()

		self:UnregisterEvent('UNIT_FLAGS', Path)
		self:UnregisterEvent('PLAYER_FLAGS_CHANGED', Path)
		self:UnregisterEvent('PLAYER_ALIVE', Path)
		self:UnregisterEvent('PLAYER_DEAD', Path)
		self:UnregisterEvent('PLAYER_UNGHOST', Path)
		self:UnregisterEvent('UNIT_CONNECTION', Path)
	end
end

oUF:AddElement('DeathIndicator', Path, Enable, Disable)

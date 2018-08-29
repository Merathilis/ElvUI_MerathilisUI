local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function UpdateAuraIconSettings(self, auras, noCycle)
	local frame = auras:GetParent()
	local type = auras.type
	if(noCycle) then
		frame = auras:GetParent():GetParent()
		type = auras:GetParent().type
	end
	if(not frame.db) then return end

	local db = frame.db[type]
	local index = 1
	if(db) then
		local config = E.db.mui.unitframes.AuraIconText
		if(not noCycle) then
			while(auras[index]) do
				local button = auras[index]
				button.text:ClearAllPoints()
				button.text:Point(config.durationTextPos, config.durationTextOffsetX, config.durationTextOffsetY)
				button.count:ClearAllPoints()
				button.count:Point(config.stackTextPos, config.stackTextOffsetX, config.stackTextOffsetY)

				if not button.helper then
					local helper = CreateFrame("Frame", nil, button)
					button.helper = helper
					button.helper:SetInside()
					button.helper:SetFrameStrata(button.cd.GetFrameStrata and button.cd:GetFrameStrata() or "HIGH")
					button.helper:SetFrameLevel(button.cd.GetFrameLevel and (button.cd:GetFrameLevel() + 2) or 20)
					button.count:SetParent(button.helper)
				end

				index = index + 1
			end
		else
			auras.text:ClearAllPoints()
			auras.text:Point(config.durationTextPos, config.durationTextOffsetX, config.durationTextOffsetY)
			auras.count:ClearAllPoints()
			auras.count:Point(config.stackTextPos, config.stackTextOffsetX, config.stackTextOffsetY)

			if not auras.helper then
				local helper = CreateFrame("Frame", nil, auras)
				auras.helper = helper
				auras.helper:SetInside()
				auras.helper:SetFrameStrata(auras.cd.GetFrameStrata and auras.cd:GetFrameStrata() or "HIGH")
				auras.helper:SetFrameLevel(auras.cd.GetFrameLevel and (auras.cd:GetFrameLevel() + 2) or 20)
				auras.count:SetParent(auras.helper)
			end
		end
	end
end
hooksecurefunc(UF, "UpdateAuraIconSettings", UpdateAuraIconSettings)

local function UpdateAuraTimer(self, elapsed)
	local hideDurationText = E.db.mui.unitframes.AuraIconText.hideDurationText
	local hideStackText = E.db.mui.unitframes.AuraIconText.hideStackText
	local durationThreshold = E.db.mui.unitframes.AuraIconText.durationThreshold
	local durationFilterOwner = E.db.mui.unitframes.AuraIconText.durationFilterOwner
	local stackFilterOwner = E.db.mui.unitframes.AuraIconText.stackFilterOwner
	local showText = true
	local showCount = true

	if ((durationThreshold > 0) and (self.expiration > durationThreshold)) or (durationFilterOwner and (self.owner ~= "player" and self.owner ~= "vehicle")) or (hideDurationText) then
		showText = false
	end

	if (stackFilterOwner and (self.owner ~= "player" and self.owner ~= "vehicle")) or (hideStackText) then
		showCount = false
	end

	self.text:SetAlpha(showText and 1 or 0)
	self.count:SetAlpha(showCount and 1 or 0)
end
hooksecurefunc(UF, "UpdateAuraTimer", UpdateAuraTimer)

local function SetOnUpdate(button)
	if button:GetScript('OnUpdate') and not button.isUpdatedCT then
		button.nextupdate = -1
		button:SetScript('OnUpdate', UF.UpdateAuraTimer)
		button.isUpdatedCT = true
	end
end

local function ResetOnUpdate(unitframe)
	if not unitframe.Buffs and not unitframe.Debuffs then return; end

	if unitframe.Buffs then
		for i = 1, #unitframe.Buffs do
			local button = unitframe.Buffs[i]
			if(button and button:IsShown()) then
				SetOnUpdate(button)
			end
		end
	end

	if unitframe.Debuffs then
		for i = 1, #unitframe.Debuffs do
			local button = unitframe.Debuffs[i]
			if(button and button:IsShown()) then
				SetOnUpdate(button)
			end
		end
	end
end

--Existing auras with a duration have their OnUpdate set before "UpdateAuraTimer" is hooked
--Duration or stack text will not be hidden for those aura buttons
--Look through all auras on all unitframes and update OnUpdate script if necessary
local function UpdateExistingAuras()
	for unit, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			ResetOnUpdate(unitframe)
		end
	end

	for unit, unitgroup in pairs(UF.groupunits) do
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			ResetOnUpdate(unitframe)
		end
	end

	for _, header in pairs(UF.headers) do
		local name = header.groupName
		local db = UF.db['units'][name]
		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			--group is Tank/Assist Frames, but for Party/Raid we need to go deeper
			ResetOnUpdate(group)

			for j = 1, group:GetNumChildren() do
				--Party/Raid unitbutton
				local unitbutton = select(j, group:GetChildren())
				ResetOnUpdate(unitbutton)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	UpdateExistingAuras()
end)

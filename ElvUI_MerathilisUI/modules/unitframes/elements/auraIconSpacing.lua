local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

--Set spacing between individual aura icons and update PostUpdateIcon
local function SetAuraSpacingAndUpdate(unitframe, unitName, auraSpacing)
	if not unitframe.Buffs and not unitframe.Debuffs then return; end

	if unitframe.Buffs then
		unitframe.Buffs.spacing = auraSpacing
		--Update internal aura settings
		if unitframe.db then
			UF:Configure_Auras(unitframe, "Buffs")
		end
	end
	if unitframe.Debuffs then
		unitframe.Debuffs.spacing = auraSpacing
		if unitframe.db then
			UF:Configure_Auras(unitframe, "Debuffs")
		end
	end

	--Refresh aura display
	if unitframe.IsElementEnabled and unitframe:IsElementEnabled("Aura") then
		unitframe:UpdateElement("Aura")
	end
end

function MUF:UpdateAuraSettings()
	local auraSpacing = E.db.mui.unitframes.AuraIconSpacing.spacing or 1

	for unit, unitName in pairs(UF.units) do
		local spacing = E.db.mui.unitframes.AuraIconSpacing.units[unitName] and auraSpacing or E.Spacing
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			SetAuraSpacingAndUpdate(unitframe, unitName, spacing)
		end
	end

	for unit, unitgroup in pairs(UF.groupunits) do
		local spacing = E.db.mui.unitframes.AuraIconSpacing.units[unitgroup] and auraSpacing or E.Spacing
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			SetAuraSpacingAndUpdate(unitframe, unitgroup, spacing)
		end
	end

	for _, header in pairs(UF.headers) do
		local name = header.groupName
		local spacing = E.db.mui.unitframes.AuraIconSpacing.units[name] and auraSpacing or E.Spacing

		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			--group is Tank/Assist Frames, but for Party/Raid we need to go deeper
			SetAuraSpacingAndUpdate(group, name, spacing)

			for j = 1, group:GetNumChildren() do
				--Party/Raid unitbutton
				local unitbutton = select(j, group:GetChildren())
				SetAuraSpacingAndUpdate(unitbutton, name, spacing)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	MUF:UpdateAuraSettings()
end)

local function SetAuraWidth(self, frame, auraType)
	local db = frame.db

	local auras = frame[auraType]
	auraType = auraType:lower()

	if db[auraType].sizeOverride and db[auraType].sizeOverride > 0 then
		auras:SetWidth(db[auraType].perrow * db[auraType].sizeOverride + ((db[auraType].perrow - 1) * auras.spacing))
	end
end
hooksecurefunc(UF, "Configure_Auras", SetAuraWidth)
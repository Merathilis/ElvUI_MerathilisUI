local E, L, V, P, G, _ = unpack(ElvUI);
local UFM = E:NewModule('MuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');

function UFM:CreateBar(frame)
	if not frame then return end
	if frame.emptyBar then return end

	frame.emptyBar = CreateFrame('Frame', frame:GetName()..'EmptyBar', frame)
	frame.emptyBar:SetTemplate('Transparent')
	frame.emptyBar:SetFrameStrata('BACKGROUND')
end

local DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = 1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = -1,
	RIGHT_DOWN = 1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = -1,
}

local DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = -1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = 1,
	RIGHT_DOWN = -1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = 1,
}

local DIRECTION_TO_POINT = {
	DOWN_RIGHT = "TOP",
	DOWN_LEFT = "TOP",
	UP_RIGHT = "BOTTOM",
	UP_LEFT = "BOTTOM",
	RIGHT_DOWN = "LEFT",
	RIGHT_UP = "LEFT",
	LEFT_DOWN = "RIGHT",
	LEFT_UP = "RIGHT",
	UP = "BOTTOM",
	DOWN = "TOP"
}

local DIRECTION_TO_COLUMN_ANCHOR_POINT = {
	DOWN_RIGHT = "LEFT",
	DOWN_LEFT = "RIGHT",
	UP_RIGHT = "LEFT",
	UP_LEFT = "RIGHT",
	RIGHT_DOWN = "TOP",
	RIGHT_UP = "BOTTOM",
	LEFT_DOWN = "TOP",
	LEFT_UP = "BOTTOM",
}

local DIRECTION_TO_GROUP_ANCHOR_POINT = {
	DOWN_RIGHT = "TOPLEFT",
	DOWN_LEFT = "TOPRIGHT",
	UP_RIGHT = "BOTTOMLEFT",
	UP_LEFT = "BOTTOMRIGHT",
	RIGHT_DOWN = "TOPLEFT",
	RIGHT_UP = "BOTTOMLEFT",
	LEFT_DOWN = "TOPRIGHT",
	LEFT_UP = "BOTTOMRIGHT",
	OUT_RIGHT_UP = "BOTTOM",
	OUT_LEFT_UP = "BOTTOM",
	OUT_RIGHT_DOWN = "TOP",
	OUT_LEFT_DOWN = "TOP",
	OUT_UP_RIGHT = "LEFT",
	OUT_UP_LEFT = "RIGHT",
	OUT_DOWN_RIGHT = "LEFT",
	OUT_DOWN_LEFT = "RIGHT",
}

function UFM:Configure_Groups()
	local db = UF.db.units[self.groupName]

	local point
	local width, height, newCols, newRows = 0, 0, 0, 0
	local direction = db.growthDirection
	local xMult, yMult = DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[direction], DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[direction]
	local SPACING = E.Spacing

	local numGroups = self.numGroups

	for i=1, numGroups do
		local group = self.groups[i]

		point = DIRECTION_TO_POINT[direction]

		if group then
			UF:ConvertGroupDB(group)
			if point == "LEFT" or point == "RIGHT" then
				group:SetAttribute("xOffset", (db.horizontalSpacing + SPACING) * DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[direction])
				group:SetAttribute("yOffset", 0)
				group:SetAttribute("columnSpacing", db.verticalSpacing + E.db.muiUnitframes.EmptyBar.groupHeight)
			else
				group:SetAttribute("xOffset", 0)
				group:SetAttribute("yOffset", (db.verticalSpacing + E.db.muiUnitframes.EmptyBar.groupHeight + SPACING) * DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[direction])
				group:SetAttribute("columnSpacing", db.horizontalSpacing)
			end

			if not group.isForced then
				if not group.initialized then
					group:SetAttribute("startingIndex", db.raidWideSorting and (-min(numGroups * (db.groupsPerRowCol * 5), MAX_RAID_MEMBERS) + 1) or -4)
					group:Show()
					group.initialized = true
				end
				group:SetAttribute('startingIndex', 1)
			end

			group:ClearAllPoints()

			if db.raidWideSorting and db.invertGroupingOrder then
				group:SetAttribute("columnAnchorPoint", INVERTED_DIRECTION_TO_COLUMN_ANCHOR_POINT[direction])
			else
				group:SetAttribute("columnAnchorPoint", DIRECTION_TO_COLUMN_ANCHOR_POINT[direction])
			end

			group:ClearChildPoints()
			group:SetAttribute("point", point)

			if not group.isForced then
				group:SetAttribute("maxColumns", db.raidWideSorting and numGroups or 1)
				group:SetAttribute("unitsPerColumn", db.raidWideSorting and (db.groupsPerRowCol * 5) or 5)
				UF.headerGroupBy[db.groupBy](group)
				group:SetAttribute('sortDir', db.sortDir)
				group:SetAttribute("showPlayer", db.showPlayer)
			end

			if i == 1 and db.raidWideSorting then
				group:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
			else
				group:SetAttribute("groupFilter", tostring(i))
			end
		end

		point = DIRECTION_TO_GROUP_ANCHOR_POINT[direction]
		if db.raidWideSorting and db.startFromCenter then
			point = DIRECTION_TO_GROUP_ANCHOR_POINT["OUT_"..direction]
		end
		if (i - 1) % db.groupsPerRowCol == 0 then
			if DIRECTION_TO_POINT[direction] == "LEFT" or DIRECTION_TO_POINT[direction] == "RIGHT" then
				if group then
					group:SetPoint(point, self, point, 0, height * yMult)
				end
				height = height + (db.height + db.verticalSpacing + E.db.muiUnitframes.EmptyBar.groupHeight + SPACING)

				newRows = newRows + 1
			else
				if group then
					group:SetPoint(point, self, point, width * xMult, 0)
				end
				width = width + (db.width + db.horizontalSpacing + SPACING)

				newCols = newCols + 1
			end
		else
			if DIRECTION_TO_POINT[direction] == "LEFT" or DIRECTION_TO_POINT[direction] == "RIGHT" then
				if newRows == 1 then
					if group then
						group:SetPoint(point, self, point, (width + (SPACING * 5)) * xMult, 0)
					end
					width = width + ((db.width + db.horizontalSpacing + SPACING) * 5)
					newCols = newCols + 1
				elseif group then
					group:SetPoint(point, self, point, (((db.width + db.horizontalSpacing + SPACING) * 5) * ((i-1) % db.groupsPerRowCol)) * xMult, ((db.height + db.verticalSpacing + SPACING) * (newRows - 1)) * yMult)
				end
			else
				if newCols == 1 then
					if group then
						group:SetPoint(point, self, point, 0, (height + (SPACING*5)) * yMult)
					end
					height = height + ((db.height + db.verticalSpacing + E.db.muiUnitframes.EmptyBar.groupHeight + SPACING) * 5)
					newRows = newRows + 1
				elseif group then
					group:SetPoint(point, self, point, ((db.width + db.horizontalSpacing + SPACING) * (newCols - 1)) * xMult, (((db.height + db.verticalSpacing + SPACING) * 5) * ((i-1) % db.groupsPerRowCol)) * yMult)
				end
			end
		end

		if height == 0 then
			height = height + ((db.height + db.verticalSpacing + E.db.muiUnitframes.EmptyBar.groupHeight) * 5)
		elseif width == 0 then
			width = width + ((db.width + db.horizontalSpacing) * 5)
		end
	end

	if not self.isInstanceForced then
		self.dirtyWidth = width - db.horizontalSpacing
		self.dirtyHeight = height - db.verticalSpacing
	end

	if self.mover then
		self.mover.positionOverride = DIRECTION_TO_GROUP_ANCHOR_POINT[direction]
		E:UpdatePositionOverride(self.mover:GetName())
	end

	self:SetSize(width - db.horizontalSpacing, height - db.verticalSpacing)
end

function UFM:Initialize()
	if E.db.muiUnitframes.EmptyBar.enable then
		UF["raid"]["Configure_Groups"] = UFM.Configure_Groups
		hooksecurefunc(UF, 'Update_RaidFrames', UFM.UpdateRaidFrames)
	end
end

E:RegisterModule(UFM:GetName())

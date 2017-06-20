local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	local ot = ObjectiveTrackerFrame
	local BlocksFrame = ot.BlocksFrame

	-- Fix height
	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 5)
			block.shouldFix = true
		end
	end

	hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)

	local bg = ObjectiveTrackerBlocksFrame.QuestHeader:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)

	local bg = ObjectiveTrackerBlocksFrame.AchievementHeader:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)

	local bg = ObjectiveTrackerBlocksFrame.ScenarioHeader:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)

	local bg = BONUS_OBJECTIVE_TRACKER_MODULE.Header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)

	local bg = WORLD_QUEST_TRACKER_MODULE.Header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)

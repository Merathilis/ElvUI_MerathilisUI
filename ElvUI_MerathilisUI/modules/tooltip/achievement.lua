local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local find, sub = string.find, string.sub
local select = select
-- WoW API / Variables
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local IsAddOnLoaded = IsAddOnLoaded
local UnitGUID = UnitGUID

-- Credits: Enhanced Achievements by Syzgyn
if IsAddOnLoaded("Enhanced Achievements") then return; end

local colors = {
	["GREEN"] = {
		["r"] = 0.25,
		["g"] = 0.75,
		["b"] = 0.25,
	},
	["GRAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
	},
}

local function SetHyperlink(tooltip, refString)
	local achievementID, numCriteria, GUID, name, completed, quantity, reqQuantity, month, day, year
	local output = {[0] = {}, [1] = {}}
	
	--If its not an achievement link, I dont care.
	if select(3, find(refString, "(%a-):")) ~= "achievement" then return end
	
	achievementID = select(3, find(refString, ":(%d+):"))
	numCriteria = GetAchievementNumCriteria(achievementID)
	GUID = select(3, find(refString, ":%d+:(.-):"))
	
	-- If I linked the tooltip, I dont need to see the info twice.
	if GUID == sub(UnitGUID("player"), 3) then 
		tooltip:Show()
		return 
	end
	
	tooltip:AddLine(" ")
	local _, _, _, completed, month, day, year, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)
	
	-- If its completed, show the completion date
	if completed then
		if year < 10 then year = "0" .. year end
		
		tooltip:AddLine(L["Your Status: Completed on "] .. day .. "." .. month .. "." .. year, 0, 1, 0)
	-- If its not completed, show the individual criteria
	elseif numCriteria == 0 then
		tooltip:AddLine(L["Your Status: Incomplete"])
	else
		tooltip:AddLine(L["Your Status:"])
		for i=1, numCriteria, 2 do
			for a=0, 1 do
				output[a].text = nil
				output[a].color = nil
				if i+a <= numCriteria then
					name,_,completed,quantity,reqQuantity = GetAchievementCriteriaInfo(achievementID, i+a)
					if completed then
						output[a].text = name
						output[a].color = "GREEN"
					else
						if quantity < reqQuantity and reqQuantity > 1 then
							output[a].text = name .. " (" .. quantity .. "/" .. reqQuantity .. ")"
							output[a].color = "GRAY"
						else
							output[a].text = name
							output[a].color = "GRAY"
						end
					end
				else
					output[a].text = nil
				end
			end
			if output[1].text == nil then
				tooltip:AddLine(output[0].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b)
			else
				tooltip:AddDoubleLine(output[0].text, output[1].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b, colors[output[1].color].r, colors[output[1].color].g, colors[output[1].color].b)
			end
			output = {[0] = {}, [1] = {}}
		end
	end
	tooltip:Show()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if E.db.mui.misc.Tooltip ~= true then return; end
	if event == "PLAYER_ENTERING_WORLD" then
		hooksecurefunc(GameTooltip, "SetHyperlink", SetHyperlink)
		hooksecurefunc(ItemRefTooltip, "SetHyperlink", SetHyperlink)
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
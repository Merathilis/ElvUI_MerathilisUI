local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("MERDashBoard")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local join = string.join
-- WoW API / Variables
local GetNetStats = GetNetStats
local InCombatLockdown = InCombatLockdown
--GLOBALS:

local LastUpdate = 1
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909",
}

function module:CreateMs()
	local boardName = _G["MER_MS"]

	boardName:SetScript('OnEnter', function(self)
		if not InCombatLockdown() then
			local value = 0
			local text = ""
			_G.GameTooltip:SetOwner(boardName, 'ANCHOR_RIGHT', 5, 0)
			_G.GameTooltip:ClearLines()
			if E.db.mui.dashboard.system.latency == 2 then
				value = (select(3, GetNetStats())) -- Home
				text = "MS (".._G.HOME.."): "
			else
				value = (select(4, GetNetStats())) -- World
				text = "MS (".._G.WORLD.."): "
			end
			_G.GameTooltip:AddDoubleLine(text, value, 0.7, 0.7, 1, 0.84, 0.75, 0.65)
			_G.GameTooltip:Show()
		end
	end)

	boardName:SetScript('OnLeave', function(self)
		_G.GameTooltip:Hide()
	end)

	boardName.Status:SetScript('OnUpdate', function(self, elapsed)
		if LastUpdate > 0 then
			LastUpdate = LastUpdate - elapsed
			return
		end

		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local value = 0
			local displayFormat = ""

			if E.db.mui.dashboard.system.latency == 1 then
				value = (select(3, GetNetStats())) -- Home
			else
				value = (select(4, GetNetStats())) -- World
			end

			local max = 200
			local mscolor = 4

			self:SetValue(value)

			if(value * 100 / max <= 35) then
				mscolor = 1
			elseif value * 100 / max > 35 and value * 100 / max < 75 then
				mscolor = 2
			else
				mscolor = 3
			end

			if E.db.mui.dashboard.system.latency == 1 then
				displayFormat = join('', 'MS (', _G.HOME, '): ', statusColors[mscolor], '%d|r')
			else
				displayFormat = join('', 'MS (', _G.WORLD, '): ', statusColors[mscolor], '%d|r')
			end

			boardName.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end

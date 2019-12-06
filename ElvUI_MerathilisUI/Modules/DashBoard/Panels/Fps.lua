local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("MERDashBoard")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local format, join = string.format, string.join
local floor = math.floor
local twipe, sort = table.wipe, table.sort
local collectgarbage = collectgarbage
-- WoW API / Variables
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetFramerate = GetFramerate
local GetNumAddOns = GetNumAddOns
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
--GLOBALS:

local kiloByteString = "|cfff6a01a %d|r".." kb"
local megaByteString = "|cfff6a01a %.2f|r".." mb"

local totalMemory = 0
local LastUpdate = 1

local statusColors = {
	"|cff0CD809",	-- green
	"|cffE8DA0F",	-- yellow
	"|cffFF9000",	-- orange
	"|cffD80909",	-- red
}

local function formatMem(memory)
	local mem
	local mult = 10^1
	if( memory > 999 ) then
		mem = ((memory / 1024) * mult) / mult
		return format(megaByteString, mem)
	else
		mem = (memory * mult) / mult
		return format(kiloByteString, mem)
	end
end

local function sortByMemory(a, b)
	if a and b then
		return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
	end
end

local memoryTable = {}

local function RebuildAddonList()
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	twipe(memoryTable)

	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	totalMemory = 0
	for i = 1, #memoryTable do
		memoryTable[i][3] = GetAddOnMemoryUsage(memoryTable[i][1])
		totalMemory = totalMemory + memoryTable[i][3]
	end
	-- Sort the table to put the largest addon on top
	sort(memoryTable, sortByMemory)
end

function module:CreateFps()
	local boardName = _G["MER_FPS"]

	boardName.Status:SetScript('OnUpdate', function(self, elapsed)
		LastUpdate = LastUpdate - elapsed

		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local framerate = floor(GetFramerate())
			self:SetValue(framerate)

			boardName.Text:SetFormattedText("FPS: %s%d|r", statusColors[framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4], framerate)
			LastUpdate = 1
		end
	end)
end

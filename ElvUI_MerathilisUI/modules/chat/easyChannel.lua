local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

-- Cache global variables
-- Lua functions
local ipairs, select, tostring = ipairs, select, tostring
local strsub = string.sub
-- WoW API / Variable
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsShiftKeyDown = IsShiftKeyDown
-- GLOBALS: ChatEdit_UpdateHeader

local cycles = {
	{
		chatType = "SAY",
		use = function(self, editbox) return 1 end,
	},
	{
		chatType = "PARTY",
		use = function(self, editbox) return IsInGroup() end,
	},
	{
		chatType = "RAID",
		use = function(self, editbox) return IsInRaid() end,
	},
	{
		chatType = "INSTANCE_CHAT",
		use = function(self, editbox) return select(2, IsInInstance()) == "pvp" end,
	},
	{
		chatType = "GUILD",
		use = function(self, editbox) return IsInGuild() end,
	},
}

function MERC:ChatEdit_CustomTabPressed(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local currChatType = self:GetAttribute("chatType")
	for i, curr in ipairs(cycles) do
		if curr.chatType == currChatType then
			local h, r, step = i+1, #cycles, 1
			if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
			if currChatType=="CHANNEL" then h = i end
			for j = h, r, step do
				if cycles[j]:use(self, currChatType) then
					self:SetAttribute("chatType", cycles[j].chatType)
					ChatEdit_UpdateHeader(self)
					return
				end
			end
		end
	end
end

function MERC:EasyChannel()
	self:RawHook("ChatEdit_CustomTabPressed", true)
end
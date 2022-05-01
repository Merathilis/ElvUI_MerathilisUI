local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Tooltip')
local TT = E:GetModule('Tooltip')

local _G = _G
local next = next
local xpcall = xpcall
local tinsert = table.insert

module.load = {}
module.updateProfile = {}

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallback(name, func)
	tinsert(self.load, func or self[name])
end

--[[
	@param {string} name
	@param {function} [func=module.name]
]]
function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--[[
	@param {string} err
]]
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

------

function module:Initialize()
	if E.private.tooltip.enable ~= true then return end

	self.db = E.db.mui.tooltip
	MER:RegisterDB(self, "tooltip")

	for index, func in next, self.load do
		xpcall(func, errorhandler)
		self.load[index] = nil
	end

	module:ReskinTooltipIcons()
end

function module:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, errorhandler, self)
		self.updateProfile[index] = nil
	end
end

MER:RegisterModule(module:GetName())

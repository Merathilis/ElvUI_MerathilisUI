local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")

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

function module:Initialize()
	self.db = E.db.mui.tooltip

	for index, func in next, self.load do
		xpcall(func, WF.Developer.ThrowError, self)
		self.load[index] = nil
	end

	self.initialized = true
end

function module:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, WF.Developer.ThrowError, self)
		self.updateProfile[index] = nil
	end
end

MER:RegisterModule(module:GetName())

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

F.Developer = {}

local _G = _G
local format, pairs, print, type = format, pairs, print, type
local strjoin, strlen, strlower, strrep = strjoin, strlen, strlower, strrep
local tostring = tostring

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

MER.IsDev = {
	["Asragoth"] = true,
	["Anonia"] = true,
	["Damará"] = true,
	["Damara"] = true, -- MOP Remix
	["Jazira"] = true,
	["Jústice"] = true,
	["Maithilis"] = true,
	["Mattdemôn"] = true,
	["Melisendra"] = true,
	["Merathilis"] = true,
	["Mérathilis"] = true,
	["Merathilîs"] = true,
	["Róhal"] = true,
	["Ronan"] = true,
	["Brítt"] = true,
	["Brìtt"] = true,
	["Jahzzy"] = true,
	["Dâmara"] = true,
	["Meravoker"] = true,

	-- Beta
	["Jalenna"] = true,
}

-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	-- Live
	["Shattrath"] = true,
	["Garrosh"] = true,

	-- Beta
	["Turnips Delight"] = true,

	-- PTR
	["Broxigar"] = true,
}

function F.IsDeveloper()
	return MER.IsDev[E.myname] and MER.IsDevRealm[E.myrealm] or false
end

--[[
	Print pretty
	-- modified from https://www.cnblogs.com/leezj/p/4230271.html
	@param {Any} Any Object
]]
function F.Developer.Print(object)
	if type(object) == "table" then
		local cache = {}
		local function printLoop(subject, indent)
			if cache[tostring(subject)] then
				print(indent .. "*" .. tostring(subject))
			else
				cache[tostring(subject)] = true
				if type(subject) == "table" then
					for pos, val in pairs(subject) do
						if type(val) == "table" then
							print(indent .. "[" .. pos .. "] => " .. tostring(subject) .. " {")
							printLoop(val, indent .. strrep(" ", strlen(pos) + 8))
							print(indent .. strrep(" ", strlen(pos) + 6) .. "}")
						elseif type(val) == "string" then
							print(indent .. "[" .. pos .. '] => "' .. val .. '"')
						else
							print(indent .. "[" .. pos .. "] => " .. tostring(val))
						end
					end
				else
					print(indent .. tostring(subject))
				end
			end
		end
		if type(object) == "table" then
			print(tostring(object) .. " {")
			printLoop(object, "  ")
			print("}")
		else
			printLoop(object, "  ")
		end
		print()
	elseif type(object) == "string" then
		print('(string) "' .. object .. '"')
	else
		print("(" .. type(object) .. ") " .. tostring(object))
	end
end

--[[
	Custom Error Handler
	@param ...string Error Message
]]
function F.Developer.ThrowError(...)
	local message = strjoin(" ", ...)
	_G.geterrorhandler()(format("%s |cffff2457[ERROR]|r\n%s", MER.Title, message))
end

--[[
	Custom Logger [WARNING]
	@param ...string Message
]]
function F.Developer.LogWarning(...)
	if E.global.mui.developer.logLevel < 2 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cfffdc600[WARNING]|r %s", MER.Title, message))
end

--[[
	Custom Logger [INFO]
	@param ...string Message
]]
function F.Developer.LogInfo(...)
	if E.global.mui.developer.logLevel < 3 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff00a4f3[INFO]|r %s", MER.Title, message))
end

--[[
	Custom Logger [DEBUG]
	@param ...string Message
]]
function F.Developer.LogDebug(...)
	if E.global.mui.developer.logLevel < 4 then
		return
	end

	local message = strjoin(" ", ...)
	print(format("%s |cff00d3bc[DEBUG]|r %s", MER.Title, message))
end

do
	local messages = {}
	function F.Developer.PrintDelayedMessages()
		for _, msg in ipairs(messages) do
			F.Developer.Print(msg)
		end

		messages = {}
	end

	function F.Developer.AddDelayedMessage(str)
		tinsert(messages, str)
	end
end

--[[
	Custom Logger Injection
	@param table Module | string Module Name
]]
function F.Developer.InjectLogger(module)
	if type(module) == "string" then
		module = MER:GetModule(module)
	end

	if not module or type(module) ~= "table" then
		F.Developer.ThrowError("Module logger injection: Invalid module.")
		return
	end

	if not module.Log then
		module.Log = function(self, level, message)
			if not level or type(level) ~= "string" then
				F.Developer.ThrowError("Invalid log level.")
				return
			end

			if not message or type(message) ~= "string" then
				F.Developer.ThrowError("Invalid log message.")
				return
			end

			level = strlower(level)

			local richMessage = format("%s %s", MER.Utilities.Color.StringByTemplate(self.name, "amber-500"), message)
			if level == "info" then
				F.Developer.LogInfo(richMessage)
			elseif level == "warning" then
				F.Developer.LogWarning(richMessage)
			elseif level == "debug" then
				F.Developer.LogDebug(richMessage)
			else
				F.Developer.ThrowError("Logger level should be info, warning or debug.")
			end
		end
	end
end

--[[
	Set delay for module initialization
	@param table module
	@param number delay
]]
function F.Developer.DelayInit(module, delay)
	delay = delay or 2
	if module.Initialize then
		module.Initialize_ = module.Initialize
		module.Initialize = function(self, ...)
			E:Delay(delay, self.Initialize_, self, ...)
		end
	end
end

--[[
	Inspect object with https://github.com/brittyazel/DevTool
	@param any obj
	@param string name
]]
function F.Developer.DT(obj, name)
	if _G.DevTool and _G.DevTool.AddData then
		_G.DevTool:AddData(obj, name)
	end
end

function F.Developer.Log(var, varName)
	if MER.IsDevelop and IsAddOnLoaded("DevTool") then
		local DevTool = _G["DevTool"]
		DevTool:AddData(var, varName)
	end
end

---Inspect object with DevTool addon
---https://github.com/brittyazel/DevTool
---@param obj any Object to inspect
---@param name string? Name for the object (optional)
function F.Developer.DevTool(obj, name)
	if _G.DevTool and _G.DevTool.AddData then
		_G.DevTool:AddData(obj, name)
	end
end

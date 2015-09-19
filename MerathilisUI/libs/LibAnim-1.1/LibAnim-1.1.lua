local LibAnim = {}
LibAnim.Types = {}
LibAnim.Callbacks = {}
LibAnim.GroupCallbacks = {}
LibAnim.Smoothing = {
	["none"] = function(t, b, c, d)
		return c * t / d + b
	end,
	
	["in"] = function(t, b, c, d)
		t = t / d
		
		return c * t * t + b
	end,
	
	["out"] = function(t, b, c, d)
		t = t / d
		
		return -c * t * (t - 2) + b
	end,
	
	["inout"] = function(t, b, c, d)
		t = t / (d / 2)
		
		if (t < 1) then
			return c / 2 * t * t + b
		end
		
		t = t - 1
		return -c / 2 * (t * (t - 2) - 1) + b
	end,
}

function LibAnim:NewType(animtype, func)
	if self.Types[animtype] then
		return
	end
	
	self.Types[animtype] = func
	self.Callbacks[animtype] = {}
end

local Run = function(object, animtype, ...)
	if (not LibAnim.Types[animtype]) then
		return
	end
	
	LibAnim.Types[animtype](object, ...)
end

local OnFinished = function(object, animtype, func)
	if (not LibAnim.Callbacks[animtype] or LibAnim.Callbacks[animtype][object]) then
		return
	end
	
	LibAnim.Callbacks[animtype][object] = func
end

function LibAnim:Callback(object, animtype, ...)
	if (not self.Callbacks[animtype][object]) then
		return
	end
	
	self.Callbacks[animtype][object](object, ...)
end

function LibAnim:GroupCallback(object)
	if (not object._Group) then
		return
	end
	
	object._Group.LastIndex = object._Group.LastIndex + 1
	
	if (object._Group.LastIndex > #object._Group.Queue) then
		object._Group.LastIndex = 1 -- Reset the order
		object._Group.TimesRun = object._Group.TimesRun + 1 -- The whole group finished, add a tick
		
		if (not object._Group.Looping or (object._Group.NumLoops and object._Group.TimesRun >= object._Group.NumLoops) or object._Group.Finish) then
			object._Group.TimesRun = 0
			
			return
		end
	end
	
	object:Run(unpack(object._Group.Queue[object._Group.LastIndex]))
end

local Add = function(self, animtype, ...)
	self.Queue[#self.Queue + 1] = {animtype, ...}
end

local Play = function(self)
	if (#self.Queue == 0) then
		return
	end
	
	self.Finish = false
	
	self.Owner:Run(unpack(self.Queue[1]))
end

local Stop = function(self)
	self.Finish = true
end

local SetNumLoops = function(self, num)
	self.Looping = true
	self.NumLoops = num or 1
end

local SetLooping = function(self, value)
	self.Looping = value
end

local SetSmoothType = function(self, smoothing)
	smoothing = strlower(smoothing)
	smoothing = LibAnim.Smoothing[smoothing] and smoothing or "none"
	
	if self.IsAnimGroup then
		self.Owner._Smoothing = smoothing
	else
		self._Smoothing = smoothing
	end
end

local NewAnimGroup = function(object)
	if (not object) then
		return
	end
	
	local Group = CreateFrame("Frame")
	
	Group.Queue = {}
	Group.Owner = object
	Group.Add = Add
	Group.Play = Play
	Group.Stop = Stop
	Group.SetNumLoops = SetNumLoops
	Group.SetLooping = SetLooping
	Group.SetSmoothType = SetSmoothType
	Group.LastIndex = 1
	Group.TimesRun = 0
	Group.IsAnimGroup = true
	object._Group = Group
	
	return Group
end

local AddAPI = function(object)
	local MetaTable = getmetatable(object).__index
	
	if not object.Run then MetaTable.Run = Run end
	if not object.OnFinished then MetaTable.OnFinished = OnFinished end
	if not object.NewAnimGroup then MetaTable.NewAnimGroup = NewAnimGroup end
	if not object.SetSmoothType then MetaTable.SetSmoothType = SetSmoothType end
end

local Handled = {["Frame"] = true}
local Object = CreateFrame("Frame")

AddAPI(Object)
AddAPI(Object:CreateTexture())
AddAPI(Object:CreateFontString())

Object = EnumerateFrames()

while Object do
	if (not Handled[Object:GetObjectType()]) then
		AddAPI(Object)
		Handled[Object:GetObjectType()] = true
	end
	
	Object = EnumerateFrames(Object)
end

_G["LibAnim"] = LibAnim
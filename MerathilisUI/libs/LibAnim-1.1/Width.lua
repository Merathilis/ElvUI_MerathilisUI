local LibAnim = LibAnim
local WidthFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._WidthTimer = Frame._WidthTimer + elapsed
		
		Frame._WidthOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._WidthTimer, Frame._StartWidth, Frame._Change, Frame._WidthDuration)
		
		Frame:SetWidth(Frame._WidthOffset)
		
		if (Frame._WidthTimer >= Frame._WidthDuration) then
			table.remove(self, Index)
			Frame:SetWidth(Frame._EndWidth)
			Frame._WidthChanging = nil
			LibAnim:Callback(Frame, "Width", Frame._WidthDuration, Frame._EndWidth)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Width = function(self, duration, width)
	if self._WidthChanging then
		return
	end
	
	self._WidthTimer = 0
	self._WidthDuration = duration or 1
	self._StartWidth = self:GetWidth() or 0
	self._EndWidth = width or 0
	self._WidthChanging = true
	self._Smoothing = self._Smoothing or "none"
	self._Change = self._EndWidth - self._StartWidth
	
	table.insert(WidthFrames, self)
	
	WidthFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Width", Width)
local LibAnim = LibAnim
local AlphaFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._AlphaTimer = Frame._AlphaTimer + elapsed
		
		Frame._AlphaOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._AlphaTimer, Frame._StartAlpha, Frame._Change, Frame._AlphaDuration)
		
		Frame:SetAlpha(Frame._AlphaOffset)
		
		if (Frame._AlphaTimer >= Frame._AlphaDuration) then
			table.remove(self, Index)
			Frame:SetAlpha(Frame._EndAlpha)
			LibAnim:Callback(Frame, "Alpha", Frame._AlphaDuration, Frame._StartAlpha, Frame._EndAlpha)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Alpha = function(self, duration, startAlpha, endAlpha)
	self._AlphaTimer = 0
	self._AlphaDuration = duration
	self._StartAlpha = startAlpha or 1
	self._EndAlpha = endAlpha or 0
	self._Smoothing = self._Smoothing or "none"
	self._Change = self._EndAlpha - self._StartAlpha
	
	table.insert(AlphaFrames, self)
	
	AlphaFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Alpha", Alpha)
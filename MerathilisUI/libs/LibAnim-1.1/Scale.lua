local LibAnim = LibAnim
local ScaleFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._ScaleTimer = Frame._ScaleTimer + elapsed
		
		Frame._ScaleOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._ScaleTimer, Frame._StartScale, Frame._Change, Frame._ScaleDuration)
		
		Frame:SetScale(Frame._ScaleOffset)
		
		if (Frame._ScaleTimer >= Frame._ScaleDuration) then
			table.remove(self, Index)
			Frame:SetScale(Frame._EndScale)
			LibAnim:Callback(Frame, "Scale", Frame._ScaleDuration, Frame._EndScale)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Scale = function(self, duration, scale)
	self._ScaleTimer = 0
	self._ScaleDuration = duration
	self._StartScale = self:GetScale()
	self._EndScale = scale
	self._Smoothing = self._Smoothing or "none"
	self._Change = self._EndScale - self._StartScale
	
	table.insert(ScaleFrames, self)
	
	ScaleFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Scale", Scale)
local LibAnim = LibAnim
local HeightFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._HeightTimer = Frame._HeightTimer + elapsed
		
		Frame._HeightOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._HeightTimer, Frame._StartHeight, Frame._Change, Frame._HeightDuration)
		
		Frame:SetHeight(Frame._HeightOffset)
		
		if (Frame._HeightTimer >= Frame._HeightDuration) then
			table.remove(self, Index)
			Frame:SetHeight(Frame._EndHeight)
			Frame._HeightChanging = nil
			LibAnim:Callback(Frame, "Height", Frame._HeightDuration, Frame._EndHeight)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Height = function(self, duration, height)
	if self._HeightChanging then
		return
	end
	
	self._HeightTimer = 0
	self._HeightDuration = duration or 1
	self._StartHeight = self:GetHeight() or 0
	self._EndHeight = height or 0
	self._HeightChanging = true
	self._Smoothing = self._Smoothing or "none"
	self._Change = self._EndHeight - self._StartHeight
	
	table.insert(HeightFrames, self)
	
	HeightFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Height", Height)
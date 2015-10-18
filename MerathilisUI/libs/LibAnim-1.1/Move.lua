local LibAnim = LibAnim
local MoveFrames = CreateFrame("Frame")
local Frame

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._MoveTimer = Frame._MoveTimer + elapsed
		
		Frame._XOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._MoveTimer, Frame._StartX, Frame._XChange, Frame._MoveDuration)
		Frame._YOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._MoveTimer, Frame._StartY, Frame._YChange, Frame._MoveDuration)
		
		Frame:SetPoint(Frame._A1, Frame._P, Frame._A2, (Frame._EndX ~= 0 and Frame._XOffset or Frame._StartX), (Frame._EndY ~= 0 and Frame._YOffset or Frame._StartY))
		
		if (Frame._MoveTimer >= Frame._MoveDuration) then
			table.remove(self, Index)
			Frame:SetPoint(Frame._A1, Frame._P, Frame._A2, Frame._EndX, Frame._EndY)
			Frame._IsMoving = nil
			LibAnim:Callback(Frame, "Width", Frame._MoveDuration, Frame._EndX, Frame._EndY)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Move = function(self, duration, x, y)
	if self._IsMoving then
		return
	end
	
	local A1, P, A2, X, Y = self:GetPoint()
	
	self._MoveTimer = 0
	self._MoveDuration = duration
	self._A1 = A1
	self._P = P
	self._A2 = A2
	self._StartX = X
	self._EndX = X + x
	self._StartY = Y
	self._EndY = Y + y
	self._Smoothing = self._Smoothing or "none"
	self._XChange = self._EndX - self._StartX
	self._YChange = self._EndY - self._StartY
	self._IsMoving = true
	
	table.insert(MoveFrames, self)
	
	MoveFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Move", Move)
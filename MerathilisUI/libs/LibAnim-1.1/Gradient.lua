local LibAnim = LibAnim
local GradientFrames = CreateFrame("StatusBar")
local modf = math.modf
local select = select
local Frame
local R, G, B, R1, G1, B1, R2, G2, B2

local Texture = GradientFrames:CreateTexture()
local Text = GradientFrames:CreateFontString()

local Set = {
	["backdrop"] = GradientFrames.SetBackdropColor,
	["border"] = GradientFrames.SetBackdropBorderColor,
	["statusbar"] = GradientFrames.SetStatusBarColor,
	["text"] = Text.SetTextColor,
	["texture"] = Texture.SetTexture,
	["vertex"] = Texture.SetVertexColor,
}

local Get = {
	["backdrop"] = GradientFrames.GetBackdropColor,
	["border"] = GradientFrames.GetBackdropBorderColor,
	["statusbar"] = GradientFrames.GetStatusBarColor,
	["text"] = Text.GetTextColor,
	["texture"] = Texture.GetVertexColor,
	["vertex"] = Texture.GetVertexColor,
}

local ColorGradient = function(min, max, ...)
	local Percent
	
	if (max == 0) then
		Percent = 0
	else
		Percent = min / max
	end
	
	if (Percent >= 1) then
		R, G, B = select(select("#", ...) - 2, ...)
		
		return R, G, B
	elseif (Percent <= 0) then
		R, G, B = ...
		
		return R, G, B
	end
	
	local Num = select("#", ...) / 3
	local Segment, Relative = modf(Percent * (Num - 1))
	R1, G1, B1, R2, G2, B2 = select((Segment * 3) + 1, ...)
	
	return R1 + (R2 - R1) * Relative, G1 + (G2 - G1) * Relative, B1 + (B2 - B1) * Relative
end

local OnUpdate = function(self, elapsed)
	local Index = 1
	
	while self[Index] do
		Frame = self[Index]
		Frame._GradientTimer = Frame._GradientTimer + elapsed
		
		Frame._GradientOffset = LibAnim.Smoothing[Frame._Smoothing](Frame._GradientTimer, 0, Frame._GradientDuration, Frame._GradientDuration)
		
		Set[Frame._Type](Frame, ColorGradient(Frame._GradientOffset, Frame._GradientDuration, Frame._StartR, Frame._StartG, Frame._StartB, Frame._EndR, Frame._EndG, Frame._EndB))
		
		if (Frame._GradientTimer >= Frame._GradientDuration) then
			table.remove(self, Index)
			Set[Frame._Type](Frame, Frame._EndR, Frame._EndG, Frame._EndB)
			LibAnim:Callback(Frame, "Gradient", Frame._GradientDuration, Frame._EndWidth)
			LibAnim:GroupCallback(Frame)
		end
		
		Index = Index + 1
	end
	
	if (#self == 0) then
		self:SetScript("OnUpdate", nil)
	end
end

local Gradient = function(self, type, duration, r, g, b)
	self._GradientTimer = 0
	self._GradientDuration = duration
	self._Type = string.lower(type)
	self._StartR, self._StartG, self._StartB = Get[self._Type](self)
	self._EndR, self._EndG, self._EndB = r, g, b
	self._Smoothing = self._Smoothing or "none"
	
	table.insert(GradientFrames, self)
	
	GradientFrames:SetScript("OnUpdate", OnUpdate)
end

LibAnim:NewType("Gradient", Gradient)
local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

do --[[ SharedXML\LayoutFrame.lua ]]
	local BaseLayoutMixin do
	BaseLayoutMixin = {}
	local function LayoutIndexComparator(left, right)
		return left.layoutIndex < right.layoutIndex
	end

		function BaseLayoutMixin.GetLayoutChildren(self)
			local children = {}
			self:AddLayoutChildren(children, self:GetChildren())
			self:AddLayoutChildren(children, self:GetRegions())
			table.sort(children, LayoutIndexComparator)

			return children
		end
	end
	MERS.BaseLayoutMixin = BaseLayoutMixin

	local LayoutMixin do
		LayoutMixin = {}
		function LayoutMixin.GetPadding(self, frame)
			if frame then
				return frame.leftPadding or 0,
					frame.rightPadding or 0,
					frame.topPadding or 0,
					frame.bottomPadding or 0
			end
		end

		function LayoutMixin.CalculateFrameSize(self, childrenWidth, childrenHeight)
			local frameWidth, frameHeight
			local leftPadding, rightPadding, topPadding, bottomPadding = LayoutMixin.GetPadding(self, self)

			childrenWidth = childrenWidth + leftPadding + rightPadding
			childrenHeight = childrenHeight + topPadding + bottomPadding

			-- Expand this frame if the "expand" keyvalue is set and children width or height is larger.
			-- Otherwise, set this frame size to the fixed size if set, or the size of the children
			local fixedWidth = self.fixedWidth
			if (self.expand and fixedWidth and childrenWidth > fixedWidth) then
				frameWidth = childrenWidth
			else
				frameWidth = fixedWidth or childrenWidth
			end

			local fixedHeight = self.fixedHeight
			if (self.expand and fixedHeight and childrenHeight > fixedHeight) then
				frameHeight = childrenHeight
			else
				frameHeight = fixedHeight or childrenHeight
			end
			return frameWidth, frameHeight
		end

		function LayoutMixin.Layout(self)
			local children = MERS.BaseLayoutMixin.GetLayoutChildren(self)
			local childrenWidth, childrenHeight, hasExpandableChild = self:_LayoutChildren(children)

			local frameWidth, frameHeight = LayoutMixin.CalculateFrameSize(self, childrenWidth, childrenHeight)

			-- If at least one child had "expand" set and we did not already expand them, call LayoutChildren() again to expand them
			if (hasExpandableChild) then
			    childrenWidth, childrenHeight = self:_LayoutChildren(children, frameWidth, frameHeight)
			    frameWidth, frameHeight = LayoutMixin.CalculateFrameSize(self, childrenWidth, childrenHeight)
			end
		end
	end
	MERS.LayoutMixin = LayoutMixin

	local VerticalLayoutMixin do
		VerticalLayoutMixin = {}
		function VerticalLayoutMixin.LayoutChildren(self, children, expandToWidth)
			local frameLeftPadding, frameRightPadding, topOffset = MERS.LayoutMixin.GetPadding(self, self)
			local spacing = self.spacing or 0
			local childrenWidth, childrenHeight = 0, 0
			local hasExpandableChild = false

			-- Calculate width and height based on children
			for i, child in ipairs(children) do
				local childWidth, childHeight = child:GetSize()
				local leftPadding, rightPadding, topPadding, bottomPadding = MERS.LayoutMixin.GetPadding(self, child)
				if (child.expand) then
				    hasExpandableChild = true
				end

				-- Expand child width if it is set to expand and we also have an expandToWidth value.
				if (child.expand and expandToWidth) then
					childWidth = expandToWidth - leftPadding - rightPadding - frameLeftPadding - frameRightPadding
					childHeight = child:GetHeight()
				end
				childrenWidth = max(childrenWidth, childWidth + leftPadding + rightPadding)
				childrenHeight = childrenHeight + childHeight + topPadding + bottomPadding
				if (i > 1) then
					childrenHeight = childrenHeight + spacing
				end

				-- Set child position
				child:ClearAllPoints()
				topOffset = topOffset + topPadding
				if (child.align == "right") then
					local rightOffset = frameRightPadding + rightPadding
				elseif (child.align == "center") then
					local leftOffset = (frameLeftPadding - frameRightPadding + leftPadding - rightPadding) / 2
				else
					local leftOffset = frameLeftPadding + leftPadding
				end
				topOffset = topOffset + childHeight + bottomPadding + spacing
			end

			return childrenWidth, childrenHeight, hasExpandableChild
		end
	end
	MERS.VerticalLayoutMixin = VerticalLayoutMixin

	local HorizontalLayoutMixin do
		HorizontalLayoutMixin = {}
		function HorizontalLayoutMixin.LayoutChildren(self, children, ignored, expandToHeight)
			local leftOffset, _, frameTopPadding, frameBottomPadding = MERS.LayoutMixin.GetPadding(self, self)
			local spacing = self.spacing or 0
			local childrenWidth, childrenHeight = 0, 0
			local hasExpandableChild = false

			-- Calculate width and height based on children
			for i, child in ipairs(children) do
				local childWidth, childHeight = child:GetSize()
				local leftPadding, rightPadding, topPadding, bottomPadding = Hook.LayoutMixin.GetPadding(self, child)
				if (child.expand) then
				    hasExpandableChild = true
				end

				-- Expand child height if it is set to expand and we also have an expandToHeight value.
				if (child.expand and expandToHeight) then
					childHeight = expandToHeight - topPadding - bottomPadding - frameTopPadding - frameBottomPadding
					Scale.RawSetHeight(child, childHeight)
					childWidth = child:GetWidth()
				end
				childrenHeight = max(childrenHeight, childHeight + topPadding + bottomPadding)
				childrenWidth = childrenWidth + childWidth + leftPadding + rightPadding
				if (i > 1) then
					childrenWidth = childrenWidth + spacing
				end

				-- Set child position
				child:ClearAllPoints()
				leftOffset = leftOffset + leftPadding
				if (child.align == "bottom") then
					local bottomOffset = frameBottomPadding + bottomPadding
				elseif (child.align == "center") then
					local topOffset = (frameTopPadding - frameBottomPadding + topPadding - bottomPadding) / 2
				else
					local topOffset = frameTopPadding + topPadding
				end
				leftOffset = leftOffset + childWidth + rightPadding + spacing
			end

			return childrenWidth, childrenHeight, hasExpandableChild
		end
	end
	MERS.HorizontalLayoutMixin = HorizontalLayoutMixin
end

do --[[ SharedXML\LayoutFrame.xml ]]
	function MERS:VerticalLayoutFrame(Frame)
		Frame._LayoutChildren = MERS.VerticalLayoutMixin.LayoutChildren
		hooksecurefunc(Frame, "Layout", MERS.LayoutMixin.Layout)
	end
	function MERS:HorizontalLayoutFrame(Frame)
		Frame._LayoutChildren = MERS.HorizontalLayoutMixin.LayoutChildren
		hooksecurefunc(Frame, "Layout", MERS.LayoutMixin.Layout)
	end
end

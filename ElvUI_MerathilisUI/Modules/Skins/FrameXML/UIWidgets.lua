local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

local function ReskinText(text)
	if text then
		F.SetFontOutline(text)
	end
end

local function ReskinLabel(label)
	if label then
		F.SetFontOutline(label)
	end
end

local function ReskinBar(bar)
	if bar and bar.backdrop then
		module:CreateBackdropShadow(bar)
		ReskinLabel(bar.Label)
	end
end

local function ReskinUIWidgetContainer(container)
	if not container or not container.widgetFrames then
		return
	end

	for _, widget in pairs(container.widgetFrames) do
		if not widget.__MERSkin then
			ReskinText(widget.Text)
			ReskinBar(widget.Bar)
			widget.__MERSkin = true
		end
	end

	hooksecurefunc(container, "ProcessWidget", function(container)
		for _, widget in pairs(container.widgetFrames) do
			if not widget.__MERSkin then
				ReskinText(widget.Text)
				ReskinBar(widget.Bar)
				widget.__MERSkin = true
			end
		end
	end)
end

local function ReskinPartitionFrame(partitionFrame)
	if partitionFrame.__MERSkin then
		return
	end

	hooksecurefunc(partitionFrame.Tex, "SetAtlas", function(self, atlas)
		if atlas == "widgetstatusbar-BorderTick" then
			self:SetTexture(E.media.blankTex)
			self:SetTexCoord(0, 1, 0, 1)
			self:SetVertexColor(1, 1, 1)
			self:SetAlpha(0.382)
			self:Height(15)
			self:Width(1)
		else
			self:SetAlpha(1)
		end
	end)

	partitionFrame.__MERSkin = true
end

function module:BlizzardUIWidget()
	if not module:CheckDB("misc", "uiWidget") then
		return
	end

	self:SecureHook(_G.UIWidgetBaseStatusBarTemplateMixin, "InitPartitions", function(widget)
		local pool = widget.partitionPool
		if not pool then
			return
		end

		for partitionFrame in pool:EnumerateActive() do
			ReskinPartitionFrame(partitionFrame)
		end

		hooksecurefunc(pool, "Acquire", function(_pool)
			for partitionFrame in _pool:EnumerateActive() do
				ReskinPartitionFrame(partitionFrame)
			end
		end)
	end)

	self:SecureHook(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widget)
		if widget:IsForbidden() or widget.widgetSetID and widget.widgetSetID == 283 then
			return
		end

		if not widget.__MERSkin then
			ReskinLabel(widget.Label)
			ReskinBar(widget.Bar)
			ReskinLabel(widget.Bar.Label)

			if widget.isJailersTowerBar and self:CheckDB(nil, "scenario") then
				widget.Bar:SetWidth(234)
			end
		end
	end)

	self:SecureHook(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(widget)
		if not widget.__MERSkin then
			ReskinBar(widget.Bar)
		end
	end)

	self:SecureHook(S, "SkinStatusBarWidget", function(_, widget)
		ReskinBar(widget.Bar)
	end)

	self:SecureHook(S, "SkinDoubleStatusBarWidget", function(_, widget)
		ReskinBar(widget.LeftBar)
		ReskinBar(widget.RightBar)
	end)

	S.SkinTextWithStateWidget = E.noop -- Use Blizzard default color

	ReskinUIWidgetContainer(_G.UIWidgetTopCenterContainerFrame)
end

module:AddCallback("BlizzardUIWidget")

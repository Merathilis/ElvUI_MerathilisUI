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

function module:BlizzardUIWidget()
	if not module:CheckDB("misc", "uiWidget") then
		return
	end

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

local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')

local _G = _G
local select, unpack = select, unpack

local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local hooksecurefunc = hooksecurefunc

local function RemoveStyle(bar)
	bar.candyBarBackdrop:Hide()

	local height = bar:Get("bigwigs:restoreheight")
	if height then
		bar:SetHeight(height)
	end

	local tex = bar:Get("bigwigs:restoreicon")
	if tex then
		bar:SetIcon(tex)
		bar:Set("bigwigs:restoreicon", nil)
		bar.candyBarIconFrameBackdrop:Hide()
	end

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 10)
	bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 10)

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 10)
	bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 10)
end

local function ApplyStyle(bar)
	local height = bar:GetHeight()
	bar:Set("bigwigs:restoreheight", height)
	bar:SetHeight(height/2)
	bar.candyBarBackdrop:Hide()
	if not bar.styled then
		bar.candyBarBar:StripTextures()
		bar.candyBarBar:CreateBackdrop('Transparent')
		bar.candyBarBar.backdrop:Styling()

		bar.styled = true
	end
	bar:SetTexture(E.media.normTex)

	local tex = bar:GetIcon()
	if tex then
		local icon = bar.candyBarIconFrame
		bar:SetIcon(nil)

		icon:SetTexture(tex)
		icon:Show()

		if bar.iconPosition == "RIGHT" then
			icon:SetPoint('BOTTOMLEFT', bar, 'BOTTOMRIGHT', 5, 0)
		else
			icon:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -5, 0)
		end

		icon:SetSize(height, height)
		bar:Set("bigwigs:restoreicon", tex)
		bar.candyBarIconFrameBackdrop:Hide()

		if not icon.styled then
			icon:CreateBackdrop()
			icon.backdrop:SetOutside(icon, 2, 2)
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

			icon.styled = true
		end
	end

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint('LEFT', bar.candyBarBar, 'LEFT', 2, 10)
	bar.candyBarLabel:SetPoint('RIGHT', bar.candyBarBar, 'RIGHT', -2, 10)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint('RIGHT', bar.candyBarBar, 'RIGHT', -2, 10)
	bar.candyBarDuration:SetPoint('LEFT', bar.candyBarBar, 'LEFT', 2, 10)
end

local f = CreateFrame("Frame")
local function RegisterStyle()
	if not _G.BigWigsAPI then return end

	local styleName = MER.Title or 'MerathilisUI'
	_G.BigWigsAPI:RegisterBarStyle(styleName, {
		apiVersion = 1,
		version = 10,
		GetSpacing = function(bar) return bar:GetHeight()+7 end,
		ApplyStyle = ApplyStyle,
		BarStopped = RemoveStyle,
		fontSizeNormal = 12,
		fontSizeEmphasized = 14,
		fontOutline = "OUTLINE",
		GetStyleName = function() return styleName end,
	})

	local bars = BigWigs:GetPlugin('Bars', true)
	hooksecurefunc(bars, 'SetBarStyle', function(self, style)
		if style ~= 'MerathilisUI' then
			self:SetBarStyle('MerathilisUI')
		end
	end)
end
f:RegisterEvent('ADDON_LOADED')

local reason = nil
f:SetScript('OnEvent', function(self, event, msg)
	if event == 'ADDON_LOADED' then
		if not reason then reason = (select(6, GetAddOnInfo('BigWigs_Plugins'))) end
		if (reason == 'MISSING' and msg == 'BigWigs') or msg == 'BigWigs_Plugins' then
			RegisterStyle()
		end
	end
end)

function MERS:BigWigs_QueueTimer()
	if not E.private.mui.skins.addonSkins.bw then return end

	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage("MerathilisUI", "BigWigs_FrameCreated", function(_, frame, name)
			if name == "QueueTimer" then
				local parent = frame:GetParent()
				frame:StripTextures()
				frame:CreateBackdrop("Transparent")
				frame.backdrop:Styling()
				frame:SetStatusBarTexture(E.media.normTex)
				frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
				frame:Size(parent:GetWidth(), 10)
				frame:ClearAllPoints()
				frame:Point("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
				frame:Point("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -5)
				frame.text.SetFormattedText = function(self, _, time)
					self:SetText(format("%d", time))
				end
				frame.text:FontTemplate()
				frame.text:ClearAllPoints()
				frame.text:Point("TOP", frame, "TOP", 0, -3)
			end
		end)

		E:Delay(2, function() _G.BigWigsLoader.UnregisterMessage("AddOnSkins", "BigWigs_FrameCreated") end)
	end
end

MERS:AddCallbackForEnterWorld("BigWigs_QueueTimer")

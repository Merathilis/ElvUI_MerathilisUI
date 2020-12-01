local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local select, unpack = select, unpack
local tremove = table.remove
local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local UIParent = UIParent

local buttonsize = 19

-- Init a table to store the backgrounds
local FreeBackgrounds = {}

local function CreateBG()
	local BG = CreateFrame('Frame', nil, nil, 'BackdropTemplate')
	MERS:CreateBD(BG, .45)
	BG:Styling()

	return BG
end

local function GetBG(FreeBackgrounds)
	if #FreeBackgrounds > 0 then
		return tremove(FreeBackgrounds)
	else
		return CreateBG()
	end
end

local function SetupBG(bg, bar, ibg)
	bg:SetParent(bar)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:ClearAllPoints()
	if ibg then
		MERS:SetOutside(bg, bar.candyBarIconFrame)
		bg:SetBackdropColor(0, 0, 0, 0)
	else
		MERS:SetOutside(bg, bar)
		bg:SetBackdropColor(unpack(E.media.backdropcolor))
	end
	bg:Show()
end

local function FreeStyle(bar)
	local bg = bar:Get('bigwigs:MerathilisUI:bg')
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = bg
	end

	local ibg = bar:Get('bigwigs:MerathilisUI:ibg')
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		FreeBackgrounds[#FreeBackgrounds + 1] = ibg
	end

	--Reset Positions
	--Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint('TOPLEFT')
	bar.candyBarIconFrame:SetPoint('BOTTOMLEFT')
	bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	--Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar.SetPoint = nil
	bar.candyBarBar:SetPoint('TOPRIGHT')
	bar.candyBarBar:SetPoint('BOTTOMRIGHT')

	--BG
	bar.candyBarBackground:SetAllPoints()
end

local function ApplyStyle(bar)
	local bg = GetBG(FreeBackgrounds)
	SetupBG(bg, bar)
	bar:Set('bigwigs:MerathilisUI:bg', bg)

	if bar.candyBarIconFrame:GetTexture() then
		local ibg = GetBG(FreeBackgrounds)
		SetupBG(ibg, bar, true)
		bar:Set('bigwigs:MerathilisUI:ibg', ibg)
	end

	bar:SetHeight(buttonsize / 2)

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.SetPoint = MER.Noop
	bar.candyBarBar:SetStatusBarTexture(E.media.normTex)
	bar.candyBarBackground:SetTexture(unpack(E.media.backdropcolor))

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -7, 0)
	bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)

	MERS:ReskinIcon(bar.candyBarIconFrame)

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint('LEFT', bar, 'LEFT', 2, 10)
	bar.candyBarLabel:SetPoint('RIGHT', bar, 'RIGHT', -2, 10)

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint('LEFT', bar, 'LEFT', 2, 10)
	bar.candyBarDuration:SetPoint('RIGHT', bar, 'RIGHT', -2, 10)
end

local f = CreateFrame("Frame")
local function RegisterStyle()
	if not BigWigs then return end
	local styleName = MER.Title or 'MerathilisUI'
	local bars = BigWigs:GetPlugin('Bars', true)
	if not bars then return end
	bars:RegisterBarStyle(styleName, {
		apiVersion = 1,
		version = 10,
		GetSpacing = function() return 20 end,
		ApplyStyle = ApplyStyle,
		BarStopped = FreeStyle,
		GetStyleName = function() return styleName end,
	})
	bars.defaultDB.barStyle = styleName
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
	if not E.private.muiSkins.addonSkins.bw then return end

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

		E:Delay(2,function()
			_G.BigWigsLoader.UnregisterMessage("AddOnSkins", "BigWigs_FrameCreated")
		end)
	end
end

MERS:AddCallbackForEnterWorld("BigWigs_QueueTimer")

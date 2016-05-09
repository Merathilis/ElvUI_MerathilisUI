local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local unpack = unpack
local tremove = tremove
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: UIParent, BigWigs, BigWigsLoader

-- Hook to AddOnSkins
if not IsAddOnLoaded("AddOnSkins") or not IsAddOnLoaded("BigWigs") then return; end
local AS = unpack(AddOnSkins);
local BWskin = AS.BigWigs
local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

function AS:BigWigs(event, addon)
	if E.private.muiSkins.addonSkins.bw ~= true then return; end

	BWskin(self, event, addon)
	if event == 'PLAYER_ENTERING_WORLD' then
		if BigWigsLoader then
			BigWigsLoader.RegisterMessage('AddOnSkins', "BigWigs_FrameCreated", function(event, frame, name)
				if name == "QueueTimer" then
					AS:SkinStatusBar(frame)
					frame:ClearAllPoints()
					frame:SetPoint('TOP', '$parent', 'BOTTOM', 0, -(AS.PixelPerfect and 2 or 4))
					frame:SetHeight(16)
					frame:SetTemplate('Transparent')
					frame:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
				end
			end)
		end
	end

	if IsAddOnLoaded('BigWigs_Plugins') or (addon == 'BigWigs_Plugins') then
		AS:UnregisterSkinEvent('BigWigs', "ADDON_LOADED")

		local buttonsize = 19
		local FreeBackgrounds = {}

		local CreateBG = function()
			local BG = CreateFrame('Frame')
			BG:SetTemplate('Transparent')
			return BG
		end

		local function FreeStyle(bar)
			local bg = bar:Get('bigwigs:AddOnSkins:bg')
			if bg then
				bg:ClearAllPoints()
				bg:SetParent(UIParent)
				bg:Hide()
				FreeBackgrounds[#FreeBackgrounds + 1] = bg
			end

			local ibg = bar:Get('bigwigs:AddOnSkins:ibg')
			if ibg then
				ibg:ClearAllPoints()
				ibg:SetParent(UIParent)
				ibg:Hide()
				FreeBackgrounds[#FreeBackgrounds + 1] = ibg
			end

			bar.candyBarIconFrame:ClearAllPoints()
			bar.candyBarIconFrame.SetWidth = nil
			bar.candyBarIconFrame:SetPoint('TOPLEFT')
			bar.candyBarIconFrame:SetPoint('BOTTOMLEFT')

			bar.candyBarBar:ClearAllPoints()
			bar.candyBarBar.SetPoint = nil
			bar.candyBarBar:SetPoint('TOPRIGHT')
			bar.candyBarBar:SetPoint('BOTTOMRIGHT')
		end

		local function ApplyStyle(bar)
			bar:SetHeight(buttonsize)

			local bg
			if #FreeBackgrounds > 0 then
				bg = tremove(FreeBackgrounds)
			else
				bg = CreateBG()
			end

			bg:SetParent(bar)
			bg:SetFrameStrata(bar:GetFrameStrata())
			bg:SetFrameLevel(bar:GetFrameLevel() - 1)
			bg:ClearAllPoints()
			bg:SetOutside(bar)
			bg:SetTemplate('Transparent')
			bg:Show()
			bar:Set('bigwigs:AddOnSkins:bg', bg)

			if bar.candyBarIconFrame:GetTexture() then
				local ibg
				if #FreeBackgrounds > 0 then
					ibg = tremove(FreeBackgrounds)
				else
					ibg = CreateBG()
				end
				ibg:SetParent(bar)
				ibg:SetFrameStrata(bar:GetFrameStrata())
				ibg:SetFrameLevel(bar:GetFrameLevel() - 1)
				ibg:ClearAllPoints()
				ibg:SetOutside(bar.candyBarIconFrame)
				ibg:SetBackdropColor(0, 0, 0, 0)
				ibg:Show()
				bar:Set('bigwigs:AddOnSkins:ibg', ibg)
			end

			bar.candyBarBar:ClearAllPoints()
			bar.candyBarBar:SetAllPoints(bar)
			bar.candyBarBar.SetPoint = AS.Noop
			bar.candyBarBar:SetStatusBarTexture(E['media'].MuiFlat)
			MER:CreateSoftGlow(bar.candyBarBar)

			bar.candyBarBackground:SetTexture(unpack(AS.BackdropColor))

			bar.candyBarIconFrame:ClearAllPoints()
			bar.candyBarIconFrame:Point('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -7, 0)
			bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
			bar.candyBarIconFrame.SetWidth = AS.Noop

			bar.candyBarLabel:SetShadowOffset(2, -2)

			bar.candyBarDuration:SetShadowOffset(2, -2)

			AS:SkinTexture(bar.candyBarIconFrame)
		end

		local BigWigsBars = BigWigs:GetPlugin('Bars')
		BigWigsBars:RegisterBarStyle('MerathilisUI', {
			apiVersion = 1,
			version = 1,
			GetSpacing = function() return 8 end,
			ApplyStyle = ApplyStyle,
			BarStopped = FreeStyle,
			GetStyleName = function() return 'MerathilisUI' end,
		})
	end
end
AS:RegisterSkin('BigWigs', AS.BigWigs, 'ADDON_LOADED')
local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
local getn = getn
local gsub = string.gsub
local tinsert = table.insert
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: DBM, DBT, DBMInfoFrame, UISpecialFrames, RaidNotice_AddMessage, DBM_GUI_OptionsFrame
-- GLOBALS: DBMRangeCheck, DBMRangeCheckRadar

local backdrop = {
	bgFile = E["media"].normTex,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:RegisterEvent("ADDON_LOADED")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
	if E.private.muiSkins.addonSkins == nil then E.private.muiSkins.addonSkins = {} end
	if E.private.muiSkins.addonSkins.dbm ~= true then return end
	if IsAddOnLoaded("DBM-Core") then
		local function SkinBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName().."Bar"]
						local spark = _G[frame:GetName().."BarSpark"]
						local texture = _G[frame:GetName().."BarTexture"]
						local icon1 = _G[frame:GetName().."BarIcon1"]
						local icon2 = _G[frame:GetName().."BarIcon2"]
						local name = _G[frame:GetName().."BarName"]
						local timer = _G[frame:GetName().."BarTimer"]

						if icon1.overlay then
							icon1.overlay = _G[icon1.overlay:GetName()]
						else
							icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
							icon1.overlay:SetWidth(25)
							icon1.overlay:SetHeight(25)
							icon1.overlay:SetFrameStrata("BACKGROUND")
							icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, -2)
							icon1.overlay:SetTemplate("Transparent")
						end

						if icon2.overlay then
							icon2.overlay = _G[icon2.overlay:GetName()]
						else
							icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
							icon2.overlay:SetWidth(25)
							icon2.overlay:SetHeight(25)
							icon2.overlay:SetFrameStrata("BACKGROUND")
							icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, -2)
							icon2.overlay:SetTemplate("Transparent")
						end

						if bar.color then
							tbar:SetBackdrop(backdrop)
							tbar:SetBackdropColor(0, 0, 0, 0.15)
						end

						if not frame.styled then
							frame:SetScale(1)
							frame:SetHeight(19)
							frame:SetTemplate("Transparent")
							frame:Styling()
							frame.styled = true
						end

						if not spark.killed then
							spark:SetAlpha(0)
							spark:SetTexture(nil)
							spark.killed = true
						end

						if not icon1.styled then
							icon1:SetTexCoord(unpack(E.TexCoords))
							icon1:ClearAllPoints()
							icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
							icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
							icon1.styled = true
						end

						if not icon2.styled then
							icon2:SetTexCoord(unpack(E.TexCoords))
							icon2:ClearAllPoints()
							icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
							icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
							icon2.styled = true
						end

						if not texture.styled then
							texture:SetTexture(E["media"].normTex)
							texture.styled = true
						end

						if not tbar.styled then
							tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							tbar.styled = true
						end

						if not name.styled then
							name:SetShadowOffset(1, -1)
							name.styled = true
						end

						if not timer.styled then
							timer:SetShadowOffset(1, -1)
							timer.styled = true
						end

						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						texture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
				end
			end
		end

		if DBM then
			hooksecurefunc(DBT, "CreateBar", SkinBars)

			hooksecurefunc(DBM.RangeCheck, "Show", function()
				if DBMRangeCheck then
					DBMRangeCheck:SetTemplate("Transparent")
					DBMRangeCheck:Styling()
				end
				if DBMRangeCheckRadar then
					DBMRangeCheckRadar:SetTemplate("Transparent")
					DBMRangeCheckRadar:Styling()
				end
			end)

			hooksecurefunc(DBM.InfoFrame, "Show", function()
				if DBMInfoFrame then
					DBMInfoFrame:SetTemplate("Transparent")
				end
			end)
		end

		local replace = gsub
		local old = RaidNotice_AddMessage
		RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
			if textString:find(" |T") then
				textString = replace(textString, "(:12:12)", ":13:13:0:0:64:64:5:59:5:59")
			end
			return old(noticeFrame, textString, colorInfo)
		end
	end

	if IsAddOnLoaded("DBM-GUI") then
		tinsert(UISpecialFrames, "DBM_GUI_OptionsFrame")
		_G["DBM_GUI_OptionsFrame"]:SetTemplate("Transparent")
		_G["DBM_GUI_OptionsFrame"]:HookScript("OnShow", function(self) self:Styling() end)
		_G["DBM_GUI_OptionsFramePanelContainer"]:SetTemplate("Transparent")

		_G["DBM_GUI_OptionsFrameTab1"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab1"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameBossMods"], "TOPLEFT", 10, 27)
		_G["DBM_GUI_OptionsFrameTab2"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab2"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameTab1"], "TOPRIGHT", 6, 0)

		_G["DBM_GUI_OptionsFrameBossMods"]:HookScript("OnShow", function(self) self:SetTemplate("Transparent") end)
		_G["DBM_GUI_OptionsFrameDBMOptions"]:HookScript("OnShow", function(self) self:SetTemplate("Transparent") end)
		_G["DBM_GUI_OptionsFrameHeader"]:SetTexture("")
		_G["DBM_GUI_OptionsFrameHeader"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameHeader"]:SetPoint("TOP", DBM_GUI_OptionsFrame, 0, 7)

		local dbmbuttons = {
			"DBM_GUI_OptionsFrameWebsiteButton",
			"DBM_GUI_OptionsFrameOkay",
		}

		local dbmtabs = {
			"DBM_GUI_OptionsFrameTab1",
			"DBM_GUI_OptionsFrameTab2",
		}

		for i = 1, getn(dbmbuttons) do
			local buttons = _G[dbmbuttons[i]]
			if buttons and not buttons.overlay then
				S:HandleButton(buttons)
			end
		end

		for i = 1, getn(dbmtabs) do
			local tab = _G[dbmtabs[i]]
			if tab and not tab.overlay then
				S:HandleTab(tab)
			end
		end
	end
end)
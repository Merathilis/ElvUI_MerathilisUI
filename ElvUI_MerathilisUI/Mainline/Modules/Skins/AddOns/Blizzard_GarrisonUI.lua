local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, select, unpack = pairs, select, unpack

local function SkinGarrisonTooltips()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local tooltips = {
		_G.GarrisonFollowerTooltip,
		_G.FloatingGarrisonFollowerTooltip,
		_G.FloatingGarrisonMissionTooltip,
		_G.FloatingGarrisonShipyardFollowerTooltip,
		_G.GarrisonShipyardFollowerTooltip,
		_G.GarrisonFollowerAbilityTooltip,
		_G.FloatingGarrisonFollowerAbilityTooltip,
		_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip,
		_G.GarrisonFollowerAbilityWithoutCountersTooltip
	}

	for _, tooltip in pairs(tooltips) do
		if tooltip then
			module:CreateBackdropShadow(tooltip)
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local frames = {
		_G.GarrisonCapacitiveDisplayFrame,
		_G.GarrisonMissionFrame,
		_G.GarrisonLandingPage,
		_G.GarrisonBuildingFrame,
		_G.GarrisonShipyardFrame,
		_G.OrderHallMissionFrame,
		_G.OrderHallCommandBar,
		_G.BFAMissionFrame,
		_G.CovenantMissionFrame,
	}

	local tabs = {
		_G.GarrisonMissionFrameTab1,
		_G.GarrisonMissionFrameTab2,
		_G.GarrisonLandingPageTab1,
		_G.GarrisonLandingPageTab2,
		_G.GarrisonLandingPageTab3,
		_G.GarrisonShipyardFrameTab1,
		_G.GarrisonShipyardFrameTab2,
		_G.OrderHallMissionFrameTab1,
		_G.OrderHallMissionFrameTab2,
		_G.OrderHallMissionFrameTab3,
		_G.BFAMissionFrameTab1,
		_G.BFAMissionFrameTab2,
		_G.BFAMissionFrameTab3,
		_G.CovenantMissionFrameTab1,
		_G.CovenantMissionFrameTab2
	}

	for _, frame in pairs(frames) do
		if frame then
			frame:Styling()
			module:CreateShadow(frame)
		end
	end

	for _, tab in pairs(tabs) do
		module:ReskinTab(tab)
	end


	-- AddOn Support
	local function reskinWidgetFont(font, r, g, b)
		if font and font.SetTextColor then
			font:SetTextColor(r, g, b)
		end
	end

	-- VenturePlan, 4.30 and higher
	if IsAddOnLoaded("VenturePlan") then
		local ANIMA_TEXTURE = 3528288
		local ANIMA_SPELLID = {[347555] = 3, [345706] = 5, [336327] = 35, [336456] = 250}
		local function GetAnimaMultiplier(itemID)
			local _, spellID = GetItemSpell(itemID)
			return ANIMA_SPELLID[spellID]
		end
		local function SetAnimaActualCount(self, text)
			local mult = GetAnimaMultiplier(self.__owner.itemID)
			if mult then
				if text == "" then text = 1 end
				text = text * mult
				self:SetFormattedText("%s", text)
				self.__owner.Icon:SetTexture(ANIMA_TEXTURE)
			end
		end
		local function AdjustFollowerList(self)
			if self.isSetting then return end
			self.isSetting = true

			local numFollowers = #C_Garrison.GetFollowers(123)
			self:SetHeight(135 + 60*ceil(numFollowers/5)) -- 5 follower per row, support up to 35 followers in the future

			self.isSetting = nil
		end

		local ReplacedRoleTex = {
			["adventures-tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
			["adventures-healer"] = "ui_adv_health",
			["adventures-dps"] = "ui_adv_atk",
			["adventures-dps-ranged"] = "Soulbinds_Tree_Conduit_Icon_Utility",
		}
		local function replaceFollowerRole(roleIcon, atlas)
			local newAtlas = ReplacedRoleTex[atlas]
			if newAtlas then
				roleIcon:SetAtlas(newAtlas)
			end
		end

		local function updateSelectedBorder(portrait, show)
			if show then
				portrait.__owner.bg:SetBackdropBorderColor(.6, 0, 0)
			else
				portrait.__owner.bg:SetBackdropBorderColor(0, 0, 0)
			end
		end

		local function updateActiveGlow(border, show)
			border.__shadow:SetShown(show)
		end

		local abilityIndex1, abilityIndex2
		local function GetAbilitiesIndex(frame)
			if not abilityIndex1 then
				for i = 1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region then
						local width, height = region:GetSize()
						if E:Round(width) == 17 and E:Round(height) == 17 then
							if abilityIndex1 then
								abilityIndex2 = i
							else
								abilityIndex1 = i
							end
						end
					end
				end
			end
			return abilityIndex1, abilityIndex2
		end

		local function reskinFollowerAbility(frame, index, first)
			local ability = select(index, frame:GetRegions())
			ability:SetMask(nil)
			ability:SetSize(14, 14)
			S:HandleIcon(ability, true)
			ability.backdrop:SetFrameLevel(4)
			tinsert(frame.__abilities, ability)
			select(2, ability:GetPoint()):SetAlpha(0)
			ability:SetPoint("CENTER", frame, "LEFT", 11, first and 15 or 0)
		end

		local function updateVisibleAbilities(self)
			local showHealth = self.__owner.__health:IsShown()
			for _, ability in pairs(self.__owner.__abilities) do
				ability:SetDesaturated(not showHealth)
				ability.backdrop:SetShown(ability:IsShown())
			end
			self.__owner.__role:SetDesaturated(not showHealth)
		end

		local function fixAnchorForModVP(self, _, x, y)
			if x == 5 and y == -18 then
				self:SetPoint("CENTER", self.__owner, 1, 0)
			end
		end

		local VPFollowers, VPTroops, VPBooks, numButtons = {}, {}, {}, 0
		function _G.VPEX_OnUIObjectCreated(otype, widget, peek)
			if widget:IsObjectType("Frame") then
				if otype == "MissionButton" then
					S:HandleButton(peek("ViewButton"))
					S:HandleButton(peek("DoomRunButton"))
					S:HandleButton(peek("TentativeClear"))
					if peek("GroupHints") then
						S:HandleButton(peek("GroupHints"))
					end
					reskinWidgetFont(peek("Description"), 1, 1, 1)
					reskinWidgetFont(peek("enemyHP"), 1, 1, 1)
					reskinWidgetFont(peek("enemyATK"), 1, 1, 1)
					reskinWidgetFont(peek("animaCost"), .6, .8, 1)
					reskinWidgetFont(peek("duration"), 1, .8, 0)
					reskinWidgetFont(widget.CDTDisplay:GetFontString(), 1, .8, 0)
				elseif otype == "CopyBoxUI" then
					S:HandleButton(widget.ResetButton)
					S:HandleCloseButton(widget.CloseButton2)
					reskinWidgetFont(widget.Intro, 1, 1, 1)
					S:HandleEditBox(widget.FirstInputBox)
					reskinWidgetFont(widget.FirstInputBoxLabel, 1, .8, 0)
					S:HandleEditBox(widget.SecondInputBox)
					reskinWidgetFont(widget.SecondInputBoxLabel, 1, .8, 0)
					reskinWidgetFont(widget.VersionText, 1, 1, 1)
				elseif otype == "MissionList" then
					widget:StripTextures()
					local background = widget:GetChildren()
					background:StripTextures()
					module:CreateBDFrame(background, .25)
				elseif otype == "MissionPage" then
					widget:StripTextures()
					S:HandleButton(peek("UnButton"))
					S:HandleButton(peek("StartButton"))
					peek("StartButton"):SetText("|T"..MER.Media.Textures.arrowUp..":16|t")
				elseif otype == "ILButton" then
					widget:DisableDrawLayer("BACKGROUND")
					local bg = module:CreateBDFrame(widget, .25)
					bg:SetPoint("TOPLEFT", -3, 1)
					bg:SetPoint("BOTTOMRIGHT", 2, -2)
					module:CreateBDFrame(widget.Icon, .25)
				elseif otype == "IconButton" then
					S:HandleIcon(widget.Icon)
					widget:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
					widget:SetPushedTexture(nil)
					widget:SetSize(46, 46)
					tinsert(VPBooks, widget)
				elseif otype == "AdventurerRoster" then
					widget:StripTextures()
					module:CreateBDFrame(widget, .25)
					hooksecurefunc(widget, "SetHeight", AdjustFollowerList)
					S:HandleButton(peek("HealAllButton"))

					for i, troop in pairs(VPTroops) do
						troop:ClearAllPoints()
						troop:SetPoint("TOPLEFT", (i-1)*60+5, -35)
					end
					for i, follower in pairs(VPFollowers) do
						follower:ClearAllPoints()
						follower:SetPoint("TOPLEFT", ((i-1)%5)*60+5, -floor((i-1)/5)*60-130)
					end
					for i, book in pairs(VPBooks) do
						book:ClearAllPoints()
						book:SetPoint("BOTTOMLEFT", 24, -46 + i*50)
					end
				elseif otype == "AdventurerListButton" then
					widget.bg = module:CreateBDFrame(peek("Portrait"), 1)
					peek("Hi"):SetColorTexture(1, 1, 1, .25)
					peek("Hi"):SetInside(widget.bg)
					peek("PortraitR"):Hide()
					peek("PortraitT"):SetTexture(nil)
					peek("PortraitT").__owner = widget
					hooksecurefunc(peek("PortraitT"), "SetShown", updateSelectedBorder)

					numButtons = numButtons + 1
					if numButtons > 2 then
						peek("UsedBorder"):SetTexture(nil)
						peek("UsedBorder").__shadow = module:CreateSD(peek("Portrait"), 5, true)
						peek("UsedBorder").__shadow:SetBackdropBorderColor(peek("UsedBorder"):GetVertexColor())
						hooksecurefunc(peek("UsedBorder"), "SetShown", updateActiveGlow)
						tinsert(VPFollowers, widget)
					else
						tinsert(VPTroops, widget)
					end

					peek("HealthBG"):ClearAllPoints()
					peek("HealthBG"):SetPoint("TOPLEFT", peek("Portrait"), "BOTTOMLEFT", 0, 10)
					peek("HealthBG"):SetPoint("BOTTOMRIGHT", peek("Portrait"), "BOTTOMRIGHT")
					local line = widget:CreateTexture(nil, "ARTWORK")
					line:SetColorTexture(0, 0, 0)
					line:SetSize(peek("HealthBG"):GetWidth(), E.mult)
					line:SetPoint("BOTTOM", peek("HealthBG"), "TOP")

					peek("Health"):SetHeight(10)
					peek("HealthFrameR"):Hide()
					peek("TextLabel"):SetFontObject("Game12Font")
					peek("TextLabel"):ClearAllPoints()
					peek("TextLabel"):SetPoint("CENTER", peek("HealthBG"), 1, 0)
					peek("TextLabel").__owner = peek("HealthBG")
					hooksecurefunc(peek("TextLabel"), "SetPoint", fixAnchorForModVP)

					peek("Favorite"):ClearAllPoints()
					peek("Favorite"):SetPoint("TOPLEFT", -2, 2)
					peek("Favorite"):SetSize(30, 30)
					peek("Blip"):SetSize(18, 20)
					peek("Blip"):SetPoint("BOTTOMRIGHT", -8, 12)
					peek("RoleB"):Hide()
					peek("Role"):ClearAllPoints()
					peek("Role"):SetPoint("CENTER", widget.bg, "TOPRIGHT", -2, -2)
					hooksecurefunc(peek("Role"), "SetAtlas", replaceFollowerRole)

					local frame = peek("Health"):GetParent()
					if frame then
						frame.__abilities = {}
						frame.__health = peek("Health")
						frame.__role = peek("Role")
						local index1, index2 = GetAbilitiesIndex(frame)
						reskinFollowerAbility(frame, index1, true)
						reskinFollowerAbility(frame, index2)
						peek("HealthBG").__owner = frame
						hooksecurefunc(peek("HealthBG"), "SetGradient", updateVisibleAbilities)
					end
				elseif otype == "ProgressBar" then
					widget:StripTextures()
					module:CreateBDFrame(widget, 1)
				elseif otype == "MissionToast" then
					if not widget.backdrop then
						widget:CreateBackdrop('Tramsparent')
					end
					module:CreateGradient(widget.backdrop)
					if widget.Background then widget.Background:Hide() end
					if widget.Detail then widget.Detail:SetFontObject("Game13Font") end
				elseif otype == "RewardFrame" then
					widget.Quantity.__owner = widget
					hooksecurefunc(widget.Quantity, "SetText", SetAnimaActualCount)
				elseif otype == "MiniHealthBar" then
					local _, r1, r2 = widget:GetRegions()
					r1:Hide()
					r2:Hide()
				end
			end
		end
	end
end

S:AddCallback("SkinGarrisonTooltips")
S:AddCallbackForAddon("Blizzard_GarrisonUI", LoadSkin)

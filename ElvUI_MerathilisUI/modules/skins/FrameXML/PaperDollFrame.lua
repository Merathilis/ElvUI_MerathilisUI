local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select, unpack = pairs, select, unpack
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetItemLevelColor = GetItemLevelColor
local GetSpecializationRole = GetSpecializationRole
local UnitLevel = UnitLevel
local UnitSex = UnitSex
local PaperDollFrame_SetItemLevel = PaperDollFrame_SetItemLevel
local PAPERDOLL_STATCATEGORIES = PAPERDOLL_STATCATEGORIES
local PAPERDOLL_STATINFO = PAPERDOLL_STATINFO
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleCPaperDollFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	local CharacterStatsPane = _G.CharacterStatsPane

	_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local border = slot.IconBorder

		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot:GetHighlightTexture():SetColorTexture(r, g, b, .25)
		slot.SetHighlightTexture = MER.dummy
		slot.icon:SetTexCoord(unpack(E.TexCoords))

		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")
		MERS:CreateBDFrame(slot, .25)
	end

	local function StatsPane(type)
		CharacterStatsPane[type]:StripTextures()
		CharacterStatsPane[type].backdrop:Hide()
	end

	local function CharacterStatFrameCategoryTemplate(Button)
		local bg = Button.Background
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:ClearAllPoints()
		bg:SetPoint("CENTER", 0, -5)
		bg:SetSize(210, 30)
		bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
	end

	if not IsAddOnLoaded("DejaCharacterStats") then
		CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
		CharacterStatsPane.AttributesCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
		CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))

		StatsPane("EnhancementsCategory")
		StatsPane("ItemLevelCategory")
		StatsPane("AttributesCategory")

		CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)


		-- Copied from ElvUI
		local function ColorizeStatPane(frame)
			if frame.leftGrad then frame.leftGrad:Hide() end
			if frame.rightGrad then frame.rightGrad:Hide() end

			frame.leftGrad = frame:CreateTexture(nil, "BORDER")
			frame.leftGrad:SetWidth(80)
			frame.leftGrad:SetHeight(frame:GetHeight())
			frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
			frame.leftGrad:SetTexture(E.media.blankTex)
			frame.leftGrad:SetGradientAlpha("Horizontal", r, g, b, 0.35, r, g, b, 0)

			frame.rightGrad = frame:CreateTexture(nil, "BORDER")
			frame.rightGrad:SetWidth(80)
			frame.rightGrad:SetHeight(frame:GetHeight())
			frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
			frame.rightGrad:SetTexture([[Interface\BUTTONS\WHITE8X8]])
			frame.rightGrad:SetGradientAlpha("Horizontal", r, g, b, 0, r, g, b, 0.35)
		end
		CharacterStatsPane.ItemLevelFrame.Background:SetAlpha(0)
		ColorizeStatPane(CharacterStatsPane.ItemLevelFrame)


		hooksecurefunc("PaperDollFrame_UpdateStats", function()
			local level = UnitLevel("player");
			local categoryYOffset = -5;
			local statYOffset = 0;

			if (not IsAddOnLoaded("DejaCharacterStats")) then
				if ( level >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
					PaperDollFrame_SetItemLevel(CharacterStatsPane.ItemLevelFrame, "player");
					CharacterStatsPane.ItemLevelFrame.Value:SetTextColor(GetItemLevelColor());
					CharacterStatsPane.ItemLevelCategory:Show();
					CharacterStatsPane.ItemLevelFrame:Show();
					CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -76);
				else
					CharacterStatsPane.ItemLevelCategory:Hide();
					CharacterStatsPane.ItemLevelFrame:Hide();
					CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -20);
					categoryYOffset = -12;
					statYOffset = -6;
				end
			end

			local spec = GetSpecialization();
			local role = GetSpecializationRole(spec);

			CharacterStatsPane.statsFramePool:ReleaseAll();
			-- we need a stat frame to first do the math to know if we need to show the stat frame
			-- so effectively we'll always pre-allocate
			local statFrame = CharacterStatsPane.statsFramePool:Acquire();

			local lastAnchor;

			for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
				local catFrame = CharacterStatsPane[PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame];
				local numStatInCat = 0;
				for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
					local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex];
					local showStat = true;
					if ( showStat and stat.primary ) then
						local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
						if ( stat.primary ~= primaryStat ) then
							showStat = false;
						end
					end
					if ( showStat and stat.roles ) then
						local foundRole = false;
						for _, statRole in pairs(stat.roles) do
							if ( role == statRole ) then
								foundRole = true;
								break;
							end
						end
						showStat = foundRole;
					end
					if ( showStat ) then
						statFrame.onEnterFunc = nil;
						PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player");
						if ( not stat.hideAt or stat.hideAt ~= statFrame.numericValue ) then
							if ( numStatInCat == 0 ) then
								if ( lastAnchor ) then
									catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset);
								end
								statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, -2);
							else
								statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset);
							end
							numStatInCat = numStatInCat + 1;
							statFrame.Background:SetShown(false);
							ColorizeStatPane(statFrame)
							statFrame.leftGrad:SetShown((numStatInCat % 2) == 0)
							statFrame.rightGrad:SetShown((numStatInCat % 2) == 0)
							lastAnchor = statFrame;
							-- done with this stat frame, get the next one
							statFrame = CharacterStatsPane.statsFramePool:Acquire();
						end
					end
				end
				catFrame:SetShown(numStatInCat > 0);
			end
			-- release the current stat frame
			CharacterStatsPane.statsFramePool:Release(statFrame);
		end)
	end

	if IsAddOnLoaded("ElvUI_SLE") then
		_G.PaperDollFrame:HookScript("OnShow", function()
			if _G.CharacterStatsPane.DefenceCategory then
				_G.CharacterStatsPane.DefenceCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
				StatsPane("DefenceCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenceCategory)
			end
			if _G.CharacterStatsPane.OffenseCategory then
				_G.CharacterStatsPane.OffenseCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
				StatsPane("OffenseCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
			end
		end)
	end

	-- CharacterFrame Class Texture
	local ClassTexture = _G.ClassTexture
	if not ClassTexture then
		ClassTexture = _G.CharacterFrameInsetRight:CreateTexture(nil, "BORDER")
		ClassTexture:SetPoint("BOTTOM", _G.CharacterFrameInsetRight, "BOTTOM", 0, 40)
		ClassTexture:SetSize(126, 120)
		ClassTexture:SetAlpha(.45)
		ClassTexture:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\classIcons\\CLASS-"..E.myclass)
		ClassTexture:SetDesaturated(true)
	end
end

S:AddCallback("mUIPaperDoll", styleCPaperDollFrame)

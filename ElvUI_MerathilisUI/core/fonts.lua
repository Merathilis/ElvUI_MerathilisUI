local MER, E, L, V, P, G = unpack(select(2, ...))
local LSM = LibStub('LibSharedMedia-3.0')

-- GLOBALS: CHAT_FONT_HEIGHTS, GameTooltipHeader, NumberFont_OutlineThick_Mono_Small, SystemFont_Shadow_Large_Outline
-- GLOBALS: NumberFont_Outline_Huge, NumberFont_Outline_Large, NumberFont_Outline_Med, NumberFont_Shadow_Med
-- GLOBALS: NumberFont_Shadow_Small, QuestFont, SystemFont_Large, GameFontNormalMed3, SystemFont_Shadow_Huge1
-- GLOBALS: SystemFont_Med1, SystemFont_Med3, QuestFont_Large, SystemFont_OutlineThick_Huge2, SystemFont_Outline_Small
-- GLOBALS: SystemFont_Shadow_Large, SystemFont_Shadow_Med1, SystemFont_Shadow_Med3, SystemFont_Shadow_Outline_Huge2
-- GLOBALS: SystemFont_Shadow_Small, SystemFont_Small, SystemFont_Tiny, Tooltip_Med, Tooltip_Small, ZoneTextString
-- GLOBALS: SubZoneTextString, PVPInfoTextString, PVPArenaTextString, CombatTextFont, FriendsFont_Normal, FriendsFont_Small
-- GLOBALS: FriendsFont_Large, FriendsFont_UserText, QuestFont_Shadow_Huge, QuestFont_Shadow_Small, SystemFont_Outline
-- GLOBALS: SystemFont_OutlineThick_WTF, SubZoneTextFont, QuestFont_Super_Huge, QuestFont_Huge, CoreAbilityFont
-- GLOBALS: MailFont_Large, InvoiceFont_Med, InvoiceFont_Small, AchievementFont_Small, ReputationDetailFont
-- GLOBALS: GameFontNormalMed2, BossEmoteNormalHuge, GameFontHighlightMedium, GameFontNormalLarge2, QuestFont_Enormous
-- GLOBALS: DestinyFontHuge, Game24Font, SystemFont_Huge1, SystemFont_Huge1_Outline, NumberFont_Normal_Med
-- GLOBALS: SystemFont_Shadow_Huge2, SystemFont_Shadow_Large2, SystemFont_Shadow_Small2, SystemFont_Small2
-- GLOBALS: Fancy22Font, Fancy24Font, Game30Font, SystemFont_Shadow_Med2, WhiteNormalNumberFont, Game18Font
-- GLOBALS: GameFontHighlightSmall2, GameFontNormalSmall2, GameFontNormalHuge2, Game15Font_o1, Game13FontShadow
-- GLOBALS: NumberFontNormalSmall, SystemFont_Shadow_Huge3, SubSpellFont, GameFont_Gigantic

-- add alpha in shadow color (sa) and moved the r, g, b to the end cause of Blizz auto coloring
local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
	if (not obj) then return end

	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb, sa) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

-- Add some more fonts
E.UpdateBlizzardFontsMui = E.UpdateBlizzardFonts
function E:UpdateBlizzardFonts()
	self:UpdateBlizzardFontsMui()
	local NORMAL     = self["media"].normFont
	local COMBAT     = LSM:Fetch('font', self.private.general.dmgfont)
	local NUMBER     = self["media"].normFont
	local MONOCHROME = ''
	local SHADOWCOLOR = 0, 0, 0, .4 	-- add alpha for shadows
	local NO_OFFSET = 0, 0
	local NORMALOFFSET = 1.25, -1.25 	-- shadow offset for small fonts
	local BIGOFFSET = 2, -2 			-- shadow offset for large fonts

	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	if self.private.general.replaceBlizzFonts then
		-- Base fonts
		--SetFont(NumberFontNormal,					LSM:Fetch('font', 'ElvUI Pixel'), 10, 'MONOCHROMEOUTLINE', 1, 1, 1, 0, 0, 0)
		SetFont(GameTooltipHeader,					NORMAL, self.db.general.fontSize)
		SetFont(NumberFont_OutlineThick_Mono_Small,	NUMBER, self.db.general.fontSize, "OUTLINE")
		SetFont(SystemFont_Shadow_Large_Outline,	NUMBER, 20, "OUTLINE")
		SetFont(NumberFont_Normal_Med,				NORMAL, 14)
		SetFont(NumberFont_Outline_Huge,			NUMBER, 28, "OUTLINE", 28)
		SetFont(NumberFont_Outline_Large,			NUMBER, 15, "OUTLINE")
		SetFont(NumberFont_Outline_Med,				NUMBER, self.db.general.fontSize*1.1, "OUTLINE")
		SetFont(NumberFont_Shadow_Med,				NORMAL, self.db.general.fontSize) --chat editbox uses this
		SetFont(NumberFont_Shadow_Small,			NORMAL, self.db.general.fontSize)
		SetFont(QuestFont,							NORMAL, self.db.general.fontSize)
		SetFont(QuestFont_Large,					NORMAL, 16)
		SetFont(SystemFont_Large,					NORMAL, 15)
		SetFont(GameFontNormalMed3,					NORMAL, 15)
		SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, "OUTLINE") -- Raid Warning, Boss emote frame too
		SetFont(SystemFont_Shadow_Huge2,			NORMAL, 22)
		SetFont(SystemFont_Med1,					NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Med3,					NORMAL, self.db.general.fontSize*1.1)
		SetFont(SystemFont_OutlineThick_Huge2,		NORMAL, 20, MONOCHROME.."THICKOUTLINE")
		SetFont(SystemFont_Outline_Small,			NUMBER, self.db.general.fontSize, "OUTLINE")
		SetFont(SystemFont_Shadow_Large,			NORMAL, 15)
		SetFont(SystemFont_Shadow_Large2,			NORMAL, 18)
		SetFont(SystemFont_Shadow_Med1,				NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Shadow_Med3,				NORMAL, self.db.general.fontSize*1.1)
		SetFont(SystemFont_Shadow_Outline_Huge2,	NORMAL, 20, "OUTLINE")
		SetFont(SystemFont_Shadow_Small,			NORMAL, self.db.general.fontSize*0.9)
		SetFont(SystemFont_Shadow_Small2,			NORMAL, self.db.general.fontSize*0.9)
		SetFont(SystemFont_Small,					NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Small2,					NORMAL, self.db.general.fontSize*0.9)
		SetFont(SystemFont_Tiny,					NORMAL, self.db.general.fontSize)
		SetFont(Tooltip_Med,						NORMAL, self.db.general.fontSize)
		SetFont(Tooltip_Small,						NORMAL, self.db.general.fontSize)
		SetFont(ZoneTextString,						NORMAL, 32, MONOCHROME.."OUTLINE")
		SetFont(SubZoneTextString,					NORMAL, 25, MONOCHROME.."OUTLINE")
		SetFont(PVPInfoTextString,					NORMAL, 22, MONOCHROME.."OUTLINE")
		SetFont(PVPArenaTextString,					NORMAL, 22, MONOCHROME.."OUTLINE")
		SetFont(CombatTextFont,						COMBAT, 200, "OUTLINE") -- number here just increase the font quality.
		SetFont(FriendsFont_Normal,					NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_Small,					NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_Large,					NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_UserText,				NORMAL, self.db.general.fontSize)

		-- new fonts subs
		SetFont(QuestFont_Shadow_Huge, 				NORMAL, 15, nil, SHADOWCOLOR, NORMALOFFSET); -- Quest Title
		SetFont(QuestFont_Shadow_Small, 			NORMAL, 14, nil, SHADOWCOLOR, NORMALOFFSET);
		SetFont(SystemFont_Outline, 				NORMAL, 13, MONOCHROME.."OUTLINE");			 -- Pet level on World map
		SetFont(SystemFont_OutlineThick_WTF,		NORMAL, 32, MONOCHROME.."OUTLINE");			 -- World Map
		SetFont(SubZoneTextFont,					NORMAL, 24, MONOCHROME.."OUTLINE");			 -- World Map(SubZone)
		SetFont(QuestFont_Super_Huge,				NORMAL, 22, nil, SHADOWCOLOR, BIGOFFSET);
		SetFont(QuestFont_Huge,						NORMAL, 15, nil, SHADOWCOLOR, BIGOFFSET);	 -- Quest rewards title(Rewards)
		SetFont(CoreAbilityFont,					NORMAL, 26);								 -- Core abilities(title)
		SetFont(MailFont_Large,						NORMAL, 14);								 -- mail
		SetFont(InvoiceFont_Med,					NORMAL, 12);								 -- mail
		SetFont(InvoiceFont_Small,					NORMAL, self.db.general.fontSize);			 -- mail
		SetFont(AchievementFont_Small,				NORMAL, self.db.general.fontSize);			 -- Achiev dates
		SetFont(ReputationDetailFont,				NORMAL, self.db.general.fontSize);			 -- Rep Desc when clicking a rep
		SetFont(GameFontNormalMed2,					NORMAL, self.db.general.fontSize*1.1);		 -- Quest tracker
		SetFont(BossEmoteNormalHuge,				NORMAL, 24);								 -- Talent Title
		SetFont(GameFontHighlightMedium,			NORMAL, 15);								 -- Fix QuestLog Title mouseover
		SetFont(GameFontNormalLarge2,				NORMAL, 15); 								 -- Garrison Follower Names
		SetFont(QuestFont_Enormous, 				NORMAL, 24, nil, SHADOWCOLOR, NORMALOFFSET); -- Garrison Titles
		SetFont(DestinyFontHuge,					NORMAL, 20, nil, SHADOWCOLOR, BIGOFFSET);	 -- Garrison Mission Report
		SetFont(Game24Font, 						NORMAL, 24);								 -- Garrison Mission level (in detail frame)
		SetFont(SystemFont_Huge1, 					NORMAL, 20);								 -- Garrison Mission XP
		SetFont(SystemFont_Huge1_Outline, 			NORMAL, 18, MONOCHROME.."OUTLINE");			 -- Garrison Mission Chance
		SetFont(Fancy22Font,						NORMAL, 20)									 -- Talking frame Title font
		SetFont(Fancy24Font,						NORMAL, 20)									 -- Artifact frame - weapon name
		SetFont(Game30Font,							NORMAL, 28)									 -- Mission Level
		SetFont(SystemFont_Shadow_Med2,				NORMAL, 13 * 1.1)							 -- Shows Order resourses on OrderHallTalentFrame
		SetFont(SystemFont_Shadow_Med3,				NORMAL, 13 * 1.1)
		SetFont(WhiteNormalNumberFont,				NORMAL, self.db.general.fontSize);			 -- Statusbar Numbers on TradeSkill frame
		SetFont(GameFontHighlightSmall2,			NORMAL, self.db.general.fontSize);			 -- Skill or Recipe description on TradeSkill frame
		SetFont(Game18Font,							NORMAL, 18)									 -- MissionUI Bonus Chance
		SetFont(GameFontNormalSmall2,				NORMAL, 12)			 					 	 -- MissionUI Followers names
		SetFont(GameFontNormalHuge2,				NORMAL, 24)			 					 	 -- Mythic weekly best dungeon name
		SetFont(Game15Font_o1,						NORMAL, 15)									 -- CharacterStatsPane (ItemLevelFrame)
		SetFont(Game13FontShadow,					NORMAL, 14)									 -- InspectPvpFrame
		SetFont(NumberFontNormalSmall,				NORMAL, 11, "OUTLINE")						 -- Calendar, EncounterJournal
		SetFont(SystemFont_Shadow_Huge3,			NORMAL, 22, nil, SHADOWCOLOR, BIGOFFSET);	 -- Flight Map, Zone Name
		SetFont(SubSpellFont, 						NORMAL, 10);
		--SetFont(QuestTitleFontBlackShadow,		NORMAL, 16)
		--SetFont(GameFontHighlightMed2, 			NORMAL, self.db.general.fontSize*1.1);
		--SetFont(GameFontNormalSmall, 				NORMAL, 10);
		--SetFont(GameFontHighlightSmall, 			NORMAL, 10);
		--SetFont(GameFontHighlight, 				NORMAL, self.db.general.fontSize);
		--SetFont(GameFontHighlightLarge,			NORMAL, 15);
		--SetFont(GameFontNormalHuge,				NORMAL, 16);
		--SetFont(SystemFont_InverseShadow_Small, 	NORMAL, 10);
		--SetFont(SystemFont_OutlineThick_Huge4,	NORMAL, 26);
		--SetFont(QuestTitleFont,					NORMAL, 16);
		SetFont(GameFont_Gigantic,				NORMAL, 32, nil, SHADOWCOLOR, BIGOFFSET);		-- Used at the install steps
		--SetFont(GameFontHighlightLarge2,			NORMAL, 14);
		--SetFont(DestinyFontLarge,					NORMAL, 14);
	end
end
local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Chat')
local S = MER:GetModule('MER_Skins')
local CH = E:GetModule('Chat')
local LO = E:GetModule('Layout')

local _G = _G

local format = format
local gsub = gsub
local ipairs = ipairs
local next = next
local pairs = pairs
local select = select
local strfind = strfind
local strjoin = strjoin
local strlen = strlen
local strlower = strlower
local strmatch = strmatch
local strsplit = strsplit
local strsub = strsub
local strupper = strupper
local time = time
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack
local utf8sub = string.utf8sub
local wipe = wipe

local Ambiguate = Ambiguate
local BetterDate = BetterDate
local BNet_GetClientEmbeddedTexture = BNet_GetClientEmbeddedTexture
local BNGetNumFriendInvites = BNGetNumFriendInvites
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local ChatTypeInfo = ChatTypeInfo
local FlashClientIcon = FlashClientIcon
local GetAchievementInfo = GetAchievementInfo
local GetAchievementInfoFromHyperlink = GetAchievementInfoFromHyperlink
local GetAchievementLink = GetAchievementLink
local GetBNPlayerCommunityLink = GetBNPlayerCommunityLink
local GetBNPlayerLink = GetBNPlayerLink
local GetChannelName = GetChannelName
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local GetGuildRosterInfo = GetGuildRosterInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetNumGroupMembers = GetNumGroupMembers
local GetNumGuildMembers = GetNumGuildMembers
local GetPlayerCommunityLink = GetPlayerCommunityLink
local GetPlayerLink = GetPlayerLink
local GMChatFrame_IsGM = GMChatFrame_IsGM
local GMError = GMError
local InCombatLockdown = InCombatLockdown
local InviteUnit = InviteUnit
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local PlaySoundFile = PlaySoundFile
local RemoveExtraSpaces = RemoveExtraSpaces
local RemoveNewlines = RemoveNewlines
local SendMessage = SendMessage
local StaticPopup_Visible = StaticPopup_Visiblelocal
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName

local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local C_ChatInfo_GetChannelRuleset = C_ChatInfo.GetChannelRuleset
local C_ChatInfo_GetChannelRulesetForChannelID = C_ChatInfo.GetChannelRulesetForChannelID
local C_ChatInfo_GetChannelShortcutForChannelID = C_ChatInfo.GetChannelShortcutForChannelID
local C_ChatInfo_IsChannelRegionalForChannelID = C_ChatInfo.IsChannelRegionalForChannelID
local C_Club_GetClubInfo = C_Club.GetClubInfo
local C_Club_GetInfoFromLastCommunityChatLine = C_Club.GetInfoFromLastCommunityChatLine
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local C_Social_GetLastItem = C_Social.GetLastItem
local C_Social_IsSocialEnabled = C_Social.IsSocialEnabled
local C_Timer_After = C_Timer.After

local CHATCHANNELRULESET_MENTOR = Enum.ChatChannelRuleset.Mentor
local NPEV2_CHAT_USER_TAG_GUIDE = gsub(NPEV2_CHAT_USER_TAG_GUIDE, "(|A.-|a).+", "%1")
local PLAYERMENTORSHIPSTATUS_NEWCOMER = Enum.PlayerMentorshipStatus.Newcomer
local PLAYER_REALM = E:ShortenRealm(E.myrealm)
local PLAYER_NAME = format("%s-%s", E.myname, PLAYER_REALM)

module.cache = {}
local lfgRoles = {}
local initRecord = {}

local offlineMessageTemplate = "%s " .. _G.ERR_FRIEND_OFFLINE_S
local offlineMessagePattern = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "(.+)")
offlineMessagePattern = format("^%s$", offlineMessagePattern)

local onlineMessageTemplate = gsub(_G.ERR_FRIEND_ONLINE_SS, "%[%%s%]", "%%s %%s")
local onlineMessagePattern = gsub(_G.ERR_FRIEND_ONLINE_SS, "|Hplayer:%%s|h%[%%s%]|h", "|Hplayer:(.+)|h%%[(.+)%%]|h")
onlineMessagePattern = format("^%s$", onlineMessagePattern)

local achievementMessageTemplate = L["%player% has earned the achievement %achievement%!"]
local achievementMessageTemplateMultiplePlayers = L["%players% have earned the achievement %achievement%!"]

local guildPlayerCache = {}
local blockedMessageCache = {}
local achievementMessageCache = {
	byAchievement = {},
	byPlayer = {}
}

local historyTypes = {
	-- the events set on the chats are still in FindURL_Events, this is used to ignore some types only
	CHAT_MSG_WHISPER = "WHISPER",
	CHAT_MSG_WHISPER_INFORM = "WHISPER",
	CHAT_MSG_BN_WHISPER = "WHISPER",
	CHAT_MSG_BN_WHISPER_INFORM = "WHISPER",
	CHAT_MSG_GUILD = "GUILD",
	CHAT_MSG_GUILD_ACHIEVEMENT = "GUILD",
	CHAT_MSG_OFFICER = "OFFICER",
	CHAT_MSG_PARTY = "PARTY",
	CHAT_MSG_PARTY_LEADER = "PARTY",
	CHAT_MSG_RAID = "RAID",
	CHAT_MSG_RAID_LEADER = "RAID",
	CHAT_MSG_RAID_WARNING = "RAID",
	CHAT_MSG_INSTANCE_CHAT = "INSTANCE",
	CHAT_MSG_INSTANCE_CHAT_LEADER = "INSTANCE",
	CHAT_MSG_CHANNEL = "CHANNEL",
	CHAT_MSG_SAY = "SAY",
	CHAT_MSG_YELL = "YELL",
	CHAT_MSG_EMOTE = "EMOTE" -- this never worked, check it sometime.
}

local roleIcons

module.cache.elvuiRoleIconsPath = {
	Tank = E.Media.Textures.Tank,
	Healer = E.Media.Textures.Healer,
	DPS = E.Media.Textures.DPS
}

module.cache.blizzardRoleIcons = {
	Tank = _G.INLINE_TANK_ICON,
	Healer = _G.INLINE_HEALER_ICON,
	DPS = _G.INLINE_DAMAGER_ICON
}

-- We need to copy it from ElvUI
local specialChatIcons
do --this can save some main file locals
	local x, y          = ':16:16', ':13:25'

	local ElvBlue       = E:TextureString(E.Media.ChatLogos.ElvBlue, y)
	local ElvGreen      = E:TextureString(E.Media.ChatLogos.ElvGreen, y)
	local ElvOrange     = E:TextureString(E.Media.ChatLogos.ElvOrange, y)
	local ElvPurple     = E:TextureString(E.Media.ChatLogos.ElvPurple, y)
	local ElvRed        = E:TextureString(E.Media.ChatLogos.ElvRed, y)
	local ElvYellow     = E:TextureString(E.Media.ChatLogos.ElvYellow, y)
	local ElvSimpy      = E:TextureString(E.Media.ChatLogos.ElvSimpy, y)

	local Bathrobe      = E:TextureString(E.Media.ChatLogos.Bathrobe, x)
	local Rainbow		= E:TextureString(E.Media.ChatLogos.Rainbow,x)
	local Hibiscus		= E:TextureString(E.Media.ChatLogos.Hibiscus,x)
	local Gem			= E:TextureString(E.Media.ChatLogos.Gem,x)
	local Beer			= E:TextureString(E.Media.ChatLogos.Beer,x)
	local PalmTree		= E:TextureString(E.Media.ChatLogos.PalmTree,x)
	local TyroneBiggums = E:TextureString(E.Media.ChatLogos.TyroneBiggums,x)
	local SuperBear		= E:TextureString(E.Media.ChatLogos.SuperBear,x)

	--[[ Simpys Thing: new icon color every message, in order then reversed back, repeating of course
		local a, b, c = 0, false, {ElvRed, ElvOrange, ElvYellow, ElvGreen, ElvBlue, ElvPurple, ElvPink}
		(a = a - (b and 1 or -1) if (b and a == 1 or a == 0) or a == #c then b = not b end return c[a])
	]]

	local itsElv, itsMis, itsSimpy, itsMel, itsThradex, itsPooc
	do	--Simpy Chaos: super cute text coloring function that ignores hyperlinks and keywords
		local e, f, g = {'||','|Helvmoji:.-|h.-|h','|[Cc].-|[Rr]','|[TA].-|[ta]','|H.-|h.-|h'}, {}, {}
		local prettify = function(t,...) return gsub(gsub(E:TextGradient(gsub(gsub(t,'%%%%','\27'),'\124\124','\26'),...),'\27','%%%%'),'\26','||') end
		local protectText = function(t, u, v) local w = E:EscapeString(v) local r, s = strfind(u, w) while f[r] do r, s = strfind(u, w, s) end if r then tinsert(g, r) f[r] = w end return gsub(t, w, '\24') end
		local specialText = function(t,...) local u = t for _, w in ipairs(e) do for k in gmatch(t, w) do t = protectText(t, u, k) end end t = prettify(t,...)
			if next(g) then if #g > 1 then sort(g) end for n in gmatch(t, '\24') do local _, v = next(g) t = gsub(t, n, f[v], 1) tremove(g, 1) f[v] = nil end end return t
		end

		--Simpys: Spring Green (2EFF7E), Vivid Sky Blue (52D9FF), Medium Purple (8D63DB), Ticke Me Pink (FF8EB6), Yellow Orange (FFAF53)
		local SimpyColors = function(t) return specialText(t, 0.18,1.00,0.49, 0.32,0.85,1.00, 0.55,0.38,0.85, 1.00,0.55,0.71, 1.00,0.68,0.32) end
		--Detroit Lions: Honolulu Blue to Silver [Elv: I stoles it @Simpy]
		local ElvColors = function(t) return specialText(t, 0,0.42,0.69, 0.61,0.61,0.61) end
		--Rainbow: FD3E44, FE9849, FFDE4B, 6DFD65, 54C4FC, A35DFA, C679FB, FE81C1
		local MisColors = function(t) return specialText(t, 0.99,0.24,0.26, 0.99,0.59,0.28, 1,0.87,0.29, 0.42,0.99,0.39, 0.32,0.76,0.98, 0.63,0.36,0.98, 0.77,0.47,0.98, 0.99,0.5,0.75) end
		--Mels: Fiery Rose (F94F6D), Saffron (F7C621), Emerald (4FC16D), Medium Slate Blue (7C7AF7), Cyan Process (11AFEA)
		local MelColors = function(t) return specialText(t, 0.98,0.31,0.43, 0.97,0.78,0.13, 0.31,0.76,0.43, 0.49,0.48,0.97, 0.07,0.69,0.92) end
		--Thradex: summer without you
		local ThradexColors = function(t) return specialText(t, 0.00,0.60,0.09, 0.22,0.65,0.90, 0.22,0.65,0.90, 1.00,0.74,0.27, 1.00,0.66,0.00, 1.00,0.50,0.20, 0.92,0.31,0.23) end
		--Repooc: Monk, Demon Hunter, Paladin, Warlock colors
		local PoocsColors = function(t) return specialText(t, 0,1,0.6, 0.64,0.19,0.79, 0.96,0.55,0.73, 0.53,0.53,0.93) end

		itsSimpy = function() return ElvSimpy, SimpyColors end
		itsElv = function() return ElvBlue, ElvColors end
		itsMel = function() return Hibiscus, MelColors end
		itsMis = function() return Rainbow, MisColors end
		itsThradex = function() return PalmTree, ThradexColors end
		itsPooc = function() return ElvBlue, PoocsColors end
	end

	local z = {}
	specialChatIcons = z

	if E.Classic then
		-- Simpy
		z['Simpy-Myzrael']			= itsSimpy -- Warlock
	elseif E.Wrath then
		-- Simpy
		z['Cutepally-Myzrael']		= itsSimpy -- Paladin
		z['Kalline-Myzrael']		= itsSimpy -- Shaman
		z['Imsojelly-Myzrael']		= itsSimpy -- [Horde] DK
		-- Luckyone
		z['Luckyone-Gehennas']		= ElvGreen -- [Horde] Hunter
		z['Luckygrip-Gehennas']		= ElvGreen -- [Horde] DK
		z['Luckyone-Everlook']		= ElvGreen -- [Alliance] Druid
		z['Luckypriest-Everlook']	= ElvGreen -- [Alliance] Priest
		z['Luckyrogue-Everlook']	= ElvGreen -- [Alliance] Rogue
		z['Luckyhunter-Everlook']	= ElvGreen -- [Alliance] Hunter
		z['Luckydk-Everlook']		= ElvGreen -- [Alliance] DK
		z['Luckykek-Everlook']		= ElvGreen -- [Alliance] Shaman
		z['Luckyone-Giantstalker']	= ElvGreen -- [Alliance] Paladin
		-- Repooc
		z['Poocsdk-Mankrik']		= ElvBlue -- [Horde] DK
		z['Repooc-Mankrik']			= ElvBlue
	elseif E.Retail then
		-- Elv
		z['Elv-Spirestone']			= itsElv
		z['Elvz-Spirestone']		= itsElv
		z['Fleshlite-Spirestone']	= itsElv
		z['Elvidan-Spirestone']		= itsElv
		z['Elvilas-Spirestone']		= itsElv
		z['Fraku-Spirestone']		= itsElv
		z['Jarvix-Spirestone']		= itsElv
		z['Watermelon-Spirestone']	= itsElv
		z['Zinxbe-Spirestone']		= itsElv
		z['Whorlock-Spirestone']	= itsElv
		-- Blazeflack
		z['Blazii-Silvermoon']	= ElvBlue -- Priest
		z['Chazii-Silvermoon']	= ElvBlue -- Shaman
		-- Merathilis
		z['Asragoth-Shattrath']		= ElvPurple	-- [Alliance] Warlock
		z['Brítt-Shattrath'] 		= ElvBlue	-- [Alliance] Warrior
		z['Damará-Shattrath']		= ElvRed	-- [Alliance] Paladin
		z['Jazira-Shattrath']		= ElvBlue	-- [Alliance] Priest
		z['Jústice-Shattrath']		= ElvYellow	-- [Alliance] Rogue
		z['Maithilis-Shattrath']	= ElvGreen	-- [Alliance] Monk
		z['Mattdemôn-Shattrath']	= ElvPurple	-- [Alliance] DH
		z['Melisendra-Shattrath']	= ElvBlue	-- [Alliance] Mage
		z['Merathilis-Shattrath']	= ElvOrange	-- [Alliance] Druid
		z['Merathilîs-Shattrath']	= ElvBlue	-- [Alliance] Shaman
		z['Róhal-Shattrath']		= ElvGreen	-- [Alliance] Hunter
		z['Meravoker-Shattrath']	= ElvGreen	-- [Alliance] Hunter
		-- Luckyone
		z['Luckyone-LaughingSkull']		= ElvGreen -- [Horde] Druid
		z['Luckypriest-LaughingSkull']	= ElvGreen -- [Horde] Priest
		z['Luckymonkas-LaughingSkull']	= ElvGreen -- [Horde] Monk
		z['Luckyhunter-LaughingSkull']	= ElvGreen -- [Horde] Hunter
		z['Luckydh-LaughingSkull']		= ElvGreen -- [Horde] DH
		z['Luckymage-LaughingSkull']	= ElvGreen -- [Horde] Mage
		z['Luckypala-LaughingSkull']	= ElvGreen -- [Horde] Paladin
		z['Luckyrogue-LaughingSkull']	= ElvGreen -- [Horde] Rogue
		z['Luckywl-LaughingSkull']		= ElvGreen -- [Horde] Warlock
		z['Luckydk-LaughingSkull']		= ElvGreen -- [Horde] DK
		z['Luckyevoker-LaughingSkull']	= ElvGreen -- [Horde] Evoker
		z['Notlucky-LaughingSkull']		= ElvGreen -- [Horde] Warrior
		z['Unluckyone-LaughingSkull']	= ElvGreen -- [Horde] Shaman
		z['Luckydruid-LaughingSkull']	= ElvGreen -- [Alliance] Druid
		-- Repooc
		z['Sifpooc-Stormrage']			= itsPooc	-- DH
		z['Fragmented-Stormrage']		= itsPooc	-- Warlock
		z['Dapooc-Stormrage']			= itsPooc	-- Druid
		z['Poocvoker-Stormrage']		= itsPooc	-- Evoker
		z['Sifupooc-Spirestone']		= itsPooc	-- Monk
		z['Repooc-Spirestone']			= itsPooc	-- Paladin
		-- Simpy
		z['Arieva-Cenarius']			= itsSimpy -- Hunter
		z['Buddercup-Cenarius']			= itsSimpy -- Rogue
		z['Cutepally-Cenarius']			= itsSimpy -- Paladin
		z['Cuddle-Cenarius']			= itsSimpy -- Mage
		z['Ezek-Cenarius']				= itsSimpy -- DK
		z['Glice-Cenarius']				= itsSimpy -- Warrior
		z['Kalline-Cenarius']			= itsSimpy -- Shaman
		z['Puttietat-Cenarius']			= itsSimpy -- Druid
		z['Simpy-Cenarius']				= itsSimpy -- Warlock
		z['Twigly-Cenarius']			= itsSimpy -- Monk
		z['Imsofire-Cenarius']			= itsSimpy -- [Horde] Evoker
		z['Imsobeefy-Cenarius']			= itsSimpy -- [Horde] Shaman
		z['Imsocheesy-Cenarius']		= itsSimpy -- [Horde] Priest
		z['Imsojelly-Cenarius']			= itsSimpy -- [Horde] DK
		z['Imsojuicy-Cenarius']			= itsSimpy -- [Horde] Druid
		z['Imsopeachy-Cenarius']		= itsSimpy -- [Horde] DH
		z['Imsosalty-Cenarius']			= itsSimpy -- [Horde] Paladin
		z['Imsospicy-Cenarius']			= itsSimpy -- [Horde] Mage
		z['Imsonutty-Cenarius']			= itsSimpy -- [Horde] Hunter
		z['Imsotasty-Cenarius']			= itsSimpy -- [Horde] Monk
		z['Imsosaucy-Cenarius']			= itsSimpy -- [Horde] Warlock
		z['Imsodrippy-Cenarius']		= itsSimpy -- [Horde] Rogue
		z['Lumee-CenarionCircle']		= itsSimpy -- [RP] Evoker
		z['Bunne-CenarionCircle']		= itsSimpy -- [RP] Warrior
		z['Loppie-CenarionCircle']		= itsSimpy -- [RP] Monk
		z['Loppybunny-CenarionCircle']	= itsSimpy -- [RP] Mage
		z['Rubee-CenarionCircle']		= itsSimpy -- [RP] DH
		z['Wennie-CenarionCircle']		= itsSimpy -- [RP] Priest
		-- Melbelle (Simpys Bestie)
		z['Melbelle-Bladefist']		= itsMel -- Hunter
		z['Deathchaser-Bladefist']	= itsMel -- DH
		z['Alyosha-Cenarius']		= itsMel -- Warrior
		z['Dãwn-Cenarius']			= itsMel -- Paladin
		z['Faelen-Cenarius']		= itsMel -- Rogue
		z['Freckles-Cenarius']		= itsMel -- DK
		z['Lõvi-Cenarius']			= itsMel -- Priest
		z['Melbelle-Cenarius']		= itsMel -- Druid
		z['Perìwìnkle-Cenarius']	= itsMel -- Shaman
		z['Pìper-Cenarius']			= itsMel -- Warlock
		z['Spãrkles-Cenarius']		= itsMel -- Mage
		z['Mellybear-Cenarius']		= itsMel -- Hunter
		z['Zuria-Cenarius']			= itsMel -- DH
		z['Tinybubbles-Cenarius']	= itsMel -- Monk
		z['Alykat-Cenarius']		= itsMel -- [Horde] Druid
		z['Alybones-Cenarius']		= itsMel -- [Horde] DK
		z['Alyfreeze-Cenarius']		= itsMel -- [Horde] Mage
		z['Alykins-Cenarius']		= itsMel -- [Horde] DH
		z['Alyrage-Cenarius']		= itsMel -- [Horde] Warrior
		z['Alysneaks-Cenarius']		= itsMel -- [Horde] Rogue
		z['Alytotes-Cenarius']		= itsMel -- [Horde] Shaman
		-- Thradex (Simpys Buddy)
		z['Foam-Area52']			= itsThradex -- Horde
		z['Gur-Area52']				= itsThradex -- Horde
		z['Archmage-Area52']		= itsThradex -- Horde
		z['Counselor-Area52']		= itsThradex -- Horde
		z['Monk-CenarionCircle']	= itsThradex
		z['Thradex-Stormrage']		= itsThradex
		z['Wrecked-Stormrage']		= itsThradex
		z['Tb-Stormrage']			= itsThradex
		-- AcidWeb
		z['Livarax-BurningLegion']		= Gem
		z['Filevandrel-BurningLegion']	= Gem
		z['Akavaya-BurningLegion']		= Gem
		z['Athyneos-BurningLegion']		= Gem
		-- Affinity
		z['Affinichi-Illidan']	= Bathrobe
		z['Affinitii-Illidan']	= Bathrobe
		z['Affinity-Illidan']	= Bathrobe
		z['Uplift-Illidan']		= Bathrobe
		-- Tirain (NOTE: lol)
		z['Tierone-Spirestone']	= TyroneBiggums
		z['Tirain-Spirestone']	= TyroneBiggums
		z['Sinth-Spirestone']	= TyroneBiggums
		z['Tee-Spirestone']		= TyroneBiggums
		z['Teepac-Area52']		= TyroneBiggums
		z['Teekettle-Area52']	= TyroneBiggums
		-- Mis (NOTE: I will forever have the picture you accidently shared of the manikin wearing a strapon burned in my brain)
		z['Twunk-Area52']			= itsMis
		z['Twunkie-Area52']			= itsMis
		z['Misoracle-Area52']		= itsMis
		z['Mismayhem-Area52']		= itsMis
		z['Misdîrect-Area52']		= itsMis
		z['Misdecay-Area52']		= itsMis
		z['Mislust-Area52'] 		= itsMis
		z['Misdivine-Area52']		= itsMis
		z['Mislight-Area52']		= itsMis
		z['Misillidan-Spirestone']	= itsMis
		z['Mispel-Spirestone']		= itsMis
		--Bladesdruid
		z['Bladedemonz-Spirestone']	= SuperBear
		z['Bladesdruid-Spirestone']	= SuperBear
		z['Rollerblade-Spirestone']	= SuperBear
		--Bozaum
		z['Bozaum-Spirestone']	= Beer
	end
end

local logoSmall = F.GetIconString(MER.Media.Textures.smallLogo, 14)
local authorIcons = {
	['Asragoth-Shattrath']		= logoSmall,	-- [Alliance] Warlock
	['Brítt-Shattrath'] 		= logoSmall,	-- [Alliance] Warrior
	['Damará-Shattrath']		= logoSmall,	-- [Alliance] Paladin
	['Jazira-Shattrath']		= logoSmall,	-- [Alliance] Priest
	['Jústice-Shattrath']		= logoSmall,	-- [Alliance] Rogue
	['Maithilis-Shattrath']	= logoSmall,	-- [Alliance] Monk
	['Mattdemôn-Shattrath']	= logoSmall,	-- [Alliance] DH
	['Melisendra-Shattrath']	= logoSmall,	-- [Alliance] Mage
	['Merathilis-Shattrath']	= logoSmall,	-- [Alliance] Druid
	['Merathilîs-Shattrath']	= logoSmall,	-- [Alliance] Shaman
	['Róhal-Shattrath']		= logoSmall,	-- [Alliance] Hunter
	['Meravoker-Shattrath']	= logoSmall	-- [Alliance] Hunter
}

local function updateGuildPlayerCache(self, event)
	if not (event == "PLAYER_ENTERING_WORLD" or event == "FORCE_UPDATE") then
		return
	end

	if not IsInGuild() then
		return
	end

	for i = 1, GetNumGuildMembers() do
		local name, _, _, _, _, _, _, _, _, _, className = GetGuildRosterInfo(i)
		name = Ambiguate(name, "none")
		guildPlayerCache[name] = className
	end
end

local function addSpaceForAsian(text, revert)
	if MER.Locale == "zhCN" or MER.Locale == "zhTW" or MER.Locale == "koKR" then
		return revert and " " .. text or text .. " "
	end
	return text
end

function module:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	if (CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE') then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or CH:GetChatTime())
		timeStamp = gsub(timeStamp, ' $', '')
		timeStamp = timeStamp:gsub('AM', ' AM')
		timeStamp = timeStamp:gsub('PM', ' PM')

		if CH.db.useCustomTimeColor then
			local color = CH.db.customTimeColor
			local hexColor = E:RGBToHex(color.r, color.g, color.b)
			msg = format("%s[%s]|r %s", hexColor, timeStamp, msg)
		else
			msg = format("[%s] %s", timeStamp, msg)
		end
	end

	if CH.db.copyChatLines then
		msg = format('|Hcpl:%s|h%s|h %s', self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ':14'), msg)
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CH:AddMessage(msg, ...)
	return module.AddMessage(self, msg, ...)
end

function CH:ChatFrame_SystemEventHandler(chat, event, message, ...)
	if event == "GUILD_MOTD" then
		if message and message ~= "" then
			local info = ChatTypeInfo["GUILD"]
			local GUILD_MOTD = "GMOTD"
			chat:AddMessage(format('|cff00c0fa%s|r: %s', GUILD_MOTD, message), info.r, info.g, info.b, info.id)
		end
		return true
	else
		return ChatFrame_SystemEventHandler(chat, event, message, ...)
	end
end

function module:StyleVoicePanel()
	if _G.ElvUIChatVoicePanel then
		_G.ElvUIChatVoicePanel:Styling()
		S:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

function module:CreateSeparators()
	if not E.db.mui.chat.seperators.enable then return end

	--Left Chat Tab Separator
	local ltabseparator = CreateFrame('Frame', 'LeftChatTabSeparator', _G.LeftChatPanel, "BackdropTemplate")
	ltabseparator:SetFrameStrata('BACKGROUND')
	ltabseparator:SetFrameLevel(_G.LeftChatPanel:GetFrameLevel() + 2)
	ltabseparator:Height(1)
	ltabseparator:Point('TOPLEFT', _G.LeftChatPanel, 5, -24)
	ltabseparator:Point('TOPRIGHT', _G.LeftChatPanel, -5, -24)
	ltabseparator:SetTemplate('Transparent')
	ltabseparator:Hide()
	_G.LeftChatTabSeparator = ltabseparator

	--Right Chat Tab Separator
	local rtabseparator = CreateFrame('Frame', 'RightChatTabSeparator', _G.RightChatPanel, "BackdropTemplate")
	rtabseparator:SetFrameStrata('BACKGROUND')
	rtabseparator:SetFrameLevel(_G.RightChatPanel:GetFrameLevel() + 2)
	rtabseparator:Height(1)
	rtabseparator:Point('TOPLEFT', _G.RightChatPanel, 5, -24)
	rtabseparator:Point('TOPRIGHT', _G.RightChatPanel, -5, -24)
	rtabseparator:SetTemplate('Transparent')
	rtabseparator:Hide()
	_G.RightChatTabSeparator = rtabseparator

	module:UpdateSeperators()
end
hooksecurefunc(LO, "CreateChatPanels", module.CreateSeparators)

function module:UpdateSeperators()
	if not E.db.mui.chat.seperators.enable then return end

	local myVisibility = E.db.mui.chat.seperators.visibility
	local elvVisibility = E.db.chat.panelBackdrop
	if myVisibility == 'SHOWBOTH' or elvVisibility == 'SHOWBOTH' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
	elseif myVisibility == 'HIDEBOTH' or elvVisibility == 'HIDEBOTH' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	elseif myVisibility == 'LEFT' or elvVisibility == 'LEFT' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	else
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
	end
end

function module:CreateChatButtons()
	if not E.db.mui.chat.chatButton or not E.private.chat.enable then return end

	E.db.mui.chat.expandPanel = 150
	E.db.mui.chat.panelHeight = E.db.mui.chat.panelHeight or E.db.chat.panelHeight

	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"].backdrop)
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", _G["LeftChatPanel"].backdrop, "TOPLEFT", 4, -8)
	ChatButton:Size(13, 13)

	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.55)
	end
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\chatButton")

	ChatButton:SetScript("OnMouseUp", function(self, btn)
		if InCombatLockdown() then return end
		if btn == "LeftButton" then
			if E.db.mui.chat.isExpanded then
				E.db.chat.panelHeight = E.db.chat.panelHeight - E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = false
			else
				E.db.chat.panelHeight = E.db.chat.panelHeight + E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = true
			end
		end
	end)

	ChatButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then return end

		self:SetAlpha(0.8)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 6)
		GameTooltip:ClearLines()
		if E.db.mui.chat.isExpanded then
			GameTooltip:AddLine(F.cOption(L["BACK"]), 'orange')
		else
			GameTooltip:AddLine(F.cOption(L["Expand the chat"]), 'orange')
		end
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)

	ChatButton:SetScript("OnLeave", function(self)
		if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
			self:SetAlpha(0)
		else
			self:SetAlpha(0.55)
		end
		GameTooltip:Hide()
	end)
end

function module:UpdateRoleIcons()
	if not self.db or not self.db.roleIcons.enable then
		return
	end

	local pack = self.db.roleIcons.enable and self.db.roleIcons.roleIconStyle or "DEFAULT"
	local sizeString = self.db.roleIcons.enable and format(":%d:%d", self.db.roleIcons.roleIconSize, self.db.roleIcons.roleIconSize) or ":16:16"

	if pack ~= "DEFAULT" and pack ~= "BLIZZARD" then
		sizeString = sizeString and (sizeString .. ":0:0:64:64:2:62:0:58")
	end

	if pack == "SUNUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.sunTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.sunHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.sunDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "LYNUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.lynTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.lynHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.lynDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "SVUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.svuiTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.svuiHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.svuiDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "DEFAULT" then
		roleIcons = {
			TANK = E:TextureString(module.cache.elvuiRoleIconsPath.Tank, sizeString .. ":0:0:64:64:2:56:2:56"),
			HEALER = E:TextureString(module.cache.elvuiRoleIconsPath.Healer, sizeString .. ":0:0:64:64:2:56:2:56"),
			DAMAGER = E:TextureString(module.cache.elvuiRoleIconsPath.DPS, sizeString)
		}

		_G.INLINE_TANK_ICON = module.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = module.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = module.cache.blizzardRoleIcons.DPS
	elseif pack == "BLIZZARD" then
		roleIcons = {
			TANK = gsub(module.cache.blizzardRoleIcons.Tank, ":16:16", sizeString),
			HEALER = gsub(module.cache.blizzardRoleIcons.Healer, ":16:16", sizeString),
			DAMAGER = gsub(module.cache.blizzardRoleIcons.DPS, ":16:16", sizeString)
		}

		_G.INLINE_TANK_ICON = module.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = module.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = module.cache.blizzardRoleIcons.DPS
	elseif pack == "CUSTOM" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.customTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.customHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.customDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GLOW" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glowTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glowHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glowDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GLOW1" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glow1Tank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glow1Heal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.gravedDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GRAVED" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.gravedTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.gravedHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glow1DPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "MAIN" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.mainTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.mainHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.mainDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "WHITE" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.whiteTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.whiteHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.whiteDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "MATERIAL" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.materialTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.materialHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.materialDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	end
end

function module:CheckLFGRoles()
	if not CH.db.lfgIcons or not IsInGroup() then
		return
	end
	wipe(lfgRoles)

	local playerRole = UnitGroupRolesAssigned("player")
	if playerRole then
		lfgRoles[PLAYER_NAME] = roleIcons[playerRole]
	end

	local unit = (IsInRaid() and "raid" or "party")
	for i = 1, GetNumGroupMembers() do
		if UnitExists(unit .. i) and not UnitIsUnit(unit .. i, "player") then
			local role = UnitGroupRolesAssigned(unit .. i)
			local name, realm = UnitName(unit .. i)

			if role and name then
				name = (realm and realm ~= "" and name .. "-" .. realm) or name .. "-" .. PLAYER_REALM
				lfgRoles[name] = roleIcons[role]
			end
		end
	end
end

function module:AddCustomEmojis()
	--Custom Emojis
	local t = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chatEmojis\\%s:16:16|t"

	-- Twitch Emojis
	CH:AddSmiley(':monkaomega:', format(t, 'monkaomega'))
	CH:AddSmiley(':salt:', format(t, 'salt'))
	CH:AddSmiley(':sadge:', format(t, 'sadge'))
end

-- Hide communities chat. Useful for streamers
-- Credits Nnogga
local commOpen = CreateFrame("Frame", nil, UIParent)
commOpen:RegisterEvent("ADDON_LOADED")
commOpen:RegisterEvent("CHANNEL_UI_UPDATE")
commOpen:SetScript("OnEvent", function(self, event, addonName)
	if event == "ADDON_LOADED" and addonName == "Blizzard_Communities" then
		--create overlay
		local f = CreateFrame("Button", nil, UIParent)
		f:SetFrameStrata("HIGH")

		f.tex = f:CreateTexture(nil, "BACKGROUND")
		f.tex:SetAllPoints()
		f.tex:SetColorTexture(0.1, 0.1, 0.1, 1)

		f.text = f:CreateFontString()
		f.text:FontTemplate(nil, 20, "OUTLINE")
		f.text:SetShadowOffset(-2, 2)
		f.text:SetText(L["Chat Hidden. Click to show"])
		f.text:SetTextColor(F.r, F.g, F.b)
		f.text:SetJustifyH("CENTER")
		f.text:SetJustifyV("MIDDLE")
		f.text:Height(20)
		f.text:Point("CENTER", f, "CENTER", 0, 0)

		f:EnableMouse(true)
		f:RegisterForClicks("AnyUp")
		f:SetScript("OnClick", function(...)
			f:Hide()
		end)

		--toggle
		local function toggleOverlay()
			if _G.CommunitiesFrame:GetDisplayMode() == COMMUNITIES_FRAME_DISPLAY_MODES.CHAT and E.db.mui.chat.hideChat then
				f:SetAllPoints(_G.CommunitiesFrame.Chat.InsetFrame)
				f:Show()
			else
				f:Hide()
			end
		end

		local function hideOverlay()
			f:Hide()
		end
		toggleOverlay() --run once

		--hook
		hooksecurefunc(_G.CommunitiesFrame, "SetDisplayMode", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Show", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Hide", hideOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "OnClubSelected", toggleOverlay)
	end
end)

CH:AddPluginIcons(function(sender)
	if authorIcons[sender] then
		return authorIcons[sender]
	end
end)

-- Copied from ElvUI
local function GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
	-- Renaming for clarity:
	local specialFlag = arg6
	local zoneChannelID = arg7
	--local localChannelID = arg8

	if specialFlag ~= '' then
		if specialFlag == 'GM' or specialFlag == 'DEV' then
			-- Add Blizzard Icon if this was sent by a GM/DEV
			return [[|TInterface\ChatFrame\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ]]
		elseif E.Retail then
			if specialFlag == 'GUIDE' then
				if _G.ChatFrame_GetMentorChannelStatus(CHATCHANNELRULESET_MENTOR, C_ChatInfo_GetChannelRulesetForChannelID(zoneChannelID)) == CHATCHANNELRULESET_MENTOR then
					return NPEV2_CHAT_USER_TAG_GUIDE
				end
			elseif specialFlag == 'NEWCOMER' then
				if _G.ChatFrame_GetMentorChannelStatus(PLAYERMENTORSHIPSTATUS_NEWCOMER, C_ChatInfo_GetChannelRulesetForChannelID(zoneChannelID)) == PLAYERMENTORSHIPSTATUS_NEWCOMER then
					return _G.NPEV2_CHAT_USER_TAG_NEWCOMER
				end
			end
		else
			return _G['CHAT_FLAG_'..specialFlag]
		end
	end

	return ''
end

function module:HandleName(nameString)
	if not nameString or nameString == "" then
		return nameString
	end

	if not self.db or not self.db.enable or not self.db.removeRealm then
		return nameString
	end

	if strsub(nameString, strlen(nameString) - 1) == "|r" then
		nameString = F.Strings.Split(nameString, "-")
		nameString = nameString .. "|r"
	else
		nameString = F.Strings.Split(nameString, "-")
	end

	return nameString
end

-- From ElvUI Chat
local function ChatFrame_CheckAddChannel(chatFrame, eventType, channelID)
	if chatFrame ~= _G.DEFAULT_CHAT_FRAME then
		return false
	end

	if eventType ~= "YOU_CHANGED" then
		return false
	end

	if not C_ChatInfo_IsChannelRegionalForChannelID(channelID) then
		return false
	end

	return _G.ChatFrame_AddChannel(chatFrame, C_ChatInfo_GetChannelShortcutForChannelID(channelID)) ~= nil
end

function module:ChatFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, isHistory, historyTime, historyName, historyBTag)
	-- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
	-- we also send isHistory and historyTime into CH:AddMessage so that we don't have to override the timestamp.
	local noBrackets = module.db.removeBrackets
	local notChatHistory, historySavedName --we need to extend the arguments on CH.ChatFrame_MessageEventHandler so we can properly handle saved names without overriding
	if isHistory == "ElvUI_ChatHistory" then
		if historyBTag then
			arg2 = historyBTag
		end -- swap arg2 (which is a |k string) to btag name
		historySavedName = historyName
	else
		notChatHistory = true
	end

	if _G.TextToSpeechFrame_MessageEventHandler and notChatHistory then
		_G.TextToSpeechFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
	end

	if strsub(event, 1, 8) == "CHAT_MSG" then
		if arg16 then
			return true
		end -- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)

		local chatType = strsub(event, 10)
		local info = _G.ChatTypeInfo[chatType]

		--If it was a GM whisper, dispatch it to the GMChat addon.
		if arg6 == "GM" and chatType == "WHISPER" then
			return
		end

		local chatFilters = _G.ChatFrame_GetMessageEventFilters(event)
		if chatFilters then
			for _, filterFunc in next, chatFilters do
				local filter, new1, new2, new3, new4, new5, new6, new7, new8, new9, new10, new11, new12, new13, new14, new15, new16, new17 = filterFunc(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
				if filter then
					return true
				elseif new1 then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = new1, new2, new3, new4, new5, new6, new7, new8, new9, new10, new11, new12, new13, new14, new15, new16, new17
				end
			end
		end

		-- data from populated guid info
		local nameWithRealm, realm
		local data = CH:GetPlayerInfoByGUID(arg12)
		if data then
			realm = data.realm
			nameWithRealm = data.nameWithRealm
		end

		-- fetch the name color to use
		local coloredName = historySavedName or CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

		local channelLength = strlen(arg4)
		local infoType = chatType

		if type == "VOICE_TEXT" then -- the code here looks weird but its how blizzard has it ~Simpy
			local leader = UnitIsGroupLeader(arg2)
			infoType, type = _G.VoiceTranscription_DetermineChatTypeVoiceTranscription_DetermineChatType(leader)
			info = _G.ChatTypeInfo[infoType]
		elseif
			chatType == "COMMUNITIES_CHANNEL" or
			((strsub(chatType, 1, 7) == "CHANNEL") and (chatType ~= "CHANNEL_LIST") and
			((arg1 ~= "INVITE") or (chatType ~= "CHANNEL_NOTICE_USER")))
		then
			if arg1 == "WRONG_PASSWORD" then
				local _, popup = _G.StaticPopup_Visible("CHAT_CHANNEL_PASSWORD")
				if popup and strupper(popup.data) == strupper(arg9) then
					return -- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
				end
			end

			local found = false
			for index, value in pairs(frame.channelList) do
				if channelLength > strlen(value) then
					-- arg9 is the channel name without the number in front...
					if (arg7 > 0 and frame.zoneChannelList[index] == arg7) or (strupper(value) == strupper(arg9)) then
						found = true

						infoType = "CHANNEL" .. arg8
						info = _G.ChatTypeInfo[infoType]

						if chatType == "CHANNEL_NOTICE" and arg1 == "YOU_LEFT" then
							frame.channelList[index] = nil
							frame.zoneChannelList[index] = nil
						end
						break
					end
				end
			end

			if not found or not info then
				local eventType, channelID = arg1, arg7
				if not ChatFrame_CheckAddChannel(self, eventType, channelID) then
					return true
				end
			end
		end

		local chatGroup = _G.Chat_GetChatCategory(chatType)
		local chatTarget = CH:FCFManager_GetChatTarget(chatGroup, arg2, arg8)

		if _G.FCFManager_ShouldSuppressMessage(frame, chatGroup, chatTarget) then
			return true
		end

		if chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" then
			if frame.privateMessageList and not frame.privateMessageList[strlower(arg2)] then
				return true
			elseif
				frame.excludePrivateMessageList and frame.excludePrivateMessageList[strlower(arg2)] and
				((chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or
				(chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline"))
			then
				return true
			end
		end

		if frame.privateMessageList then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if
				(chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and
				not frame.privateMessageList[strlower(arg2)]
			then
				return true
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if chatGroup == "SYSTEM" then
				local matchFound = false
				local message = strlower(arg1)
				for playerName in pairs(frame.privateMessageList) do
					local playerNotFoundMsg = strlower(format(_G.ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
					local charOnlineMsg = strlower(format(_G.ERR_FRIEND_ONLINE_SS, playerName, playerName))
					local charOfflineMsg = strlower(format(_G.ERR_FRIEND_OFFLINE_S, playerName))
					if message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg then
						matchFound = true
						break
					end
				end

				if not matchFound then
					return true
				end
			end
		end

		if
			(chatType == "SYSTEM" or chatType == "SKILL" or chatType == "CURRENCY" or chatType == "MONEY" or
			chatType == "OPENING" or
			chatType == "TRADESKILLS" or
			chatType == "PET_INFO" or
			chatType == "TARGETICONS" or
			chatType == "BN_WHISPER_PLAYER_OFFLINE")
		then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "LOOT" then
			-- Append [Share] hyperlink if this is a valid social item and you are the looter.
			if arg12 == E.myguid and C_Social_IsSocialEnabled() then
				local itemID, creationContext = GetItemInfoFromHyperlink(arg1)
				if itemID and C_Social_GetLastItem() == itemID then
					arg1 = arg1 .. " " .. _G.Social_GetShareItemLink(creationContext, true)
				end
			end
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 7) == "COMBAT_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 6) == "SPELL_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 10) == "BG_SYSTEM_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 11) == "ACHIEVEMENT" then
			-- Append [Share] hyperlink
			if arg12 == E.myguid and C_Social_IsSocialEnabled() then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if achieveID then
					arg1 = arg1 .. " " .. _G.Social_GetShareAchievementLink(achieveID, true)
				end
			end
			frame:AddMessage(format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", module:HandleName(coloredName)))), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 18) == "GUILD_ACHIEVEMENT" then
			local message =
				format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", module:HandleName(coloredName))))
			if C_Social_IsSocialEnabled() then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if achieveID then
					local isGuildAchievement = select(12, GetAchievementInfo(achieveID))
					if isGuildAchievement then
						message = message .. " " .. _G.Social_GetShareAchievementLink(achieveID, true)
					end
				end
			end
			frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "IGNORED" then
			frame:AddMessage(format(_G.CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "FILTERED" then
			frame:AddMessage(format(_G.CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "RESTRICTED" then
			frame:AddMessage(_G.CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "CHANNEL_LIST" then
			if channelLength > 0 then
				frame:AddMessage(format(_G["CHAT_" .. chatType .. "_GET"] .. arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == "CHANNEL_NOTICE_USER" then
			local globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
			if not globalstring then
				globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
			end
			if not globalstring then
				GMError(format("Missing global string for %q", "CHAT_" .. arg1 .. "_NOTICE_BN"))
				return
			end
			if arg5 ~= "" then
				-- TWO users in this notice (E.G. x kicked y)
				frame:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			elseif arg1 == "INVITE" then
				frame:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				frame:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
			if arg1 == "INVITE" and GetCVarBool("blockChannelInvites") then
				frame:AddMessage(_G.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == "CHANNEL_NOTICE" then
			local accessID = _G.ChatHistory_GetAccessID(chatGroup, arg8)
			local typeID = _G.ChatHistory_GetAccessID(infoType, arg8, arg12)

			if E.Retail and arg1 == "YOU_CHANGED" and C_ChatInfo_GetChannelRuleset(arg8) == CHATCHANNELRULESET_MENTOR then
				_G.ChatFrame_UpdateDefaultChatTarget(frame)
				_G.ChatEdit_UpdateNewcomerEditBoxHint(frame.editBox)
			else
				if E.Retail and arg1 == "YOU_LEFT" then
					_G.ChatEdit_UpdateNewcomerEditBoxHint(frame.editBox, arg8)
				end

				local globalstring
				if arg1 == "TRIAL_RESTRICTED" then
					globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
				else
					globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
					if not globalstring then
						globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
						if not globalstring then
							GMError(format("Missing global string for %q", "CHAT_" .. arg1 .. "_NOTICE"))
							return
						end
					end
				end

				frame:AddMessage(format(globalstring, arg8, _G.ChatFrame_ResolvePrefixedChannelName(arg4)), info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
			end
		elseif chatType == "BN_INLINE_TOAST_ALERT" then
			local globalstring = _G["BN_INLINE_TOAST_" .. arg1]
			if not globalstring then
				GMError(format("Missing global string for %q", "BN_INLINE_TOAST_" .. arg1))
				return
			end

			local message
			if arg1 == "FRIEND_REQUEST" then
				message = globalstring
			elseif arg1 == "FRIEND_PENDING" then
				message = format(_G.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
			elseif arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" then
				message = format(globalstring, arg2)
			elseif arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE" then
				local _, _, battleTag, _, characterName, _, clientProgram = CH.BNGetFriendInfoByID(arg13)

				if clientProgram and clientProgram ~= "" then
					local name = _G.BNet_GetValidatedCharacterName(characterName, battleTag, clientProgram) or ""
					local characterNameText = _G.BNet_GetClientEmbeddedAtlas(clientProgram, 14) .. name
					local linkDisplayText = format(noBrackets and "%s (%s)" or "[%s] (%s)", arg2, characterNameText)
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
					message = format(globalstring, playerLink)
				else
					local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
					message = format(globalstring, playerLink)
				end
			else
				local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
				message = format(globalstring, playerLink)
			end
			frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == "BN_INLINE_TOAST_BROADCAST" then
			if arg1 ~= "" then
				arg1 = RemoveNewlines(RemoveExtraSpaces(arg1))
				local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
				frame:AddMessage(format(_G.BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == "BN_INLINE_TOAST_BROADCAST_INFORM" then
			if arg1 ~= "" then
				frame:AddMessage(_G.BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		else
			local body

			if chatType == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) then
				return
			end

			local showLink = 1
			if strsub(chatType, 1, 7) == "MONSTER" or strsub(chatType, 1, 9) == "RAID_BOSS" then
				showLink = nil

				-- fix blizzard formatting errors from localization strings
				-- arg1 = gsub(arg1, '%%%d', '%%s') -- replace %1 to %s (russian client specific?) [broken since BFA?]
				arg1 = gsub(arg1, "(%d%%)([^%%%a])", "%1%%%2") -- escape percentages that need it [broken since SL?]
				arg1 = gsub(arg1, "(%d%%)$", "%1%%")           -- escape percentages on the end
			else
				arg1 = gsub(arg1, "%%", "%%%%")                -- escape any % characters, as it may otherwise cause an 'invalid option in format' error
			end

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1)

			-- Search for icon links and replace them with texture links.
			arg1 = CH:ChatFrame_ReplaceIconAndGroupExpressions(arg1, arg17, not _G.ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)) -- If arg17 is true, don't convert to raid icons

			--ElvUI: Get class colored name for BattleNet friend
			if chatType == "BN_WHISPER" or chatType == "BN_WHISPER_INFORM" then
				coloredName = historySavedName or CH:GetBNFriendColor(arg2, arg13)
			end

			local playerLink
			local playerLinkDisplayText = coloredName
			local relevantDefaultLanguage = frame.defaultLanguage
			if chatType == "SAY" or chatType == "YELL" then
				relevantDefaultLanguage = frame.alternativeDefaultLanguage
			end
			local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage)
			local usingEmote = (chatType == "EMOTE") or (chatType == "TEXT_EMOTE")

			if usingDifferentLanguage or not usingEmote then
				playerLinkDisplayText = format(noBrackets and "%s" or "[%s]", module:HandleName(coloredName))
			end

			local isCommunityType = chatType == "COMMUNITIES_CHANNEL"
			local playerName, lineID, bnetIDAccount = arg2, arg11, arg13
			if isCommunityType then
				local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
				local messageInfo, clubId, streamId = C_Club_GetInfoFromLastCommunityChatLine()

				if messageInfo ~= nil then
					if isBattleNetCommunity then
						playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					else
						playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					end
				else
					playerLink = playerLinkDisplayText
				end
			else
				if chatType == "BN_WHISPER" or chatType == "BN_WHISPER_INFORM" then
					playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
				elseif ((chatType == "GUILD" or chatType == "TEXT_EMOTE") or arg14) and (nameWithRealm and nameWithRealm ~= playerName) then
					playerName = nameWithRealm
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				else
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				end
			end

			local message = arg1
			if arg14 then --isMobile
				message = _G.ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b) .. message
			end

			-- Player Flags
			local pflag = GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
			local chatIcon, pluginChatIcon = specialChatIcons[playerName], CH:GetPluginIcon(playerName)
			if type(chatIcon) == 'function' then
				local icon, prettify, var1, var2, var3 = chatIcon()
				if prettify and not CH:MessageIsProtected(message) then
					if chatType == 'TEXT_EMOTE' and not usingDifferentLanguage and (showLink and arg2 ~= '') then
						var1, var2, var3 = strmatch(message, '^(.-)(' .. arg2 .. (realm and '%-' .. realm or '') ..
						')(.-)$')
					end

					if var2 then
						if var1 ~= '' then var1 = prettify(var1) end
						if var3 ~= '' then var3 = prettify(var3) end

						message = var1 .. var2 .. var3
					else
						message = prettify(message)
					end
				end

				chatIcon = icon or ''
			end

			-- LFG Role Flags
			local lfgRole = lfgRoles[playerName]
			if lfgRole and (chatType == "PARTY_LEADER" or chatType == "PARTY" or chatType == "RAID" or chatType == "RAID_LEADER" or chatType == "INSTANCE_CHAT" or
				chatType == "INSTANCE_CHAT_LEADER")
			then
				pflag = pflag..lfgRole
			end

			-- Special Chat Icon
			if chatIcon then
				pflag = pflag..chatIcon
			end

			-- Plugin Chat Icon
			if pluginChatIcon then
				pflag = pflag..pluginChatIcon
			end

			if usingDifferentLanguage then
				local languageHeader = "[" .. arg3 .. "] "
				if showLink and arg2 ~= "" then
					body = format(_G["CHAT_" .. chatType .. "_GET"] .. languageHeader .. message, pflag .. playerLink)
				else
					body = format(_G["CHAT_" .. chatType .. "_GET"] .. languageHeader .. message, pflag .. arg2)
				end
			else
				if not showLink or arg2 == "" then
					if chatType == "TEXT_EMOTE" then
						body = message
					else
						body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. arg2, arg2)
					end
				else
					if chatType == "EMOTE" then
						body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. playerLink)
					elseif chatType == "TEXT_EMOTE" and realm then
						if info.colorNameByClass then
							body =
								gsub(
									message,
									arg2 .. "%-" .. realm,
									pflag .. gsub(playerLink, "(|h|c.-)|r|h$", "%1-" .. realm .. "|r|h"),
									1
								)
						else
							body =
								gsub(
									message,
									arg2 .. "%-" .. realm,
									pflag .. gsub(playerLink, "(|h.-)|h$", "%1-" .. realm .. "|h"),
									1
								)
						end
					elseif chatType == "TEXT_EMOTE" then
						body = gsub(message, arg2, pflag .. playerLink, 1)
					elseif chatType == "GUILD_ITEM_LOOTED" then
						body = gsub(message, "$s", GetPlayerLink(arg2, playerLinkDisplayText))
					else
						body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. playerLink)
					end
				end
			end

			-- Add Channel
			if channelLength > 0 then
				body =
					"|Hchannel:channel:" ..
					arg8 .. "|h[" .. _G.ChatFrame_ResolvePrefixedChannelName(arg4) .. "]|h " .. body
			end

			if (chatType ~= "EMOTE" and chatType ~= "TEXT_EMOTE") and (CH.db.shortChannels or CH.db.hideChannels) then
				body = CH:HandleShortChannels(body, CH.db.hideChannels)
			end

			for _, filter in ipairs(CH.PluginMessageFilters) do
				body = filter(body)
			end

			local accessID = _G.ChatHistory_GetAccessID(chatGroup, chatTarget)
			local typeID = _G.ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)

			local alertType =
				notChatHistory and not CH.SoundTimer and not strfind(event, "_INFORM") and
				CH.db.channelAlerts[historyTypes[event]]
			if
				alertType and alertType ~= "None" and arg2 ~= PLAYER_NAME and
				(not CH.db.noAlertInCombat or not InCombatLockdown())
			then
				CH.SoundTimer = E:Delay(5, CH.ThrottleSound)
				PlaySoundFile(E.LSM:Fetch("sound", alertType), "Master")
			end

			frame:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		end

		if notChatHistory and (chatType == "WHISPER" or chatType == "BN_WHISPER") then
			_G.ChatEdit_SetLastTellTarget(arg2, chatType)
			if CH.db.flashClientIcon then
				FlashClientIcon()
			end
		end

		if notChatHistory and not frame:IsShown() then
			if
				(frame == _G.DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or
				(frame ~= _G.DEFAULT_CHAT_FRAME and info.flashTab)
			then
				if not _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS or chatType == "WHISPER" or chatType == "BN_WHISPER" then
					if not _G.FCFManager_ShouldSuppressMessageFlash(frame, chatGroup, chatTarget) then
						_G.FCF_StartAlertFlash(frame)
					end
				end
			end
		end

		return true
	end
end

function module:ToggleReplacement()
	if not self.db then
		return
	end

	-- ChatFrame_AddMessage
	if self.db.enable and self.db.removeBrackets then
		if not initRecord.ChatFrame_AddMessage then
			for _, frameName in ipairs(_G.CHAT_FRAMES) do
				local frame = _G[frameName]
				local id = frame:GetID()
				if id ~= 2 and frame.OldAddMessage then
					frame.AddMessage = module.AddMessage
				end
			end

			initRecord.ChatFrame_AddMessage = true
		end
	else
		if initRecord.ChatFrame_AddMessage then
			for _, frameName in ipairs(_G.CHAT_FRAMES) do
				local frame = _G[frameName]
				local id = frame:GetID()
				if id ~= 2 and frame.OldAddMessage then
					frame.AddMessage = CH.AddMessage
				end
			end
			initRecord.ChatFrame_AddMessage = false
		end
	end

	-- ChatFrame_MessageEventHandler
	-- CheckLFGRoles
	if self.db.enable and (self.db.removeBrackets or self.db.roleIconStyle ~= "DEFAULT" or self.db.roleIconSize ~= 15 or self.db.removeRealm) then
		if not initRecord.ChatFrame_MessageEventHandler then
			module.cache.ChatFrame_MessageEventHandler = CH.ChatFrame_MessageEventHandler
			CH.ChatFrame_MessageEventHandler = module.ChatFrame_MessageEventHandler
			module.cache.CheckLFGRoles = CH.CheckLFGRoles
			CH.CheckLFGRoles = module.CheckLFGRoles

			initRecord.ChatFrame_MessageEventHandler = true
		end
	else
		if initRecord.ChatFrame_MessageEventHandler then
			if module.cache.ChatFrame_MessageEventHandler then
				CH.ChatFrame_MessageEventHandler = module.cache.ChatFrame_MessageEventHandler
				CH.CheckLFGRoles = module.cache.CheckLFGRoles
			end

			initRecord.ChatFrame_MessageEventHandler = false
		end
	end
end

function module.GuildMemberStatusMessageHandler(_, _, msg)
	if not module.db or not module.db.enable or not module.db.guildMemberStatus then
		return
	end

	local name, class, link, resultText

	if blockedMessageCache[msg] then
		return true
	end

	name = strmatch(msg, offlineMessagePattern)
	if not name then
		link, name = strmatch(msg, onlineMessagePattern)
	end

	if name then
		class = guildPlayerCache[name]
		if not class then
			updateGuildPlayerCache(nil, "FORCE_UPDATE")
			class = guildPlayerCache[name]
		end
	end

	if class then
		blockedMessageCache[msg] = true

		C_Timer_After(0.1, function()
			blockedMessageCache[msg] = nil
		end)

		local displayName = module.db.removeRealm and Ambiguate(name, "short") or name
		local coloredName = F.CreateClassColorString(displayName, link and guildPlayerCache[link] or guildPlayerCache[name])

		coloredName = addSpaceForAsian(coloredName)
		local classIcon = F.GetClassIconStringWithStyle(class, module.db.classIconStyle, 16, 16)

		if coloredName and classIcon then
			if link then
				resultText = format(onlineMessageTemplate, link, classIcon, coloredName)
				if module.db.guildMemberStatusInviteLink then
					local MERInviteLink = format("|Hwtinvite:%s|h%s|h", link, F.StringByTemplate(format("[%s]", L["Invite"]), "info"))
					resultText = resultText .. " " .. MERInviteLink
				end
				_G.ChatFrame1:AddMessage(resultText, F.RGBFromTemplate("success"))
			else
				resultText = format(offlineMessageTemplate, classIcon, coloredName)
				_G.ChatFrame1:AddMessage(resultText, F.RGBFromTemplate("danger"))
			end

			return true
		end
	end

	return false
end

function module.SendAchivementMessage()
	if not module.db or not module.db.enable or not module.db.mergeAchievement then
		return
	end

	local channelData = {
		{ event = "CHAT_MSG_GUILD_ACHIEVEMENT", color = ChatTypeInfo.GUILD },
		{ event = "CHAT_MSG_ACHIEVEMENT",       color = ChatTypeInfo.SYSTEM }
	}

	for _, data in ipairs(channelData) do
		local event, color = data.event, data.color
		if achievementMessageCache.byPlayer[event] then
			for playerString, achievementTable in pairs(achievementMessageCache.byPlayer[event]) do
				local players = { strsplit("=", playerString) }

				local achievementLinks = {}
				for achievementID in pairs(achievementTable) do
					tinsert(achievementLinks, GetAchievementLink(achievementID))
				end

				local message = nil

				if #players == 1 then
					message = gsub(achievementMessageTemplate, "%%player%%", addSpaceForAsian(players[1]))
				elseif #players > 1 then
					message = gsub(achievementMessageTemplateMultiplePlayers, "%%players%%", addSpaceForAsian(strjoin(", ", unpack(players))))
				end

				if message then
					message = gsub(message, "%%achievement%%", addSpaceForAsian(strjoin(", ", unpack(achievementLinks)), true))
					_G.ChatFrame1:AddMessage(message, color.r, color.g, color.b)
				end
			end
			wipe(achievementMessageCache.byPlayer[event])
		end
	end
end

function module.AchievementMessageHandler(_, event, ...)
	if not module.db or not module.db.enable or not module.db.mergeAchievement then
		return
	end

	local achievementMessage = select(1, ...)
	local guid = select(12, ...)

	if not guid then
		return
	end

	if not achievementMessageCache.byAchievement[event] then
		achievementMessageCache.byAchievement[event] = {}
	end

	if not achievementMessageCache.byPlayer[event] then
		achievementMessageCache.byPlayer[event] = {}
	end

	local cache = achievementMessageCache.byAchievement[event]
	local cacheByPlayer = achievementMessageCache.byPlayer[event]

	local achievementID = strmatch(achievementMessage, "|Hachievement:(%d+):")
	if not achievementID then
		return
	end

	if not cache[achievementID] then
		cache[achievementID] = {}
		C_Timer_After(0.1, function()
			local players = {}
			for k in pairs(cache[achievementID]) do
				tinsert(players, k)
			end

			if #players >= 1 then
				local playerString = strjoin("=", unpack(players))

				if not cacheByPlayer[playerString] then
					cacheByPlayer[playerString] = {}
				end

				cacheByPlayer[playerString][achievementID] = true

				if not module.waitForAchievementMessage then
					module.waitForAchievementMessage = true
					C_Timer_After(0.2, function()
						module.SendAchivementMessage()
						module.waitForAchievementMessage = false
					end)
				end
			end

			cache[achievementID] = nil
		end)
	end

	local playerInfo = CH:GetPlayerInfoByGUID(guid)
	if not playerInfo or not playerInfo.englishClass or not playerInfo.name or not playerInfo.nameWithRealm then
		return
	end

	local displayName = module.db.removeRealm and playerInfo.name or playerInfo.nameWithRealm
	local coloredName = F.CreateClassColorString(displayName, playerInfo.englishClass)
	local classIcon = F.GetClassIconStringWithStyle(playerInfo.englishClass, module.db.classIconStyle, 16, 16)

	if coloredName and classIcon and cache[achievementID] then
		local playerName = format("|Hplayer:%s|h%s %s|h", playerInfo.nameWithRealm, classIcon, coloredName)
		cache[achievementID][playerName] = true
		return true
	end
end

function module:BetterSystemMessage()
	if not module.db then
		return
	end

	if module.db.guildMemberStatus and not module.isSystemMessageHandled then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", module.GuildMemberStatusMessageHandler)

		local setHyperlink = _G.ItemRefTooltip.SetHyperlink
		function _G.ItemRefTooltip:SetHyperlink(data, ...)
			if strsub(data, 1, 8) == "wtinvite" then
				local player = strmatch(data, "wtinvite:(.+)")
				if player then
					C_PartyInfo_InviteUnit(player)
					return
				end
			end
			setHyperlink(self, data, ...)
		end

		module.isSystemMessageHandled = true
	end

	if module.db.mergeAchievement and not module.isAchievementHandled then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", module.AchievementMessageHandler)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", module.AchievementMessageHandler)
		module.isAchievementHandled = true
	end
end

function module:Initialize()
	module.db = E.db.mui.chat
	if not module.db or not E.private.chat.enable then
		return
	end

	module:StyleVoicePanel()
	module:DamageMeterFilter()
	module:LoadChatFade()
	module:UpdateSeperators()
	module:CreateChatButtons()
	module:UpdateRoleIcons()
	module:ToggleReplacement()
	module:AddCustomEmojis()
	module:CheckLFGRoles()
	module:BetterSystemMessage()

	if E.Retail then
		module:ChatFilter()
	end
end

function module:ProfileUpdate()
	module.db = E.db.mui.chat
	if not module.db then
		return
	end

	module:UpdateRoleIcons()
	module:ToggleReplacement()
	module:AddCustomEmojis()
	module:CheckLFGRoles()
	module:BetterSystemMessage()
end

MER:RegisterModule(module:GetName())

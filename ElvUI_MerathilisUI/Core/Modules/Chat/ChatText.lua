local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local CT = MER:GetModule('MER_ChatText')
local CH = E:GetModule("Chat")
local LSM = E.Libs.LSM

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
local type = type
local unpack = unpack
local utf8sub = string.utf8sub
local wipe = wipe

local Ambiguate = Ambiguate
local BetterDate = BetterDate
local BNet_GetClientEmbeddedTexture = BNet_GetClientEmbeddedTexture
local BNGetNumFriends = BNGetNumFriends
local BNGetNumFriendInvites = BNGetNumFriendInvites
local FlashClientIcon = FlashClientIcon
local GetAchievementLink = GetAchievementLink
local GetBNPlayerCommunityLink = GetBNPlayerCommunityLink
local GetBNPlayerLink = GetBNPlayerLink
local GetChannelName = GetChannelName
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local GetGuildRosterInfo = GetGuildRosterInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetNumGuildMembers = GetNumGuildMembers
local GetPlayerCommunityLink = GetPlayerCommunityLink
local GetPlayerLink = GetPlayerLink
local GMChatFrame_IsGM = GMChatFrame_IsGM
local GMError = GMError
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local PlaySoundFile = PlaySoundFile
local RemoveExtraSpaces = RemoveExtraSpaces
local RemoveNewlines = RemoveNewlines
local StaticPopup_Visible = StaticPopup_Visiblelocal
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_ChatInfo_GetChannelRuleset = C_ChatInfo.GetChannelRuleset
local C_ChatInfo_GetChannelRulesetForChannelID = C_ChatInfo.GetChannelRulesetForChannelID
local C_ChatInfo_GetChannelShortcutForChannelID = C_ChatInfo.GetChannelShortcutForChannelID
local C_ChatInfo_IsChannelRegionalForChannelID = C_ChatInfo.IsChannelRegionalForChannelID
local C_Club_GetClubInfo = C_Club.GetClubInfo
local C_Club_GetInfoFromLastCommunityChatLine = C_Club.GetInfoFromLastCommunityChatLine
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local C_Texture_GetTitleIconTexture = C_Texture and C_Texture.GetTitleIconTexture
local C_Timer_After = C_Timer.After

local CHATCHANNELRULESET_MENTOR = Enum.ChatChannelRuleset.Mentor
local NPEV2_CHAT_USER_TAG_GUIDE = E.Retail and gsub(NPEV2_CHAT_USER_TAG_GUIDE, "(|A.-|a).+", "%1")
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local PLAYER_REALM = E:ShortenRealm(E.myrealm)
local PLAYER_NAME = format("%s-%s", E.myname, PLAYER_REALM)
local PLAYERMENTORSHIPSTATUS_NEWCOMER = Enum.PlayerMentorshipStatus and Enum.PlayerMentorshipStatus.Newcomer
local TitleIconVersion_Small = Enum.TitleIconVersion and Enum.TitleIconVersion.Small
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE

CT.cache = {}
local lfgRoles = {}
local initRecord = {}

local factionTextures = {
	["Neutral"] = [[Interface\Addons\ElvUI_MerathilisUI\Core\Media\FriendList\GameIcons\WoW]],
	["Alliance"] = [[Interface\Addons\ElvUI_MerathilisUI\Core\Media\FriendList\GameIcons\Alliance]],
	["Horde"] = [[Interface\Addons\ElvUI_MerathilisUI\Core\Media\FriendList\GameIcons\Horde]]
}

local offlineMessageTemplate = "%s" .. _G.ERR_FRIEND_OFFLINE_S
local offlineMessagePattern = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "(.+)")
offlineMessagePattern = format("^%s$", offlineMessagePattern)

local onlineMessageTemplate = gsub(_G.ERR_FRIEND_ONLINE_SS, "%[%%s%]", "%%s%%s")
local onlineMessagePattern = gsub(_G.ERR_FRIEND_ONLINE_SS, "|Hplayer:%%s|h%[%%s%]|h", "|Hplayer:(.+)|h%%[(.+)%%]|h")
onlineMessagePattern = format("^%s$", onlineMessagePattern)

local achievementMessageTemplate = L["%player% has earned the achievement %achievement%!"]
local achievementMessageTemplateMultiplePlayers = L["%players% have earned the achievement %achievement%!"]

local bnetFriendOnlineMessageTemplate = L["%players% (%bnet%) has come online."]
local bnetFriendOfflineMessageTemplate = L["%players% (%bnet%) has gone offline."]

local guildPlayerCache = {}
local achievementMessageCache = {
	byAchievement = {},
	byPlayer = {}
}

local elvuiAbbrStrings = {
	GUILD = L["G"],
	PARTY = L["P"],
	RAID = L["R"],
	OFFICER = L["O"],
	PARTY_LEADER = L["PL"],
	RAID_LEADER = L["RL"],
	INSTANCE_CHAT = L["I"],
	INSTANCE_CHAT_LEADER = L["IL"],
	PET_BATTLE_COMBAT_LOG = _G.PET_BATTLE_COMBAT_LOG
}

local abbrStrings = {
	GUILD = L["[ABBR] Guild"],
	PARTY = L["[ABBR] Party"],
	RAID = L["[ABBR] Raid"],
	OFFICER = L["[ABBR] Officer"],
	PARTY_LEADER = L["[ABBR] Party Leader"],
	RAID_LEADER = L["[ABBR] Raid Leader"],
	RAID_WARNING = L["[ABBR] Raid Warning"],
	INSTANCE_CHAT = L["[ABBR] Instance"],
	INSTANCE_CHAT_LEADER = L["[ABBR] Instance Leader"],
	PET_BATTLE_COMBAT_LOG = _G.PET_BATTLE_COMBAT_LOG
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

CT.cache.elvuiRoleIconsPath = {
	Tank = E.Media.Textures.Tank,
	Healer = E.Media.Textures.Healer,
	DPS = E.Media.Textures.DPS
}

CT.cache.blizzardRoleIcons = {
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
	local Rainbow       = E:TextureString(E.Media.ChatLogos.Rainbow, x)
	local Hibiscus      = E:TextureString(E.Media.ChatLogos.Hibiscus, x)
	local Gem           = E:TextureString(E.Media.ChatLogos.Gem, x)
	local Beer          = E:TextureString(E.Media.ChatLogos.Beer, x)
	local PalmTree      = E:TextureString(E.Media.ChatLogos.PalmTree, x)
	local TyroneBiggums = E:TextureString(E.Media.ChatLogos.TyroneBiggums, x)
	local SuperBear     = E:TextureString(E.Media.ChatLogos.SuperBear, x)

	--[[ Simpys Thing: new icon color every message, in order then reversed back, repeating of course
		local a, b, c = 0, false, {ElvRed, ElvOrange, ElvYellow, ElvGreen, ElvBlue, ElvPurple, ElvPink}
		(a = a - (b and 1 or -1) if (b and a == 1 or a == 0) or a == #c then b = not b end return c[a])
	]]
	local itsElv, itsMis, itsSimpy, itsMel, itsThradex, itsPooc
	do --Simpy Chaos: super cute text coloring function that ignores hyperlinks and keywords
		local e, f, g = { '||', '|Helvmoji:.-|h.-|h', '|[Cc].-|[Rr]', '|[TA].-|[ta]', '|H.-|h.-|h' }, {}, {}
		local prettify = function(t, ...) return gsub(
			gsub(E:TextGradient(gsub(gsub(t, '%%%%', '\27'), '\124\124', '\26'), ...), '\27', '%%%%'), '\26', '||') end
		local protectText = function(t, u, v)
			local w = E:EscapeString(v)
			local r, s = strfind(u, w)
			while f[r] do r, s = strfind(u, w, s) end
			if r then
				tinsert(g, r)
				f[r] = w
			end
			return gsub(t, w, '\24')
		end
		local specialText = function(t, ...)
			local u = t
			for _, w in ipairs(e) do for k in gmatch(t, w) do t = protectText(t, u, k) end end
			t = prettify(t, ...)
			if next(g) then
				if #g > 1 then sort(g) end
				for n in gmatch(t, '\24') do
					local _, v = next(g)
					t = gsub(t, n, f[v], 1)
					tremove(g, 1)
					f[v] = nil
				end
			end
			return t
		end

		--Simpys: Spring Green (2EFF7E), Vivid Sky Blue (52D9FF), Medium Purple (8D63DB), Ticke Me Pink (FF8EB6), Yellow Orange (FFAF53)
		local SimpyColors = function(t) return specialText(t, 0.18, 1.00, 0.49, 0.32, 0.85, 1.00, 0.55, 0.38, 0.85, 1.00,
			0.55, 0.71, 1.00, 0.68, 0.32) end
		--Detroit Lions: Honolulu Blue to Silver [Elv: I stoles it @Simpy]
		local ElvColors = function(t) return specialText(t, 0, 0.42, 0.69, 0.61, 0.61, 0.61) end
		--Rainbow: FD3E44, FE9849, FFDE4B, 6DFD65, 54C4FC, A35DFA, C679FB, FE81C1
		local MisColors = function(t) return specialText(t, 0.99, 0.24, 0.26, 0.99, 0.59, 0.28, 1, 0.87, 0.29, 0.42, 0.99,
			0.39, 0.32, 0.76, 0.98, 0.63, 0.36, 0.98, 0.77, 0.47, 0.98, 0.99, 0.5, 0.75) end
		--Mels: Fiery Rose (F94F6D), Saffron (F7C621), Emerald (4FC16D), Medium Slate Blue (7C7AF7), Cyan Process (11AFEA)
		local MelColors = function(t) return specialText(t, 0.98, 0.31, 0.43, 0.97, 0.78, 0.13, 0.31, 0.76, 0.43, 0.49,
			0.48, 0.97, 0.07, 0.69, 0.92) end
		--Thradex: summer without you
		local ThradexColors = function(t) return specialText(t, 0.00, 0.60, 0.09, 0.22, 0.65, 0.90, 0.22, 0.65, 0.90,
			1.00, 0.74, 0.27, 1.00, 0.66, 0.00, 1.00, 0.50, 0.20, 0.92, 0.31, 0.23) end
		--Repooc: Monk, Demon Hunter, Paladin, Warlock colors
		local PoocsColors = function(t) return specialText(t, 0, 1, 0.6, 0.64, 0.19, 0.79, 0.96, 0.55, 0.73, 0.53, 0.53,
			0.93) end

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
		z['Simpy-Myzrael'] = itsSimpy -- Warlock
	elseif E.Wrath then
		-- Simpy
		z['Cutepally-Myzrael']     = itsSimpy -- Paladin
		z['Kalline-Myzrael']       = itsSimpy -- Shaman
		z['Imsojelly-Myzrael']     = itsSimpy -- [Horde] DK
		-- Luckyone
		z['Luckyone-Gehennas']     = ElvGreen -- [Horde] Hunter
		z['Luckygrip-Gehennas']    = ElvGreen -- [Horde] DK
		z['Luckyone-Everlook']     = ElvGreen -- [Alliance] Druid
		z['Luckypriest-Everlook']  = ElvGreen -- [Alliance] Priest
		z['Luckyrogue-Everlook']   = ElvGreen -- [Alliance] Rogue
		z['Luckyhunter-Everlook']  = ElvGreen -- [Alliance] Hunter
		z['Luckydk-Everlook']      = ElvGreen -- [Alliance] DK
		z['Luckykek-Everlook']     = ElvGreen -- [Alliance] Shaman
		z['Luckyone-Giantstalker'] = ElvGreen -- [Alliance] Paladin
		-- Repooc
		z['Poocsdk-Mankrik']       = ElvBlue -- [Horde] DK
		z['Repooc-Mankrik']        = ElvBlue
	elseif E.Retail then
		-- Elv
		z['Elv-Spirestone']            = itsElv
		z['Elvz-Spirestone']           = itsElv
		z['Fleshlite-Spirestone']      = itsElv
		z['Elvidan-Spirestone']        = itsElv
		z['Elvilas-Spirestone']        = itsElv
		z['Fraku-Spirestone']          = itsElv
		z['Jarvix-Spirestone']         = itsElv
		z['Watermelon-Spirestone']     = itsElv
		z['Zinxbe-Spirestone']         = itsElv
		z['Whorlock-Spirestone']       = itsElv
		-- Blazeflack
		z['Blazii-Silvermoon']         = ElvBlue -- Priest
		z['Chazii-Silvermoon']         = ElvBlue -- Shaman
		-- Merathilis
		z['Asragoth-Shattrath']        = ElvPurple -- [Alliance] Warlock
		z['Brítt-Shattrath']          = ElvBlue -- [Alliance] Warrior
		z['Damará-Shattrath']         = ElvRed -- [Alliance] Paladin
		z['Jazira-Shattrath']          = ElvBlue -- [Alliance] Priest
		z['Jústice-Shattrath']        = ElvYellow -- [Alliance] Rogue
		z['Maithilis-Shattrath']       = ElvGreen -- [Alliance] Monk
		z['Mattdemôn-Shattrath']      = ElvPurple -- [Alliance] DH
		z['Melisendra-Shattrath']      = ElvBlue -- [Alliance] Mage
		z['Merathilis-Shattrath']      = ElvOrange -- [Alliance] Druid
		z['Merathilîs-Shattrath']     = ElvBlue -- [Alliance] Shaman
		z['Róhal-Shattrath']          = ElvGreen -- [Alliance] Hunter
		z['Meravoker-Shattrath']       = ElvGreen -- [Alliance] Hunter
		-- Luckyone
		z['Luckyone-LaughingSkull']    = ElvGreen -- [Horde] Druid
		z['Luckypriest-LaughingSkull'] = ElvGreen -- [Horde] Priest
		z['Luckymonkas-LaughingSkull'] = ElvGreen -- [Horde] Monk
		z['Luckyhunter-LaughingSkull'] = ElvGreen -- [Horde] Hunter
		z['Luckydh-LaughingSkull']     = ElvGreen -- [Horde] DH
		z['Luckymage-LaughingSkull']   = ElvGreen -- [Horde] Mage
		z['Luckypala-LaughingSkull']   = ElvGreen -- [Horde] Paladin
		z['Luckyrogue-LaughingSkull']  = ElvGreen -- [Horde] Rogue
		z['Luckywl-LaughingSkull']     = ElvGreen -- [Horde] Warlock
		z['Luckydk-LaughingSkull']     = ElvGreen -- [Horde] DK
		z['Luckyevoker-LaughingSkull'] = ElvGreen -- [Horde] Evoker
		z['Notlucky-LaughingSkull']    = ElvGreen -- [Horde] Warrior
		z['Unluckyone-LaughingSkull']  = ElvGreen -- [Horde] Shaman
		z['Luckydruid-LaughingSkull']  = ElvGreen -- [Alliance] Druid
		-- Repooc
		z['Sifpooc-Stormrage']         = itsPooc -- DH
		z['Fragmented-Stormrage']      = itsPooc -- Warlock
		z['Dapooc-Stormrage']          = itsPooc -- Druid
		z['Poocvoker-Stormrage']       = itsPooc -- Evoker
		z['Sifupooc-Spirestone']       = itsPooc -- Monk
		z['Repooc-Spirestone']         = itsPooc -- Paladin
		-- Simpy
		z['Arieva-Cenarius']           = itsSimpy -- Hunter
		z['Buddercup-Cenarius']        = itsSimpy -- Rogue
		z['Cutepally-Cenarius']        = itsSimpy -- Paladin
		z['Cuddle-Cenarius']           = itsSimpy -- Mage
		z['Ezek-Cenarius']             = itsSimpy -- DK
		z['Glice-Cenarius']            = itsSimpy -- Warrior
		z['Kalline-Cenarius']          = itsSimpy -- Shaman
		z['Puttietat-Cenarius']        = itsSimpy -- Druid
		z['Simpy-Cenarius']            = itsSimpy -- Warlock
		z['Twigly-Cenarius']           = itsSimpy -- Monk
		z['Imsofire-Cenarius']         = itsSimpy -- [Horde] Evoker
		z['Imsobeefy-Cenarius']        = itsSimpy -- [Horde] Shaman
		z['Imsocheesy-Cenarius']       = itsSimpy -- [Horde] Priest
		z['Imsojelly-Cenarius']        = itsSimpy -- [Horde] DK
		z['Imsojuicy-Cenarius']        = itsSimpy -- [Horde] Druid
		z['Imsopeachy-Cenarius']       = itsSimpy -- [Horde] DH
		z['Imsosalty-Cenarius']        = itsSimpy -- [Horde] Paladin
		z['Imsospicy-Cenarius']        = itsSimpy -- [Horde] Mage
		z['Imsonutty-Cenarius']        = itsSimpy -- [Horde] Hunter
		z['Imsotasty-Cenarius']        = itsSimpy -- [Horde] Monk
		z['Imsosaucy-Cenarius']        = itsSimpy -- [Horde] Warlock
		z['Imsodrippy-Cenarius']       = itsSimpy -- [Horde] Rogue
		z['Lumee-CenarionCircle']      = itsSimpy -- [RP] Evoker
		z['Bunne-CenarionCircle']      = itsSimpy -- [RP] Warrior
		z['Loppie-CenarionCircle']     = itsSimpy -- [RP] Monk
		z['Loppybunny-CenarionCircle'] = itsSimpy -- [RP] Mage
		z['Rubee-CenarionCircle']      = itsSimpy -- [RP] DH
		z['Wennie-CenarionCircle']     = itsSimpy -- [RP] Priest
		-- Melbelle (Simpys Bestie)
		z['Melbelle-Bladefist']        = itsMel -- Hunter
		z['Deathchaser-Bladefist']     = itsMel -- DH
		z['Alyosha-Cenarius']          = itsMel -- Warrior
		z['Dãwn-Cenarius']            = itsMel -- Paladin
		z['Faelen-Cenarius']           = itsMel -- Rogue
		z['Freckles-Cenarius']         = itsMel -- DK
		z['Lõvi-Cenarius']            = itsMel -- Priest
		z['Melbelle-Cenarius']         = itsMel -- Druid
		z['Perìwìnkle-Cenarius']     = itsMel -- Shaman
		z['Pìper-Cenarius']           = itsMel -- Warlock
		z['Spãrkles-Cenarius']        = itsMel -- Mage
		z['Mellybear-Cenarius']        = itsMel -- Hunter
		z['Zuria-Cenarius']            = itsMel -- DH
		z['Tinybubbles-Cenarius']      = itsMel -- Monk
		z['Alykat-Cenarius']           = itsMel -- [Horde] Druid
		z['Alybones-Cenarius']         = itsMel -- [Horde] DK
		z['Alyfreeze-Cenarius']        = itsMel -- [Horde] Mage
		z['Alykins-Cenarius']          = itsMel -- [Horde] DH
		z['Alyrage-Cenarius']          = itsMel -- [Horde] Warrior
		z['Alysneaks-Cenarius']        = itsMel -- [Horde] Rogue
		z['Alytotes-Cenarius']         = itsMel -- [Horde] Shaman
		-- Thradex (Simpys Buddy)
		z['Foam-Area52']               = itsThradex -- Horde
		z['Gur-Area52']                = itsThradex -- Horde
		z['Archmage-Area52']           = itsThradex -- Horde
		z['Counselor-Area52']          = itsThradex -- Horde
		z['Monk-CenarionCircle']       = itsThradex
		z['Thradex-Stormrage']         = itsThradex
		z['Wrecked-Stormrage']         = itsThradex
		z['Tb-Stormrage']              = itsThradex
		-- AcidWeb
		z['Livarax-BurningLegion']     = Gem
		z['Filevandrel-BurningLegion'] = Gem
		z['Akavaya-BurningLegion']     = Gem
		z['Athyneos-BurningLegion']    = Gem
		-- Affinity
		z['Affinichi-Illidan']         = Bathrobe
		z['Affinitii-Illidan']         = Bathrobe
		z['Affinity-Illidan']          = Bathrobe
		z['Uplift-Illidan']            = Bathrobe
		-- Tirain (NOTE: lol)
		z['Tierone-Spirestone']        = TyroneBiggums
		z['Tirain-Spirestone']         = TyroneBiggums
		z['Sinth-Spirestone']          = TyroneBiggums
		z['Tee-Spirestone']            = TyroneBiggums
		z['Teepac-Area52']             = TyroneBiggums
		z['Teekettle-Area52']          = TyroneBiggums
		-- Mis (NOTE: I will forever have the picture you accidently shared of the manikin wearing a strapon burned in my brain)
		z['Twunk-Area52']              = itsMis
		z['Twunkie-Area52']            = itsMis
		z['Misoracle-Area52']          = itsMis
		z['Mismayhem-Area52']          = itsMis
		z['Misdîrect-Area52']         = itsMis
		z['Misdecay-Area52']           = itsMis
		z['Mislust-Area52']            = itsMis
		z['Misdivine-Area52']          = itsMis
		z['Mislight-Area52']           = itsMis
		z['Misillidan-Spirestone']     = itsMis
		z['Mispel-Spirestone']         = itsMis
		--Bladesdruid
		z['Bladedemonz-Spirestone']    = SuperBear
		z['Bladesdruid-Spirestone']    = SuperBear
		z['Rollerblade-Spirestone']    = SuperBear
		--Bozaum
		z['Bozaum-Spirestone']         = Beer
	end
end

local logoSmall = F.GetIconString(MER.Media.Textures.smallLogo, 14)
local authorIcons = {
	['Asragoth-Shattrath']    = logoSmall, -- [Alliance] Warlock
	['Brítt-Shattrath']      = logoSmall, -- [Alliance] Warrior
	['Damará-Shattrath']     = logoSmall, -- [Alliance] Paladin
	['Jazira-Shattrath']      = logoSmall, -- [Alliance] Priest
	['Jústice-Shattrath']    = logoSmall, -- [Alliance] Rogue
	['Maithilis-Shattrath']   = logoSmall, -- [Alliance] Monk
	['Mattdemôn-Shattrath']  = logoSmall, -- [Alliance] DH
	['Melisendra-Shattrath']  = logoSmall, -- [Alliance] Mage
	['Merathilis-Shattrath']  = logoSmall, -- [Alliance] Druid
	['Merathilîs-Shattrath'] = logoSmall, -- [Alliance] Shaman
	['Róhal-Shattrath']      = logoSmall, -- [Alliance] Hunter
	['Meravoker-Shattrath']   = logoSmall -- [Alliance] Hunter
}

CH:AddPluginIcons(function(sender)
	if authorIcons[sender] then
		return authorIcons[sender]
	end
end)

-- From ElvUI Chat
local function GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
	local specialFlag = arg6
	local zoneChannelID = arg7

	if specialFlag ~= "" then
		if specialFlag == "GM" or specialFlag == "DEV" then
			return [[|TInterface\ChatFrame\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ]]
		elseif specialFlag == "GUIDE" then
			if _G.ChatFrame_GetMentorChannelStatus(CHATCHANNELRULESET_MENTOR, C_ChatInfo_GetChannelRulesetForChannelID(zoneChannelID)) == CHATCHANNELRULESET_MENTOR then
				return NPEV2_CHAT_USER_TAG_GUIDE
			end
		elseif specialFlag == "NEWCOMER" then
			if _G.ChatFrame_GetMentorChannelStatus(PLAYERMENTORSHIPSTATUS_NEWCOMER, C_ChatInfo_GetChannelRulesetForChannelID(zoneChannelID)) == PLAYERMENTORSHIPSTATUS_NEWCOMER then
				return _G.NPEV2_CHAT_USER_TAG_NEWCOMER
			end
		end
	end

	return ""
end

-- From ElvUI Chat
local function FlashTabIfNotShown(frame, info, chatType, chatGroup, chatTarget)
	if
		not frame:IsShown() and
		((frame == _G.DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or
		(frame ~= _G.DEFAULT_CHAT_FRAME and info.flashTab))
	then
		if
			(not _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS or chatType == "WHISPER" or chatType == "BN_WHISPER") and --BN_WHISPER FIXME
			not _G.FCFManager_ShouldSuppressMessageFlash(frame, chatGroup, chatTarget)
		then
			_G.FCF_StartAlertFlash(frame)
		end
	end
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

function CT:UpdateRoleIcons()
	if not self.db then
		return
	end

	local pack = self.db.enable and self.db.roleIconStyle or "DEFAULT"
	local sizeString = self.db.enable and format(":%d:%d", self.db.roleIconSize, self.db.roleIconSize) or ":16:16"

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
			TANK = E:TextureString(CT.cache.elvuiRoleIconsPath.Tank, sizeString .. ":0:0:64:64:2:56:2:56"),
			HEALER = E:TextureString(CT.cache.elvuiRoleIconsPath.Healer, sizeString .. ":0:0:64:64:2:56:2:56"),
			DAMAGER = E:TextureString(CT.cache.elvuiRoleIconsPath.DPS, sizeString)
		}

		_G.INLINE_TANK_ICON = CT.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = CT.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = CT.cache.blizzardRoleIcons.DPS
	elseif pack == "BLIZZARD" then
		roleIcons = {
			TANK = gsub(CT.cache.blizzardRoleIcons.Tank, ":16:16", sizeString),
			HEALER = gsub(CT.cache.blizzardRoleIcons.Healer, ":16:16", sizeString),
			DAMAGER = gsub(CT.cache.blizzardRoleIcons.DPS, ":16:16", sizeString)
		}

		_G.INLINE_TANK_ICON = CT.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = CT.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = CT.cache.blizzardRoleIcons.DPS
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

function CT:ShortChannel()
	local noBracketsString
	local abbr

	if CT.db then
		if CT.db.removeBrackets then
			noBracketsString = "|Hchannel:%s|h%s|h"
		end

		if CT.db.abbreviation == "SHORT" then
			abbr = abbrStrings[strupper(self)]
		elseif CT.db.abbreviation == "NONE" then
			return ""
		else
			abbr = elvuiAbbrStrings[strupper(self)]
		end
	end

	if not abbr and CT.db.abbreviation == "SHORT" then
		local name = select(2, GetChannelName(gsub(self, "channel:", "")))

		if name then
			local communityID = strmatch(name, "Community:(%d+):")
			if communityID then
				local communityInfo = C_Club_GetClubInfo(communityID)

				if communityInfo.clubType == 0 then
					if communityInfo.name and CT.db and CT.db.customAbbreviation then
						abbr = CT.db.customAbbreviation[communityInfo.name]
					end
					abbr = abbr or strupper(utf8sub(communityInfo.name, 1, 2))
					abbr = E:TextGradient(abbr, 0.000, 0.592, 0.902, 0.000, 0.659, 1.000)
				elseif communityInfo.clubType == 1 then
					if CT.db and CT.db.customAbbreviation then
						abbr = CT.db.customAbbreviation[communityInfo.name]
					end
					abbr = abbr or communityInfo.shortName or strupper(utf8sub(communityInfo.name, 1, 2))
					abbr = F.CreateColorString(abbr, { r = 0.902, g = 0.494, b = 0.133 })
				end
			else
				if CT.db and CT.db.customAbbreviation then
					abbr = CT.db.customAbbreviation[name]
				end
				abbr = abbr or utf8sub(name, 1, 1)
			end
		end
	end

	abbr = abbr or gsub(self, "channel:", "")

	return format(noBracketsString or "|Hchannel:%s|h[%s]|h", self, abbr)
end

function CT:HandleShortChannels(msg)
	msg = gsub(msg, "|Hchannel:(.-)|h%[(.-)%]|h", CT.ShortChannel)
	msg = gsub(msg, "CHANNEL:", "")
	msg = gsub(msg, "^(.-|h) " .. L["whispers"], "%1")
	msg = gsub(msg, "^(.-|h) " .. L["says"], "%1")
	msg = gsub(msg, "^(.-|h) " .. L["yells"], "%1")
	msg = gsub(msg, "<" .. _G.AFK .. ">", "[|cffFF0000" .. L["AFK"] .. "|r] ")
	msg = gsub(msg, "<" .. _G.DND .. ">", "[|cffE7E716" .. L["DND"] .. "|r] ")

	local raidWarningString = ""
	if CT.db and CT.db.abbreviation == "SHORT" and MER.ChineseLocale then
		msg = gsub(msg, utf8sub(_G.CHAT_WHISPER_GET, 3), L["[ABBR] Whisper"] .. "：")
		msg = gsub(msg, utf8sub(_G.CHAT_WHISPER_INFORM_GET, 1, 3), L["[ABBR] Whisper"])
		msg = gsub(msg, utf8sub(_G.CHAT_SAY_GET, 3), L["[ABBR] Say"] .. "：")
		msg = gsub(msg, utf8sub(_G.CHAT_YELL_GET, 3), L["[ABBR] Yell"] .. "：")
	end

	if CT.db and CT.db.removeBrackets then
		if CT.db.abbreviation == "SHORT" then
			raidWarningString = abbrStrings["RAID_WARNING"]
		end
	else
		if CT.db.abbreviation == "SHORT" then
			raidWarningString = "[" .. abbrStrings["RAID_WARNING"] .. "]"
		end
	end
	msg = gsub(msg, "^%[" .. _G.RAID_WARNING .. "%]", raidWarningString)
	return msg
end

function CT:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp  --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then
		historyTimestamp = historyTime
	end

	if CH.db.timeStampFormat and CH.db.timeStampFormat ~= "NONE" then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or CH:GetChatTime())
		timeStamp = gsub(timeStamp, " ", "")
		timeStamp = gsub(timeStamp, "AM", " AM")
		timeStamp = gsub(timeStamp, "PM", " PM")
		if CH.db.useCustomTimeColor then
			local color = CH.db.customTimeColor
			local hexColor = E:RGBToHex(color.r, color.g, color.b)
			msg = format("%s%s|r %s", hexColor, timeStamp, msg)
		else
			msg = format("%s %s", timeStamp, msg)
		end
	end

	if CH.db.copyChatLines then
		msg = format("|Hcpl:%s|h%s|h %s", self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ":14"), msg)
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CT:CheckLFGRoles()
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

function CT:HandleName(nameString)
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

function CT:ChatFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, isHistory, historyTime, historyName, historyBTag)
	-- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
	-- we also send isHistory and historyTime into CH:AddMessage so that we don't have to override the timestamp.
	local noBrackets = CT.db.removeBrackets
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

		if chatType == "VOICE_TEXT" then -- the code here looks weird but its how blizzard has it ~Simpy
			local leader = UnitIsGroupLeader(arg2)
			infoType, chatType = _G.VoiceTranscription_DetermineChatTypeVoiceTranscription_DetermineChatType(leader)
			info = _G.ChatTypeInfo[infoType]
		elseif chatType == "COMMUNITIES_CHANNEL" or ((strsub(chatType, 1, 7) == "CHANNEL") and (chatType ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (chatType ~= "CHANNEL_NOTICE_USER"))) then
			if arg1 == "WRONG_PASSWORD" then
				local _, popup = StaticPopup_Visible("CHAT_CHANNEL_PASSWORD")
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
			if chatType ~= "SYSTEM" or not CT:ElvUIChat_GuildMemberStatusMessageHandler(frame, arg1) then
				frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == "LOOT" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 7) == "COMBAT_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 6) == "SPELL_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 10) == "BG_SYSTEM_" then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType, 1, 11) == "ACHIEVEMENT" then
			-- Append [Share] hyperlink
			if not CT:ElvUIChat_AchievementMessageHandler(event, frame, arg1, data) then
				frame:AddMessage(format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", CT:HandleName(coloredName)))), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif strsub(chatType, 1, 18) == "GUILD_ACHIEVEMENT" then
			if not CT:ElvUIChat_AchievementMessageHandler(event, frame, arg1, data) then
				local message = format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", coloredName)))
				frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
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
					if C_Texture_GetTitleIconTexture then
						C_Texture_GetTitleIconTexture(clientProgram, TitleIconVersion_Small, function(success, texture)
							if success then
								local charName = _G.BNet_GetValidatedCharacterNameWithClientEmbeddedTexture(characterName, battleTag, texture, 32, 32, 10)
								local linkDisplayText = format(noBrackets and "%s (%s)" or "[%s] (%s)", arg2, charName)
								local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
								frame:AddMessage(format(globalstring, playerLink), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)

								if notChatHistory then
									FlashTabIfNotShown(frame, info, chatType, chatGroup, chatTarget)
								end
							end
						end)
					end

					return
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
			arg1 = CH:ChatFrame_ReplaceIconAndGroupExpressions( arg1, arg17, not _G.ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)) -- If arg17 is true, don't convert to raid icons

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
				playerLinkDisplayText = format(noBrackets and "%s" or "[%s]", CT:HandleName(coloredName))
			end

			local isCommunityType = chatType == "COMMUNITIES_CHANNEL"
			local playerName, lineID, bnetIDAccount = (nameWithRealm ~= arg2 and nameWithRealm) or arg2, arg11, arg13
			if isCommunityType then
				local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
				local messageInfo, clubId, streamId = C_Club_GetInfoFromLastCommunityChatLine()

				if messageInfo ~= nil then
					if isBattleNetCommunity then
						playerLink =
							GetBNPlayerCommunityLink(
								playerName,
								playerLinkDisplayText,
								bnetIDAccount,
								clubId,
								streamId,
								messageInfo.messageId.epoch,
								messageInfo.messageId.position
							)
					else
						playerLink =
							GetPlayerCommunityLink(
								playerName,
								playerLinkDisplayText,
								clubId,
								streamId,
								messageInfo.messageId.epoch,
								messageInfo.messageId.position
							)
					end
				else
					playerLink = playerLinkDisplayText
				end
			elseif chatType == "BN_WHISPER" or chatType == "BN_WHISPER_INFORM" then
				playerLink =
					GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
			else
				playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
			end

			local message = arg1
			if arg14 then --isMobile
				message = _G.ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b) .. message
			end

			-- Player Flags
			local pflag = GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,
			arg14, arg15, arg16, arg17)
			local chatIcon, pluginChatIcon = specialChatIcons[playerName], CH:GetPluginIcon(playerName)
			if type(chatIcon) == 'function' then
				local icon, prettify, var1, var2, var3 = chatIcon()
				if prettify and not CH:MessageIsProtected(message) then
					if chatType == 'TEXT_EMOTE' and not usingDifferentLanguage and (showLink and arg2 ~= '') then
						var1, var2, var3 = strmatch(message, '^(.-)(' .. arg2 .. (realm and '%-' .. realm or '') .. ')(.-)$')
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
			if
				lfgRole and
				(chatType == "PARTY_LEADER" or chatType == "PARTY" or chatType == "RAID" or
				chatType == "RAID_LEADER" or
				chatType == "INSTANCE_CHAT" or
				chatType == "INSTANCE_CHAT_LEADER")
			then
				pflag = pflag .. lfgRole
			end

			-- Special Chat Icon
			if chatIcon then
				pflag = pflag .. chatIcon
			end

			-- Plugin Chat Icon
			if pluginChatIcon then
				pflag = pflag .. pluginChatIcon
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
							body = gsub(message, arg2 .. "%-" .. realm, pflag .. gsub(playerLink, "(|h|c.-)|r|h$", "%1-" .. realm .. "|r|h"), 1)
						else
							body = gsub(message, arg2 .. "%-" .. realm, pflag .. gsub(playerLink, "(|h.-)|h$", "%1-" .. realm .. "|h"), 1)
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
				PlaySoundFile(LSM:Fetch("sound", alertType), "Master")
			end

			frame:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		end

		if notChatHistory and (chatType == "WHISPER" or chatType == "BN_WHISPER") then
			_G.ChatEdit_SetLastTellTarget(arg2, chatType)
			if CH.db.flashClientIcon then
				FlashClientIcon()
			end
		end

		if notChatHistory then
			FlashTabIfNotShown(frame, info, chatType, chatGroup, chatTarget)
		end

		return true
	end
end

function CT:ToggleReplacement()
	if not self.db then
		return
	end

	-- HandleShortChannels
	if self.db.enable and (self.db.abbreviation ~= "DEFAULT" or self.db.removeBrackets) then
		if not initRecord.HandleShortChannels then
			CT.cache.HandleShortChannels = CH.HandleShortChannels
			CH.HandleShortChannels = CT.HandleShortChannels
			initRecord.HandleShortChannels = true
		end
	else
		if initRecord.HandleShortChannels then
			if CT.cache.HandleShortChannels then
				CH.HandleShortChannels = CT.cache.HandleShortChannels
			end
			initRecord.HandleShortChannels = false
		end
	end

	-- ChatFrame_AddMessage
	if self.db.enable and self.db.removeBrackets then
		if not initRecord.ChatFrame_AddMessage then
			for _, frameName in ipairs(_G.CHAT_FRAMES) do
				local frame = _G[frameName]
				local id = frame:GetID()
				if id ~= 2 and frame.OldAddMessage then
					frame.AddMessage = CT.AddMessage
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
	if
		self.db.enable and
		(self.db.removeBrackets or self.db.roleIconStyle ~= "DEFAULT" or self.db.roleIconSize ~= 15 or
		self.db.removeRealm)
	then
		if not initRecord.ChatFrame_MessageEventHandler then
			CT.cache.ChatFrame_MessageEventHandler = CH.ChatFrame_MessageEventHandler
			CH.ChatFrame_MessageEventHandler = CT.ChatFrame_MessageEventHandler
			CT.cache.CheckLFGRoles = CH.CheckLFGRoles
			CH.CheckLFGRoles = CT.CheckLFGRoles

			initRecord.ChatFrame_MessageEventHandler = true
		end
	else
		if initRecord.ChatFrame_MessageEventHandler then
			if CT.cache.ChatFrame_MessageEventHandler then
				CH.ChatFrame_MessageEventHandler = CT.cache.ChatFrame_MessageEventHandler
				CH.CheckLFGRoles = CT.cache.CheckLFGRoles
			end

			initRecord.ChatFrame_MessageEventHandler = false
		end
	end
end

function CT:SendAchivementMessage()
	if not self.db or not self.db.enable or not self.db.mergeAchievement then
		return
	end

	local channelData = {
		{ event = "CHAT_MSG_GUILD_ACHIEVEMENT", color = _G.ChatTypeInfo.GUILD },
		{ event = "CHAT_MSG_ACHIEVEMENT",       color = _G.ChatTypeInfo.SYSTEM }
	}

	for _, data in ipairs(channelData) do
		local event, color = data.event, data.color
		for frame, cache in pairs(achievementMessageCache.byPlayer) do
			if cache and cache[event] then
				for playerString, achievementTable in pairs(cache[event]) do
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

						message = select(2, MER:GetModule("MER_ChatLink"):Filter("", message))
						frame:AddMessage(message, color.r, color.g, color.b)
					end
				end
			end
			wipe(cache)
		end
	end
end

function CT:ElvUIChat_AchievementMessageHandler(event, frame, achievementMessage, playerInfo)
	if not frame or not event or not achievementMessage or not playerInfo then
		return
	end

	if not self.db or not self.db.enable or not self.db.mergeAchievement then
		return
	end

	if not achievementMessageCache.byAchievement[frame] then
		achievementMessageCache.byAchievement[frame] = {}
	end

	if not achievementMessageCache.byAchievement[frame][event] then
		achievementMessageCache.byAchievement[frame][event] = {}
	end

	if not achievementMessageCache.byPlayer[frame] then
		achievementMessageCache.byPlayer[frame] = {}
	end

	if not achievementMessageCache.byPlayer[frame][event] then
		achievementMessageCache.byPlayer[frame][event] = {}
	end

	local cache = achievementMessageCache.byAchievement[frame][event]
	local cacheByPlayer = achievementMessageCache.byPlayer[frame][event]

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

				if not self.waitForAchievementMessage then
					self.waitForAchievementMessage = true
					C_Timer_After(0.2, function()
						self:SendAchivementMessage()
						self.waitForAchievementMessage = false
					end)
				end
			end

			cache[achievementID] = nil
		end)
	end

	if not playerInfo or not playerInfo.englishClass or not playerInfo.name or not playerInfo.nameWithRealm then
		return
	end

	local displayName = self.db.removeRealm and playerInfo.name or playerInfo.nameWithRealm
	local coloredName = F.CreateClassColorString(displayName, playerInfo.englishClass)
	local classIcon = self.db.classIcon and F.GetClassIconStringWithStyle(playerInfo.englishClass, self.db.classIconStyle, 14, 14) .. " " or ""

	if coloredName and classIcon and cache[achievementID] then
		local playerName = format("|Hplayer:%s|h%s %s|h", playerInfo.nameWithRealm, classIcon, coloredName)
		cache[achievementID][playerName] = true
		return true
	end
end

function CT:ElvUIChat_GuildMemberStatusMessageHandler(frame, msg)
	if not frame or not msg then
		return
	end

	if not CT.db or not CT.db.enable or not CT.db.guildMemberStatus then
		return
	end

	local name, class, link, resultText

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
		local displayName = CT.db.removeRealm and Ambiguate(name, "short") or name
		local coloredName = F.CreateClassColorString(displayName, link and guildPlayerCache[link] or guildPlayerCache[name])

		coloredName = addSpaceForAsian(coloredName)
		local classIcon = self.db.classIcon and F.GetClassIconStringWithStyle(class, CT.db.classIconStyle, 16, 16) .. " " or ""

		if coloredName and classIcon then
			if link then
				resultText = format(onlineMessageTemplate, link, classIcon, coloredName)
				if CT.db.guildMemberStatusInviteLink then
					local windInviteLink =
						format("|Hwtinvite:%s|h%s|h", link, F.StringByTemplate(format("[%s]", L["Invite"]), "info"))
					resultText = resultText .. " " .. windInviteLink
				end
				frame:AddMessage(resultText, F.RGBFromTemplate("success"))
			else
				resultText = format(offlineMessageTemplate, classIcon, coloredName)
				frame:AddMessage(resultText, F.RGBFromTemplate("danger"))
			end

			return true
		end
	end
end

function CT:BetterSystemMessage()
	if self.db and self.db.guildMemberStatus and not self.isSystemMessageHandled then
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

		self.isSystemMessageHandled = true
	end
end

local battleNetFriendsCharacters = {}
local battleNetFriendStatusUpdateTime = {}

local function getElementNumberOfTable(t)
	if not t then
		return 0
	end

	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

local function UpdateBattleNetFriendStatus(friendIndex)
	local friendInfo = friendIndex and C_BattleNet_GetFriendAccountInfo(friendIndex)
	if not friendInfo then
		return
	end

	local savedCharacters = battleNetFriendsCharacters[friendInfo.bnetAccountID]
	local numberOfSavedCharacters = getElementNumberOfTable(savedCharacters)
	local characters = {}
	local numberOfCharacters = 0

	if battleNetFriendStatusUpdateTime[friendInfo.bnetAccountID] then
		local timeSinceLastUpdate = time() - battleNetFriendStatusUpdateTime[friendInfo.bnetAccountID]
		if timeSinceLastUpdate < 2 then
			return
		end
	end

	local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(friendIndex)
	if numGameAccounts and numGameAccounts > 0 then
		for accountIndex = 1, numGameAccounts do
			local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(friendIndex, accountIndex)
			if gameAccountInfo and gameAccountInfo.wowProjectID == WOW_PROJECT_MAINLINE and gameAccountInfo.characterName then
				numberOfCharacters = numberOfCharacters + 1
				characters[gameAccountInfo.characterName] = {
					faction = gameAccountInfo.factionName,
					realm = gameAccountInfo.realmDisplayName,
					class = E:UnlocalizedClassName(gameAccountInfo.className)
				}
			end
		end
	end

	local changed, changedCharacters

	if numberOfSavedCharacters == 0 then
		if numberOfCharacters > 0 then
			changed = true
			changedCharacters = {}

			for character, data in pairs(characters) do
				changedCharacters[character] = {
					type = "online",
					data = data
				}
			end
		end
	else
		if numberOfCharacters ~= numberOfSavedCharacters then
			changed = true
			changedCharacters = {}

			for character, data in pairs(characters) do
				changedCharacters[character] = {
					type = "online",
					data = data
				}
			end

			for character, data in pairs(savedCharacters) do
				if not changedCharacters[character] then
					changedCharacters[character] = {
						type = "offline",
						data = data
					}
				else
					changedCharacters[character] = nil
				end
			end
		end
	end

	battleNetFriendsCharacters[friendInfo.bnetAccountID] = characters
	battleNetFriendStatusUpdateTime[friendInfo.bnetAccountID] = time()
	return changed, friendInfo.accountName, friendInfo.bnetAccountID, changedCharacters
end

function CT:PLAYER_ENTERING_WORLD(event)
	updateGuildPlayerCache(nil, event)
	for friendIndex = 1, BNGetNumFriends() do
		UpdateBattleNetFriendStatus(friendIndex)
	end

	self.bnetFriendDataCached = true
	self:UnregisterEvent(event)
end

function CT:BN_FRIEND_INFO_CHANGED(_, friendIndex, appTexture)
	if not appTexture then
		if C_Texture_GetTitleIconTexture then
			C_Texture_GetTitleIconTexture("App", TitleIconVersion_Small, function(success, texture)
				if success then
					self:BN_FRIEND_INFO_CHANGED(_, friendIndex, texture)
				end
			end)
		end

		return
	end

	if not self.bnetFriendDataCached or not (self.db.bnetFriendOnline or self.db.bnetFriendOffline) then
		return
	end

	local changed, accountName, accountID, characters = UpdateBattleNetFriendStatus(friendIndex)
	if not changed then
		return
	end

	local displayAccountName = format("%s |cff82c5ff%s|r", BNet_GetClientEmbeddedTexture(appTexture, 32, 32, 12), accountName)
	local bnetLink = GetBNPlayerLink(accountName, displayAccountName, accountID, 0, 0, 0)

	local onlineCharacters = {}
	local offlineCharacters = {}

	for character, characterData in pairs(characters) do
		local fullName = characterData.data.realm and format("%s-%s", character, characterData.data.realm) or character

		-- to avoid duplicate message
		if not guildPlayerCache[Ambiguate(fullName, "none")] then
			local classIcon = self.db.classIcon and F.GetClassIconStringWithStyle(characterData.data.class, CT.db.classIconStyle, 16, 16) .. " " or ""
			local coloredName = F.CreateClassColorString(character, characterData.data.class)

			local playerName = format("|Hplayer:%s|h%s%s|h", fullName, classIcon, coloredName)

			if self.db.factionIcon then
				local factionIcon = F.GetIconString(factionTextures[characterData.data.faction] or factionTextures["Neutral"], 18)
				playerName = factionIcon and format("%s %s", factionIcon, playerName) or playerName
			end

			tinsert(characterData.type == "online" and onlineCharacters or offlineCharacters, addSpaceForAsian(playerName))
		end
	end

	local function sendMessage(template, players, bnetLink, ...)
		local message = gsub(template, "%%players%%", players)
		message = gsub(message, "%%bnet%%", bnetLink)

		for i = 1, NUM_CHAT_WINDOWS do
			local chatFrame = _G["ChatFrame" .. i]
			if chatFrame and chatFrame:IsEventRegistered("CHAT_MSG_BN_INLINE_TOAST_ALERT") then
				chatFrame:AddMessage(message, ...)
			end
		end
	end

	if #onlineCharacters > 0 and self.db.bnetFriendOnline then
		sendMessage(bnetFriendOnlineMessageTemplate, strjoin(", ", unpack(onlineCharacters)), bnetLink, F.RGBFromTemplate("success"))
	end

	if #offlineCharacters > 0 and self.db.bnetFriendOffline then
		sendMessage(bnetFriendOfflineMessageTemplate, strjoin(", ", unpack(offlineCharacters)), bnetLink, F.RGBFromTemplate("danger"))
	end
end

function CT:Initialize()
	self.db = E.db.mui.chat.chatText
	if not self.db or not self.db.enable or not E.private.chat.enable then
		return
	end

	self:UpdateRoleIcons()
	self:ToggleReplacement()
	self:CheckLFGRoles()
	self:BetterSystemMessage()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("BN_FRIEND_INFO_CHANGED")
end

function CT:ProfileUpdate()
	self.db = E.db.mui.chat.chatText
	if not self.db then
		return
	end

	self:UpdateRoleIcons()
	self:ToggleReplacement()
	self:CheckLFGRoles()
	self:BetterSystemMessage()
end

MER:RegisterModule(CT:GetName())

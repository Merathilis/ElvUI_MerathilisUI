-- Korean localization file for koKR.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "koKR")

-- Core
L[" is loaded. For any issues or suggestions, please visit "] = true

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L["AFK"] = "자리비움"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = true
L["Are you still there? ... Hello?"] = true
L["Logout Timer"] = true
L["SplashScreen"] = true
L["Enable/Disable the Splash Screen on Login."] = true
L["Options"] = "옵션"
L["Desciption"] = true
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r is an extension of ElvUI. It adds:

- a lot of new features
- a transparent overall look
- rewrote all existing ElvUI Skins
- my personal Layout

|cFF00c0faNote:|r It is compatible with most of other ElvUI plugins.
But if you install another Layout over mine, you must adjust it manually.

|cffff8000Newest additions are marked with: |r]=]

-- Core Options
L["Login Message"] = "로그인 메세지 표시"
L["Enable/Disable the Login Message in Chat"] = true
L["Debug Mode"] = "디버그 모드"
L["If you installed other ElvUI Plugins, enabling debug mode is not a suggestion."] = "다른 ElvUI 플러그인을 설치한 경우 디버그 모드를 활성화하는 것은 권장하지 않습니다."

-- Bags
L["Equipment Manager"] = true
L["Equipment Set Overlay"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "뒤로"
L["ERR_FRIEND_ONLINE"] = "has come |cff298F00online|r."
L["ERR_FRIEND_OFFLINE"] = "has gone |cffff0000offline|r."
L["BN_INLINE_TOAST_FRIEND_ONLINE"] = " has come |cff298F00online|r."
L["BN_INLINE_TOAST_FRIEND_OFFLINE"] = " has gone |cffff0000offline|r.."
L["has come |cff298F00online|r."] = true -- Guild Message
L["has gone |cffff0000offline|r."] = true -- Guild Message
L[" has come |cff298F00online|r."] = true -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = true -- Battle.Net Message
L["|cFF00c0failvl|r: %d"] = true
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = true
L["Requires level: %d - %d"] = true
L["Requires level: %d - %d (%d)"] = true
L["(+%.1f Rested)"] = true
L["Unknown"] = "알수없음"
L["Chat Item Level"] = true
L["Shows the slot and item level in the chat"] = true
L["Expand the chat"] = true
L["Chat Menu"] = true
L["Create a chat button to increase the chat size."] = true
L["Hide Player Brackets"] = "플레이어 대괄호 숨기기"
L["Removes brackets around the person who posts a chat message."] = true
L["Hide Chat Side Panel"] = true
L["Removes the Chat SidePanel. |cffFF0000WARNING: If you disable this option you must adjust your Layout.|r"] = true
L["Chat Bar"] = "채팅 바"
L["Shows a ChatBar with different quick buttons."] = true
L["Hide Community Chat"] = true
L["Adds an overlay to the Community Chat. Useful for streamers."] = true
L["Chat Hidden. Click to show"] = true
L["Click to open Emoticon Frame"] = true
L["Emotes"] = true
L["Damage Meter Filter"] = true
L["Fade Chat"] = true
L["Auto hide timeout"] = true
L["Seconds before fading chat panel"] = true
L["Seperators"] = true
L["Orientation"] = "방향"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = "블리자드 커뮤니티 UI를 사용하여 먼저 메인 채팅 프레임에 채널을 추가하세요."
L["Channel Name"] = "채널명"
L["Abbreviation"] = "줄임말"
L["Auto Join"] = "자동 참여"
L["World"] = "월드"
L["Channels"] = "대화 / 채널"
L["Block Shadow"] = "블럭 그림자"
L["Hide channels not exist."] = "존재하지 않는 채널을 자동으로 숨깁니다."
L["Only show chat bar when you mouse over it."] = "마우스 오버 시에만 채팅 바를 표시합니다."
L["Button"] = "버튼"
L["Item Level Links"] = true
L["Filter"] = "필터"
L["Block"] = "블럭"
L["Custom Online Message"] = true
L["Chat Link"] = "채팅 링크"
L["Add extra information on the link, so that you can get basic information but do not need to click"] = "추가 정보를 선택하면 채팅 링크를 클릭하지 않고도 기본 정보를 확인할 수 있습니다."
L["Additional Information"] = "추가 정보"
L["Level"] = "레벨"
L["Translate Item"] = "아이템명 변역"
L["Translate the name in item links into your language."] = "링크된 아이템명을 플레이어의 언어로 번역합니다."
L["Icon"] = "아이콘"
L["Armor Category"] = "방어구 카테고리"
L["Weapon Category"] = "무기 카테고리"
L["Filters some messages out of your chat, that some Spam AddOns use."] = true

-- Combat Alert
L["Combat Alert"] = "전투 알림"
L["Enable/Disable the combat message if you enter/leave the combat."] = true
L["Enter Combat"] = ">>전투 시작<<"
L["Leave Combat"] = ">>전투 종료<<"
L["Stay Duration"] = true
L["Custom Text"] = true
L["Custom Text (Enter)"] = true
L["Custom Text (Leave)"] = true
L["Color"] = "색상"

-- Information
L["Information"] = "정보"
L["Support & Downloads"] = true
L["Tukui"] = true
L["Github"] = true
L["CurseForge"] = true
L["Coding"] = true
L["Testing & Inspiration"] = true
L["Development Version"] = true
L["Here you can download the latest development version."] = true

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = true
L["Are you sure you want to reset %s module?"] = "%s 모듈을 재설정하시겠습니까?"
L["Reset All Modules"] = "모든 모듈 리셋"
L["Reset all %s modules."] = "모든 %s 모듈을 리셋합니다."

-- GameMenu
L["GameMenu"] = true
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] = true

-- Extended Vendor
L["Extended Vendor"] = true

-- FlightMode
L["FlightMode"] = true
L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = true
L["Exit FlightMode"] = true
L["Left Click to Request Stop"] = true

-- FlightPoint
L["Flight Point"] = true
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = true

-- Shadows
L["Shadows"] = true
L["Increase Size"] = "두께 설정"
L["Make shadow thicker."] = "그림자의 두께를 조절합니다."

-- Mail
L["Mail"] = "우편"
L["Alternate Character"] = "다른 캐릭터"
L["Alt List"] = "다른 캐릭터 목록"
L["Delete"] = "삭제"
L["Favorites"] = true
L["Favorite List"] = "즐겨찾기 목록"
L["Name"] = "이름"
L["Realm"] = "서버명"
L["Add"] = "추가"
L["Please set the name and realm first."] = "먼저 이름과 서버를 설정하세요."
L["Toggle Contacts"] = "연락처 토글"
L["Online Friends"] = "접속 중인 친구들"
L["Add To Favorites"] = "즐겨찾기에 추가"
L["Remove From Favorites"] = "즐겨 찾기에서 삭제하기"

-- MicroBar
L["Backdrop"] = "배경"
L["Backdrop Spacing"] = "배경 여백"
L["The spacing between the backdrop and the buttons."] = "버튼과 배경 사이에 공간을 둡니다."
L["Time Width"] = true
L["Time Height"] = true
L["The spacing between buttons."] = "버튼 사이의 간격을 설정합니다."
L["The size of the buttons."] = "버튼의 크기입니다."
L["Slow Mode"] = true
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = "메모리 사용을 줄이기 위해 추가 문자를 1초가 아닌 10초마다 갱신합니다."
L["Display"] = "표시"
L["Fade Time"] = "사라지는 시간 설정"
L["Tooltip Position"] = true
L["Mode"] = "모드"
L["None"] = "없음"
L["Class Color"] = "클래스 색상"
L["Custom"] = "사용자 지정"
L["Additional Text"] = "추가 문자"
L["Interval"] = "간격"
L["The interval of updating."] = "업데이트 간격입니다."
L["Home"] = "귀환"
L["Left Button"] = "왼쪽 버튼"
L["Right Button"] = "오른쪽 버튼"
L["Left Panel"] = "왼쪽 패널"
L["Right Panel"] = "오른쪽 패널"
L["Button #%d"] = "%d 버튼"
L["Pet Journal"] = "애완동물 도감"
L["Show Pet Journal"] = "애완동물 도감 보기"
L["Show Pet Journal"] = "애완동물 도감 보기"
L["Screenshot"] = "스크린샷"
L["Screenshot immediately"] = "즉시 스크린샷 촬영"
L["Screenshot after 2 secs"] = "2초 후 스크린샷 촬영"
L["Toy Box"] = "장난감 상자"
L["Collections"] = "수집품"
L["Show Collections"] = "수집품 보기"
L["Random Favorite Mount"] = "즐겨찾는 탈것 무작위 소환"
L["Decrease the volume"] = "볼륨 낮추기"
L["Increase the volume"] = "볼륨 높이기"
L["Profession"] = "전문 기술"
L["Volume"] = "볼륨"

-- Misc
L["Misc"] = "기타"
L["Artifact Power"] = true
L["has appeared on the MiniMap!"] = true
L["Alt-click, to buy an stack"] = true
L["Announce"] = true
L["Skill gains"] = true
L[" members"] = true
L["Name Hover"] = true
L["Shows the Unit Name on the mouse."] = true
L["Undress"] = true
L["Flashing Cursor"] = true
L["Accept Quest"] = true
L["Placed Item"] = true
L["Stranger"] = true
L["Keystones"] = true
L["GUILD_MOTD_LABEL2"] = "오늘의 길드 메시지"
L["LFG Member Info"] = true
L["Shows role informations in your tooltip in the lfg frame."] = true
L["MISC_REPUTATION"] = "Reputation"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Reputation"
L["MISC_PARAGON_NOTIFY"] = "Max Reputation - Receive Reward."
L["Fun Stuff"] = true
L["Press CTRL + C to copy."] = true
L["Wowhead Links"] = true
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = true
L["Highest Quest Reward"] = true
L["Automatically select the item with the highest reward."] = true
L["Item Alerts"] = true
L["Announce in chat when someone placed an usefull item."] = true
L["Maw ThreatBar"] = true
L["Replace the Maw Threat Display, with a simple StatusBar"] = true
L.ANNOUNCE_FP_PRE = "{rt1} %s has prepared a %s. {rt1}"
L.ANNOUNCE_FP_CLICK = "{rt1} %s is casting %s. Click! {rt1}"
L.ANNOUNCE_FP_USE = "{rt1} %s used a %s. {rt1}"
L.ANNOUNCE_FP_CAST = "{rt1} %s is casting %s. {rt1}"

-- Nameplates
L["NamePlates"] = true
L["Enhanced NameplateAuras"] = true

-- Tooltip
L["Your Status:"] = true
L["Your Status: Incomplete"] = true
L["Your Status: Completed on "] = true
L["Adds an icon for spells and items on your tooltip."] = true
L["Adds an Icon for battle pets on the tooltip."] = true
L["Adds an Icon for the faction on the tooltip."] = true
L["Adds information to the tooltip, on which char you earned an achievement."] = true
L["Keystone"] = "쐐기돌"
L["Adds descriptions for mythic keystone properties to their tooltips."] = true
L["Title Color"] = "제목 색상"
L["Change the color of the title in the Tooltip."] = true
L["Progress Info"] = true
L["Shows raid progress of a character in the tooltip"] = true
L["Mythic"] = "신화"
L["Heroic"] = "영웅"
L["Normal"] = "표준"
L["LFR"] = true
L["Uldir"] = true
L["Battle Of Dazaralor"] = "Battle Of Dazaralor"
L["Crucible Of Storms"] = "Crucible Of Storms"
L["Eternal Palace"] = "Eternal Palace"
L["Ny'alotha"] = true
L["Castle Nathria"] = "나스리아 성채"
L["Sanctum of Domination"] = "지배의 성소"
L["FACTION"] = "진영"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "활성화된 아제라이트 능력"
L["Only Icons"] = true
L["Use the new style tooltip."] = "Use the new style tooltip."
L["Display in English"] = "Display in English"
L["Show icon"] = "Show icon"
L["Show the spell icon along with the name."] = "Show the spell icon along with the name."
L["Domination Rank"] = "지배조각 등급"
L["Show the rank of shards."] = "지배의 조각 등급을 표시합니다"

-- Notification
L["Notification"] = "알림 표시"
L["Display a Toast Frame for different notifications."] = true
L["This is an example of a notification."] = true
L["Notification Mover"] = true
L["%s slot needs to repair, current durability is %d."] = true
L["You have %s pending calendar invite(s)."] = true
L["You have %s pending guild event(s)."] = true
L["Event \"%s\" will end today."] = true
L["Event \"%s\" started today."] = true
L["Event \"%s\" is ongoing."] = true
L["Event \"%s\" will end tomorrow."] = true
L["Here you can enable/disable the different notification types."] = true
L["Enable Mail"] = true
L["Enable Vignette"] = true
L["If a Rare Mob or a treasure gets spotted on the minimap."] = true
L["Enable Invites"] = true
L["Enable Guild Events"] = true
L["No Sounds"] = true

-- DataTexts
-- DataBars
L["DataBars"] = "정보막대"
L["Add some stylish buttons at the bottom of the DataBars"] = true
L["Style DataBars"] = true

-- PVP
L["Automatically cancel PvP duel requests."] = true
L["Automatically cancel pet battles duel requests."] = true
L["Announce in chat if duel was rejected."] = true
L["MER_DuelCancel_REGULAR"] = "Duel request from %s rejected."
L["MER_DuelCancel_PET"] = "Pet duel request from %s rejected."
L["Show your PvP killing blows as a popup."] = true
L["Sound"] = "소리"
L["Play sound when killing blows popup is shown."] = true

-- Actionbars
L["Specialization Bar"] = true
L["EquipSet Bar"] = true
L["Auto Buttons"] = true
L["Bind Font Size"] = true
L["Trinket Buttons"] = true
L["Color by Quality"] = true
L["Quest Buttons"] = true
L["Blacklist Item"] = true
L["Whitelist Item"] = true
L["Add Item ID"] = true
L["Delete Item ID"] = true
L["Custom Glow"] = true
L["Replaces the default Actionbar glow for procs with an own pixel glow."] = true

-- AutoButtons
L["AutoButtons"] = true
L["Bar"] = "바"
L["Only show the bar when you mouse over it."] = "마우스 오버 시에만 바를 표시합니다."
L["Bar Backdrop"] = "바 배경"
L["Show a backdrop of the bar."] = "바의 배경을 표시합니다."
L["Button Width"] = "버튼 폭"
L["The width of the buttons."] = "버튼의 너비입니다."
L["Button Height"] = "버튼 높이"
L["The height of the buttons."] = "버튼의 높이입니다."
L["Counter"] = "개수 글씨 설정"
L["Outline"] = "외곽선"
L["Button Groups"] = "버튼 그룹"
L["Key Binding"] = "단축키 글씨 설정"
L["Custom Items"] = "사용자 지정 아이템"
L["List"] = "목록"
L["New Item ID"] = "새 아이템 ID"
L["Auto Button Bar"] = true
L["Quest Items"] = "퀘스트 아이템"
L["Equipments"] = "장비"
L["Potions"] = "물약"
L["Flasks"] = "영약"
L["Food"] = "음식"
L["Crafted by mage"] = "마법사 창조"
L["Banners"] = "전투 깃발"
L["Utilities"] = "유틸리티"
L["Custom Items"] = "사용자 지정 아이템"
L["Fade Time"] = "사라지는 시간 설정"
L["Alpha Min"] = "최소 알파값"
L["Alpha Max"] = "최대 알파값"

-- Armory
L["Armory"] = "전투정보실"
L["ARMORY_DESC"] = [=[The |cffff7d0aArmory Mode|r only works with the ElvUI 'Display Character Info'. You may need to reload your UI:

ElvUI - General - BlizzUI Improvements - Display Character Infos.]=]
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = true
L["Durability"] = true
L["Enable/Disable the display of durability information on the character window."] = true
L["Damaged Only"] = true
L["Only show durability information for items that are damaged."] = true
L["Itemlevel"] = true
L["Enable/Disable the display of item levels on the character window."] = true
L["Level"] = "레벨"
L["Full Item Level"] = true
L["Show both equipped and average item levels."] = true
L["Item Level Coloring"] = true
L["Color code item levels values. Equipped will be gradient, average - selected color."] = true
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Only Relevant Stats"] = true
L["Show only those primary stats relevant to your spec."] = true
L["Item Level"] = "아이템 레벨"
L["Categories"] = true
L["Slot Gradient"] = true
L["Shows a gradiation texture on the Character Slots."] = true
L["Indicators"] = true
L["Transmog"] = "형상 변환"
L["Shows an arrow indictor for currently transmogrified items."] = true
L["Illusion"] = true
L["Shows an indictor for weapon illusions."] = true
L["Empty Socket"] = true
L["Not Enchanted"] = true
L["Warnings"] = true
L["Shows an indicator for missing sockets and enchants."] = true

-- Media
L["MER_MEDIA_ZONES"] = {
	"Washington",
	"Moscow",
	"Moon Base",
	"Goblin Spa Resort",
	"Illuminaty Headquaters",
	"Elv's Closet",
	"BlizzCon",
}
L["MER_MEDIA_PVP"] = {
	"(Horde Territory)",
	"(Alliance Territory)",
	"(Contested Territory)",
	"(Russian Territory)",
	"(Aliens Territory)",
	"(Cats Territory)",
	"(Japanese Territory)",
	"(EA Territory)",
}
L["MER_MEDIA_SUBZONES"] = {
	"Administration",
	"Hellhole",
	"Alley of Bullshit",
	"Dr. Pepper Storage",
	"Vodka Storage",
	"Last National Bank",
}
L["MER_MEDIA_PVPARENA"] = {
	"(PvP)",
	"No Smoking!",
	"Only 5% Taxes",
	"Free For All",
	"Self destruction is in process",
}

-- Unitframes
L["UnitFrames"] = "유닛프레임"
L["Adds a shadow to the debuffs that the debuff color is more visible."] = true
L["Swing Bar"] = true
L["Creates a weapon Swing Bar"] = true
L["Main-Hand Color"] = true
L["Off-Hand Color"] = true
L["Two-Hand Color"] = true
L["GCD Bar"] = true
L["Creates a Global Cooldown Bar"] = true
L["UnitFrame Style"] = true
L["Adds my styling to the Unitframes if you use transparent health."] = true
L["Change the default role icons."] = true
L["Changes the Heal Prediction texture to the default Blizzard ones."] = true
L["Add a glow in the end of health bars to indicate the over absorb."] = true
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = true
L["Auto Height"] = true
L["Blizzard Absorb Overlay"] = true
L["Blizzard Over Absorb Glow"] = true
L["Blizzard Style"] = "블리자드 기본"
L["Change the color of the absorb bar."] = true
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = true
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = true
L["Max Overflow"] = true
L["Modify the texture of the absorb bar."] = true
L["Overflow"] = true
L["Set %s to %s"] = true
L["Set All Absorb Style to %s"] = true
L["The absorb style %s and %s is highly recommended with %s tweaks."] = true
L["The selected texture will override the ElvUI default absorb bar texture."] = true
L["Use the texture from Blizzard Raid Frames."] = true

-- LocationPanel
L["Location Panel"] = true
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = "사용자 지정 색상"
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = true
L["Teleports"] = true
L["Portals"] = "포털"
L["Link Position"] = true
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = true
L["Relocation Menu"] = true
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = true
L["Custom Width"] = true
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = true
L["Justify Text"] = true
L["Auto Width"] = true
L["Change width based on the zone name length."] = true
L["Hearthstone Location"] = true
L["Show the name on location your Hearthstone is bound to."] = true
L["Combat Hide"] = true
L["Show/Hide all panels when in combat"] = true
L["Hide In Class Hall"] = true
L["Hearthstone Location"] = true
L["Hearthstone Toys Order"] = true
L["Show hearthstones"] = true
L["Show hearthstone type items in the list."] = true
L["Show Toys"] = true
L["Show toys in the list. This option will affect all other display options as well."] = true
L["Show spells"] = true
L["Show relocation spells in the list."] = true
L["Show engineer gadgets"] = true
L["Show items used only by engineers when the profession is learned."] = true
L["Ignore missing info"] = true
L["MER_LOCPANEL_IGNOREMISSINGINFO"] = [[Due to how client functions some item info may become unavailable for a period of time. This mostly happens to toys info.
When called the menu will wait for all information being available before showing up. This may resul in menu opening after some concidarable amount of time, depends on how fast the server will answer info requests.
By enabling this option you'll make the menu ignore items with missing info, resulting in them not showing up in the list.]]
L["Info for some items is not available yet. Please try again later"] = true
L["Update canceled."] = true
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = true
L["Update complete. Opening menu."] = true
L["Hide Coordinates"] = true

-- Maps
L["MiniMap Buttons"] = true
L["Minimap Ping"] = "미니맵 핑"
L["Add Server Name"] = "서버명 추가"
L["Only In Combat"] = true
L["Fade-In"] = true
L["The time of animation. Set 0 to disable animation."] = "애니메이션 시간. 애니메이션을 비활성화하려면 0을 설정하십시오."
L["Blinking Minimap"] = true
L["Enable the blinking animation for new mail or pending invites."] = true
L["Super Tracker"] = "슈퍼 트래커"
L["Description"] = "설명"
L["Additional features for waypoint."] = "지도 핀에 기능을 추가합니다."
L["Auto Track Waypoint"] = "지도 핀 자동 추적"
L["Auto track the waypoint after setting."] = "지도 핀을 배치하면 즉시 추적하여 화면에 표시합니다."
L["Right Click To Clear"] = "오른쪽 클릭으로 삭제"
L["Right click the waypoint to clear it."] = "지도 핀을 마우스 오른쪽 버튼 클릭으로 삭제합니다."
L["No Distance Limitation"] = "표시 거리 제한 해제"
L["Force to track the target even if it over 1000 yds."] = "1,000미터 이상 떨어진 거리의 지도 핀도 강제로 화면에 표시합니다."
L["Distance Text"] = "거리 문자 설정"
L["Only Number"] = "숫자만 표시"

-- SMB
L["Button Settings"] = true

--Raid Marks
L["Raid Markers"] = "공격대 징표"
L["Click to clear the mark."] = true
L["Click to mark the target."] = true
L["%sClick to remove all worldmarkers."] = true
L["%sClick to place a worldmarker."] = true
L["Raid Marker Bar"] = true
L["Options for panels providing fast access to raid markers and flares."] = true
L["Show/Hide raid marks."] = true
L["Reverse"] = true
L["Modifier Key"] = "키 설정"
L["Set the modifier key for placing world markers."] = "빛기둥 징표를 배치하기 위한 키를 설정합니다."
L["Visibility State"] = "표시 자동전환 조건"

-- Raid Buffs
L["Raid Buff Reminder"] = true
L["Shows a frame with flask/food/rune."] = true
L["Class Specific Buffs"] = true
L["Shows all the class specific raid buffs."] = true
L["Change the alpha level of the icons."] = true
L["Shows the pixel glow on missing raidbuffs."] = true

-- Raid Manager
L["Raid Manager"] = true
L["This will disable the ElvUI Raid Control and replace it with my own."] = true
L["Open Raid Manager"] = true
L["Pull Timer Count"] = true
L["Change the Pulltimer for DBM or BigWigs"] = true
L["Only accept values format with '', e.g.: '5', '8', '10' etc."] = true

-- Reminder
L["Reminder"] = true
L["Reminds you on self Buffs."] = true

-- Cooldowns
L["CooldownFlash"] = true
L["Settings"] = true
L["Fadein duration"] = true
L["Fadeout duration"] = true
L["Duration time"] = true
L["Animation size"] = true
L["Display spell name"] = true
L["Watch on pet spell"] = true
L["Transparency"] = true
L["Test"] = "테스트"
L["Sort Upwards"] = true
L["Sort by Expiration Time"] = true
L["Show Self Cooldown"] = true
L["Show Icons"] = true
L["Show In Party"] = true
L["Show In Raid"] = true
L["Show In Arena"] = true

-- CVars
L["\n\nDefault: |cff00ff001|r"] = true
L["\n\nDefault: |cffff00000|r"] = true
L["alwaysCompareItems"] = true
L["alwaysCompareItems_DESC"] = "Always show item comparsion tooltips\r\rDefault: |cffff00000|r"
L["breakUpLargeNumbers"] = true
L["breakUpLargeNumbers_DESC"] = "Toggles using commas in large numbers\r\rDefault: |cff00ff001|r"
L["scriptErrors"] = true
L["enableWoWMouse"] = true
L["trackQuestSorting"] = true
L["trackQuestSorting_DESC"] = "New tracking tasks will be listed at target tracking location \r\r default: top"
L["autoLootDefault"] = true
L["autoDismountFlying"] = true
L["removeChatDelay"] = true
L["screenshotQuality"] = true
L["screenshotQuality_DESC"] = "Screenshot Quality\r\rDefault: |cff00ff003|r"
L["showTutorials"] = true
L["WorldTextScale"] = true
L["WorldTextScale_DESC"] = "The scale of in-world damge numbers, xp gain, artifact gain, etc \r\r default: 1.0"
L["floatingCombatTextCombatDamageDirectionalScale"] = true
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] = "Directional damage numbers movement scale (disable = no directional numbers\r\rDefault: |cff00ff001|r"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = true

-- AFK
L["Jan"] = true
L["Feb"] = true
L["Mar"] = true
L["Apr"] = true
L["May"] = true
L["Jun"] = true
L["Jul"] = true
L["Aug"] = true
L["Sep"] = true
L["Oct"] = true
L["Nov"] = true
L["Dec"] = true

L["Sun"] = true
L["Mon"] = true
L["Tue"] = true
L["Wed"] = true
L["Thu"] = true
L["Fri"] = true
L["Sat"] = true

-- Nameplates
L["Castbar Shield"] = true
L["Show a shield icon on the castbar for non interruptible spells."] = true
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] = true

-- Install
L["Welcome"] = true
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = true
L["MerathilisUI didn't find any supported addons for profile creation"] = true
L["MerathilisUI successfully created and applied profile(s) for:"] = true
L["Chat Set"] = "대화창 설정"
L["ActionBars"] = "행동단축바"
L["ActionBars Set"] = true
L["DataTexts Set"] = true
L["Profile Set"] = true
L["ElvUI AddOns settings applied."] = true
L["AddOnSkins is not enabled, aborting."] = true
L["AddOnSkins settings applied."] = true
L["BigWigs is not enabled, aborting."] = true
L["BigWigs Profile Created"] = true
L["Skada Profile Created"] = true
L["Skada is not enabled, aborting."] = true
L["UnitFrames Set"] = true
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = true
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = true
L["Buttons must be clicked twice"] = true
L["Importance: |cffff0000Very High|r"] = true
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = true
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = true
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = true
L["The Addon 'Skada' is not enabled. Profile not created."] = true
L["This part of the installation process sets up your chat fonts and colors."] = true
L["This part of the installation changes the default ElvUI look."] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below to setup your Unitframes."] = true
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = true
L["DataTexts"] = "정보문자"
L["Setup Chat"] = "대화창 설치"
L["General Layout"] = true
L["Setup ActionBars"] = true
L["Setup UnitFrames"] = true
L["Setup Datatexts"] = true
L["Setup Addons"] = true
L["ElvUI AddOns"] = true
L["Finish"] = true
L["Installed"] = true

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). MerathilisUI isn't loaded. Please update your ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Here you can choose the layout for S&L.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BUI"] = [[Here you can choose the layout for BenikUI.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[Here you can choose the layout for BigWigs.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[Here you can choose the layout for Deadly Boss Mods.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[Here you can choose the layout for Details.]]
L["Name for the new profile"] = true
L["Are you sure you want to override the current profile?"] = true

-- Skins
L["MER_SKINS_DESC"] = [[This section is designed to enhance skins existing in ElvUI.

Please note that some of these options will not be available if corresponding skin is |cff636363disabled|r in main ElvUI skins section.]]
L["MER_ADDONSKINS_DESC"] = [[This section is designed to modify some external addons appearance.

Please note that some of these options will be |cff636363disabled|r if the addon is not loaded in the addon control panel.]]
L["MerathilisUI Style"] = true
L["Creates decorative stripes and a gradient on some frames"] = true
L["MerathilisUI Shadows"] = true
L["Enables/Disables a shadow overlay to darken the screen."] = true
L["Undress Button"] = true
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["Enable/Disable"] = true
L["decor."] = true
L["MerathilisUI Button Style"] = true
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = true
L["Additional Backdrop"] = true
L["Remove Border Effect"] = true
L["Animation Type"] = true
L["The type of animation activated when a button is hovered."] = true
L["Animation Duration"] = true
L["The duration of the animation in seconds."] = true
L["Backdrop Class Color"] = true
L["Border Class Color"] = true
L["Border Color"] = true
L["Normal Class Color"] = true
L["Selected Backdrop & Border"] = true
L["Selected Class Color"] = true
L["Selected Color"] = true
L["Tab"] = true
L["Tree Group Button"] = true

-- Panels
L["Top Left Panel"] = true
L["Top Left Extra Panel"] = true
L["Top Right Panel"] = true
L["Top Right Extra Panel"] = true
L["Bottom Left Panel"] = true
L["Bottom Left Extra Panel"] = true
L["Bottom Right Panel"] = true
L["Bottom Right Extra Panel"] = true

-- Objective Tracker
L["1. Customize the font of Objective Tracker."] = true
L["2. Add colorful progress text to the quest."] = true
L["Progress"] = true
L["No Dash"] = true
L["Colorful Progress"] = true
L["Percentage"] = true
L["Add percentage text after quest text."] = true
L["Colorful Percentage"] = true
L["Make the additional percentage text be colored."] = true
L["Cosmetic Bar"] = true
L["Border"] = true
L["Border Alpha"] = true
L["Width Mode"] = true
L["'Absolute' mode means the width of the bar is fixed."] = true
L["'Dynamic' mode will also add the width of header text."] = true
L["'Absolute' mode means the height of the bar is fixed."] = true
L["'Dynamic' mode will also add the height of header text."] = true
L["Absolute"] = true
L["Dyanamic"] = true
L["Color Mode"] = true
L["Gradient"] = true
L["Class Color"] = true
L["Normal Color"] = true
L["Gradient Color 1"] = true
L["Gradient Color 2"] = true
L["Presets"] = true
L["Preset %d"] = true
L["Here are some example presets, just try them!"] = true
L["Default"] = true
L["Header"] = true
L["Short Header"] = true
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] = true
L["Title Color"] = true
L["Change the color of quest titles."] = true
L["Use Class Color"] = true
L["Highlight Color"] = true
L["Title"] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[This section creates Profiles for some AddOns.

|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply my Profiles please don't press the Buttons below.]]

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = "프로필"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = true

-- Changelog
L["Changelog"] = "변경 사항"

-- Compatibility
L["Compatibility Check"] = "호환성 확인"
L["Help you to enable/disable the modules for a better experience with other plugins."] = "다른 플러그인에 대한 더 나은 경험을 위해 모듈을 활성화 / 비활성화하도록 도와줍니다."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] = "다른 애드온 또는 ElvUI 플러그인의 많은 모듈이 있지만 그중 일부는 거의 동일한 기능입니다."
L["Have a good time with %s!"] = "%s와 즐거운 시간 보내세요!"
L["Choose the module you would like to |cff00ff00use|r"] = "|cff00ff00사용|r할 모듈을 선택하십시오"
L["If you find the %s module conflicts with another addon, alert me via Discord."] = "%s 모듈이 다른 애드온과 충돌하는 것을 발견하면 Discord를 통해 알려주세요."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = "[MerathilisUI]-[정보] 하단의 옵션을 통해 호환성 검사를 비활성화/활성화할 수 있습니다."
L["Complete"] = "완료"

-- Debug
L["Usage"] = true
L["Enable debug mode"] = "디버그 모드 활성화"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = "ElvUI Core, ElvUI %s 및 BugSack을 제외한 다른 모든 애드온을 비활성화합니다."
L["Disable debug mode"] = "디버그 모드 비활성화"
L["Reenable the addons that disabled by debug mode."] = "디버그 모드에서 비활성화된 애드온을 다시 활성화합니다."
L["Debug Enviroment"] = "디버그 환경"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = "|cff00ff00/muidebug off|r 명령을 사용하여 디버그 모드를 종료할 수 있습니다."
L["After you stop debuging, %s will reenable the addons automatically."] = "디버깅을 중지하면 %s이(가) 애드온을 자동으로 다시 활성화합니다."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = "버그를 제출하기 전에 %s을(를) 사용하여 디버그 모드를 활성화하고 한 번 더 테스트하십시오."

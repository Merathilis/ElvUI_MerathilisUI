-- English localization file for enUS
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "enUS", true, true)
if not L then
	return
end

-- Core

L[" is loaded. For any issues or suggestions join my discord: "] = true
L["Alpha"] = "투명도"
L["Enable"] = "사용"
L["Font"] = "글꼴"
L["Font Outline"] = "글꼴 외곽선"
L["Height"] = "높이"
L["Icon Size"] = "아이콘 크기"
L["Outline"] = "외곽선"
L["Size"] = "크기"
L["Width"] = "너비"
L["X-Offset"] = "X 위치 이동"
L["Y-Offset"] = "Y 위치 이동"
L["Y-Offset"] = true


-- General Options
L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"] = true
L["AFK"] = "자리비움"
L["Are you still there? ... Hello?"] = "아직 계신가요?... 안녕하세요?"
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = "제작자: Merathilis (|cFF00c0faEU-Shattrath|r)"
L["Description"] = "설명"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = true
L["Enable/Disable the Splash Screen on Login."] = "로그인 시 스플래시 화면을 표시/숨깁니다."
L["Enables the stripes/gradient look on the frames"] = true
L["General"] = "일반"
L["Logout Timer"] = "자동 로그아웃 타이머"
L["Media"] = "미디어"
L["MER_DESC"] = true
L["Modules"] = "모듈"
L["Options"] = "옵션"
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = "|cffff7d0aElvUI|r용 플러그인 - 제작자: Merathilis"
L["SplashScreen"] = "로그인 화면"


-- Core Options
L["Enable/Disable the Login Message in Chat"] = "채팅창에 로그인 메시지를 표시/숨깁니다"
L["Log Level"] = "로그 레벨"
L["Login Message"] = "로그인 메세지 표시"
L["Only display log message that the level is higher than you choose."] = true
L["Set to 2 if you do not understand the meaning of log level."] = true
L["This will overwrite most of the ElvUI Options for the colors, so please keep that in mind."] = true


-- Information
L["Coding"] = "코딩"
L["CurseForge"] = "CurseForge"
L["Development Version"] = "개발 버전"
L["Donations"] = "후원"
L["Github"] = "GitHub"
L["Here you can download the latest development version."] = true
L["Information"] = "정보"
L["Support & Downloads"] = "지원 및 다운로드"
L["Testing & Inspiration"] = "테스트 및 영감"
L["Tukui"] = "Tukui"


-- Modules
L["Are you sure you want to reset %s module?"] = "%s 모듈을 재설정하시겠습니까?"
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = true
L["Reset all %s modules."] = "모든 %s 모듈을 리셋합니다."
L["Reset All Modules"] = "모든 모듈 리셋"


-- GameMenu
L["Achievement Points: "] = "업적 점수:"
L["Achievements: "] = "업적:"
L["Current Keystone: "] = "현재 쐐기돌:"
L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"] = true
L["Game Menu"] = "ESC 시스템 패널"
L["History Limit"] = "기록 제한"
L["M+ Score: "] = "쐐기 점수:"
L["Mounts: "] = "탈것:"
L["Mythic+"] = "쐐기 던전"
L["Number of Mythic+ dungeons shown in the latest runs."] = "최근 진행한 쐐기 던전 표시 개수"
L["Pets: "] = "애완동물:"
L["Show Mythic+ Infos"] = "쐐기 던전 정보 표시"
L["Show Mythic+ Score"] = "쐐기 점수 표시"
L["Show Random Pets"] = "무작위 애완동물 표시"
L["Show Weekly Delves Keys"] = "주간 구렁 열쇠 표시"
L["Toys: "] = "장난감:"


-- Misc
L[" members"] = "구성원"
L["%s contains the daily quest label."] = true
L["%s contains the quest level."] = true
L["%s contains the quest objective progress."] = true
L["%s contains the quest tag, which is typically the quest series name."] = true
L["%s contains the quest title."] = true
L["%s contains the suggested group size for the quest."] = true
L["%s contains the weekly quest label."] = true
L["Accept Quest"] = "퀘스트 수락"
L["Add a styled section title to the context menu."] = true
L["Add features to the context menu."] = "우클릭 메뉴에 기능을 추가합니다"
L["Add Item level Infos in Guild News"] = "길드 뉴스에 아이템 레벨 정보를 추가합니다"
L["Add LFG group info to tooltip."] = "파티 찾기 그룹 정보를 툴팁에 추가합니다"
L["Add more oUF tags. You can use them on UnitFrames configuration."] = true
L["Add Title"] = "칭호 추가"
L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."] = true
L["Adds a Singing sockets selection tool on the Socketing Frame."] = true
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = true
L["Alerts"] = "알림"
L["Alt-click, to buy an stack"] = "Alt-클릭으로 묶음 구매"
L["Americas & Oceania"] = "아메리카 & 오세아니아"
L["Announce"] = "공지"
L["Announce every time the progress has been changed."] = "진행 상황이 변경될 때마다 알림을 보냅니다"
L["Announce in chat when someone placed an usefull item."] = true
L["Announce the new mythic keystone."] = "새로운 쐐기돌 정보를 알립니다"
L["Armory"] = "전투정보실"
L["Artifact Power"] = "유물력"
L["Auction House"] = "경매장"
L["Auto-detect"] = "자동 감지"
L["Block Join Requests"] = "가입 요청 차단"
L["Bots"] = "지브스 소환"
L["Call to Arms"] = "전장 지원 요청"
L["Cannot track more than %d achievements"] = true
L["Change role icons."] = "역할 아이콘을 변경합니다"
L["Change the NPC Talk Frame."] = "NPC 대화 프레임을 변경합니다"
L["Channel"] = "채널"
L["Chef's Hat"] = true
L["Class"] = "직업"
L["Class Icon"] = "직업 아이콘"
L["Class Trainer"] = "직업 훈련사"
L["COLOR"] = "색상"
L["Context Menu"] = "우클릭 메뉴"
L["Creates a random toy macro."] = "무작위로 장난감을 사용하는 매크로를 생성합니다"
L["Crying"] = "울기"
L["Daily quest label"] = true
L["Deathknight"] = "죽음의 기사"
L["Default Text"] = "기본 텍스트"
L["Detail Template"] = true
L["Disable some annoying sound effects."] = "짜증나는 효과음을 끕니다"
L["Display an additional title."] = "추가 칭호를 표시합니다"
L["Display colorful quest progress information to replace Blizzard's default."] = true
L["Double Click to Undress"] = "두 번 클릭하면 장비를 해제합니다"
L["Dragonriding"] = "드래곤 기수"
L["Dressing Room"] = "착용 미리보기"
L["Due to Blizzard restrictions, the button area cannot be clicked through even when the button is hidden."] = true
L["Emote"] = "감정 표현"
L["Enable Tabs on the Profession Frames"] = "제작 전문 기술 창에 탭을 활성화합니다"
L["Enable/Disable the spell activation alert frame."] = "주문 발동 알림 창을 활성화/비활성화합니다"
L["Equipment Upgrade"] = "장비 강화"
L["Europe"] = "유럽"
L["Evoker"] = "기원사"
L["Feasts"] = "혈기 왕성한 연회"
L["Feasts"] = true
L["Fonts"] = "글자"
L["Fun Stuff"] = "재미있는 기능"
L["Gossip"] = "대화"
L["Group Finder"] = "던전 및 공격대"
L["Guild Invite"] = "길드 초대"
L["Guild News Item Level"] = "길드 뉴스 아이템 레벨"
L["GUILD_MOTD_LABEL2"] = "오늘의 길드 메시지"
L["has appeared on the MiniMap!"] = "미니맵에 나타났습니다!"
L["Heroism/Bloodlust"] = "영웅심/피의 욕망"
L["Hide Max Level"] = "최고 레벨일 경우 숨기기"
L["Hide On Character Level"] = true
L["Hide the level part if the quest level is the same as your character level."] = true
L["Hide the level part if the quest level is the same as your character level."] = true
L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."] = true
L["In Instance"] = "인스턴스 던전 내"
L["In Party"] = "파티 중"
L["In Raid"] = "공격대 중"
L["Include Details"] = "세부 정보 포함"
L["Include Player"] = "플레이어 포함"
L["Inspect Frame"] = "살펴보기 창"
L["It will affect the cry emote sound."] = "감정 표현 중 '울기'의 사운드에 영향을 줍니다"
L["It will also affect the crying sound of all female Blood Elves."] = true
L["Item Alerts"] = "아이템 알림"
L["Jewelcrafting"] = "보석 세공"
L["Keystone"] = "쐐기돌"
L["Keystones"] = "쐐기돌"
L["Korea"] = "한국"
L["LFG Member Info"] = "파티 찾기 멤버 정보"
L["Line"] = "선"
L["Makes the transmogrification frame bigger. Credits to Kayr for code."] = true
L["Message Template"] = true
L["Middle click the character back slot to open the Reshii Wraps upgrade menu."] = true
L["Misc"] = "기타"
L["MISC_PARAGON"] = "용사"
L["MISC_PARAGON_NOTIFY"] = "평판 최대치 - 보상 획득 가능"
L["MISC_PARAGON_REPUTATION"] = "용사 평판"
L["MISC_REPUTATION"] = "평판"
L["Miscellaneous"] = "기타"
L["Mute"] = "음소거"
L["Mute crying sounds of all races."] = "모든 종족의 울음소리를 음소거합니다"
L["Mute the sound of dragonriding."] = "드래곤 기수 효과음을 끕니다"
L["Mute the sound of jewelcrafting."] = "보석 세공 효과음을 끕니다"
L["Name Hover"] = "이름 표시"
L["Name of the player"] = "플레이어 이름"
L["None"] = "없음"
L["Objective"] = true
L["Objective Color"] = true
L["Opacity"] = "투명도"
L["Open Upgrade Menu"] = true
L["Others"] = "기타"
L["Party"] = "파티"
L["Pet Filter Tab"] = "애완동물 필터 탭"
L["Placed Item"] = "배치된 아이템"
L["Portals"] = "차원문"
L["Prefix"] = "앞에 붙는 문자"
L["Press CTRL + C to copy."] = "CTRL + C를 눌러 복사합니다"
L["Print Message"] = "스샷를 채팅 메시지 출력"
L["Prints a message in the chat when you take a screenshot."] = true
L["Put the keystone from bag automatically."] = true
L["Quest level"] = true
L["Quest link"] = true
L["Quest progress (including objectives)"] = true
L["Quest Progress and Error Text"] = true
L["Quest tags (Quest series)"] = true
L["Quest title"] = true
L["Quick Keystone"] = true
L["Raid Warning"] = "공격대 경고"
L["Random Toy"] = "무작위 장난감"
L["Random Toy Macro"] = "무작위 장난감 매크로"
L["Report Stats"] = "능력치 보고"
L["Reset Instance"] = "인스턴스 초기화"
L["Reset the template to default value."] = true
L["Reshii Wraps Upgrade"] = true
L["Reskin Icon"] = "아이콘 스킨 변경"
L["Same Message Interval"] = "동일 메시지 간격 제한"
L["Say"] = "일반 말하기"
L["Section Title"] = "제목 영역"
L["Self (Chat Frame)"] = "자신 (채팅창)"
L["Send a message after instance resetting."] = "인스턴스를 초기화한 뒤 메시지를 보냅니다"
L["Send the use of portals, ritual of summoning, feasts, etc."] = true
L["Server List"] = "서버 목록"
L["Set Region"] = "지역 설정"
L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"] = true
L["Set the scale of the spell activation alert frame."] = "주문 발동 알림 창의 크기를 설정합니다"
L["Set to 0 to disable."] = "0으로 설정하면 비활성화됩니다"
L["Show all stats on the Character Frame"] = "캐릭터 창에 모든 능력치를 표시합니다"
L["Shows a simple frame with Raid Informations."] = "간단한 공격대 정보 창을 표시합니다"
L["Shows role informations in your tooltip in the lfg frame."] = true
L["Shows the Unit Name on the mouse."] = "마우스를 올리면 유닛 이름을 표시합니다"
L["Singing Sockets"] = "속성 소켓 도구"
L["Skill gains"] = "기술 습득"
L["Spell activation alert frame customizations."] = "주문 발동 알림 창 설정"
L["Spell Alert Scale"] = "주문 경고 크기"
L["Status icon (accept/complete)"] = true
L["Stranger"] = "친구 아님"
L["Suggested Group"] = "권장 파티 인원"
L["Suggested group size"] = true
L["Sync Inspect"] = "살펴보기 동기화"
L["Taiwan"] = "대만"
L["Talents"] = "전문화"
L["Target name"] = "대상 이름"
L["Template Elements"] = true
L["Test Quest Name"] = true
L["Test Series"] = true
L["Test Target"] = true
L["Text"] = "텍스트"
L["Text Style"] = "텍스트 스타일"
L["The class icon of the player's class"] = "플레이어의 직업 아이콘입니다"
L["The progress details like 10/20."] = true
L["The spell link"] = "주문 링크"
L["The template for rendering announcement message."] = true
L["The template for rendering progress message in UIErrorsFrame."] = true
L["The template of each element can be customized in %s module."] = true
L["Time interval between sending same messages measured in seconds."] = true
L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."] = true
L["Toys"] = "장난감"
L["Toys"] = true
L["Track Achievement"] = true
L["Trade Tabs"] = "제작 탭"
L["Transmog Frame"] = "형상변환 창"
L["Uncheck this box, it will not send message if you cast the spell."] = true
L["Untrack Achievement"] = true
L["Vendor"] = "상인"
L["Wardrobe"] = "옷장"
L["Weekly quest label"] = true
L["Who"] = "누구"
L["Wowhead Links"] = "Wowhead 링크"
L["Yell"] = "외침"
L["You can find the setting in 'ElvUI > %s > %s > %s'."] = true
L["You can use ElvUI Mover to reposition it."] = true
L["|nIf checked, only popout join requests from friends and guild members."] = true


-- Nameplates
L["NamePlates"] = "이름표"


-- Notification
L["%s slot needs to repair, current durability is %d."] = true
L["Debug Print"] = "디버그 출력"
L["Display a Toast Frame for different notifications."] = "다양한 알림을 위한 토스트 창을 표시합니다"
L["Enable Guild Events"] = "길드 이벤트 알림 활성화"
L["Enable Invites"] = "초대 알림 활성화"
L["Enable Mail"] = "우편 알림 활성화"
L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"] = true
L["Enable Vignette"] = "비넷(미니맵 탐지) 알림 활성화"
L["Here you can enable/disable the different notification types."] = true
L["If a Rare Mob or a treasure gets spotted on the minimap."] = true
L["No Sounds"] = "소리 없음"
L["Notification"] = "알림 표시"
L["Notification Mover"] = "알림 위치 이동"
L["Prints a clickable Link with Coords in the Chat."] = true
L["Quick Join"] = "빠른 참가"
L["Text Font"] = "텍스트 글꼴"
L["This is an example of a notification."] = "이것은 알림의 예시입니다"
L["Title Font"] = "제목 글꼴"
L["Vignette Print"] = "비네트 좌표 출력"
L["You have %s pending calendar invite(s)."] = "%s개의 일정 초대가 보류 중입니다"
L["You have %s pending guild event(s)."] = "%s개의 길드 이벤트가 보류 중입니다"


-- Actionbars
L["Add Item ID"] = "아이템 ID 추가"
L["Auto Buttons"] = "자동 버튼"
L["Bind Font Size"] = "단축키 글꼴 크기"
L["Blacklist Item"] = "아이템 블랙리스트"
L["Color by Quality"] = "품질별 색상 표시"
L["Creates a texture to show the recently pressed buttons."] = true
L["Delete Item ID"] = "아이템 ID 삭제"
L["EquipSet Bar"] = "장비 세트 바"
L["Frame Level"] = true
L["Frame Strata"] = true
L["Quest Buttons"] = "퀘스트 버튼"
L["Specialization Bar"] = "전문화 바"
L["Spell Feedback"] = "주문 피드백"
L["Trinket Buttons"] = "장신구 버튼"
L["Whitelist Item"] = "아이템 화이트리스트"


-- Armory
L["Add %d sockets"] = "%d개의 소켓 추가"
L["Add enchant"] = "마법부여 추가"
L["Alpha"] = true
L["Animation"] = "애니메이션"
L["Animation Multiplier"] = "애니메이션 배율"
L["Armory"] = true
L["Attributes"] = "속성"
L["Background"] = "배경"
L["Bags Item Level"] = "가방 아이템 레벨"
L["Change the Background image."] = "배경 이미지를 변경합니다"
L["Class Background"] = "직업별 배경"
L["Crops and moves sockets above enchant text."] = true
L["Decimal format"] = "소수점 형식"
L["Enable/Disable the Enchant text display"] = "마법부여 텍스트 표시 여부 설정"
L["Enable/Disable the Item Level text display"] = "아이템 레벨 텍스트 표시 여부 설정"
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = true
L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."] = true
L["Enchant & Socket Strings"] = "마법부여 및 소켓 문자열"
L["Enchant Font"] = "마법부여 글꼴"
L["End Alpha"] = "종료 투명도"
L["Format"] = "형식"
L["Hide Controls"] = "컨트롤 숨기기"
L["Hide Controls"] = true
L["Hides the camera controls when hovering the character model."] = true
L["Hides the camera controls when hovering the character model."] = true
L["Item Level"] = "아이템 레벨"
L["Item Quality Gradient"] = "아이템 품질 그라데이션"
L["Missing Enchants"] = "누락된 마법부여"
L["Missing Sockets"] = "누락된 소켓"
L["Move Sockets"] = "소켓 위치 조정"
L["Settings for strings displaying enchant and socket info from the items"] = true
L["Settings for the color coming out of your item slot."] = "아이템 슬롯에서 나오는 색상 설정"
L["Settings for the Item Level next tor your item slot"] = true
L["Short Enchant Text"] = "마법부여 텍스트 간소화"
L["Slot Item Level"] = "슬롯 아이템 레벨"
L["Start Alpha"] = "시작 투명도"
L["Style"] = "스타일"
L["Toggle sockets & azerite traits"] = "소켓 및 아제라이트 특성 표시 전환"
L["Toggling this on enables the Item Quality bars."] = "활성화 시 아이템 품질 막대 표시"
L["Use class specific backgrounds."] = "직업별로 고유 배경을 사용합니다"


-- Unitframes
L["Add a glow in the end of health bars to indicate the over absorb."] = true
L["Add an additional overlay to the absorb bar."] = "흡수 바에 추가 오버레이를 적용합니다"
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = true
L["Adds a shadow to the debuffs that the debuff color is more visible."] = true
L["Adds an own highlight to the Unitframes"] = "유닛 프레임에 고유한 하이라이트 효과를 추가합니다"
L["Adds an shadow around the auras"] = "오라 주변에 그림자를 추가합니다"
L["Adds my styling to the Unitframes if you use transparent health."] = true
L["Auras"] = "오라"
L["Auto Height"] = "자동 높이"
L["Blizzard Absorb Overlay"] = "블리자드 피해흡수 오버레이"
L["Blizzard Over Absorb Glow"] = "블리자드 초과 피해흡수 효과"
L["Blizzard Style"] = "블리자드 기본"
L["Change the color of the absorb bar."] = "보호막 바의 색상을 변경합니다."
L["Change the default raid icons."] = "기본 공격대 아이콘을 변경합니다"
L["Change the default role icons."] = "기본 역할 아이콘을 변경합니다"
L["Changes the Heal Prediction texture to the default Blizzard ones."] = true
L["Creates a Global Cooldown Bar"] = "글로벌 재사용 대기시간(GCD) 바를 생성합니다"
L["Creates a weapon Swing Bar"] = "무기 스윙 바를 생성합니다"
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the animated Power Bar"] = "자원 바에 애니메이션 효과를 활성화합니다"
L["Enable the replacing of ElvUI absorb bar textures."] = true
L["Heal Prediction"] = "치유 예측"
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = true
L["Highlight"] = "하이라이트"
L["Main-Hand Color"] = "주 장비 색상"
L["Max Overflow"] = "최대 치유 흡수 보호막"
L["Modify the texture of the absorb bar."] = "피해흡수 바의 텍스처를 수정합니다."
L["Off-Hand Color"] = "보조 장비 색상"
L["Overflow"] = "초과 표시"
L["Power"] = "자원"
L["Raid Icon"] = "공격대 아이콘"
L["Role Icons"] = "역할 아이콘"
L["Select Model"] = "모델 선택"
L["Set %s to %s"] = "%s을 %s(으)로 설정"
L["Set All Absorb Style to %s"] = "모든 피해흡수 스타일을 %s(으)로 설정"
L["Swing Bar"] = "스윙 바"
L["The absorb style %s and %s is highly recommended with %s tweaks."] = true
L["The selected texture will override the ElvUI default absorb bar texture."] = true
L["Two-Hand Color"] = "양손 무기 색상"
L["Type the Model ID"] = "모델 ID를 입력하세요"
L["UnitFrame Style"] = "유닛 프레임 스타일"
L["UnitFrames"] = "유닛프레임"
L["Use the texture from Blizzard Raid Frames."] = "블리자드 공격대 프레임의 텍스처를 사용합니다."


-- Cooldowns
L["Animation size"] = "애니메이션 크기"
L["Cooldown Flash"] = "재사용 시각 효과"
L["Cooldowns"] = "재사용 대기시간"
L["Duration time"] = "효과 지속 시간"
L["Fadein duration"] = "서서히 표시 시간"
L["Fadeout duration"] = "서서히 사라짐 시간"
L["Settings"] = "설정"
L["Show Icons"] = "아이콘 표시"
L["Show In Arena"] = "투기장 내 표시"
L["Show In Party"] = "파티 내 표시"
L["Show In Raid"] = "공격대 내 표시"
L["Show Self Cooldown"] = "자신의 재사용 시간 표시"
L["Sort by Expiration Time"] = "만료 시간 기준 정렬"
L["Sort Upwards"] = "위쪽으로 정렬"
L["Spell List"] = "주문 목록"
L["Spell Name"] = "주문 이름"
L["Test"] = "테스트"
L["Transparency"] = "투명도"
L["Watch on pet spell"] = "소환수 주문도 감시"


-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = true


-- AFK
L["Apr"] = "4월"
L["Aug"] = "8월"
L["Dec"] = "12월"
L["Feb"] = "2월"
L["Jan"] = "1월"
L["Jul"] = "7월"
L["Jun"] = "6월"
L["Mar"] = "3월"
L["May"] = "5월"
L["Nov"] = "11월"
L["Oct"] = "10월"
L["Sep"] = "9월"


L["Fri"] = "금요일"
L["Mon"] = "월요일"
L["Sat"] = "토요일"
L["Sun"] = "일요일"
L["Thu"] = "목요일"
L["Tue"] = "화요일"
L["Wed"] = "수요일"


-- Install
L["ActionBars"] = "행동 단축바"
L["ActionBars Set"] = "행동단축바 설정 적용됨"
L["AddOnSkins is not enabled, aborting."] = "AddOnSkins가 활성화되어 있지 않아 작업을 중단합니다"
L["AddOnSkins settings applied."] = "AddOnSkins 설정이 적용되었습니다"
L["BigWigs is not enabled, aborting."] = "BigWigs가 활성화되어 있지 않아 작업을 중단합니다"
L["BigWigs Profile Created"] = "BigWigs 프로필 생성 완료"
L["Buttons must be clicked twice"] = "버튼을 두 번 클릭해야 합니다"
L["Chat Set"] = "채팅 설정"
L["DataTexts"] = "정보문자"
L["DataTexts Set"] = "데이터 텍스트 설정 적용됨"
L["EditMode"] = true
L["ElvUI AddOns"] = "ElvUI 애드온"
L["ElvUI AddOns settings applied."] = "ElvUI 애드온 설정이 적용되었습니다"
L["Finish"] = "완료"
L["General Layout"] = "전체 레이아웃"
L["Importance: |cffff0000Very High|r"] = "중요도: |cffff0000매우 높음|r"
L["Installed"] = "설치됨"
L["MerathilisUI didn't find any supported addons for profile creation"] = true
L["MerathilisUI Set"] = "MerathilisUI 설정 적용됨"
L["MerathilisUI successfully created and applied profile(s) for:"] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your actionbars."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below to setup your NamePlates."] = true
L["Please click the button below to setup your Unitframes."] = true
L["Profile Set"] = "프로필 설정 적용됨"
L["Setup ActionBars"] = "행동 단축바 설정"
L["Setup Addons"] = "애드온 설정"
L["Setup Datatexts"] = "데이터 텍스트 설정"
L["Setup NamePlates"] = "이름표 설정"
L["Setup UnitFrames"] = "유닛 프레임 설정"
L["Skada is not enabled, aborting."] = "Skada가 활성화되어 있지 않아 작업을 중단합니다"
L["Skada Profile Created"] = "Skada 프로필 생성 완료"
L["Step 1:"] = true
L["Step 2:"] = true
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = true
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = true
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = true
L["The Addon 'Skada' is not enabled. Profile not created."] = true
L["This part of the installation changes the default ElvUI look."] = true
L["This part of the installation process sets up your chat fonts and colors."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This part of the installation process will change your NamePlates."] = true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["UnitFrames Set"] = "유닛 프레임 설정 적용됨"
L["Welcome"] = "환영합니다"
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = true
L["|cffff7d0aMerathilisUI|r Installation"] = "|cffff7d0aMerathilisUI|r 설치"


-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] =
	"Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). Please update your ElvUI to avoid errors."
L["MSG_MER_ELV_MISMATCH"] =
	"Your ElvUI version is higher than expected. Please update MerathilisUI or you might run into issues or |cffFF0000having it already|r."
L["Are you sure you want to override the current profile?"] = "현재 프로필을 덮어쓰시겠습니까?"
L["MER_INSTALL_SETTINGS_LAYOUT_DETAILS"] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[여기에서 BigWigs 애드온의 레이아웃을 선택할 수 있습니다.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = true
L["Name for the new profile"] = "새 프로필 이름"
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true


-- Skins
L["MER_SKINS_DESC"] = [[이 섹션은 ElvUI에 이미 존재하는 스킨을 향상시키기 위한 설정입니다.


Please note that some of these options will not be available if corresponding skin is |cff636363disabled|r in main ElvUI skins section.]]
L["MER_ADDONSKINS_DESC"] = [[이 섹션은 외부 애드온의 외형을 수정하기 위한 설정입니다.


Please note that some of these options will be |cff636363disabled|r if the addon is not loaded in the addon control panel.]]
L["%s is not loaded."] = "%s가 로드되지 않았습니다"
L["Action Status"] = "행동 상태"
L["Additional Backdrop"] = "배경 추가"
L["Advanced Skin Settings"] = "고급 스킨 설정"
L["Allied Races"] = "동맹 종족"
L["Anima Diversion"] = "아니마 분배"
L["Animation Duration"] = "애니메이션 지속 시간"
L["Animation Type"] = "애니메이션 유형"
L["Archaeology Frame"] = "고고학 창"
L["AUCTIONS"] = "경매장"
L["Azerite Essence"] = "아제로스 정수"
L["Backdrop Alpha"] = "배경 투명도"
L["Backdrop Class Color"] = "클래스 배경 색상"
L["Backdrop Color"] = "배경 색상"
L["Bar Texture"] = true
L["BigWigs Bars"] = "BigWigs 바"
L["BigWigs Skin"] = "BigWigs 스킨"
L["Border Class Color"] = "클래스 테두리 색상"
L["Border Color"] = "테두리 색상"
L["BOTTOM"] = "하단"
L["Buff Bar"] = true
L["Buff Icon"] = true
L["Calendar Frame"] = "달력 창"
L["CHANNELS"] = "채널"
L["Character Frame"] = "캐릭터 창"
L["Charge Count Text"] = true
L["Check Box"] = "체크박스"
L["Chromie Time"] = "크로미 시간 여행"
L["Color Override"] = "색상 재정의"
L["Contribution"] = "기여도"
L["Covenant Preview"] = "성약의 단 미리보기"
L["Covenant Renown"] = "성약의 단 명성"
L["Covenant Sanctum"] = "성약의 단 성소"
L["Craft"] = "제작"
L["Creates decorative stripes and a gradient on some frames"] = true
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = true
L["decor."] = "장식 요소"
L["Disable All"] = "모두 비활성화"
L["Disable ElvUI's LibCustomGlow for fixing cooldown animations."] = true
L["Ease"] = "이지 효과"
L["Embed Settings"] = "내장 설정"
L["Emphasized Bar"] = "강조 바"
L["Enable All"] = "모두 활성화"
L["Enable/Disable"] = "활성화/비활성화"
L["Enables/Disables a shadow overlay to darken the screen."] = true
L["Essential"] = true
L["Event Toast Manager"] = "이벤트 알림 관리자"
L["FLIGHT_MAP"] = "비행 경로 지도"
L["Frame Level"] = true
L["Frame Strata"] = true
L["FRIENDS"] = "친구"
L["Generally, enabling this option makes the value increase faster in the first half of the animation."] = true
L["Gossip Frame"] = "대화 창"
L["Gradient Bars"] = "그라데이션 바"
L["Gradient color of the left part of the bar."] = "바의 왼쪽 부분 그라데이션 색상"
L["Gradient color of the right part of the bar."] = "바의 오른쪽 부분 그라데이션 색상"
L["Guide Frame"] = "가이드 창"
L["GUILD"] = "길드"
L["Guild Control Frame"] = "길드 관리 창"
L["GUILD_BANK"] = "길드 은행"
L["Help Frame"] = "도움말 창"
L["Horizontal Justify"] = true
L["How to change BigWigs bar style:"] = "BigWigs 바 스타일 변경 방법:"
L["Icon Height Ratio"] = true
L["Invert Ease"] = "이지 반전"
L["It only works when you enable the skin (%s)."] = "이 기능은 스킨 (%s) 활성화 시에만 작동합니다"
L["Item Interaction"] = "아이템 상호작용"
L["Item Upgrade"] = "아이템 강화"
L["Left Color"] = "왼쪽 색상"
L["LevelUp Display"] = "레벨 업 표시"
L["LF Guild Frame"] = "길드 찾기 창"
L["Loot"] = "전리품"
L["Loot Frames"] = "전리품 창"
L["MACROS"] = "매크로"
L["Mail Frame"] = "우편 창"
L["MerathilisUI Button Style"] = "MerathilisUI 버튼 스타일"
L["MerathilisUI Style"] = "MerathilisUI 스타일"
L["Merchant Frame"] = "상인 창"
L["Minimap"] = "미니맵"
L["Misc"] = true
L["Normal Bar"] = "일반 바"
L["Normal Class Color"] = "일반 클래스 색상"
L["Open BigWigs Options UI with /bw > Bars > Style."] = true
L["Open Details"] = "Details 열기"
L["Orderhall"] = "지휘의 전당"
L["Override the bar color."] = "바의 색상을 재정의합니다"
L["Player Choice"] = "플레이어 선택"
L["PvP Frames"] = "PvP 창"
L["Quest Choice"] = "퀘스트 선택"
L["Quest Frames"] = "퀘스트 창"
L["Queue Timer"] = "대기열 타이머"
L["Raid Frame"] = "공격대 창"
L["Relative Point"] = true
L["Remove Border Effect"] = "테두리 효과 제거"
L["Reset Settings"] = "설정 초기화"
L["Right Color"] = "오른쪽 색상"
L["Roll Result"] = "주사위 결과"
L["Screen Shadow Overlay"] = "화면 그림자 오버레이"
L["Selected Backdrop & Border"] = "선택한 배경 및 테두리"
L["Selected Class Color"] = "선택한 클래스 색상"
L["Selected Color"] = "선택한 색상"
L["Set the height ratio of icons inside Cooldown Viewer."] = true
L["Shadow Color"] = "그림자 색상"
L["Shop"] = true
L["Show spark on the bar."] = "바에 빛 효과를 표시합니다"
L["Slider"] = "슬라이더"
L["Smooth"] = "부드럽게"
L["Smooth Bars"] = true
L["Smooth the bar animation with ElvUI."] = "ElvUI의 애니메이션을 부드럽게 처리합니다"
L["Socket Frame"] = "보석 장착 창"
L["Soulbinds"] = "영혼 결속"
L["Spark"] = "번쩍임"
L["Spellbook"] = "주문책"
L["Subpages"] = true
L["Tab"] = "탭"
L["TALENTS"] = "특성"
L["TalkingHead"] = "말하는 머리 창"
L["Texture"] = "텍스처"
L["The duration of the animation in seconds."] = "애니메이션 지속 시간(초)"
L["The easing function used for colorize the button."] = "버튼에 색상을 입힐 때 사용되는 이징 함수"
L["The options below are only for BigWigs %s bar style."] = "아래 옵션은 BigWigs %s 바 스타일 전용입니다"
L["The options below is only for the Details look, NOT the Embeded."] = true
L["The type of animation activated when a button is hovered."] = true
L["These skins will affect all widgets handled by ElvUI Skins."] = true
L["This module will override ElvUI's Cooldown Manager count font settings."] = true
L["To enable the modifications below, you need to enable [%s] - [%s] skin first."] = true
L["Toggle Direction"] = "방향 전환"
L["TOP"] = "상단"
L["Trade"] = "거래"
L["Trainer Frame"] = "훈련사 창"
L["Tree Group Button"] = "계층 그룹 버튼"
L["UI Widget"] = "UI 위젯"
L["Undress Button"] = "장비 제거 버튼"
L["Use Blizzard Glow"] = true
L["Weekly Rewards"] = "주간 보상"
L["With this option you can embed your Details into an own Panel."] = true
L["WORLD_MAP"] = "세계 지도"
L["You need to manually set the bar style to %s in BigWigs first."] = true


-- Panels
L["Bottom Left Extra Panel"] = "좌측 하단 보조 패널"
L["Bottom Left Panel"] = "좌측 하단 패널"
L["Bottom Panel"] = "하단 패널"
L["Bottom Right Extra Panel"] = "우측 하단 보조 패널"
L["Bottom Right Panel"] = "우측 하단 패널"
L["Panels"] = "패널"
L["Style Panels"] = "스타일 패널"
L["Top Left Extra Panel"] = "좌측 상단 보조 패널"
L["Top Left Panel"] = "좌측 상단 패널"
L["Top Panel"] = "상단 패널"
L["Top Right Extra Panel"] = "우측 상단 보조 패널"
L["Top Right Panel"] = "우측 상단 패널"


-- Filter
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] = true
L["Filter"] = "비속어 필터"
L["Profanity Filter"] = "비속어 필터"
L["Unblock the profanity filter."] = "비속어 필터 차단을 해제하십시오."


-- Vehicle Bar
L["Animation Speed"] = "애니메이션 속도"
L["Animations"] = "애니메이션"
L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."] = true
L["Skyriding Bar"] = "창공 비행 바"
L["The color for vigor bar's speed text when you are regaining vigor."] = true
L["Thrill Color"] = "활력 속도 색상"
L["VehicleBar"] = "탈것 바"


-- Raid Info Frame
L[" provides a Raid Info Frame that shows a list of players per role in your raid."] = true
L["Change the look of the icons"] = "아이콘의 외형을 변경합니다"
L["Customization"] = "사용자 설정"
L["Displays the current count of Tanks, Healers, and DPS in your raid group."] = true
L["Enable the Raid Info Frame."] = "공격대 정보 창을 활성화합니다"
L["Padding"] = "패딩"
L["Raid Info Frame"] = "공격대 정보 창"
L["Set the backdrop color of the frame."] = "프레임 배경 색상을 설정합니다"
L["Set the outside padding of the frame."] = "프레임 외부 여백(패딩)을 설정합니다"
L["Set the size of the text and icons."] = "텍스트와 아이콘의 크기를 설정합니다"
L["Set the spacing between the icons."] = "아이콘 사이 간격을 설정합니다"
L["Temporarily shows the frame even outside of a raid for easier customization."] = true
L["|cffFFFFFFLeft Click:|r Toggle Raid Frame"] = "|cffFFFFFF좌클릭:|r 공격대 정보 창 표시/숨기기"
L["|cffFFFFFFRight Click:|r Toggle Settings"] = "|cffFFFFFF우클릭:|r 설정 창 표시/숨기기"


-- Profiles
L["MER_PROFILE_DESC"] = [[이 섹션에서는 일부 애드온을 위한 프로필을 생성합니다.


|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply my Profiles please don't press the Buttons below.]]

-- Advanced Settings
L["Advanced Settings"] = "고급 설정"
L["Blizzard Fixes"] = "블리자드 버그 수정"
L["CVar Alert"] = "CVar 변경 경고"
L["Fix a PlayerStyle lua error that can happen on the LFG Frame."] = true
L["Fix LFG Frame error"] = "던전 찾기 창 오류 수정"
L["It will alert you to reload UI when you change the CVar %s."] = true
L["The message will be shown in chat when you login."] = "로그인 시 채팅창에 메시지가 표시됩���다"
L["This section will help reset specfic settings back to default."] = true


-- Gradient colors
L[" below.\n\n"] = true
L[" Colors|r\nFor people that like it a bit more extreme\n\n"] = true
L[" from one color to another. You can change the "] = true
L[" Gradient theme "] = true
L[" of Castbar colors.\n\n"] = true
L[" of NPC colors.\n\n"] = true
L[" of Power colors.\n\n"] = true
L[" of State colors.\n\n"] = true
L["Background Brightness"] = true
L["Boosts the saturation and darkens "] = true
L["Boss & Arena"] = true
L["Castbar Colors"] = true
L["Castbar Texture"] = true
L["Castbar texture for UnitFrames"] = true
L["Change the textures used for UnitFrame's Health, Power and Cast status bars."] = true
L["Class Colors"] = true
L["Control the gradient fade direction for boss and arena unitframes.\n\n"] = true
L["Control the gradient fade direction for party and raid unitframes.\n\n"] = true
L["Control the gradient fade direction for player and target unitframes.\n\n"] = true
L["Control the gradient fade direction for tank and assist unitframes.\n\n"] = true
L["Control the Lightness value of HSL for the Normal color."] = true
L["Control the Lightness value of HSL for the Shift color."] = true
L["Control the Saturation value of HSL for the Normal color."] = true
L["Control the Saturation value of HSL for the Shift color."] = true
L["Custom Gradient Colors"] = "사용자 지정 그라데이션 색상"
L["Custom Nameplates Colors"] = "사용자 지정 이름표 색상"
L["Custom Power Colors"] = "사용자 지정 자원 색상"
L["Custom Unitframes Colors"] = "사용자 지정 유닛 프레임 색상"
L["Fade Direction"] = true
L["Group Frames"] = true
L["Health bar texture for UnitFrames"] = true
L["Health Texture"] = true
L["Here you can change the "] = true
L["Normal Lightness"] = true
L["Normal Saturation"] = true
L["NPC Colors"] = true
L["Only used if using threat plates from ElvUI"] = "ElvUI의 Threat Plates를 사용할 경우에만 적용됩니다"
L["Other Colors"] = true
L["Player & Target"] = true
L["Power bar texture for UnitFrames"] = true
L["Power Texture"] = true
L["Role Frames"] = true
L["Runic Power"] = "룬력"
L["Saturation Boost"] = true
L["Shift Lightness"] = true
L["Shift Saturation"] = true
L["State Colors"] = true
L["Theme"] = true
L["Toggling this on enables fancy gradients for "] = true
L["UnitFrame Textures"] = true
L["Warning: Enabling this setting will overwrite textures in ElvUI!"] = true
L["Warning: Setting this too high may cause readability issues!"] = true


-- Addons
L["BigWigs"] = "BigWigs"
L["MasterPlan"] = "MasterPlan"
L["Profiles"] = "프로필"
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["Skins/AddOns"] = "스킨/애드온"
L["This will create and apply profile for "] = true


-- Changelog
L["Changelog"] = "변경 사항"


-- Compatibility
L["Choose the module you would like to |cff00ff00use|r"] = "|cff00ff00사용|r할 모듈을 선택하십시오"
L["Compatibility Check"] = "호환성 확인"
L["Complete"] = "완료"
L["Have a good time with %s!"] = "%s와 즐거운 시간 보내세요!"
L["Help you to enable/disable the modules for a better experience with other plugins."] = true
L["If you find the %s module conflicts with another addon, alert me via Discord."] = true
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = true


-- Profiles
L[" Apply"] = "적용"
L[" Reset"] = "초기화"
L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true
L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true
L["This group allows to update all fonts used in the "] = true


-- Debug
L["After you stop debuging, %s will reenable the addons automatically."] = true
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = true
L["Debug Enviroment"] = "디버그 환경"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = true
L["Disable debug mode"] = "디버그 모드 비활성화"
L["Enable debug mode"] = "디버그 모드 활성화"
L["Error"] = "오류"
L["Reenable the addons that disabled by debug mode."] = true
L["Usage"] = "사용법"
L["Warning"] = "경고"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = true


-- Abbreviate
L["[ABBR] Announcement"] = "ANN"
L["[ABBR] Ara-Kara, City of Echoes"] = "ARAK"
L["[ABBR] Back"] = "Back"
L["[ABBR] Challenge Level 1"] = "CL1"
L["[ABBR] Chest"] = "Chest"
L["[ABBR] Cinderbrew Meadery"] = "BREW"
L["[ABBR] City of Threads"] = "COT"
L["[ABBR] Community"] = "C"
L["[ABBR] Darkflame Cleft"] = "DFC"
L["[ABBR] Delves"] = "Delves"
L["[ABBR] Dragonflight"] = "DF"
L["[ABBR] Eco-Dome Al'dani"] = "EDA"
L["[ABBR] Emote"] = "E"
L["[ABBR] Event Scenario"] = "EScen"
L["[ABBR] Feet"] = "Feet"
L["[ABBR] Finger"] = "Finger"
L["[ABBR] Follower"] = "Follower"
L["[ABBR] Guild"] = "G"
L["[ABBR] Halls of Atonement"] = "HoA"
L["[ABBR] Hands"] = "Hands"
L["[ABBR] Head"] = "Head"
L["[ABBR] Held In Off-hand"] = "Off-hand"
L["[ABBR] Heroic"] = "H"
L["[ABBR] Instance"] = "I"
L["[ABBR] Instance Leader"] = "IL"
L["[ABBR] Legs"] = "Legs"
L["[ABBR] Liberation of Undermine"] = "LoU"
L["[ABBR] Looking for raid"] = "LFR"
L["[ABBR] Lorewalking"] = "LW"
L["[ABBR] Manaforge Omega"] = "MFO"
L["[ABBR] Mythic"] = "M"
L["[ABBR] Mythic Keystone"] = "M+"
L["[ABBR] Neck"] = "Neck"
L["[ABBR] Nerub-ar Palace"] = "NP"
L["[ABBR] Normal"] = "N"
L["[ABBR] Normal Scaling Party"] = "NSP"
L["[ABBR] Officer"] = "O"
L["[ABBR] Operation: Floodgate"] = "FLOOD"
L["[ABBR] Operation: Mechagon - Workshop"] = "WORK"
L["[ABBR] Party"] = "P"
L["[ABBR] Party Leader"] = "PL"
L["[ABBR] Path of Ascension"] = "PoA"
L["[ABBR] Priory of the Sacred Flame"] = "PSF"
L["[ABBR] Quest"] = "Quest"
L["[ABBR] Raid"] = "R"
L["[ABBR] Raid Finder"] = "RF"
L["[ABBR] Raid Leader"] = "RL"
L["[ABBR] Raid Warning"] = "RW"
L["[ABBR] Roll"] = "RL"
L["[ABBR] Say"] = "S"
L["[ABBR] Scenario"] = "Scen"
L["[ABBR] Shadowlands"] = "SL"
L["[ABBR] Shoulders"] = "Shoulders"
L["[ABBR] Story"] = "Story"
L["[ABBR] Tazavesh: So'leah's Gambit"] = "GMBT"
L["[ABBR] Tazavesh: Streets of Wonder"] = "STRT"
L["[ABBR] Teeming Island"] = "Teeming"
L["[ABBR] The Dawnbreaker"] = "DAWN"
L["[ABBR] The MOTHERLODE!!"] = "ML"
L["[ABBR] The Rookery"] = "ROOK"
L["[ABBR] The Stonevault"] = "SV"
L["[ABBR] The War Within"] = "TWW"
L["[ABBR] The War Within Keystone Hero: Season One"] = "S1 Keystone Hero"
L["[ABBR] The War Within Keystone Hero: Season Three"] = "S3 Keystone Hero"
L["[ABBR] The War Within Keystone Hero: Season Two"] = "S2 Keystone Hero"
L["[ABBR] The War Within Keystone Legend: Season Three"] = "S3 Keystone Legend"
L["[ABBR] The War Within Keystone Master: Season One"] = "S1 Keystone Master"
L["[ABBR] The War Within Keystone Master: Season Three"] = "S3 Keystone Master"
L["[ABBR] The War Within Keystone Master: Season Two"] = "S2 Keystone Master"
L["[ABBR] Theater of Pain"] = "TOP"
L["[ABBR] Timewalking"] = "TW"
L["[ABBR] Torghast"] = "Torghast"
L["[ABBR] Trinket"] = "Trinket"
L["[ABBR] Turn In"] = "TURNIN"
L["[ABBR] Visions of N'Zoth"] = "Visions"
L["[ABBR] Waist"] = "Waist"
L["[ABBR] Warfronts"] = "WF"
L["[ABBR] Whisper"] = "Whispers"
L["[ABBR] Wind Emote"] = "WE"
L["[ABBR] World"] = "W"
L["[ABBR] World Boss"] = "WB"
L["[ABBR] Wrist"] = "Wrist"
L["[ABBR] Yell"] = "Y"

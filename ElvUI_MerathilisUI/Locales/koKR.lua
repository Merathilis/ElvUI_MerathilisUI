-- Korean localization file for koKR.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "koKR")

-- Core
L["Enable"] = "사용"
L[" is loaded. For any issues or suggestions join my discord: "] =
	"애드온 로딩이 완료되었습니다. 오류 신고 및 피드백은 디스코드를 통해 전달해 주세요."
L[" or visit my homepage: "] = " 또는 제 홈페이지를 방문하세요: "
L["Please run through the installation process to set up the plugin.\n\n |cffff7d0aThis step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step.|r"] =
	"플러그인을 설정하려면 설치 과정을 실행하세요.\n\n |cffff7d0a이 단계는 프로필의 모든 기능이 올바르게 구성되었는지 확인하는 데 필요합니다. 모든 단계를 적용할 필요는 없습니다.|r"
L["Font"] = "글꼴"
L["Size"] = "크기"
L["Width"] = "가로 길이"
L["Height"] = "세로 길이"
L["Outline"] = "외곽선"
L["X-Offset"] = "X 좌표"
L["Y-Offset"] = "Y 좌표"

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = "|cffff7d0aElvUI|r용 플러그인 - 제작자: Merathilis"
L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"] =
	"현재 게임 버전을 지원하지 않습니다. 애드온을 삭제하시고 지원 요청은 삼가주시기 바랍니다. 감사합니다!"
L["AFK"] = "자리 비움"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] =
	"MUI AFK 화면을 사용/중지합니다. BenikUI가 로드된 경우 비활성화됩니다."
L["Logout Timer"] = "자동 로그아웃 타이머"
L["AFK ... maybe!?"] = "자리 비움... 아마도요?!"
L["Just five more minutes..."] = "딱 5분만 더..."
L["Do not disturb!"] = "방해하지 마세요!"
L["Dreaming of loot..."] = "전리품 꿈을 꾸는 중..."
L["Brb, getting coffee"] = "커피 한 잔 하고 올게요"
L["Counting sheep..."] = "양을 세는 중..."
L["SplashScreen"] = "로그인 화면"
L["Enable/Disable the Splash Screen on Login."] = "로그인 시 스플래시 화면을 표시/숨깁니다."

-- Performance Tuning
L["Performance Tuning"] = "성능 최적화"
L["Trades environment detail for a higher frame rate and a sharper image with one click."] =
	"클릭 한 번으로 환경 디테일을 낮추는 대신 프레임 속도를 높이고 화면을 더 선명하게 만듭니다."
L["Boost FPS & Clarity"] = "FPS 및 선명도 향상"
L["Adjusts your graphics settings for a higher frame rate and a sharper image. Textures stay on high."] =
	"프레임 속도를 높이고 화면을 더 선명하게 하도록 그래픽 설정을 조정합니다. 텍스처는 높음으로 유지됩니다."
L["Revert to Previous Settings"] = "이전 설정으로 되돌리기"
L["Puts back the graphics settings you had before the tuning."] = "최적화 전에 사용하던 그래픽 설정으로 되돌립니다."
L["Show Details"] = "상세 정보 보기"
L["Hide Details"] = "상세 정보 숨기기"
L["What the Tuning Changes"] = "최적화로 변경되는 항목"
L["Performance tuning applied."] = "성능 최적화가 적용되었습니다."
L["Previous graphics settings are back."] = "이전 그래픽 설정으로 복원되었습니다."
L["The tuning lowers the settings that cost a lot of FPS but add little to what you actually see in combat."] =
	"전투에서 실제로 보이는 차이는 적지만 FPS를 많이 소모하는 설정을 낮춥니다."
L["Your previous values are saved first, so the revert button can bring them back at any time."] =
	"이전 값이 먼저 저장되므로 되돌리기 버튼으로 언제든지 복원할 수 있습니다."
L["Changed settings:"] = "변경된 설정:"
L["Shadow Quality: Fair (balanced quality and FPS)"] = "그림자 품질: 보통 (품질과 FPS의 균형)"
L["Liquid Detail: Low"] = "액체 디테일: 낮음"
L["Particle Density: Ultra (keeps important spell effects)"] = "입자 밀도: 최상 (중요한 주문 효과 유지)"
L["SSAO (Ambient Occlusion): Disabled"] = "SSAO(주변 광 차단): 사용 안 함"
L["Depth Effects: Disabled"] = "심도 효과: 사용 안 함"
L["Compute Effects: Disabled"] = "연산 효과: 사용 안 함"
L["Outline Mode: Disabled"] = "외곽선 모드: 사용 안 함"
L["Texture Resolution: High"] = "텍스처 해상도: 높음"
L["Spell Density: Essential"] = "주문 효과 밀도: 필수"
L["Projected Textures: Enabled (needed for ground effects)"] = "투영 텍스처: 사용 (지면 효과에 필요)"
L["View Distance: 1"] = "시야 거리: 1"
L["Environment Detail: 1"] = "환경 디테일: 1"
L["Ground Clutter: 1"] = "지면 효과 밀도: 1"
L["Raid/Dungeon Settings: Same settings everywhere"] = "공격대/던전 설정: 모든 곳에 동일한 설정 적용"
L["Resample Sharpening: Enabled (crisper image)"] = "리샘플 선명하게: 사용 (더 또렷한 화면)"
L["Reverb: Disabled (spell and interrupt sound cues stay crisp)"] = "잔향: 사용 안 함 (주문 및 차단 효과음이 또렷하게 유지됨)"
L["Contrast: +10 (if currently 55 or below)"] = "대비: +10 (현재 55 이하인 경우)"
L["Character and world textures are left on high, only distant scenery, effects and post-processing are toned down."] =
	"캐릭터와 월드 텍스처는 높음으로 유지하고, 먼 풍경과 효과, 후처리만 낮춥니다."

L["Description"] = "설명"
L["General"] = "일반"
L["Modules"] = "모듈"
L["MER_DESC"] =
	[=[|cffffffffMerathilis|r|cffff7d0aUI|r는 ElvUI의 & ElvUI_WindTools 확장 애드온입니다. 다음과 같은 기능을 제공합니다:

- 다양한 신규 기능 추가
- 전체적으로 투명한 디자인
- 개발자의 개인 레이아웃 적용

|cFF00c0fa참고:|r 대부분의 ElvUI 플러그인과 호환됩니다.
단, 다른 레이아웃을 설치할 경우 수동으로 설정을 조정해야 할 수 있습니다.

|cffff8000최신 추가 항목은 다음 기호로 표시됩니다: |r]=]

L["Enables the stripes/gradient look on the frames"] =
	"프레임에 줄무늬/그라데이션 효과를 적용합니다"

-- Core Options
L["Tags"] = "태그"
L["Show More Options"] = "옵션 더 보기"
L["Show Fewer Options"] = "옵션 간단히 보기"
L["Color Picker"] = "색상 선택기"
L["Current"] = "현재"
L["Hex"] = "16진수"
L["Opacity"] = "불투명도"
L["Quick Colors"] = "빠른 색상"
L["Favorites"] = "즐겨찾기"
L["Recent Colors"] = "최근 색상"
L["Click to go back to this color."] = "클릭하면 이 색상으로 되돌립니다."
L["Right-click to add it to your favorites."] = "우클릭하면 즐겨찾기에 추가합니다."
L["Right-click to remove it from your favorites."] = "우클릭하면 즐겨찾기에서 제거합니다."
L["Right-click a recent color to add it."] = "최근 색상을 우클릭하여 추가하세요."
L["Colors you confirm show up here."] = "확인한 색상이 여기에 표시됩니다."
L["Main Text"] = "주 텍스트"
L["Status Text"] = "상태 텍스트"
L["Header Text"] = "머리글 텍스트"
L["Guild Text"] = "길드 텍스트"
L["Sub Text"] = "보조 텍스트"
L["Enemy Forces Font"] = "적 병력 글꼴"
L["Resets the settings of every MerathilisUI module to their defaults."] = "모든 MerathilisUI 모듈의 설정을 기본값으로 초기화합니다."
L["Browse and play the game's music by expansion and zone, and replay the cinematics."] =
	"게임 음악을 확장팩과 지역별로 둘러보며 재생하고 영상을 다시 볼 수 있습니다."
L["Info"] = "정보"
L["Login Message"] = "로그인 메시지 표시"

-- Information
L["Information"] = "정보"
L["Support & Downloads"] = "지원 및 다운로드"
L["Tukui"] = "Tukui"
L["Website"] = "웹사이트"
L["Donate"] = "후원"
L["Coding"] = "코딩"
L["Testing & Inspiration"] = "테스트 및 영감"
L["Development Version"] = "개발 버전"
L["Join the community"] = "커뮤니티 참여"
L["Report bugs and suggestions"] = "버그 및 제안 신고"
L["Via the CurseForge app"] = "CurseForge 앱으로 설치"
L["Via the Wago app"] = "Wago 앱으로 설치"
L["Latest development build"] = "최신 개발 빌드"
L["Found a Bug?"] = "버그를 발견하셨나요?"
L["Support the Project"] = "프로젝트 후원"
L["MerathilisUI is free and I work on it in my spare time. If you enjoy it, you can support its development here."] =
	"MerathilisUI는 무료이며 제가 여가 시간에 개발하고 있습니다. 마음에 드신다면 여기에서 개발을 후원해 주세요."
L["Monthly support"] = "월간 후원"
L["Monthly or one-time"] = "월간 또는 일회성"
L["Buy me a coffee"] = "커피 한 잔 사주기"
L["One-time donation"] = "일회성 후원"
L["Thank You!"] = "감사합니다!"
L["Patrons"] = "후원자"
L["Home of ElvUI"] = "ElvUI 공식 사이트"
L["ElvUI support and community"] = "ElvUI 지원 및 커뮤니티"

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] =
	"여기에서 다양한 |cffffffffMerathilis|r|cffff8000UI|r 모듈들의 옵션을 확인할 수 있습니다"
L["Are you sure you want to reset %s module?"] = "%s 모듈을 재설정하시겠습니까?"
L["Reset All Modules"] = "모든 모듈 리셋"
L["Reset all %s modules."] = "모든 %s 모듈을 리셋합니다."

-- Auras
L["BUFFOPTIONS_LABEL"] = "강화 및 약화 효과"

-- GameMenu
L["Game Menu"] = "게임 메뉴"
L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"] =
	"Blizzard 게임 메뉴에서 MerathilisUI 스타일을 사용/중지합니다 (예: 페페, 로고, 바 등)"
L["Achievement Points: "] = "업적 점수:"
L["Mounts: "] = "탈것:"
L["Pets: "] = "애완동물:"
L["Toys: "] = "장난감:"
L["Current Keystone: "] = "현재 쐐기돌:"
L["M+ Score: "] = "쐐기 점수:"
L["Background Color"] = "배경 색상"
L["Show Weekly Delves Keys"] = "주간 구렁 열쇠 표시"
L["Fade In Content"] = "콘텐츠 페이드 인"
L["Fades the info blocks in one after the other when the game menu opens."] = "게임 메뉴를 열 때 정보 블록이 차례대로 서서히 나타납니다."
L["Show Great Vault"] = "위대한 금고 표시"
L["Shows your Great Vault progress for raids, dungeons and the world."] = "공격대, 던전, 세계 활동의 위대한 금고 진행도를 표시합니다."
L["Show Clock"] = "시계 표시"
L["Shows the time, the date and the time until the weekly reset."] = "시간, 날짜, 주간 초기화까지 남은 시간을 표시합니다."
L["Weekly reset in %s"] = "주간 초기화까지 %s"
L["Mythic+"] = "쐐기 던전"
L["Show Mythic+ Infos"] = "쐐기 던전 정보 표시"
L["Show Mythic+ Score"] = "쐐기 점수 표시"
L["History Limit"] = "기록 제한"
L["Number of Mythic+ dungeons shown in the latest runs."] = "최근 진행한 쐐기 던전 표시 개수"
L["Show Random Pets"] = "무작위 애완동물 표시"

-- Misc
L["has appeared on the MiniMap!"] = "미니맵에 나타났습니다!"
L["Name Hover"] = "이름 표시"
L["MISC_PARAGON"] = "용사"
L["Wowhead Links"] = "Wowhead 링크"
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] =
	"업적 및 세계지도 프레임에 Wowhead 링크를 추가합니다"
L["None"] = "없음"
L["Party"] = "파티"
L["Block Join Requests"] = "가입 요청 차단"
L["|nIf checked, only popout join requests from friends and guild members."] =
	"|n체크 시 친구와 길드원에게서만 가입 요청 팝업이 표시됩니다"
L["Dressing Room"] = "착용 미리보기"
L["Inspect Frame"] = "살펴보기 창"
L["Sync Inspect"] = "살펴보기 동기화"
L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."] =
	"켜면 살펴보기 창의 크기가 캐릭터 창의 크기와 동일하게 설정됩니다"
L["Talents"] = "전문화"
L["Mailbox"] = "우편함"
L["Auction House"] = "경매장"
L["Transmog Frame"] = "형상변환 창"
L["Add more oUF tags. You can use them on UnitFrames configuration."] =
	"추가 oUF 태그를 제공합니다. 유닛 프레임 설정에서 사용 가능합니다"
L["Custom Color"] = "색상 개인설정"
L["Trade Tabs"] = "제작 탭"
L["Enable Tabs on the Profession Frames"] = "제작 전문 기술 창에 탭을 활성화합니다"
L["Train All"] = "모두 배우기"
L["Adds a button to the trainer that learns everything available you can afford."] =
	"구매 가능한 기술을 한 번에 모두 배우는 버튼을 훈련사 창에 추가합니다."
L["Learns %d available entries for %s."] = "배울 수 있는 %d개 항목을 %s에 배웠습니다."
L["Nothing to learn that you can afford."] = "구매 가능한 배울 거리가 없습니다."
L["Auto Combat Log"] = "자동 전투 기록"
L["Turns combat logging on inside the chosen raids and dungeons and off again after you leave. A log you started yourself keeps running."] =
	"선택한 공격대와 던전 안에서 전투 기록을 켜고, 떠나면 다시 끕니다. 직접 시작한 기록은 계속 유지됩니다."
L["Turns this game setting on before logging starts, log sites need it."] =
	"기록을 시작하기 전에 이 게임 설정을 켭니다. 기록 사이트에서 필요로 합니다."
L["Guild Best"] = "길드 최고 기록"
L["No runs this week"] = "이번 주 기록 없음"
L["Lists your guild's best keystone runs of the week in the Mythic+ window. Stays away while RaiderIO shows its own list there."] =
	"쐐기 던전 창에 이번 주 길드의 최고 쐐기 기록을 표시합니다. RaiderIO가 자체 목록을 표시하는 동안에는 표시되지 않습니다."
L["AddOn Usage"] = "애드온 사용량"
L["Blizzard's AddOn profiler is not available."] = "블리자드 애드온 프로파일러를 사용할 수 없습니다."
L["Left Click: Open the AddOn list"] = "좌클릭: 애드온 목록 열기"
L["Paragon Progress"] = "용사 진행도"
L["Reputation panel bars of paragon factions show the progress towards the next reward instead of a full bar."] =
	"용사 평판 진영의 평판 창 막대가 가득 찬 막대 대신 다음 보상까지의 진행도를 표시합니다."
L["Queue Timer"] = "대기열 타이머"
L["Shows the time left to accept a dungeon or battleground invite in a bar below the invite."] =
	"던전 또는 전장 초대를 수락할 수 있는 남은 시간을 초대창 아래 막대로 표시합니다."
L["Group Finder"] = "던전 및 공격대"
L["Vendor"] = "상인"
L["Class Trainer"] = "직업 훈련사"
L["Gossip"] = "대화"
L["Singing Sockets"] = "속성 소켓 도구"
L["Adds a Singing sockets selection tool on the Socketing Frame."] =
	"소켓 장착 창에 속성 소켓 선택 도구를 추가합니다"
L["Pet Filter Tab"] = "애완동물 필터 탭"
L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."] =
	"애완동물 일지에 탭을 추가하여 종류별로 필터링할 수 있습니다"
L["Auction Enhanced"] = "경매장 강화"
L["Show the tertiary stats of equipments in auction house."] = "경매장에서 장비의 3차 능력치를 표시합니다."
L["Hide In Combat"] = "전투시 숨김"
L["Toggle"] = "표시 전환"

-- Nameplates
L["NamePlates"] = "이름표"

-- Notification
L["Notification"] = "알림 표시"
L["Bags Full"] = "가방 꽉 참"
L["This is an example of a notification."] = "이것은 알림의 예시입니다"
L["Test Notification"] = "알림 테스트"
L["Sends an example toast notification."] = "예시 알림을 보냅니다."
L["Notification Mover"] = "알림 위치 이동"
L["%s slot needs to repair, current durability is %d."] =
	"%s 슬롯을 수리해야 합니다. 현재 내구도는 %d입니다"
L["Here you can enable/disable the different notification types."] =
	"여기에서 다양한 알림 유형을 활성화/비활성화할 수 있습니다"
L["Enable Mail"] = "우편 알림 활성화"
L["Enable Invites"] = "초대 알림 활성화"
L["Enable Guild Events"] = "길드 이벤트 알림 활성화"
L["No Sounds"] = "소리 없음"
L["Vignette Print"] = "비네트 좌표 출력"
L["Quick Join"] = "빠른 참가"
L["Your Great Vault has rewards ready to claim!"] = "위대한 금고에 수령 가능한 보상이 있습니다!"
L["Currency Cap Warning"] = "화폐 한도 경고"
L["Track any currency by ID and get a toast once it nears its weekly or total cap."] =
	"ID로 화폐를 추적하고 주간 또는 전체 한도에 가까워지면 알림을 받습니다."
L["Warn at (%)"] = "경고 기준 (%)"
L["Currency ID"] = "화폐 ID"
L["Enter a currency ID and press Enter to add it."] = "화폐 ID를 입력하고 Enter를 눌러 추가하세요."
L["Currency List"] = "화폐 목록"
L["Tracked Currencies"] = "추적 중인 화폐"
L["Unknown or undiscovered currency ID."] = "알 수 없거나 발견하지 못한 화폐 ID입니다."
L["You are close to the cap: %d / %d"] = "한도에 가깝습니다: %d / %d"
L["Title Font"] = "제목 글꼴"
L["Text Font"] = "텍스트 글꼴"
L["Chat Mentions"] = "대화 언급"
L["Shows a toast when your name or one of your keywords comes up in chat. Click the toast to answer in the same channel."] =
	"대화에서 내 이름이나 키워드가 언급되면 알림을 표시합니다. 알림을 클릭하면 같은 채널로 답장할 수 있습니다."
L["Comma separated list of words that trigger a toast. %MYNAME% stands for your character name."] =
	"알림을 발생시킬 단어 목록(쉼표로 구분). %MYNAME%은(는) 캐릭터 이름을 나타냅니다."
L["Channels"] = "채널"
L["Say / Yell"] = "일반 대화 / 외침"
L["Chat Channels"] = "대화 채널"
L["General, Trade and custom channels."] = "공개, 거래 및 사용자 지정 채널입니다."
L["Every whisper shows a toast, no keyword needed."] = "키워드 없이 모든 귓속말에 알림을 표시합니다."
L["Credits"] = "제작자"

-- Actionbars
L["Specialization Bar"] = "전문화 바"
L["Frame Strata"] = "프레임 보임순서"
L["Frame Level"] = "프레임 레벨"
L["Single-Button Assistant"] = "단일 버튼 보조"
L["Brings back Blizzard's rotation frame around its action button, which ElvUI's action bars leave out."] =
	"ElvUI 행동 단축바에서 빠져 있는 블리자드의 연속 시전 프레임을 행동 버튼 주위에 다시 표시합니다."
L["Combat Animation"] = "전투 애니메이션"
L["Spins a glow around the frame while you are in combat."] = "전투 중에는 프레임 주위에 빛이 회전합니다."

-- Armory
L["Armory"] = "전투정보실"
L["Name Text"] = "이름 텍스트"
L["Settings for different font strings"] = "글꼴 문자열 설정"
L["Title Text"] = "제목 텍스트"
L["Level Title Text"] = "레벨 제목 텍스트"
L["Font Color"] = "글꼴 색상"
L["Short Display"] = "간단히 표시"
L["Level Text"] = "레벨 텍스트"
L["Class Text Font"] = "직업 텍스트 글꼴"
L["Class Gradient"] = "직업 색상 그라데이션"
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] =
	"|cffff7d0aMerathilisUI|r 전투정보실 모드를 켜거나 끕니다"
L["Enchant & Socket Strings"] = "마법부여 및 소켓 문자열"
L["Settings for strings displaying enchant and socket info from the items"] =
	"아이템의 마법부여 및 소켓 정보를 표시하는 문자열 설정"
L["Enable/Disable the Enchant text display"] = "마법부여 텍스트 표시 여부 설정"
L["Missing Enchants"] = "누락된 마법부여"
L["Missing Sockets"] = "누락된 소켓"
L["Short Enchant Text"] = "마법부여 텍스트 간소화"
L["Enchant Font"] = "마법부여 글꼴"
L["Item Level"] = "아이템 레벨"
L["Shows the item level on the items in the merchant and trade windows."] = "상인 및 거래 창의 아이템에 아이템 레벨을 표시합니다."
L["The item level on the equipment flyout, the scrapping machine and in the guild news is part of WindTools (Item > Item Level, Misc)."] =
	"장비 선택창, 분해 기계, 길드 소식의 아이템 레벨은 WindTools(아이템 > 아이템 레벨, 기타)에서 설정합니다."
L["Uncollected Appearances"] = "미수집 외형"
L["Marks merchant items whose appearance you have not collected yet and can collect on this character."] =
	"이 캐릭터가 수집할 수 있지만 아직 수집하지 않은 외형의 상인 아이템을 표시합니다."
L["Items you already know are tinted by WindTools (Item > Already Known)."] =
	"이미 알고 있는 아이템은 WindTools(아이템 > 이미 알고 있음)에서 색을 입힙니다."
L["Settings for the Item Level next to your item slot"] =
	"아이템 슬롯 옆에 표시되는 아이템 레벨 설정"
L["Settings for the custom %s Armory decorative lines."] = "사용자 지정 %s 전투정보실 장식선 설정입니다."
L["Enable/Disable the Item Level text display"] = "아이템 레벨 텍스트 표시 여부 설정"
L["Toggle sockets & azerite traits"] = "소켓 및 아제라이트 특성 표시 전환"
L["Item Quality Gradient"] = "아이템 품질 그라데이션"
L["Settings for the color coming out of your item slot."] = "아이템 슬롯에서 나오는 색상 설정"
L["Toggling this on enables the Item Quality bars."] = "활성화 시 아이템 품질 막대 표시"
L["Start Alpha"] = "시작 투명도"
L["End Alpha"] = "종료 투명도"
L["Upgrade Level"] = "강화 단계"
L["A bar next to the item icon shows the upgrade level of the item, e.g. 4 of 6 segments filled."] =
	"아이템 아이콘 옆 막대로 아이템의 강화 단계를 표시합니다. 예: 6칸 중 4칸 채움."
L["Upgrade Track Color"] = "강화 등급 색상"
L["Colors the upgrade bar by the upgrade track of the item: Explorer gray, Adventurer white, Veteran green, Champion blue, Hero purple and Myth orange. Without it the bar goes from red to green with the upgrade level."] =
	"아이템의 강화 등급에 따라 강화 막대에 색을 입힙니다: 탐험가 회색, 모험가 흰색, 노련가 녹색, 챔피언 파란색, 영웅 보라색, 신화 주황색. 끄면 강화 단계에 따라 빨간색에서 녹색으로 변합니다."
L["Upgrade Track"] = "강화 등급"
L["Shows the first letter of the upgrade track in the corner of the item icon, e.g. H for Hero, in the color of the track."] =
	"아이템 아이콘 모서리에 강화 등급의 첫 글자를 등급 색상으로 표시합니다. 예: 영웅은 H."
L["Model"] = "모델"
L["Spotlight"] = "스포트라이트"
L["A soft glow in your class color behind the character."] = "캐릭터 뒤에 직업 색상의 은은한 빛을 표시합니다."
L["Ground Shadow"] = "지면 그림자"
L["A shadow under the feet of the character that follows the camera."] = "카메라를 따라 움직이는 캐릭터 발밑의 그림자입니다."
L["Double-Click Reset"] = "더블클릭 초기화"
L["Double-click the character to reset its rotation, zoom and position."] = "캐릭터를 더블클릭하면 회전, 확대/축소, 위치를 초기화합니다."
L["Highlight Slots"] = "슬롯 강조"
L["Hovering a secondary or tertiary stat dims the item slots that do not have it, gems included."] =
	"2차 또는 3차 능력치에 마우스를 올리면 해당 능력치가 없는 아이템 슬롯(보석 포함)이 어두워집니다."
L["Stat Picker"] = "능력치 선택기"
L["Shows a cog button on the stats of the character frame. It switches to an edit mode where a click shows or hides a stat and dragging changes the order."] =
	"캐릭터 창의 능력치에 톱니바퀴 버튼을 표시합니다. 편집 모드로 전환되며, 클릭하면 능력치를 표시/숨기고 드래그하면 순서를 변경합니다."
L["Reset Stats"] = "능력치 초기화"
L["Restores the default order and visibility of all stats."] = "모든 능력치의 기본 순서와 표시 상태를 복원합니다."
L["Edit Stats"] = "능력치 편집"
L["Reset to Default"] = "기본값으로 초기화"
L["Drag:"] = "드래그:"
L["Change Order"] = "순서 변경"
L["Slot Item Level"] = "슬롯 아이템 레벨"
L["Bags Item Level"] = "가방 아이템 레벨"
L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."] =
	"가방 내 아이템으로 달성 가능한 최대 아이템 레벨을 표시합니다"
L["Format"] = "형식"
L["Decimal format"] = "소수점 형식"
L["Move Sockets"] = "소켓 위치 조정"
L["Crops and moves sockets above enchant text."] =
	"소켓을 잘라내어 마법부여 텍스트 위로 이동시킵니다"
L["Add enchant"] = "마법부여 추가"
L["Attributes"] = "속성"
L["Background Bars"] = "배경 막대"
L["Background Alpha"] = "배경 투명도"
L["Header Font"] = "제목 글꼴"
L["Label Font"] = "이름 글꼴"
L["Value Font"] = "속성 값 글꼴"
L["Short Labels"] = "짧은 이름"
L["Attribute Visibility"] = "속성 표시 여부"
L["Background"] = "배경"
L["Alpha"] = "투명도"
L["Style"] = "디자인"
L["Change the Background image."] = "배경 이미지를 변경합니다"
L["Class Background"] = "직업별 배경"
L["Use class specific backgrounds."] = "직업별로 고유 배경을 사용합니다"
L["Hide Controls"] = "컨트롤 숨기기"
L["Hides the camera controls when hovering the character model."] =
	"캐릭터 모델 위에 마우스를 올렸을 때 카메라 컨트롤을 숨깁니다"
L["Animation"] = "애니메이션"
L["Animation Multiplier"] = "애니메이션 배율"

L["Socket Panel"] = "소켓 패널"
L["Show the socket panel at the bottom of the character sheet."] =
	"캐릭터 정보창 하단에 소켓 패널을 표시합니다."
L["Appearance"] = "모양"
L["Icon Size"] = "아이콘 크기"
L["Horizontal Offset"] = "가로 위치 이동"
L["Vertical Offset"] = "세로 위치 이동"
L["Open on Empty Socket Hover"] = "빈 소켓에 마우스를 올리면 열기"
L["Highlight Equipment Slot"] = "장비 슬롯 하이라이트"
L["Gem Flyout"] = "보석 펼침 창"
L["Row Height"] = "행 높이"
L["Maximum Visible Rows"] = "최대 표시 행 수"
L["Empty Socket"] = "빈 소켓"
L["Pick a gem from the list to socket it."] = "목록에서 보석을 선택하여 장착하세요."
L["No gems in bags."] = "가방에 보석이 없습니다."
L["Loading..."] = "불러오는 중..."
L["Total: %d"] = "합계: %d"
L["Item Stats"] = "아이템 능력치"
L["Shows the main and secondary stat of each item in place of its item level, weapons show their damage per second."] =
	"아이템 레벨 대신 각 아이템의 주 능력치와 2차 능력치를 표시하며, 무기는 초당 피해량(DPS)을 표시합니다."
L["Str"] = "힘"
L["Agi"] = "민첩"
L["Int"] = "지능"
L["Stam"] = "체력"
L["Spi"] = "정신"
L["AP"] = "전투력"
L["RAP"] = "원거리 전투력"
L["SP"] = "주문력"
L["Heal"] = "치유량"
L["Spell Crit"] = "주문 치명"
L["Hit"] = "적중"
L["Spell Hit"] = "주문 적중"
L["MP5"] = "5초당 마나 회복"
L["HP5"] = "5초당 생명력 회복"
L["Def"] = "방어"
L["Dodge"] = "회피"
L["Parry"] = "무기 막기"
L["Block"] = "방패 막기"
L["Spell Pen"] = "주문 관통"
L["DPS"] = "DPS"
L["Search titles..."] = "칭호 검색..."
L["Earned"] = "획득함"
L["Unearned"] = "미획득"
L["Replace Blizzard's native Equipment Manager pane with a custom MerathilisUI gear-set panel."] =
	"블리자드 기본 장비 관리자 창을 MerathilisUI 전용 장비 세트 패널로 교체합니다."
L["Use your class color for the selected/equipped set accents instead of the accent color below."] =
	"선택/착용 중인 세트 강조에 아래의 강조 색상 대신 직업 색상을 사용합니다."
L["Accent Color"] = "강조 색상"
L["Accent color used for the selected/equipped set highlight, unless Class Color is enabled."] =
	"직업 색상을 사용하지 않는 경우, 선택/착용 중인 세트 강조에 사용할 색상입니다."
L["Show Backdrop"] = "배경 표시"
L["Show an opaque dark backdrop behind the gear-set panel."] = "장비 세트 패널 뒤에 불투명한 어두운 배경을 표시합니다."
L["Gear Sets"] = "장비 세트"
L["Equip"] = "착용"
L["Save"] = "저장"
L["Saved!"] = "저장되었습니다!"
L["Cancel"] = "취소"
L["Delete equipment set '%s'?"] = "장비 세트 '%s'을(를) 삭제하시겠습니까?"
L["Change Icon"] = "아이콘 변경"
L["Assign to Spec"] = "전문화에 지정"
L["Unassigned"] = "미지정"
L["+ New Set"] = "+ 새 세트"

-- Unitframes
L["UnitFrames"] = "유닛프레임"
L["Individual Units"] = "개별 프레임[Individual Units]"
L["Group Units"] = "그룹별 프레임[Group Units]"
L["Resting Indicator"] = "휴식 상태 표시기"
L["Custom Texture"] = "텍스처 개인설정"
L["Raid Icon"] = "공격대 아이콘"
L["Change the default raid icons."] = "기본 공격대 아이콘을 변경합니다"
L["Highlight"] = "하이라이트"
L["Adds an own highlight to the Unitframes"] = "유닛 프레임에 고유한 하이라이트 효과를 추가합니다"
L["Auras"] = "오라 설정"

-- Cooldowns
L["Spell List"] = "주문 목록"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] =
	"길드 오늘의 메시지가 변경되었을 경우 별도의 창으로 표시합니다"

-- AFK
L["Jan"] = "1월"
L["Feb"] = "2월"
L["Mar"] = "3월"
L["Apr"] = "4월"
L["May"] = "5월"
L["Jun"] = "6월"
L["Jul"] = "7월"
L["Aug"] = "8월"
L["Sep"] = "9월"
L["Oct"] = "10월"
L["Nov"] = "11월"
L["Dec"] = "12월"

L["Sun"] = "일요일"
L["Mon"] = "월요일"
L["Tue"] = "화요일"
L["Wed"] = "수요일"
L["Thu"] = "목요일"
L["Fri"] = "금요일"
L["Sat"] = "토요일"

-- Install
L["|cffff7d0aMerathilisUI|r Installation"] = "|cffff7d0aMerathilisUI|r 설치"
L["Step %d of %d"] = "%d / %d 단계"
L["Welcome"] = "환영합니다"
L["Welcome to %s"] = "%s에 오신 것을 환영합니다"
L["This installer sets up MerathilisUI in a few steps. Everything can be changed later in the options."] =
	"이 설치 마법사는 몇 단계만에 MerathilisUI를 설정합니다. 모든 항목은 나중에 설정에서 변경할 수 있습니다."
L["Version %s for ElvUI %s"] = "버전 %s (ElvUI %s용)"
L["Import Existing"] = "기존 설정 가져오기"
L["Import Existing takes over the MerathilisUI profile %s and the settings of %s, for example from your main character."] =
	"기존 설정 가져오기는 MerathilisUI 프로필 %s와(과) %s의 설정을 가져옵니다. 예를 들어 주 캐릭터의 설정입니다."
L["Use the MerathilisUI profile %s (layout %s) and the settings of %s for this character? The UI reloads afterwards."] =
	"이 캐릭터에 MerathilisUI 프로필 %s(레이아웃 %s)와(과) %s의 설정을 사용하시겠습니까? 이후 UI가 다시 불러와집니다."
L["Skip"] = "건너뛰기"
L["Closes the installer without changing anything. It does not open again by itself, run it anytime with /mer install."] =
	"아무것도 변경하지 않고 설치 마법사를 닫습니다. 자동으로 다시 열리지 않으며 /mer install로 언제든지 실행할 수 있습니다."
L["Recommended"] = "권장"
L["MerathilisUI changes a lot of ElvUI settings. A new profile keeps your current one untouched, so you can switch back anytime."] =
	"MerathilisUI는 많은 ElvUI 설정을 변경합니다. 새 프로필을 만들면 현재 프로필은 그대로 유지되므로 언제든지 되돌릴 수 있습니다."
L["Creates a fresh profile for this character and installs MerathilisUI into it."] =
	"이 캐릭터용 새 프로필을 만들고 그 안에 MerathilisUI를 설치합니다."
L["Use Current Profile"] = "현재 프로필 사용"
L["Installs MerathilisUI into %s. Your changes in this profile get overwritten."] =
	"MerathilisUI를 %s에 설치합니다. 이 프로필에서 변경한 내용은 덮어씌워집니다."
L["Name for the new profile"] = "새 프로필 이름"
L["A profile with that name already exists."] = "같은 이름의 프로필이 이미 존재합니다."
L["Choose how big the interface is. Auto Scale picks the pixel perfect size for your resolution."] =
	"인터페이스 크기를 선택하세요. 자동 크기 조절은 해상도에 맞는 픽셀 퍼펙트 크기를 선택합니다."
L["Pixel perfect for %s"] = "%s에 맞는 픽셀 퍼펙트"
L["More room on the screen"] = "더 넓은 화면 공간"
L["A balanced size"] = "균형 잡힌 크기"
L["Easier to read"] = "더 읽기 쉬운 크기"
L["Applies the complete MerathilisUI layout: general look, chat, datatexts, action bars, nameplates and unit frames. Pick the unit frame style you like."] =
	"MerathilisUI 전체 레이아웃(전반적인 모양, 대화창, 데이터 텍스트, 행동 단축바, 이름표, 유닛 프레임)을 적용합니다. 원하는 유닛 프레임 스타일을 선택하세요."
L["Class colored health bars with a soft gradient."] = "부드러운 그라데이션이 적용된 직업 색상 생명력 바."
L["Dark health bars with the class color on their backdrop."] = "배경에 직업 색상이 들어간 어두운 생명력 바."
L["Recommended game settings (CVars)"] = "권장 게임 설정 (CVar)"
L["Changes a few World of Warcraft settings, for example the camera distance, nameplates and chat. They are tailored to the author of MerathilisUI and not needed for the layout."] =
	"카메라 거리, 이름표, 대화창 등 월드 오브 워크래프트 설정 몇 가지를 변경합니다. MerathilisUI 제작자에게 맞춰진 설정이며 레이아웃에는 필요하지 않습니다."
L["Overwrites the layout settings of the current profile."] = "현재 프로필의 레이아웃 설정을 덮어씁니다."
L["Installing ..."] = "설치 중 ..."
L["Enable All"] = "모두 사용"
L["Disable All"] = "모두 사용 안 함"
L["%d of %d enabled"] = "%d / %d 사용 중"
L["Shows a styled bar for vehicles and skyriding, with vigor and speed."] = "탈것과 스카이라이딩용 스타일 바를 표시하며 활력과 속도를 보여줍니다."
L["Shows toasts for new mail, invites, guild events, the Great Vault and more."] =
	"새 우편, 초대, 길드 이벤트, 위대한 금고 등에 대한 알림을 표시합니다."
L["Shows the name, guild and level of the unit under your mouse right next to the cursor."] =
	"마우스 아래 유닛의 이름, 길드, 레벨을 커서 바로 옆에 표시합니다."
L["Blizzard's Edit Mode places a few frames ElvUI does not move. Import the MerathilisUI Edit Mode layout in two steps."] =
	"블리자드의 편집 모드는 ElvUI가 이동하지 않는 일부 프레임을 배치합니다. MerathilisUI 편집 모드 레이아웃을 두 단계로 가져옵니다."
L["Copy the Layout String"] = "레이아웃 문자열 복사"
L["Opens a window with the string. Select it with CTRL+A and copy it with CTRL+C."] =
	"문자열이 담긴 창을 엽니다. CTRL+A로 전체 선택하고 CTRL+C로 복사하세요."
L["Pick Import in the layout dropdown, paste the string with CTRL+V, give it a name and click Import."] =
	"레이아웃 드롭다운에서 가져오기를 선택하고 CTRL+V로 문자열을 붙여넣은 뒤 이름을 지정하고 가져오기를 클릭하세요."
L["String copied"] = "문자열 복사됨"
L["AddOn Profiles"] = "애드온 프로필"
L["MerathilisUI brings matching profiles for these AddOns. Click an AddOn to apply its profile."] =
	"MerathilisUI는 이 애드온들에 맞는 프로필을 제공합니다. 애드온을 클릭하면 해당 프로필이 적용됩니다."
L["Click to apply the profile"] = "클릭하여 프로필 적용"
L["Profile applied"] = "프로필 적용됨"
L["%d applied"] = "%d개 적용됨"
L["Settings only the developer of MerathilisUI uses."] = "MerathilisUI 제작자만 사용하는 설정입니다."
L["UI scale, chat bubbles, ElvUI user tags and a few module settings."] = "UI 크기, 말풍선, ElvUI 사용자 태그 및 일부 모듈 설정."
L["Applied"] = "적용됨"
L["Summary"] = "요약"
L["Skipped"] = "건너뜀"
L["Finish & Reload"] = "완료 및 다시 불러오기"
L["ActionBars"] = "행동단축바"


L["DataTexts"] = "정보문자"
L["EditMode"] = "편집 모드"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] =
	"현재 사용 중인 ElvUI 버전이 |cffff7d0aMerathilisUI|r에서 권장하는 버전보다 낮습니다. 현재 버전: |cff00c0fa%.2f|r (권장 버전: |cff00c0fa%.2f|r). MerathilisUI가 로드되지 않았습니다. ElvUI를 업데이트해주세요."
L["MSG_MER_ELV_MISMATCH"] =
	"현재 ElvUI 버전이 예상보다 높습니다. MerathilisUI를 업데이트하지 않으면 문제가 발생하거나 |cffFF0000이미 문제가 발생했을 수 있습니다|r."

-- Skins
L["MER_ADDONSKINS_DESC"] = [[이 섹션은 외부 애드온의 외형을 수정하기 위한 설정입니다.

참고: 해당 애드온이 애드온 제어 패널에서 로드되지 않은 경우, 일부 옵션은 |cff636363비활성화|r됩니다.]]
L["Screen Shadow Overlay"] = "화면 그림자 오버레이"
L["Restyles the Blizzard frames and the supported AddOns in the MerathilisUI look."] =
	"블리자드 프레임과 지원되는 애드온을 MerathilisUI 스타일로 다시 꾸밉니다."
L["Enables/Disables a shadow overlay to darken the screen."] =
	"화면을 어둡게 만드는 그림자 오버레이를 활성화하거나 비활성화합니다"
L["Backdrop Color"] = "배경 색상"
L["Character Frame"] = "캐릭터 창"
L["Item Upgrade"] = "아이템 강화 창"
L["Trade"] = "거래"
L["Misc"] = "기타"
L["%s is not loaded."] = "%s가 로드되지 않았습니다"
L["Left Color"] = "왼쪽 색상"
L["Right Color"] = "오른쪽 색상"
L["The options below is only for the Details look, NOT the Embeded."] =
	"아래 옵션은 'Details' 외형용이며, 내장 모드가 아닙니다"
L["Embed Settings"] = "내장 설정"
L["With this option you can embed your Details into an own Panel."] =
	"이 옵션으로 'Details' 애드온을 별도 패널에 내장할 수 있습니다"
L["Number of Windows"] = "창 개수"
L["Window %d"] = "창 %d"
L["Reset Settings"] = "설정 초기화"
L["Toggle Direction"] = "방향 전환"
L["TOP"] = "위쪽"
L["BOTTOM"] = "아래쪽"
L["Advanced Skin Settings"] = "고급 스킨 설정"
L["Gradient Bars"] = "그라데이션 바"
L["Open Details"] = "Details 열기"
L["Fonts"] = "글꼴"
L["AddOns"] = "애드온"

-- Panels
L["Panels"] = "패널"
L["Top Panel"] = "상단 패널 표시"
L["Bottom Panel"] = "하단 패널 표시"
L["Style Panels"] = "스타일 패널"
L["Top Left Panel"] = "좌측 상단 패널"
L["Top Left Extra Panel"] = "좌측 상단 보조 패널"
L["Top Right Panel"] = "우측 상단 패널"
L["Top Right Extra Panel"] = "우측 상단 보조 패널"
L["Bottom Left Panel"] = "좌측 하단 패널"
L["Bottom Left Extra Panel"] = "좌측 하단 보조 패널"
L["Bottom Right Panel"] = "우측 하단 패널"
L["Bottom Right Extra Panel"] = "우측 하단 보조 패널"

-- LootSpecManager
L["LootSpecManager"] = "전리품 전문화 관리자"
L["LootSpecManagerTips"] = "|n이 기능은 LootSpecManager를 기반으로 하며, 우두머리마다 전리품 전문화를 자동으로 변경합니다. 공격대와 쐐기 던전을 지원합니다."
L["LootSpecManagerRaidStart"] = "우두머리 전투 시작. 전문화가 변경되었습니다."
L["LootSpecManagerM+Start"] = "쐐기 던전 시작, 전리품 전문화가 변경되었습니다."

-- Vehicle Bar
L["VehicleBar"] = "탈것 바"
L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."] =
	"탈것 바의 버튼 너비를 변경합니다. 높이는 4:3 비율에 따라 자동으로 조정됩니다"
L["Thrill Color"] = "활력 속도 색상"
L["Animations"] = "애니메이션"
L["Animation Speed"] = "애니메이션 속도"
L["Hide ElvUI Bars"] = "ElvUI 바 숨기기"

-- Raid Info Frame
L["Raid Info Frame"] = "공격대 정보 창"
L["Cinematics"] = "영상"
L["Media Player"] = "미디어 플레이어"
L["Open Media Player"] = "미디어 플레이어 열기"
L["Browse the game's music by expansion and zone and play it as a playlist, or replay the cinematics. The search finds tracks, zones and cinematics. The game's own music pauses while a track plays."] =
	"게임 음악을 확장팩과 지역별로 둘러보며 재생 목록으로 재생하거나 영상을 다시 볼 수 있습니다. 검색으로 음악, 지역, 영상을 찾을 수 있습니다. 음악이 재생되는 동안에는 게임 자체 음악이 일시 정지됩니다."
L["Also opens with %s."] = "%s(으)로도 열 수 있습니다."
L["Back"] = "뒤로"
L["Battlegrounds & Arenas"] = "전장 및 투기장"
L["Click a track to play it, the zone's other tracks follow."] = "트랙을 클릭하면 재생되고, 해당 지역의 다른 트랙이 이어서 재생됩니다."
L["Dungeons"] = "던전"
L["Next"] = "다음"
L["Not downloaded"] = "다운로드되지 않음"
L["Nothing found."] = "검색 결과가 없습니다."
L["Now Playing:"] = "재생 중:"
L["Other Music"] = "기타 음악"
L["Previous"] = "이전"
L["Scenarios"] = "시나리오"
L["Search tracks, zones and cinematics"] = "음악, 지역, 영상 검색"
L["Search: %s"] = "검색: %s"
L["Stop"] = "정지"
L["Tracks"] = "트랙"
L["Various"] = "기타"
L["Zones"] = "지역"
L["Cinematics can't be played in combat."] = "전투 중에는 영상을 재생할 수 없습니다."
L["This cinematic is not available, it may still be downloading."] = "이 영상을 재생할 수 없습니다. 아직 다운로드 중일 수 있습니다."
L[" provides a Raid Info Frame that shows a list of players per role in your raid."] =
	"공격대에서 역할별로 플레이어 목록을 보여주는 공격대 정보 창을 제공합니다"
L["Temporarily shows the frame even outside of a raid for easier customization."] =
	"공격대 외부에서도 일시적으로 창을 표시하여 사용자 설정을 쉽게 합니다"
L["Customization"] = "사용자정의(개인설정)"
L["Set the size of the text and icons."] = "텍스트와 아이콘의 크기를 설정합니다"
L["Padding"] = "패딩"
L["Set the outside padding of the frame."] = "프레임 외부 여백(패딩)을 설정합니다"
L["Set the spacing between the icons."] = "아이콘 사이 간격을 설정합니다"
L["Set the backdrop color of the frame."] = "프레임 배경 색상을 설정합니다"
L["Change the look of the icons"] = "아이콘의 외형을 변경합니다"
L["Displays the current count of Tanks, Healers, and DPS in your raid group."] =
	"공격대 내의 탱커, 힐러, 딜러 인원수를 표시합니다"
L["|cffFFFFFFLeft Click:|r Toggle Raid Frame"] = "|cffFFFFFF좌클릭:|r 공격대 정보 창 표시/숨기기"
L["|cffFFFFFFRight Click:|r Toggle Settings"] = "|cffFFFFFF우클릭:|r 설정 창 표시/숨기기"

-- Profiles
L["MER_PROFILE_DESC"] = [[이 섹션에서는 일부 애드온을 위한 프로필을 생성합니다.

|cffff0000경고:|r 기존 프로필이 덮어쓰이거나 삭제될 수 있습니다. MerathilisUI 프로필을 적용하고 싶지 않다면 아래 버튼을 누르지 마세요.]]
L["Changes are only applied to the ElvUI profile after clicking Apply."] = "변경 사항은 적용을 클릭한 후에야 ElvUI 프로필에 반영됩니다."
L["Main Font"] = "주 글꼴"
L["Number Font"] = "숫자 글꼴"
L["Font Size Offset"] = "글꼴 크기 보정"
L["Added to every font size the profile sets."] = "프로필이 설정한 모든 글꼴 크기에 더해집니다."
L["Default keeps the outline each element uses in the profile."] = "기본값은 프로필에서 각 요소가 사용하는 외곽선을 유지합니다."

-- Advanced Settings
L["Advanced Settings"] = "고급 설정"
L["The message will be shown in chat when you login."] = "로그인 시 채팅창에 메시지가 표시됩���다"
L["This section will help reset specfic settings back to default."] =
	"이 섹션에서는 특정 설정을 기본값으로 초기화할 수 있습니다"

-- Gradient colors
L["Theme"] = "테마"
L["Warning: Enabling one of these settings may overwrite colors or textures in ElvUI, they also prevent you from changing certain settings in ElvUI!"] =
	"경고: 이 설정 중 하나를 활성화하면 ElvUI의 색상이나 텍스처를 덮어쓸 수 있으며, ElvUI의 일부 설정을 변경할 수 없게 됩니다!"
L["Toggling this on enables fancy gradients for "] = "이 옵션을 켜면 멋진 그라데이션이 적용됩니다: "
L["Warning: Enabling this setting will overwrite textures in ElvUI!"] = "경고: 이 설정을 활성화하면 ElvUI의 텍스처를 덮어씁니다!"
L[" Gradient theme "] = " 그라데이션 테마 "
L[" from one color to another. You can change the "] = " 한 색상에서 다른 색상으로 이어집니다. 변경 가능한 항목: "
L[" below.\n\n"] = "\n\n"
L["Class Colors"] = "직업 색상"
L["NPC Colors"] = "NPC 색상"
L["Here you can change the "] = "여기에서 변경할 수 있는 항목: "
L["Power Colors"] = "자원 색상"
L["Non-interruptible"] = "차단 불가"
L["Regular"] = "일반"
L["Here you can change additional settings for the %s."] = "%s의 추가 설정을 여기에서 변경할 수 있습니다."
L[" of NPC colors.\n\n"] = " (NPC 색상)\n\n"
L[" of Power colors.\n\n"] = " (자원 색상)\n\n"
L["Other Colors"] = "기타 색상"
L["State Colors"] = "상태 색상"
L[" of State colors.\n\n"] = " (상태 색상)\n\n"
L["Castbar Colors"] = "시전 바 색상"
L[" of Castbar colors.\n\n"] = " (시전 바 색상)\n\n"
L["Fade Direction"] = "페이드 방향"
L["Player & Target"] = "플레이어 및 대상"
L["Control the gradient fade direction for player and target unitframes.\n\n"] =
	"플레이어 및 대상 유닛 프레임의 그라데이션 페이드 방향을 조절합니다.\n\n"
L["Group Frames"] = "그룹 프레임"
L["Control the gradient fade direction for party and raid unitframes.\n\n"] =
	"파티 및 공격대 유닛 프레임의 그라데이션 페이드 방향을 조절합니다.\n\n"
L["Boss & Arena"] = "우두머리 및 투기장"
L["Control the gradient fade direction for boss and arena unitframes.\n\n"] =
	"우두머리 및 투기장 유닛 프레임의 그라데이션 페이드 방향을 조절합니다.\n\n"
L["Role Frames"] = "역할 프레임"
L["Control the gradient fade direction for tank and assist unitframes.\n\n"] =
	"탱커 및 지원 유닛 프레임의 그라데이션 페이드 방향을 조절합니다.\n\n"
L["UnitFrame Textures"] = "유닛 프레임 텍스처"
L["Change the textures used for UnitFrame's Health, Power and Cast status bars."] =
	"유닛 프레임의 생명력, 자원, 시전 상태 바에 사용하는 텍스처를 변경합니다."
L["Health Texture"] = "생명력 텍스처"
L["Health bar texture for UnitFrames"] = "유닛 프레임 생명력 바 텍스처"
L["Power Texture"] = "자원 텍스처"
L["Power bar texture for UnitFrames"] = "유닛 프레임 자원 바 텍스처"
L["Castbar Texture"] = "시전 바 텍스처"
L["Castbar texture for UnitFrames"] = "유닛 프레임 시전 바 텍스처"
L["Background Brightness"] = "배경 밝기"
L["This controls the strength of the background colors.\n\nLower value means a darker background, higher value means a lighter background.\n\n"] =
	"배경 색상의 강도를 조절합니다.\n\n값이 낮을수록 배경이 어두워지고, 높을수록 밝아집니다.\n\n"
L["Warning: Setting this too high may cause readability issues!"] = "경고: 값을 너무 높게 설정하면 가독성이 떨어질 수 있습니다!"
L["Saturation Boost"] = "채도 강화"
L["Boosts the saturation and darkens "] = "채도를 높이고 어둡게 합니다: "
L[" Colors|r\nFor people that like it a bit more extreme\n\n"] = " 색상|r\n좀 더 강한 느낌을 원하는 분들을 위한 옵션입니다\n\n"
L["Shift Lightness"] = "변화 명도"
L["Control the Lightness value of HSL for the Shift color."] = "변화 색상의 HSL 명도 값을 조절합니다."
L["Shift Saturation"] = "변화 채도"
L["Control the Saturation value of HSL for the Shift color."] = "변화 색상의 HSL 채도 값을 조절합니다."
L["Normal Lightness"] = "일반 명도"
L["Control the Lightness value of HSL for the Normal color."] = "일반 색상의 HSL 명도 값을 조절합니다."
L["Normal Saturation"] = "일반 채도"
L["Control the Saturation value of HSL for the Normal color."] = "일반 색상의 HSL 채도 값을 조절합니다."

-- Addons
L["Skins/AddOns"] = "스킨/애드온"
L["Profiles"] = "프로필"
L["BigWigs"] = "BigWigs"
L["Create and apply the profile"] = "프로필 생성 및 적용"
L["AddOn is not enabled"] = "애드온이 활성화되지 않았습니다"
L["This will create and apply profile for "] =
	"이 설정은 다음 애드온에 대한 프로필을 생성하고 적용합니다: "

-- Changelog
L["Changelog"] = "변경 사항"
L["What's New in %s"] = "%s 업데이트 내용"
L["Full Changelog"] = "전체 변경 내역"
L["In Development"] = "개발 중"
L["Did you know?"] = "알고 계셨나요?"
L["Go to Option"] = "설정으로 이동"
L["Type /mer status to open the Status Report. Post it when you report a bug."] =
	"/mer status를 입력하면 상태 보고서가 열립니다. 버그를 신고할 때 함께 첨부해 주세요."
L["/muidebug on turns off all other addons except ElvUI, WindTools, MerathilisUI and BugSack. /muidebug off turns them back on."] =
	"/muidebug on은 ElvUI, WindTools, MerathilisUI, BugSack을 제외한 모든 애드온을 끕니다. /muidebug off는 다시 켭니다."
L["Type /mer changelog to read what changed in every version."] = "/mer changelog를 입력하면 모든 버전의 변경 사항을 볼 수 있습니다."
L["Movement Alert shows the cooldown of your movement spells while they are not ready."] =
	"이동 알림은 이동 주문이 재사용 대기 중일 때 남은 시간을 표시합니다."
L["The Tracker shows your group's battle res charges in Mythic+ keys and raid boss encounters."] =
	"추적기는 쐐기 던전과 공격대 우두머리 전투에서 파티의 전투 부활 충전 횟수를 표시합니다."
L["Cursor puts a colored ring around your mouse cursor, optionally with a GCD and cast ring."] =
	"커서는 마우스 커서 주위에 색상 링을 표시하며, 선택적으로 전역 재사용 대기시간(GCD) 및 시전 링도 표시할 수 있습니다."
L["The Chat Sidebar gives quick access to friends, guild, copy chat and M+ portals."] =
	"대화창 사이드바에서 친구, 길드, 대화 복사, 쐐기 던전 차원문에 빠르게 접근할 수 있습니다."
L["Loot Roll replaces the roll frames with a movable bar. Its Test button shows a preview."] =
	"전리품 주사위는 기본 주사위 창을 이동 가능한 바로 대체합니다. 테스트 버튼으로 미리 볼 수 있습니다."
L["Buff Reminder shows icons for the raid buffs you are missing."] = "버프 알림은 부족한 공격대 버프의 아이콘을 표시합니다."
L["HoverCast casts your spells on the unit frame or unit under your mouse and replaces Clique."] =
	"마우스오버 시전은 마우스 아래의 유닛 프레임 또는 유닛에 주문을 시전하며 Clique를 대체합니다."
L["HoverCast's Quickbind binds a spell in one step: hover it and press a key or click."] =
	"마우스오버 시전의 퀵바인드는 한 번에 주문을 단축키로 지정합니다. 주문 위에 마우스를 올리고 키를 누르거나 클릭하세요."
L["Singing Sockets adds a selection tool to the socketing frame."] = "속성 소켓 도구는 소켓 창에 선택 도구를 추가합니다."
L["The Game Menu can show random battle pets."] = "게임 메뉴에 무작위 전투 애완동물을 표시할 수 있습니다."
L["Type /mer install to run the installer again, e.g. to reapply the MerathilisUI profile."] =
	"/mer install을 입력하면 설치 마법사를 다시 실행합니다. 예: MerathilisUI 프로필을 다시 적용할 때."
L["Type /mlr to preview the Loot Roll bar with test rolls."] = "/mlr을 입력하면 테스트 주사위로 전리품 주사위 바를 미리 볼 수 있습니다."
L["Type /lsm to open the LootSpecManager. It switches your loot spec per boss in raids and Mythic+."] =
	"/lsm을 입력하면 전리품 전문화 관리자가 열립니다. 공격대와 쐐기 던전에서 우두머리마다 전리품 전문화를 전환합니다."
L["Interrupt Ready colors enemy castbars while your interrupt is on cooldown and marks when it is ready again."] =
	"차단 준비는 차단기가 재사용 대기 중일 때 적 시전 바에 색을 입히고, 다시 사용 가능해지면 표시합니다."
L["In Mythic+, the nameplates can show how much Enemy Forces each enemy is worth."] =
	"쐐기 던전에서는 이름표에 각 적이 차지하는 적 병력 비율을 표시할 수 있습니다."
L["Cast on You marks the castbar of enemies whose cast targets you."] = "나에게 시전은 대상이 나인 적의 시전 바를 표시합니다."
L["Categorized Bags sorts your bags into groups like equipment, consumables and quest items."] =
	"분류된 가방은 가방을 장비, 소모품, 퀘스트 아이템 등의 그룹으로 정리합니다."
L["The Armory warns you about missing enchants and sockets on your gear."] = "전투정보실은 장비의 누락된 마법부여와 보석 소켓을 경고합니다."
L["Mail adds checkboxes to open or delete several mails at once and saves recipient lists."] =
	"우편은 여러 우편을 한 번에 열거나 삭제할 수 있는 체크박스를 추가하고 수신자 목록을 저장합니다."
L["Right-click the Durability/Ilevel datatext to summon your repair mount."] =
	"내구도/아이템 레벨 데이터 텍스트를 우클릭하면 수리용 탈것을 소환합니다."
L["The Minimap Buttons bar adds a Great Vault button and your M+ portals next to the Minimap."] =
	"미니맵 버튼 바는 미니맵 옆에 위대한 금고 버튼과 쐐기 던전 차원문을 추가합니다."
L["Addon Buttons on the Minimap Buttons bar collects the minimap buttons of your addons into one grid."] =
	"미니맵 버튼 바의 애드온 버튼은 애드온의 미니맵 버튼을 하나의 격자로 모아줍니다."
L["Want an addon button to stay on the Minimap? Add its name to the Ignored Buttons of Addon Buttons."] =
	"애드온 버튼을 미니맵에 그대로 두고 싶으신가요? 애드온 버튼의 무시할 버튼 목록에 이름을 추가하세요."
L["The Location Panel above the Minimap can show your coordinates. Left-click it to open the World Map, right-click to link your location in chat."] =
	"미니맵 위의 위치 패널은 좌표를 표시할 수 있습니다. 좌클릭하면 세계 지도가 열리고, 우클릭하면 현재 위치를 대화창에 링크합니다."
L["The Specialization Bar switches your spec with a left click and your loot spec with a right click."] =
	"전문화 바는 좌클릭으로 전문화를, 우클릭으로 전리품 전문화를 전환합니다."
L["Auras can add a collapse button to your buffs that hides long-lasting ones until they are about to expire."] =
	"오라는 오래 지속되는 버프를 만료 직전까지 숨기는 접기 버튼을 버프에 추가할 수 있습니다."
L["Item Level shows the item level on items in the merchant and trade windows."] =
	"아이템 레벨은 상인 및 거래 창의 아이템에 아이템 레벨을 표시합니다."
L["The Raid Info Frame lists the players in your raid by role."] = "공격대 정보 창은 공격대원을 역할별로 나열합니다."
L["MerathilisUI adds extra oUF tags you can use in the UnitFrames options."] =
	"MerathilisUI는 유닛 프레임 설정에서 사용할 수 있는 oUF 태그를 추가로 제공합니다."
L["Categorized Bags can also show your items as a sortable list or as compact blocks. Switch it with the button in the bag's title bar."] =
	"분류된 가방은 아이템을 정렬 가능한 목록이나 간결한 블록으로 표시할 수도 있습니다. 가방 제목 표시줄의 버튼으로 전환하세요."
L["The Junk Marker of Categorized Bags marks items as junk with a click, Sell Junk then sells all of them at a vendor."] =
	"분류된 가방의 잡템 표시는 클릭으로 아이템을 잡템으로 표시하고, 잡템 판매는 상인에게서 한 번에 모두 판매합니다."
L["Neutral Name Only shows only the name of idle neutral NPCs and gives them their full nameplate back in combat."] =
	"중립 이름만 표시는 대기 중인 중립 NPC의 이름만 표시하고, 전투 중에는 전체 이름표를 다시 표시합니다."
L["The options window opens at a size that fits your screen. Reposition Window at the bottom of the window brings it back to that size."] =
	"설정 창은 화면에 맞는 크기로 열립니다. 창 하단의 창 위치 초기화를 누르면 해당 크기로 되돌립니다."

-- Compatibility
L["Compatibility Check"] = "호환성 검사"
L["Shared Features Found"] = "중복 기능 발견"
L["Some of your ElvUI plugins offer the same features as %s. Running both can cause errors or a doubled look, so turn off the one you don't want to use."] =
	"일부 ElvUI 플러그인이 %s와(과) 같은 기능을 제공합니다. 둘 다 실행하면 오류나 중복 표시가 발생할 수 있으니, 사용하지 않을 쪽을 끄세요."
L["Later"] = "나중에"
L["Features left on for both won't be asked about again. Apply reloads the UI when something was turned off."] =
	"둘 다 켜 둔 기능은 다시 묻지 않습니다. 끈 항목이 있으면 적용 시 UI를 다시 불러옵니다."
L["No shared features with your other ElvUI plugins found."] = "다른 ElvUI 플러그인과 중복되는 기능이 없습니다."
L["%d shared |4feature:features;"] = "중복 기능 %d개"
L["Details Embed"] = "Details 내장"
L["After login, checks if another ElvUI plugin has the same features turned on and lets you choose which one to keep."] =
	"로그인 후 다른 ElvUI 플러그인에 같은 기능이 켜져 있는지 확인하고 어느 쪽을 유지할지 선택하게 합니다."
L["Check Now"] = "지금 검사"
L["Runs the compatibility check now, including the features you kept on for both."] =
	"둘 다 켜 두기로 한 기능을 포함해 지금 호환성 검사를 실행합니다."

-- Profiles
L[" Apply"] = "적용"
L[" Reset"] = "초기화"
L["This group allows to update all fonts used in the "] =
	"이 그룹에서는 다음 UI에서 사용되는 모든 글꼴을 업데이트할 수 있습니다: "
L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"] =
	"경고: 일부 글꼴은 이상적으로 보이지 않을 수 있습니다! 최상의 결과는 아니더라도 글꼴 커스터마이징에는 도움이 될 거예요 :)\n"
L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] =
	"모든 |cffffffffMerathilis|r|cffff7d0aUI|r 글꼴 설정을 적용합니다"
L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] =
	"모든 |cffffffffMerathilis|r|cffff7d0aUI|r 글꼴 설정을 초기화합니다"

-- Debug
L["Usage"] = "사용법"
L["Enable debug mode"] = "디버그 모드 활성화"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] =
	"ElvUI Core, ElvUI %s 및 BugSack을 제외한 다른 모든 애드온을 비활성화합니다."
L["Disable debug mode"] = "디버그 모드 비활성화"
L["Reenable the addons that disabled by debug mode."] =
	"디버그 모드에서 비활성화된 애드온을 다시 활성화합니다."
L["Debug Enviroment"] = "디버그 환경"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] =
	"|cff00ff00/muidebug off|r 명령을 사용하여 디버그 모드를 종료할 수 있습니다."
L["After you stop debuging, %s will reenable the addons automatically."] =
	"디버깅을 중지하면 %s이(가) 애드온을 자동으로 다시 활성화합니다."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] =
	"버그를 제출하기 전에 %s을(를) 사용하여 디버그 모드를 활성화하고 한 번 더 테스트하십시오."
L["If you get an error, open the Status Report with %s, click %s and paste the text into your report."] =
	"오류가 발생하면 %s(으)로 상태 보고서를 열고 %s을(를) 클릭한 뒤 텍스트를 보고서에 붙여넣으세요."
L["Error"] = "오류"
L["Warning"] = "경고"

-- Abbreviate

-- AUTO-ADDED PLACEHOLDERS START (do not remove without review)
-- AUTO-PLACEHOLDER
-- AUTO-ADDED PLACEHOLDERS END

-- Additional locale entries for consistency
L["AddOnSkins"] = true
L["Default"] = "기본값"
L["Level"] = "레벨"

-- Automatically added missing keys
L[" Raid Info Frame"] = " 공격대 정보 창"
L["%day%-%month%-%year%"] = "%day%-%month%-%year%"
L[".\n\n"] = ".\n\n"
L["Abbreviates the enchant strings."] = "마법부여 문자열을 축약합니다."
L["Add"] = "추가"
L["Add %d socket"] = "소켓 %d개 추가"
L["Addon Skins"] = "애드온 스킨"
L["Addons"] = "애드온"
L["Adds a button to the character and inspect frame that allows you to copy a list of the currently transmogrified items."] =
	"캐릭터 창과 살펴보기 창에 현재 형상변환된 아이템 목록을 복사할 수 있는 버튼을 추가합니다."
L["Anchor Point"] = "기준점"
L["Are you sure you want to import this string?"] = "이 문자열을 가져오시겠습니까?"
L["Arena"] = "투기장"
L["Assist"] = "지원 공격"
L["Assist Target"] = "지원 대상"
L["Auto Copy Private Profile"] = "비공개 프로필 자동 복사"
L["Import / Export"] = "가져오기 / 내보내기"
L["Auto Scale"] = "UI 자동조절"
L["Automatically copy the selected private profile to a new character on first login."] =
	"첫 로그인 시 선택한 비공개 프로필을 새 캐릭터에 자동으로 복사합니다."
L["BACKGROUND"] = "BACKGROUND"
L["BagSync"] = "BagSync"
L["Bags"] = "가방"
L["Bar Height"] = "바 높이"
L["Bar Settings"] = "행동단축바 설정"
L["BigWigs is not installed or enabled."] = "BigWigs가 설치되어 있지 않거나 활성화되지 않았습니다."
L["Blacklist"] = "블랙리스트"
L["Blizzard"] = "블리자드"
L["Blizzard DamageMeter"] = "블리자드 피해량 측정기"
L["Blizzard Inspect Button Fallback"] = "블리자드 살펴보기 버튼 대체"
L["Blizzard Tool Tip"] = "블리자드 툴팁"
L["Blizzard ToolTip Options"] = "블리자드 툴팁 설정"
L["Boss"] = "보스(Boss)"
L["Button Size"] = "버튼 크기"
L["Button Width"] = "버튼 너비"
L["Buttons"] = "버튼 수"
L["Capping"] = "Capping"
L["Change the Skyriding Bar's height."] = "스카이라이딩 바의 높이를 변경합니다."
L["Changelog Popup"] = "변경 내역 팝업"
L["Character"] = "캐릭터"
L["Chat"] = "채팅창"
L["Check the setting of ElvUI Private database in ElvUI Options -> Profiles -> Private (tab)."] =
	"ElvUI 설정 -> 프로필 -> 개인 설정(탭)에서 ElvUI 개인 데이터베이스 설정을 확인하세요."
L["AussyLoot"] = true
L["Class Codex"] = "직업 도감"
L["Class Color"] = "직업 색상"
L["Classification"] = "분류"
L["Clear Initialized Characters"] = "초기화된 캐릭터 기록 삭제"
L["Clear the record of initialized characters, allowing the profile to be copied again on next login."] =
	"초기화된 캐릭터 기록을 삭제하여 다음 로그인 시 프로필이 다시 복사되도록 합니다."
L["Clique"] = "Clique"
L["Collections"] = "수집품"
L["Color"] = "색상"
L["Color Modifier Keys"] = "보조키 색상 지정"
L["Color Settings"] = "색상 설정"
L["Cooldown Manager"] = "재사용 대기시간 관리자"
L["Tooltip"] = "툴팁"
L["Copy From"] = "복사해오기"
L["Copy Transmog"] = "형상변환 복사"
L["Could not add the texture."] = "텍스처를 추가할 수 없습니다."
L["Could not convert unicode "] = "유니코드를 변환할 수 없습니다: "
L["Credits: ElvUI_ToxiUI"] = "제작자: ElvUI_ToxiUI"
L["Crit"] = "치명"
L["Custom"] = "사용자 지정"
L["Dark Layout"] = "어두운 레이아웃"
L["Dark Texture"] = "어두운 텍스처"
L["Decorative Lines"] = "장식선"
L["Delete"] = "삭제"
L["Details"] = "Details"
L["Details Skin"] = "Details 스킨"
L["Developer Settings"] = "개발자 설정"
L["Developer Settings Done"] = "개발자 설정 완료"
L["Disable NameHover inside dungeons, raids and scenarios.\nIf disabled, NameHover will replace the Blizzard tooltip instead."] =
	"던전, 공격대, 시나리오 안에서는 NameHover를 비활성화합니다.\n비활성화 시 NameHover가 블리자드 툴팁을 대체합니다."
L["Disable in Dungeons/Raids"] = "던전/공격대에서 비활성화"
L["Durability/ Ilevel"] = "내구도/아이템 레벨"
L["ElvUI"] = "ElvUI"
L["Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."] =
	"가방에 있는 장비 아이콘에 장비 세트 소속 여부를 나타내는 표시를 활성화합니다."
L["Enabling this colors your modifier keys."] = "활성화하면 보조키에 색상이 적용됩니다."
L["Encounter Journal"] = "모험 안내서"
L["Enter Edit Mode"] = "편집 모드 진입"
L["Equipment Manager"] = "장비 관리자"
L["Middle Click:"] = "휠클릭:"
L["Pick up / move item"] = "아이템 집기 / 이동"
L["Pin / unpin item"] = "아이템 고정 / 고정 해제"
L["Shift + Middle Click:"] = "Shift + 휠클릭:"
L["Shift + Click:"] = "Shift + 클릭:"
L["Split Stack"] = "묶음 나누기"
L["Ctrl + Right Click:"] = "Ctrl + 우클릭:"
L["Move to Bank Tab / Bag"] = "은행 탭 / 가방으로 이동"
L["Bag"] = "가방"
L["Bank / Warband Bank (while open)"] = "은행 / 전쟁부대 은행 (열려 있는 동안)"
L["Bank (while open)"] = "은행 (열려 있는 동안)"
L["Vendor (while open)"] = "상인 (열려 있는 동안)"
L["Deposit / withdraw item"] = "아이템 보관 / 찾기"
L["Sell item"] = "아이템 판매"
L["Use / equip item"] = "아이템 사용 / 착용"
L["Add Category"] = "분류 추가"
L["Alternating Row Background"] = "행 교차 배경"
L["Shades every second sidebar category row, same as the Armory panel's alternating stat rows."] =
	"전투정보실 패널의 교차 능력치 행처럼 사이드바 분류 행을 한 줄씩 어둡게 표시합니다."
L["Armor"] = "방어구"
L["Assign to Category"] = "분류에 지정"
L["Categorized Bags"] = "분류된 가방"
L["Category Header Height"] = "분류 머리글 높이"
L["Clear Assignment"] = "지정 해제"
L["Enter a spell/item/currency ID, or a texture path/ID, for the category icon:"] =
	"분류 아이콘으로 사용할 주문/아이템/화폐 ID 또는 텍스처 경로/ID를 입력하세요:"
L["Enter a new name:"] = "새 이름을 입력하세요:"
L["Hide Empty Categories"] = "빈 분류 숨기기"
L["Item Count"] = "아이템 갯수 표시"
L["Item Info"] = "이이템 정보"
L["Item Size"] = "아이템 크기"
L["Shows a bind-type indicator (BoE, BoU, ...) on items that aren't bound yet."] =
	"아직 귀속되지 않은 아이템에 귀속 유형 표시(BoE, BoU 등)를 표시합니다."
L["BoP"] = "획득 귀속"
L["BoE"] = "착귀"
L["BoU"] = "사용 귀속"
L["BoA"] = true
L["Backpack"] = "배낭"
L["Bag %d"] = "가방 %d"
L["All Items"] = "모든 아이템"
L["OneBag"] = "통합 가방"
L["MultiBag"] = "개별 가방"
L["Inventory"] = "인벤토리"
L["Categories"] = "분류"
L["Equipment"] = "장비"
L["Ungroup %s"] = "%s 그룹 해제"
L["Disband Group"] = "그룹 해산"
L["Create Group With"] = "함께 그룹 만들기"
L["Add to Group"] = "그룹에 추가"
L["Group"] = "그룹"
L["Restores any category group (e.g. \"Equipment\") you disbanded or removed a category from, removes the groups you created yourself and clears any group renames."] =
	"해산했거나 분류를 제거한 모든 분류 그룹(예: \"장비\")을 복원하고, 직접 만든 그룹을 삭제하며 그룹 이름 변경을 초기화합니다."
L["Hide in All Items"] = "모든 아이템에서 숨기기"
L["Show in All Items"] = "모든 아이템에서 표시"
L["Reset Currency Order"] = "화폐 순서 초기화"
L["Puts the tracked currencies in the footer back into Blizzard's own order. Drag one currency onto another in the footer to reorder them."] =
	"하단에 추적 중인 화폐를 블리자드 기본 순서로 되돌립니다. 하단에서 화폐를 다른 화폐 위로 드래그하여 순서를 바꿀 수 있습니다."
L["Footer Currencies"] = "하단 화폐"
L["The currencies shown in the footer, per character and without Blizzard's limit of three. Ticking a currency in the Currency tab still adds it here. Drag one currency onto another in the footer to reorder them."] =
	"하단에 표시되는 화폐입니다. 캐릭터별로 설정되며 블리자드의 3개 제한이 없습니다. 화폐 탭에서 화폐를 체크해도 여기에 추가됩니다. 하단에서 화폐를 다른 화폐 위로 드래그하여 순서를 바꿀 수 있습니다."
L["Reset Currencies"] = "화폐 초기화"
L["Replaces this character's footer currencies with the ones shown on the backpack in the Currency tab, in Blizzard's order."] =
	"이 캐릭터의 하단 화폐를 화폐 탭에서 배낭에 표시된 화폐로 블리자드 순서에 맞춰 교체합니다."
L["Retired"] = "사용 중단"
L["Reset Category Groups"] = "분류 그룹 초기화"
L["Restores any category group (e.g. \"The Armory\") you disbanded or removed a category from, and clears any group renames."] =
	"해산했거나 분류를 제거한 모든 분류 그룹(예: \"전투정보실\")을 복원하고 그룹 이름 변경을 초기화합니다."
L["Toggle Bag Bar"] = "가방 바 전환"
L["Warband Bank"] = "전쟁부대 은행"
L["Delete Character"] = true
L["Delete All - %s"] = true
L["Bank"] = "은행"
L["All Bank Tabs"] = "모든 은행 탭"
L["All Warband Tabs"] = "모든 전쟁부대 탭"
L["OneBank"] = "통합 은행"
L["OneWarband"] = "통합 전쟁부대"
L["Deposit Reagents"] = "재료 보관"
L["Deposit Warbound Items"] = "전쟁부대 귀속 아이템 보관"
L["Withdraw"] = "찾기"
L["Deposit"] = "보관"
L["Bank Window"] = "은행 창"
L["Bag Window"] = "가방 창"
L["Sizes"] = "크기"
L["Click to filter by this tab"] = "클릭하여 이 탭으로 필터링"
L["Drop a bag here to equip it"] = "가방을 여기에 놓아 장착하세요"
L["Click to clear the filter"] = "클릭하여 필터 해제"
L["Purchase Bank Tab"] = "은행 탭 구매"
L["Click to purchase"] = "클릭하여 구매"
L["Cost"] = "비용"
L["Locked"] = "잠김"
L["Purchase the previous tab first."] = "이전 탭을 먼저 구매하세요."
L["Move to Bank Tab"] = "은행 탭으로 이동"
L["Move to Warband Tab"] = "전쟁부대 탭으로 이동"
L["Move to Bag"] = "가방으로 이동"
L["No free slot available."] = "사용 가능한 빈 칸이 없습니다."
L["Ctrl+Right-click to move to a specific tab/bag"] = "Ctrl+우클릭하여 특정 탭/가방으로 이동"
L["Items"] = "아이템"
L["Collapse Sidebar"] = "사이드바 접기"
L["Expand Sidebar"] = "사이드바 펼치기"
L["New Custom Category"] = "새 사용자 지정 분류"
L["Icon:"] = "아이콘:"
L["Custom Icon ID:"] = "사용자 지정 아이콘 ID:"
L["Create"] = "생성"
L["Position"] = "위치"
L["Item Spacing (Horizontal)"] = "아이템 간격 (가로)"
L["Item Spacing (Vertical)"] = "아이템 간격 (세로)"
L["Miscellaneous"] = "잡다한"
L["No gray items to sell."] = "판매할 회색 아이템이 없습니다."
L["Pinned Items"] = "고정된 아이템"
L["Quest Items"] = "퀘스트 아이템"
L["Reagent Bag"] = "재료 가방"
L["Recent Items"] = "최근 아이템"
L["Group by Expansion"] = "확장팩별 그룹화"
L["Splits categories like Consumables or Trade Goods into sub-headers per expansion, newest first."] =
	"소모품, 교역품 같은 분류를 확장팩별 하위 머리글로 나누며, 최신 확장팩이 먼저 표시됩니다."
L["Group by Equipment Set"] = "장비 세트별 그룹화"
L["Splits the gear categories into sub-headers per Blizzard equipment set."] = "장비 분류를 블리자드 장비 세트별 하위 머리글로 나눕니다."
L["Auto Height"] = "높이 자동 조절"
L["Shrinks the bag and bank windows to fit their contents. The configured height becomes the maximum instead of a fixed size."] =
	"가방과 은행 창을 내용물에 맞게 줄입니다. 설정된 높이는 고정 크기 대신 최대값이 됩니다."
L["Anchor to Nearest Corner"] = true
L["The bag and bank windows each hold the screen corner nearest to them, so they grow and shrink toward it when their size changes instead of running off the screen. The corner is picked again when you move a window."] = true
L["Merge Duplicate Stacks"] = "중복 묶음 합치기"
L["Shows identical items from several bag slots as one slot with the combined count. Gear is never merged, and merging pauses while a vendor, mailbox, trade, auction house or bank window is open, since those only ever take one stack at a time."] =
	"여러 가방 칸의 동일한 아이템을 합산된 수량의 한 칸으로 표시합니다. 장비는 합치지 않으며, 상인, 우편함, 거래, 경매장, 은행 창이 열려 있는 동안에는 한 번에 한 묶음만 처리하므로 합치기가 일시 중지됩니다."
L["Clear Recent on Close"] = "닫을 때 최근 아이템 비우기"
L["Empties the Recent Items list whenever you close the bags, instead of keeping it until you clear it yourself."] =
	"직접 비울 때까지 유지하는 대신, 가방을 닫을 때마다 최근 아이템 목록을 비웁니다."
L["New Items Only"] = true
L["Only items you were not carrying before appear in Recent Items, so looting more of a stack you already have no longer adds it. Gear and items from the mailbox or a trade always appear."] = true
L["Recent Items Limit"] = "최근 아이템 최대 개수"
L["How many items the Recent Items list keeps at most; the oldest drops out first."] =
	"최근 아이템 목록에 유지할 최대 아이템 수입니다. 가장 오래된 것부터 제거됩니다."
L["Item Set Gear"] = "아이템 세트 장비"
L["Gear Enhancements"] = "장비 강화 요소"
L["Professions"] = "전문 기술"
L["Housing"] = "주거지"
L["Rename"] = "이름 변경"
L["Reset Item Order"] = "아이템 순서 초기화"
L["Alt + Drag:"] = "Alt + 드래그:"
L["Alt+Drag onto another item to move it there. Items stay in their bag slots."] =
	"다른 아이템 위로 Alt+드래그하여 그 위치로 이동합니다. 아이템은 가방 칸에 그대로 남아 있습니다."
L["Changes the display order only - nothing moves in your bags."] = "표시 순서만 변경하며, 가방 안에서 실제로 이동하지는 않습니다."
L["Reorder items inside a category"] = "분류 안에서 아이템 순서 변경"
L["Replaces ElvUI's bag frame with a category-sidebar view (Pinned/Recent items, custom categories). Requires a UI reload to take effect."] =
	"ElvUI의 가방 창을 분류 사이드바 보기(고정/최근 아이템, 사용자 지정 분류)로 교체합니다. 적용하려면 UI를 다시 불러와야 합니다."
L["Show Pinned Items"] = "고정 아이템 표시"
L["Show Recent Items"] = "최근 아이템 표시"
L["Sidebar Row Height"] = "사이드바 행 높이"
L["Sidebar Width"] = "사이드바 너비"
L["Sort Bags"] = "가방 정리"
L["Sort"] = "정렬"
L["Sort, don't ask again"] = "정렬하고 다시 묻지 않기"
L["Sort the %s? Items are moved between its tabs."] = "%s을(를) 정렬하시겠습니까? 아이템이 탭 사이에서 이동됩니다."
L["Sort Bank"] = "은행 정렬"
L["Sort Warband Bank"] = "전쟁부대 은행 정렬"
L["No bank tabs purchased yet."] = "구매한 은행 탭이 없습니다."
L["Sort Spinner"] = "정렬 중 표시"
L["Same spinner ElvUI's own bag frame shows while sorting."] = "정렬 중 ElvUI 기본 가방 창에 표시되는 것과 같은 진행 표시입니다."
L["Drag an item here to pin it."] = "아이템을 여기로 드래그하여 고정하세요."
L["Drag an item here to assign it to %s."] = "아이템을 여기로 드래그하여 %s에 지정하세요."
L["No items found."] = "아이템을 찾을 수 없습니다."
L["Effects"] = "효과"
L["Fade Windows"] = "창 페이드"
L["Fades the bag and bank windows in when opened and out when closed."] = "가방과 은행 창을 열 때 서서히 나타나고 닫을 때 서서히 사라지게 합니다."
L["Fade Duration"] = "반투명 대기시간"
L["New Item Glow"] = "새로운 아이템 발광"
L["Pulsing glow on newly picked-up items."] = "새로 획득한 아이템에 맥동하는 빛을 표시합니다."
L["Empty Slot Opacity"] = "빈 칸 불투명도"
L["Opacity of the empty drop-target slots at the end of each category (the first \"+\" slot always stays fully visible)."] =
	"각 분류 끝에 있는 빈 드롭 대상 칸의 불투명도입니다 (첫 번째 \"+\" 칸은 항상 완전히 표시됩니다)."
L["Tints the item slot hover highlight in your class color."] = "아이템 칸 마우스오버 강조에 직업 색상을 입힙니다."
L["Hover Color"] = "마우스오버 색상"
L["WuE"] = true
L["Warbound Marker"] = "전쟁부대 귀속 표시"
L["Shows a small Warband icon on items that are Warbound or Warbound until equipped."] =
	"전쟁부대 귀속이거나 착용 시까지 전쟁부대 귀속인 아이템에 작은 전쟁부대 아이콘을 표시합니다."
L["Custom Window Opacity"] = "창 불투명도 사용자 지정"
L["Overrides ElvUI's transparent backdrop opacity for the bag and bank windows."] =
	"가방과 은행 창에 대해 ElvUI의 투명 배경 불투명도를 덮어씁니다."
L["Window Opacity"] = "창 불투명도"
L["Category Headers"] = "분류 머리글"
L["Sub-Headers"] = "하위 머리글"
L["New Item Badge"] = "새 아이템 배지"
L["Shows a small NEW badge on newly picked-up items, in addition to the glow."] = "새로 획득한 아이템에 빛과 함께 작은 NEW 배지를 표시합니다."
L["Highlight Drop Targets"] = "드롭 대상 강조"
L["Lights up the empty slots at the end of each category while an item is on the cursor, so it's clear where it can be dropped to assign it."] =
	"아이템을 커서로 들고 있는 동안 각 분류 끝의 빈 칸을 밝혀서, 어디에 놓아야 지정되는지 알기 쉽게 합니다."
L["Dim Unusable Items"] = "사용 불가 아이템 어둡게"
L["While a spell or window waits for an item (Disenchant, Milling, Prospecting, enchant scrolls, the scrapper...), darkens every item it can't be used on."] =
	"주문이나 창이 아이템을 기다리는 동안(마력 추출, 분쇄, 광석 감정, 마법부여 두루마리, 분해 기계 등) 사용할 수 없는 모든 아이템을 어둡게 합니다."
L["Desaturate Junk"] = "잡탬 흑백처리"
L["Greys out grey-quality items, in addition to the coin icon they already get."] =
	"이미 표시되는 동전 아이콘과 함께 회색 품질 아이템을 회색으로 표시합니다."
L["Pinned Marker"] = "고정 표시"
L["Shows a small pin icon on pinned items, also in their normal category."] = "고정된 아이템에 작은 핀 아이콘을 표시하며, 원래 분류에서도 표시됩니다."
L["Sub-Header Icons"] = "하위 머리글 아이콘"
L["Shows the expansion logo or equipment set icon in front of the sub-headers."] =
	"하위 머리글 앞에 확장팩 로고 또는 장비 세트 아이콘을 표시합니다."
L["Takes effect once the item is in your bags."] = "아이템이 가방에 들어오면 적용됩니다."
L["%d results"] = "결과 %d개"
L["Fill Level"] = "사용량"
L["%d of %d slots used (%d%%)"] = "%d / %d칸 사용 중 (%d%%)"
L["%d free"] = "%d칸 비어 있음"
L["Class color; turns yellow at 80% and red at 95%."] = "직업 색상이며 80%에서 노란색, 95%에서 빨간색으로 변합니다."
L["Spacing Between Categories"] = "분류 간 간격"
L["Stack Items In Bags"] = "가방 안 아이템 겹치기"
L["Stack Items In Bank"] = "은행 안 아이템 겹치기"
L["Hold Shift:"] = "Shift 누르기:"
L["Stack Items To Bank"] = "은행으로 아이템 겹치기"
L["Stack Items To Bags"] = "가방으로 아이템 겹치기"
L["Only available for the character bank."] = "캐릭터 은행에서만 사용할 수 있습니다."
L["Trade Goods"] = "교역품"
L["Vendor Grays"] = "잡동사니 자동 판매"
L["Vendored gray items for: %s"] = "모든 잡동사니를 팔았습니다: %s"
L["Weapons & Trinkets"] = "무기 및 장신구"
L["You must be at a vendor."] = "상인을 만나야 가능합니다."
L["You must be at the bank."] = "은행에 있어야 합니다."
L["Export All"] = "모두 내보내기"
L["Export Private"] = "개인 설정 내보내기"
L["Export Profile"] = "프로필 내보내기"
L["Export all setting of %s."] = "%s의 모든 설정을 내보냅니다."
L["Export the setting of %s that stored in ElvUI Private database."] = "ElvUI 개인 설정 데이터베이스에 저장된 %s의 설정을 내보냅니다."
L["Export the setting of %s that stored in ElvUI Profile database."] = "ElvUI 프로필 데이터베이스에 저장된 %s의 설정을 내보냅니다."
L["Faction"] = "진영"
L["Fixes"] = "수정 사항"
L["Focus"] = "주시"
L["Friends"] = "친구"
L["GlobalIgnoreList"] = "GlobalIgnoreList"
L["Gradient"] = "그라데이션"
L["Gradient Layout"] = "그라데이션 레이아웃"
L["Gradient Name"] = "그라데이션 이름"
L["Guild Name"] = "길드 이름"
L["Guild Rank"] = "길드 직급"
L["Guild Text Outline"] = "길드 텍스트 외곽선"
L["Guild Text Size"] = "길드 텍스트 크기"
L["HIGH"] = "HIGH"
L["Haste"] = "가속"
L["Header"] = "머리글"
L["Header Text Outline"] = "머리글 텍스트 외곽선"
L["Header Text Size"] = "머리글 텍스트 크기"
L["Hides the frame while in combat."] = "전투 중에는 프레임을 숨깁니다."
L["How long a vignette of the same time should not be notified. In seconds"] = "같은 종류의 비네트를 다시 알리지 않을 시간입니다. 초 단위"
L["How often the speed text is updated."] = "속도 텍스트를 갱신하는 주기입니다."
L["I got it!"] = "알겠습니다!"
L["I want to sync setting of MerathilisUI!"] = "MerathilisUI 설정을 동기화하고 싶어요!"
L["Icon"] = "아이콘 표시"
L["Icon Search"] = "아이콘 검색"
L["Enter a spell ID or item ID to find its icon."] = "주문 ID 또는 아이템 ID를 입력하여 아이콘을 찾으세요."
L["If you simply want to share the same private settings across all characters, it is recommended to set the same private profile for them in ElvUI > Profiles > Private."] =
	"모든 캐릭터에서 같은 개인 설정을 공유하려면, ElvUI > 프로필 > 개인 설정에서 모든 캐릭터에 같은 개인 프로필을 지정하는 것을 권장합니다."
L["Import"] = "입력"
L["Import and export your %s settings."] = "%s 설정을 가져오고 내보냅니다."
L["Improvements"] = "개선 사항"
L["Install"] = "설치"
L["Installation Complete"] = "설치 완료"
L["It will override your %s setting."] = "%s 설정을 덮어씁니다."
L["Item Level Font"] = "아이템 레벨 글꼴"
L["KeystoneLoot"] = "KeystoneLoot"
L["LEFT"] = "왼쪽"
L["LOW"] = "LOW"
L["Large"] = "크게"
L["Latest runs"] = "최근 기록"
L["Layout"] = "레이아웃"
L["Layout Set"] = "레이아웃 설정"
L["Left Click:"] = "왼 클릭 :"
L["Localization"] = "현지화"
L["MEDIUM"] = "MEDIUM"
L["Main Text Outline"] = "주 텍스트 외곽선"
L["Main Text Size"] = "주 텍스트 크기"
L["Many thanks to these wonderful persons for letting me use some of their code: %s."] =
	"코드 일부를 사용하도록 허락해 주신 훌륭한 분들께 진심으로 감사드립니다: %s."
L["Maps"] = "지도"
L["Mark as read, the changelog message will be hidden when you login next time."] =
	"읽음으로 표시하면 다음 로그인 시 변경 내역 메시지가 숨겨집니다."
L["Mastery"] = "특화"
L["Medium"] = "중간"
L["MerathilisUI saves all data in ElvUI Profile and Private database."] =
	"MerathilisUI는 모든 데이터를 ElvUI 프로필 및 개인 설정 데이터베이스에 저장합니다."
L["Mouse Over"] = "마우스오버"
L["Mouseover"] = "마우스오버 시 표시"
L["N/A"] = "N/A"
L["New"] = "신규"
L["New Profile"] = "새로운 프로필"
L["Next Time"] = "다음에"
L["No Guild"] = "길드 없음"
L["Normal Texture"] = "일반 텍스처"
L["Not Installed"] = "설치되지 않음"
L["Not Set"] = "설정되지 않음"
L["Note: This feature only copies the private profile once per character. It does not synchronize settings afterwards."] =
	"참고: 이 기능은 캐릭터당 한 번만 개인 프로필을 복사하며, 이후에는 설정을 동기화하지 않습니다."
L["Offset Y"] = "Y 좌표"
L["Ok"] = "확인"
L["Open Changelog"] = "변경 내역 열기"
L["Open Character Frame"] = "캐릭터 창 열기"
L["Other"] = "기타"
L["Pawn"] = "Pawn"
L["Pet"] = "펫(소환수)"
L["Player"] = "플레이어"
L["Interface"] = "인터페이스"
L["Combat"] = "전투"
L["Quality of Life"] = "편의 기능"
L["Choose the modules you want to use. Changes are applied on the reload at the end of the installer and can be changed anytime in the options."] =
	"사용할 모듈을 선택하세요. 변경 사항은 설치 마법사 마지막의 다시 불러오기 때 적용되며, 설정에서 언제든지 변경할 수 있습니다."
L["Features, the full changelog and downloads can be found on the website %s."] =
	"기능, 전체 변경 내역, 다운로드는 웹사이트 %s에서 확인할 수 있습니다."
L["Please set the ID first."] = "먼저 ID를 설정하세요."
L["Profession"] = "전문 기술"
L["Profile"] = "프로필"
L["Profile Created"] = "프로필 생성됨"
L["Quest"] = "퀘스트"
L["RIGHT"] = "오른쪽"
L["Race"] = "종족"
L["Raid 1"] = "공격대 1"
L["Raid 2"] = "공격대 2"
L["Raid 3"] = "공격대 3"
L["Released"] = "출시됨"
L["Reset"] = "새로고침"
L["Reset Details check"] = "Details 확인 초기화"
L["Right Click:"] = "우클릭:"
L["Run the installation process."] = "ElvUI의 설치 프로세스를 실행합니다."
L["Scale"] = "크기"
L["Scale other frames.\n\n"] = "다른 프레임의 크기를 조절합니다.\n\n"
L["Settings for the Action Bar Buttons of the Vehicle Bar.\n\n"] = "탈것 바의 행동 단축 버튼 설정입니다.\n\n"
L["Setup Developer Settings"] = "개발자 설정 적용"
L["Sharing ElvUI Profile is a very common thing nowadays, but actually ElvUI Private database is also exist for saving configuration of General, Skins, etc."] =
	"ElvUI 프로필 공유는 요즘 매우 흔하지만, 일반, 스킨 등의 설정을 저장하는 ElvUI 개인 설정 데이터베이스도 따로 있습니다."
L["Shield"] = "보호막"
L["Shorten and abbreviate attribute labels."] = "능력치 이름을 줄이고 약어로 표시합니다."
L["Show Blizzard unit tooltip alongside NameHover. If disabled, you can use keybind to quickly switch between NameHover and Blizzard"] =
	"NameHover와 함께 블리자드 유닛 툴팁을 표시합니다. 비활성화한 경우 단축키로 NameHover와 블리자드 툴팁을 빠르게 전환할 수 있습니다."
L["Show Collections"] = "수집품 표시"
L["Show Illusion"] = "환영 표시"
L["Show Keybinds"] = "단축키 표시"
L["Show Macro Text"] = "매크로 텍스트 표시"
L["Show Speed Text"] = "속도 텍스트 표시"
L["Show Target of Target"] = "대상의 대상 표시"
L["Show the changelog popup rather than chat message after every update."] = "업데이트할 때마다 대화창 메시지 대신 변경 내역 팝업을 표시합니다."
L["Show the illusion of the item in the list."] = "목록에 아이템의 환영을 표시합니다."
L["Show/Hide Visual"] = "시각 효과 표시/숨기기"
L["Shows a warning when you're missing an enchant."] = "마법부여가 누락되었을 때 경고를 표시합니다."
L["Shows a warning when you're missing sockets on your necklace."] = "목걸이에 소켓이 누락되었을 때 경고를 표시합니다."
L["Shows random battle pets"] = "무작위 전투 애완동물 표시"
L["Small"] = "작은"
L["So if you set ElvUI Profile and Private these |cffff0000TWO|r databases to the same across multiple character, the setting of MerathilisUI will be synced."] =
	"따라서 여러 캐릭터에서 ElvUI 프로필과 개인 설정, 이 |cffff0000두 가지|r 데이터베이스를 같게 지정하면 MerathilisUI 설정이 동기화됩니다."
L["Sockets"] = "소켓"
L["Sockets can be added with "] = "소켓은 다음으로 추가할 수 있습니다: "
L["Spacing"] = "간격"
L["Spec Icon"] = "특성 아이콘"
L["SpecializationBarMover"] = "전문화 바 위치 이동"
L["Speed Text Settings"] = "속도 텍스트 설정"
L["Status"] = "상태창"
L["Status Text Outline"] = "상태 텍스트 외곽선"
L["Status Text Size"] = "상태 텍스트 크기"
L["String"] = "문자열"
L["Sub Text Outline"] = "보조 텍스트 외곽선"
L["Sub Text Size"] = "보조 텍스트 크기"
L["Tank"] = "탱커"
L["Tank Target"] = "탱커 대상"
L["Target"] = "대상"
L["Target of Target"] = "대상의 대상"
L["Text Options"] = "글자 옵션"
L["The profile from which the private settings will be copied."] = "개인 설정을 복사해 올 프로필입니다."
L["The style already exists."] = "이미 존재하는 스타일입니다."
L["The texture coordinates must be passed as a table."] = "텍스처 좌표는 테이블로 전달되어야 합니다."
L["This is useful when you have multiple characters but want to use a specific private profile as the starting point for new ones."] =
	"여러 캐릭터를 사용하면서 특정 개인 프로필을 새 캐릭터의 시작점으로 사용하고 싶을 때 유용합니다."
L["Time Out"] = "제한 시간"
L["Tips"] = "팁"
L["Toggle whether to show keybinds of an action bar button on the Vehicle Bar."] = "탈것 바에 행동 단축 버튼의 단축키를 표시할지 설정합니다."
L["Toggle whether to show macro text of an action bar button on the Vehicle Bar."] =
	"탈것 바에 행동 단축 버튼의 매크로 텍스트를 표시할지 설정합니다."
L["Toggles the blue bars behind every second number."] = "숫자 한 줄씩 건너뛰며 뒤에 표시되는 파란 막대를 설정합니다."
L["Transmog Text Frame"] = "형상변환 텍스트 창"
L["Tukui Discord Server"] = "Tukui 디스코드 서버"
L["UI Scale"] = "UI 크기"
L["Unknown"] = "알 수 없음"
L["Update"] = "업데이트"
L["Update Database"] = "데이터베이스 업데이트"
L["Update Rate"] = "갱신 주기"
L["Use Custom Color"] = "사용자 지정 색상 사용"
L["Use class color for the enchant strings."] = "마법부여 문자열에 직업 색상을 사용합니다."
L["Use the WoW Key Bindings menu for the custom Hold to show bind. This modifier remains available for these hotkeys"] =
	"WoW 단축키 설정 메뉴에서 사용자 지정 단축키 표시 키를 지정하세요. 이 보조키는 다음 단축키에서 계속 사용할 수 있습니다"
L["Value Color"] = "값 색상"
L["Versa"] = "Versa"
L["Version"] = "버전"
L["Vignette"] = "비네트"
L["Vignette ID"] = "비네트 ID"
L["Vigor Bar"] = "활력 바"
L["Vigor bar texture for Dark Mode."] = "어두운 모드용 활력 바 텍스처입니다."
L["Vigor bar texture for Normal and Gradient Mode"] = "일반 및 그라데이션 모드용 활력 바 텍스처"
L["WIM"] = "WIM"
L["Weekly Delves Keys"] = "주간 구렁 열쇠"
L["Weekly Rewards"] = "주간 보상"
L["Welcome to %s %s!"] = "%s %s에 오신 것을 환영합니다!"
L["Welcome to version %s!"] = "버전 %s에 오신 것을 환영합니다!"
L["WowLua"] = "WowLua"
L["You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"] =
	"파일 ID 또는 경로를 사용할 수 있습니다.\n파일 ID 예시입니다.\niconFileID: 3547163\n\n이미 설정 가능한 항목이지만 경로 예시로 표시한 것입니다.\n경로: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"
L["You have %s pending calendar |4invite:invites;."] = "대기 중인 달력 초대가 %s개 있습니다."
L["You have %s pending guild |4event:events;."] = "대기 중인 길드 이벤트가 %s개 있습니다."
L["is looking for members"] = "구성원 찾는 중"
L["joined a group"] = "그룹에 참가"
L["ls_Toasts"] = "ls_Toasts"
L["ncHoverName by Nightcracker"] = "Nightcracker의 ncHoverName"
--

-- Buff Reminder
L["Buff Reminder"] = "버프 알림"
L["Raid Buffs"] = "공격대 버프"
L["Consumables"] = "소모품"
L["Flask"] = "영약"
L["Food"] = "음식"
L["Rune"] = "룬"
L["Main Hand"] = "주 장비"
L["Off Hand"] = "보조 장비"
L["Mark of the Wild"] = "야생의 징표"
L["Battle Shout"] = "전투의 외침"
L["Power Word: Fortitude"] = "신의 권능: 인내"
L["Arcane Intellect"] = "신비한 지능"
L["Blessing of the Bronze"] = "청동의 축복"
L["Skyfury"] = "하늘격노"
L["Symbiotic Relationship"] = "공생 관계"
L["Battle Stance"] = "전투 태세"
L["Berserker Stance"] = "광폭 태세"
L["Defensive Stance"] = "방어 태세"
L["Shadowform"] = "어둠의 형상"
L["Devotion Aura"] = "헌신의 오라"
L["Augment Rune"] = "증강 룬"
L["Weapon Enchant"] = "무기 마법부여"
L["Deadly Poison"] = "맹독"
L["Instant Poison"] = "즉효성 독"
L["Wound Poison"] = "상처 감염 독"
L["Amplifying Poison"] = "증폭 독"
L["Crippling Poison"] = "신경 마비 독"
L["Numbing Poison"] = "마비 독"
L["Atrophic Poison"] = "퇴화 독"
L["Rite of Adjuration"] = "맹세의 의식"
L["Rite of Sanctification"] = "성화의 의식"
L["Flametongue Weapon"] = "불꽃혓바닥 무기"
L["Windfury Weapon"] = "질풍의 무기"
L["Earthliving Weapon"] = "대지의 생명 무기"
L["Tidecaller's Guard"] = "해일소환사의 수호"
L["Thunderstrike Ward"] = "번개강타 수호"
L["Hide in Open World"] = "야외 월드에서 숨기기"
L["Only show reminders inside dungeons, raids and scenarios."] = "던전, 공격대, 시나리오 안에서만 알림을 표시합니다."
L["Hide while Mounted/Flying"] = "탈것 탑승/비행 중 숨기기"
L["Remind Under (minutes)"] = "알림 기준 (분)"
L["Also remind when a tracked consumable buff is about to expire within this many minutes."] =
	"추적 중인 소모품 버프가 이 시간(분) 이내에 만료될 때도 알립니다."
L["Icon Spacing"] = "아이콘 간격"
L["Show Text"] = "주석 표시"
L["Text Size"] = "텍스트 크기"
L["Text Outline"] = "텍스트 외곽선"
L["Show Bag Count"] = "가방 수량 표시"
L["Enable Glow"] = "반짝임 사용"
L["Glow Color"] = "반짝임 색상"
L["Sounds"] = "소리"
L["Show Without Item"] = "아이템 없이도 표시"
L["Missing Buffs From Group"] = "그룹원에게 부족한 버프"
L["Aspect"] = true
L["Blessing"] = true
L["Aura"] = true
L["Also shows the raid buffs a groupmate provides while you are missing them. These icons are only a hint, clicks go through them."] =
	"내가 부족한 공격대 버프 중 그룹원이 제공하는 버프도 표시합니다. 이 아이콘은 안내용이며 클릭은 아이콘을 통과합니다."
L["Talent Reminders"] = "특성 알림"
L["Talent"] = "특성"
L["Not Needed"] = "필요 없음"
L["Never"] = "사용 안 함"
L["Raid Buff Check"] = "공격대 버프 확인"
L["Vantus Rune"] = "밴투스 룬"
L["Hide Fully Buffed"] = "버프가 모두 있으면 숨기기"
L["Require Augment Rune"] = "증강 룬 필요"
L["Require Vantus Rune"] = "밴투스 룬 필요"
L["Offline Bank"] = "오프라인 은행"
L["Equipped"] = "착용 중"
L["Guild Bank"] = "길드 은행"
L["All Characters"] = "모든 캐릭터"
L["just now"] = "방금 전"
L["%s ago"] = "%s 전"
L["Tab %d"] = "탭 %d"
L["Saved %s"] = "%s에 저장됨"
L["Back to the live view"] = "실시간 보기로 돌아가기"
L["%s's Bank"] = "%s의 은행"
L["%s's Inventory"] = "%s의 인벤토리"
L["Show Character"] = "캐릭터 표시"
L["Delete Saved Data"] = "저장된 데이터 삭제"
L["Bags, bank and more of your other characters."] = "다른 캐릭터의 가방, 은행 등을 볼 수 있습니다."
L["Use the search box to look through all characters."] = "검색 상자로 모든 캐릭터를 검색하세요."
L["The warband bank has not been saved yet. Open it once at a banker."] = "전쟁부대 은행이 아직 저장되지 않았습니다. 은행원에게서 한 번 열어 주세요."
L["No guild bank saved for this character. Open it once."] = "이 캐릭터의 길드 은행이 저장되어 있지 않습니다. 한 번 열어 주세요."
L["Not saved yet. Log in on this character once."] = "아직 저장되지 않았습니다. 이 캐릭터로 한 번 로그인하세요."
L["Not saved yet. Visit it once on this character."] = "아직 저장되지 않았습니다. 이 캐릭터로 한 번 방문하세요."
L["Delete the saved bags and bank of %s? They are saved again the next time you log in on that character."] =
	"%s의 저장된 가방과 은행을 삭제하시겠습니까? 해당 캐릭터로 다시 로그인하면 다시 저장됩니다."
L["Saves the bags, bank, equipment and mail of each character when you see them, plus the warband and guild bank. A button in the bag and bank title shows them anywhere and searches through all characters."] =
	"각 캐릭터의 가방, 은행, 장비, 우편과 전쟁부대 및 길드 은행을 확인할 때 저장합니다. 가방 및 은행 제목의 버튼으로 어디서나 볼 수 있으며 모든 캐릭터를 검색할 수 있습니다."
L["Tooltip Item Counts"] = "툴팁 아이템 수량"
L["Item tooltips list how many of that item each of your characters owns, plus the warband and guild bank."] =
	"아이템 툴팁에 각 캐릭터와 전쟁부대 및 길드 은행이 보유한 해당 아이템의 수량을 표시합니다."
L["Characters"] = "캐릭터"
L["Connected Realms"] = "연결된 서버"
L["Own Faction Only"] = "내 진영만"
L["Delete All Saved Data"] = "저장된 모든 데이터 삭제"
L["Delete every saved inventory of all characters?"] = "모든 캐릭터의 저장된 인벤토리를 전부 삭제하시겠습니까?"
L["Everyone is fully buffed."] = "모두 버프를 받고 있습니다."
L["Missing"] = "없음"
L["Expiring Soon"] = "곧 만료"
L["%dm"] = "%d분"
L["Food and runes cannot be read here (aura restriction). ? = unknown"] = "음식과 룬은 여기에서 확인할 수 없습니다 (오라 제한). ? = 알 수 없음"
L["? = unknown (offline, dead or out of range)"] = "? = 알 수 없음 (오프라인, 사망 또는 범위 밖)"
L["Raid Buff Check cannot be opened in combat."] = "공격대 버프 확인은 전투 중에 열 수 없습니다."
L["Raid Buff Check is turned off, it can be enabled in the Buff Reminder options."] =
	"공격대 버프 확인이 꺼져 있습니다. 버프 알림 설정에서 켤 수 있습니다."
L["A window listing every group member's flask, food, augment rune, vantus rune and missing raid buffs. Opens with /buffcheck or the button below, out of combat only."] =
	"모든 파티원의 영약, 음식, 증강 룬, 밴투스 룬, 부족한 공격대 버프를 나열하는 창입니다. /buffcheck 또는 아래 버튼으로 열 수 있으며 전투 중에는 사용할 수 없습니다."
L["Open on Ready Check"] = "준비 확인 시 열기"
L["Opens the window on every ready check while you are the group leader or a raid assistant."] =
	"파티장 또는 공격대 부관일 때 모든 준비 확인마다 창을 엽니다."
L["Current Season Instances"] = "현재 시즌 던전"
L["All Instances"] = "모든 던전"
L["Reminds you to remove the talent in the instances you did not pick for it."] = "선택하지 않은 던전에서 해당 특성을 해제하라고 알려줍니다."
L["Pick a talent of your current specialization and the instances you want it in. Inside them, an icon shows while the talent is not chosen. Reminders are saved per specialization."] =
	"현재 전문화의 특성과 그 특성을 사용할 던전을 선택하세요. 해당 던전 안에서 특성이 선택되지 않았으면 아이콘이 표시됩니다. 알림은 전문화별로 저장됩니다."
L["Keep showing a desaturated reminder icon even when you have none of the item left in your bags."] =
	"가방에 해당 아이템이 하나도 없어도 채도가 낮은 알림 아이콘을 계속 표시합니다."
L["Test"] = "테스트"
L["Stop Test"] = "테스트 중지"
L["Shows a row of sample icons for 20 seconds so you can check scale, glow, text and position without needing to actually be missing anything in a raid."] =
	"크기, 반짝임, 텍스트, 위치를 확인할 수 있도록 샘플 아이콘 줄을 20초 동안 표시합니다. 공격대에서 실제로 부족한 항목이 없어도 됩니다."
L["Hide in Combat"] = "전투 중 숨기기"
L["When disabled, reminders freeze in place during combat instead of disappearing."] =
	"비활성화하면 전투 중 알림이 사라지지 않고 그 자리에 고정됩니다."

-- Minimap Buttons
L["Minimap Buttons"] = "미니맵 버튼"
L["Add a bar of extra buttons next to your Minimap."] = "미니맵 옆에 추가 버튼 바를 표시합니다."
L["Great Vault"] = "위대한 금고"
L["M+ Portals"] = "쐐기 던전 차원문"
L["Other Characters"] = "다른 캐릭터"
L["Other Characters' Hearthstones"] = "다른 캐릭터의 귀환석"
L["Lists your other characters in the tooltip of the hearthstone button in the M+ Portals flyout: where each one is bound and when its hearthstone is ready again. A character shows up once it was logged in with this option on. Applies to your whole account."] =
	"쐐기 던전 차원문 팝업의 귀환석 버튼 툴팁에 다른 캐릭터를 나열합니다: 각 캐릭터의 귀속 위치와 귀환석을 다시 사용할 수 있는 시점. 이 옵션이 켜진 상태로 로그인한 캐릭터부터 표시되며, 계정 전체에 적용됩니다."
L["Forget Characters"] = "캐릭터 정보 삭제"
L["Clears the saved hearthstones of all characters, for example after deleting one. Each character is saved again the next time it logs in."] =
	"모든 캐릭터의 저장된 귀환석 정보를 삭제합니다. 예: 캐릭터를 삭제한 후. 각 캐릭터는 다음에 로그인할 때 다시 저장됩니다."
L["Tracking"] = "추적"
L["Calendar"] = "달력"
L["Mail"] = "우편"
L["Crafting Orders"] = "제작 주문"
L["Elements"] = "요소"
L["A second bar for the Blizzard indicators, anchored on its own."] = "블리자드 표시기를 위한 별도의 바이며, 독립적으로 고정됩니다."
L["Replaces the Blizzard icon on your Minimap with one in this bar."] = "미니맵의 블리자드 아이콘을 이 바 안의 아이콘으로 대체합니다."
L["The tooltip lists your raid lockouts, the realm time and the weekly reset."] = "툴팁에 공격대 귀속, 서버 시간, 주간 초기화가 표시됩니다."
L["Only shown while there is something to report."] = "알릴 내용이 있을 때만 표시됩니다."
L["Weekly Reset"] = "주간 초기화"
L["Growth Direction"] = "배열 방향"
L["Which way the bar extends as buttons are added."] = "버튼이 추가될 때 바가 늘어나는 방향입니다."
L["Raids"] = "공격대"
L["World"] = "월드"
L["Test Pulse"] = "맥동 테스트"
L["Briefly plays the Great Vault button's pulse animation, even without any unclaimed rewards."] =
	"수령하지 않은 보상이 없어도 위대한 금고 버튼의 맥동 애니메이션을 잠시 재생합니다."
L["Addon Buttons"] = "애드온 버튼"
L["Collects the minimap buttons of your addons into a grid that opens from this bar."] =
	"애드온의 미니맵 버튼을 이 바에서 열리는 격자로 모읍니다."
L["Switching it off requires a reload."] = "끄려면 UI를 다시 불러와야 합니다."
L["%s already collects your minimap buttons, so this collector stays off."] =
	"%s이(가) 이미 미니맵 버튼을 모으고 있으므로 이 수집 기능은 꺼진 상태로 유지됩니다."
L["Disable WindTools Minimap Buttons"] = "WindTools 미니맵 버튼 비활성화"
L["Buttons Per Row"] = "한 줄당 버튼 수"
L["Show as List"] = true
L["Shows the buttons in one column with each addon's name next to its icon."] = true
L["Ignored Buttons"] = "무시할 버튼"
L["Names or parts of names of buttons that stay on the Minimap, separated by commas."] =
	"미니맵에 남겨 둘 버튼의 이름 또는 이름의 일부이며, 쉼표로 구분합니다."
L["Requires a reload."] = "UI를 다시 불러와야 합니다."
L["Top Left"] = "상단 왼쪽"
L["Top"] = "상단 중앙"
L["Top Right"] = "상단 오른쪽"
L["Left"] = "왼쪽"
L["Right"] = "오른쪽"
L["Bottom Left"] = "하단 왼쪽"
L["Bottom"] = "하단"
L["Bottom Right"] = "하단 오른쪽"
L["Housing Dashboard"] = "주거지 대시보드"

-- Cursor
L["Cursor"] = "커서"
L["Cursor Ring"] = "커서 링"
L["Cursor Trail"] = "커서 궤적"
L["GCD Ring"] = "GCD 링"
L["Cast Ring"] = "시전 링"
L["Cursor GCD Ring"] = "커서 GCD 링"
L["Cursor Cast Ring"] = "커서 시전 링"
L["Show a colored ring around your mouse cursor, with an optional trail, GCD ring and cast-time ring."] =
	"마우스 커서 주위에 색상 링을 표시하며, 선택적으로 궤적, GCD 링, 시전 시간 링을 표시합니다."
L["Use Class Color"] = "직업 색상 사용"
L["Radius"] = "반지름"
L["Show Center Dot"] = "중앙 점 표시"
L["Show Spark"] = "스파크 표시"
L["Attach to Cursor"] = "커서에 부착"
L["Only In Instances"] = "던전에서만"
L["Only In Combat"] = "전투 중에만"
L["Only While Steering Camera"] = "카메라 조작 중에만"
L["Only show the ring while you're holding a mouse button to turn or move the camera (the hardware cursor is hidden)."] =
	"마우스 버튼을 누른 채 카메라를 돌리거나 이동하는 동안에만 링을 표시합니다 (하드웨어 커서가 숨겨진 상태)."

-- Loot Roll
L["Loot Roll"] = "주사위 굴림창"
L["Can't Roll"] = "주사위를 굴릴 수 없습니다."
L["Replaces ElvUI's Need/Greed/Pass loot roll frames with a custom, movable bar."] =
	"ElvUI의 필요/차순/포기 전리품 주사위 창을 이동 가능한 사용자 지정 바로 대체합니다."
L["Show/hide a fake roll bar to preview your settings."] = "설정을 미리 볼 수 있도록 가짜 주사위 바를 표시/숨깁니다."
L["Grow Direction"] = "확장 방향"
L["Down"] = "아래로"
L["Up"] = "위로"
L["Max Bars"] = "바 최대갯수"
L["Colors"] = "색상"
L["Color Border by Quality"] = "품질별 테두리 색상"
L["Color Name by Quality"] = "품질별 이름 색상"
L["Show Item Level"] = "아이템 레벨 표시"
L["Color Status Bar by Quality"] = "품질별 상태 바 색상"
L["Custom Status Bar Color"] = "사용자 지정 상태 바 색상"
L["Status Bar Texture"] = "상태 바 텍스처"
L["Font Size"] = "글자 크기"
L["Font Outline"] = "글꼴 외곽선"
L["Rollers"] = "주사위 굴린 사람"
L["Show Rollers in Tooltip"] = "툴팁에 주사위 굴린 사람 표시"
L["Show who rolled Need/Greed/Disenchant/Pass in the item's tooltip.\n\nNote: on modern retail WoW this can currently only be populated for boss/encounter loot - it stays empty for regular group loot (e.g. trash mobs, world content)."] =
	"아이템 툴팁에 필요/차순/마력 추출/포기를 선택한 사람을 표시합니다.\n\n참고: 현재 정규 서버에서는 우두머리/전투 전리품에만 표시되며, 일반 파티 전리품(예: 일반 몹, 월드 콘텐츠)에서는 비어 있습니다."
L["Uncommon Test Item"] = "고급 테스트 아이템"
L["Rare Test Item"] = "희귀 테스트 아이템"
L["Epic Test Item"] = "영웅 테스트 아이템"
L["Legendary Test Item"] = "전설 테스트 아이템"

-- Auras
L["Collapse & Expand Button"] = "접기 및 펼치기 버튼"
L["Adds Blizzard's Collapse/Expand arrow button back to ElvUI's Player Buffs. Collapsing shrinks the buffs down to a single row, keeping only the ones about to expire visible while long-lasting buffs are hidden."] =
	"블리자드의 접기/펼치기 화살표 버튼을 ElvUI 플레이어 버프에 다시 추가합니다. 접으면 버프가 한 줄로 줄어들어 만료 직전의 버프만 보이고 오래 지속되는 버프는 숨겨집니다."
L["Expand Buffs"] = "버프 펼치기"
L["Collapse Buffs"] = "버프 접기"

-- Mail
L["Open"] = "열기"
L["Open Selected"] = "선택 열기"
L["Delete Selected"] = "선택 삭제"
L["Selection"] = "선택"
L["Send Templates"] = "발송 템플릿"
L["Continue"] = "계속"
L["No templates saved."] = "저장된 템플릿이 없습니다."
L["Template Name"] = "템플릿 이름"
L["Recipients (one per line, or comma separated)"] = "받는 사람 (한 줄에 하나씩, 또는 쉼표로 구분)"
L["Subject"] = "제목"
L["Body"] = "내용"
L["New Template"] = "새 템플릿"
L["Clear the fields above to create a new template."] = "새 템플릿을 만들려면 위 입력란을 비웁니다."
L["Add / Update"] = "추가 / 업데이트"
L["Confirm each field above first (Enter, or the checkmark under multiline boxes) - this button re-saves whatever is currently confirmed."] = "먼저 위의 각 필드를 확인하세요 (Enter 키 또는 여러 줄 상자 아래의 체크 표시) - 이 버튼은 현재 확인된 내용을 다시 저장합니다."
L["Saved Templates"] = "저장된 템플릿"
L["Pick a saved template to load it into the fields above for editing."] =
	"저장된 템플릿을 선택하면 위 입력란에 불러와 수정할 수 있습니다."
L["Please set a template name first."] = "먼저 템플릿 이름을 입력하세요."
L["Please add at least one recipient."] = "받는 사람을 한 명 이상 추가하세요."
L["This template has no recipients."] = "이 템플릿에는 받는 사람이 없습니다."
L["Delete %d selected mails?"] = "선택한 우편 %d개를 삭제하시겠습니까?"
L["No mail selected."] = "선택된 우편이 없습니다."
L["Select all mail on this page"] = "이 페이지의 모든 우편 선택"
L["Adds checkboxes to the inbox to open or delete multiple mails at once."] =
	"받은 편지함에 체크박스를 추가하여 여러 우편을 한 번에 열거나 삭제할 수 있습니다."
L["Save recipient lists to send the same mail to multiple people at once from the mailbox."] =
	"받는 사람 목록을 저장하여 우체통에서 같은 우편을 여러 사람에게 한 번에 보낼 수 있습니다."
L["Item cleared - re-drag it into the attachment slot, then click Continue."] =
	"아이템이 비워졌습니다 - 첨부 칸에 다시 끌어놓은 다음 계속을 클릭하세요."
L["Mass send complete."] = "대량 발송이 완료되었습니다."
L["Sending %d/%d to %s..."] = "%s에게 발송 중 (%d/%d)..."
L["Send failed for %s."] = "%s에게 발송하지 못했습니다."
L["Example: Send to Alts"] = "예시: 부캐에게 보내기"
L["Gold from Main"] = "본캐로부터의 골드"
L["This is an example template - edit the recipients/subject/body or delete it in Options > Mail > Send Templates."] =
	"이것은 예시 템플릿입니다 - 옵션 > 우편 > 발송 템플릿에서 받는 사람/제목/내용을 수정하거나 삭제하세요."
L["Cloth"] = "천"
L["Leather"] = "가죽"
L["Metal & Stone"] = "금속 및 석재"
L["Cooking"] = "요리"
L["Herb"] = "약초"
L["Enchanting"] = "마법부여"
L["Inscription"] = "주문각인"
L["Jewelcrafting"] = "보석세공"
L["Elemental"] = "정령"
L["Optional Reagents"] = "추가 재료"
L["Parts"] = "부품"
L["All Trade Goods"] = "모든 무역 물품"
L["Set a default recipient for %s (leave empty to clear):"] = "%s의 기본 받는 사람을 설정하세요 (비워두면 삭제):"
L["Default recipient: %s"] = "기본 받는 사람: %s"
L["Left-click to attach all - right-click to set a default recipient."] =
	"왼쪽 클릭으로 모두 첨부 - 오른쪽 클릭으로 기본 받는 사람 설정."

-- Chat
L["Chat Sidebar"] = "대화창 사이드바"
L["Adds a slim icon bar inside a chat panel with quick access to friends, guild, copy chat, M+ portals and more."] =
	"대화창 안에 친구, 길드, 대화 복사, 쐐기 던전 차원문 등에 빠르게 접근할 수 있는 얇은 아이콘 바를 추가합니다."
L["Requires ElvUI's %s module to be enabled."] = "ElvUI의 %s 모듈이 활성화되어 있어야 합니다."
L["No MerathilisUI profile installed."] = "설치된 MerathilisUI 프로필이 없습니다."
L["Not available while EltruismUI is enabled."] = "EltruismUI가 활성화되어 있는 동안에는 사용할 수 없습니다."
L["Not available while BenikUI is enabled."] = "BenikUI가 활성화되어 있는 동안에는 사용할 수 없습니다."
L["Chat Panel"] = "대화창 패널"
L["Side"] = "위치"
L["Which edge of the chat panel the sidebar sits on."] = "사이드바가 위치할 대화창 패널의 가장자리입니다."
L["Visibility"] = "표시"
L["Always"] = "항상"
L["Divider"] = "구분선"
L["Draws a thin line between the sidebar and the chat text."] = "사이드바와 대화 텍스트 사이에 얇은 선을 그립니다."
L["Counter Font Size"] = "카운터 글꼴 크기"
L["Icon Color"] = "아이콘 색상"
L["Icon Alpha"] = "아이콘 투명도"
L["Hover Class Color"] = "마우스오버 직업 색상"
L["Highlights hovered icons in your class color."] = "마우스를 올린 아이콘을 직업 색상으로 강조합니다."
L["Buttons that no longer fit the panel height are left out."] = "패널 높이에 맞지 않는 버튼은 제외됩니다."
L["Guild"] = "길드"
L["Durability"] = "내구도"
L["Copy Chat"] = "대화 복사"
L["Voice / Channels"] = "음성 / 채널"
L["Settings"] = "설정"
L["Scroll to Bottom"] = "맨 아래로 스크롤"
L["Shows the number of friends online."] = "접속 중인 친구 수를 표시합니다."
L["Shows the number of guild members online."] = "접속 중인 길드원 수를 표시합니다."
L["Shows the durability of your most damaged item."] = "가장 많이 손상된 아이템의 내구도를 표시합니다."
L["Pinned to the bottom of the sidebar, lights up while the chat is scrolled up."] =
	"사이드바 하단에 고정되며, 대화창이 위로 스크롤되어 있는 동안 밝게 표시됩니다."
L["Durability Warning"] = "내구도 경고"
L["The durability counter turns red at or below this value."] = "내구도 카운터가 이 값 이하일 때 빨간색으로 변합니다."
L["Portal Direction"] = "차원문 방향"
L["Which way the M+ Portals flyout opens from its button. Automatic opens it over the chat text."] =
	"쐐기 던전 차원문 팝업이 버튼에서 열리는 방향입니다. 자동은 대화 텍스트 위로 엽니다."
L["World of Warcraft"] = "월드 오브 워크래프트"
L["Online"] = "접속 중"
L["ElvUI Chat"] = "ElvUI 대화창"
L["Chat Menu"] = "대화 메뉴"
L["Replaces ElvUI's copy button on the chat windows. Right-click opens the chat menu."] =
	"대화창의 ElvUI 복사 버튼을 대체합니다. 우클릭하면 대화 메뉴가 열립니다."
L["Inside"] = "안쪽"
L["Outside"] = "바깥쪽"
L["Inside shares the chat panel and moves the chat text aside, outside places the sidebar as its own block next to the panel."] =
	"안쪽은 대화창 패널을 공유하며 대화 텍스트를 옆으로 이동하고, 바깥쪽은 사이드바를 패널 옆의 별도 블록으로 배치합니다."
L["Distance"] = "거리"
L["Shift + Drag to reorder"] = "Shift + 드래그하여 순서 변경"
L["Shift + drag an icon in the sidebar to change the order."] = "사이드바의 아이콘을 Shift + 드래그하여 순서를 변경합니다."
L["Reset Order"] = "순서 초기화"
L["Chat Panels"] = "채팅 패널"
L["Lock Chat Size"] = "대화창 크기 잠금"
L["Hides the resize grip that shows in the corner of a chat panel while hovering it."] =
	"대화창 패널에 마우스를 올렸을 때 모서리에 나타나는 크기 조절 손잡이를 숨깁니다."
L["Drag to resize the chat panel"] = "드래그하여 대화창 패널 크기 조절"
L["Combat Log Filters"] = "전투 기록 필터"
L["Colors the active combat log filter in your class color and dims the others."] =
	"활성화된 전투 기록 필터를 직업 색상으로 표시하고 나머지는 어둡게 합니다."
L["Edit Box"] = "입력창"
L["Restyles the chat input box."] = "대화 입력창의 모양을 다시 꾸밉니다."
L["MerathilisUI Style"] = "MerathilisUI 스타일"
L["Transparent backdrop with the MerathilisUI stripes and gradient."] = "MerathilisUI 줄무늬와 그라데이션이 적용된 투명 배경."
L["Chat Type Accent"] = "대화 유형 강조"
L["A neutral border with a small bar in the color of the current chat type, instead of coloring the whole border."] =
	"전체 테두리에 색을 입히는 대신, 중립 테두리에 현재 대화 유형 색상의 작은 막대를 표시합니다."
L["Header Badge"] = "머리글 배지"
L["Shows the chat type prefix (Say, Guild, Whisper to ...) as a colored badge."] =
	"대화 유형 접두사(일반 대화, 길드, 귓속말 대상 ...)를 색상 배지로 표시합니다."
L["Open Animation"] = "열기 애니메이션"
L["Fades the box in when it opens."] = "입력창이 열릴 때 서서히 나타나게 합니다."
L["Class Color Glow"] = "직업 색상 반짝임"
L["A glow in your class color around the box while it is open."] = "입력창이 열려 있는 동안 주위에 직업 색상의 빛을 표시합니다."
L["Opens the chat history in a MerathilisUI window instead of ElvUI's copy frame. Used by the sidebar copy button and ElvUI's copy button on each chat."] =
	"대화 기록을 ElvUI 복사 창 대신 MerathilisUI 창에서 엽니다. 사이드바 복사 버튼과 각 대화창의 ElvUI 복사 버튼에서 사용됩니다."
L["Keeps the chat colors in the copied text. Turn it off to copy plain text."] =
	"복사한 텍스트에 대화 색상을 유지합니다. 끄면 일반 텍스트로 복사됩니다."
L["Press Ctrl+C to copy the selected text."] = "Ctrl+C를 눌러 선택한 텍스트를 복사하세요."
L["Chat Search"] = "대화 검색"
L["Click a line to jump to it in the chat."] = "줄을 클릭하면 대화창에서 해당 위치로 이동합니다."
L["%d matches"] = "일치 %d건"
L["Type to search the chat history."] = "입력하여 대화 기록을 검색하세요."
L["Opens the chat search for the chat window next to the sidebar."] = "사이드바 옆 대화창의 대화 검색을 엽니다."
L["Searches the history of a chat window, the newest matches first. Click a match to scroll the chat to it, Enter jumps to the newest one. Opened by the search button in the chat sidebar."] =
	"대화창의 기록을 최신 일치 항목부터 검색합니다. 일치 항목을 클릭하면 대화창이 해당 위치로 스크롤되며, Enter는 가장 최신 항목으로 이동합니다. 대화창 사이드바의 검색 버튼으로 엽니다."
L["Invite Links"] = "초대 링크"
L["Turns invite keywords in whispers, guild, say, yell and chat channels into links. A click on the link invites the sender."] =
	"귓속말, 길드, 일반 대화, 외침, 대화 채널의 초대 키워드를 링크로 바꿉니다. 링크를 클릭하면 보낸 사람을 초대합니다."
L["Comma separated list of words that become an invite link."] = "초대 링크로 바뀌는 단어 목록(쉼표로 구분)."
L["Alt-Click Invite"] = "Alt-클릭 초대"
L["Alt-click a player name in the chat to invite that player."] = "대화창에서 플레이어 이름을 Alt-클릭하면 해당 플레이어를 초대합니다."
L["%d lines"] = "%d줄"
L["Backdrop Alpha"] = "배경 투명도"
L["Same setting as in ElvUI's chat options, shown here for convenience."] = "ElvUI 대화 설정과 같은 설정이며, 편의를 위해 여기에도 표시합니다."
L["Active Underline"] = "활성 탭 밑줄"
L["Marks the active tab with a line in your class color."] = "활성 탭을 직업 색상의 선으로 표시합니다."
L["How opaque the edit box backdrop is. ElvUI's own transparency setting is used for everything else."] =
	"입력창 배경의 불투명도입니다. 그 외에는 ElvUI 자체 투명도 설정이 사용됩니다."
L["Replaced by the copy button of the MerathilisUI Chat Sidebar."] = "MerathilisUI 대화창 사이드바의 복사 버튼으로 대체되었습니다."
L["Hide Voice Buttons"] = "음성 버튼 숨김"
L["Hides the voice buttons on the chat panel, the sidebar button takes their place."] =
	"대화창 패널의 음성 버튼을 숨기고 사이드바 버튼이 그 자리를 대신합니다."
L["Opens the channel list. Right-click mutes your microphone, middle-click your speakers."] =
	"채널 목록을 엽니다. 우클릭은 마이크를, 휠클릭은 스피커를 음소거합니다."
L["Replaced by the voice button of the MerathilisUI Chat Sidebar."] = "MerathilisUI 대화창 사이드바의 음성 버튼으로 대체되었습니다."
L["Other Games / App"] = "다른 게임 / 앱"
L["Gives ElvUI's chat bubbles the MerathilisUI look with a pixel perfect border, and styles the speaker's name."] =
	"ElvUI 말풍선에 픽셀 퍼펙트 테두리가 있는 MerathilisUI 스타일을 적용하고 말하는 사람의 이름을 꾸밉니다."
L["Needs ElvUI's chat bubble skin, see ElvUI > General > Cosmetic > Chat Bubbles."] =
	"ElvUI의 말풍선 스킨이 필요합니다. ElvUI > 일반 > 외형 > 말풍선을 확인하세요."
L["The backdrop needs one of ElvUI's two backdrop styles, the name settings work with every style."] =
	"배경에는 ElvUI의 두 가지 배경 스타일 중 하나가 필요하며, 이름 설정은 모든 스타일에서 작동합니다."
L["Speaker Name"] = "말하는 사람 이름"
L["Needs ElvUI's Chat Bubble Names option."] = "ElvUI의 말풍선 이름 옵션이 필요합니다."
L["Group Chat Names"] = "그룹 대화 이름"
L["Also names the bubbles of party, raid and instance chat. ElvUI only names say, yell and NPC bubbles."] =
	"파티, 공격대, 던전 대화의 말풍선에도 이름을 표시합니다. ElvUI는 일반 대화, 외침, NPC 말풍선에만 이름을 표시합니다."
L["Shows the name in a class color gradient, NPCs in yellow."] = "이름을 직업 색상 그라데이션으로 표시하며 NPC는 노란색입니다."
L["Alignment"] = "정렬"
L["Hide in Instances"] = "던전에서 숨기기"
L["Chat bubbles can't be styled inside instances, so Blizzard's own show there. This turns them off while you are in an instance and back on when you leave."] =
	"던전 안에서는 말풍선을 꾸밀 수 없어 블리자드 기본 말풍선이 표시됩니다. 던전 안에서는 이 옵션이 말풍선을 끄고, 나오면 다시 켭니다."
L["Not available while WindTools' Auto Toggle Chat Bubble is enabled."] =
	"WindTools의 말풍선 자동 전환이 활성화되어 있는 동안에는 사용할 수 없습니다."
L["Guard"] = "수호"

L["Location Panel"] = "위치 패널"
L["Link Location in Chat"] = "대화창에 위치 링크"
L["Shows the current zone in a panel above your Minimap. Left-click it to open the World Map, right-click to link your location in chat."] =
	"미니맵 위 패널에 현재 지역을 표시합니다. 좌클릭하면 세계 지도가 열리고, 우클릭하면 현재 위치를 대화창에 링크합니다."
L["Disable ElvUI Cluster"] = "ElvUI 클러스터 비활성화"
L["ElvUI's Minimap Cluster shows the zone text and the clock above the Minimap. Disable it so it does not overlap the panel."] =
	"ElvUI 미니맵 클러스터는 미니맵 위에 지역 텍스트와 시계를 표시합니다. 패널과 겹치지 않도록 비활성화하세요."
L["Opens Blizzard's addon list. Hidden while ElvUI's own option hides the addon compartment."] =
	"블리자드 애드온 목록을 엽니다. ElvUI 자체 옵션으로 애드온 보관함을 숨긴 경우에는 표시되지 않습니다."
L["Gap between the panel and the Minimap."] = "패널과 미니맵 사이의 간격입니다."
L["Minimap Zone Text"] = "미니맵 지역 텍스트"
L["Zone"] = "지역"
L["Zone and Subzone"] = "지역 및 하위 지역"
L["Zone PvP Status"] = "지역 PvP 상태"
L["Left Click"] = "좌클릭"
L["Hide ElvUI Location Text"] = "ElvUI 위치 텍스트 숨기기"
L["Hides the zone text ElvUI shows on the Minimap, the panel shows it already."] =
	"ElvUI가 미니맵에 표시하는 지역 텍스트를 숨깁니다. 패널에서 이미 표시합니다."
L["Coordinates"] = "좌표"
L["Shows your X coordinate left and your Y coordinate right of the zone text."] = "지역 텍스트의 왼쪽에 X 좌표, 오른쪽에 Y 좌표를 표시합니다."

-- Tracker
L["Tracker"] = "추적기"
L["Battle Res"] = "전투 부활"
L["Shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters."] =
	"쐐기 던전과 공격대 우두머리 전투 중 파티가 공유하는 전투 부활 충전 횟수와 다음 충전까지 남은 시간을 표시합니다."
L["Shows sample values for 20 seconds so you can check the look and position."] =
	"모양과 위치를 확인할 수 있도록 샘플 값을 20초 동안 표시합니다."
L["Mythic+ and Raid"] = "쐐기 던전 및 공격대"
L["Raid"] = "레이드"
L["Desaturate"] = "흑백처리"
L["Greys out the icon while no charge is left."] = "충전이 남아 있지 않은 동안 아이콘을 회색으로 표시합니다."
L["Charges"] = "충전"
L["Recharge Time"] = "재충전 시간"
L["Bloodlust"] = "피의 욕망"
L["The Bloodlust tracker shows your Sated lockout, the active lust and optionally when a lust is ready again."] =
	"피의 욕망 추적기는 만족 제한, 활성화된 피의 욕망, 그리고 선택적으로 피의 욕망을 다시 사용할 수 있는 시점을 표시합니다."
L["Show Sated"] = "만족 표시"
L["Shows the remaining time of your Sated lockout. The active lust itself is always shown."] =
	"만족 제한의 남은 시간을 표시합니다. 활성화된 피의 욕망 자체는 항상 표시됩니다."
L["Show Ready"] = "준비 완료 표시"
L["Keeps the icon up with a Ready text while you can benefit from a lust again."] =
	"피의 욕망의 효과를 다시 받을 수 있는 동안 준비 완료 텍스트와 함께 아이콘을 유지합니다."
L["Greys out the icon while you are Sated."] = "만족 상태인 동안 아이콘을 회색으로 표시합니다."
L["Ready"] = "준비 완료"

-- Movement Alert
L["No %s"] = "%s 없음"
L["%s ready"] = "%s 준비 완료"
L["Movement Alert"] = "이동 알림"
L["Time Spiral"] = "시간의 소용돌이"
L["Gateway Control Shard"] = "관문 조종 파편"
L["Sound"] = "소리"
L["Text to Speech"] = "텍스트 음성 변환"
L["Reads the alert out loud with the voice from Blizzard's Text to Speech settings instead of playing the sound."] =
	"소리를 재생하는 대신 블리자드의 텍스트 음성 변환 설정에 있는 음성으로 알림을 소리 내어 읽어 줍니다."
L["Spoken Text"] = "읽을 텍스트"
L["Unknown Spell"] = "알 수 없는 주문"
L["Movement spells of your class. Only spells your current specialization knows are shown."] =
	"내 직업의 이동 주문입니다. 현재 전문화에서 알고 있는 주문만 표시됩니다."
L["Custom Spells"] = "사용자 지정 주문"
L["Add Spell ID"] = "주문 ID 추가"
L["Tracks another spell of your class, for example one that is missing from the list above."] =
	"내 직업의 다른 주문을 추적합니다. 예: 위 목록에 없는 주문."
L["Not a valid spell ID."] = "올바른 주문 ID가 아닙니다."
L["Remove"] = "제거"
L["Shows the cooldown of your class's movement spells while they are not available, a banner when Time Spiral lets you use one for free and a reminder when your Gateway Control Shard can be used."] =
	"이동 주문을 사용할 수 없는 동안 재사용 대기시간을 표시하고, 시간의 소용돌이로 무료로 사용할 수 있을 때 배너를, 관문 조종 파편을 사용할 수 있을 때 알림을 표시합니다."
L["Shows sample alerts for 20 seconds so you can check the look and position."] =
	"모양과 위치를 확인할 수 있도록 샘플 알림을 20초 동안 표시합니다."
L["Combat Only"] = "전투 중에만"
L["Only show the cooldowns while you are in combat."] = "전투 중에만 재사용 대기시간을 표시합니다."
L["Display Mode"] = "표시방법"
L["Text"] = "글자 표시"
L["Bar"] = "바"
L["Text Format"] = "글자 형식"
L["Name + Time"] = "이름 + 시간"
L["Time + Name"] = "시간 + 이름"
L["Time only"] = "시간만"
L["Show Decimals"] = "소수점 표시"
L["Places the bars at an ElvUI unit frame instead of their own mover."] = "바를 자체 이동 도구 대신 ElvUI 유닛 프레임에 배치합니다."
L["Match Frame Width"] = "프레임 너비에 맞춤"
L["The bars take the width of the unit frame."] = "바가 유닛 프레임의 너비를 따릅니다."
L["Texture"] = "텍스처"
L["Show Icon"] = "아이콘 표시"
L["Show Time"] = "시간 표시"
L["Ready Alert"] = "준비 완료 알림"
L["Plays a sound or reads the spell name out loud when a movement spell is available again."] =
	"이동 주문을 다시 사용할 수 있게 되면 소리를 재생하거나 주문 이름을 소리 내어 읽습니다."
L["Spells"] = "주문"
L["Shows a banner while one of your movement spells can be used for free after Time Spiral or a similar effect reset it."] =
	"시간의 소용돌이 또는 비슷한 효과로 초기화되어 이동 주문을 무료로 사용할 수 있는 동안 배너를 표시합니다."
L["Shows a reminder while the Gateway Control Shard in your bags can be used."] =
	"가방에 있는 관문 조종 파편을 사용할 수 있는 동안 알림을 표시합니다."

-- Faction Indicator
L["Faction Indicator"] = "진영 표시기"
L["Shows the faction icon of players from the opposing faction."] = "상대 진영 플레이어의 진영 아이콘을 표시합니다."
L["Ping Icon"] = "핑 아이콘"
L["Shows pings placed on a unit on its unitframe."] = "유닛에 찍힌 핑을 해당 유닛 프레임에 표시합니다."
L["Crest"] = "문장"
L["Round"] = "원형"
L["TargetTarget"] = "대상의 대상"
L["FocusTarget"] = "주시 대상"
L["Open the %s Status Report window that shows necessary information for debugging. Post this when reporting bugs!"] =
	"디버깅에 필요한 정보를 보여주는 %s 상태 보고서 창을 엽니다. 버그를 신고할 때 함께 올려 주세요!"
L["Equipment Flyout"] = "장비 선택창"

-- DataTexts
L["Settings for the MerathilisUI datatexts. Add them to a panel in ElvUI's DataTexts options."] =
	"MerathilisUI 데이터 텍스트 설정입니다. ElvUI 데이터 텍스트 설정에서 패널에 추가하세요."
L["Show Icons"] = "아이콘 표시"
L["White Text"] = "흰색 텍스트"
L["Shows the values in white instead of ElvUI's value color."] = "값을 ElvUI 값 색상 대신 흰색으로 표시합니다."
L["White Icon"] = "흰색 아이콘"
L["Keeps the durability icon white instead of coloring it like the durability."] =
	"내구도 아이콘을 내구도에 따라 색을 입히지 않고 흰색으로 유지합니다."
L["Repair Mount"] = "수리용 탈것"
L["Summoned with a right click on the datatext."] = "데이터 텍스트를 우클릭하여 소환합니다."
L["Colored Durability"] = "내구도 색상 표시"
L["Colors the durability below the thresholds. Turned off, it only turns orange below 15%."] =
	"기준값 아래에서 내구도에 색을 입힙니다. 끄면 15% 미만에서만 주황색으로 변합니다."
L["Warning Color"] = "경고 색상"
L["Critical"] = "위험"
L["Critical Color"] = "위험 색상"
L["Permoks Account Manager"] = true
L["RestedXP Guides"] = true

-- NamePlates
L["Target Arrows"] = "대상 화살표"
L["Animated arrows next to the nameplate of your target. While enabled, they replace the arrows of ElvUI's target indicator, its glow stays."] =
	"대상의 이름표 옆에 애니메이션 화살표를 표시합니다. 활성화하는 동안 ElvUI 대상 표시기의 화살표를 대체하며, 반짝임은 유지됩니다."
L["Target Emphasis"] = "대상 강조"
L["Makes the nameplate of your target stand out: while you have a target, the other nameplates fade and get a dark shade, the new target pops up once."] =
	"대상의 이름표를 돋보이게 합니다. 대상이 있는 동안 다른 이름표는 흐려지며 어두운 음영이 입혀지고, 새 대상은 한 번 튀어나옵니다."
L["Shade Other Plates"] = "다른 이름표 음영 처리"
L["Lays a dark shade over the health bar of the nameplates that aren't your target."] =
	"대상이 아닌 이름표의 생명력 바 위에 어두운 음영을 덮습니다."
L["Shade Strength"] = "음영 강도"
L["Fade Other Plates"] = "다른 이름표 흐리게"
L["Lowers the alpha of the nameplates that aren't your target. Plates that use the Visibility settings of ElvUI keep their own alpha."] =
	"대상이 아닌 이름표의 투명도를 낮춥니다. ElvUI의 표시 설정을 사용하는 이름표는 자체 투명도를 유지합니다."
L["Keep Casting Units"] = "시전 중인 유닛 유지"
L["Units that are casting keep their full alpha, so their castbar stays easy to see."] =
	"시전 중인 유닛은 투명도를 그대로 유지하여 시전 바가 잘 보이도록 합니다."
L["Pop on Target"] = "대상 시 튀어나옴"
L["The nameplate of a new target grows for a moment."] = "새 대상의 이름표가 잠시 커집니다."
L["Pop Size"] = "확대 크기"
L["Stronger Border Glow"] = "테두리 반짝임 강화"
L["Makes the border glow of ElvUI's target indicator wider and lets it fade in on a new target. Needs one of the Border styles as Target Glow Style, the color stays ElvUI's Glow Color."] =
	"ElvUI 대상 표시기의 테두리 반짝임을 더 넓게 하고 새 대상에서 서서히 나타나게 합니다. 대상 반짝임 스타일로 테두리 스타일 중 하나가 필요하며, 색상은 ElvUI의 반짝임 색상을 따릅니다."
L["Glow Size"] = "반짝임 크기"
L["The border glow slowly pulses."] = "테두리 반짝임이 천천히 맥동합니다."
L["Bring Target to Front"] = "대상을 맨 앞으로"
L["Draws the nameplate of your target above the nameplates it overlaps."] = "대상의 이름표를 겹치는 다른 이름표 위에 그립니다."
L["Only fades and shades the other nameplates while you are in combat."] = "전투 중에만 다른 이름표를 흐리게 하고 음영 처리합니다."
L["Friendly Plates"] = "아군 이름표"
L["Also fades and shades the nameplates of friendly units."] = "아군 유닛의 이름표도 흐리게 하고 음영 처리합니다."
L["Side Arrows"] = "양옆 화살표"
L["Top Arrow"] = "상단 화살표"
L["Slide In"] = "슬라이드 인"
L["Bounce"] = "바운스"
L["Arrow Texture"] = "화살표 텍스처"
L["Hover Highlight"] = "강조효과"
L["Restyles the highlight on the health bar of the nameplate under your mouse. Needs the Highlight option of ElvUI's nameplates."] =
	"마우스 아래 이름표의 생명력 바 강조 표시를 다시 꾸밉니다. ElvUI 이름표의 강조 표시 옵션이 필요합니다."
L["Fade In"] = "페이드 인"
L["Additive Blend"] = "밝기 조정"
L["Brightens the health bar instead of laying the texture over it."] = "텍스처를 덮는 대신 생명력 바를 밝게 합니다."
L["Focus Highlight"] = "주시 대상 강조"
L["Lays a texture over the health bar of your focus target's nameplate."] = "주시 대상 이름표의 생명력 바 위에 텍스처를 덮습니다."
L["Neutral Name Only"] = "중립 이름만 표시"
L["Indicators"] = "표시기"
L["Castbar"] = "시전 바"
L["Health Bar"] = "생명력 바"
L["Neutral NPCs use the Friendly NPC settings of ElvUI's nameplates, by default only their name is shown."] =
	"중립 NPC는 ElvUI 이름표의 우호적 NPC 설정을 사용하며, 기본적으로 이름만 표시됩니다."
L["Show on Target"] = "대상일 때 표시"
L["Shows the full nameplate while the unit is your target."] = "유닛이 대상인 동안 전체 이름표를 표시합니다."
L["Show in Combat"] = "전투 중 표시"
L["Shows the full nameplate while the unit fights you or your group."] = "유닛이 나 또는 내 파티와 싸우는 동안 전체 이름표를 표시합니다."
L["Shows the name with the [name:MER:gradient] tag instead of the Friendly NPC name format."] =
	"우호적 NPC 이름 형식 대신 [name:MER:gradient] 태그로 이름을 표시합니다."
L["Raid Marker Color"] = "공격대 징표 색상"
L["Tints the health bar of a nameplate with a raid marker in the color of that marker."] =
	"공격대 징표가 있는 이름표의 생명력 바에 해당 징표의 색상을 입힙니다."
L["Enemy Forces"] = "적 병력"
L["During a Mythic+ keystone run, shows next to the health bar how much an enemy contributes to the Enemy Forces requirement."] =
	"쐐기 던전 진행 중에 적 병력 요구량에 각 적이 얼마나 기여하는지 생명력 바 옆에 표시합니다."

-- Interrupt Ready
L["Interrupt Ready"] = "차단 준비"
L["Colors the castbar of hostile units while your interrupt is on cooldown and marks the moment it is ready again. The colors are ElvUI's Non-Interruptible and Interruptible castbar colors."] =
	"차단기가 재사용 대기 중인 동안 적대적 유닛의 시전 바에 색을 입히고, 다시 사용 가능해지는 시점을 표시합니다. 색상은 ElvUI의 차단 불가 및 차단 가능 시전 바 색상입니다."
L["ElvUI Castbar Colors"] = "ElvUI 시전 바 색상"
L["Opens ElvUI's castbar colors, where you can change them."] = "색상을 변경할 수 있는 ElvUI 시전 바 색상 설정을 엽니다."
L["Cooldown Color"] = "재사용 대기 색상"
L["Colors the filled part of the castbar while your interrupt is on cooldown."] =
	"차단기가 재사용 대기 중인 동안 시전 바의 채워진 부분에 색을 입힙니다."
L["Ready Window"] = "준비 구간"
L["Colors the rest of the cast from the moment your interrupt is ready again."] =
	"차단기가 다시 사용 가능해지는 순간부터 시전의 나머지 부분에 색을 입힙니다."
L["Ready Tick"] = "준비 눈금"
L["A thin line at the moment your interrupt is ready again."] = "차단기가 다시 사용 가능해지는 순간에 표시되는 얇은 선입니다."
L["Tick Color"] = "눈금 색상"
L["Units"] = "유닛"
L["Interrupt on Cooldown"] = "차단기 재사용 대기 중"

-- Castbar Shield
L["Castbar Shield"] = "시전 바 방패"
L["Shows a shield icon on the castbar of hostile units while their cast can't be interrupted."] =
	"적대적 유닛의 시전이 차단 불가인 동안 시전 바에 방패 아이콘을 표시합니다."

-- Portraits
L["Portraits"] = "초상화"
L["Shows a portrait next to the unitframes, cut to a shape and framed by a ring in the unit's color."] =
	"유닛 프레임 옆에 모양대로 잘라내고 유닛 색상의 링으로 둘러싼 초상화를 표시합니다."
L["Shape"] = "모양"
L["Drop"] = "물방울"
L["Square"] = "사각형"
L["Class color for players, reaction color for NPCs. Gradient uses the colors of the Gradient Theme."] =
	"플레이어는 직업 색상, NPC는 반응 색상을 사용합니다. 그라데이션은 그라데이션 테마의 색상을 사용합니다."
L["Shadow"] = "그림자"
L["Shadow Alpha"] = "그림자 투명도"
L["Inner Shadow"] = "안쪽 그림자"
L["Darkens the portrait along the inside of the ring."] = "링 안쪽을 따라 초상화를 어둡게 합니다."
L["Marks boss, elite and rare NPCs on their portrait."] = "우두머리, 정예, 희귀 NPC를 초상화에 표시합니다."
L["Dragon"] = "용"
L["Badge"] = "배지"
L["Ring Color"] = "링 색상"
L["Show On"] = "표시 대상"
L["Dragon Color"] = "용 색상"
L["Portrait Color"] = "초상화 색상"
L["Above the Ring"] = "링 위에 표시"
L["Draws the dragon over the ring instead of behind it."] = "용을 링 뒤가 아니라 링 위에 그립니다."
L["Unit"] = "유닛"
L["Cast Icon"] = "시전 아이콘"
L["Shows the spell icon instead of the portrait while the unit casts."] = "유닛이 시전하는 동안 초상화 대신 주문 아이콘을 표시합니다."
L["Mirror"] = "좌우 반전"
L["Flips the portrait and the shape, for frames on the right side."] = "오른쪽에 있는 프레임을 위해 초상화와 모양을 뒤집습니다."
L["Relative Point"] = "상대 기준점"

-- Rounded Corners
L["Rounded Corners"] = "둥근 모서리"
L["Rounds the corners of the health, power, class and cast bars, including their border."] =
	"생명력, 자원, 직업, 시전 바의 모서리를 테두리를 포함해 둥글게 합니다."
L["0 keeps the default subtle corners, any other value is the corner radius in pixels."] =
	"0은 기본의 은은한 모서리를 유지하며, 그 외의 값은 모서리 반지름(픽셀)입니다."
L["The MerathilisUI layout with rounded health, power, class and cast bars on all unit frames."] =
	"모든 유닛 프레임의 생명력, 자원, 직업, 시전 바가 둥근 MerathilisUI 레이아웃입니다."

-- Cast on You
L["Cast on You"] = "나에게 시전"
L["Marks the castbar of hostile units while their cast targets you. Channeled spells are not marked."] =
	"시전 대상이 나인 동안 적대적 유닛의 시전 바에 표시합니다. 정신 집중 주문은 표시되지 않습니다."
L["Castbar Border"] = "시전 바 테두리"
L["A colored border around the castbar."] = "시전 바 주위의 색상 테두리입니다."
L["Border Size"] = "테두리 크기"
L["Castbar Color"] = "시전 바 색상"
L["Colors the filled part of the castbar. The Interrupt Ready colors stay on top."] =
	"시전 바의 채워진 부분에 색을 입힙니다. 차단 준비 색상이 그 위에 유지됩니다."

-- Execute Line
L["Execute Line"] = "처형 구간 표시선"
L["A line on the health bar at the given health percent, so you see at a glance when a unit gets into the range of your execute abilities."] =
	"지정한 생명력 비율 위치에 생명력 바 위에 선을 표시하여, 유닛이 처형 기술 사용 범위에 들어오는 것을 한눈에 볼 수 있습니다."
L["Hostile Units Only"] = "적대적 유닛만"
L["Only shows the line on units you can attack."] = "공격할 수 있는 유닛에만 선을 표시합니다."
L["Health Percent"] = "생명력 비율"
L["Glow"] = "발광"
L["A soft glow around the line."] = "선 주위의 은은한 반짝임입니다."
L["Pulse"] = "맥동"
L["The glow slowly pulses."] = "반짝임이 천천히 맥동합니다."
L["Markers"] = "표식"
L["Small arrows at both ends of the line that point at the health bar."] = "선의 양 끝에서 생명력 바를 가리키는 작은 화살표입니다."
L["Execute Range"] = "처형 구간"
L["Tints the part of the health bar below the line, fading in towards the line."] =
	"선 아래 생명력 바 부분에 색을 입히며, 선 쪽으로 갈수록 서서히 나타납니다."
L["Range Opacity"] = "구간 불투명도"

-- HoverCast
L["HoverCast"] = "마우스오버 시전"
L["%s is disabled while %s is loaded, both bind clicks on the same unit frames."] =
	"%s이(가) 비활성화되었습니다. %s이(가) 로드되어 있으며, 둘 다 같은 유닛 프레임의 클릭을 지정합니다."
L["Always casts your highest rank."] = "항상 가장 높은 등급으로 시전합니다."
L["Target Unit"] = "유닛 대상 지정"
L["Context Menu"] = "상황별 메뉴"
L["Actions"] = "행동"
L["Trinket 1"] = "장신구 1"
L["Trinket 2"] = "장신구 2"
L["Dynamic Rez"] = "동적 부활"
L["Unknown Macro"] = "알 수 없는 매크로"
L["Unknown Item"] = "알 수 없는 아이템"
L["Dispels"] = "해제"
L["Externals"] = "외부 생존기"
L["Right Click"] = "우클릭"
L["Middle Click"] = "휠클릭"
L["Mouse 4"] = "마우스 4"
L["Mouse 5"] = "마우스 5"
L["Wheel Up"] = "휠 위로"
L["Wheel Down"] = "휠 아래로"
L["Not Bound"] = "지정되지 않음"
L["Press a key, click, or scroll..."] = "키를 누르거나 클릭하거나 스크롤하세요..."
L["Left-click to set keybind.\nRight-click to clear."] = "좌클릭하여 단축키를 지정합니다.\n우클릭하여 해제합니다."
L["Conflicting Keybind"] = "충돌하는 단축키"
L["%s is also assigned to:"] = "%s은(는) 다음에도 지정되어 있습니다:"
L["Not currently talented"] = "현재 선택되지 않은 특성"
L["Global Bindings"] = "전역 지정"
L["Spec Bindings"] = "전문화별 지정"
L["Macros"] = "매크로"
L["Add Global Binding"] = "전역 지정 추가"
L["Add New"] = "새로 추가"
L["Quickbind"] = "퀵바인드"
L["Quickbind: hover a spell, press a key"] = "퀵바인드: 주문 위에 마우스를 올리고 키를 누르세요"
L["Done"] = "완료"
L["Global Options"] = "전역 옵션"
L["Enable Click Casting"] = "클릭 시전 사용"
L['Please disable the addon "Clique" to use this feature.'] = "이 기능을 사용하려면 Clique 애드온을 비활성화하세요."
L["Trigger Bindings on Down"] = "누를 때 지정 실행"
L["Mouseover Frames"] = "마우스오버 프레임"
L["All Unit Frames"] = "모든 유닛 프레임"
L["ElvUI Group Frames"] = "ElvUI 그룹 프레임"
L["Per-Spell Options"] = "주문별 옵션"
L["Spell"] = "주문"
L["Macro"] = "매크로"
L["Item"] = "아이템"
L["Action"] = "행동"
L["Preset"] = "프리셋"
L["Keybind"] = "단축키"
L["Enable Dynamic Rez"] = "동적 부활 사용"
L["Only Cast Out of Combat"] = "비전투 시에만 시전"
L["Only Open Menu Out of Combat"] = "비전투 시에만 메뉴 열기"
L["Only Target Out of Combat"] = "비전투 시에만 대상 지정"
L["Active In"] = "활성화 위치"
L["Solo"] = "솔로"
L["PvP"] = "PvP"
L["All"] = "전체"
L["Active while you are not in a group."] = "파티에 속하지 않은 동안 활성화됩니다."
L["Active in a PvE party."] = "PvE 파티에서 활성화됩니다."
L["Active in a PvE raid."] = "PvE 공격대에서 활성화됩니다."
L["Active in battlegrounds and arenas."] = "전장과 투기장에서 활성화됩니다."
L["Cast On"] = "시전 대상"
L["Frames"] = "프레임"
L["Frames and Mouseover"] = "프레임 및 마우스오버"
L["Hovercast is not available for unmodified left/right click"] = "마우스오버 시전은 수정키 없는 좌클릭/우클릭에는 사용할 수 없습니다"
L["Unit Types"] = "유닛 유형"
L["Enemy"] = "적군"
L["Friendly"] = "아군"
L["Disabling both disables this binding."] = "둘 다 끄면 이 지정이 비활성화됩니다."
L["Select a binding from either sidebar to edit its options"] = "옵션을 편집하려면 양쪽 사이드바 중 하나에서 지정을 선택하세요"

-- Presets
L["Presets"] = "프리셋"
L["Export"] = "출력"
L["Name"] = "이름"
L["Author"] = "제작자"
L["Backup"] = "백업"
L["Made with"] = "제작 버전"
L["Preset Code"] = "프리셋 코드"
L["Apply Preset"] = "프리셋 적용"
L["Create Code"] = "코드 생성"
L["Invalid Code"] = "잘못된 코드"
L["Find More Presets"] = "프리셋 더 찾기"
L["Share Your Preset"] = "내 프리셋 공유"
L["Browse the presets of the community on merathilisui.com"] = "merathilisui.com에서 커뮤니티 프리셋을 둘러보세요"
L["Upload it with a few screenshots on merathilisui.com"] = "merathilisui.com에 스크린샷 몇 장과 함께 업로드하세요"
L["Official preset, included in %s."] = "공식 프리셋이며 %s에 포함되어 있습니다."
L["Select the code with CTRL+A and copy it with CTRL+C."] = "CTRL+A로 코드를 선택하고 CTRL+C로 복사하세요."
L["Paste a preset code from %s or from another player. The preset becomes a new ElvUI profile, so you can switch back to your current one at any time."] =
	"%s 또는 다른 플레이어의 프리셋 코드를 붙여넣으세요. 프리셋은 새 ElvUI 프로필이 되므로 언제든지 현재 프로필로 돌아갈 수 있습니다."
L["Turn your current setup into a preset code: the active ElvUI profile with all MerathilisUI settings and the private settings of this character."] =
	"현재 설정을 프리셋 코드로 만듭니다: 활성 ElvUI 프로필, 모든 MerathilisUI 설정, 이 캐릭터의 개인 설정이 포함됩니다."
L["Apply the preset %s as a new ElvUI profile? Your current profile stays untouched, the private settings of this character are kept as a backup. The UI reloads afterwards."] =
	"프리셋 %s을(를) 새 ElvUI 프로필로 적용하시겠습니까? 현재 프로필은 그대로 유지되며, 이 캐릭터의 개인 설정은 백업으로 보관됩니다. 이후 UI가 다시 불러와집니다."
L["This is not a MerathilisUI preset code."] = "MerathilisUI 프리셋 코드가 아닙니다."
L["This is an ElvUI profile string. Import it in the ElvUI profile options."] =
	"ElvUI 프로필 문자열입니다. ElvUI 프로필 설정에서 가져오세요."
L["The preset code is damaged. Copy it again, completely."] = "프리셋 코드가 손상되었습니다. 전체를 다시 복사하세요."
L["This preset needs a newer version of MerathilisUI."] = "이 프리셋에는 더 최신 버전의 MerathilisUI가 필요합니다."
L["This preset is not included in your version of MerathilisUI. Please update the addon."] =
	"이 프리셋은 현재 MerathilisUI 버전에 포함되어 있지 않습니다. 애드온을 업데이트하세요."
L["Made for WoW Forever, some settings might not fit Retail."] = "WoW Forever용으로 제작되었으며, 일부 설정은 리테일과 맞지 않을 수 있습니다."
L["Made for Retail, some settings might not fit WoW Forever."] = "리테일용으로 제작되었으며, 일부 설정은 WoW Forever와 맞지 않을 수 있습니다."
L["Made with MerathilisUI %s, update the addon to get all of its settings."] =
	"MerathilisUI %s(으)로 제작되었습니다. 모든 설정을 적용하려면 애드온을 업데이트하세요."
L["Made for a %dx%d screen, a few positions might need adjusting at %dx%d."] =
	"%dx%d 화면용으로 제작되었으며, %dx%d에서는 일부 위치를 조정해야 할 수 있습니다."
L["The preset could not be applied completely."] = "프리셋을 완전히 적용하지 못했습니다."
L["Copy Code"] = "코드 복사"
L["Official Presets"] = "공식 프리셋"
L["Dark"] = "어두운 느낌"
L["Healer"] = "힐러"
L["Minimal"] = "미니멀"
L["Compact"] = "컴팩트"
L["Presets made by the author of %s. Each one starts from the current MerathilisUI layout, so it stays up to date with every release."] =
	"%s 제작자가 만든 프리셋입니다. 각 프리셋은 현재 MerathilisUI 레이아웃에서 시작하므로 모든 릴리스에 맞춰 최신 상태로 유지됩니다."
L["The MerathilisUI layout with gradient health bars in the class color."] =
	"직업 색상 그라데이션 생명력 바가 적용된 MerathilisUI 레이아웃입니다."
L["The MerathilisUI layout with dark health bars and the class color on their backdrop."] =
	"어두운 생명력 바와 배경에 직업 색상이 적용된 MerathilisUI 레이아웃입니다."
L["Bigger party and raid frames in the middle of the screen, close to your character."] =
	"화면 중앙 캐릭터 가까이에 배치된 더 큰 파티 및 공격대 프레임."
L["Only the main action bar stays visible, the other bars show on mouseover. No chat backgrounds, chat bar or portraits."] =
	"주 행동 단축바만 계속 표시되고 나머지 바는 마우스를 올리면 표시됩니다. 대화창 배경, 대화 바, 초상화가 없습니다."
L["Smaller unit frames and action buttons for 1080p and small screens."] = "1080p 및 작은 화면용으로 더 작은 유닛 프레임과 행동 버튼."
L["Type /mer presets to pick a ready-made look. Every preset becomes a new ElvUI profile, so you can switch back at any time."] =
	"/mer presets를 입력하면 준비된 스타일을 고를 수 있습니다. 모든 프리셋은 새 ElvUI 프로필이 되므로 언제든지 돌아갈 수 있습니다."
L["More presets from the community wait on merathilisui.com/presets. Copy a code and paste it under Presets > Import."] =
	"커뮤니티의 더 많은 프리셋은 merathilisui.com/presets에서 볼 수 있습니다. 코드를 복사하여 프리셋 > 가져오기에 붙여넣으세요."
L["Presets > Export turns your setup into a code. Upload it with a few screenshots on merathilisui.com to share it."] =
	"프리셋 > 내보내기는 현재 설정을 코드로 만듭니다. merathilisui.com에 스크린샷 몇 장과 함께 업로드하여 공유하세요."

-- Option cards
L["Scales the character, dressing room, inspect, talent and collection frames on their own, independent of the UI scale."] =
	"캐릭터, 착용 미리보기, 살펴보기, 전문화, 수집 창의 크기를 UI 크기와 별개로 조절합니다."
L["Shows the name, level, guild and target of the unit under your mouse cursor right next to it."] =
	"마우스 커서 아래 유닛의 이름, 레벨, 길드, 대상을 커서 바로 옆에 표시합니다."
L["Shows small toast notifications for new mail, invites, guild events, paragon rewards and more."] =
	"새 우편, 초대, 길드 이벤트, 용사 보상 등에 대한 작은 알림을 표시합니다."
L["Shows its own action bar while you are in a vehicle or skyriding."] = "탈것 이용 중이거나 스카이라이딩 중일 때 전용 행동 단축바를 표시합니다."
L["Hides ElvUI's action bars 1-3 while the vehicle bar is shown."] = "탈것 바가 표시되는 동안 ElvUI 행동 단축바 1~3을 숨깁니다."
L["Hide While Skyriding"] = "스카이라이딩 중 숨기기"
L["Keeps the vehicle bar hidden while skyriding, ElvUI's action bar 1 shows the skyriding abilities instead. The Vigor Bar is attached to the vehicle bar and is hidden as well."] =
	"스카이라이딩 중에는 탈것 바를 숨기고 ElvUI 행동 단축바 1에 스카이라이딩 기술이 표시됩니다. 활력 바는 탈것 바에 붙어 있으므로 함께 숨겨집니다."
L["Restyles Blizzard's built-in damage meter in the MerathilisUI look."] = "블리자드 기본 피해량 측정기를 MerathilisUI 스타일로 다시 꾸밉니다."

-- Quick Grid
L["Quick Grid"] = "퀵 그리드"
L["Hold a key and a grid of eight actions opens around your mouse cursor. Point in a direction and release the key to use that action. Releasing in the center or without moving the mouse cancels. Works in combat."] =
	"키를 누르고 있으면 마우스 커서 주위에 8개 행동의 격자가 열립니다. 원하는 방향을 가리키고 키를 놓으면 해당 행동을 사용합니다. 중앙에서 놓거나 마우스를 움직이지 않고 놓으면 취소됩니다. 전투 중에도 사용할 수 있습니다."
L["Open At"] = "열리는 위치"
L["Opens the grid under your mouse cursor or always in the middle of the screen."] = "격자를 마우스 커서 아래에 열거나 항상 화면 중앙에 엽니다."
L["Screen Center"] = "화면 중앙"
L["Tile Size"] = "타일 크기"
L["Show Cooldowns"] = "재사용 대기시간 표시"
L["Shows the cooldowns of spells, items and toys on their tiles."] = "타일에 주문, 아이템, 장난감의 재사용 대기시간을 표시합니다."
L["Show Name"] = "이름 표시"
L["Shows the name of the selected action below the grid."] = "선택한 행동의 이름을 격자 아래에 표시합니다."
L["Name Size"] = "이름 크기"
L["Decks"] = "덱"
L["Hold this key to open the deck. The free modifier combinations of the key open it too, so a modifier can be pressed while the deck is open."] =
	"이 키를 누르고 있으면 덱이 열립니다. 이 키에 사용 가능한 보조키 조합으로도 열리므로, 덱이 열려 있는 동안 보조키를 누를 수 있습니다."
L["Custom Deck"] = "사용자 지정 덱"
L["Drag a spell, item or macro onto a field, or type the name of a spell, macro, mount, toy, item or equipment set. Empty a field to clear it."] =
	"주문, 아이템, 매크로를 칸 위로 드래그하거나, 주문, 매크로, 탈것, 장난감, 아이템, 장비 세트의 이름을 입력하세요. 칸을 비우면 지워집니다."
L["The center cancels."] = "중앙은 취소입니다."
L["Could not find %s. Use the name of a spell, macro, mount, toy, item or equipment set."] =
	"%s을(를) 찾을 수 없습니다. 주문, 매크로, 탈것, 장난감, 아이템, 장비 세트의 이름을 사용하세요."
L["Teleports"] = "순간이동"
L["Travel"] = "이동"
L["Random Favorite Mount"] = "무작위 즐겨찾기 탈것"
L["World Marker"] = "월드 징표"
L["The Mythic+ dungeon teleports of the current season. Teleports you don't know yet are greyed out."] =
	"현재 시즌의 쐐기 던전 순간이동입니다. 아직 모르는 순간이동은 회색으로 표시됩니다."
L["Random favorite mount (top), hearthstone (right), Dalaran Hearthstone (left), a vendor mount (bottom), an auction house mount (top right) and your first favorite mounts in the free corners."] =
	"무작위 즐겨찾기 탈것(위), 귀환석(오른쪽), 달라란 귀환석(왼쪽), 상인 탈것(아래), 경매장 탈것(오른쪽 위), 빈 모서리에는 첫 번째 즐겨찾기 탈것들이 배치됩니다."
L["Raid target icons on your target. Hold Shift while you release the key to place the matching world marker instead."] =
	"대상에 공격대 대상 아이콘을 지정합니다. 키를 놓을 때 Shift를 누르고 있으면 대신 해당 월드 징표를 설치합니다."
L["Both professions with their second ability, cooking, fishing and archaeology, always in the same place. The top left opens the professions book."] =
	"두 전문 기술과 각각의 두 번째 능력, 요리, 낚시, 고고학이 항상 같은 위치에 배치됩니다. 왼쪽 위는 전문 기술 책을 엽니다."
L["Eight places of your own for spells, items, toys, macros, mounts and equipment sets. Saved per character."] =
	"주문, 아이템, 장난감, 매크로, 탈것, 장비 세트를 위한 8개의 개인 칸입니다. 캐릭터별로 저장됩니다."
L["Equipment Sets"] = "장비 세트"
L["The first eight sets of your Equipment Manager, clockwise from the top in the manager's order. The set you wear is marked. Changing gear does not work in combat."] =
	"장비 관리자의 처음 8개 세트가 관리자 순서대로 위쪽부터 시계 방향으로 배치됩니다. 착용 중인 세트에는 표시가 붙습니다. 전투 중에는 장비를 변경할 수 없습니다."
L["Quick Grid opens a grid of eight actions at your cursor while you hold a key: teleports, mounts, markers, professions or your own."] =
	"퀵 그리드는 키를 누르고 있는 동안 커서 위치에 8개 행동의 격자를 엽니다: 순간이동, 탈것, 징표, 전문 기술 또는 직접 구성한 행동."
L["In the Quick Grid marker deck, hold Shift while you release the key to place a world marker instead of a target marker."] =
	"퀵 그리드 징표 덱에서 키를 놓을 때 Shift를 누르고 있으면 대상 징표 대신 월드 징표를 설치합니다."
L["Hold %s"] = "%s 누르고 있기"
L["Hold the key"] = "키 누르고 있기"
L["Release the key"] = "키 놓기"

-- Tooltip
L["Achievement"] = "업적"
L["Buffs"] = "버프"
L["Players Only"] = "플레이어만"
L["Icons Per Row"] = "줄당 아이콘 수"
L["Max Icons"] = "최대 아이콘 수"
L["Stack Font Size"] = "중첩 글꼴 크기"
L["Shows on achievement links who earned the achievement and whether you have completed it too."] =
	"업적 링크에 누가 업적을 달성했는지와 나도 완료했는지 표시합니다."
L["Colors the upgrade level line of items by the upgrade track and shows the item level the item can still be upgraded to."] =
	"아이템의 강화 단계 줄을 강화 등급에 따라 색칠하고 아이템을 더 강화할 수 있는 아이템 레벨을 표시합니다."
L["Mount Source"] = "탈것 출처"
L["Shows on the tooltip of a mounted player which mount it is and where it comes from. Blizzard hides this from addons in combat, during encounters, in Mythic+ and in PvP matches, so nothing shows there."] =
	"탈것을 탄 플레이어의 툴팁에 어떤 탈것인지와 획득처를 표시합니다. 블리자드는 전투 중, 우두머리 전투 중, 쐐기 던전, PvP 경기에서 이 정보를 애드온에 숨기므로 그곳에서는 표시되지 않습니다."
L["Mount Collected"] = "탈것 수집 여부"
L["Also shows whether you own that mount yourself."] = "내가 해당 탈것을 가지고 있는지도 표시합니다."
L["Up to %d"] = "최대 %d개"
L["Shows the buffs of the hovered unit as icons on the tooltip."] = "마우스를 올린 유닛의 버프를 툴팁에 아이콘으로 표시합니다."
L["Only show buffs on the tooltip of players."] = "플레이어의 툴팁에만 버프를 표시합니다."

-- Unlock Mode
L["Unlock Mode"] = "잠금 해제 모드"
L["Extends ElvUI's mover mode: movers snap to each other with guide lines, can be anchored to each other, a click selects a mover for the arrow keys and a toolbar shows your changes, which you can save or revert. The positions stay in ElvUI's profile."] =
	"ElvUI의 이동 도구 모드를 확장합니다: 이동 도구가 안내선과 함께 서로 맞춰지고, 서로에게 고정할 수 있으며, 클릭하면 방향키로 조절할 이동 도구가 선택되고 툴바에 변경 사항이 표시되어 저장하거나 되돌릴 수 있습니다. 위치는 ElvUI 프로필에 그대로 저장됩니다."
L["Open Unlock Mode"] = "잠금 해제 모드 열기"
L["Opens ElvUI's mover mode with the additions of this page."] = "이 페이지의 추가 기능이 적용된 ElvUI 이동 도구 모드를 엽니다."
L["Toolbar"] = "툴바"
L["Shows a toolbar at the top of the screen instead of ElvUI's mover window, with the layout filter, grid, snapping and your changes."] =
	"ElvUI 이동 도구 창 대신 화면 상단에 레이아웃 필터, 격자, 맞춤, 변경 사항이 있는 툴바를 표시합니다."
L["Show Grid"] = "격자 표시"
L["Class Colored Grid"] = "직업 색상 격자"
L["Draws the center lines of the grid in your class color."] = "격자의 중심선을 직업 색상으로 그립니다."
L["Small Movers on Top"] = "작은 이동 도구를 위에 표시"
L["Small movers are drawn above big ones, so a mover inside another one can still be grabbed."] =
	"작은 이동 도구를 큰 이동 도구 위에 그려서, 다른 이동 도구 안에 있는 이동 도구도 잡을 수 있게 합니다."
L["Snapping"] = "맞춤"
L["While you drag a mover, its edges and center snap to the edges and centers of the other movers. Hold Shift to drag freely. Replaces ElvUI's Sticky Frames as long as it is on."] =
	"이동 도구를 드래그하는 동안 가장자리와 중앙이 다른 이동 도구의 가장자리 및 중앙에 맞춰집니다. Shift를 누르면 자유롭게 드래그합니다. 켜져 있는 동안 ElvUI의 자석 프레임을 대체합니다."
L["Guide Lines"] = "안내선"
L["Draws a line across the screen where the mover snapped."] = "이동 도구가 맞춰진 위치에 화면을 가로지르는 선을 그립니다."
L["Snap to Screen"] = "화면에 맞춤"
L["Also snaps to the center and the edges of the screen."] = "화면의 중앙과 가장자리에도 맞춰집니다."
L["Snap Distance"] = "맞춤 거리"
L["How close an edge has to come before it snaps, in pixels."] = "가장자리가 얼마나 가까워져야 맞춰지는지 픽셀 단위로 설정합니다."
L["Keyboard"] = "키보드"
L["Click a mover to select it, the arrow keys then move it by one pixel. Escape or another click on it clears the selection."] =
	"이동 도구를 클릭해 선택하면 방향키로 1픽셀씩 이동합니다. Esc를 누르거나 다시 클릭하면 선택이 해제됩니다."
L["Arrow Keys"] = "방향키"
L["Step with Modifier"] = "보조키 이동 단위"
L["Pixels per key press while Shift, Ctrl or Alt is held."] = "Shift, Ctrl, Alt를 누른 상태에서 키를 한 번 누를 때 이동하는 픽셀 수입니다."
L["Grid Size"] = "격자 크기"
L["Number of grid cells across the screen, from 4 to 256."] = "화면 가로의 격자 칸 수이며, 4에서 256까지 설정할 수 있습니다."
L["Grid"] = "격자"
L["Snap"] = "맞춤"
L["Edges and centers snap to the other movers and to the screen while you drag. Hold Shift to drag freely."] =
	"드래그하는 동안 가장자리와 중앙이 다른 이동 도구와 화면에 맞춰집니다. Shift를 누르면 자유롭게 드래그합니다."
L["Revert"] = "되돌리기"
L["Puts every mover back where it was when the unlock mode opened."] = "잠금 해제 모드를 열었을 때의 위치로 모든 이동 도구를 되돌립니다."
L["Reset All"] = "모두 초기화"
L["Puts every mover back to its default position."] = "모든 이동 도구를 기본 위치로 되돌립니다."
L["Save & Lock"] = "저장 및 잠금"
L["Click: select"] = "클릭: 선택"
L["Arrow keys: nudge, with Shift %d px"] = "방향키: 미세 이동, Shift 누르면 %d 픽셀"
L["Shift while dragging: no snapping"] = "드래그 중 Shift: 맞춤 해제"
L["Shows only the movers whose name contains every typed word."] = "입력한 모든 단어가 이름에 포함된 이동 도구만 표시합니다."
L["Ctrl+Mouse Wheel: cycle overlapping movers"] = "Ctrl+마우스 휠: 겹친 이동 도구 순환"
L["Cycle Overlapping Movers"] = "겹친 이동 도구 순환"
L["Ctrl+mouse wheel over movers lying on top of each other brings the next one to the top and selects it."] =
	"서로 겹쳐 있는 이동 도구 위에서 Ctrl+마우스 휠을 사용하면 다음 이동 도구를 맨 위로 올리고 선택합니다."
L["Auto Hide Toolbar"] = "툴바 자동 숨기기"
L["Hides the toolbar until the cursor reaches its place. It stays hidden while you drag a mover or while a mover is under the cursor, so movers below it can be reached."] =
	"커서가 툴바 위치에 닿을 때까지 숨깁니다. 이동 도구를 드래그하는 동안이나 이동 도구가 커서 아래에 있는 동안에는 숨겨진 상태를 유지하므로, 그 아래의 이동 도구에도 접근할 수 있습니다."
L["Show Mover"] = "이동 도구 표시"
L["Opens the mover mode with only the mover of %s."] = "%s의 이동 도구만 표시한 채 이동 도구 모드를 엽니다."
L["Right-click: settings"] = "우클릭: 설정"
L["Ctrl+Right-click: reset"] = "Ctrl+우클릭: 초기화"
L["Shift+Right-click: hide"] = "Shift+우클릭: 숨기기"
L["%d change"] = "%d개 변경"
L["%d changes"] = "%d개 변경"
L["No changes"] = "변경 사항 없음"
L["Anchors"] = "고정"
L["Select a mover, then Alt-click another one: the selected mover is anchored to it and follows it from then on. The side is taken from where the mover sits. Dragging or nudging an anchored mover only changes its distance to the target. Alt-click the target again to detach it."] =
	"이동 도구를 선택한 다음 다른 이동 도구를 Alt-클릭하세요. 선택한 이동 도구가 그곳에 고정되어 이후 계속 따라갑니다. 방향은 이동 도구가 놓인 위치에서 정해집니다. 고정된 이동 도구를 드래그하거나 미세 이동하면 대상까지의 거리만 변경됩니다. 대상을 다시 Alt-클릭하면 고정이 해제됩니다."
L["Anchor Lines"] = "고정선"
L["Connects anchored movers with a line in the mover mode."] = "이동 도구 모드에서 고정된 이동 도구를 선으로 연결합니다."
L["Detach All"] = "모두 고정 해제"
L["Detaches every anchored mover, it keeps its current place on the screen."] =
	"고정된 모든 이동 도구의 고정을 해제하며, 화면의 현재 위치는 유지됩니다."
L["Detach"] = "고정 해제"
L["%s is anchored to %s."] = "%s은(는) %s에 고정되어 있습니다."
L["Alt-click another mover to anchor %s to it."] = "%s을(를) 고정하려면 다른 이동 도구를 Alt-클릭하세요."
L["Select a mover, then Alt-click another one to anchor it there."] = "이동 도구를 선택한 다음 다른 이동 도구를 Alt-클릭하여 고정하세요."
L["%s can't be anchored to %s, because %s already follows it."] = "%s은(는) %s에 고정할 수 없습니다. %s이(가) 이미 따라가고 있기 때문입니다."
L["Shift+Alt-click: pick anchor points"] = "Shift+Alt-클릭: 고정 지점 선택"
L["Shift+Alt-click picks both points by hand instead: first one of nine on the selected mover, then one on the target. The two points are put on top of each other, Esc cancels."] =
	"Shift+Alt-클릭은 두 지점을 직접 선택합니다: 먼저 선택한 이동 도구의 9개 지점 중 하나, 그다음 대상의 한 지점입니다. 두 지점이 겹쳐지며, Esc로 취소합니다."
L["Pick a point on %s."] = "%s의 지점을 선택하세요."
L["Pick the point on %s that %s docks to."] = "%s에서 %s이(가) 붙을 지점을 선택하세요."
L["Esc or right-click: cancel"] = "Esc 또는 우클릭: 취소"
L["Edit Mode Hints"] = "편집 모드 안내"
L["Marks the parts of the interface that Blizzard's Edit Mode places instead of ElvUI. A click on one closes the mover mode and opens the Edit Mode."] =
	"ElvUI가 아닌 블리자드 편집 모드가 배치하는 인터페이스 부분을 표시합니다. 하나를 클릭하면 이동 도구 모드가 닫히고 편집 모드가 열립니다."
L["Placed by Blizzard's Edit Mode, not by ElvUI."] = "ElvUI가 아닌 블리자드 편집 모드가 배치합니다."
L["Click: open Blizzard's Edit Mode"] = "클릭: 블리자드 편집 모드 열기"
L["Plays a short unlock animation when the mover mode opens and a lock animation when it closes."] =
	"이동 도구 모드를 열 때 짧은 잠금 해제 애니메이션을, 닫을 때 잠금 애니메이션을 재생합니다."
L["Display"] = "표시"
L["List"] = "목록"
L["Columns"] = "열"
L["Move Left"] = "왼쪽으로 이동"
L["Move Right"] = "오른쪽으로 이동"
L["Category Order"] = "분류 순서"
L["Reset Columns"] = "열 초기화"
L["Click to sort."] = "클릭하여 정렬합니다."
L["Drag to move. Right-click to choose the columns."] = "드래그하여 이동합니다. 우클릭하여 열을 선택합니다."
L["Click to unfold."] = "클릭하여 펼칩니다."
L["iLvl"] = "템렙"
L["Req"] = "요구"
L["Required Level"] = "요구 레벨"
L["Type"] = "유형"
L["Bind"] = "귀속"
L["Bind Type"] = "귀속 유형"
L["Sell Price"] = "판매 가격"
L["SB"] = true
L["WB"] = true
L["Category Value"] = "분류 가치"
L["Shows what the items of a category sell for next to its name."] = "분류의 아이템 판매 가격 합계를 분류 이름 옆에 표시합니다."
L["Grid shows item icons, List one row per item with sortable columns, Compact packs the categories side by side. Also switchable from the title bar."] =
	"격자는 아이템 아이콘을, 목록은 정렬 가능한 열이 있는 아이템별 한 줄을, 간결하게는 분류를 나란히 배치합니다. 제목 표시줄에서도 전환할 수 있습니다."
L["Right-click a column header in the list to show, hide or move columns. Click a column to sort by it."] =
	"목록의 열 머리글을 우클릭하여 열을 표시, 숨기기 또는 이동합니다. 열을 클릭하면 해당 열로 정렬합니다."
L["Junk"] = "잡템"
L["Junk Marker"] = "잡템 표시"
L["Mark Junk"] = "잡템 표시하기"
L["Sell Junk"] = "잡템 판매"
L["Click items to mark them as junk, click again to unmark them."] = "아이템을 클릭하여 잡템으로 표시하고, 다시 클릭하면 표시를 해제합니다."
L["Sold %d junk items for %s."] = "잡템 %d개를 %s에 판매했습니다."
L["Adds a Junk category for grey items and everything you mark as junk. The coin button in the title bar starts marking: click items to mark or unmark them. Sell Junk at a vendor sells all of it."] =
	"회색 아이템과 잡템으로 표시한 모든 아이템을 위한 잡템 분류를 추가합니다. 제목 표시줄의 동전 버튼으로 표시를 시작하며, 아이템을 클릭하여 표시하거나 해제합니다. 상인에게서 잡템 판매를 누르면 모두 판매합니다."
L["Auto Sell"] = "자동 판매"
L["Sells all junk as soon as you open a vendor. Items that can still be refunded are never sold."] =
	"상인을 열자마자 모든 잡템을 판매합니다. 환불이 가능한 아이템은 판매하지 않습니다."
L["Sale Summary"] = "판매 요약"
L["Prints how many items were sold and for how much."] = "판매한 아이템 수와 금액을 출력합니다."
L["Sort by Value"] = "가치순 정렬"
L["Orders the Junk category by sell price, most valuable first."] = "잡템 분류를 판매 가격이 높은 순서로 정렬합니다."
L["Show Junk in Recent Items"] = "최근 아이템에 잡템 표시"
L["Junk Section in All Items / MultiBag"] = "모든 아이템 / 개별 가방의 잡템 구역"
L["Pulls the junk out of All Items and the bags in MultiBag into a Junk section of its own."] =
	"모든 아이템과 개별 가방의 가방에서 잡템을 꺼내 별도의 잡템 구역에 모읍니다."
L["Junk at the Top"] = "잡템을 맨 위에"
L["Shows the Junk section right below Pinned and Recent Items instead of at the end."] =
	"잡템 구역을 맨 끝이 아니라 고정 및 최근 아이템 바로 아래에 표시합니다."
L["Coin Icon Position"] = "동전 아이콘 위치"
L["Corner of the coin icon on junk items."] = "잡템 아이템에서 동전 아이콘이 표시되는 모서리입니다."
L["Reset Junk Marks"] = "잡템 표시 초기화"
L["Unmarks every item you marked as junk and makes all grey items junk again."] =
	"잡템으로 표시한 모든 아이템의 표시를 해제하고 모든 회색 아이템을 다시 잡템으로 지정합니다."

-- Loadout Manager
L["Open World"] = "야외 월드"
L["Applied when you LEAVE an instance and return to the open world. Leave empty to keep whatever you are wearing."] =
	"던전을 나와 야외 월드로 돌아갈 때 적용됩니다. 비워 두면 현재 착용 중인 장비를 유지합니다."
L["Dungeon / Party"] = "던전 / 파티"
L["Mythic+ Keystone"] = "쐐기 던전"
L["Mythic and Keystone dungeons. Beats the Dungeon / Party default."] = "신화 및 쐐기 던전입니다. 던전 / 파티 기본값보다 우선합니다."
L["Timewalking dungeons and raids. Beats their normal type default."] = "시간여행 던전과 공격대입니다. 일반 유형의 기본값보다 우선합니다."
L["Delve"] = "구렁"
L["Delves. Beats the Scenario default."] = "구렁입니다. 시나리오 기본값보다 우선합니다."
L["Battleground / PvP"] = "전장 / PvP"
L["Loadout Manager"] = "구성 관리자"
L["Spec %s"] = "전문화 %s"
L["All Specs"] = "모든 전문화"
L["Copied the assignments of %s into %s."] = "%s의 지정 내용을 %s(으)로 복사했습니다."
L["Skipped %d talent loadout(s) belonging to other specs."] = "다른 전문화에 속한 특성 구성 %d개를 건너뛰었습니다."
L["DONT MOVE - CHANGING TALENTS"] = "움직이지 마세요 - 특성 변경 중"
L["Wait until the loadout finishes."] = "구성 적용이 끝날 때까지 기다리세요."
L["Difficulty %s"] = "난이도 %s"
L["Instance %s"] = "던전 %s"
L["%s (%s Only)"] = "%s (%s 전용)"
L["%s (Any Difficulty)"] = "%s (모든 난이도)"
L["Talent changes are blocked during this encounter."] = "이 전투 중에는 특성을 변경할 수 없습니다."
L["Talent changes are blocked while a PvP match clears."] = "PvP 경기가 정리되는 동안에는 특성을 변경할 수 없습니다."
L["Talent changes are blocked right after combat."] = "전투 직후에는 특성을 변경할 수 없습니다."
L["In combat. Gear swap skipped."] = "전투 중입니다. 장비 교체를 건너뛰었습니다."
L["In combat. Talent swap skipped."] = "전투 중입니다. 특성 교체를 건너뛰었습니다."
L["Retry limit reached, use Check Now when ready."] = "재시도 횟수 제한에 도달했습니다. 준비되면 지금 확인을 사용하세요."
L["Queued for after combat."] = "전투 종료 후로 대기열에 추가되었습니다."
L["The gear swap waits until you are alive."] = "장비 교체는 생존해 있을 때까지 대기합니다."
L["The talent swap waits until you are alive."] = "특성 교체는 생존해 있을 때까지 대기합니다."
L["The swap waits until it is allowed again."] = "교체는 다시 허용될 때까지 대기합니다."
L["Waiting for a game update, Check Now can retry."] = "게임 업데이트를 기다리는 중입니다. 지금 확인으로 다시 시도할 수 있습니다."
L["Equipment sets are not available yet."] = "장비 세트를 아직 사용할 수 없습니다."
L["Could not find the Equipment Manager set %s. It may have been renamed or deleted, Verify Assigned Sets finds stale assignments."] =
	"장비 관리자 세트 %s을(를) 찾을 수 없습니다. 이름이 변경되었거나 삭제되었을 수 있으며, 지정 세트 확인으로 오래된 지정을 찾을 수 있습니다."
L["Gear set %s is already equipped."] = "장비 세트 %s은(는) 이미 착용 중입니다."
L["In combat."] = "전투 중입니다."
L["You are dead."] = "사망했습니다."
L["Gear set %s has %d missing item(s), they may be in the bank. Equipping the rest."] =
	"장비 세트 %s에 누락된 아이템이 %d개 있습니다. 은행에 있을 수 있습니다. 나머지를 착용합니다."
L["Gear swap could not apply %s."] = "장비 교체로 %s을(를) 적용하지 못했습니다."
L["Equipping gear %s (%s)."] = "장비 %s 착용 중 (%s)."
L["manual"] = "수동"
L["Loadout %s"] = "구성 %s"
L["Talent change was interrupted."] = "특성 변경이 중단되었습니다."
L["Talent changes are locked once a PvP match starts. Talent swap skipped."] = "PvP 경기가 시작되면 특성이 잠깁니다. 특성 교체를 건너뛰었습니다."
L["Cannot change talents here yet."] = "이곳에서는 아직 특성을 변경할 수 없습니다."
L["The selected talent loadout belongs to a different specialization. Select a loadout for your current spec."] =
	"선택한 특성 구성이 다른 전문화에 속해 있습니다. 현재 전문화의 구성을 선택하세요."
L["Talent loadouts are not available for your current spec yet."] = "현재 전문화에서는 아직 특성 구성을 사용할 수 없습니다."
L["Could not find the assigned talent loadout for your current spec."] = "현재 전문화에 지정된 특성 구성을 찾을 수 없습니다."
L["Talent loadout %s is already active."] = "특성 구성 %s이(가) 이미 활성화되어 있습니다."
L["Talent swap skipped: the assigned loadout needs a unique saved name. Check for duplicate names, then use Check Now."] =
	"특성 교체를 건너뛰었습니다: 지정된 구성에는 고유한 저장 이름이 필요합니다. 중복된 이름이 있는지 확인한 뒤 지금 확인을 사용하세요."
L["Could not apply talent loadout %s."] = "특성 구성 %s을(를) 적용할 수 없습니다."
L["Requesting talents %s (%s)."] = "특성 %s 요청 중 (%s)."
L["%s default"] = "%s 기본값"
L["Nothing is assigned for %s."] = "%s에 지정된 항목이 없습니다."
L["the open world"] = "야외 월드"
L["Gear set %s did not fully equip, %d item(s) missing (check the bank)."] =
	"장비 세트 %s을(를) 완전히 착용하지 못했습니다. %d개 아이템이 없습니다 (은행을 확인하세요)."
L["Gear set %s did not fully equip, %d item(s) missing."] = "장비 세트 %s을(를) 완전히 착용하지 못했습니다. %d개 아이템이 없습니다."
L["Gear set %s did not finish equipping. Press Check Now to retry."] = "장비 세트 %s 착용이 완료되지 않았습니다. 지금 확인을 눌러 다시 시도하세요."
L["no gear"] = "장비 없음"
L["no talents"] = "특성 없음"
L["Skipped talents: %s belongs to %s. Switch specs to assign %s talents."] =
	"특성을 건너뛰었습니다: %s은(는) %s 소속입니다. %s 특성을 지정하려면 전문화를 전환하세요."
L["%s for %s now uses %s."] = "%s (%s): 이제 %s을(를) 사용합니다."
L["Nothing selected to assign."] = "지정할 항목이 선택되지 않았습니다."
L["Cleared %s for %s (was %s)."] = "%s (%s) 지정을 해제했습니다 (이전: %s)."
L["You are not inside a dungeon, raid or other instance."] = "던전, 공격대 또는 다른 인스턴스 안에 있지 않습니다."
L["Equipment sets are still loading, try again in a moment."] = "장비 세트를 불러오는 중입니다. 잠시 후 다시 시도하세요."
L["All gear assignments point to existing Equipment Manager sets."] = "모든 장비 지정이 존재하는 장비 관리자 세트를 가리키고 있습니다."
L["%d assignment(s) point to missing gear sets (listed above). Reassign or clear them: content type defaults on their own rows, instances under Saved Instances."] =
	"%d개의 지정이 존재하지 않는 장비 세트를 가리키고 있습니다 (위에 표시). 다시 지정하거나 해제하세요: 콘텐츠 유형 기본값은 각 행에서, 던전은 저장된 던전에서 설정합니다."
L["The %s default"] = "%s 기본값"
L["the %s default"] = "%s 기본값"
L["Pick a gear set or talent loadout under Selected Loadout first."] = "먼저 선택한 구성에서 장비 세트 또는 특성 구성을 선택하세요."
L["Enter a dungeon, raid or other instance first."] = "먼저 던전, 공격대 또는 다른 인스턴스에 입장하세요."
L["not set"] = "설정되지 않음"
L["Dungeon"] = "던전"
L["Battleground"] = "전장"
L["open world"] = "야외 월드"
L["This Difficulty"] = "이 난이도"
L["this instance, %s only"] = "이 던전, %s 전용"
L["this instance"] = "이 던전"
L["%s only"] = "%s 전용"
L["every difficulty"] = "모든 난이도"
L["Any Difficulty"] = "모든 난이도"
L["not in an instance"] = "인스턴스 밖"
L["%s Only"] = "%s 전용"
L["Save the selected loadout for this instance on %s, for %s."] = "선택한 구성을 이 던전에 대해 %s 기준으로 %s용으로 저장합니다."
L["Nothing saved here for %s."] = "%s에 저장된 항목이 없습니다."
L["Remove this instance's %s assignment for %s."] = "이 던전의 %s 지정을 제거합니다 (%s용)."
L["Save the selected loadout as the %s default for %s."] = "선택한 구성을 %s 기본값으로 %s용으로 저장합니다."
L["Nothing saved for %s in %s."] = "%s에 대해 %s에 저장된 항목이 없습니다."
L["Remove the %s default for %s."] = "%s 기본값을 제거합니다 (%s용)."
L["Applies gear sets and talent loadouts automatically per instance type and specialization. While off the module registers no events at all, Check Now and Equip Now still work on demand."] =
	"인스턴스 유형과 전문화별로 장비 세트와 특성 구성을 자동으로 적용합니다. 꺼져 있는 동안 모듈은 이벤트를 전혀 등록하지 않으며, 지금 확인과 지금 착용은 필요할 때 직접 사용할 수 있습니다."
L["Auto-Swap Gear Sets"] = "장비 세트 자동 교체"
L["Equip the assigned Equipment Manager set when you enter a new context."] = "새로운 상황에 들어가면 지정된 장비 관리자 세트를 착용합니다."
L["Auto-Swap Talent Loadouts"] = "특성 구성 자동 교체"
L["Load the assigned talent loadout when you enter a new context."] = "새로운 상황에 들어가면 지정된 특성 구성을 불러옵니다."
L["Queue In Combat"] = "전투 중 대기"
L["If a swap is needed while you are in combat, hold it and apply it once combat ends."] =
	"전투 중 교체가 필요하면 보류했다가 전투가 끝나면 적용합니다."
L["Re-Swap On Spec Change"] = "전문화 변경 시 다시 교체"
L["Changing specialization inside an instance re-runs the swap for the new spec."] =
	"인스턴스 안에서 전문화를 변경하면 새 전문화에 대해 교체를 다시 실행합니다."
L["Switching between your Primary and Secondary dual spec applies the gear assigned for the new one, anywhere."] = true
L["Talent-Change Warning"] = "특성 변경 경고"
L["Show the DONT MOVE panel in the middle of the screen while a talent loadout is being applied."] =
	"특성 구성을 적용하는 동안 화면 중앙에 움직이지 마세요 패널을 표시합니다."
L["Announce Swaps In Chat"] = "교체를 대화창에 알림"
L["Ask Before Swap"] = true
L["Ask with a Yes / No popup before an automatic swap changes your gear or talents. No skips the swap until the next one."] = true
L["Swap your loadout for %s?"] = true
L["Gear: %s"] = true
L["Talents: %s"] = true
L["Swap skipped for %s."] = true
L["Print a chat line whenever gear or talents are applied."] = "장비나 특성이 적용될 때마다 대화창에 메시지를 출력합니다."
L["Current Context"] = "현재 상황"
L["Apply whatever is assigned for where you are standing, even while the Loadout Manager is off."] =
	"구성 관리자가 꺼져 있어도 현재 위치에 지정된 항목을 적용합니다."
L["Specialization"] = "전문화"
L["unknown"] = "알 수 없음"
L["Gear Here"] = "이곳의 장비"
L["nothing assigned here"] = "이곳에 지정된 항목 없음"
L["Talents Here"] = "이곳의 특성"
L["Selected Loadout"] = "선택한 구성"
L["Gear Set"] = "장비 세트"
L["The Equipment Manager set the Save buttons below assign. No gear set leaves the saved gear as it is, Clear removes both."] =
	"아래 저장 버튼이 지정하는 장비 관리자 세트입니다. 장비 세트를 지정하지 않으면 저장된 장비가 그대로 유지되며, 해제를 누르면 둘 다 제거됩니다."
L["No gear set"] = "장비 세트 없음"
L["Talent Loadout"] = "특성 구성"
L["The talent loadout the Save buttons below assign. Only loadouts of your current specialization are listed. No talent loadout leaves the saved talents as they are, Clear removes both."] =
	"아래 저장 버튼이 지정하는 특성 구성입니다. 현재 전문화의 구성만 표시됩니다. 특성 구성을 지정하지 않으면 저장된 특성이 그대로 유지되며, 해제를 누르면 둘 다 제거됩니다."
L["The dual spec (Primary or Secondary) the Save buttons below assign: the swap switches to it. No talent loadout leaves the saved talents as they are, Clear removes both."] = true
L["No talent loadout"] = "특성 구성 없음"
L["Assign For"] = "지정 대상"
L["Which layer the Save buttons below write to and show. All Specs applies to every specialization, a spec overrides it for that spec only."] =
	"아래 저장 버튼이 기록하고 표시하는 계층입니다. 모든 전문화는 전문화 전체에 적용되며, 개별 전문화는 해당 전문화에 대해서만 덮어씁니다."
L["Copies another layer into the one picked under Assign For, replacing everything it holds."] =
	"다른 계층을 지정 대상에서 선택한 계층으로 복사하며, 기존 내용은 모두 대체됩니다."
L["Replace every %s assignment with a copy of the %s assignments?"] = "모든 %s 지정을 %s 지정의 복사본으로 대체하시겠습니까?"
L["Equip Now"] = "지금 착용"
L["Apply the gear set and talent loadout picked above right now, ignoring the assignments."] =
	"지정 내용과 관계없이 위에서 선택한 장비 세트와 특성 구성을 지금 바로 적용합니다."
L["Verify Assigned Sets"] = "지정 세트 확인"
L["Lists every assignment that points to an Equipment Manager set that no longer exists."] =
	"더 이상 존재하지 않는 장비 관리자 세트를 가리키는 모든 지정을 나열합니다."
L["Instances"] = "던전"
L["Every instance assignment saved for the layer picked under Assign For, wherever you are. Pick one to see what it holds or clear it."] =
	"위치와 관계없이 지정 대상에서 선택한 계층에 저장된 모든 던전 지정입니다. 하나를 선택하면 내용을 확인하거나 해제할 수 있습니다."
L["Pick an instance"] = "던전 선택"
L["Assignment"] = "지정"
L["nothing saved for %s"] = "%s에 저장된 항목 없음"
L["pick a saved instance"] = "저장된 던전 선택"
L["Pick a saved instance first."] = "먼저 저장된 던전을 선택하세요."
L["Remove %s for %s."] = "%s 제거 (%s용)."
L["Content Type Defaults"] = "콘텐츠 유형 기본값"
L["Resets every Loadout Manager setting and removes all assignments of this character."] =
	"모든 구성 관리자 설정을 초기화하고 이 캐릭터의 모든 지정을 제거합니다."
L["The Loadout Manager equips your gear set and loads your talent loadout on its own when you enter a dungeon, raid or other content. Type /lm to set it up."] =
	"구성 관리자는 던전, 공격대 또는 다른 콘텐츠에 입장하면 장비 세트와 특성 구성을 자동으로 착용하고 불러옵니다. /lm을 입력해 설정하세요."
L["Loadout Manager assignments can be made for all specs or a single spec. A spec assignment wins over the All Specs one."] =
	"구성 관리자 지정은 모든 전문화 또는 하나의 전문화에 대해 만들 수 있습니다. 전문화 지정이 모든 전문화 지정보다 우선합니다."
L["Inside an instance, the Loadout Manager can save a loadout for just the difficulty you are in, e.g. only Mythic."] =
	"인스턴스 안에서 구성 관리자는 현재 난이도에 대해서만(예: 신화 난이도만) 구성을 저장할 수 있습니다."
L["Clear Stuck Spell Targeting"] = "멈춘 주문 대상 지정 해제"
L["Before a binding casts, cancel any spell still waiting for a target (the glowing hand cursor left by a cast on a unit it can't take), so the press casts instead of being swallowed."] =
	"지정된 키가 시전되기 전에, 대상을 기다리는 주문(받을 수 없는 유닛에 시전해서 남은 빛나는 손 커서)을 취소하여 키 입력이 무시되지 않고 시전되도록 합니다."
L["Talent loadout %s did not fully apply."] = "특성 구성 %s이(가) 완전히 적용되지 않았습니다."
L["Talent loadout %s did not load."] = "특성 구성 %s을(를) 불러오지 못했습니다."
L["Talent swap held: a talent change is in progress."] = "특성 교체 보류: 특성 변경이 진행 중입니다."
L["Talent swap held: you have unsaved talent changes."] = "특성 교체 보류: 저장하지 않은 특성 변경이 있습니다."
L["Talent swap held: you are moving or casting."] = true
L["Toggle with Character Window"] = "캐릭터 창과 함께 열기/닫기"
L["Opens the bags together with the character window and closes them again when it closes."] =
	"캐릭터 창과 함께 가방을 열고, 캐릭터 창을 닫으면 가방도 닫습니다."
L["Quick Actions"] = "빠른 행동"
L["Adds a title bar button that highlights the items Disenchant or Pick Lock can work on. Clicking a highlighted item casts the spell on it."] =
	"마력 추출이나 자물쇠 따기를 사용할 수 있는 아이템을 강조하는 제목 표시줄 버튼을 추가합니다. 강조된 아이템을 클릭하면 해당 아이템에 주문을 시전합니다."
L["Click to leave Quick Actions."] = "클릭하여 빠른 행동 종료."
L["Highlights the items your spells can work on (%s). Click a highlighted item to cast the spell on it. Out of combat only."] =
	"주문(%s)을 사용할 수 있는 아이템을 강조합니다. 강조된 아이템을 클릭하면 해당 아이템에 주문을 시전합니다. 비전투 시에만 사용할 수 있습니다."

-- Group Finder
L["Accepted"] = "수락됨"
L["Declined"] = "거절됨"
L["Delisted"] = "목록에서 제거됨"
L["Cancelled"] = "취소됨"
L["Session"] = "세션"
L["Account"] = "계정"
L["Mythic+ Applications"] = "쐐기 던전 지원"
L["|cffFFFFFFClick:|r Switch between session, character and account"] = "|cffFFFFFF클릭:|r 세션, 캐릭터, 계정 간 전환"
L["No applications yet"] = "아직 지원 내역 없음"
L["Members:"] = "멤버:"
L["Adds a few things to the Premade Groups list. Works together with the LFG List and Group Info features of WindTools."] =
	"파티 찾기 목록에 몇 가지 기능을 추가합니다. WindTools의 LFG 목록 및 그룹 정보 기능과 함께 작동합니다."
L["Group List"] = "그룹 목록"
L["Leaver Mark"] = "이탈자 표시"
L["Keeps Blizzard's mark for players who left Mythic+ runs early visible above the role icons, also with the role icons of WindTools."] =
	"쐐기 던전을 중도에 이탈한 플레이어에 대한 블리자드 표시를 역할 아이콘 위에 계속 표시하며, WindTools의 역할 아이콘과도 함께 작동합니다."
L["Missing Roles"] = "부족한 역할"
L["Shows the roles a 5 player group still needs in its empty slots."] = "5인 그룹에 아직 필요한 역할을 빈 칸에 표시합니다."
L["Group Name Colors"] = "그룹 이름 색상"
L["Colors the names of groups that are new since your last search green, and those that declined you or that you are saved to red."] =
	"마지막 검색 이후 새로 생긴 그룹의 이름은 녹색으로, 나를 거절했거나 내가 이미 귀속된 그룹의 이름은 빨간색으로 표시합니다."
L["Members In Tooltip"] = "툴팁에 멤버 표시"
L["Lists the group members by role in the tooltip. With the Group Info tooltip of WindTools, only the names are added."] =
	"툴팁에 그룹 멤버를 역할별로 나열합니다. WindTools의 그룹 정보 툴팁이 있으면 이름만 추가됩니다."
L["Region Tags"] = "지역 태그"
L["Shows where the group leader plays from after the activity: the region on US realms (NA, OCE, MEX, BRA), the realm language on EU realms (EN, DE, FR, ES, IT, PT, RU)."] =
	"활동 이름 뒤에 파티장이 접속한 지역을 표시합니다: 미국 서버는 지역(NA, OCE, MEX, BRA), 유럽 서버는 서버 언어(EN, DE, FR, ES, IT, PT, RU)입니다."
L["Group Notes"] = "그룹 메모"
L["Shows the note of a group in its row, after the play style. Blizzard only shows it in the tooltip."] =
	"플레이 방식 뒤에 그룹의 메모를 행에 표시합니다. 블리자드는 툴팁에만 표시합니다."
L["North America"] = "북미"
L["Oceanic"] = "오세아니아"
L["Latin America"] = "중남미"
L["Brazil"] = "브라질"
L["English"] = "영어"
L["German"] = "독일어"
L["French"] = "프랑스어"
L["Spanish"] = "스페인어"
L["Italian"] = "이탈리아어"
L["Portuguese"] = "포르투갈어"
L["Russian"] = "러시아어"
L["Filter Expression"] = "필터 식"
L["Groups that don't match the expression are dimmed. Words: tanks, healers, dps, members, tankopen, healeropen, dpsopen, score (leader rating), ilvl (required item level), age (minutes), friends, voice, hasbl, hasbr, myclass and class names such as mage or dk. Combine them with and, or, not, comparisons (= != < <= > >=), + - * / and brackets."] =
	"식과 일치하지 않는 그룹은 어둡게 표시됩니다. 사용 가능한 단어: tanks, healers, dps, members, tankopen, healeropen, dpsopen, score(파티장 점수), ilvl(요구 아이템 레벨), age(분), friends, voice, hasbl, hasbr, myclass, 그리고 mage나 dk 같은 직업 이름. and, or, not, 비교(= != < <= > >=), + - * / 및 괄호로 조합할 수 있습니다."
L["Example: %s"] = "예시: %s"
L["Expression"] = "식"
L["Could not read the filter expression at: %s"] = "다음 위치에서 필터 식을 읽을 수 없습니다: %s"
L["No filter set."] = "설정된 필터가 없습니다."
L["The expression is valid."] = "식이 올바릅니다."
L["end of the expression"] = "식의 끝"
L["Counts your Mythic+ applications and shows how they ended in a bar on the Premade Groups page."] =
	"쐐기 던전 지원 횟수를 세고 그 결과를 파티 찾기 페이지의 막대로 표시합니다."
L["Reset Session"] = "세션 초기화"
L["Reset Character"] = "캐릭터 초기화"
L["Reset Account"] = "계정 초기화"

-- Addon Manager
L["Addon Manager"] = "애드온 관리자"
L["Addon Profiles"] = "애드온 프로필"
L["Adds addon profiles, locked addons and a wider search to the game's addon list (Game Menu > AddOns)."] =
	"게임의 애드온 목록(게임 메뉴 > 애드온)에 애드온 프로필, 잠긴 애드온, 확장 검색을 추가합니다."
L["Profiles also load with %s."] = "프로필은 %s과(와) 함께 불러오기도 합니다."
L["Gives the addon list a profile panel, a lock per addon, switches and a size grip in the look of these options."] =
	"애드온 목록에 이 설정의 스타일로 프로필 패널, 애드온별 잠금, 스위치, 크기 조절 손잡이를 추가합니다."
L["Extended Search"] = "확장 검색"
L["The search of the addon list also finds addons by their folder name, author and notes."] =
	"애드온 목록 검색에서 폴더 이름, 제작자, 설명으로도 애드온을 찾습니다."
L["A profile remembers which addons are on. Loading it switches the addons of this character and reloads the UI, locked addons stay on."] =
	"프로필은 어떤 애드온이 켜져 있는지 기억합니다. 불러오면 이 캐릭터의 애드온을 전환하고 UI를 다시 불러오며, 잠긴 애드온은 켜진 상태로 유지됩니다."
L["Load"] = "불러오기"
L["Load this addon profile and reload the UI?"] = "이 애드온 프로필을 불러오고 UI를 다시 불러오시겠습니까?"
L["Overwrite With Current"] = "현재 상태로 덮어쓰기"
L["Save Current As..."] = "현재 상태를 다음 이름으로 저장..."
L["Locked Addons"] = "잠긴 애드온"
L["A locked addon stays on: Disable All, a profile or a click in the list can't turn it off."] =
	"잠긴 애드온은 켜진 상태로 유지됩니다: 모두 끄기, 프로필, 목록 클릭으로도 끌 수 없습니다."
L["The lock in each row of the addon list does the same."] = "애드온 목록 각 행의 잠금도 같은 기능을 합니다."
L["Covers this character and All Characters, not other characters picked in the list."] =
	"이 캐릭터와 모든 캐릭터에 적용되며, 목록에서 선택한 다른 캐릭터에는 적용되지 않습니다."
L["Addon profile %s saved."] = "애드온 프로필 %s을(를) 저장했습니다."
L["There is no addon profile called %s."] = "%s(이)라는 애드온 프로필이 없습니다."
L["There already is an addon profile called %s."] = "%s(이)라는 애드온 프로필이 이미 있습니다."
L["Name of the addon profile:"] = "애드온 프로필 이름:"
L["Delete the addon profile %s?"] = "애드온 프로필 %s을(를) 삭제하시겠습니까?"
L["No profiles yet"] = "아직 프로필 없음"
L["The Addon Manager is off, turn it on in the options under Modules."] = "애드온 관리자가 꺼져 있습니다. 설정의 모듈에서 켜세요."
L["Usage: /muiaddons <profile> loads an addon profile and reloads the UI."] =
	"사용법: /muiaddons <프로필>은 애드온 프로필을 불러오고 UI를 다시 불러옵니다."
L["Simple Addon Manager opens its own window from the Game Menu, so these additions only show in the game's own addon list."] =
	"Simple Addon Manager는 게임 메뉴에서 자체 창을 열기 때문에, 이 추가 기능은 게임 자체 애드온 목록에만 표시됩니다."
L["Switches the addons of this character to the profile. Click Reload UI afterwards."] =
	"이 캐릭터의 애드온을 프로필에 맞게 전환합니다. 이후 UI 다시 불러오기를 클릭하세요."
L["%d |4addon:addons;"] = "애드온 %d개"
L["No profiles yet. Save the addons that are on right now as your first one."] =
	"아직 프로필이 없습니다. 지금 켜져 있는 애드온을 첫 번째 프로필로 저장하세요."
L["Drag to resize"] = "드래그하여 크기 조절"
L["Double-click to reset the size."] = "더블클릭하여 크기 초기화."
L["%s is needed by %s. Turn those off as well?"] = "%s은(는) %s에 필요합니다. 해당 애드온도 함께 끄시겠습니까?"
L["Turn Off"] = "끄기"
L["Keep"] = "유지"
L["Optional: "] = "선택: "
L["Required by: "] = "필요로 하는 애드온: "
L["Author: "] = "제작자: "
L["Extended Tooltip"] = "확장 툴팁"
L["The addon tooltip colors the dependencies (green on, orange off, red not installed) and adds the optional ones, the addons that need it and the author."] =
	"애드온 툴팁에서 의존성을 색상(녹색 켜짐, 주황색 꺼짐, 빨간색 미설치)으로 표시하고, 선택 의존성, 해당 애드온을 필요로 하는 애드온, 제작자를 추가합니다."
L["Enable Dependencies"] = "의존성 활성화"
L["Turning an addon on also turns on the addons it needs."] = "애드온을 켜면 필요한 애드온도 함께 켭니다."
L["Warn About Dependents"] = "종속 애드온 경고"
L["Turning off an addon that others need asks whether those should be turned off as well."] =
	"다른 애드온이 필요로 하는 애드온을 끌 때, 해당 애드온들도 함께 끌지 묻습니다."
L["All Addons"] = "모든 애드온"
L["Enabled Addons"] = "활성화된 애드온"
L["Disabled Addons"] = "비활성화된 애드온"
L["Changed Addons"] = "변경된 애드온"
L["Show"] = "표시"
L["Filter"] = "필터"
L["Show Version"] = "버전 표시"
L["Shows the version of each addon behind its title in the addon list."] = "애드온 목록에서 각 애드온 제목 뒤에 버전을 표시합니다."
L["Find Faulty Addon"] = "문제 애드온 찾기"
L["Turns off half of your addons per reload until the one behind a problem is found. Your addons come back at the end."] =
	"문제의 원인을 찾을 때까지 다시 불러올 때마다 애드온의 절반을 끕니다. 마지막에는 애드온이 원래대로 돌아옵니다."
L["There are no addons to search through, every enabled addon is locked."] = "검색할 애드온이 없습니다. 활성화된 모든 애드온이 잠겨 있습니다."
L["Find the addon that causes a problem: half of your addons are turned off, the UI reloads and you tell whether the problem is still there, until one addon is left. Locked addons stay on. Your addons come back at the end.\n\nStart now?"] =
	"문제를 일으키는 애드온을 찾습니다: 애드온의 절반을 끄고 UI를 다시 불러온 뒤 문제가 아직 있는지 알려 주면, 애드온 하나가 남을 때까지 반복합니다. 잠긴 애드온은 켜진 상태로 유지됩니다. 마지막에는 애드온이 원래대로 돌아옵니다.\n\n지금 시작하시겠습니까?"
L["Find Faulty Addon (step %s)\n\n%s"] = "문제 애드온 찾기 (%s단계)\n\n%s"
L["Problem Is Still There"] = "문제가 아직 있음"
L["Problem Is Gone"] = "문제가 사라짐"
L["Found it: %s causes the problem. Your addons are back."] = "찾았습니다: %s이(가) 문제를 일으킵니다. 애드온이 원래대로 돌아왔습니다."
L["No single addon causes the problem, it also happens with all suspects off (or only with several of them together). Your addons are back."] =
	"단일 애드온이 문제를 일으키는 것이 아닙니다. 의심 애드온을 모두 꺼도 발생하거나(또는 여러 개가 함께 있을 때만 발생합니다). 애드온이 원래대로 돌아왔습니다."
L["The search was stopped. Your addons are back."] = "검색이 중단되었습니다. 애드온이 원래대로 돌아왔습니다."
L["%d of %d suspects on, about %d more |4step:steps; after this one.\n\nDoes the problem still happen?"] =
	"의심 애드온 %d / %d개 켜짐, 이번 단계 이후 약 %d단계가 더 남았습니다.\n\n문제가 여전히 발생합니까?"
L["These locked addons were off and are turned on again: %s\n\nReload the UI to load them?"] =
	"꺼져 있던 이 잠긴 애드온들이 다시 켜졌습니다: %s\n\n불러오려면 UI를 다시 불러오시겠습니까?"
L["Check At Login"] = "로그인 시 확인"
L["A locked addon that was turned off outside the game (e.g. on the character screen) is turned on again at login, and a reload is offered."] =
	"게임 밖(예: 캐릭터 선택 화면)에서 꺼진 잠긴 애드온은 로그인할 때 다시 켜지며, UI 다시 불러오기를 제안합니다."
L["This is not an addon profile code."] = "애드온 프로필 코드가 아닙니다."
L["The addon profile code is damaged. Copy it again, completely."] = "애드온 프로필 코드가 손상되었습니다. 전체를 다시 복사하세요."
L["This addon profile code needs a newer version of MerathilisUI."] = "이 애드온 프로필 코드에는 더 최신 버전의 MerathilisUI가 필요합니다."
L["Imported"] = "가져옴"
L["Addon profile %s imported with %d |4addon:addons;."] = "애드온 프로필 %s을(를) 애드온 %d개와 함께 가져왔습니다."
L["%d of them are not installed, they are skipped when the profile loads."] = "그중 %d개는 설치되어 있지 않으며, 프로필을 불러올 때 건너뜁니다."
L["Paste an addon profile code:"] = "애드온 프로필 코드를 붙여넣으세요:"
L["Adds a profile from an addon profile code."] = "애드온 프로필 코드로 프로필을 추가합니다."
L["Alt-click: lock or unlock"] = "Alt-클릭: 잠금 또는 해제"
L["Shift-click: also switch the addons that need it"] = "Shift-클릭: 필요한 애드온도 함께 전환"
L["Scenarios and Delves"] = "시나리오 및 구렁"
L["Battlegrounds"] = "전장"
L["Your addon profile for this kind of place is %s. Load it now? The UI reloads."] =
	"이 종류의 장소에 대한 애드온 프로필은 %s입니다. 지금 불러오시겠습니까? UI가 다시 불러와집니다."
L["Not Now"] = "나중에"
L["Instance Profiles"] = "인스턴스 프로필"
L["Entering one of these places offers to load its addon profile when your addons differ. Loading reloads the UI."] =
	"이 장소들 중 하나에 입장할 때 애드온이 다르면 해당 애드온 프로필을 불러올지 묻습니다. 불러오면 UI를 다시 불러옵니다."
L["Warband Gold"] = "전쟁부대 골드"
L["Auto Deposit/Withdraw Gold"] = "골드 자동 보관/찾기"
L["Opening the bank moves gold between the character and the warband bank until the character carries the set amount. Applies to all characters of the account."] =
	"은행을 열면 캐릭터가 설정한 금액을 가질 때까지 캐릭터와 전쟁부대 은행 사이에서 골드를 이동합니다. 계정의 모든 캐릭터에 적용됩니다."
L["Gold To Keep"] = "유지할 골드"
L["The gold every character keeps on hand. While this is empty no gold moves, 0 deposits everything."] =
	"모든 캐릭터가 소지할 골드입니다. 비어 있는 동안에는 골드가 이동하지 않으며, 0은 전부 보관합니다."
L["Chat Message"] = "대화창 메시지"
L["Prints every transfer to the chat."] = "모든 이체를 대화창에 출력합니다."
L["Deposited %s to the warband bank."] = "%s을(를) 전쟁부대 은행에 보관했습니다."
L["Withdrew %s from the warband bank."] = "%s을(를) 전쟁부대 은행에서 찾았습니다."
L["Color Casting Enemies"] = "시전 중인 적 색상 지정"
L["Enemy NPCs keep a health bar color after their first cast, so casters stay visible for the whole pull. Interruptible wins once a mob has shown both kinds. Needs ElvUI's nameplate castbar."] =
	"적 NPC는 첫 시전 이후에도 생명력 바 색상을 유지하므로, 시전하는 적을 전투 내내 쉽게 알아볼 수 있습니다. 두 종류를 모두 보인 적은 차단 가능이 우선합니다. ElvUI 이름표 시전 바가 필요합니다."
L["Show / hide keyring"] = "열쇠고리 표시 / 숨기기"
L["Show in Sidebar"] = true
L["Turns the category off. You can turn it on again in the options."] = true
L["The built-in categories the bags sort items into. Items of a category that is off go to the next matching one, or Miscellaneous. Delete in a category's right-click menu turns it off as well."] = true

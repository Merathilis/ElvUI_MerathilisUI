-- Korean localization file for koKR.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "koKR")

-- Core
L["Enable"] = "사용"
L[" is loaded. For any issues or suggestions join my discord: "] =
	"애드온 로딩이 완료되었습니다. 오류 신고 및 피드백은 디스코드를 통해 전달해 주세요."
L[" or visit my homepage: "] = true
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
L["SplashScreen"] = "로그인 화면"
L["Enable/Disable the Splash Screen on Login."] = "로그인 시 스플래시 화면을 표시/숨깁니다."

-- Performance Tuning
L["Performance Tuning"] = true
L["Trades environment detail for a higher frame rate and a sharper image with one click."] = true
L["Boost FPS & Clarity"] = true
L["Adjusts your graphics settings for a higher frame rate and a sharper image. Textures stay on high."] = true
L["Revert to Previous Settings"] = true
L["Puts back the graphics settings you had before the tuning."] = true
L["Show Details"] = true
L["Hide Details"] = true
L["What the Tuning Changes"] = true
L["Performance tuning applied."] = true
L["Previous graphics settings are back."] = true
L["The tuning lowers the settings that cost a lot of FPS but add little to what you actually see in combat."] = true
L["Your previous values are saved first, so the revert button can bring them back at any time."] = true
L["Changed settings:"] = true
L["Shadow Quality: Fair (balanced quality and FPS)"] = true
L["Liquid Detail: Low"] = true
L["Particle Density: Ultra (keeps important spell effects)"] = true
L["SSAO (Ambient Occlusion): Disabled"] = true
L["Depth Effects: Disabled"] = true
L["Compute Effects: Disabled"] = true
L["Outline Mode: Disabled"] = true
L["Texture Resolution: High"] = true
L["Spell Density: Essential"] = true
L["Projected Textures: Enabled (needed for ground effects)"] = true
L["View Distance: 1"] = true
L["Environment Detail: 1"] = true
L["Ground Clutter: 1"] = true
L["Raid/Dungeon Settings: Same settings everywhere"] = true
L["Resample Sharpening: Enabled (crisper image)"] = true
L["Reverb: Disabled (spell and interrupt sound cues stay crisp)"] = true
L["Contrast: +10 (if currently 55 or below)"] = true
L["Character and world textures are left on high, only distant scenery, effects and post-processing are toned down."] = true

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
L["Info"] = "정보"
L["Login Message"] = "로그인 메시지 표시"

-- Information
L["Information"] = "정보"
L["Support & Downloads"] = "지원 및 다운로드"
L["Tukui"] = "Tukui"
L["Website"] = true
L["Coding"] = "코딩"
L["Testing & Inspiration"] = "테스트 및 영감"
L["Development Version"] = "개발 버전"
L["Join the community"] = true
L["Report bugs and suggestions"] = true
L["Via the CurseForge app"] = true
L["Via the Wago app"] = true
L["Latest development build"] = true
L["Found a Bug?"] = true
L["Support the Project"] = true
L["MerathilisUI is free and I work on it in my spare time. If you enjoy it, you can support its development here."] = true
L["Monthly support"] = true
L["Monthly or one-time"] = true
L["Buy me a coffee"] = true
L["One-time donation"] = true
L["Thank You!"] = true
L["Patrons"] = true
L["Home of ElvUI"] = true
L["ElvUI support and community"] = true

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
L["Fade In Content"] = true
L["Fades the info blocks in one after the other when the game menu opens."] = true
L["Show Great Vault"] = true
L["Shows your Great Vault progress for raids, dungeons and the world."] = true
L["Show Clock"] = true
L["Shows the time, the date and the time until the weekly reset."] = true
L["Weekly reset in %s"] = true
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
L["Auction Enhanced"] = true
L["Show the tertiary stats of equipments in auction house."] = true
L["Hide In Combat"] = "전투시 숨김"
L["Toggle"] = "표시 전환"

-- Nameplates
L["NamePlates"] = "이름표"

-- Notification
L["Notification"] = "알림 표시"
L["Bags Full"] = "가방 꽉 참"
L["This is an example of a notification."] = "이것은 알림의 예시입니다"
L["Test Notification"] = true
L["Sends an example toast notification."] = true
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
L["Your Great Vault has rewards ready to claim!"] = true
L["Currency Cap Warning"] = true
L["Track any currency by ID and get a toast once it nears its weekly or total cap."] = true
L["Warn at (%)"] = true
L["Currency ID"] = true
L["Enter a currency ID and press Enter to add it."] = true
L["Currency List"] = true
L["Tracked Currencies"] = true
L["Unknown or undiscovered currency ID."] = true
L["You are close to the cap: %d / %d"] = true
L["Title Font"] = "제목 글꼴"
L["Text Font"] = "텍스트 글꼴"
L["Credits"] = "제작자"

-- Actionbars
L["Specialization Bar"] = "전문화 바"
L["Frame Strata"] = "프레임 보임순서"
L["Frame Level"] = "프레임 레벨"

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
L["Shows the item level on the items in the merchant and trade windows."] = true
L["The item level on the equipment flyout, the scrapping machine and in the guild news is part of WindTools (Item > Item Level, Misc)."] = true
L["Settings for the Item Level next to your item slot"] =
	"아이템 슬롯 옆에 표시되는 아이템 레벨 설정"
L["Settings for the custom %s Armory decorative lines."] = true
L["Enable/Disable the Item Level text display"] = "아이템 레벨 텍스트 표시 여부 설정"
L["Toggle sockets & azerite traits"] = "소켓 및 아제라이트 특성 표시 전환"
L["Item Quality Gradient"] = "아이템 품질 그라데이션"
L["Settings for the color coming out of your item slot."] = "아이템 슬롯에서 나오는 색상 설정"
L["Toggling this on enables the Item Quality bars."] = "활성화 시 아이템 품질 막대 표시"
L["Start Alpha"] = "시작 투명도"
L["End Alpha"] = "종료 투명도"
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
L["Total: %d"] = true
L["Search titles..."] = true
L["Earned"] = true
L["Unearned"] = true
L["Replace Blizzard's native Equipment Manager pane with a custom MerathilisUI gear-set panel."] = true
L["Use your class color for the selected/equipped set accents instead of the accent color below."] = true
L["Accent Color"] = true
L["Accent color used for the selected/equipped set highlight, unless Class Color is enabled."] = true
L["Show Backdrop"] = true
L["Show an opaque dark backdrop behind the gear-set panel."] = true
L["Gear Sets"] = true
L["Equip"] = true
L["Save"] = "저장"
L["Saved!"] = true
L["Cancel"] = true
L["Delete equipment set '%s'?"] = true
L["Change Icon"] = true
L["Assign to Spec"] = true
L["Unassigned"] = true
L["+ New Set"] = true

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
L["Step %d of %d"] = true
L["Welcome"] = true
L["Welcome to %s"] = true
L["This installer sets up MerathilisUI in a few steps. Everything can be changed later in the options."] = true
L["Version %s for ElvUI %s"] = true
L["Import Existing"] = true
L["Import Existing takes over the MerathilisUI profile %s and the settings of %s, for example from your main character."] = true
L["Use the MerathilisUI profile %s (layout %s) and the settings of %s for this character? The UI reloads afterwards."] = true
L["Skip"] = true
L["Closes the installer without changing anything. It does not open again by itself, run it anytime with /mer install."] = true
L["Recommended"] = true
L["MerathilisUI changes a lot of ElvUI settings. A new profile keeps your current one untouched, so you can switch back anytime."] = true
L["Creates a fresh profile for this character and installs MerathilisUI into it."] = true
L["Use Current Profile"] = true
L["Installs MerathilisUI into %s. Your changes in this profile get overwritten."] = true
L["Name for the new profile"] = true
L["A profile with that name already exists."] = true
L["Choose how big the interface is. Auto Scale picks the pixel perfect size for your resolution."] = true
L["Pixel perfect for %s"] = true
L["More room on the screen"] = true
L["A balanced size"] = true
L["Easier to read"] = true
L["Applies the complete MerathilisUI layout: general look, chat, datatexts, action bars, nameplates and unit frames. Pick the unit frame style you like."] = true
L["Class colored health bars with a soft gradient."] = true
L["Dark health bars with the class color on their backdrop."] = true
L["Recommended game settings (CVars)"] = true
L["Changes a few World of Warcraft settings, for example the camera distance, nameplates and chat. They are tailored to the author of MerathilisUI and not needed for the layout."] = true
L["Overwrites the layout settings of the current profile."] = true
L["Installing ..."] = true
L["Enable All"] = true
L["Disable All"] = true
L["%d of %d enabled"] = true
L["Shows a styled bar for vehicles and skyriding, with vigor and speed."] = true
L["Shows toasts for new mail, invites, guild events, the Great Vault and more."] = true
L["Shows the name, guild and level of the unit under your mouse right next to the cursor."] = true
L["Blizzard's Edit Mode places a few frames ElvUI does not move. Import the MerathilisUI Edit Mode layout in two steps."] = true
L["Copy the Layout String"] = true
L["Opens a window with the string. Select it with CTRL+A and copy it with CTRL+C."] = true
L["Pick Import in the layout dropdown, paste the string with CTRL+V, give it a name and click Import."] = true
L["String copied"] = true
L["AddOn Profiles"] = true
L["MerathilisUI brings matching profiles for these AddOns. Click an AddOn to apply its profile."] = true
L["Click to apply the profile"] = true
L["Profile applied"] = true
L["%d applied"] = true
L["Settings only the developer of MerathilisUI uses."] = true
L["UI scale, chat bubbles, ElvUI user tags and a few module settings."] = true
L["Applied"] = true
L["Summary"] = true
L["Skipped"] = true
L["Finish & Reload"] = true
L["ActionBars"] = "행동단축바"


L["DataTexts"] = "정보문자"
L["EditMode"] = true

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] =
	"현재 사용 중인 ElvUI 버전이 |cffff7d0aMerathilisUI|r에서 권장하는 버전보다 낮습니다. 현재 버전: |cff00c0fa%.2f|r (권장 버전: |cff00c0fa%.2f|r). MerathilisUI가 로드되지 않았습니다. ElvUI를 업데이트해주세요."
L["MSG_MER_ELV_MISMATCH"] =
	"현재 ElvUI 버전이 예상보다 높습니다. MerathilisUI를 업데이트하지 않으면 문제가 발생하거나 |cffFF0000이미 문제가 발생했을 수 있습니다|r."

-- Skins
L["MER_ADDONSKINS_DESC"] = [[이 섹션은 외부 애드온의 외형을 수정하기 위한 설정입니다.

참고: 해당 애드온이 애드온 제어 패널에서 로드되지 않은 경우, 일부 옵션은 |cff636363비활성화|r됩니다.]]
L["Screen Shadow Overlay"] = "화면 그림자 오버레이"
L["Restyles the Blizzard frames and the supported AddOns in the MerathilisUI look."] = true
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
L["Window %d"] = true
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
L["LootSpecManager"] = "Loot Spec Manager"
L["LootSpecManagerTips"] = "|nBase on LootSpecManager, auto change your loot spec between bosses, support Raid and M+."
L["LootSpecManagerRaidStart"] = "Boss pulled. Spec changed."
L["LootSpecManagerM+Start"] = "M+ started, loot spec changed."

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
L["Changes are only applied to the ElvUI profile after clicking Apply."] = true
L["Main Font"] = true
L["Number Font"] = true
L["Font Size Offset"] = true
L["Added to every font size the profile sets."] = true
L["Default keeps the outline each element uses in the profile."] = true

-- Advanced Settings
L["Advanced Settings"] = "고급 설정"
L["The message will be shown in chat when you login."] = "로그인 시 채팅창에 메시지가 표시됩���다"
L["This section will help reset specfic settings back to default."] =
	"이 섹션에서는 특정 설정을 기본값으로 초기화할 수 있습니다"

-- Gradient colors
L["Theme"] = true
L["Warning: Enabling one of these settings may overwrite colors or textures in ElvUI, they also prevent you from changing certain settings in ElvUI!"] =
	true
L["Toggling this on enables fancy gradients for "] = true
L["Warning: Enabling this setting will overwrite textures in ElvUI!"] = true
L[" Gradient theme "] = true
L[" from one color to another. You can change the "] = true
L[" below.\n\n"] = true
L["Class Colors"] = true
L["NPC Colors"] = true
L["Here you can change the "] = true
L["Power Colors"] = true
L["Non-interruptible"] = true
L["Regular"] = true
L["Here you can change additional settings for the %s."] = true
L[" of NPC colors.\n\n"] = true
L[" of Power colors.\n\n"] = true
L["Other Colors"] = true
L["State Colors"] = true
L[" of State colors.\n\n"] = true
L["Castbar Colors"] = true
L[" of Castbar colors.\n\n"] = true
L["Fade Direction"] = true
L["Player & Target"] = true
L["Control the gradient fade direction for player and target unitframes.\n\n"] = true
L["Group Frames"] = true
L["Control the gradient fade direction for party and raid unitframes.\n\n"] = true
L["Boss & Arena"] = true
L["Control the gradient fade direction for boss and arena unitframes.\n\n"] = true
L["Role Frames"] = true
L["Control the gradient fade direction for tank and assist unitframes.\n\n"] = true
L["UnitFrame Textures"] = true
L["Change the textures used for UnitFrame's Health, Power and Cast status bars."] = true
L["Health Texture"] = true
L["Health bar texture for UnitFrames"] = true
L["Power Texture"] = true
L["Power bar texture for UnitFrames"] = true
L["Castbar Texture"] = true
L["Castbar texture for UnitFrames"] = true
L["Background Brightness"] = true
L["This controls the strength of the background colors.\n\nLower value means a darker background, higher value means a lighter background.\n\n"] =
	true
L["Warning: Setting this too high may cause readability issues!"] = true
L["Saturation Boost"] = true
L["Boosts the saturation and darkens "] = true
L[" Colors|r\nFor people that like it a bit more extreme\n\n"] = true
L["Shift Lightness"] = true
L["Control the Lightness value of HSL for the Shift color."] = true
L["Shift Saturation"] = true
L["Control the Saturation value of HSL for the Shift color."] = true
L["Normal Lightness"] = true
L["Control the Lightness value of HSL for the Normal color."] = true
L["Normal Saturation"] = true
L["Control the Saturation value of HSL for the Normal color."] = true

-- Addons
L["Skins/AddOns"] = "스킨/애드온"
L["Profiles"] = "프로필"
L["BigWigs"] = "BigWigs"
L["Create and apply the profile"] = true
L["AddOn is not enabled"] = true
L["This will create and apply profile for "] =
	"이 설정은 다음 애드온에 대한 프로필을 생성하고 적용합니다: "

-- Changelog
L["Changelog"] = "변경 사항"
L["What's New in %s"] = true
L["Full Changelog"] = true
L["In Development"] = true
L["Did you know?"] = true
L["Go to Option"] = true
L["Type /mer status to open the Status Report. Post it when you report a bug."] = true
L["/muidebug on turns off all other addons except ElvUI, WindTools, MerathilisUI and BugSack. /muidebug off turns them back on."] = true
L["Type /mer changelog to read what changed in every version."] = true
L["Movement Alert shows the cooldown of your movement spells while they are not ready."] = true
L["The Tracker shows your group's battle res charges in Mythic+ keys and raid boss encounters."] = true
L["Cursor puts a colored ring around your mouse cursor, optionally with a GCD and cast ring."] = true
L["The Chat Sidebar gives quick access to friends, guild, copy chat and M+ portals."] = true
L["Loot Roll replaces the roll frames with a movable bar. Its Test button shows a preview."] = true
L["Buff Reminder shows icons for the raid buffs you are missing."] = true
L["HoverCast casts your spells on the unit frame or unit under your mouse and replaces Clique."] = true
L["HoverCast's Quickbind binds a spell in one step: hover it and press a key or click."] = true
L["Singing Sockets adds a selection tool to the socketing frame."] = true
L["The Game Menu can show random battle pets."] = true
L["Type /mer install to run the installer again, e.g. to reapply the MerathilisUI profile."] = true
L["Type /mlr to preview the Loot Roll bar with test rolls."] = true
L["Type /lsm to open the LootSpecManager. It switches your loot spec per boss in raids and Mythic+."] = true
L["Interrupt Ready colors enemy castbars while your interrupt is on cooldown and marks when it is ready again."] = true
L["In Mythic+, the nameplates can show how much Enemy Forces each enemy is worth."] = true
L["Cast on You marks the castbar of enemies whose cast targets you."] = true
L["Categorized Bags sorts your bags into groups like equipment, consumables and quest items."] = true
L["The Armory warns you about missing enchants and sockets on your gear."] = true
L["Mail adds checkboxes to open or delete several mails at once and saves recipient lists."] = true
L["Right-click the Durability/Ilevel datatext to summon your repair mount."] = true
L["The Minimap Buttons bar adds a Great Vault button and your M+ portals next to the Minimap."] = true
L["Addon Buttons on the Minimap Buttons bar collects the minimap buttons of your addons into one grid."] = true
L["Want an addon button to stay on the Minimap? Add its name to the Ignored Buttons of Addon Buttons."] = true
L["The Location Panel above the Minimap can show your coordinates. Left-click it to open the World Map, right-click to link your location in chat."] = true
L["The Specialization Bar switches your spec with a left click and your loot spec with a right click."] = true
L["Auras can add a collapse button to your buffs that hides long-lasting ones until they are about to expire."] = true
L["Item Level shows the item level on items in the merchant and trade windows."] = true
L["The Raid Info Frame lists the players in your raid by role."] = true
L["MerathilisUI adds extra oUF tags you can use in the UnitFrames options."] = true

-- Compatibility

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
L["If you get an error, open the Status Report with %s, click %s and paste the text into your report."] = true
L["Error"] = "오류"
L["Warning"] = "경고"

-- Abbreviate

-- AUTO-ADDED PLACEHOLDERS START (do not remove without review)
-- AUTO-PLACEHOLDER
-- AUTO-ADDED PLACEHOLDERS END

-- Additional locale entries for consistency
L["AddOnSkins"] = true
L["Default"] = true
L["Level"] = "레벨"

-- Automatically added missing keys
L[" Raid Info Frame"] = " Raid Info Frame"
L["%day%-%month%-%year%"] = "%day%-%month%-%year%"
L[".\n\n"] = ".\n\n"
L["Abbreviates the enchant strings."] = "Abbreviates the enchant strings."
L["Add"] = "추가"
L["Add %d socket"] = "Add %d socket"
L["Addon Skins"] = "Addon Skins"
L["Addons"] = "Addons"
L["Adds a button to the character and inspect frame that allows you to copy a list of the currently transmogrified items."] =
	"Adds a button to the character and inspect frame that allows you to copy a list of the currently transmogrified items."
L["Anchor Point"] = "기준점"
L["Are you sure you want to import this string?"] = "Are you sure you want to import this string?"
L["Arena"] = "투기장"
L["Assist"] = "지원 공격"
L["Assist Target"] = "Assist Target"
L["Auto Copy Private Profile"] = "Auto Copy Private Profile"
L["Auto Scale"] = "UI 자동조절"
L["Automatically copy the selected private profile to a new character on first login."] =
	"Automatically copy the selected private profile to a new character on first login."
L["BACKGROUND"] = "BACKGROUND"
L["BagSync"] = "BagSync"
L["Bags"] = "가방"
L["Bar Height"] = "Bar Height"
L["Bar Settings"] = "행동단축바 설정"
L["BigWigs is not installed or enabled."] = "BigWigs is not installed or enabled."
L["Blacklist"] = "블랙리스트"
L["Blizzard"] = "블리자드"
L["Blizzard DamageMeter"] = "Blizzard DamageMeter"
L["Blizzard Inspect Button Fallback"] = "Blizzard Inspect Button Fallback"
L["Blizzard Tool Tip"] = "Blizzard Tool Tip"
L["Blizzard ToolTip Options"] = "Blizzard ToolTip Options"
L["Boss"] = "보스(Boss)"
L["Button Size"] = "버튼 크기"
L["Button Width"] = "버튼 너비"
L["Buttons"] = "버튼 수"
L["Capping"] = "Capping"
L["Change the Skyriding Bar's height."] = "Change the Skyriding Bar's height."
L["Changelog Popup"] = "Changelog Popup"
L["Character"] = "Character"
L["Chat"] = "채팅창"
L["Check the setting of ElvUI Private database in ElvUI Options -> Profiles -> Private (tab)."] =
	"Check the setting of ElvUI Private database in ElvUI Options -> Profiles -> Private (tab)."
L["Class Codex"] = true
L["Class Color"] = "직업 색상"
L["Classification"] = "분류"
L["Clear Initialized Characters"] = "Clear Initialized Characters"
L["Clear the record of initialized characters, allowing the profile to be copied again on next login."] =
	"Clear the record of initialized characters, allowing the profile to be copied again on next login."
L["Clique"] = "Clique"
L["Collections"] = "Collections"
L["Color"] = "Color"
L["Color Modifier Keys"] = "Color Modifier Keys"
L["Color Settings"] = "Color Settings"
L["Cooldown Manager"] = "재사용 대기시간 관리자"
L["Tooltip"] = "툴팁"
L["Copy From"] = "복사해오기"
L["Copy Transmog"] = "Copy Transmog"
L["Could not add the texture."] = "Could not add the texture."
L["Could not convert unicode "] = "Could not convert unicode "
L["Credits: ElvUI_ToxiUI"] = "Credits: ElvUI_ToxiUI"
L["Crit"] = "Crit"
L["Custom"] = "Custom"
L["Dark Layout"] = "Dark Layout"
L["Dark Texture"] = "Dark Texture"
L["Decorative Lines"] = "Decorative Lines"
L["Delete"] = "삭제"
L["Details"] = "Details"
L["Details Skin"] = "Details Skin"
L["Developer Settings"] = "Developer Settings"
L["Developer Settings Done"] = "Developer Settings Done"
L["Disable NameHover inside dungeons, raids and scenarios.\nIf disabled, NameHover will replace the Blizzard tooltip instead."] =
	"Disable NameHover inside dungeons, raids and scenarios.\nIf disabled, NameHover will replace the Blizzard tooltip instead."
L["Disable in Dungeons/Raids"] = "Disable in Dungeons/Raids"
L["Durability/ Ilevel"] = "Durability/ Ilevel"
L["ElvUI"] = "ElvUI"
L["Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."] =
	"Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."
L["Enabling this colors your modifier keys."] = "Enabling this colors your modifier keys."
L["Encounter Journal"] = "Encounter Journal"
L["Enter Edit Mode"] = "Enter Edit Mode"
L["Equipment Manager"] = "Equipment Manager"
L["Middle Click:"] = true
L["Pick up / move item"] = true
L["Pin / unpin item"] = true
L["Shift + Middle Click:"] = true
L["Shift + Click:"] = true
L["Split Stack"] = true
L["Ctrl + Right Click:"] = true
L["Move to Bank Tab / Bag"] = true
L["Bag"] = true
L["Bank / Warband Bank (while open)"] = true
L["Vendor (while open)"] = true
L["Deposit / withdraw item"] = true
L["Sell item"] = true
L["Use / equip item"] = true
L["Add Category"] = true
L["Alternating Row Background"] = true
L["Shades every second sidebar category row, same as the Armory panel's alternating stat rows."] = true
L["Armor"] = true
L["Assign to Category"] = true
L["Categorized Bags"] = true
L["Category Header Height"] = true
L["Clear Assignment"] = true
L["Enter a spell/item/currency ID, or a texture path/ID, for the category icon:"] = true
L["Enter a new name:"] = true
L["Hide Empty Categories"] = true
L["Item Count"] = "아이템 갯수 표시"
L["Item Info"] = "이이템 정보"
L["Item Size"] = true
L["Shows a bind-type indicator (BoE, BoU, ...) on items that aren't bound yet."] = true
L["BoP"] = "획득 귀속"
L["BoE"] = "착귀"
L["BoU"] = "사용 귀속"
L["BoA"] = true
L["Backpack"] = true
L["Bag %d"] = "가방 %d"
L["All Items"] = true
L["OneBag"] = true
L["MultiBag"] = true
L["Inventory"] = true
L["Categories"] = true
L["Equipment"] = true
L["Ungroup %s"] = true
L["Disband Group"] = "그룹 해산"
L["Create Group With"] = true
L["Add to Group"] = true
L["Group"] = true
L["Restores any category group (e.g. \"Equipment\") you disbanded or removed a category from, removes the groups you created yourself and clears any group renames."] = true
L["Hide in All Items"] = true
L["Show in All Items"] = true
L["Reset Currency Order"] = true
L["Puts the tracked currencies in the footer back into Blizzard's own order. Drag one currency onto another in the footer to reorder them."] = true
L["Reset Category Groups"] = true
L["Restores any category group (e.g. \"The Armory\") you disbanded or removed a category from, and clears any group renames."] = true
L["Toggle Bag Bar"] = true
L["Warband Bank"] = true
L["Bank"] = "은행"
L["All Bank Tabs"] = true
L["All Warband Tabs"] = true
L["OneBank"] = true
L["OneWarband"] = true
L["Deposit Reagents"] = true
L["Deposit Warbound Items"] = true
L["Withdraw"] = true
L["Deposit"] = true
L["Bank Window"] = true
L["Bag Window"] = true
L["Sizes"] = true
L["Click to filter by this tab"] = true
L["Click to clear the filter"] = true
L["Purchase Bank Tab"] = true
L["Click to purchase"] = true
L["Cost"] = true
L["Locked"] = true
L["Purchase the previous tab first."] = true
L["Move to Bank Tab"] = true
L["Move to Warband Tab"] = true
L["Move to Bag"] = true
L["No free slot available."] = true
L["Ctrl+Right-click to move to a specific tab/bag"] = true
L["Items"] = "아이템"
L["Collapse Sidebar"] = true
L["Expand Sidebar"] = true
L["New Custom Category"] = true
L["Icon:"] = true
L["Custom Icon ID:"] = true
L["Create"] = true
L["Position"] = "위치"
L["Item Spacing (Horizontal)"] = true
L["Item Spacing (Vertical)"] = true
L["Miscellaneous"] = "잡다한"
L["No gray items to sell."] = true
L["Pinned Items"] = true
L["Quest Items"] = true
L["Reagent Bag"] = true
L["Recent Items"] = true
L["Group by Expansion"] = true
L["Splits categories like Consumables or Trade Goods into sub-headers per expansion, newest first."] = true
L["Group by Equipment Set"] = true
L["Splits the gear categories into sub-headers per Blizzard equipment set."] = true
L["Auto Height"] = true
L["Shrinks the bag and bank windows to fit their contents. The configured height becomes the maximum instead of a fixed size."] = true
L["Merge Duplicate Stacks"] = true
L["Shows identical items from several bag slots as one slot with the combined count. Gear is never merged, and merging pauses while a vendor, mailbox, trade, auction house or bank window is open, since those only ever take one stack at a time."] = true
L["Clear Recent on Close"] = true
L["Empties the Recent Items list whenever you close the bags, instead of keeping it until you clear it yourself."] = true
L["Recent Items Limit"] = true
L["How many items the Recent Items list keeps at most; the oldest drops out first."] = true
L["Item Set Gear"] = true
L["Gear Enhancements"] = true
L["Professions"] = "전문 기술"
L["Housing"] = true
L["Rename"] = true
L["Reset Item Order"] = true
L["Alt + Drag:"] = true
L["Alt+Drag onto another item to move it there. Items stay in their bag slots."] = true
L["Changes the display order only - nothing moves in your bags."] = true
L["Reorder items inside a category"] = true
L["Reset Name"] = true
L["Replaces ElvUI's bag frame with a category-sidebar view (Pinned/Recent items, custom categories). Requires a UI reload to take effect."] = true
L["Show Pinned Items"] = true
L["Show Recent Items"] = true
L["Sidebar Row Height"] = true
L["Sidebar Width"] = true
L["Sort Bags"] = "가방 정리"
L["Sort"] = true
L["Sort, don't ask again"] = true
L["Sort the %s? Items are moved between its tabs."] = true
L["Sort Bank"] = true
L["Sort Warband Bank"] = true
L["No bank tabs purchased yet."] = true
L["Sort Spinner"] = true
L["Same spinner ElvUI's own bag frame shows while sorting."] = true
L["Drag an item here to pin it."] = true
L["Drag an item here to assign it to %s."] = true
L["No items found."] = true
L["Effects"] = true
L["Fade Windows"] = true
L["Fades the bag and bank windows in when opened and out when closed."] = true
L["Fade Duration"] = "반투명 대기시간"
L["New Item Glow"] = "새로운 아이템 발광"
L["Pulsing glow on newly picked-up items."] = true
L["Empty Slot Opacity"] = true
L["Opacity of the empty drop-target slots at the end of each category (the first \"+\" slot always stays fully visible)."] = true
L["Tints the item slot hover highlight in your class color."] = true
L["Hover Color"] = true
L["WuE"] = true
L["Warbound Marker"] = true
L["Shows a small Warband icon on items that are Warbound or Warbound until equipped."] = true
L["Custom Window Opacity"] = true
L["Overrides ElvUI's transparent backdrop opacity for the bag and bank windows."] = true
L["Window Opacity"] = true
L["Category Headers"] = true
L["Sub-Headers"] = true
L["New Item Badge"] = true
L["Shows a small NEW badge on newly picked-up items, in addition to the glow."] = true
L["Highlight Drop Targets"] = true
L["Lights up the empty slots at the end of each category while an item is on the cursor, so it's clear where it can be dropped to assign it."] = true
L["Dim Unusable Items"] = true
L["While a spell or window waits for an item (Disenchant, Milling, Prospecting, enchant scrolls, the scrapper...), darkens every item it can't be used on."] = true
L["Desaturate Junk"] = "잡탬 흑백처리"
L["Greys out grey-quality items, in addition to the coin icon they already get."] = true
L["Pinned Marker"] = true
L["Shows a small pin icon on pinned items, also in their normal category."] = true
L["Sub-Header Icons"] = true
L["Shows the expansion logo or equipment set icon in front of the sub-headers."] = true
L["Takes effect once the item is in your bags."] = true
L["%d results"] = true
L["Fill Level"] = true
L["%d of %d slots used (%d%%)"] = true
L["%d free"] = true
L["Class color; turns yellow at 80% and red at 95%."] = true
L["Spacing Between Categories"] = true
L["Stack Items In Bags"] = "가방 안 아이템 겹치기"
L["Stack Items In Bank"] = "은행 안 아이템 겹치기"
L["Hold Shift:"] = "Shift:"
L["Stack Items To Bank"] = "은행으로 아이템 겹치기"
L["Stack Items To Bags"] = "가방으로 아이템 겹치기"
L["Only available for the character bank."] = true
L["Trade Goods"] = true
L["Vendor Grays"] = "잡동사니 자동 판매"
L["Vendored gray items for: %s"] = "모든 잡동사니를 팔았습니다: %s"
L["Weapons & Trinkets"] = true
L["You must be at a vendor."] = "상인을 만나야 가능합니다."
L["You must be at the bank."] = true
L["Export All"] = "Export All"
L["Export Private"] = "Export Private"
L["Export Profile"] = "프로필 내보내기"
L["Export all setting of %s."] = "Export all setting of %s."
L["Export the setting of %s that stored in ElvUI Private database."] =
	"Export the setting of %s that stored in ElvUI Private database."
L["Export the setting of %s that stored in ElvUI Profile database."] =
	"Export the setting of %s that stored in ElvUI Profile database."
L["Faction"] = "Faction"
L["Fixes"] = "Fixes"
L["Focus"] = "주시"
L["Friends"] = "친구"
L["GlobalIgnoreList"] = "GlobalIgnoreList"
L["Gradient"] = "Gradient"
L["Gradient Layout"] = "Gradient Layout"
L["Gradient Name"] = "Gradient Name"
L["Guild Name"] = "Guild Name"
L["Guild Rank"] = "Guild Rank"
L["Guild Text Outline"] = "Guild Text Outline"
L["Guild Text Size"] = "Guild Text Size"
L["HIGH"] = "HIGH"
L["Haste"] = "Haste"
L["Header"] = "Header"
L["Header Text Outline"] = "Header Text Outline"
L["Header Text Size"] = "Header Text Size"
L["Hides the frame while in combat."] = "Hides the frame while in combat."
L["How long a vignette of the same time should not be notified. In seconds"] =
	"How long a vignette of the same time should not be notified. In seconds"
L["How often the speed text is updated."] = "How often the speed text is updated."
L["I got it!"] = "I got it!"
L["I want to sync setting of MerathilisUI!"] = "I want to sync setting of MerathilisUI!"
L["Icon"] = "아이콘 표시"
L["Icon Search"] = true
L["Enter a spell ID or item ID to find its icon."] = true
L["If you simply want to share the same private settings across all characters, it is recommended to set the same private profile for them in ElvUI > Profiles > Private."] =
	"If you simply want to share the same private settings across all characters, it is recommended to set the same private profile for them in ElvUI > Profiles > Private."
L["Import"] = "입력"
L["Import and export your %s settings."] = "Import and export your %s settings."
L["Improvements"] = "Improvements"
L["Install"] = "설치"
L["Installation Complete"] = "설치 완료"
L["It will override your %s setting."] = "It will override your %s setting."
L["Item Level Font"] = "Item Level Font"
L["KeystoneLoot"] = "KeystoneLoot"
L["LEFT"] = "왼쪽"
L["LOW"] = "LOW"
L["Large"] = "크게"
L["Latest runs"] = "Latest runs"
L["Layout"] = "레이아웃"
L["Layout Set"] = "레이아웃 설정"
L["Left Click:"] = "왼 클릭 :"
L["Localization"] = "Localization"
L["MEDIUM"] = "MEDIUM"
L["Main Text Outline"] = "Main Text Outline"
L["Main Text Size"] = "Main Text Size"
L["Many thanks to these wonderful persons for letting me use some of their code: %s."] =
	"Many thanks to these wonderful persons for letting me use some of their code: %s."
L["Maps"] = "지도"
L["Mark as read, the changelog message will be hidden when you login next time."] =
	"Mark as read, the changelog message will be hidden when you login next time."
L["Mastery"] = "Mastery"
L["Medium"] = "중간"
L["MerathilisUI saves all data in ElvUI Profile and Private database."] =
	"MerathilisUI saves all data in ElvUI Profile and Private database."
L["Mouse Over"] = "Mouse Over"
L["Mouseover"] = "마우스오버 시 표시"
L["N/A"] = "N/A"
L["New"] = "New"
L["New Profile"] = "새로운 프로필"
L["Next Time"] = "Next Time"
L["No Guild"] = "길드 없음"
L["Normal Texture"] = "Normal Texture"
L["Not Installed"] = "Not Installed"
L["Not Set"] = "Not Set"
L["Note: This feature only copies the private profile once per character. It does not synchronize settings afterwards."] =
	"Note: This feature only copies the private profile once per character. It does not synchronize settings afterwards."
L["Offset Y"] = "Offset Y"
L["Ok"] = "Ok"
L["Open Changelog"] = "Open Changelog"
L["Open Character Frame"] = "Open Character Frame"
L["Other"] = "Other"
L["Pawn"] = "Pawn"
L["Pet"] = "펫(소환수)"
L["Player"] = "플레이어"
L["Interface"] = true
L["Combat"] = "전투"
L["Quality of Life"] = true
L["Choose the modules you want to use. Changes are applied on the reload at the end of the installer and can be changed anytime in the options."] = true
L["Features, the full changelog and downloads can be found on the website %s."] = true
L["Please set the ID first."] = "Please set the ID first."
L["Profession"] = "Profession"
L["Profile"] = "프로필"
L["Profile Created"] = "Profile Created"
L["Quest"] = "Quest"
L["RIGHT"] = "오른쪽"
L["Race"] = "Race"
L["Raid 1"] = "Raid 1"
L["Raid 2"] = "Raid 2"
L["Raid 3"] = "Raid 3"
L["Released"] = "Released"
L["Reset"] = "새로고침"
L["Reset Details check"] = "Reset Details check"
L["Right Click:"] = "Right Click:"
L["Run the installation process."] = "ElvUI의 설치 프로세스를 실행합니다."
L["Scale"] = "크기"
L["Scale other frames.\n\n"] = "Scale other frames.\n\n"
L["Settings for the Action Bar Buttons of the Vehicle Bar.\n\n"] =
	"Settings for the Action Bar Buttons of the Vehicle Bar.\n\n"
L["Setup Developer Settings"] = "Setup Developer Settings"
L["Sharing ElvUI Profile is a very common thing nowadays, but actually ElvUI Private database is also exist for saving configuration of General, Skins, etc."] =
	"Sharing ElvUI Profile is a very common thing nowadays, but actually ElvUI Private database is also exist for saving configuration of General, Skins, etc."
L["Shield"] = "Shield"
L["Shorten and abbreviate attribute labels."] = "Shorten and abbreviate attribute labels."
L["Show Blizzard unit tooltip alongside NameHover. If disabled, you can use keybind to quickly switch between NameHover and Blizzard"] =
	"Show Blizzard unit tooltip alongside NameHover. If disabled, you can use keybind to quickly switch between NameHover and Blizzard"
L["Show Collections"] = "Show Collections"
L["Show Illusion"] = "Show Illusion"
L["Show Keybinds"] = "Show Keybinds"
L["Show Macro Text"] = "Show Macro Text"
L["Show Speed Text"] = "Show Speed Text"
L["Show Target of Target"] = "Show Target of Target"
L["Show the changelog popup rather than chat message after every update."] =
	"Show the changelog popup rather than chat message after every update."
L["Show the illusion of the item in the list."] = "Show the illusion of the item in the list."
L["Show/Hide Visual"] = "Show/Hide Visual"
L["Shows a warning when you're missing an enchant."] = "Shows a warning when you're missing an enchant."
L["Shows a warning when you're missing sockets on your necklace."] =
	"Shows a warning when you're missing sockets on your necklace."
L["Shows random battle pets"] = "Shows random battle pets"
L["Small"] = "작은"
L["So if you set ElvUI Profile and Private these |cffff0000TWO|r databases to the same across multiple character, the setting of MerathilisUI will be synced."] =
	"So if you set ElvUI Profile and Private these |cffff0000TWO|r databases to the same across multiple character, the setting of MerathilisUI will be synced."
L["Sockets"] = "Sockets"
L["Sockets can be added with "] = "Sockets can be added with "
L["Spacing"] = "간격"
L["Spec Icon"] = "특성 아이콘"
L["SpecializationBarMover"] = "SpecializationBarMover"
L["Speed Text Settings"] = "Speed Text Settings"
L["Status"] = "상태창"
L["Status Text Outline"] = "Status Text Outline"
L["Status Text Size"] = "Status Text Size"
L["String"] = "String"
L["Sub Text Outline"] = "Sub Text Outline"
L["Sub Text Size"] = "Sub Text Size"
L["Tank"] = "탱커"
L["Tank Target"] = "Tank Target"
L["Target"] = "대상"
L["Target of Target"] = "Target of Target"
L["Text Options"] = "글자 옵션"
L["The profile from which the private settings will be copied."] =
	"The profile from which the private settings will be copied."
L["The style already exists."] = "The style already exists."
L["The texture coordinates must be passed as a table."] = "The texture coordinates must be passed as a table."
L["This is useful when you have multiple characters but want to use a specific private profile as the starting point for new ones."] =
	"This is useful when you have multiple characters but want to use a specific private profile as the starting point for new ones."
L["Time Out"] = "Time Out"
L["Tips"] = "Tips"
L["Toggle whether to show keybinds of an action bar button on the Vehicle Bar."] =
	"Toggle whether to show keybinds of an action bar button on the Vehicle Bar."
L["Toggle whether to show macro text of an action bar button on the Vehicle Bar."] =
	"Toggle whether to show macro text of an action bar button on the Vehicle Bar."
L["Toggles the blue bars behind every second number."] = "Toggles the blue bars behind every second number."
L["Transmog Text Frame"] = "Transmog Text Frame"
L["Tukui Discord Server"] = "Tukui Discord Server"
L["UI Scale"] = "UI 크기"
L["Unknown"] = "Unknown"
L["Update"] = "Update"
L["Update Database"] = "Update Database"
L["Update Rate"] = "Update Rate"
L["Use Custom Color"] = "Use Custom Color"
L["Use class color for the enchant strings."] = "Use class color for the enchant strings."
L["Use the WoW Key Bindings menu for the custom Hold to show bind. This modifier remains available for these hotkeys"] =
	"Use the WoW Key Bindings menu for the custom Hold to show bind. This modifier remains available for these hotkeys"
L["Value Color"] = "Value Color"
L["Versa"] = "Versa"
L["Version"] = "버전"
L["Vignette"] = "Vignette"
L["Vignette ID"] = "Vignette ID"
L["Vigor Bar"] = "Vigor Bar"
L["Vigor bar texture for Dark Mode."] = "Vigor bar texture for Dark Mode."
L["Vigor bar texture for Normal and Gradient Mode"] = "Vigor bar texture for Normal and Gradient Mode"
L["WIM"] = "WIM"
L["Weekly Delves Keys"] = "Weekly Delves Keys"
L["Weekly Rewards"] = "주간 보상"
L["Welcome to %s %s!"] = "Welcome to %s %s!"
L["Welcome to version %s!"] = "Welcome to version %s!"
L["WowLua"] = "WowLua"
L["You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"] =
	"You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"
L["You have %s pending calendar |4invite:invites;."] = "You have %s pending calendar |4invite:invites;."
L["You have %s pending guild |4event:events;."] = "You have %s pending guild |4event:events;."
L["is looking for members"] = "구성원 찾는 중"
L["joined a group"] = "그룹에 참가"
L["ls_Toasts"] = "ls_Toasts"
L["ncHoverName by Nightcracker"] = "ncHoverName by Nightcracker"
--

-- Buff Reminder
L["Buff Reminder"] = true
L["Raid Buffs"] = true
L["Consumables"] = true
L["Flask"] = true
L["Food"] = true
L["Rune"] = true
L["Main Hand"] = true
L["Off Hand"] = true
L["Mark of the Wild"] = true
L["Battle Shout"] = true
L["Power Word: Fortitude"] = true
L["Arcane Intellect"] = true
L["Blessing of the Bronze"] = true
L["Skyfury"] = true
L["Symbiotic Relationship"] = true
L["Battle Stance"] = true
L["Berserker Stance"] = true
L["Defensive Stance"] = true
L["Shadowform"] = true
L["Devotion Aura"] = true
L["Augment Rune"] = true
L["Weapon Enchant"] = true
L["Deadly Poison"] = true
L["Instant Poison"] = true
L["Wound Poison"] = true
L["Amplifying Poison"] = true
L["Crippling Poison"] = true
L["Numbing Poison"] = true
L["Atrophic Poison"] = true
L["Rite of Adjuration"] = true
L["Rite of Sanctification"] = true
L["Flametongue Weapon"] = true
L["Windfury Weapon"] = true
L["Earthliving Weapon"] = true
L["Tidecaller's Guard"] = true
L["Thunderstrike Ward"] = true
L["Hide in Open World"] = true
L["Only show reminders inside dungeons, raids and scenarios."] = true
L["Hide while Mounted/Flying"] = true
L["Remind Under (minutes)"] = true
L["Also remind when a tracked consumable buff is about to expire within this many minutes."] = true
L["Icon Spacing"] = true
L["Show Text"] = "주석 표시"
L["Text Size"] = true
L["Text Outline"] = true
L["Show Bag Count"] = true
L["Enable Glow"] = true
L["Glow Color"] = true
L["Sounds"] = true
L["Show Without Item"] = true
L["Keep showing a desaturated reminder icon even when you have none of the item left in your bags."] = true
L["Test"] = true
L["Stop Test"] = true
L["Shows a row of sample icons for 20 seconds so you can check scale, glow, text and position without needing to actually be missing anything in a raid."] =
	true
L["Hide in Combat"] = true
L["When disabled, reminders freeze in place during combat instead of disappearing."] = true

-- Minimap Buttons
L["Minimap Buttons"] = "미니맵 버튼"
L["Add a bar of extra buttons next to your Minimap."] = true
L["Great Vault"] = true
L["M+ Portals"] = true
L["Tracking"] = "추적"
L["Calendar"] = "달력"
L["Mail"] = true
L["Crafting Orders"] = true
L["Elements"] = true
L["A second bar for the Blizzard indicators, anchored on its own."] = true
L["Replaces the Blizzard icon on your Minimap with one in this bar."] = true
L["The tooltip lists your raid lockouts, the realm time and the weekly reset."] = true
L["Only shown while there is something to report."] = true
L["Weekly Reset"] = true
L["Growth Direction"] = "배열 방향"
L["Which way the bar extends as buttons are added."] = true
L["Raids"] = true
L["World"] = true
L["Test Pulse"] = true
L["Briefly plays the Great Vault button's pulse animation, even without any unclaimed rewards."] = true
L["Addon Buttons"] = true
L["Collects the minimap buttons of your addons into a grid that opens from this bar."] = true
L["Switching it off requires a reload."] = true
L["%s already collects your minimap buttons, so this collector stays off."] = true
L["Disable WindTools Minimap Buttons"] = true
L["Buttons Per Row"] = "한 줄당 버튼 수"
L["Ignored Buttons"] = true
L["Names or parts of names of buttons that stay on the Minimap, separated by commas."] = true
L["Requires a reload."] = true
L["Top Left"] = "상단 왼쪽"
L["Top"] = "상단 중앙"
L["Top Right"] = "상단 오른쪽"
L["Left"] = true
L["Right"] = "오른쪽"
L["Bottom Left"] = "하단 왼쪽"
L["Bottom"] = "하단"
L["Bottom Right"] = "하단 오른쪽"
L["Housing Dashboard"] = true

-- Cursor
L["Cursor"] = true
L["Cursor Ring"] = true
L["Cursor Trail"] = true
L["GCD Ring"] = true
L["Cast Ring"] = true
L["Cursor GCD Ring"] = true
L["Cursor Cast Ring"] = true
L["Show a colored ring around your mouse cursor, with an optional trail, GCD ring and cast-time ring."] = true
L["Use Class Color"] = "직업 색상 사용"
L["Radius"] = true
L["Show Center Dot"] = true
L["Show Spark"] = true
L["Attach to Cursor"] = true
L["Only In Instances"] = true
L["Only In Combat"] = true
L["Only While Steering Camera"] = true
L["Only show the ring while you're holding a mouse button to turn or move the camera (the hardware cursor is hidden)."] =
	true

-- Loot Roll
L["Loot Roll"] = "주사위 굴림창"
L["Can't Roll"] = "주사위를 굴릴 수 없습니다."
L["Replaces ElvUI's Need/Greed/Pass loot roll frames with a custom, movable bar."] = true
L["Show/hide a fake roll bar to preview your settings."] = true
L["Grow Direction"] = true
L["Down"] = "아래로"
L["Up"] = "위로"
L["Max Bars"] = "바 최대갯수"
L["Colors"] = "색상"
L["Color Border by Quality"] = true
L["Color Name by Quality"] = true
L["Show Item Level"] = true
L["Color Status Bar by Quality"] = true
L["Custom Status Bar Color"] = true
L["Status Bar Texture"] = true
L["Font Size"] = "글자 크기"
L["Font Outline"] = "글꼴 외곽선"
L["Rollers"] = true
L["Show Rollers in Tooltip"] = true
L["Show who rolled Need/Greed/Disenchant/Pass in the item's tooltip.\n\nNote: on modern retail WoW this can currently only be populated for boss/encounter loot - it stays empty for regular group loot (e.g. trash mobs, world content)."] =
	true
L["Uncommon Test Item"] = true
L["Rare Test Item"] = true
L["Epic Test Item"] = true
L["Legendary Test Item"] = true

-- Auras
L["Collapse & Expand Button"] = true
L["Adds Blizzard's Collapse/Expand arrow button back to ElvUI's Player Buffs. Collapsing shrinks the buffs down to a single row, keeping only the ones about to expire visible while long-lasting buffs are hidden."] =
	true
L["Expand Buffs"] = true
L["Collapse Buffs"] = true

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
L["Chat Sidebar"] = true
L["Adds a slim icon bar inside a chat panel with quick access to friends, guild, copy chat, M+ portals and more."] = true
L["Requires ElvUI's %s module to be enabled."] = true
L["No MerathilisUI profile installed."] = true
L["Not available while EltruismUI is enabled."] = true
L["Not available while BenikUI is enabled."] = true
L["Chat Panel"] = true
L["Side"] = true
L["Which edge of the chat panel the sidebar sits on."] = true
L["Visibility"] = "표시"
L["Always"] = true
L["Divider"] = true
L["Draws a thin line between the sidebar and the chat text."] = true
L["Counter Font Size"] = true
L["Icon Color"] = true
L["Icon Alpha"] = true
L["Hover Class Color"] = true
L["Highlights hovered icons in your class color."] = true
L["Buttons that no longer fit the panel height are left out."] = true
L["Guild"] = "길드"
L["Durability"] = true
L["Copy Chat"] = true
L["Voice / Channels"] = true
L["Settings"] = true
L["Scroll to Bottom"] = true
L["Shows the number of friends online."] = true
L["Shows the number of guild members online."] = true
L["Shows the durability of your most damaged item."] = true
L["Pinned to the bottom of the sidebar, lights up while the chat is scrolled up."] = true
L["Durability Warning"] = true
L["The durability counter turns red at or below this value."] = true
L["World of Warcraft"] = true
L["Online"] = true
L["ElvUI Chat"] = true
L["Chat Menu"] = true
L["Replaces ElvUI's copy button on the chat windows. Right-click opens the chat menu."] = true
L["Inside"] = true
L["Outside"] = true
L["Inside shares the chat panel and moves the chat text aside, outside places the sidebar as its own block next to the panel."] = true
L["Distance"] = true
L["Shift + Drag to reorder"] = true
L["Shift + drag an icon in the sidebar to change the order."] = true
L["Reset Order"] = true
L["Chat Panels"] = "채팅 패널"
L["Lock Chat Size"] = true
L["Hides the resize grip that shows in the corner of a chat panel while hovering it."] = true
L["Drag to resize the chat panel"] = true
L["Combat Log Filters"] = true
L["Colors the active combat log filter in your class color and dims the others."] = true
L["Edit Box"] = true
L["Restyles the chat input box."] = true
L["MerathilisUI Style"] = true
L["Transparent backdrop with the MerathilisUI stripes and gradient."] = true
L["Chat Type Accent"] = true
L["A neutral border with a small bar in the color of the current chat type, instead of coloring the whole border."] = true
L["Header Badge"] = true
L["Shows the chat type prefix (Say, Guild, Whisper to ...) as a colored badge."] = true
L["Open Animation"] = true
L["Fades the box in when it opens."] = true
L["Class Color Glow"] = true
L["A glow in your class color around the box while it is open."] = true
L["Backdrop Alpha"] = true
L["Same setting as in ElvUI's chat options, shown here for convenience."] = true
L["Active Underline"] = true
L["Marks the active tab with a line in your class color."] = true
L["How opaque the edit box backdrop is. ElvUI's own transparency setting is used for everything else."] = true
L["Replaced by the copy button of the MerathilisUI Chat Sidebar."] = true
L["Hide Voice Buttons"] = "음성 버튼 숨김"
L["Hides the voice buttons on the chat panel, the sidebar button takes their place."] = true
L["Opens the channel list. Right-click mutes your microphone, middle-click your speakers."] = true
L["Replaced by the voice button of the MerathilisUI Chat Sidebar."] = true
L["Other Games / App"] = true

L["Location Panel"] = true
L["Link Location in Chat"] = true
L["Shows the current zone in a panel above your Minimap. Left-click it to open the World Map, right-click to link your location in chat."] = true
L["Disable ElvUI Cluster"] = true
L["ElvUI's Minimap Cluster shows the zone text and the clock above the Minimap. Disable it so it does not overlap the panel."] = true
L["Opens Blizzard's addon list. Hidden while ElvUI's own option hides the addon compartment."] = true
L["Gap between the panel and the Minimap."] = true
L["Minimap Zone Text"] = true
L["Zone"] = true
L["Zone and Subzone"] = true
L["Zone PvP Status"] = true
L["Left Click"] = true
L["Hide ElvUI Location Text"] = true
L["Hides the zone text ElvUI shows on the Minimap, the panel shows it already."] = true
L["Coordinates"] = true
L["Shows your X coordinate left and your Y coordinate right of the zone text."] = true

-- Tracker
L["Tracker"] = true
L["Battle Res"] = true
L["Shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters."] = true
L["Shows sample values for 20 seconds so you can check the look and position."] = true
L["Mythic+ and Raid"] = true
L["Raid"] = "레이드"
L["Desaturate"] = "흑백처리"
L["Greys out the icon while no charge is left."] = true
L["Charges"] = true
L["Recharge Time"] = true
L["Bloodlust"] = true
L["The Bloodlust tracker shows your Sated lockout, the active lust and optionally when a lust is ready again."] = true
L["Show Sated"] = true
L["Shows the remaining time of your Sated lockout. The active lust itself is always shown."] = true
L["Show Ready"] = true
L["Keeps the icon up with a Ready text while you can benefit from a lust again."] = true
L["Greys out the icon while you are Sated."] = true
L["Ready"] = true

-- Movement Alert
L["No %s"] = true
L["%s ready"] = true
L["Movement Alert"] = true
L["Time Spiral"] = true
L["Gateway Control Shard"] = true
L["Sound"] = true
L["Text to Speech"] = true
L["Reads the alert out loud with the voice from Blizzard's Text to Speech settings instead of playing the sound."] = true
L["Spoken Text"] = true
L["Unknown Spell"] = true
L["Movement spells of your class. Only spells your current specialization knows are shown."] = true
L["Custom Spells"] = true
L["Add Spell ID"] = true
L["Tracks another spell of your class, for example one that is missing from the list above."] = true
L["Not a valid spell ID."] = true
L["Remove"] = true
L["Shows the cooldown of your class's movement spells while they are not available, a banner when Time Spiral lets you use one for free and a reminder when your Gateway Control Shard can be used."] = true
L["Shows sample alerts for 20 seconds so you can check the look and position."] = true
L["Combat Only"] = true
L["Only show the cooldowns while you are in combat."] = true
L["Display Mode"] = "표시방법"
L["Text"] = "글자 표시"
L["Bar"] = true
L["Text Format"] = "글자 형식"
L["Name + Time"] = true
L["Time + Name"] = true
L["Time only"] = true
L["Show Decimals"] = true
L["Texture"] = "텍스처"
L["Show Icon"] = "아이콘 표시"
L["Show Time"] = true
L["Ready Alert"] = true
L["Plays a sound or reads the spell name out loud when a movement spell is available again."] = true
L["Spells"] = true
L["Shows a banner while one of your movement spells can be used for free after Time Spiral or a similar effect reset it."] = true
L["Shows a reminder while the Gateway Control Shard in your bags can be used."] = true

-- Faction Indicator
L["Faction Indicator"] = true
L["Shows the faction icon of players from the opposing faction."] = true
L["Crest"] = true
L["Round"] = true
L["TargetTarget"] = "대상의 대상"
L["FocusTarget"] = "주시 대상"
L["Open the %s Status Report window that shows necessary information for debugging. Post this when reporting bugs!"] = true
L["Equipment Flyout"] = true

-- DataTexts
L["Settings for the MerathilisUI datatexts. Add them to a panel in ElvUI's DataTexts options."] = true
L["Show Icons"] = true
L["White Text"] = true
L["Shows the values in white instead of ElvUI's value color."] = true
L["White Icon"] = true
L["Keeps the durability icon white instead of coloring it like the durability."] = true
L["Repair Mount"] = true
L["Summoned with a right click on the datatext."] = true
L["Colored Durability"] = true
L["Colors the durability below the thresholds. Turned off, it only turns orange below 15%."] = true
L["Warning Color"] = true
L["Critical"] = true
L["Critical Color"] = true
L["Permoks Account Manager"] = true

-- NamePlates
L["Target Arrows"] = true
L["Animated arrows next to the nameplate of your target. While enabled, they replace the arrows of ElvUI's target indicator, its glow stays."] = true
L["Side Arrows"] = "양옆 화살표"
L["Top Arrow"] = "상단 화살표"
L["Slide In"] = true
L["Bounce"] = true
L["Arrow Texture"] = "화살표 텍스처"
L["Hover Highlight"] = "강조효과"
L["Restyles the highlight on the health bar of the nameplate under your mouse. Needs the Highlight option of ElvUI's nameplates."] = true
L["Fade In"] = true
L["Additive Blend"] = "밝기 조정"
L["Brightens the health bar instead of laying the texture over it."] = true
L["Focus Highlight"] = true
L["Lays a texture over the health bar of your focus target's nameplate."] = true
L["Raid Marker Color"] = true
L["Tints the health bar of a nameplate with a raid marker in the color of that marker."] = true
L["Enemy Forces"] = true
L["During a Mythic+ keystone run, shows next to the health bar how much an enemy contributes to the Enemy Forces requirement."] = true

-- Interrupt Ready
L["Interrupt Ready"] = true
L["Colors the castbar of hostile units while your interrupt is on cooldown and marks the moment it is ready again. The colors are the interrupt entries of the Castbar Colors in the Theme options."] = true
L["Cooldown Color"] = true
L["Colors the filled part of the castbar while your interrupt is on cooldown."] = true
L["Ready Window"] = true
L["Colors the rest of the cast from the moment your interrupt is ready again."] = true
L["Ready Tick"] = true
L["A thin line at the moment your interrupt is ready again."] = true
L["Tick Color"] = true
L["Units"] = true
L["Interrupt on Cooldown"] = true
L["Interrupt Ready Soon"] = true

-- Cast on You
L["Cast on You"] = true
L["Marks the castbar of hostile units while their cast targets you. Channeled spells are not marked."] = true
L["Castbar Border"] = true
L["A colored border around the castbar."] = true
L["Border Size"] = true
L["Castbar Color"] = true
L["Colors the filled part of the castbar. The Interrupt Ready colors stay on top."] = true

-- Execute Line
L["Execute Line"] = true
L["A line on the health bar at the given health percent, so you see at a glance when a unit gets into the range of your execute abilities."] = true
L["Hostile Units Only"] = true
L["Only shows the line on units you can attack."] = true
L["Health Percent"] = true
L["Glow"] = "발광"
L["A soft glow around the line."] = true
L["Pulse"] = true
L["The glow slowly pulses."] = true
L["Markers"] = true
L["Small arrows at both ends of the line that point at the health bar."] = true
L["Execute Range"] = true
L["Tints the part of the health bar below the line, fading in towards the line."] = true
L["Range Opacity"] = true

-- HoverCast
L["HoverCast"] = true
L["%s is disabled while %s is loaded, both bind clicks on the same unit frames."] = true
L["Always casts your highest rank."] = true
L["Target Unit"] = true
L["Context Menu"] = true
L["Trinket 1"] = true
L["Trinket 2"] = true
L["Dynamic Rez"] = true
L["Unknown Macro"] = true
L["Unknown Item"] = true
L["Dispels"] = true
L["Externals"] = true
L["Right Click"] = true
L["Middle Click"] = true
L["Mouse 4"] = true
L["Mouse 5"] = true
L["Wheel Up"] = true
L["Wheel Down"] = true
L["Not Bound"] = true
L["Press a key, click, or scroll..."] = true
L["Left-click to set keybind.\nRight-click to clear."] = true
L["Conflicting Keybind"] = true
L["%s is also assigned to:"] = true
L["Not currently talented"] = true
L["Global Bindings"] = true
L["Spec Bindings"] = true
L["Macros"] = true
L["Add Global Binding"] = true
L["Add New"] = true
L["Quickbind"] = true
L["Quickbind: hover a spell, press a key"] = true
L["Done"] = true
L["Global Options"] = true
L["Enable Click Casting"] = true
L['Please disable the addon "Clique" to use this feature.'] = true
L["Trigger Bindings on Down"] = true
L["Mouseover Frames"] = true
L["All Unit Frames"] = true
L["ElvUI Group Frames"] = true
L["Per-Spell Options"] = true
L["Spell"] = true
L["Macro"] = true
L["Item"] = true
L["Action"] = true
L["Preset"] = true
L["Keybind"] = true
L["Enable Dynamic Rez"] = true
L["Only Cast Out of Combat"] = true
L["Only Open Menu Out of Combat"] = true
L["Only Target Out of Combat"] = true
L["Active In"] = true
L["Solo"] = true
L["PvP"] = true
L["All"] = true
L["Active while you are not in a group."] = true
L["Active in a PvE party."] = true
L["Active in a PvE raid."] = true
L["Active in battlegrounds and arenas."] = true
L["Cast On"] = true
L["Frames"] = true
L["Frames and Mouseover"] = true
L["Hovercast is not available for unmodified left/right click"] = true
L["Unit Types"] = true
L["Enemy"] = "적군"
L["Friendly"] = "아군"
L["Disabling both disables this binding."] = true
L["Select a binding from either sidebar to edit its options"] = true

-- Presets
L["Presets"] = true
L["Export"] = "출력"
L["Name"] = "이름"
L["Author"] = true
L["Backup"] = true
L["Made with"] = true
L["Preset Code"] = true
L["Apply Preset"] = true
L["Create Code"] = true
L["Invalid Code"] = true
L["Find More Presets"] = true
L["Share Your Preset"] = true
L["Browse the presets of the community on merathilisui.com"] = true
L["Upload it with a few screenshots on merathilisui.com"] = true
L["Official preset, included in %s."] = true
L["Select the code with CTRL+A and copy it with CTRL+C."] = true
L["Paste a preset code from %s or from another player. The preset becomes a new ElvUI profile, so you can switch back to your current one at any time."] = true
L["Turn your current setup into a preset code: the active ElvUI profile with all MerathilisUI settings and the private settings of this character."] = true
L["Apply the preset %s as a new ElvUI profile? Your current profile stays untouched, the private settings of this character are kept as a backup. The UI reloads afterwards."] = true
L["This is not a MerathilisUI preset code."] = true
L["This is an ElvUI profile string. Import it in the ElvUI profile options."] = true
L["The preset code is damaged. Copy it again, completely."] = true
L["This preset needs a newer version of MerathilisUI."] = true
L["This preset is not included in your version of MerathilisUI. Please update the addon."] = true
L["Made for WoW Forever, some settings might not fit Retail."] = true
L["Made for Retail, some settings might not fit WoW Forever."] = true
L["Made with MerathilisUI %s, update the addon to get all of its settings."] = true
L["Made for a %dx%d screen, a few positions might need adjusting at %dx%d."] = true
L["The preset could not be applied completely."] = true
L["Copy Code"] = true
L["Official Presets"] = true
L["Dark"] = "어두운 느낌"
L["Healer"] = "힐러"
L["Minimal"] = true
L["Compact"] = true
L["Presets made by the author of %s. Each one starts from the current MerathilisUI layout, so it stays up to date with every release."] = true
L["The MerathilisUI layout with gradient health bars in the class color."] = true
L["The MerathilisUI layout with dark health bars and the class color on their backdrop."] = true
L["Bigger party and raid frames in the middle of the screen, close to your character."] = true
L["Only the main action bar stays visible, the other bars show on mouseover. No chat backgrounds, chat bar or portraits."] = true
L["Smaller unit frames and action buttons for 1080p and small screens."] = true
L["Type /mer presets to pick a ready-made look. Every preset becomes a new ElvUI profile, so you can switch back at any time."] = true
L["More presets from the community wait on merathilisui.com/presets. Copy a code and paste it under Presets > Import."] = true
L["Presets > Export turns your setup into a code. Upload it with a few screenshots on merathilisui.com to share it."] = true

-- Option cards
L["Scales the character, dressing room, inspect, talent and collection frames on their own, independent of the UI scale."] = true
L["Shows the name, level, guild and target of the unit under your mouse cursor right next to it."] = true
L["Shows small toast notifications for new mail, invites, guild events, paragon rewards and more."] = true
L["Shows its own action bar while you are in a vehicle or skyriding."] = true
L["Hides ElvUI's action bars 1-3 while the vehicle bar is shown."] = true
L["Restyles Blizzard's built-in damage meter in the MerathilisUI look."] = true

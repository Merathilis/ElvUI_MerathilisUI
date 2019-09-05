-- Simplified Chinese localization file for zhCN
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "zhCN")

-- Core
L[" is loaded. For any issues or suggestions, please visit "] = " 已加载。如有任何问题或建议，请访问 "

-- General Options
L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."] = true
L["by Merathilis (EU-Shattrath)"] = true
L["AFK"] = "离开"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = "启用/禁用MUI AFK屏幕。如果加载了BenikUI，则禁用"
L["Are you still there? ... Hello?"] = "你还在吗？ ... 在吗？"
L["Logout Timer"] = "登出计时器"
L["SplashScreen"] = "闪屏"
L["Enable/Disable the Splash Screen on Login."] = "在登录时启用/禁用启动画面."
L["Options"] = "选项"
L["Combat State"] = "战斗状态"
L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."] = "如果你进入/离开战斗，启用/禁用'+'/'-'战斗信息."
L["Desciption"] = "描述"
L["MER_DESC"] = [=[|cffff7d0aMerathilisUI|r 是ElvUI的扩展. 它增加了:

- 大量新特性
- 一个整体的透明外观
- 重写了所有的ElvUI外观
- 我的个人布局

|cFF00c0faNote:|r 它与其他大多数ElvUI插件兼容.
但是如果你在我的之外安装了另一个布局，你必须手动调整它。.

|cffff8000Newest additions are marked with: |r]=]

-- LoginMessage
L["Enable/Disable the Login Message in Chat"] = "在聊天框中启用/禁用登录消息"

-- Bags
L["Equipment Manager"] = "装备管理"
L["Equipment Set Overlay"] = "套装覆盖"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "为你背包(银行)中的物品显示关联的套装."

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "后退"
L["has come |cff298F00online|r."] = "来了 |cff298F00在线|r." -- Guild Message
L["has gone |cffff0000offline|r."] = "走了 |cffff0000离线|r." -- Guild Message
L[" has come |cff298F00online|r."] = "来了 |cff298F00在线|r." -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = "走了 |cffff0000离线|r." -- Battle.Net Message
L["|cFF00c0failvl|r: %d"] = true
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = "|CFF1EFF00%s|r |CFFFF0000出售.|r"
L["Requires level: %d - %d"] = "需要等级: %d - %d"
L["Requires level: %d - %d (%d)"] = "需要等级: %d - %d (%d)"
L["(+%.1f Rested)"] = "(+%.1f 休息)"
L["Unknown"] = "未知"
L["Chat Item Level"] = "聊天物品等级"
L["Shows the slot and item level in the chat"] = "显示聊天中的插槽和物品等级"
L["Expand the chat"] = "展开聊天框"
L["Chat Menu"] = "聊天菜单"
L["Create a chat button to increase the chat size and chat menu button."] = "创建聊天按钮以增加聊天大小和聊天菜单按钮."
L["Hide Player Brackets"] = "隐藏玩家括号"
L["Removes brackets around the person who posts a chat message."] = "删除聊天框中玩家名字两边的括号."
L["Hide Community Chat"] = "隐藏社区聊天"
L["Adds an overlay to the Community Chat. Useful for streamers."] = true
L["Chat Hidden. Click to show"] = "聊天框已隐藏，点击显示"
L["ChatBar"] = "聊天条"
L["Shows a ChatBar with different quick buttons."] = "用不同的快捷按钮显示一个聊天条"
L["Click to open Emoticon Frame"] = "点击打开表情框架"
L["Emotes"] = "表情"

-- Information
L["Information"] = "信息"
L["Support & Downloads"] = "支持 & 下载"
L["Tukui.org"] = true
L["Git Ticket tracker"] = true
L["Curse.com"] = true
L["Coding"] = true
L["Testing & Inspiration"] = true
L["Development Version"] = true
L["Here you can download the latest development version."] = "您可以从这里下载最新的开发版本."

-- Modules
L["Here you find the options for all the different |cffff8000MerathilisUI|r modules.\nPlease use the dropdown to navigate through the modules."] = "你能在这里找到所有不同的选项 |cffff8000MerathilisUI|r modules.\n请使用下拉列表浏览模块."

-- GameMenu
L["GameMenu"] = "游戏菜单"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."] = "从暴雪游戏菜单启用/禁用MerathilisUI样式."

-- FlightMode
L["FlightMode"] = "飞行模式"
L["Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = "启用/禁用MerathilisUI飞行模式.\n要完全进入飞行模式，请进入 |cff00c0faBenikUI|r Options."

-- FlightPoint
L["Flight Point"] = "飞行点"
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = "在飞行地图上启用/禁用MerathilisUI飞行点."

-- MasterPlan
L["MasterPlan"] = true
L["Skins the additional Tabs from MasterPlan."] = true

-- MicroBar
L["Hide In Orderhall"] = "在职业大厅中隐藏"
L["Show/Hide the friend text on MicroBar."] = "在微型菜单上显示/隐藏朋友文本."
L["Show/Hide the guild text on MicroBar."] = "在微型菜单上显示/隐藏公会文本."
L["Blingtron"] = "布林顿每日任务"
L["Mean One"] = "冬幕节"
L["Timewarped"] = "500时空扭曲徽章"
L["Legion Invasion"] = "军团入侵"
L["Faction Assault"] = "阵营突袭"
L["Local Time"] = "本地时间"
L["Realm Time"] = "现实时间"
L["Current Invasion: "] = "当前入侵: "
L["Next Invasion: "] = "下次入侵: "
L["Mythic Dungeon"] = "地下城"

-- Misc
L["Misc"] = "杂项"
L["Artifact Power"] = "神器能量"
L["has appeared on the MiniMap!"] = "已经出现在小地图上!"
L["Alt-click, to buy an stack"] = "Alt-点击, 批量买"
L["Mover Transparency"] = "Mover透明度"
L["Changes the transparency of all the movers."] = "更改所有movers的透明度."
L["Announce"] = "通告"
L["Skill gains"] = "技能提升"
L["Automatically select the quest reward with the highest vendor sell value. Also announce Quest Progress."] = "自动选择具有售价的任务奖励.同时通告任务进度."
L[" members"] = " 会员"
L["Name Hover"] = "名字悬停"
L["Shows the Unit Name on the mouse."] = "显示鼠标指向的单位名称."
L["Undress"] = "解除装备"
L["Flashing Cursor"] = "鼠标闪光"
L["Accept Quest"] = "接受任务"
L["Placed Item"] = "放置物品"
L["Stranger"] = "陌生人"
L["Raid Info"] = "团队信息"
L["Shows a simple frame with Raid Informations."] = "显示带有Raid信息的简单框架."
L["Keystones"] = "大秘境钥匙"
L["GUILD_MOTD_LABEL2"] = "公会今日信息"
L["LFG Member Info"] = true
L["MISC_REPUTATION"] = "Reputation"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Reputation"
L["MISC_PARAGON_NOTIFY"] = "Max Reputation - Receive Reward."
L["Skip Azerite Animation"] = true

-- Tooltip
L["Your Status:"] = "你的状态: "
L["Your Status: Incomplete"] = "你的状态：不完整"
L["Your Status: Completed on "] = "您的状态：已完成"
L["Adds an Icon for battle pets on the tooltip."] = "在鼠标提示中为战斗宠物添加一个图标."
L["Adds an Icon for the faction on the tooltip."] = "在鼠标提示中为阵营添加一个图标."
L["Adds information to the tooltip, on which char you earned an achievement."] = "在鼠标提示中增加一个信息,显示你在哪个角色上取得了成就."
L["Keystone"] = "大秘境钥匙"
L["Adds descriptions for mythic keystone properties to their tooltips."] = "鼠标提示中添加大米钥匙的词缀描述"
L["Title Color"] = "标题颜色"
L["Change the color of the title in the Tooltip."] = "改变鼠标提示中标题的颜色"
L["Progress Info"] = "进度信息"
L["Shows raid progress of a character in the tooltip"] = "鼠标提示中显示角色的副本进度"
L["Mythic"] = "史诗"
L["Heroic"] = "英雄"
L["Normal"] = "普通"
L["LFR"] = true
L["Uldir"] = true
L["BattleOfDazaralor"] = "达萨罗之战"
L["CrucibleOfStorms"] = "风暴熔炉"
L["FACTION"] = "阵营"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "已激活的艾泽里特之力"
L["Only Icons"] = true

-- MailInputBox
L["Mail Inputbox Resize"] = "收件箱大小调整"
L["Resize the Mail Inputbox and move the shipping cost to the Bottom"] = "调整邮件收件箱大小，并把费用移动到底部"

-- Notification
L["Notification"] = "通知"
L["Display a Toast Frame for different notifications."] = "为不同的通知显示一个提示框."
L["This is an example of a notification."] = "这是一个通知的示例."
L["Notification Mover"] = true
L["%s slot needs to repair, current durability is %d."] = "%s 插槽需要修理, 当前耐久度是 %d."
L["You have %s pending calendar invite(s)."] = "你有 %s 待处理的日历邀请."
L["You have %s pending guild event(s)."] = "你有 %s 待处理的公会事件."
L["Event \"%s\" will end today."] = "\"%s\" 活动今天结束."
L["Event \"%s\" started today."] = "\"%s\" 活动今天开始."
L["Event \"%s\" is ongoing."] = "\"%s\" 活动正在进行中."
L["Event \"%s\" will end tomorrow."] = "\"%s\" 活动明天结束."
L["Here you can enable/disable the different notification types."] = "在这里，你可以启用/禁用不同的通知类型."
L["Enable Mail"] = "启用邮件"
L["Enable Vignette"] = "启用简介"
L["If a Rare Mob or a treasure gets spotted on the minimap."] = "如果在小地图上发现稀有精英或宝箱"
L["Enable Invites"] = "启用邀请"
L["Enable Guild Events"] = "启用公会活动"
L["No Sounds"] = "没有声音"

-- DataTexts
L["ChatTab Datatext Panel"] = "聊天标签信息面板"
L["Middle Datatext Panel"] = "中间的信息面板"
L["Right Click"] = true
L["Toggle ActionBar"] = true
L["Toggle Middle DT"] = true

-- DataBars
L["DataBars"] = "数据条"
L["Add some stylish buttons at the bottom of the DataBars"] = "在数据条底部添加一些美观的按钮"
L["Style DataBars"] = "样式数据条"

-- Actionbars
L["Specialisation Bar"] = "专业条"
L["EquipSet Bar"] = "套装管理条"
L["Clean Boss Button"] = true
L["Auto Buttons"] = "自动按钮"
L["Bind Font Size"] = "绑定字体大小"
L["Trinket Buttons"] = "饰品按钮"
L["Color by Quality"] = "品质颜色"
L["Quest Buttons"] = "任务按钮"
L["Blacklist Item"] = true
L["Whitelist Item"] = true
L["Add Item ID"] = true
L["Delete Item ID"] = true

-- Armory
L["Armory"] = true
L["ARMORY_DESC"] = [=[这个 |cffff7d0aArmory 模式|r只对ElvUI'显示人物信息'有效. 你可能需要重载你的UI:

ElvUI - 常规 - BlizzUI改进 - 显示人物信息.]=]
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = "启用/禁用|cffff7d0aMerathilisUI|r Armory模式"
L["Azerite Buttons"] = "艾泽里特按钮"
L["Enable/Disable the Azerite Buttons on the character window."] = "在人物窗口启用/禁用艾泽里特按钮."
L["Durability"] = "耐久度"
L["Enable/Disable the display of durability information on the character window."] = "在人物窗口启用/禁用耐久度信息显示."
L["Damaged Only"] = "仅受损"
L["Only show durability information for items that are damaged."] = "仅显示已受损物品的耐久度信息"
L["Itemlevel"] = "物品等级"
L["Enable/Disable the display of item levels on the character window."] = "在人物窗口启用/禁用物品等级显示."
L["Level"] = "等级"
L["Full Item Level"] = "完整物品等级"
L["Show both equipped and average item levels."] = "显示装备和平均物品等级."
L["Item Level Coloring"] = "物品等级着色"
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "物品等级的颜色代码值，通过选择的颜色，Equipped will be gradient, average - selected color"
L["Color of Average"] = "装等颜色"
L["Sets the color of average item level."] = "设置平均装等的颜色"
L["Only Relevant Stats"] = "只有相关统计数据"
L["Show only those primary stats relevant to your spec."] = "仅显示与你专精相关的主要信息."
L["Item Level"] = "物品等级"
L["Categories"] = "分类"
L["Open head slot azerite powers."] = "打开头部的艾泽里特能量槽."
L["Open shoulder slot azerite powers."] = "打开肩部的艾泽里特能量槽."
L["Open chest slot azerite powers."] = "打开胸部的艾泽里特能量槽"
L["Slot Gradient"] = "槽渐变"
L["Shows a gradiation texture on the Character Slots."] = "为角色的物品槽显示一个渐变的材质."
L["Indicators"] = "指示器"
L["Transmog"] = "幻化"
L["Shows an arrow indictor for currently transmogrified items."] = "为当前幻化的物品显示一个箭头指示器."
L["Illusion"] = "幻象"
L["Shows an indictor for weapon illusions."] = "为武器幻象显示一个指示器"
-- PRINTS
L["Equipped head is not an Azerite item."] = "已装备的头部不是一个艾泽里特物品."
L["No head item is equipped."] = "没有头部物品被装备."
L["Equipped shoulder is not an Azerite item."] = "已装备的肩部不是一个艾泽里特物品."
L["No shoulder item is equipped."] = "没有肩部物品被装备."
L["Equipped chest is not an Azerite item."] = "已装备的胸部不是一个艾泽里特物品."
L["No chest item is equipped."] = "没有胸部物品被装备."

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
L["UnitFrames"] = "单位框体"
L["Player Portrait"] = "玩家肖像"
L["Target Portrait"] = "目标肖像"
L["Aura Spacing"] = "光环间距"
L["Sets space between individual aura icons."] = "设置各个光环图标间的间距."
L["Set Aura Spacing On Following Units"] = "在以下单位上设置光环间距"
L["Assist"] = "辅助"
L["Boss"] = "首领"
L["Focus"] = "焦点"
L["FocusTarget"] = "焦点的目标"
L["Party"] = "小队"
L["Pet"] = "宠物"
L["PetTarget"] = "宠物目标"
L["Player"] = "玩家"
L["Raid"] = "团队"
L["Raid40"] = "40人团队"
L["RaidPet"] = "团队宠物"
L["Tank"] = "坦克"
L["Target"] = "目标"
L["TargetTarget"] = "目标的目标"
L["TargetTargetTarget"] = "目标的目标的目标"
L["Hide Text"] = "隐藏文本"
L["Hide From Others"] = "隐藏其他"
L["Threshold"] = "阈值"
L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."] = "持续时间文本将被隐藏,直到达到此阈值(以秒为单位).设置为-1以始终显示持续时间文本"
L["Position of the duration text on the aura icon."] = "持续时间文本在光环图标上的位置."
L["Position of the stack count on the aura icon."] = "光环上层数的位置."
-- Castbar
L["Adjust castbar text Y Offset"] = "调整施法条文本在Y轴的偏移"
L["Force show any text placed on the InfoPanel, while casting."] = "当正在施法时，强制显示信息面板上的文字."
L["Castbar Text"] = "施法条文本"
L["Show Castbar text"] = "显示施法条文本"
L["Show InfoPanel text"] = "显示信息面板文本"
L["InfoPanel Style"] = "信息面板风格"
L["Show on Target"] = "目标上显示"

-- LocationPanel
L["Location Panel"] = "位置面板"
L["Update Throttle"] = "更新阈值"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "坐标和区域文本更新的频率，数值越小更新越频繁."
L["Full Location"] = "完整位置"
L["Color Type"] = "颜色类型"
L["Custom Color"] = "自定义颜色"
L["Reaction"] = true
L["Location"] = "位置"
L["Coordinates"] = "坐标"
L["Teleports"] = "传送点"
L["Portals"] = "入口"
L["Link Position"] = "链接位置"
L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."] = "按住shift键点击位置，能在聊天框中粘贴你的坐标."
L["Relocation Menu"] = "传送菜单"
L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."] = "在位置面板上点击右键将弹出一些可用选项用来传送你的角色(例如炉石，传送门等)."
L["Custom Width"] = "自定义宽度"
L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."] = "默认情况下，菜单的宽度将等于位置面板宽度。 选中此选项将允许您设置自己的宽度"
L["Justify Text"] = "对齐文字"
L["Auto Width"] = "自动宽度"
L["Change width based on the zone name length."] = "根据区域名称长度更改宽度"
L["Hearthstone Location"] = "炉石位置"
L["Hearthstone Toys Order"] = "炉石玩具顺序"
L["Show the name on location your Hearthstone is bound to."] = "在您的炉石所绑定的位置显示名称"
L["Combat Hide"] = "战斗中隐藏"
L["Show/Hide all panels when in combat"] = "显示/隐藏所有的面板(战斗中)"
L["Hide In Class Hall"] = "职业大厅中隐藏"
L["Hearthstone Location"] = "炉石位置"
L["Show hearthstones"] = "显示炉石"
L["Show hearthstone type items in the list."] = "在列表中显示类炉石功能的物品."
L["Show Toys"] = "显示玩具"
L["Show toys in the list. This option will affect all other display options as well."] = "在列表中显示玩具. 此选项也会影响所有其他显示选项"
L["Show spells"] = "显示法术"
L["Show relocation spells in the list."] = "列表中显示传送法术."
L["Show engineer gadgets"] = "显示工程玩具"
L["Show items used only by engineers when the profession is learned."] = "仅显示已学的工程专业能使用的物品."
L["Ignore missing info"] = "忽略丢失的信息"
L["MER_LOCPANEL_IGNOREMISSINGINFO"] = [[一些项目由于客户端功能可能导致一段时间不可用.这些主要是玩具信息.
当调用时,菜单将等待到所有可用的信息后才会出现.可能导致菜单打开延迟，这取决于服务器响应请求的速度.
通过启用此选项，您将使菜单项忽略缺少的信息，使它们不会出现在列表中.]]
L["Info for some items is not available yet. Please try again later"] = "尚未提供某些项目的信息。请稍后再试"
L["Update canceled."] = "更新取消"
L["Item info is not available. Waiting for it. This can take some time. Menu will be opened automatically when all info becomes available. Calling menu again during the update will cancel it."] = "物品信息不可用.请等待一小会.当所有信息变得可用时，菜单将自动打开时.在更新期间再次调用菜单将取消它."
L["Update complete. Opening menu."] = "更新完成，正在打开菜单."
L["Hide Coordinates"] = "隐藏坐标"

-- Maps
L["MiniMap Buttons"] = "小地图按钮"
L["Minimap Ping"] = "小地图点击"
L["Shows the name of the player who pinged on the Minimap."] = "显示点击小地图的玩家姓名"
L["Blinking Minimap"] = "小地图边框闪亮"
L["Enable the blinking animation for new mail or pending invites."] = "为新邮件或等待的邀请启用闪光动画."

-- SMB
L["Bar Backdrop"] = "条背景"
L["Move Tracker Icon"] = "移动追踪图标"
L["Move Queue Status Icon"] = "移动队列状态图标"
L["Reverse Direction"] = true

-- Raid Marks
L["Raid Markers"] = "团队标记"
L["Click to clear the mark."] = "点击清理标记."
L["Click to mark the target."] = "点击标记目标."
L["%sClick to remove all worldmarkers."] = "%s点击移除所有的世界标记."
L["%sClick to place a worldmarker."] = "%s点击放置一个世界标记."
L["Raid Marker Bar"] = "团队标记条"
L["Options for panels providing fast access to raid markers and flares."] = "面板选项可快速访问团队标记和耀斑."
L["Show/Hide raid marks."] = "显示/隐藏Raid标记."
L["Reverse"] = "反转"
L["Modifier Key"] = "快捷键"
L["Set the modifier key for placing world markers."] = "设置用于放置世界标记的快捷键."
L["Visibility State"] = "可见状态"

-- Raid Buffs
L["Raid Buff Reminder"] = "团队BUFF提醒"
L["Shows a frame with flask/food/rune."] = "显示一个带合剂/食物/符文的框架."
L["Class Specific Buffs"] = "职业专精BUFF"
L["Shows all the class specific raid buffs."] = "显示所有的职业专精团队增益BUFF"
L["Change the alpha level of the icons."] = "改变图标的透明等级."
L["Shows the pixel glow on missing raidbuffs."] = "为丢失的团队BUFF显示一个像素发光."

-- Reminder
L["Reminder"] = "常驻BUFF提醒"
L["Reminds you on self Buffs."] = "提醒你自己的BUFF"

-- Cooldowns
L["CooldownFlash"] = "冷却闪光"
L["Settings"] = "设置"
L["Fadein duration"] = "淡入持续时间"
L["Fadeout duration"] = "淡出持续时间"
L["Duration time"] = "持续时间"
L["Animation size"] = "动画大小"
L["Display spell name"] = "显示法术名"
L["Watch on pet spell"] = "观看宠物法术"
L["Transparency"] = "透明度"
L["Test"] = "测试"
L["Sort Upwards"] = true
L["Sort by Expiration Time"] = true
L["Show Self Cooldown"] = true
L["Show Icons"] = true
L["Show In Party"] = true
L["Show In Raid"] = true
L["Show In Arena"] = true

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] = "如果有更新，则在额外的窗口中显示当天的公会信息."

-- AFK
L["Jan"] = "一月"
L["Feb"] = "二月"
L["Mar"] = "三月"
L["Apr"] = "四月"
L["May"] = "五月"
L["Jun"] = "六月"
L["Jul"] = "七月"
L["Aug"] = "八月"
L["Sep"] = "九月"
L["Oct"] = "十月"
L["Nov"] = "十一月"
L["Dec"] = "十二月"

L["Sun"] = "星期日"
L["Mon"] = "星期一"
L["Tue"] = "星期二"
L["Wed"] = "星期三"
L["Thu"] = "星期四"
L["Fri"] = "星期五"
L["Sat"] = "星期六"

-- Nameplates
L["Castbar Shield"] = true
L["Show a shield icon on the castbar for non interruptible spells."] = true
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 30 x 30"] = true

-- Install
L["Welcome"] = "欢迎"
L["|cffff7d0aMerathilisUI|r Installation"] = "|cffff7d0aMerathilisUI|r安装"
L["MerathilisUI Set"] = "MerathilisUI设置"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI没有找到任何支持的插件用于配置文件创建."
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI成功创建并应用了个人配置为:"
L["Tank/ DPS Layout"] = "坦克/DPS布局"
L["Heal Layout"] = "治疗布局"
L["Chat Set"] = "聊天框设置"
L["ActionBars"] = "动作条"
L["ActionBars Set"] = "动作条设置"
L["DataTexts Set"] = "数据文本设置"
L["Profile Set"] = "配置设置"
L["ElvUI AddOns settings applied."] = "应用ElvUI加载项设置."
L["AddOnSkins is not enabled, aborting."] = "AddOnSkins未启用，正在中止."
L["AddOnSkins settings applied."] = "应用了AddOnSkins设置."
L["BigWigs is not enabled, aborting."] = "BigWigs未启用，正在中止."
L["BigWigs Profile Created"] = "BigWigs配置文件已创建."
L["Skada Profile Created"] = "Skada配置文件已创建"
L["Skada is not enabled, aborting."] = "Skada未启用，正在中止."
L["UnitFrames Set"] = "单位框体设置"
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] = "欢迎来到MerathilisUI |cff00c0faVersion|r %s, 适用于ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "按下继续按钮，MerathilisUI将应用于您当前的ElvUI安装.\r\r|cffff8000 小窍门: 防止你不喜欢这个结果，你应该在新的配置文件中应用这个更改.|r"
L["Buttons must be clicked twice"] = "按钮需要点击两次"
L["Importance: |cffff0000Very High|r"] = "重要性: |cffff0000非常高|r"
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = "插件'AddOnSkins'未启用.没有设置被更改."
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = "插件'Big Wigs'未启用.未创建配置文件."
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] = "插件'ElvUI_BenikUI'未启用.没有设置被更改."
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] = "插件'ElvUI_SLE'未启用.没有设置被更改."
L["The Addon 'Skada' is not enabled. Profile not created."] = "插件'Skada'未启用.未创建配置文件."
L["This part of the installation process sets up your chat fonts and colors."] = "安装过程的此部分设置您的聊天字体和颜色."
L["This part of the installation changes the default ElvUI look."] = "安装过程的此部分更改了默认的ElvUI外观."
L["This part of the installation process let you create a new profile or install |cffff8000MerathilisUI|r settings to your current profile."] = "安装过程的此部分允许您为当前配置文件创建新配置文件或安装|cffff8000MerathilisUI|r设置."
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "这部分安装过程将填充MerathilisUI数据文本.\r|cffff8000这不会触及ElvUI数据文本|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = "这部分安装过程将重新布局您的动作条并启用背景"
L["This part of the installation process will reposition your Unitframes."] = "这部分安装过程将重新布局您的单位框体."
L["This part of the installation process will apply changes to ElvUI Plugins"] = "这部分安装过程将对ElvUI插件应用更改"
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "此步骤更改了一些魔兽世界的默认选项.这些选项是根据%s作者的需求量身定制的,并不是此配置功能所必需的(一些cvar的修改)"
L["Please click the button below to apply the new layout."] = "请单击下面的按钮以应用新布局."
L["Please click the button below to setup your chat windows."] = "请单击下面的按钮设置聊天窗口."
L["Please click the button below |cff07D400twice|r to setup your actionbars."] = "请点击下面的按钮|cff07D400两次|r来设置你的动作条."
L["Please click the button below to setup your datatexts."] = "请单击下面的按钮来设置数据文本."
L["Please click the button below |cff07D400twice|r to setup your Unitframes."] = "请点击下面的按钮|cff07D400两次|r来设置你的单位框体."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = "请单击下面的按钮以设置ElvUI AddOns.对于其他Addon配置文件,请进入我的选项 - 皮肤/插件"
L["DataTexts"] = "数据文本"
L["Setup Datatexts"] = "设置数据文本"
L["Setup Addons"] = "设置插件"
L["ElvUI AddOns"] = "ElvUI 插件"
L["Finish"] = "完成"
L["Installed"] = "安装"
L["|cffff8000Your currently active ElvUI profile is:|r %s."] = "|cffff8000你当前有效的ElvUI配置文件是:|r %s."

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "您的ElvUI版本比推荐使用|cffff7d0aMerathilisUI|r的版本旧. 你的版本是 |cff00c0fa%.2f|r (推荐版本 |cff00c0fa%.2f|r). MerathilisUI未加载. 请更新你的ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "你已经同时启用了Location Plus和Shadow＆Light.选择要禁用的插件"
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[在这里,您可以选择S＆L的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BUI"] = [[在这里,您可以选择BenikUI的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[在这里,您可以选择BigWigs的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[在这里,您可以选择Deadly Boss Mods的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[在这里,您可以选择Details!的布局.]]
L["Name for the new profile"] = "新配置文件的名称"
L["Are you sure you want to override the current profile?"] = "您确定要覆盖当前的配置吗？"

-- Skins
L["MER_SKINS_DESC"] = [[此部分旨在增强ElvUI中存在的外观.

请注意，如果相应的皮肤在主要的ElvUI皮肤部分中的|cff636363被禁用|r,则其中一些选项将不可用.]]
L["MER_ADDONSKINS_DESC"] = [[此部分旨在修改一些外部插件外观.

请注意，如果插件控制面板中未加载插件，其中一些选项将|cff636363被禁用|r.]]
L["Creates decorative stripes and a gradient on some frames"] = "在一些框架上创建条纹材质和渐变"
L["MerathilisUI Style"] = "MerathilisUI 样式"
L["MerathilisUI Panels"] = "MerathilisUI 面板"
L["MerathilisUI Shadows"] = "MerathilisUI 阴影"
L["Undress Button"] = "解除装备按钮"
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[这个部分将为某些插件创建配置文件.

|cffff0000警告:|r 它将覆盖/删除已经存在的配置文件. 如果你不想应用我的配置，请不要按下面的按钮.]]

-- Addons
L["Skins/AddOns"] = "皮肤/插件"
L["Profiles"] = "配置文件"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = true
L["This will create and apply profile for "] = "这将创建并应用配置文件"

-- Changelog
L["Changelog"] = "更新日志"

-- Errors
L["Error Handling"] = "错误处理"
L["In the List below, you can disable some annoying error texts, like |cffff7d0a'Not enough rage'|r or |cffff7d0a'Not enough energy'|r."] = "在下面的列表中, 你可以禁用一些领人烦恼的错误, 比如 |cffff7d0a'没有足够的怒气'|r 或 |cffff7d0a'没有足够的能量'|r"
L["Filter Errors"] = "过滤错误"
L["Choose specific errors from the list below to hide/ignore."] = "从下面的列表中选择特定的错误以隐藏/忽略."
L["Hides all errors regardless of filtering while in combat."] = "无论如果过滤，战斗中都隐藏所有错误."

-- Compatibility
L["has |cffff2020disabled|r "] = "已 |cffff2020禁用|r "
L[" from "] = " 从 "
L[" due to incompatiblities."] = " 由于不兼容."
L[" due to incompatiblities with: "] = true
L["You got |cff00c0faElvUI_Windtools|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."] = true
L["You got |cff9482c9ElvUI_LivvenUI|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."] = true

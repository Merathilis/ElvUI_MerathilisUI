-- Chinese localization file for enUS
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "enUS")
if not L then return; end

-- Core
L[" is loaded. For any issues or suggestions, please visit "] = " 已加载。如有任何问题或建议，请访问 "

-- General Options
L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."] = true
L["by Merathilis (EU-Shattrath)"] = true
L["AFK"] = true
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = "启用/禁用MUI AFK屏幕。如果加载了BenikUI，则禁用"
L["Are you still there? ... Hello?"] = "你还在吗？ ... 在吗？"
L["Logout Timer"] = "登出计时器"
L["SplashScreen"] = "闪屏"
L["Enable/Disable the Splash Screen on Login."] = "在登录时启用/禁用启动画面."
L["Options"] = "选项"
L["Combat State"] = "战斗状态"
L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."] = "如果你进入/离开战斗，启用/禁用'+'/'-'战斗信息."
L["Show Merchant ItemLevel"] = "显示商人物品等级"
L["Display the item level on the MerchantFrame, to change the font you have to set it in ElvUI - Bags - ItemLevel"] = "在商人框体上显示物品等级, 更改字体你需要在ElvUI-背包-物品等级"
L["Desciption"] = "描述"
L["MER_DESC"] = [=[|cffff7d0aMerathilisUI|r ElvUI的扩展. 它增加了:

- 大量新特性
- 一个整体的透明外观
- 重写了所有的ElvUI外观
- 我的个人布局

|cFF00c0faNote:|r 它与其他大多数ElvUI插件兼容.
但是如果你在我的之外安装了另一个布局，你必须手动调整它。.]=]

-- LoginMessage
L["Enable/Disable the Login Message in Chat"] = "在聊天框中启用/禁用登录消息"

-- Bags
L["Transparent Slots"] = "透明插槽"
L["Equipment Manager"] = "装备管理"
L["Equipment Set Overlay"] = "套装覆盖"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "为你背包(银行)中的物品显示关联的套装."

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
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
L["Mythic Dungeon"] = "大秘境"

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
L["Undress"] = "脱掉装备"
L["Flashing Cursor"] = "光标闪光"
L["Accept Quest"] = "接受任务"
L["Placed Item"] = "放置物品"
L["Stranger"] = "陌生人"
L["Raid Info"] = "团本信息"
L["Shows a simple frame with Raid Informations."] = "显示带有Raid信息的简单框架."
L["Keystones"] = "大秘境钥匙"

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

-- MailInputBox
L["Mail Inputbox Resize"] = "邮件收件箱大小调整"
L["Resize the Mail Inputbox and move the shipping cost to the Bottom"] = "调整邮件收件箱大小，并把费用移动到底部"

-- Notification
L["Notification"] = "通知"
L["Display a Toast Frame for different notifications."] = "为不同的通知显示一个提示框."
L["This is an example of a notification."] = "这是一个通知的示例."
L["Notification Mover"] = "true"
L["%s slot needs to repair, current durability is %d."] = "%s 插槽需要修理, 当前耐久度是 %d."
L["You have %s pending calendar invite(s)."] = "你有 %s 待处理的日历邀请."
L["You have %s pending guild event(s)."] = "你有 %s 待处理的公会事件."
L["Event \"%s\" will end today."] = "\"%s\" 活动今天结束."
L["Event \"%s\" started today."] = "\"%s\" 活动今天开始."
L["Event \"%s\" is ongoing."] = "\"%s\" 活动正在进行中."
L["Event \"%s\" will end tomorrow."] = "\"%s\" 活动明天结束."
L["Here you can enable/disable the different notification types."] = "在这里，你可以启用/禁用不同的通知类型."
L["Enable Mail"] = "启用邮件"
L["Enable Vignette"] = "true"
L["If a Rare Mob or a treasure gets spotted on the minimap."] = "如果在小地图上发现稀有精英或宝箱"
L["Enable Invites"] = "启用邀请"
L["Enable Guild Events"] = "启用公会活动"
L["No Sounds"] = "没有声音"

-- DataTexts
L["ChatTab Datatext Panel"] = "聊天标签信息面板"
L["Middle Datatext Panel"] = "中间的信息面板"

-- DataBars
L["DataBars"] = "数据条"
L["Add some stylish buttons at the bottom of the DataBars"] = "在数据条底部添加一些美观的按钮"
L["Style DataBars"] = "样式数据条"

-- Actionbars
L["Applies transparency in all actionbar backdrops and actionbar buttons."] = "为所有动作条的背景和按钮应用透明度"
L["Transparent Backdrops"] = "透明背景"
L["Specialisation Bar"] = "专业条"
L["EquipSet Bar"] = "套装管理条"
L["Clean Boss Button"] = true

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
L["Color code item levels values. Equipped will be gradient, average - selected color."] = "true"
L["Color of Average"] = true
L["Sets the color of average item level."] = true
L["Only Relevant Stats"] = true
L["Show only those primary stats relevant to your spec."] = true
L["Item Level"] = true
L["Categories"] = true
L["Open head slot azerite powers."] = true
L["Open shoulder slot azerite powers."] = true
L["Open chest slot azerite powers."] = true
L["Slot Gradient"] = true
L["Shows a gradiation texture on the Character Slots."] = true
L["Indicators"] = true
L["Transmog"] = true
L["Shows an arrow indictor for currently transmogrified items."] = true
L["Illusion"] = true
L["Shows an indictor for weapon illusions."] = true
-- PRINTS
L["Equipped head is not an Azerite item."] = true
L["No head item is equipped."] = true
L["Equipped shoulder is not an Azerite item."] = true
L["No shoulder item is equipped."] = true
L["Equipped chest is not an Azerite item."] = true
L["No chest item is equipped."] = true

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
L["Player Portrait"] = true
L["Target Portrait"] = true
L["Aura Spacing"] = true
L["Sets space between individual aura icons."] = true
L["Set Aura Spacing On Following Units"] = true
L["Assist"] = true
L["Boss"] = true
L["Focus"] = true
L["FocusTarget"] = true
L["Party"] = true
L["Pet"] = true
L["PetTarget"] = true
L["Player"] = true
L["Raid"] = true
L["Raid40"] = true
L["RaidPet"] = true
L["Tank"] = true
L["Target"] = true
L["TargetTarget"] = true
L["TargetTargetTarget"] = true
L["Hide Text"] = true
L["Hide From Others"] = true
L["Threshold"] = true
L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."] = true
L["Position of the duration text on the aura icon."] = true
L["Position of the stack count on the aura icon."] = true
-- Castbar
L["Adjust castbar text Y Offset"] = true
L["Force show any text placed on the InfoPanel, while casting."] = true
L["Castbar Text"] = true
L["Show Castbar text"] = true
L["Show InfoPanel text"] = true
L["InfoPanel Style"] = true
L["Show on Target"] = true

-- LocationPanel
L["Location Panel"] = "位置面板"
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = true
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = true
L["Teleports"] = true
L["Portals"] = true
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
L["Hearthstone Toys Order"] = true
L["Show the name on location your Hearthstone is bound to."] = true
L["Combat Hide"] = true
L["Show/Hide all panels when in combat"] = true
L["Hide In Class Hall"] = true
L["Hearthstone Location"] = true
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
L["MiniMap Buttons"] = "小地图按钮"
L["Minimap Ping"] = true
L["Shows the name of the player who pinged on the Minimap."] = true
L["Blinking Minimap"] = true
L["Enable the blinking animation for new mail or pending invites."] = true

-- NSCT
L["Combat Text"] = "战斗文本"
L["Disable Blizzard FCT"] = true
L["Personal SCT"] = true
L["Also show numbers when you take damage on your personal nameplate or in the center of the screen."] = true
L["Animations"] = true
L["Default"] = true
L["Criticals"] = true
L["Miss/Parry/Dodge/etc."] = true
L["Personal SCT Animations"] = true
L["Appearance/Offsets"] = true
L["Font Shadow"] = true
L["Use Damage Type Color"] = true
L["Default Color"] = true
L["Has soft min/max, you can type whatever you'd like into the editbox tho."] = true
L["Has soft min/max, you can type whatever you'd like into the editbox tho."] = true
L["X-Offset Personal SCT"] = true
L["Y-Offset Personal SCT"] = true
L["Only used if Personal Nameplate is Disabled."] = true
L["Text Formatting"] = true
L["Truncate Number"] = true
L["Condense combat text numbers."] = true
L["Show Truncated Letter"] = true
L["Comma Seperate"] = true
L["e.g. 100000 -> 100,000"] = true
L["Icon"] = true
L["Size"] = true
L["Start Alpha"] = true
L["Use Seperate Off-Target Text Appearance"] = true
L["Off-Target Text Appearance"] = true
L["Sizing Modifiers"] = true
L["Embiggen Crits"] = true
L["Embiggen Crits Scale"] = true
L["Embiggen Miss/Parry/Dodge/etc."] = true
L["Embiggen Miss/Parry/Dodge/etc. Scale"] = true
L["Scale Down Small Hits"] = true
L["Small Hits Scale"] = true

-- SMB
L["Bar Backdrop"] = "条背景"
L["Move Tracker Icon"] = true
L["Move Queue Status Icon"] = true

-- Raid Marks
L["Raid Markers"] = "团队标记"
L["Click to clear the mark."] = true
L["Click to mark the target."] = true
L["%sClick to remove all worldmarkers."] = true
L["%sClick to place a worldmarker."] = true
L["Raid Marker Bar"] = true
L["Options for panels providing fast access to raid markers and flares."] = true
L["Show/Hide raid marks."] = true
L["Reverse"] = true
L["Modifier Key"] = true
L["Set the modifier key for placing world markers."] = true
L["Visibility State"] = true

-- Raid Buffs
L["Raid Buff Reminder"] = "团队BUFF提醒"
L["Shows a frame with flask/food/rune."] = true
L["Class Specific Buffs"] = true
L["Shows all the class specific raid buffs."] = true
L["Change the alpha level of the icons."] = true
L["Shows the pixel glow on missing raidbuffs."] = true

-- Reminder
L["Reminder"] = "常驻BUFF提醒"
L["Reminds you on self Buffs."] = "提醒你自己的BUFF"

-- CooldownFlash
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
L["NameplateAuras"] = "姓名版光环"
L["Visibility"] = "可见度"
L["Set when this aura is visble."] = "当这个光环可见时设置"
L["Clear Spell List"] = true
L["Empties the list of specific spells and their configurations."] = true
L["Restore Spell List"] = true
L["Restores the default list of specific spells and their configurations."] = true
L["Spell Name/ID"] = true
L["Input a spell name or spell ID."] = true
L["Spell List"] = true
L["Remove Spell"] = true
L["Other Auras"] = true
L["These are the settings for all spells not explicitly specified."] = true
L["Icon Width"] = true
L["Set the width of this spells icon."] = true
L["Icon Height"] = true
L["Set the height of this spells icon."] = true
L["Lock Aspect Ratio"] = true
L["Set if height and width are locked to the same value."] = true
L["Stack Size"] = true
L["Text Size"] = true
L["Size of the stack text."] = true
L["Size of the cooldown text."] = true
L["Specific Auras"] = "特定光环"
L["Always"] = "总是"
L["Never"] = "决不"
L["Only Mine"] = true

-- Install
L["Welcome"] = "欢迎"
L["|cffff7d0aMerathilisUI|r Installation"] = true
L["MerathilisUI Set"] = true
L["MerathilisUI didn't find any supported addons for profile creation"] = true
L["MerathilisUI successfully created and applied profile(s) for:"] = true
L["Tank/ DPS Layout"] = true
L["Heal Layout"] = true
L["Chat Set"] = true
L["ActionBars"] = true
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
L["This part of the installation process let you create a new profile or install |cffff8000MerathilisUI|r settings to your current profile."] = true
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below |cff07D400twice|r to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below |cff07D400twice|r to setup your Unitframes."] = true
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = true
L["DataTexts"] = true
L["Setup Datatexts"] = true
L["Setup Addons"] = true
L["ElvUI AddOns"] = true
L["Finish"] = true
L["Installed"] = true
L["|cffff8000Your currently active ElvUI profile is:|r %s."] = true

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
L["Creates decorative stripes and a gradient on some frames"] = "在一些框架上创建条纹材质和渐变"
L["MerathilisUI Style"] = "MerathilisUI 样式"
L["MerathilisUI Panels"] = "MerathilisUI 面板"
L["MerathilisUI Shadows"] = "MerathilisUI 阴影"
L["Undress Button"] = "脱装备按钮"

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
L["In the List below, you can disable some annoying error texts, like |cffff7d0a'Not enough rage'|r or |cffff7d0a'Not enough energy'|r."] = true
L["Filter Errors"] = "过滤错误"
L["Choose specific errors from the list below to hide/ignore."] = true
L["Hides all errors regardless of filtering while in combat."] = true

-- Compatibility
L["has |cffff2020disabled|r "] = "已 |cffff2020禁用|r "
L[" from "] = " 从 "
L[" due to incompatiblities."] = " 由于不兼容."
L[" due to incompatiblities with: "] = true

-- Simplified Chinese localization file for zhCN
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "zhCN")

-- Core
L["Enable"] = "启用"
L[" is loaded. For any issues or suggestions join my discord: "] = true
L["Please run through the installation process to set up the plugin.\n\n |cffff7d0aThis step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step.|r"] =
	true
L["Font"] = true
L["Size"] = true
L["Width"] = true
L["Height"] = true
L["Alpha"] = true
L["Outline"] = "描边"
L["X-Offset"] = true
L["Y-Offset"] = true
L["Icon Size"] = true
L["Font Outline"] = true

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"] = true
L["AFK"] = "离开"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] =
	"启用/禁用MUI AFK屏幕。如果加载了BenikUI，则禁用"
L["Are you still there? ... Hello?"] = "你还在吗？ ... 在吗？"
L["Logout Timer"] = "登出计时器"
L["SplashScreen"] = "闪屏"
L["Enable/Disable the Splash Screen on Login."] = "在登录时启用/禁用启动画面."
L["Options"] = "选项"
L["Description"] = "描述"
L["General"] = true
L["Modules"] = true
L["Media"] = true
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r 是ElvUI的扩展. 它增加了:

- 大量新特性
- 一个整体的透明外观
- 重写了所有的ElvUI外观
- 我的个人布局

|cFF00c0faNote:|r 它与其他大多数ElvUI插件兼容.
但是如果你在我的之外安装了另一个布局，你必须手动调整它。.

|cffff8000Newest additions are marked with: |r]=]
L["Enables the stripes/gradient look on the frames"] = true

-- Core Options
L["Login Message"] = "登陆信息"
L["Enable/Disable the Login Message in Chat"] = "在聊天框中启用/禁用登录消息"
L["Log Level"] = "日志等级"
L["Only display log message that the level is higher than you choose."] = "只显示高于选择等级的日志信息."
L["Set to 2 if you do not understand the meaning of log level."] =
	"如果你不理解什么是日志级别, 设置为 2 就行."
L["This will overwrite most of the ElvUI Options for the colors, so please keep that in mind."] = true

-- Bags

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "后退"
L["|cFF00c0failvl|r: %d"] = "|cFF00c0fa物品等级|r: %d"
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = "|CFF1EFF00%s|r |CFFFF0000出售.|r"
L["Requires level: %d - %d"] = "需要等级: %d - %d"
L["Requires level: %d - %d (%d)"] = "需要等级: %d - %d (%d)"
L["(+%.1f Rested)"] = "(+%.1f 休息)"
L["Unknown"] = "未知"
L["Chat Item Level"] = "聊天物品等级"
L["Shows the slot and item level in the chat"] = "显示聊天中的插槽和物品等级"
L["Expand the chat"] = "展开聊天框"
L["Chat Menu"] = "聊天菜单"
L["Create a chat button to increase the chat size."] = "创建一个按钮用来调整聊天框大小"
L["Hide Player Brackets"] = "隐藏玩家括号"
L["Removes brackets around the person who posts a chat message."] = "删除聊天框中玩家名字两边的括号."
L["Hide Community Chat"] = "隐藏社区聊天"
L["Adds an overlay to the Community Chat. Useful for streamers."] =
	"在社区聊天内容上添加一个遮罩，对主播很有用"
L["Chat Hidden. Click to show"] = "聊天框已隐藏，点击显示"
L["Chat Bar"] = "聊天条"
L["Shows a ChatBar with different quick buttons."] = "用不同的快捷按钮显示一个聊天条"
L["Click to open Emoticon Frame"] = "点击打开表情框架"
L["Emotes"] = "表情"
L["Damage Meter Filter"] = "伤害统计过滤"
L["Fade Chat"] = "聊天渐隐"
L["Auto hide timeout"] = "时间"
L["Seconds before fading chat panel"] = "多少秒后聊天框自动隐藏"
L["Seperators"] = "标签分隔符"
L["Orientation"] = "方向"
L["Community"] = "社群"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = "请先加入一个社区."
L["Channel Name"] = "频道名称"
L["Abbreviation"] = "缩写"
L["Auto Join"] = "自动加入"
L["World"] = "世界"
L["Channels"] = "频道"
L["Block Shadow"] = "按键阴影"
L["Hide channels not exist."] = "隐藏不存在的频道."
L["Only show chat bar when you mouse over it."] = "鼠标滑过时显示."
L["Button"] = "按键"
L["Item Level Links"] = "物品等级链接"
L["Filter"] = "过滤器"
L["Block"] = "块"
L["Use Icon"] = "使用图标"
L["Use a icon rather than text"] = "使用图标"
L["Use Color"] = "使用颜色"
L["Font Setting"] = "字体设定"
L["Custom Online Message"] = true
L["Chat Link"] = "聊天链接"
L["Add extra information on the link, so that you can get basic information but do not need to click"] =
	"为链接添加额外信息, 这样你就可以不通过点击也能获取到基础信息"
L["Additional Information"] = "额外信息"
L["Level"] = "等级"
L["Translate Item"] = "翻译物品"
L["Translate the name in item links into your language."] = "将物品链接中的名称翻译为你的语言."
L["Icon"] = "图标"
L["Armor Category"] = "护甲分类"
L["Weapon Category"] = "武器分类"
L["Filters some messages out of your chat, that some Spam AddOns use."] = true
L["Display the level of the item on the item link."] = true
L["Numerical Quality Tier"] = true
L["%player% has earned the achievement %achievement%!"] = "%player%获得了成就%achievement%!"
L["%players% have earned the achievement %achievement%!"] = "%players%获得了成就%achievement%!"
L["%players% (%bnet%) has come online."] = "%players% (%bnet%) 已经上线。"
L["%players% (%bnet%) has gone offline."] = "%players% (%bnet%) 已经离线。"
L["BNet Friend Offline"] = true
L["BNet Friend Online"] = true
L["Show a message when a Battle.net friend's wow character comes online."] = true
L["Show a message when a Battle.net friend's wow character goes offline."] = true
L["Show the class icon before the player name."] = true
L["Show the faction icon before the player name."] = true
L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."] = true
L["This feature only works for message that sent by this module."] = true
L["Position of the Chat EditBox, if the Actionbar backdrop is disabled, this will be forced to be above chat."] = true
L["Actionbar 1 (below)"] = true
L["Actionbar 2 (below)"] = true
L["Actionbar 3 (below)"] = true
L["Actionbar 4 (below)"] = true
L["Actionbar 5 (below)"] = true
L["Actionbar 6 (above)"] = true

-- Combat Alert
L["Combat Alert"] = "战斗提示"
L["Enable/Disable the combat message if you enter/leave the combat."] = "启用/禁用战斗状态提示"
L["Enter Combat"] = "进入战斗"
L["Leave Combat"] = "脱离战斗"
L["Stay Duration"] = "持续时间"
L["Custom Text"] = "自订文字"
L["Custom Text (Enter)"] = "自订文字 (进入)"
L["Custom Text (Leave)"] = "自订文字 (脱离)"
L["Color"] = "颜色"

-- Information
L["Information"] = "信息"
L["Support & Downloads"] = "支持 & 下载"
L["Tukui"] = true
L["Github"] = true
L["CurseForge"] = true
L["Coding"] = "代码"
L["Testing & Inspiration"] = "测试与灵感"
L["Development Version"] = "开发版本"
L["Here you can download the latest development version."] = "您可以从这里下载最新的开发版本."
L["Donations"] = true

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] =
	"你能在这里找到所有不同的选项 |cffffffffMerathilis|r|cffff8000UI|r 模块."
L["Are you sure you want to reset %s module?"] = "你确定要重置 %s 模块么?"
L["Reset All Modules"] = "重置全部模块"
L["Reset all %s modules."] = "重置全部 %s 模块."

-- GameMenu
L["Game Menu"] = "游戏菜单"
L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"] =
	"从暴雪游戏菜单启用/禁用MerathilisUI样式."
L["Achievements: "] = true
L["Achievement Points: "] = true
L["Mounts: "] = true
L["Pets: "] = true
L["Toys: "] = true
L["Current Keystone: "] = true
L["M+ Score: "] = true
L["Show Weekly Delves Keys"] = true
L["Mythic+"] = true
L["Show Mythic+ Infos"] = true
L["Show Mythic+ Score"] = true
L["History Limit"] = true
L["Number of Mythic+ dungeons shown in the latest runs."] = true

-- Extended Vendor
L["Extended Vendor"] = true
L["Enhanced NameplateAuras"] = "增强姓名板光环"
L["Extends the merchant page to show more items."] = true
L["Number of Pages"] = true
L["The number of pages shown in the merchant frame."] = true

-- Shadows
L["Shadows"] = true
L["Increase Size"] = "增大尺寸"
L["Make shadow thicker."] = "让阴影变得更加厚实."

-- Mail
L["Mail"] = "邮件"
L["Alternate Character"] = "其他角色"
L["Alt List"] = "角色列表"
L["Delete"] = "删除"
L["Favorites"] = "收藏"
L["Favorite List"] = "收藏列表"
L["Name"] = "姓名"
L["Realm"] = "服务器"
L["Add"] = "添加"
L["Please set the name and realm first."] = "请先填写姓名和服务器."
L["Toggle Contacts"] = "开/关通讯录"
L["Online Friends"] = "在线好友"
L["Add To Favorites"] = "添加到收藏"
L["Remove From Favorites"] = "从收藏移除"
L["Remove This Alt"] = true

-- MicroBar
L["Backdrop"] = "背景"
L["Backdrop Spacing"] = "背景间距"
L["The spacing between the backdrop and the buttons."] = "背景和按键间的间距."
L["Time Width"] = "时间宽度"
L["Time Height"] = "时间高度"
L["The spacing between buttons."] = "按键间的间距"
L["The size of the buttons."] = "按键大小"
L["Slow Mode"] = "慢速模式"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] =
	"以更慢的时间(10秒)更新额外文字"
L["Display"] = "显示"
L["Fade Time"] = "淡入时间"
L["Tooltip Position"] = "鼠标提示位置"
L["Mode"] = "模式"
L["None"] = "无"
L["Class Color"] = "职业色"
L["Custom"] = "自订"
L["Additional Text"] = "额外文字"
L["Interval"] = "时间间隔"
L["The interval of updating."] = "更新时间间隔"
L["Home"] = "家"
L["Left Button"] = "左键"
L["Right Button"] = "右键"
L["Left Panel"] = "左面板"
L["Right Panel"] = "右面板"
L["Button #%d"] = "按键 #%d"
L["Pet Journal"] = "宠物"
L["Show Pet Journal"] = "显示小伙伴手册"
L["Random Favorite Pet"] = "随机偏好小伙伴"
L["Screenshot"] = "截图"
L["Screenshot immediately"] = "立即截图"
L["Screenshot after 2 secs"] = "2秒后截图"
L["Toy Box"] = "玩具"
L["Collections"] = "藏品"
L["Show Collections"] = "显示藏品"
L["Random Favorite Mount"] = "随机偏好坐骑"
L["Decrease the volume"] = "降低音量"
L["Increase the volume"] = "增大音量"
L["Profession"] = "专业"
L["Volume"] = "音量"

-- Misc
L["Misc"] = "杂项"
L["Artifact Power"] = "神器能量"
L["has appeared on the MiniMap!"] = "已经出现在小地图上!"
L["Alt-click, to buy an stack"] = "Alt-点击, 批量买"
L["Announce"] = "通告"
L["Skill gains"] = "技能提升"
L[" members"] = " 会员"
L["Name Hover"] = "名字悬停"
L["Shows the Unit Name on the mouse."] = "显示鼠标指向的单位名称."
L["Double Click to Undress"] = true
L["Accept Quest"] = "接受任务"
L["Placed Item"] = "放置物品"
L["Stranger"] = "陌生人"
L["Keystones"] = "大秘境钥匙"
L["GUILD_MOTD_LABEL2"] = "公会今日信息"
L["LFG Member Info"] = "寻找公会人员信息"
L["Shows role informations in your tooltip in the lfg frame."] = "在寻找公会界面鼠标提示显示职责信息"
L["MISC_REPUTATION"] = "声望"
L["MISC_PARAGON"] = "巅峰"
L["MISC_PARAGON_REPUTATION"] = "巅峰声望"
L["MISC_PARAGON_NOTIFY"] = "最高声望 - 接收奖励."
L["Fun Stuff"] = "有趣的玩意儿"
L["Change the NPC Talk Frame."] = true
L["Press CTRL + C to copy."] = "按下 CTRL + C 复制"
L["Wowhead Links"] = "Wowhead 链接"
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = "在成就和地图框体上添加 Wowhead 链接"
L["Item Alerts"] = "物品通告"
L["Announce in chat when someone placed an usefull item."] = "当有玩家放置某些物品时将在聊天栏通知"
L["Miscellaneous"] = true
L["Guild News Item Level"] = true
L["Add Item level Infos in Guild News"] = true
L["Spell Alert Scale"] = true
L["Add Title"] = true
L["Display an additional title."] = true
L["Add LFG group info to tooltip."] = true
L["Reskin Icon"] = true
L["Change role icons."] = true
L["Line"] = true
L["Alerts"] = true
L["Call to Arms"] = true
L["Feasts"] = true
L["Toys"] = true
L["Random Toy"] = true
L["Text Style"] = true
L["COLOR"] = true
L["Hide Boss Banner"] = true
L["This will hide the popup, that shows loot, after you kill a boss"] = true
L["{rt1} %player% cast %spell% -> %target% {rt1}"] = "%player%使用了%spell% -> %target%"
L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"] =
	"{rt1} %player%使用了%spell%, 各位快来领面包哦! {rt1}"
L["{rt1} %player% is casting %spell%, please assist! {rt1}"] =
	"{rt1} %player%正在进行 %spell%, 请配合点门哦! {rt1}"
L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"] = true
L["{rt1} %player% opened %spell%! {rt1}"] = "{rt1} %player%开启了%spell% {rt1}"
L["{rt1} %player% puts %spell% {rt1}"] = "{rt1} %player%放置了%spell% {rt1}"
L["{rt1} %player% used %spell% {rt1}"] = "{rt1} %player% 使用了 %spell% {rt1}"
L["{rt1} %player% puts down %spell%! {rt1}"] = true
L["Completed"] = "已完成"
L["%s has been reseted"] = "已重置 %s"
L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"] =
	"重置 %s 失败（有玩家在尝试进入副本）"
L["Cannot reset %s (There are players offline in your party.)"] = "重置 %s 失败（有离线玩家）"
L["Cannot reset %s (There are players still inside the instance.)"] = "重置 %s 失败（副本内还有玩家）"
L["Let your teammates know the progress of quests."] = true
L["Disable Blizzard"] = true
L["Disable Blizzard quest progress message."] = true
L["Include Details"] = true
L["Announce every time the progress has been changed."] = true
L["In Party"] = true
L["In Instance"] = true
L["In Raid"] = true
L["None"] = true
L["Self (Chat Frame)"] = true
L["Emote"] = true
L["Party"] = true
L["Yell"] = true
L["Say"] = true
L["The category of the quest."] = true
L["Suggested Group"] = true
L["If the quest is suggested with multi-players, add the number of players to the message."] = true
L["The level of the quest."] = true
L["Hide Max Level"] = true
L["Hide the level part if the quest level is the max level of this expansion."] = true
L["Add the prefix if the quest is a daily quest."] = true
L["Add the prefix if the quest is a weekly quest."] = true
L["Send the use of portals, ritual of summoning, feasts, etc."] = true
L["Feasts"] = true
L["Bots"] = true
L["Toys"] = true
L["Portals"] = true
L["Include Player"] = true
L["Uncheck this box, it will not send message if you cast the spell."] = true
L["Raid Warning"] = true
L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."] = true
L["Text"] = true
L["Name of the player"] = true
L["Target name"] = true
L["The spell link"] = true
L["Default Text"] = true
L["Reset Instance"] = true
L["Send a message after instance resetting."] = true
L["Prefix"] = true
L["Channel"] = true
L["Keystone"] = true
L["Announce the new mythic keystone."] = true
L["Heroism/Bloodlust"] = true
L["Mute"] = true
L["Disable some annoying sound effects."] = true
L["Others"] = true
L["Dragonriding"] = true
L["Mute the sound of dragonriding."] = true
L["Jewelcrafting"] = true
L["Mute the sound of jewelcrafting."] = true
L["Same Message Interval"] = true
L["Time interval between sending same messages measured in seconds."] = true
L["Set to 0 to disable."] = true
L["Automation"] = true
L["Automate your game life."] = true
L["Auto Hide Bag"] = true
L["Automatically close bag if player enters combat."] = true
L["Auto Hide Map"] = true
L["Automatically close world map if player enters combat."] = true
L["Accept Resurrect"] = true
L["Accept resurrect from other player automatically when you not in combat."] = true
L["Accept Combat Resurrect"] = true
L["Accept resurrect from other player automatically when you in combat."] = true
L["Confirm Summon"] = true
L["Confirm summon from other player automatically."] = true
L["Quick Delete"] = true
L["This will add the 'DELETE' text to the Item Delete Dialog."] = true
L["Show all stats on the Character Frame"] = true
L["Block Join Requests"] = true
L["|nIf checked, only popout join requests from friends and guild members."] = true
L["Random Toy Macro"] = true
L["Creates a random toy macro."] = true
L["Spell activation alert frame customizations."] = true
L["Enable/Disable the spell activation alert frame."] = true
L["Opacity"] = true
L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"] = true
L["Set the scale of the spell activation alert frame."] = true
L["Dressing Room"] = true
L["Inspect Frame"] = true
L["Sync Inspect"] = true
L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."] = true
L["Talents"] = true
L["Wardrobe"] = true
L["Auction House"] = true
L["Transmog Frame"] = true
L["Makes the transmogrification frame bigger. Credits to Kayr for code."] = true
L["Add more oUF tags. You can use them on UnitFrames configuration."] = true
L["Already Known"] = true
L["Puts a overlay on already known learnable items on vendors and AH."] = true
L["Crying"] = true
L["Mute crying sounds of all races."] = true
L["It will affect the cry emote sound."] = true
L["It will also affect the crying sound of all female Blood Elves."] = true
L["Class"] = true
L["The class icon of the player's class"] = true
L["Context Menu"] = true
L["Add features to the context menu."] = true
L["Section Title"] = true
L["Add a styled section title to the context menu."] = true
L["Guild Invite"] = true
L["Who"] = true
L["Report Stats"] = true
L["Armory"] = true
L["Set Region"] = true
L["If the game language is different from the primary language in this server, you need to specify which area you play on."] =
	true
L["Auto-detect"] = true
L["Taiwan"] = true
L["Korea"] = true
L["Americas & Oceania"] = true
L["Europe"] = true
L["Server List"] = true
L["Trade Tabs"] = true
L["Enable Tabs on the Profession Frames"] = true
L["Chef's Hat"] = "大厨帽"
L["Group Finder"] = true
L["Equipment Upgrade"] = true
L["Vendor"] = true
L["Class Trainer"] = true
L["Gossip"] = true
L["Class Icon"] = true
L["Deathknight"] = true
L["Evoker"] = true
L["Singing Sockets"] = true
L["Adds a Singing sockets selection tool on the Socketing Frame."] = true
L["Pet Filter Tab"] = true
L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."] = true

-- Tooltip
L["Your Status:"] = "你的状态: "
L["Your Status: Incomplete"] = "你的状态：未完成"
L["Your Status: Completed on "] = "您的状态：完成于"
L["Adds an icon for spells and items on your tooltip."] = "在鼠标提示中为法术和物品添加一个图标."
L["Adds an Icon for battle pets on the tooltip."] = "在鼠标提示中为战斗宠物添加一个图标."
L["Adds an Icon for the faction on the tooltip."] = "在鼠标提示中为阵营添加一个图标."
L["Adds information to the tooltip, on which char you earned an achievement."] =
	"在鼠标提示中增加一个信息,显示你在哪个角色上取得了成就."
L["Keystone"] = "大秘境钥匙"
L["Adds descriptions for mythic keystone properties to their tooltips."] =
	"鼠标提示中添加大米钥匙的词缀描述"
L["Title Color"] = "标题颜色"
L["Change the color of the title in the Tooltip."] = "改变鼠标提示中标题的颜色"
L["FACTION"] = "阵营"
L["Only Icons"] = "仅图标"
L["Use the new style tooltip."] = "使用新的鼠标提示外观，将腐蚀特效名称显示到腐蚀属性后。"
L["Display in English"] = "显示英语腐化特效名称"
L["Show icon"] = "显示图标"
L["Show the spell icon along with the name."] = "在腐化特效名称前显示其图标。"
L["Domination Rank"] = "統御等級"
L["Show the rank of shards."] = "显示统御碎片的等级."
L["Pet Battle"] = true
L["Tooltip Icons"] = true
L["Pet Icon"] = true
L["Pet ID"] = true
L["Add an icon for indicating the type of the pet."] = true
L["Show battle pet species ID in tooltips."] = true
L["The modifer key to show additional information from %s."] = true
L["Display TargetTarget"] = true
L["Gradient Color"] = true
L["Colors the player names in a gradient instead of class color"] = true
L["Health Bar Y-Offset"] = true
L["Change the postion of the health bar."] = true
L["Health Text Y-Offset"] = true
L["Change the postion of the health text."] = true
L["Class Icon Style"] = true
L["Reference"] = true
L["Preview"] = true
L["Template"] = true
L["Please click the button below to read reference."] = true
L["Spec Icon"] = true
L["Show the icon of the specialization."] = true
L["Race Icon"] = true
L["Show the icon of the player race."] = true
L["Health Bar"] = true
L["Group Info"] = true

-- Notification
L["Notification"] = "通知"
L["Display a Toast Frame for different notifications."] = "为不同的通知显示一个提示框."
L["This is an example of a notification."] = "这是一个通知的示例."
L["Notification Mover"] = "通知"
L["%s slot needs to repair, current durability is %d."] = "%s 插槽需要修理, 当前耐久度是 %d."
L["You have %s pending calendar invite(s)."] = "你有 %s 待处理的日历邀请."
L["You have %s pending guild event(s)."] = "你有 %s 待处理的公会事件."
L['Event "%s" will end today.'] = '"%s" 活动今天结束.'
L['Event "%s" started today.'] = '"%s" 活动今天开始.'
L['Event "%s" is ongoing.'] = '"%s" 活动正在进行中.'
L['Event "%s" will end tomorrow.'] = '"%s" 活动明天结束.'
L["Here you can enable/disable the different notification types."] =
	"在这里，你可以启用/禁用不同的通知类型."
L["Enable Mail"] = "启用邮件"
L["Enable Vignette"] = "启用简介"
L["If a Rare Mob or a treasure gets spotted on the minimap."] = "如果在小地图上发现稀有精英或宝箱"
L["Enable Invites"] = "启用邀请"
L["Enable Guild Events"] = "启用公会活动"
L["No Sounds"] = "没有声音"
L["Vignette Print"] = true
L["Prints a clickable Link with Coords in the Chat."] = true
L["Quick Join"] = true
L["Title Font"] = true
L["Text Font"] = true
L["Debug Print"] = true
L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"] = true

-- DataTexts
L["|cffFFFFFFLeft Click:|r Open Character Frame"] = true
L["|cffFFFFFFRight Click:|r Summon Grand Expedition Yak"] = true

-- DataBars
L["DataBars"] = "数据条"
L["Add some stylish buttons at the bottom of the DataBars"] = "在数据条底部添加一些美观的按钮"
L["Style DataBars"] = "样式数据条"

-- PVP
L["Duels"] = "决斗"
L["Automatically cancel PvP duel requests."] = "自动取消决斗请求"
L["Automatically cancel pet battles duel requests."] = "自动取消宠物对战请求"
L["Announce in chat if duel was rejected."] = "当拒绝时在聊天栏通告"
L["MER_DuelCancel_REGULAR"] = "已拒绝来自 %s 的决斗请求."
L["MER_DuelCancel_PET"] = "已拒绝来自 %s 的宠物对战请求."
L["Show your PvP killing blows as a popup."] = "将PvP击杀弹出显示"
L["Sound"] = "声音"
L["Play sound when killing blows popup is shown."] = "当PvP击杀时播放音效"
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Check for rebirth mechanics"] = true
L["Do not release if reincarnation or soulstone is up."] = true

-- Actionbars
L["Specialization Bar"] = "专业条"
L["EquipSet Bar"] = "套装管理条"
L["Auto Buttons"] = "自动按钮"
L["Bind Font Size"] = "绑定字体大小"
L["Trinket Buttons"] = "饰品按钮"
L["Color by Quality"] = "品质颜色"
L["Quest Buttons"] = "任务按钮"
L["Blacklist Item"] = "黑名单物品"
L["Whitelist Item"] = "白名单物品"
L["Add Item ID"] = "添加物品ID"
L["Delete Item ID"] = "删除物品ID"
L["Spell Feedback"] = true
L["Creates a texture to show the recently pressed buttons."] = true
L["Frame Strata"] = true
L["Frame Level"] = true
L["KeyFeedback"] = true
L["Mirror"] = true
L["Mirror Button Size"] = true
L["Mirror Direction"] = true
L["LEFT"] = true
L["RIGHT"] = true

-- Armory
L["Armory"] = true
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = true
L["Enchant & Socket Strings"] = true
L["Settings for strings displaying enchant and socket info from the items"] = true
L["Enable/Disable the Enchant text display"] = true
L["Missing Enchants"] = true
L["Missing Sockets"] = true
L["Short Enchant Text"] = true
L["Enchant Font"] = true
L["Item Level"] = true
L["Settings for the Item Level next tor your item slot"] = true
L["Enable/Disable the Item Level text display"] = true
L["Toggle sockets & azerite traits"] = true
L["Item Quality Gradient"] = true
L["Settings for the color coming out of your item slot."] = true
L["Toggling this on enables the Item Quality bars."] = true
L["Start Alpha"] = true
L["End Alpha"] = true
L["Slot Item Level"] = true
L["Bags Item Level"] = true
L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."] = true
L["Format"] = true
L["Decimal format"] = true
L["Move Sockets"] = true
L["Crops and moves sockets above enchant text."] = true
L["Hide Controls"] = true
L["Hides the camera controls when hovering the character model."] = true
L["Add %d sockets"] = true
L["Add enchant"] = true
L["Attributes"] = true
L["Background"] = true
L["Alpha"] = true
L["Style"] = true
L["Change the Background image."] = true
L["Class Background"] = true
L["Use class specific backgrounds."] = true
L["Hide Controls"] = true
L["Hides the camera controls when hovering the character model."] = true
L["Animation"] = true
L["Animation Multiplier"] = true

-- AutoButtons
L["AutoButtons"] = "自动按键"
L["Bar"] = "动作条"
L["Only show the bar when you mouse over it."] = "鼠标滑过时显示"
L["Bar Backdrop"] = "动作条背景"
L["Show a backdrop of the bar."] = "为动作条显示一个背景."
L["Button Width"] = "按键宽度"
L["The width of the buttons."] = "按键的宽度"
L["Button Height"] = "按键高度"
L["The height of the buttons."] = "按键的高度"
L["Counter"] = "计数"
L["Button Groups"] = "按键组"
L["Key Binding"] = "按键绑定"
L["Custom Items"] = "自订物品"
L["List"] = "列表"
L["New Item ID"] = "新物品ID"
L["Auto Button Bar"] = "自动按键动作条"
L["Quest Items"] = "任务物品"
L["Equipments"] = "装备"
L["Potions"] = "药水"
L["Flasks"] = "合剂"
L["Food"] = "食物"
L["Crafted by mage"] = "由法师制作"
L["Banners"] = "战旗"
L["Utilities"] = "实用"
L["Fade Time"] = "淡入时间"
L["Alpha Min"] = "最小透明度"
L["Alpha Max"] = "最大透明度"
L["Inherit Global Fade"] = true
L["Anchor Point"] = true
L["The first button anchors itself to this point on the bar."] = true
L["Dream Seeds"] = true
L["Reset the button groups of this bar."] = true
L["Holiday Reward Boxes"] = true

-- Media
L["Zone Text"] = "区域文字"
L["Font Size"] = "字体大小"
L["Subzone Text"] = "子区域文字"
L["PvP Status Text"] = "PvP 状态文字"
L["Misc Texts"] = "杂项文字"
L["Mail Text"] = "邮件文字"
L["Chat Editbox Text"] = "聊天输入框文字"
L["Gossip and Quest Frames Text"] = "聊天及任务界面文字"
L["Objective Tracker Header Text"] = "任务追踪标题文字"
L["Objective Tracker Text"] = "任务追踪文字"
L["Banner Big Text"] = "横幅文字"
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
L["Adds a shadow to the debuffs that the debuff color is more visible."] =
	"在Debuff图标外添加阴影以便更清楚的分辨Debuff类型"
L["Swing Bar"] = "普攻计时条"
L["Creates a weapon Swing Bar"] = "创建一个普攻计时条"
L["Main-Hand Color"] = "主手颜色"
L["Off-Hand Color"] = "副手颜色"
L["Two-Hand Color"] = "双手颜色"
L["Creates a Global Cooldown Bar"] = "创建一个公共CD计时条"
L["UnitFrame Style"] = "头像样式"
L["Adds my styling to the Unitframes if you use transparent health."] =
	"当你使用透明头像时，添加Merathilis风格"
L["Change the default role icons."] = "替换默认职责图标"
L["Changes the Heal Prediction texture to the default Blizzard ones."] =
	"将治疗预估材质替换为暴雪默认样式"
L["Add a glow in the end of health bars to indicate the over absorb."] =
	"在生命条的末端添加发光来表示过量吸收."
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] =
	"为 ElvUI 单位框体添加暴雪风格的过量吸收发光和叠加层."
L["Auto Height"] = "自动高度"
L["Blizzard Absorb Overlay"] = "暴雪吸收覆盖层"
L["Blizzard Over Absorb Glow"] = "暴雪过量吸收发光"
L["Blizzard Style"] = "暴雪样式"
L["Change the color of the absorb bar."] = "修改吸收条的颜色."
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = "启用 ElvUI 吸收条材质替换."
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] =
	"这里有一些按钮帮助你一键更改所有吸收条的设置."
L["Max Overflow"] = "最大治疗吸收盾"
L["Modify the texture of the absorb bar."] = "修改吸收条材质."
L["Overflow"] = "溢出"
L["Set %s to %s"] = "设置 %s 为 %s"
L["Set All Absorb Style to %s"] = "设置全部吸收样式为 %s"
L["The absorb style %s and %s is highly recommended with %s tweaks."] =
	"非常推荐使用 %s 和 %s 的吸收风格来和 %s的修改进行搭配显示."
L["The selected texture will override the ElvUI default absorb bar texture."] =
	"选定的材质会覆盖 ElvUI 默认吸收材质."
L["Use the texture from Blizzard Raid Frames."] = "使用暴雪团队框架中的材质."
L["Raid Icon"] = true
L["Change the default raid icons."] = true
L["Highlight"] = true
L["Adds an own highlight to the Unitframes"] = true
L["Auras"] = true
L["Adds an shadow around the auras"] = true
L["Power"] = true
L["Enable the animated Power Bar"] = true
L["Select Model"] = true
L["Type the Model ID"] = true
L["Role Icons"] = true
L["Heal Prediction"] = true
L["Add an additional overlay to the absorb bar."] = true

-- Maps
L["Maps"] = true
L["World Map"] = true
L["Duration"] = true
L["Fade Out"] = true
L["Scale"] = true
L["Hide Blizzard"] = true
L["Change the shape of ElvUI minimap."] = true
L["Height Percentage"] = true
L["Percentage of ElvUI minimap size."] = true
L["MiniMap"] = "小地图"
L["MiniMap Buttons"] = "小地图按钮"
L["Minimap Ping"] = "小地图点击"
L["Add Server Name"] = "添加服务器名称"
L["Only In Combat"] = "仅在战斗中"
L["Fade-In"] = "淡入"
L["The time of animation. Set 0 to disable animation."] = "时间动画. 设置为0来关闭动画"
L["Blinking Minimap"] = "小地图边框闪亮"
L["Enable the blinking animation for new mail or pending invites."] =
	"为新邮件或等待的邀请启用闪光动画."
L["Super Tracker"] = "超级追踪"
L["Description"] = "描述"
L["Additional features for waypoint."] = "为标记点添加额外功能."
L["Auto Track Waypoint"] = "自动追踪标记"
L["Auto track the waypoint after setting."] = "在设定标记后自动进行追踪."
L["Middle Click To Clear"] = true
L["Middle click the waypoint to clear it."] = true
L["No Distance Limitation"] = "无距离限制"
L["Force to track the target even if it over 1000 yds."] = "强制追踪超过 1000 码的目标."
L["Distance Text"] = "距离文字"
L["Only Number"] = "仅数字"
L["Add Command"] = "添加命令"
L["Add a input box to the world map."] = "在世界地图中添加一个输入框."
L["Are you sure to delete the %s command?"] = "你确定要删除 %s 命令?"
L["Can not set waypoint on this map."] = "无法在这个地图上设置路径点."
L["Command"] = "命令"
L["Command Configuration"] = "命令设置"
L["Command List"] = "命令列表"
L["Delete Command"] = "删除命令"
L["Delete the selected command."] = "删除选中的命令."
L["Enable to use the command to set the waypoint."] = "启用使用命令设置路径点的功能."
L["Go to ..."] = "前往 ..."
L["Input Box"] = "输入框"
L["New Command"] = "新命令"
L["No Arg"] = "无参数"
L["Smart Waypoint"] = "智能路径点"
L["The argument is invalid."] = "参数无效."
L["The argument is needed."] = "需要参数."
L["The command to set a waypoint."] = "设置路径点的命令."
L["The coordinates contain illegal number."] = "坐标包含非法数字."
L["Waypoint %s has been set."] = "已设置 %s 路径点."
L["Waypoint Parse"] = "路径点解析"
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] =
	"你可以在这里粘贴任何包含坐标的文字, 然后按 回车键 设置路径点."
L["illegal"] = "非法"
L["invalid"] = "无效"
L["Because of %s, this module will not be loaded."] = true
L["This module will help you to reveal and resize maps."] = true
L["Reveal"] = true
L["Use Colored Fog"] = true
L["Remove Fog of War from your world map."] = true
L["Style Fog of War with special color."] = true
L["Resize world map."] = true
L["LFG Queue"] = true
L["Right click to switch expansion"] = true
L["Add trackers for world events in the bottom of world map."] = true
L["Alert"] = true
L["Alert Second"] = true
L["Alert will be triggered when the remaining time is less than the set value."] = true
L["Community Feast"] = true
L["Cooking"] = true
L["Dragonbane Keep"] = true
L["Duration"] = true
L["Event Tracker"] = true
L["Feast"] = true
L["In Progress"] = true
L["Location"] = true
L["Siege On Dragonbane Keep"] = true
L["Status"] = true
L["Waiting"] = true
L["Weekly Reward"] = true
L["%s will be started in %s!"] = true
L["Next Event"] = true
L["Stop Alert if Completed"] = true
L["Stop alert when the event is completed in this week."] = true
L["Alert Sound"] = true
L["Play sound when the alert is triggered."] = true
L["Sound File"] = true
L["Only DF Character"] = true
L["Stop alert when the player have not entered Dragonlands yet."] = true
L["The offset of the frame from the bottom of world map. (Default is -3)"] = true
L["Alert Timeout"] = true
L["All nets can be collected"] = true
L["Can be collected"] = true
L["Can be set"] = true
L["Fishing Net"] = true
L["Fishing Nets"] = true
L["Iskaaran Fishing Net"] = true
L["Net #%d"] = true
L["Net %s can be collected"] = true
L["No Nets Set"] = true
L["Custom String"] = "自定义字符串"
L["Custom Strings"] = "自定义字符串"
L["Custom color can be used by adding the following code"] = true
L["Difficulty"] = "难度"
L["M+ Level"] = "M+ 等级"
L["Number of Players"] = "玩家数量"
L["Placeholders"] = "占位符"
L["Use Default"] = "使用默认"
L["Researchers Under Fire"] = true
L["Time Rift"] = true
L["Superbloom"] = true
L["Big Dig"] = true
L["The Big Dig"] = true
L["Horizontal Spacing"] = true
L["Show a backdrop of the trackers."] = true
L["The Y-Offset of the backdrop."] = true
L["The height of the tracker."] = true
L["The spacing between the backdrop and the trackers."] = true
L["The spacing between the tracker and the world map."] = true
L["The spacing between trackers."] = true
L["The width of the tracker."] = true
L["Vertical Spacing"] = true
L["Click to show location"] = true
L["Current Location"] = "当前位置"
L["Echoes"] = "回响"
L["Next Location"] = "下次位置"
L["Radiant Echoes"] = "光耀回响"
L["Performing"] = true
L["Theater Troupe"] = true
L["Nightfall"] = true
L["Running"] = true
L["Khaz Algar Emissary"] = true
L["Professions Weekly"] = true
L["Ringing Deeps"] = true
L["Spreading The Light"] = true
L["Underworld Operative"] = true
L["World Soul"] = true
L["Rectangle Minimap"] = true
L["Expansion Landing Page"] = true
L["Instance Difficulty"] = true
L["Reskin the instance diffculty in text style."] = true
L["Text Align"] = true
L["Hide Blizzard Indicator"] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true
L["Minimap Coords"] = true
L["Add coords to your Minimap."] = true

-- SMB
L["Minimap Buttons"] = "小地图按钮"
L["Add an extra bar to collect minimap buttons."] = "添加一个额外的条来收集小地图图标."
L["Toggle minimap buttons bar."] = "开关小地图按钮条."
L["Mouse Over"] = "鼠标滑过显示"
L["Only show minimap buttons bar when you mouse over it."] = "只在鼠标滑过时显示小地图按钮条."
L["Minimap Buttons Bar"] = "小地图按钮条"
L["Bar Backdrop"] = "条背景"
L["Show a backdrop of the bar."] = "为条添加一个背景."
L["Backdrop Spacing"] = "背景间距"
L["The spacing between the backdrop and the buttons."] = "背景与按钮之间的间隙."
L["Inverse Direction"] = "反向"
L["Reverse the direction of adding buttons."] = "反转添加按钮时的方向."
L["Orientation"] = "按钮对齐方向"
L["Arrangement direction of the bar."] = "条的成长方向."
L["Drag"] = "拖拽"
L["Horizontal"] = "水平"
L["Vertical"] = "垂直"
L["Buttons"] = "按钮数"
L["Buttons Per Row"] = "每行按钮数"
L["The amount of buttons to display per row."] = "每行显示多少个按钮数"
L["Button Size"] = "按钮大小"
L["The size of the buttons."] = "按钮的大小."
L["Button Spacing"] = "按钮间距"
L["The spacing between buttons."] = "两个按钮间的距离."
L["Blizzard Buttons"] = "暴雪按钮"
L["Calendar"] = "日历"
L["Add calendar button to the bar."] = "添加日历按钮到条上."
L["Garrison"] = "要塞"
L["Add garrison button to the bar."] = "添加要塞按钮到条上."

-- Raid Marks
L["Raid Markers"] = "团队标记"
L["Raid Markers Bar"] = "团队标记条"
L["Raid Utility"] = "团队工具"
L["Left Click to mark the target with this mark."] = "左键点击以标记目标"
L["Right Click to clear the mark on the target."] = "右键点选以清除目标的标记."
L["%s + Left Click to place this worldmarker."] = "%s + 左键点击 放置这个光柱."
L["%s + Right Click to clear this worldmarker."] = "%s + 右键点击 清除这个光柱."
L["%s + Left Click to mark the target with this mark."] = "%s + 点击 以标记目标"
L["%s + Right Click to clear the mark on the target."] = "%s + 右键点选 以清除目标的标记"
L["Click to clear all marks."] = "点选清除所有标记"
L["takes 3s"] = "需 3 秒"
L["%s + Click to remove all worldmarkers."] = "%s + 点击 清除所有光柱."
L["Click to remove all worldmarkers."] = "点击清除所有光柱."
L["%s + Click to clear all marks."] = "%s + 点击 清除所有标记"
L["Left Click to ready check."] = "左键点击: 团队确认"
L["Right click to toggle advanced combat logging."] = "右键点击: 开关高级战斗记录."
L["Left Click to start count down."] = "左键点击: 开始倒数."
L["Add an extra bar to let you set raid markers efficiently."] =
	"添加一个额外的条让你更加效率得设定团队标记."
L["Toggle raid markers bar."] = "开关团队标记条."
L["Inverse Mode"] = "反向模式"
L["Swap the functionality of normal click and click with modifier keys."] =
	"对调正常点击和按下修饰键时点击的功能."
L["Visibility"] = "可见性"
L["In Party"] = "在小队中"
L["Always Display"] = "总是显示"
L["Mouse Over"] = "鼠标滑过显示"
L["Only show raid markers bar when you mouse over it."] = "只在鼠标滑过时显示团队标记条."
L["Tooltip"] = "鼠标提示"
L["Show the tooltip when you mouse over the button."] = "在鼠标悬浮时添加提示."
L["Modifier Key"] = "组合键"
L["Set the modifier key for placing world markers."] = "设定标示团队光柱的组合键"
L["Shift Key"] = "Shift 键"
L["Ctrl Key"] = "Ctrl 键"
L["Alt Key"] = "Alt 键"
L["Bar Backdrop"] = "条背景"
L["Show a backdrop of the bar."] = "为条添加一个背景."
L["Backdrop Spacing"] = "背景间距"
L["The spacing between the backdrop and the buttons."] = "背景与按钮之间的间隙."
L["Orientation"] = "按钮对齐方向"
L["Arrangement direction of the bar."] = "条的成长方向."
L["Raid Buttons"] = "Raid 按钮"
L["Ready Check"] = "准备确认"
L["Advanced Combat Logging"] = "高级战斗记录"
L["Left Click to ready check."] = "左键点击: 团队确认"
L["Right click to toggle advanced combat logging."] = "右键点击: 开关高级战斗记录."
L["Count Down"] = "倒数"
L["Count Down Time"] = "倒数时间"
L["Count down time in seconds."] = "倒数时间秒数."
L["Button Size"] = "按钮大小"
L["The size of the buttons."] = "按钮的大小."
L["Button Spacing"] = "按钮间距"
L["The spacing between buttons."] = "两个按钮间的距离."
L["Button Backdrop"] = "按钮背景"
L["Button Animation"] = "按钮动画"

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
L["Cooldowns"] = true
L["Cooldown Flash"] = "冷却闪光"
L["Settings"] = "设置"
L["Fadein duration"] = "淡入持续时间"
L["Fadeout duration"] = "淡出持续时间"
L["Duration time"] = "持续时间"
L["Animation size"] = "动画大小"
L["Watch on pet spell"] = "观看宠物法术"
L["Transparency"] = "透明度"
L["Test"] = "测试"
L["RaidCD"] = "团队技能CD"
L["Sort Upwards"] = "向上排序"
L["Sort by Expiration Time"] = "根据剩余时间排序"
L["Show Self Cooldown"] = "显示自身冷却"
L["Show Icons"] = "显示图标"
L["Show In Party"] = "在小队中显示"
L["Show In Raid"] = "在团队中显示"
L["Show In Arena"] = "在竞技场中显示"
L["Spell Name"] = true
L["Spell List"] = true

-- CVars
L["\n\nDefault: |cff00ff001|r"] = "\n\n默认: |cff00ff00开|r"
L["\n\nDefault: |cffff00000|r"] = "\n\n默认: |cffff0000关|r"
L["alwaysCompareItems"] = "总是比较物品"
L["alwaysCompareItems_DESC"] = "总是显示比较物品鼠标提示\r\r默认: |cffff0000关|r"
L["breakUpLargeNumbers"] = "缩写数字"
L["breakUpLargeNumbers_DESC"] = "缩写大数字\r\r默认: |cff00ff00开|r"
L["scriptErrors"] = "脚本报错"
L["enableWoWMouse"] = "启用WoW鼠标"
L["trackQuestSorting"] = "任务追踪排序"
L["trackQuestSorting_DESC"] = "新追踪的任务在任务追踪列表的位置 \r\r 默认: top"
L["autoLootDefault"] = "自动拾取"
L["autoDismountFlying"] = "自动取消飞行坐骑"
L["removeChatDelay"] = "移除聊天延时"
L["screenshotQuality"] = "截图质量"
L["screenshotQuality_DESC"] = "截图质量\r\r默认: |cff00ff003|r"
L["showTutorials"] = "显示教程"
L["World Text Scale"] = "世界文字尺寸"
L["WorldTextScale_DESC"] = "游戏世界中伤害数字、经验获取、神器获得等字体的尺寸\r\r默认: 1.0"
L["floatingCombatTextCombatDamageDirectionalScale"] = "直接伤害文字速度"
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] =
	"直接伤害文字移动速度 (禁用 = 无数字)\r\r默认: |cff00ff001|r"

-- GMOTD
L["Display the Guild Message of the Day in an extra window, if updated."] =
	"如果有更新，则在额外的窗口中显示当天的公会信息."

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
L["Castbar Shield"] = "施法条盾牌"
L["Show a shield icon on the castbar for non interruptible spells."] =
	"在不可打断的法术图标上添加盾牌图标"
L["Enhanced NameplateAuras"] = "增强姓名板光环"
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] =
	"|cffFF0000注意:|r 这会覆盖 ElvUI 姓名板 Buff/Debuffs 的长宽设置. 控制技能的图标大小固定为: 32 x 32"

-- Install
L["Welcome"] = "欢迎"
L["|cffff7d0aMerathilisUI|r Installation"] = "|cffff7d0aMerathilisUI|r安装"
L["MerathilisUI Set"] = "MerathilisUI设置"
L["MerathilisUI didn't find any supported addons for profile creation"] =
	"MerathilisUI没有找到任何支持的插件用于配置文件创建."
L["MerathilisUI successfully created and applied profile(s) for:"] =
	"MerathilisUI成功创建并应用了个人配置为:"
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
L["Welcome to MerathilisUI |cff00c0faVersion|r %s, for ElvUI %s."] =
	"欢迎来到MerathilisUI |cff00c0faVersion|r %s, 适用于ElvUI %s."
L["By pressing the Continue button, MerathilisUI will be applied in your current ElvUI installation.\r\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] =
	"按下继续按钮，MerathilisUI将应用于您当前的ElvUI安装.\r\r|cffff8000 小窍门: 防止你不喜欢这个结果，你应该在新的配置文件中应用这个更改.|r"
L["Buttons must be clicked twice"] = "按钮需要点击两次"
L["Importance: |cffff0000Very High|r"] = "重要性: |cffff0000非常高|r"
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] =
	"插件'AddOnSkins'未启用.没有设置被更改."
L["The Addon 'Big Wigs' is not enabled. Profile not created."] = "插件'Big Wigs'未启用.未创建配置文件."
L["The AddOn 'ElvUI_BenikUI' is not enabled. No settings have been changed."] =
	"插件'ElvUI_BenikUI'未启用.没有设置被更改."
L["The AddOn 'ElvUI_SLE' is not enabled. No settings have been changed."] =
	"插件'ElvUI_SLE'未启用.没有设置被更改."
L["The Addon 'Skada' is not enabled. Profile not created."] = "插件'Skada'未启用.未创建配置文件."
L["This part of the installation process sets up your chat fonts and colors."] =
	"安装过程的此部分设置您的聊天字体和颜色."
L["This part of the installation changes the default ElvUI look."] =
	"安装过程的此部分更改了默认的ElvUI外观."
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] =
	"这部分安装过程将填充MerathilisUI数据文本.\r|cffff8000这不会触及ElvUI数据文本|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] =
	"这部分安装过程将重新布局您的动作条并启用背景"
L["This part of the installation process will change your NamePlates."] = true
L["This part of the installation process will reposition your Unitframes."] =
	"这部分安装过程将重新布局您的单位框体."
L["This part of the installation process will apply changes to ElvUI Plugins"] =
	"这部分安装过程将对ElvUI插件应用更改"
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] =
	"此步骤更改了一些魔兽世界的默认选项.这些选项是根据%s作者的需求量身定制的,并不是此配置功能所必需的(一些cvar的修改)"
L["Please click the button below to apply the new layout."] = "请单击下面的按钮以应用新布局."
L["Please click the button below to setup your chat windows."] = "请单击下面的按钮设置聊天窗口."
L["Please click the button below to setup your actionbars."] = "请单击下面的按钮设置动作条."
L["Please click the button below to setup your datatexts."] = "请单击下面的按钮来设置数据文本."
L["Please click the button below to setup your NamePlates."] = true
L["Please click the button below to setup your Unitframes."] = "请单击下面的按钮设置单位框架."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] =
	"请单击下面的按钮以设置ElvUI AddOns.对于其他Addon配置文件,请进入我的选项 - 皮肤/插件"
L["DataTexts"] = "数据文本"
L["General Layout"] = true
L["Setup ActionBars"] = true
L["Setup NamePlates"] = true
L["Setup UnitFrames"] = true
L["Setup Datatexts"] = "设置数据文本"
L["Setup Addons"] = "设置插件"
L["ElvUI AddOns"] = "ElvUI 插件"
L["Finish"] = "完成"
L["Installed"] = "安装"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] =
	"您的ElvUI版本比推荐使用|cffff7d0aMerathilisUI|r的版本旧. 你的版本是 |cff00c0fa%.2f|r (推荐版本 |cff00c0fa%.2f|r). MerathilisUI未加载. 请更新你的ElvUI."
L["MSG_MER_ELV_MISMATCH"] =
	"Your ElvUI version is higher than expected. Please update MerathilisUI or you might run into issues or |cffFF0000having it already|r."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] =
	"你已经同时启用了Location Plus和Shadow＆Light.选择要禁用的插件"
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[在这里,您可以选择S＆L的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[在这里,您可以选择BigWigs的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[在这里,您可以选择Deadly Boss Mods的布局.]]
L["MER_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[在这里,您可以选择Details!的布局.]]
L["Name for the new profile"] = "新配置文件的名称"
L["Are you sure you want to override the current profile?"] = "您确定要覆盖当前的配置吗？"

-- Skins
L["AddOnSkins"] = "插件皮肤"
L["MER_SKINS_DESC"] = [[此部分旨在增强ElvUI中存在的外观.

请注意，如果相应的皮肤在主要的ElvUI皮肤部分中的|cff636363被禁用|r,则其中一些选项将不可用.]]
L["MER_ADDONSKINS_DESC"] = [[此部分旨在修改一些外部插件外观.

请注意，如果插件控制面板中未加载插件，其中一些选项将|cff636363被禁用|r.]]
L["Creates decorative stripes and a gradient on some frames"] = "在一些框架上创建条纹材质和渐变"
L["MerathilisUI Style"] = "MerathilisUI 样式"
L["Screen Shadow Overlay"] = true
L["Undress Button"] = "解除装备按钮"
L["Subpages"] = "子页面"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] =
	"子页面有10个物品, 这个选项设置了一页里有多少子页面"
L["Enable/Disable"] = "启用/禁用"
L["decor."] = "装饰"
L["Enables/Disables a shadow overlay to darken the screen."] = true
L["MerathilisUI Button Style"] = true
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = true
L["Additional Backdrop"] = "额外背景"
L["Remove Border Effect"] = "移除边框效果"
L["Animation Type"] = "动画类型"
L["The type of animation activated when a button is hovered."] = "当按钮被滑过时的动画类型."
L["Animation Duration"] = "动画时间"
L["The duration of the animation in seconds."] = "动画持续时间 (秒)."
L["Backdrop Class Color"] = "背景职业颜色"
L["Border Class Color"] = "边框职业颜色"
L["Border Color"] = "边框颜色"
L["Normal Class Color"] = "正常职业颜色"
L["Selected Backdrop & Border"] = "选中时背景和边框"
L["Selected Class Color"] = "选中职业颜色"
L["Selected Color"] = "选中颜色"
L["Tab"] = "选项卡"
L["Tree Group Button"] = "树状分组按钮"
L["Shadow Color"] = true
L["These skins will affect all widgets handled by ElvUI Skins."] = true
L["Texture"] = true
L["Backdrop Color"] = true
L["Check Box"] = true
L["Slider"] = true
L["Backdrop Alpha"] = true
L["Enable All"] = true
L["Disable All"] = true
L["Spellbook"] = true
L["Character Frame"] = true
L["Gossip Frame"] = true
L["Quest Frames"] = true
L["TALENTS"] = true
L["AUCTIONS"] = true
L["FRIENDS"] = true
L["GUILD"] = true
L["Mail Frame"] = true
L["WORLD_MAP"] = true
L["Guild Control Frame"] = true
L["MACROS"] = true
L["GUILD_BANK"] = true
L["FLIGHT_MAP"] = true
L["Help Frame"] = true
L["Loot Frames"] = true
L["CHANNELS"] = true
L["Raid Frame"] = true
L["Craft"] = true
L["Event Toast Manager"] = true
L["Quest Choice"] = true
L["Orderhall"] = true
L["Contribution"] = true
L["Calendar Frame"] = true
L["Merchant Frame"] = true
L["PvP Frames"] = true
L["LF Guild Frame"] = true
L["TalkingHead"] = true
L["Minimap"] = true
L["Trainer Frame"] = true
L["Socket Frame"] = true
L["Item Upgrade"] = true
L["Trade"] = true
L["Allied Races"] = true
L["Archaeology Frame"] = true
L["Azerite Essence"] = true
L["Item Interaction"] = true
L["Anima Diversion"] = true
L["Soulbinds"] = true
L["Covenant Sanctum"] = true
L["Covenant Preview"] = true
L["Covenant Renown"] = true
L["Player Choice"] = true
L["Chromie Time"] = true
L["LevelUp Display"] = true
L["Guide Frame"] = true
L["Weekly Rewards"] = true
L["Misc"] = true
L["%s is not loaded."] = true
L["BigWigs Bars"] = true
L["BigWigs Skin"] = true
L["Color Override"] = true
L["Emphasized Bar"] = true
L["Gradient color of the left part of the bar."] = true
L["Gradient color of the right part of the bar."] = true
L["How to change BigWigs bar style:"] = true
L["Left Color"] = true
L["Normal Bar"] = true
L["Open BigWigs Options UI with /bw > Bars > Style."] = true
L["Override the bar color."] = true
L["Right Color"] = true
L["Show spark on the bar."] = true
L["Smooth"] = true
L["Smooth the bar animation with ElvUI."] = true
L["Spark"] = true
L["The options below are only for BigWigs %s bar style."] = true
L["You need to manually set the bar style to %s in BigWigs first."] = true
L["The options below is only for the Details look, NOT the Embeded."] = true
L["Action Status"] = true
L["Roll Result"] = true
L["It only works when you enable the skin (%s)."] = true
L["Loot"] = true
L["Embed Settings"] = true
L["With this option you can embed your Details into an own Panel."] = true
L["Reset Settings"] = true
L["Toggle Direction"] = true
L["TOP"] = true
L["BOTTOM"] = true
L["Advanced Skin Settings"] = true
L["Queue Timer"] = true
L["Gradient Bars"] = true
L["Open Details"] = true
L["Ease"] = true
L["Generally, enabling this option makes the value increase faster in the first half of the animation."] = true
L["Invert Ease"] = true
L["The easing function used for colorize the button."] = true
L["UI Widget"] = true

-- Panels
L["Panels"] = true
L["Top Panel"] = true
L["Bottom Panel"] = true
L["Style Panels"] = true
L["Top Left Panel"] = "左上面板"
L["Top Left Extra Panel"] = "左上额外面板"
L["Top Right Panel"] = "右上面板"
L["Top Right Extra Panel"] = "右上额外面板"
L["Bottom Left Panel"] = "左下面板"
L["Bottom Left Extra Panel"] = "左下额外面板"
L["Bottom Right Panel"] = "右下面板"
L["Bottom Right Extra Panel"] = "右下额外面板"

-- Objective Tracker
L["Objective Tracker"] = true
L["1. Customize the font of Objective Tracker."] = "1. 自定义任务追踪的字体."
L["2. Add colorful progress text to the quest."] = "2. 为任务添加彩色的进度文字."
L["Progress"] = "进度"
L["No Dash"] = "无标记"
L["Colorful Progress"] = "彩色进度"
L["Percentage"] = "百分比"
L["Add percentage text after quest text."] = "在任务文本后添加百分比文字."
L["Colorful Percentage"] = "彩色百分比"
L["Make the additional percentage text be colored."] = "使额外的百分比文字为彩色."
L["Cosmetic Bar"] = "装饰条"
L["Border"] = "边框"
L["Border Alpha"] = "边框透明度"
L["Width Mode"] = "宽度模式"
L["'Absolute' mode means the width of the bar is fixed."] = "'绝对' 模式意味着宽度是固定的."
L["'Dynamic' mode will also add the width of header text."] = "'动态' 模式将自动加上顶部文字的宽度."
L["'Absolute' mode means the height of the bar is fixed."] = "'绝对' 模式意味着高度是固定的."
L["'Dynamic' mode will also add the height of header text."] = "'动态' 模式将自动加上顶部文字的高度."
L["Absolute"] = "绝对"
L["Dyanamic"] = "动态"
L["Color Mode"] = "颜色模式"
L["Gradient"] = "渐变"
L["Class Color"] = "职业色"
L["Normal Color"] = "正常颜色"
L["Gradient Color 1"] = "渐变色 1"
L["Gradient Color 2"] = "渐变色 2"
L["Presets"] = "预设"
L["Preset %d"] = "%d 号预设"
L["Here are some example presets, just try them!"] = "这里有一些示例预设, 赶快试一试!"
L["Default"] = "默认"
L["Header"] = "顶部"
L["Short Header"] = "简短顶部"
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] =
	"使用简短名字替代, 比如 托加斯特,罪魂之塔 为 托加斯特."
L["Title Color"] = "标题颜色"
L["Change the color of quest titles."] = "修改任务标题文字颜色."
L["Use Class Color"] = "使用职业颜色"
L["Highlight Color"] = "高亮颜色"
L["Title"] = "标题"
L["Bottom Right Offset X"] = "右下角 X 偏移"
L["Bottom Right Offset Y"] = "右下角 Y 偏移"
L["Top Left Offset X"] = "左上角 X 轴偏移"
L["Top Left Offset Y"] = "左上角 Y 轴偏移"
L["Transparent"] = "透明"
L["Style"] = true
L["Height Mode"] = true
L["Menu Title"] = true
L["it shows when objective tracker is collapsed."] = true

-- Quest
L["Switch Buttons"] = true
L["Add a bar that contains buttons to enable/disable modules quickly."] = true
L["Hide With Objective Tracker"] = true
L["Bar Backdrop"] = true
L["Announcement"] = true
L["Quest"] = true
L["Turn In"] = true
L["Make quest acceptance and completion automatically."] = true
L["Mode"] = true
L["Only Accept"] = true
L["Only Complete"] = true
L["Pause On Press"] = true
L["Pause the automation by pressing a modifier key."] = true
L["Reward"] = true
L["Select Reward"] = true
L["If there are multiple items in the reward list, it will select the reward with the highest sell price."] = true
L["Get Best Reward"] = true
L["Complete the quest with the most valuable reward."] = true
L["Smart Chat"] = true
L["Chat with NPCs smartly. It will automatically select the best option for you."] = true
L["Dark Moon"] = true
L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."] = true
L["Follower Assignees"] = true
L["Open the window of follower recruit automatically."] = true
L["Ignored NPCs"] = true
L["If you add the NPC into the list, all automation will do not work for it."] = true
L["Ignore List"] = true
L["Add Target"] = true
L["Make sure you select the NPC as your target."] = true
L["Delete"] = true
L["Delete the selected NPC."] = true

-- Filter
L["Filter"] = "过滤器"
L["Unblock the profanity filter."] = "解锁语言过滤器."
L["Profanity Filter"] = "语言过滤器"
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] =
	"开启这个选项将解锁语言过滤器的设定.[国服]"

-- Friends List
L["Friends List"] = "好友列表"
L["Add additional information to the friend frame."] = "为好友框体添加额外的信息."
L["Modify the texture of status and make name colorful."] = "设定状态的材质, 彩色化名字."
L["Enhanced Texture"] = "材质增强"
L["Game Icons"] = "游戏图标"
L["Default"] = "默认"
L["Modern"] = "现代"
L["Status Icon Pack"] = "状态图标包"
L["Diablo 3"] = "暗黑破坏神 III"
L["Square"] = "方块"
L["Faction Icon"] = "阵营图标"
L["Use faction icon instead of WoW icon."] = "使用阵营图标来代替魔兽世界游戏图标."
L["Name"] = "姓名"
L["Level"] = "等级"
L["Hide Max Level"] = "隐藏满级"
L["Use Note As Name"] = "使用备注作为名字"
L["Replace the Real ID or the character name of friends with your notes."] =
	"使用你的备注替换好友的战网名或角色名."
L["Use Game Color"] = "使用游戏颜色"
L["Change the color of the name to the in-playing game style."] =
	"根据正在游玩的游戏的风格来改变姓名颜色."
L["Use Class Color"] = "使用职业颜色"
L["Font Setting"] = "字体设定"
L["Hide Realm"] = true
L["Hide the realm name of friends."] = true

-- Vehicle Bar
L["VehicleBar"] = true
L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."] = true
L["Thrill Color"] = true
L["The color for vigor bar's speed text when you are regaining vigor."] = true
L["Animations"] = true
L["Animation Speed"] = true
L["Skyriding Bar"] = true

-- Delete Item
L["Delete Item"] = true
L["This module provides several easy-to-use methods of deleting items."] = true
L["Use Delete Key"] = true
L["Allow you to use Delete Key for confirming deleting."] = true
L["Fill In"] = true
L["Disable"] = true
L["Fill by click"] = true
L["Auto Fill"] = true
L["Press the |cffffd200Delete|r key as confirmation."] = true
L["Click to confirm"] = true

-- Raid Info Frame
L["Raid Info Frame"] = true
L[" provides a Raid Info Frame that shows a list of players per role in your raid."] = true
L["Enable the Raid Info Frame."] = true
L["Temporarily shows the frame even outside of a raid for easier customization."] = true
L["Customization"] = true
L["Set the size of the text and icons."] = true
L["Padding"] = true
L["Set the outside padding of the frame."] = true
L["Set the spacing between the icons."] = true
L["Set the backdrop color of the frame."] = true
L["Change the look of the icons"] = true
L["Displays the current count of Tanks, Healers, and DPS in your raid group."] = true
L["|cffFFFFFFLeft Click:|r Toggle Raid Frame"] = true
L["|cffFFFFFFRight Click:|r Toggle Settings"] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[这个部分将为某些插件创建配置文件.

|cffff0000警告:|r 它将覆盖/删除已经存在的配置文件. 如果你不想应用我的配置，请不要按下面的按钮.]]
L[" Apply"] = true
L[" Reset"] = true
L["This group allows to update all fonts used in the "] = true
L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"] =
	true
L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true
L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."] = true

-- Advanced Settings
L["Advanced Settings"] = true
L["Blizzard Fixes"] = true
L["The message will be shown in chat when you login."] = true
L["CVar Alert"] = true
L["It will alert you to reload UI when you change the CVar %s."] = true
L["Fix LFG Frame error"] = true
L["Fix a PlayerStyle lua error that can happen on the LFG Frame."] = true
L["This section will help reset specfic settings back to default."] = true

-- Gradient colors
L["Custom Gradient Colors"] = true
L["Custom Nameplates Colors"] = true
L["Only used if using threat plates from ElvUI"] = true
L["Custom Unitframes Colors"] = true
L["Custom Power Colors"] = true
L["Runic Power"] = true

-- Addons
L["Skins & AddOns"] = "皮肤和插件"
L["Skins/AddOns"] = "皮肤/插件"
L["Profiles"] = "配置文件"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = "这将创建并应用配置文件"

-- Changelog
L["Changelog"] = "更新日志"

-- Compatibility
L["Compatibility Check"] = "兼容性检测"
L["Help you to enable/disable the modules for a better experience with other plugins."] =
	"为了更好的与其他插件兼容, 帮助你开启/禁用一些模块."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] =
	"不同的插件和 ElvUI 增强中有非常多的模块, 但其中部分模块功能是高度相似的."
L["Have a good time with %s!"] = "希望 %s 能让你玩得开心!"
L["Choose the module you would like to |cff00ff00use|r"] = "请选择你要|cff00ff00使用|r的模块"
L["If you find the %s module conflicts with another addon, alert me via Discord."] =
	"如果你发现 %s 的模块与其他插件冲突, 可以通过 Discord 来告知我."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] =
	"你可以通过设定位于 [MerathilisUI]-[信息] 底部的选项来启用/停用兼容性检查."
L["Complete"] = "完成"

-- Debug
L["Usage"] = "用法"
L["Enable debug mode"] = "启用除错模式"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] =
	"禁用除了 ElvUI 核心, ElvUI %s 和 BugSack 以外的插件."
L["Disable debug mode"] = "禁用除错模式"
L["Reenable the addons that disabled by debug mode."] = "重新启用调试模式时禁用的插件."
L["Debug Enviroment"] = "调试环境"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] =
	"你可以使用 |cff00ff00/muidebug off|r 命令来退出调试模式."
L["After you stop debuging, %s will reenable the addons automatically."] =
	"在你停止调试后, %s 将自动重新启用插件."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] =
	"在提交一个错误报告之前, 请先用 %s 命令启用调试模式并再测试一次."
L["Error"] = true
L["Warning"] = true

-- Abbreviate
L["[ABBR] Algeth'ar Academy"] = "学院"
L["[ABBR] Announcement"] = "通报"
L["[ABBR] Back"] = "披"
L["[ABBR] Challenge Level 1"] = "挑战"
L["[ABBR] Chest"] = "胸"
L["[ABBR] Community"] = "群"
L["[ABBR] Court of Stars"] = "群星"
L["[ABBR] Delves"] = "探究"
L["[ABBR] Dragonflight Keystone Hero: Season One"] = "钥石英雄 第一季"
L["[ABBR] Dragonflight Keystone Master: Season One"] = "钥石大师 第一季"
L["[ABBR] Emote"] = "情"
L["[ABBR] Event Scenario"] = "事件"
L["[ABBR] Feet"] = "脚"
L["[ABBR] Finger"] = "戒"
L["[ABBR] Follower"] = "追随者"
L["[ABBR] Guild"] = "会"
L["[ABBR] Halls of Valor"] = "英灵"
L["[ABBR] Hands"] = "手"
L["[ABBR] Head"] = "头"
L["[ABBR] Held In Off-hand"] = "副手"
L["[ABBR] Heroic"] = "H"
L["[ABBR] Instance"] = "副"
L["[ABBR] Instance Leader"] = "队长"
L["[ABBR] Legs"] = "腿"
L["[ABBR] Looking for Raid"] = "随机"
L["[ABBR] Mythic"] = "M"
L["[ABBR] Mythic Keystone"] = "大秘"
L["[ABBR] Neck"] = "项链"
L["[ABBR] Normal"] = "PT"
L["[ABBR] Normal Scaling Party"] = "普通調幅"
L["[ABBR] Officer"] = "官"
L["[ABBR] Party"] = "队"
L["[ABBR] Party Leader"] = "队长"
L["[ABBR] Path of Ascension"] = "晋升之路"
L["[ABBR] Quest"] = "任务"
L["[ABBR] Raid"] = "团"
L["[ABBR] Raid Finder"] = "随机"
L["[ABBR] Raid Leader"] = "RL"
L["[ABBR] Raid Warning"] = "团警"
L["[ABBR] Roll"] = "掷"
L["[ABBR] Ruby Life Pools"] = "红玉"
L["[ABBR] Say"] = "说"
L["[ABBR] Scenario"] = "场景"
L["[ABBR] Shadowmoon Burial Grounds"] = "墓地"
L["[ABBR] Shoulders"] = "肩"
L["[ABBR] Story"] = "故事"
L["[ABBR] Lorewalking"] = "漫游"
L["[ABBR] Teeming Island"] = "擁擠之島"
L["[ABBR] Temple of the Jade Serpent"] = "青龙"
L["[ABBR] The Azure Vault"] = "碧蓝"
L["[ABBR] The Nokhud Offensive"] = "诺库德"
L["[ABBR] Timewalking"] = "时光"
L["[ABBR] Torghast"] = "托加斯特"
L["[ABBR] Trinket"] = "饰"
L["[ABBR] Turn In"] = "交接"
L["[ABBR] Vault of the Incarnates"] = "牢窟"
L["[ABBR] Visions of N'Zoth"] = "幻象"
L["[ABBR] Waist"] = "腰"
L["[ABBR] Warfronts"] = "前线"
L["[ABBR] Whisper"] = "密"
L["[ABBR] Wind Emote"] = "情"
L["[ABBR] World"] = "世"
L["[ABBR] World Boss"] = "世界首领"
L["[ABBR] Wrist"] = "腕"
L["[ABBR] Yell"] = "喊"

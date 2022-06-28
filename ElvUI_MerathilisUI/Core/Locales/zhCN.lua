-- Simplified Chinese localization file for zhCN
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "zhCN")

-- Core
L[" is loaded. For any issues or suggestions, please visit "] = " 已加载。如有任何问题或建议，请访问 "

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L["AFK"] = "离开"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = "启用/禁用MUI AFK屏幕。如果加载了BenikUI，则禁用"
L["Are you still there? ... Hello?"] = "你还在吗？ ... 在吗？"
L["Logout Timer"] = "登出计时器"
L["SplashScreen"] = "闪屏"
L["Enable/Disable the Splash Screen on Login."] = "在登录时启用/禁用启动画面."
L["Options"] = "选项"
L["Desciption"] = "描述"
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r 是ElvUI的扩展. 它增加了:

- 大量新特性
- 一个整体的透明外观
- 重写了所有的ElvUI外观
- 我的个人布局

|cFF00c0faNote:|r 它与其他大多数ElvUI插件兼容.
但是如果你在我的之外安装了另一个布局，你必须手动调整它。.

|cffff8000Newest additions are marked with: |r]=]

-- Core Options
L["Login Message"] = "登陆信息"
L["Enable/Disable the Login Message in Chat"] = "在聊天框中启用/禁用登录消息"
L["Log Level"] = "日志等级"
L["Only display log message that the level is higher than you choose."] = "只显示高于选择等级的日志信息."
L["Set to 2 if you do not understand the meaning of log level."] = "如果你不理解什么是日志级别, 设置为 2 就行."

-- Bags
L["Equipment Manager"] = "装备管理"
L["Equipment Set Overlay"] = "套装文字"
L["Show the associated equipment sets for the items in your bags (or bank)."] = "为你背包(银行)中的物品显示关联的套装."

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "后退"
L["ERR_FRIEND_ONLINE"] = "|cff298F00上线|r."
L["ERR_FRIEND_OFFLINE"] = "|cffff0000离线|r."
L["BN_INLINE_TOAST_FRIEND_ONLINE"] = "|cff298F00上线|r."
L["BN_INLINE_TOAST_FRIEND_OFFLINE"] = "|cffff0000离线|r."
L["has come |cff298F00online|r."] = "|cff298F00上线|r." -- Guild Message
L["has gone |cffff0000offline|r."] = "|cffff0000离线|r." -- Guild Message
L[" has come |cff298F00online|r."] = "|cff298F00上线|r." -- Battle.Net Message
L[" has gone |cffff0000offline|r."] = "|cffff0000离线|r." -- Battle.Net Message
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
L["Adds an overlay to the Community Chat. Useful for streamers."] = "在社区聊天内容上添加一个遮罩，对主播很有用"
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
L["Add extra information on the link, so that you can get basic information but do not need to click"] = "为链接添加额外信息, 这样你就可以不通过点击也能获取到基础信息"
L["Additional Information"] = "额外信息"
L["Level"] = "等级"
L["Translate Item"] = "翻译物品"
L["Translate the name in item links into your language."] = "将物品链接中的名称翻译为你的语言."
L["Icon"] = "图标"
L["Armor Category"] = "护甲分类"
L["Weapon Category"] = "武器分类"
L["Filters some messages out of your chat, that some Spam AddOns use."] = true

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

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = "你能在这里找到所有不同的选项 |cffffffffMerathilis|r|cffff8000UI|r 模块."
L["Are you sure you want to reset %s module?"] = "你确定要重置 %s 模块么?"
L["Reset All Modules"] = "重置全部模块"
L["Reset all %s modules."] = "重置全部 %s 模块."

-- GameMenu
L["GameMenu"] = "游戏菜单"
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] = "从暴雪游戏菜单启用/禁用MerathilisUI样式."

-- Extended Vendor
L["Extended Vendor"] = true
L["Enhanced NameplateAuras"] = "增强姓名板光环"

-- FlightMode
L["FlightMode"] = "飞行模式"
L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."] = "增强 |cff00c0faBenikUI|r 的飞行模式, 如需完全禁用飞行模式, 请前往 |cff00c0faBenikUI|r 选项."
L["Exit FlightMode"] = "退出飞行模式"
L["Left Click to Request Stop"] = "左键点击来请求停止"

-- FlightPoint
L["Flight Point"] = "飞行点"
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = "在飞行地图上启用/禁用MerathilisUI飞行点."

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

-- MicroBar
L["Backdrop"] = "背景"
L["Backdrop Spacing"] = "背景间距"
L["The spacing between the backdrop and the buttons."] = "背景和按键间的间距."
L["Time Width"] = "时间宽度"
L["Time Height"] = "时间高度"
L["The spacing between buttons."] = "按键间的间距"
L["The size of the buttons."] = "按键大小"
L["Slow Mode"] = "慢速模式"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = "以更慢的时间(10秒)更新额外文字"
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
L["Undress"] = "解除装备"
L["Flashing Cursor"] = "鼠标闪光"
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
L["Press CTRL + C to copy."] = "按下 CTRL + C 复制"
L["Wowhead Links"] = "Wowhead 链接"
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = "在成就和地图框体上添加 Wowhead 链接"
L["Highest Quest Reward"] = "最贵任务奖励"
L["Automatically select the item with the highest reward."] = "自动选中最贵任务奖励"
L["Item Alerts"] = "物品通告"
L["Announce in chat when someone placed an usefull item."] = "当有玩家放置某些物品时将在聊天栏通知"
L["Maw ThreatBar"] = true
L["Replace the Maw Threat Display, with a simple StatusBar"] = true
L.ANNOUNCE_FP_PRE = "{rt1} %s 放置了 %s {rt1}"
L.ANNOUNCE_FP_CLICK = "{rt1} %s 正在开启 %s... 请点击 ! {rt1}"
L.ANNOUNCE_FP_USE = "{rt1} %s 使用了 %s。 {rt1}"
L.ANNOUNCE_FP_CAST = "{rt1} %s 开启了 %s {rt1}"

-- Tooltip
L["Your Status:"] = "你的状态: "
L["Your Status: Incomplete"] = "你的状态：未完成"
L["Your Status: Completed on "] = "您的状态：完成于"
L["Adds an icon for spells and items on your tooltip."] = "在鼠标提示中为法术和物品添加一个图标."
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
L["LFR"] = "寻求组队"
L["Uldir"] = "奥迪尔"
L["BattleOfDazaralor"] = "达萨罗之战"
L["CrucibleOfStorms"] = "风暴熔炉"
L["EternalPalace"] = "永恒王宫"
L["Nyalotha"] = "尼奥罗萨"
L["Castle Nathria"] = "纳斯利亚堡"
L["Sanctum of Domination"] = "统御圣所"
L["FACTION"] = "阵营"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "已激活的艾泽里特之力"
L["Only Icons"] = "仅图标"
L["I"] = "1 级"
L["II"] = "2 级"
L["III"] = "3 级"
L["Use the new style tooltip."] = "使用新的鼠标提示外观，将腐蚀特效名称显示到腐蚀属性后。"
L["Display in English"] = "显示英语腐化特效名称"
L["Show icon"] = "显示图标"
L["Show the spell icon along with the name."] = "在腐化特效名称前显示其图标。"
L["Domination Rank"] = "統御等級"
L["Show the rank of shards."] = "显示统御碎片的等级."
L["Covenant: <Not in Group>"] = true
L["Covenant: <Checking...>"] = true
L["Covenant: <None - Too low>"] = true
L["Covenant"] = "盟约"
L["Covenant: "] = true
L["Shows the Players Covenant on the Tooltip."] = true
L["Show not in group"] = true
L["Keep the Covenant Line when not in a group. Showing: <Not in Group>"] = true
L["Kyrian"] = "格里恩"
L["Venthyr"] = "温西尔"
L["NightFae"] = "法夜"
L["Necrolord"] = "通灵领主"

-- Notification
L["Notification"] = "通知"
L["Display a Toast Frame for different notifications."] = "为不同的通知显示一个提示框."
L["This is an example of a notification."] = "这是一个通知的示例."
L["Notification Mover"] = "通知"
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
L["Outline"] = "描边"
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

-- Armory
L["Armory"] = "角色界面"
L["ARMORY_DESC"] = [=[这个 |cffff7d0aArmory 模式|r只对ElvUI'显示人物信息'有效. 你可能需要重载你的UI:

ElvUI - 常规 - BlizzUI改进 - 显示人物信息.]=]
L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."] = "启用/禁用|cffff7d0aMerathilisUI|r Armory模式"
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
L["Slot Gradient"] = "槽渐变"
L["Shows a gradiation texture on the Character Slots."] = "为角色的物品槽显示一个渐变的材质."
L["Indicators"] = "指示器"
L["Transmog"] = "幻化"
L["Shows an arrow indictor for currently transmogrified items."] = "为当前幻化的物品显示一个箭头指示器."
L["Illusion"] = "幻象"
L["Shows an indictor for weapon illusions."] = "为武器幻象显示一个指示器"
L["Empty Socket"] = true
L["Not Enchanted"] = true
L["Warnings"] = true
L["Shows an indicator for missing sockets and enchants."] = true

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
L["Adds a shadow to the debuffs that the debuff color is more visible."] = "在Debuff图标外添加阴影以便更清楚的分辨Debuff类型"
L["Swing Bar"] = "普攻计时条"
L["Creates a weapon Swing Bar"] = "创建一个普攻计时条"
L["Main-Hand Color"] = "主手颜色"
L["Off-Hand Color"] = "副手颜色"
L["Two-Hand Color"] = "双手颜色"
L["GCD Bar"] = "公共CD条"
L["Creates a Global Cooldown Bar"] = "创建一个公共CD计时条"
L["UnitFrame Style"] = "头像样式"
L["Adds my styling to the Unitframes if you use transparent health."] = "当你使用透明头像时，添加Merathilis风格"
L["Change the default role icons."] = "替换默认职责图标"
L["Changes the Heal Prediction texture to the default Blizzard ones."] = "将治疗预估材质替换为暴雪默认样式"
L["Add a glow in the end of health bars to indicate the over absorb."] = "在生命条的末端添加发光来表示过量吸收."
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = "为 ElvUI 单位框体添加暴雪风格的过量吸收发光和叠加层."
L["Auto Height"] = "自动高度"
L["Blizzard Absorb Overlay"] = "暴雪吸收覆盖层"
L["Blizzard Over Absorb Glow"] = "暴雪过量吸收发光"
L["Blizzard Style"] = "暴雪样式"
L["Change the color of the absorb bar."] = "修改吸收条的颜色."
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Enable the replacing of ElvUI absorb bar textures."] = "启用 ElvUI 吸收条材质替换."
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = "这里有一些按钮帮助你一键更改所有吸收条的设置."
L["Max Overflow"] = "最大治疗吸收盾"
L["Modify the texture of the absorb bar."] = "修改吸收条材质."
L["Overflow"] = "溢出"
L["Set %s to %s"] = "设置 %s 为 %s"
L["Set All Absorb Style to %s"] = "设置全部吸收样式为 %s"
L["The absorb style %s and %s is highly recommended with %s tweaks."] = "非常推荐使用 %s 和 %s 的吸收风格来和 %s的修改进行搭配显示."
L["The selected texture will override the ElvUI default absorb bar texture."] = "选定的材质会覆盖 ElvUI 默认吸收材质."
L["Use the texture from Blizzard Raid Frames."] = "使用暴雪团队框架中的材质."

-- LocationPanel
L["Template"] = "模版"
L["NoBackdrop"] = "无背景"
L["Location Panel"] = "位置面板"
L["Update Throttle"] = "更新阈值"
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = "坐标和区域文本更新的频率，数值越小更新越频繁."
L["Full Location"] = "完整位置"
L["Color Type"] = "颜色类型"
L["Custom Color"] = "自定义颜色"
L["Reaction"] = "声望"
L["Location"] = "位置"
L["Coordinates"] = "坐标"
L["Teleports"] = "传送"
L["Portals"] = "传送门"
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
L["Dungeon Teleports"] = true

-- Maps
L["MiniMap"] = "小地图"
L["MiniMap Buttons"] = "小地图按钮"
L["Minimap Ping"] = "小地图点击"
L["Add Server Name"] = "添加服务器名称"
L["Only In Combat"] = "仅在战斗中"
L["Fade-In"] = "淡入"
L["The time of animation. Set 0 to disable animation."] = "时间动画. 设置为0来关闭动画"
L["Blinking Minimap"] = "小地图边框闪亮"
L["Enable the blinking animation for new mail or pending invites."] = "为新邮件或等待的邀请启用闪光动画."
L["Super Tracker"] = "超级追踪"
L["Description"] = "描述"
L["Additional features for waypoint."] = "为标记点添加额外功能."
L["Auto Track Waypoint"] = "自动追踪标记"
L["Auto track the waypoint after setting."] = "在设定标记后自动进行追踪."
L["Right Click To Clear"] = "右键清除"
L["Right click the waypoint to clear it."] = "右键标记点来清除它."
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
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] = "你可以在这里粘贴任何包含坐标的文字, 然后按 回车键 设置路径点."
L["illegal"] = "非法"
L["invalid"] = "无效"
L["Because of %s, this module will not be loaded."] = true
L["This module will help you to reveal and resize maps."] = true
L["Reveal"] = true
L["Use Colored Fog"] = true
L["Remove Fog of War from your world map."] = true
L["Style Fog of War with special color."] = true

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
L["Add an extra bar to let you set raid markers efficiently."] = "添加一个额外的条让你更加效率得设定团队标记."
L["Toggle raid markers bar."] = "开关团队标记条."
L["Inverse Mode"] = "反向模式"
L["Swap the functionality of normal click and click with modifier keys."] = "对调正常点击和按下修饰键时点击的功能."
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

-- Raid Manager
L["Raid Manager"] = "团队管理"
L["This will disable the ElvUI Raid Control and replace it with my own."] = "这将禁用ElvUI的团队管理，替换为Merathilis的"
L["Open Raid Manager"] = "打开团队管理"
L["Pull Timer Count"] = "倒数计时"
L["Change the Pulltimer for DBM or BigWigs"] = "修改DBM和BigWigs的倒数计时"
L["Only accept values format with '', e.g.: '5', '8', '10' etc."] = "仅识别数字"

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
L["RaidCD"] = "团队技能CD"
L["Sort Upwards"] = "向上排序"
L["Sort by Expiration Time"] = "根据剩余时间排序"
L["Show Self Cooldown"] = "显示自身冷却"
L["Show Icons"] = "显示图标"
L["Show In Party"] = "在小队中显示"
L["Show In Raid"] = "在团队中显示"
L["Show In Arena"] = "在竞技场中显示"

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
L["floatingCombatTextCombatDamageDirectionalScale_DESC"] = "直接伤害文字移动速度 (禁用 = 无数字)\r\r默认: |cff00ff001|r"

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
L["Castbar Shield"] = "施法条盾牌"
L["Show a shield icon on the castbar for non interruptible spells."] = "在不可打断的法术图标上添加盾牌图标"
L["Enhanced NameplateAuras"] = "增强姓名板光环"
L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"] = "|cffFF0000注意:|r 这会覆盖 ElvUI 姓名板 Buff/Debuffs 的长宽设置. 控制技能的图标大小固定为: 32 x 32"

-- Install
L["Welcome"] = "欢迎"
L["|cffff7d0aMerathilisUI|r Installation"] = "|cffff7d0aMerathilisUI|r安装"
L["MerathilisUI Set"] = "MerathilisUI设置"
L["MerathilisUI didn't find any supported addons for profile creation"] = "MerathilisUI没有找到任何支持的插件用于配置文件创建."
L["MerathilisUI successfully created and applied profile(s) for:"] = "MerathilisUI成功创建并应用了个人配置为:"
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
L["This part of the installation process will fill MerathilisUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "这部分安装过程将填充MerathilisUI数据文本.\r|cffff8000这不会触及ElvUI数据文本|r"
L["This part of the installation process will reposition your Actionbars and will enable backdrops"] = "这部分安装过程将重新布局您的动作条并启用背景"
L["This part of the installation process will reposition your Unitframes."] = "这部分安装过程将重新布局您的单位框体."
L["This part of the installation process will apply changes to ElvUI Plugins"] = "这部分安装过程将对ElvUI插件应用更改"
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = "此步骤更改了一些魔兽世界的默认选项.这些选项是根据%s作者的需求量身定制的,并不是此配置功能所必需的(一些cvar的修改)"
L["Please click the button below to apply the new layout."] = "请单击下面的按钮以应用新布局."
L["Please click the button below to setup your chat windows."] = "请单击下面的按钮设置聊天窗口."
L["Please click the button below to setup your actionbars."] = "请单击下面的按钮设置动作条."
L["Please click the button below to setup your datatexts."] = "请单击下面的按钮来设置数据文本."
L["Please click the button below to setup your Unitframes."] = "请单击下面的按钮设置单位框架."
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = "请单击下面的按钮以设置ElvUI AddOns.对于其他Addon配置文件,请进入我的选项 - 皮肤/插件"
L["DataTexts"] = "数据文本"
L["General Layout"] = true
L["Setup ActionBars"] = true
L["Setup UnitFrames"] = true
L["Setup Datatexts"] = "设置数据文本"
L["Setup Addons"] = "设置插件"
L["ElvUI AddOns"] = "ElvUI 插件"
L["Finish"] = "完成"
L["Installed"] = "安装"

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "您的ElvUI版本比推荐使用|cffff7d0aMerathilisUI|r的版本旧. 你的版本是 |cff00c0fa%.2f|r (推荐版本 |cff00c0fa%.2f|r). MerathilisUI未加载. 请更新你的ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = "你已经同时启用了Location Plus和Shadow＆Light.选择要禁用的插件"
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[在这里,您可以选择S＆L的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_BW"] = [[在这里,您可以选择BigWigs的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DBM"] = [[在这里,您可以选择Deadly Boss Mods的布局.]]
L["MUI_INSTALL_SETTINGS_LAYOUT_DETAILS"] = [[在这里,您可以选择Details!的布局.]]
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
L["MerathilisUI Shadows"] = "MerathilisUI 阴影"
L["Undress Button"] = "解除装备按钮"
L["Subpages"] = "子页面"
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = "子页面有10个物品, 这个选项设置了一页里有多少子页面"
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

-- Panels
L["Top Left Panel"] = "左上面板"
L["Top Left Extra Panel"] = "左上额外面板"
L["Top Right Panel"] = "右上面板"
L["Top Right Extra Panel"] = "右上额外面板"
L["Bottom Left Panel"] = "左下面板"
L["Bottom Left Extra Panel"] = "左下额外面板"
L["Bottom Right Panel"] = "右下面板"
L["Bottom Right Extra Panel"] = "右下额外面板"

-- Objective Tracker
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
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] = "使用简短名字替代, 比如 托加斯特,罪魂之塔 为 托加斯特."
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

-- Filter
L["Filter"] = "过滤器"
L["Unblock the profanity filter."] = "解锁语言过滤器."
L["Profanity Filter"] = "语言过滤器"
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] = "开启这个选项将解锁语言过滤器的设定.[国服]"

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
L["Replace the Real ID or the character name of friends with your notes."] = "使用你的备注替换好友的战网名或角色名."
L["Use Game Color"] = "使用游戏颜色"
L["Change the color of the name to the in-playing game style."] = "根据正在游玩的游戏的风格来改变姓名颜色."
L["Use Class Color"] = "使用职业颜色"
L["Font Setting"] = "字体设定"

-- Talents
L["Talents"] = "天赋"
L["This feature improves the Talent Window by:\n\n Adding an Extra Button to swap between specializations.\n Adding an Extra Button to use and track duration for Codices and Tomes."] = true

-- Profiles
L["MER_PROFILE_DESC"] = [[这个部分将为某些插件创建配置文件.

|cffff0000警告:|r 它将覆盖/删除已经存在的配置文件. 如果你不想应用我的配置，请不要按下面的按钮.]]

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
L["Help you to enable/disable the modules for a better experience with other plugins."] = "为了更好的与其他插件兼容, 帮助你开启/禁用一些模块."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] = "不同的插件和 ElvUI 增强中有非常多的模块, 但其中部分模块功能是高度相似的."
L["Have a good time with %s!"] = "希望 %s 能让你玩得开心!"
L["Choose the module you would like to |cff00ff00use|r"] = "请选择你要|cff00ff00使用|r的模块"
L["If you find the %s module conflicts with another addon, alert me via Discord."] = "如果你发现 %s 的模块与其他插件冲突, 可以通过 Discord 来告知我."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = "你可以通过设定位于 [MerathilisUI]-[信息] 底部的选项来启用/停用兼容性检查."
L["Complete"] = "完成"

-- Debug
L["Usage"] = "用法"
L["Enable debug mode"] = "启用除错模式"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = "禁用除了 ElvUI 核心, ElvUI %s 和 BugSack 以外的插件."
L["Disable debug mode"] = "禁用除错模式"
L["Reenable the addons that disabled by debug mode."] = "重新启用调试模式时禁用的插件."
L["Debug Enviroment"] = "调试环境"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = "你可以使用 |cff00ff00/muidebug off|r 命令来退出调试模式."
L["After you stop debuging, %s will reenable the addons automatically."] = "在你停止调试后, %s 将自动重新启用插件."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = "在提交一个错误报告之前, 请先用 %s 命令启用调试模式并再测试一次."

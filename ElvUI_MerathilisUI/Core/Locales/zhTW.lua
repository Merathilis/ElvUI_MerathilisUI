-- Traditional Chinese localization file for zhTW.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "zhTW")

-- Core
L["Enable"] = "啟用"
L[" is loaded. For any issues or suggestions, please visit "] = true
L["Font"] = true
L["Size"] = true
L["Width"] = true
L["Height"] = true
L["Alpha"] = true
L["Outline"] = "描邊"
L["X-Offset"] = true
L["Y-Offset"] = true
L["Icon Size"] = true
L["Font Outline"] = true

-- General Options
L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."] = true
L["by Merathilis (|cFF00c0faEU-Shattrath|r)"] = true
L["AFK"] = "暫離"
L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"] = true
L["Are you still there? ... Hello?"] = true
L["Logout Timer"] = true
L["SplashScreen"] = true
L["Enable/Disable the Splash Screen on Login."] = true
L["Options"] = "設定"
L["Description"] = true
L["General"] = true
L["Modules"] = true
L["Media"] = true
L["MER_DESC"] = [=[|cffffffffMerathilis|r|cffff7d0aUI|r is an extension of ElvUI. It adds:

- a lot of new features
- a transparent overall look
- rewrote all existing ElvUI Skins
- my personal Layout

|cFF00c0faNote:|r It is compatible with most of other ElvUI plugins.
But if you install another Layout over mine, you must adjust it manually.

|cffff8000Newest additions are marked with: |r]=]

-- Core Options
L["Login Message"] = "登入資訊"
L["Enable/Disable the Login Message in Chat"] = true
L["Log Level"] = "日誌等級"
L["Only display log message that the level is higher than you choose."] = "只顯示高於所選等級的日志訊息."
L["Set to 2 if you do not understand the meaning of log level."] = "如果你不理解日志等級的意思, 設置為 2 就好."
L["Open the changelog window."] = true

-- Bags
L["BANK_DESC"] = [=[If you have my Bags enabled the ElvUI Bags will be forced to be disabled! So if you want the ElvUI back, you need to disable my Bags first and then enable the ElvUI Bags again.]=]
L["Item Filter"] = true
L["Junk"] = true
L["Consumable"] = true
L["Ammo"] = true
L["Azerite"] = true
L["Equipments"] = true
L["EquipSets"] = true
L["Legendarys"] = true
L["Collection"] = true
L["Favorite"] = true
L["Goods"] = true
L["Quest"] = true
L["Anima"] = true
L["Relic"] = true
L["Collect Empty Slots"] = true
L["Special Bags Color"] = true
L["|nShow color for special bags:|n- Herb bag|n- Mining bag|n- Gem bag|n- Enchanted mageweave pouch"] = true
L["New Item Glow"] = true
L["Show ItemLevel"] = true
L["Pet Trash Currencies"] = true
L[
	"|nIn patch 9.1, you can buy 3 battle pets by using specific trash items. Keep this enabled, will sort these items into Collection Filter, and won't be sold by auto junk selling."
	] = true
L["ItemLevel Threshold"] = true
L["BagSort Mode"] = true
L[
	"|nIf you have empty slots after bag sort, please disable bags module, and turn off all bags filter in default ui containers."
	] = true
L["Forward"] = true
L["Backwards"] = true
L["Bags per Row"] = true
L["|nIf Bags ItemFilter enabled, change the bags per row for anchoring."] = true
L["Bank bags per Row"] = true
L["|nIf Bags ItemFilter enabled, change the bank bags per row for anchoring."] = true
L["Icon Size"] = true
L["Icon Spacing"] = true
L["Font Size"] = true
L["Bags Width"] = true
L["Bank Width"] = true
L["Bag Search Tip"] = "|nClick to search your bag items.|nYou can type in item names or item equip locations.|n'boe' for items that bind on equip and 'quest' for quest items.|n|nPress key ESC to clear editbox."
L["Auto Deposit Tip"] = "|nLeft click to deposit reagents, right click to switch auto deposit.|nIf the button border shown, the reagents from your bags would auto deposit once you open your BankFrame."
L["Bag Sort Disabled"] = "BagSort has been disabled in the Options."
L["Sort"] = true
L["FreeSlots"] = "Total free slots"
L["Split Mode Enabled"] = "|nClick to split stacked items in your bags.|nYou can change 'split count' for each click thru the editbox."
L["Quick Split"] = true
L["Favourite Mode"] = true
L["Favourite Mode Enabled"] = "|nYou can now star items.|nIf 'Bags ItemFilter' enabled, the item you starred will add to Preferences filter slots.|nThis is not available to trash."
L["Reset junklist warning"] = "Are you sure to wipe the custom junk list?"
L["Junk Mode Enabled"] = "|nClick to tag item as junk.|nIf 'Autosell Junk' enabled, these items would be sold as well.|nThe list is saved account-wide, and won't be in the export data.|nYou can hold CTRL+ALT and click to wipe the custom junk list."
L["Custom Junk Mode"] = "Custom Junk List"
L["Delete Mode Enabled"] = "|nYou can destroy container item by holding CTRL+ALT. The item can be heirlooms or its quality lower then rare (blue)."
L["Item Delete Mode"] = true
L["Azerite Armor"] = true
L["Equipment Set"] = true
L["Korthia Relic"] = true
L["StupidShiftKey"] = true
L["Equipment Set Overlay"] = true
L["Show the associated equipment sets for the items in your bags (or bank)."] = true

-- Chat
L["CHAT_AFK"] = "[AFK]"
L["CHAT_DND"] = "[DND]"
L["BACK"] = "上頁"
L["|cFF00c0failvl|r: %d"] = true
L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"] = true
L["Requires level: %d - %d"] = true
L["Requires level: %d - %d (%d)"] = true
L["(+%.1f Rested)"] = true
L["Unknown"] = "未知"
L["Chat Item Level"] = true
L["Shows the slot and item level in the chat"] = true
L["Expand the chat"] = true
L["Chat Menu"] = true
L["Create a chat button to increase the chat size."] = true
L["Hide Player Brackets"] = "隱藏玩家方括弧"
L["Removes brackets around the person who posts a chat message."] = true
L["Hide Chat Side Panel"] = true
L["Removes the Chat SidePanel. |cffFF0000WARNING: If you disable this option you must adjust your Layout.|r"] = true
L["Chat Bar"] = "聊天條"
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
L["Orientation"] = "按鍵對齊方向"
L["Please use Blizzard Communities UI add the channel to your main chat frame first."] = "請先使用暴雪社群介面將頻道添加至主聊天視窗."
L["Channel Name"] = "頻道名"
L["Abbreviation"] = "縮寫"
L["Auto Join"] = "自動加入"
L["World"] = "世界"
L["Channels"] = "頻道"
L["Block Shadow"] = "方塊陰影"
L["Hide channels not exist."] = "隱藏不存在的頻道."
L["Only show chat bar when you mouse over it."] = "只在滑鼠經過時顯示聊天條."
L["Button"] = "按鍵"
L["Item Level Links"] = true
L["Filter"] = "過濾器"
L["Block"] = "方塊"
L["Custom Online Message"] = true
L["Chat Link"] = "聊天鏈接"
L["Add extra information on the link, so that you can get basic information but do not need to click"] = "為聊天鏈接添加額外的訊息, 如此一來, 你就可以不透過點擊直接獲取到物品的基礎訊息"
L["Additional Information"] = "附加訊息"
L["Level"] = "等級"
L["Translate Item"] = "翻譯物品"
L["Translate the name in item links into your language."] = "將物品連結的名稱翻譯到你的語言."
L["Icon"] = "圖示"
L["Armor Category"] = "護甲分類"
L["Weapon Category"] = "武器分類"
L["Filters some messages out of your chat, that some Spam AddOns use."] = true
L["Display the level of the item on the item link."] = true
L["Numberical Quality Tier"] = true
L["%player% has earned the achievement %achievement%!"] = "%player%獲得了成就%achievement%!"
L["%players% have earned the achievement %achievement%!"] = "%players%獲得了成就%achievement%!"
L["%players% (%bnet%) has come online."] = "%players% (%bnet%) 上線了。"
L["%players% (%bnet%) has gone offline."] = "%players% (%bnet%) 下線了。"
L["BNet Friend Offline"] = true
L["BNet Friend Online"] = true
L["Show a message when a Battle.net friend's wow character comes online."] = true
L["Show a message when a Battle.net friend's wow character goes offline."] = true
L["Show the class icon before the player name."] = true
L["Show the faction icon before the player name."] = true
L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."] = true
L["This feature only works for message that sent by this module."] = true

-- Combat Alert
L["Combat Alert"] = "戰鬥提醒"
L["Enable/Disable the combat message if you enter/leave the combat."] = true
L["Enter Combat"] = "進入戰鬥"
L["Leave Combat"] = "離開戰鬥"
L["Stay Duration"] = true
L["Custom Text"] = true
L["Custom Text (Enter)"] = true
L["Custom Text (Leave)"] = true
L["Color"] = "顏色"

-- Information
L["Information"] = "信息"
L["Support & Downloads"] = true
L["Tukui"] = true
L["Github"] = true
L["CurseForge"] = true
L["Coding"] = true
L["Testing & Inspiration"] = true
L["Development Version"] = "開發版"
L["Here you can download the latest development version."] = true
L["Donations"] = true

-- Modules
L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."] = true
L["Are you sure you want to reset %s module?"] = "你確定要重置 %s 模組麼?"
L["Reset All Modules"] = "重置全部模組"
L["Reset all %s modules."] = "重置全部 %s 模組."

-- GameMenu
L["GameMenu"] = true
L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"] = true

-- Extended Vendor
L["Extended Vendor"] = true
L["Enhanced NameplateAuras"] = true
L["Extends the merchant page to show more items."] = true
L["Number of Pages"] = true
L["The number of pages shown in the merchant frame."] = true

-- FlightPoint
L["Flight Point"] = true
L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."] = true

-- Shadows
L["Shadows"] = true
L["Increase Size"] = "增大尺寸"
L["Make shadow thicker."] = "使陰影更厚."

-- Mail
L["Mail"] = "邮箱"
L["Alternate Character"] = "分身角色"
L["Alt List"] = "分身名單"
L["Delete"] = "刪除"
L["Favorites"] = true
L["Favorite List"] = "最愛列表"
L["Name"] = "姓名"
L["Realm"] = "伺服器"
L["Add"] = "新增"
L["Please set the name and realm first."] = "請先設定名字和伺服器名."
L["Toggle Contacts"] = "開關聯絡人"
L["Online Friends"] = "在線好友"
L["Add To Favorites"] = "添加到我的最愛"
L["Remove From Favorites"] = "從我的最愛移除"
L["Remove This Alt"] = true
L["Fishing Net"] = true
L["Fishing Nets"] = true
L["Iskaaran Fishing Net"] = true
L["Net #%d"] = true
L["Net %s can be collected"] = true
L["No Nets Set"] = true

-- MicroBar
L["Backdrop"] = "背景"
L["Backdrop Spacing"] = "背景間距"
L["The spacing between the backdrop and the buttons."] = "背景與按鈕之間的間隙"
L["Time Width"] = true
L["Time Height"] = true
L["The spacing between buttons."] = "兩個按鈕間的距離."
L["The size of the buttons."] = "按鍵的尺寸."
L["Slow Mode"] = "慢速模式"
L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."] = "附加文字的更新間隔將從 1 秒改為 10 秒以降低記憶體使用."
L["Display"] = "顯示"
L["Fade Time"] = "漸變時間"
L["Tooltip Position"] = true
L["Mode"] = "模式"
L["None"] = "無"
L["Class Color"] = "職業顏色"
L["Custom"] = "自訂"
L["Additional Text"] = "附加文字"
L["Interval"] = "時間間隔"
L["The interval of updating."] = "更新時間間隔."
L["Home"] = "家"
L["Left Button"] = "左鍵"
L["Right Button"] = "右鍵"
L["Left Panel"] = "左側面板"
L["Right Panel"] = "右側面板"
L["Button #%d"] = "第 %d 個按鍵"
L["Pet Journal"] = "寵物日誌"
L["Show Pet Journal"] = "顯示寵物日誌"
L["Screenshot"] = "擷圖"
L["Screenshot immediately"] = "立即擷圖"
L["Screenshot after 2 secs"] = "2 秒後進行擷圖"
L["Toy Box"] = "玩具箱"
L["Collections"] = "收藏"
L["Show Collections"] = "顯示收藏"

-- Misc
L["Misc"] = "其他"
L["Artifact Power"] = true
L["has appeared on the MiniMap!"] = true
L["Alt-click, to buy an stack"] = true
L["Announce"] = true
L["Skill gains"] = true
L[" members"] = true
L["Name Hover"] = true
L["Shows the Unit Name on the mouse."] = true
L["Double Click to Undress"] = true
L["Flashing Cursor"] = true
L["Lights up the cursor to make it easier to see."] = true
L["Accept Quest"] = true
L["Placed Item"] = true
L["Stranger"] = true
L["Keystones"] = true
L["GUILD_MOTD_LABEL2"] = "公會今日訊息"
L["LFG Member Info"] = true
L["Shows role informations in your tooltip in the lfg frame."] = true
L["MISC_REPUTATION"] = "Reputation"
L["MISC_PARAGON"] = "Paragon"
L["MISC_PARAGON_REPUTATION"] = "Paragon Reputation"
L["MISC_PARAGON_NOTIFY"] = "Max Reputation - Receive Reward."
L["Fun Stuff"] = true
L["Change the NPC Talk Frame."] = true
L["Press CTRL + C to copy."] = true
L["Wowhead Links"] = true
L["Adds Wowhead links to the Achievement- and WorldMap Frame"] = true
L["Highest Quest Reward"] = true
L["Automatically select the item with the highest reward."] = true
L["Item Alerts"] = true
L["Announce in chat when someone placed an usefull item."] = true
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
L["Creates a random toy macro."] = true
L["Text Style"] = true
L["COLOR"] = true
L["Hide Boss Banner"] = true
L["This will hide the popup, that shows loot, after you kill a boss"] = true
L["{rt1} %player% cast %spell% -> %target% {rt1}"] = "{rt1} %player%使用了%spell% -> %target% {rt1}"
L["{rt1} %player% cast %spell%, today's special is Anchovy Pie! {rt1}"] = "{rt1} %player%使用了%spell%, 各位快來領餐包喔! {rt1}"
L["{rt1} %player% is casting %spell%, please assist! {rt1}"] = "{rt1} %player%正在進行%spell%, 請配合點門喔! {rt1}"
L["{rt1} %player% is handing out %spell%, go and get one! {rt1}"] = true
L["{rt1} %player% opened %spell%! {rt1}"] = "{rt1} %player%開啟了%spell% {rt1}"
L["{rt1} %player% puts %spell% {rt1}"] = "{rt1} %player%放置了%spell% {rt1}"
L["{rt1} %player% used %spell% {rt1}"] = "{rt1} %player%使用了%spell% {rt1}"
L["{rt1} %player% puts down %spell%! {rt1}"] = true
L["Completed"] = "已完成"
L["%s has been reseted"] = "已重置 %s"
L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"] = "重置 %s 失敗（有玩家在試圖進入副本）"
L["Cannot reset %s (There are players offline in your party.)"] = "重置 %s 失敗（有離線玩家）"
L["Cannot reset %s (There are players still inside the instance.)"] = "重置 %s 失敗（副本內仍有玩家）"
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

-- Tooltip
L["Your Status:"] = true
L["Your Status: Incomplete"] = true
L["Your Status: Completed on "] = true
L["Adds an icon for spells and items on your tooltip."] = true
L["Adds an Icon for battle pets on the tooltip."] = true
L["Adds an Icon for the faction on the tooltip."] = true
L["Adds information to the tooltip, on which char you earned an achievement."] = true
L["Keystone"] = "鑰石"
L["Adds descriptions for mythic keystone properties to their tooltips."] = true
L["Title Color"] = "標題顏色"
L["Change the color of the title in the Tooltip."] = true
L["FACTION"] = "陣營"
L["HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS"] = "啟動艾澤萊晶岩之力"
L["Only Icons"] = true
L["I"] = "1階"
L["II"] = "2階"
L["III"] = "3階"
L["Use the new style tooltip."] = "使用新型態提示。"
L["Display in English"] = "顯示為英文"
L["Show icon"] = "顯示圖示"
L["Show the spell icon along with the name."] = "顯示法術圖示以及名稱。"
L["Show the rank of shards."] = "顯示統御碎片的等級."
L["Pet Battle"] = true
L["Tooltip Icons"] = true

-- Notification
L["Notification"] = "通知"
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
L["Vignette Print"] = true
L["Prints a clickable Link with Coords in the Chat."] = true
L["Quick Join"] = true
L["Title Font"] = true
L["Text Font"] = true
L["Debug Print"] = true
L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"] = true

-- DataTexts
-- DataBars
L["DataBars"] = "數據條"
L["Add some stylish buttons at the bottom of the DataBars"] = true
L["Style DataBars"] = true

-- PVP
L["Automatically cancel PvP duel requests."] = true
L["Automatically cancel pet battles duel requests."] = true
L["Announce in chat if duel was rejected."] = true
L["MER_DuelCancel_REGULAR"] = "Duel request from %s rejected."
L["MER_DuelCancel_PET"] = "Pet duel request from %s rejected."
L["Show your PvP killing blows as a popup."] = true
L["Sound"] = "声效"
L["Play sound when killing blows popup is shown."] = true
L["PvP Auto Release"] = true
L["Automatically release body when killed inside a battleground."] = true
L["Check for rebirth mechanics"] = true
L["Do not release if reincarnation or soulstone is up."] = true

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

-- AutoButtons
L["AutoButtons"] = "自動按鍵"
L["Bar"] = "條"
L["Only show the bar when you mouse over it."] = "只在滑鼠經過時顯示條."
L["Bar Backdrop"] = "條背景"
L["Show a backdrop of the bar."] = "顯示條背景."
L["Button Width"] = "按鍵寬度"
L["The width of the buttons."] = "按鍵的寬度."
L["Button Height"] = "按鍵高度"
L["The height of the buttons."] = "按鍵的高度."
L["Counter"] = "計數"
L["Button Groups"] = "按鍵组"
L["Key Binding"] = "按鍵綁定"
L["Custom Items"] = "自訂物品"
L["List"] = "列表"
L["New Item ID"] = "新物品 ID"
L["Auto Button Bar"] = true
L["Quest Items"] = "任務物品"
L["Equipments"] = "裝備"
L["Potions"] = "藥水"
L["Flasks"] = "藥劑"
L["Food"] = "食物"
L["Crafted by mage"] = "由法師製造"
L["Banners"] = "戰旗"
L["Utilities"] = "實用物品"
L["Custom Items"] = "自訂物品"
L["Fade Time"] = "漸變時間"
L["Alpha Min"] = "最小透明度"
L["Alpha Max"] = "最大透明度"
L["Inherit Global Fade"] = true
L["Anchor Point"] = true
L["The first button anchors itself to this point on the bar."] = true

-- Media
L["Zone Text"] = true
L["Font Size"] = true
L["Subzone Text"] = true
L["PvP Status Text"] = true
L["Misc Texts"] = true
L["Mail Text"] = true
L["Chat Editbox Text"] = true
L["Gossip and Quest Frames Text"] = true
L["Objective Tracker Header Text"] = true
L["Objective Tracker Text"] = true
L["Banner Big Text"] = true
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
L["UnitFrames"] = "單位框架"
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
L["Add a glow in the end of health bars to indicate the over absorb."] = "在生命條的末尾添加一個火花来指示過量吸收."
L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."] = "為 ElvUI 單位框架添加暴雪過量吸收火花和遮罩."
L["Auto Height"] = "自動高度"
L["Blizzard Absorb Overlay"] = "暴雪吸收遮罩層"
L["Blizzard Over Absorb Glow"] = "暴雪過量吸收火花"
L["Blizzard Style"] = "暴雪風格"
L["Change the color of the absorb bar."] = "修改吸收條的顏色."
L["Custom Texture"] = "自訂材質"
L["Enable the replacing of ElvUI absorb bar textures."] = "啟用 ElvUI 生命條材質替換."
L["Here are some buttons for helping you change the setting of all absorb bars by one-click."] = "這裡有一些按鍵來幫助你一鍵修改所有吸收條的設定."
L["Max Overflow"] = "Maximaler Overflow"
L["Modify the texture of the absorb bar."] = "修改吸收盾材質."
L["Overflow"] = "超出顯示"
L["Set %s to %s"] = "設置 %s 為 %s"
L["Set All Absorb Style to %s"] = "設置全部吸收類型為 %s"
L["The absorb style %s and %s is highly recommended with %s tweaks."] = "非常推薦使用 %s 和 %s 的吸收條風格來與 %s修改配合顯示."
L["The selected texture will override the ElvUI default absorb bar texture."] = "選擇的材質將覆蓋ElvUI預設吸收條的材質."
L["Use the texture from Blizzard Raid Frames."] = "使用遊戲內建的團隊框架圖示."
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

-- LocationPanel
L["Location Panel"] = true
L["Update Throttle"] = true
L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."] = true
L["Full Location"] = true
L["Color Type"] = true
L["Custom Color"] = "自定顏色"
L["Reaction"] = true
L["Location"] = true
L["Coordinates"] = true
L["Teleports"] = true
L["Portals"] = "傳送門"
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
L["Dungeon Teleports"] = true
L["Hide In Combat"] = true

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
L["MiniMap Buttons"] = true
L["Minimap Ping"] = "小地圖點擊"
L["Add Server Name"] = "添加伺服器"
L["Only In Combat"] = true
L["Fade-In"] = true
L["The time of animation. Set 0 to disable animation."] = "動畫時間. 設定為 0 可禁用動畫."
L["Blinking Minimap"] = true
L["Enable the blinking animation for new mail or pending invites."] = true
L["Super Tracker"] = "超級追蹤"
L["Description"] = "描述"
L["Additional features for waypoint."] = "為標記點添加額外功能."
L["Auto Track Waypoint"] = "自動追蹤標記"
L["Auto track the waypoint after setting."] = "在設定標記後自動進行追蹤."
L["Middle Click To Clear"] = true
L["Middle click the waypoint to clear it."] = true
L["No Distance Limitation"] = "無距離限制"
L["Force to track the target even if it over 1000 yds."] = "強制追蹤超過 1000 碼的目標."
L["Distance Text"] = "距離文字"
L["Only Number"] = "只有數字"
L["Add Command"] = "新增指令"
L["Add a input box to the world map."] = "添加一個輸入框到世界地圖."
L["Are you sure to delete the %s command?"] = "你是否確定刪除 %s 指令?"
L["Can not set waypoint on this map."] = "無法在此地圖上設定地圖標記."
L["Command"] = "指令"
L["Command Configuration"] = "指令設定"
L["Command List"] = "指令列表"
L["Delete Command"] = "刪除指令"
L["Delete the selected command."] = "刪除選中的指令."
L["Enable to use the command to set the waypoint."] = "啟用使用指令設定地圖標記的功能."
L["Go to ..."] = "前往 ..."
L["Input Box"] = "輸入框"
L["New Command"] = "新指令"
L["No Arg"] = "無參數"
L["Smart Waypoint"] = "智能地圖標記"
L["The argument is invalid."] = "參數無效."
L["The argument is needed."] = "需要參數."
L["The command to set a waypoint."] = "設置地圖標記的指令."
L["The coordinates contain illegal number."] = "坐標包含非法數字."
L["Waypoint %s has been set."] = "已設定 %s 地圖標記."
L["Waypoint Parse"] = "地圖標記解析"
L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."] = "你可以在這裡貼上任何包含座標的文字, 並按下 輸入鍵(Enter) 設定地圖標記."
L["illegal"] = "非法"
L["invalid"] = "無效"
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
L["Custom String"] = "自訂字串"
L["Custom Strings"] = "自訂字串"
L["Custom color can be used by adding the following code"] = "自訂顏色可使用以下代碼"
L["Difficulty"] = "難度"
L["M+ Level"] = "M+ 等級"
L["Number of Players"] = "玩家數量"
L["Placeholders"] = "占位符"
L["Use Default"] = "使用預設"

-- SMB
L["Minimap Buttons"] = "小地圖按鍵"
L["Add an extra bar to collect minimap buttons."] = "添加一個額外的條來蒐集小地圖按鍵."
L["Toggle minimap buttons bar."] = "開關小地圖按鍵條."
L["Mouse Over"] = "滑鼠滑過顯示"
L["Only show minimap buttons bar when you mouse over it."] = "只在滑鼠經過時顯示小地圖按鍵條."
L["Minimap Buttons Bar"] = "小地圖按鍵條"
L["Bar Backdrop"] = "條背景"
L["Show a backdrop of the bar."] = "顯示條背景."
L["Backdrop Spacing"] = "背景間距"
L["The spacing between the backdrop and the buttons."] = "背景與按鍵之間的間隙."
L["Inverse Direction"] = "反向"
L["Reverse the direction of adding buttons."] = "反轉添加按鍵的方向."
L["Orientation"] = "按鍵對齊方向"
L["Arrangement direction of the bar."] = "條的增長方向."
L["Drag"] = "拖拽"
L["Horizontal"] = "水平"
L["Vertical"] = "垂直"
L["Buttons"] = "按鍵數"
L["Buttons Per Row"] = "每行按鍵數"
L["The amount of buttons to display per row."] = "每行所顯示的按鍵數量."
L["Button Size"] = "按鍵尺寸"
L["The size of the buttons."] = "按鍵的尺寸."
L["Button Spacing"] = "按鍵間距"
L["The spacing between buttons."] = "兩個按鍵間的距離."
L["Blizzard Buttons"] = "暴雪按鍵"
L["Calendar"] = "行事曆"
L["Add calendar button to the bar."] = "添加行事曆按鍵到條上."
L["Garrison"] = "要塞"
L["Add garrison button to the bar."] = "添加要塞按鍵到條上."

--Raid Marks
L["Raid Markers"] = "團隊標記"
L["Raid Markers Bar"] = "團隊標記條"
L["Raid Utility"] = "團隊工具"
L["Left Click to mark the target with this mark."] = "左鍵單擊來設定這個標記."
L["Right Click to clear the mark on the target."] = "右鍵點選以清除目標的標記."
L["%s + Left Click to place this worldmarker."] = "%s + 左鍵點擊 放置這個光柱."
L["%s + Right Click to clear this worldmarker."] = "%s + 右鍵點擊 清除這個光柱."
L["%s + Left Click to mark the target with this mark."] = "%s + 點擊 設定這個標記."
L["%s + Right Click to clear the mark on the target."] = "%s + 右鍵點擊 清除目標標記."
L["Click to clear all marks."] = "點選清除所有標記"
L["takes 3s"] = "需 3 秒"
L["%s + Click to remove all worldmarkers."] = "%s + 點擊 清除所有光柱."
L["Click to remove all worldmarkers."] = "點擊清除所有世界標記."
L["%s + Click to clear all marks."] = "%s + 點擊 清除所有標記."
L["Left Click to ready check."] = "左鍵點擊: 團隊確認"
L["Right click to toggle advanced combat logging."] = "右鍵點擊: 開關高級戰鬥記錄."
L["Left Click to start count down."] = "左鍵點擊: 開始倒數."
L["Add an extra bar to let you set raid markers efficiently."] = "添加一個額外的條來使你設定團隊標記更有效率."
L["Toggle raid markers bar."] = "開關團隊標記條."
L["Inverse Mode"] = "反向模式"
L["Swap the functionality of normal click and click with modifier keys."] = "對調正常點擊和按下修飾鍵時進行點擊的功能."
L["Visibility"] = "可見性"
L["In Party"] = "在隊伍中"
L["Always Display"] = "總是顯示"
L["Mouse Over"] = "滑鼠滑過顯示"
L["Only show raid markers bar when you mouse over it."] = "只在滑鼠經過時顯示團隊標記條."
L["Tooltip"] = "浮動提示"
L["Show the tooltip when you mouse over the button."] = "滑鼠置於按鈕上時顯示浮動提示."
L["Modifier Key"] = "組合鍵"
L["Set the modifier key for placing world markers."] = "設定標示團隊光柱的組合鍵"
L["Shift Key"] = "Shift 鍵"
L["Ctrl Key"] = "Ctrl 鍵"
L["Alt Key"] = "Alt 鍵"
L["Bar Backdrop"] = "條背景"
L["Show a backdrop of the bar."] = "顯示條背景."
L["Backdrop Spacing"] = "背景間距"
L["The spacing between the backdrop and the buttons."] = "背景與按鍵之間的間隙."
L["Orientation"] = "按鍵對齊方向"
L["Arrangement direction of the bar."] = "條的增長方向."
L["Raid Buttons"] = "Raid 按鍵"
L["Ready Check"] = "準備確認"
L["Advanced Combat Logging"] = "高級戰鬥記錄"
L["Left Click to ready check."] = "左鍵點擊: 團隊確認"
L["Right click to toggle advanced combat logging."] = "右鍵點擊: 開關高級戰鬥記錄."
L["Count Down"] = "倒數"
L["Count Down Time"] = "倒數時間"
L["Count down time in seconds."] = "倒數時間秒數."
L["Button Size"] = "按鍵尺寸"
L["The size of the buttons."] = "按鍵的尺寸."
L["Button Spacing"] = "按鍵間距"
L["The spacing between buttons."] = "兩個按鍵間的距離."
L["Button Backdrop"] = "按鍵背景"
L["Button Animation"] = "按鍵動畫"

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
L["Cooldowns"] = true
L["Cooldown Flash"] = true
L["Settings"] = true
L["Fadein duration"] = true
L["Fadeout duration"] = true
L["Duration time"] = true
L["Animation size"] = true
L["Watch on pet spell"] = true
L["Transparency"] = true
L["Test"] = "測試"
L["Sort Upwards"] = true
L["Sort by Expiration Time"] = true
L["Show Self Cooldown"] = true
L["Show Icons"] = true
L["Show In Party"] = true
L["Show In Raid"] = true
L["Show In Arena"] = true
L["Spell Name"] = true
L["Spell List"] = true

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
L["Chat Set"] = "對話设置"
L["ActionBars"] = "快捷列"
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
L["This part of the installation process will change your NamePlates."] = true
L["This part of the installation process will reposition your Unitframes."] = true
L["This part of the installation process will apply changes to ElvUI Plugins"] = true
L["This step changes a few World of Warcraft default options. These options are tailored to the needs of the author of %s and are not necessary for this edit to function."] = true
L["Please click the button below to apply the new layout."] = true
L["Please click the button below to setup your chat windows."] = true
L["Please click the button below to setup your actionbars."] = true
L["Please click the button below to setup your datatexts."] = true
L["Please click the button below to setup your NamePlates."] = true
L["Please click the button below to setup your Unitframes."] = true
L["Please click the button below to setup the ElvUI AddOns. For other Addon profiles please go in my Options - Skins/AddOns"] = true
L["DataTexts"] = "資訊文字"
L["General Layout"] = true
L["Setup ActionBars"] = true
L["Setup NamePlates"] = true
L["Setup UnitFrames"] = true
L["Setup Chat"] = "設定對話視窗"
L["Setup Datatexts"] = true
L["Setup Addons"] = true
L["ElvUI AddOns"] = true
L["Finish"] = true
L["Installed"] = true

-- Staticpopup
L["MSG_MER_ELV_OUTDATED"] = "Your version of ElvUI is older than recommended to use with |cffff7d0aMerathilisUI|r. Your version is |cff00c0fa%.2f|r (recommended is |cff00c0fa%.2f|r). MerathilisUI isn't loaded. Please update your ElvUI."
L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."] = true
L["MUI_INSTALL_SETTINGS_LAYOUT_SLE"] = [[Here you can choose the layout for S&L.]]
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
L["Screen Shadow Overlay"] = true
L["Enables/Disables a shadow overlay to darken the screen."] = true
L["Undress Button"] = true
L["Subpages"] = true
L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."] = true
L["Enable/Disable"] = true
L["decor."] = true
L["MerathilisUI Button Style"] = true
L["Creates decorative stripes on Ingame Buttons (only active with MUI Style)"] = true
L["Additional Backdrop"] = "附加背景"
L["Remove Border Effect"] = "移除邊框效果"
L["Animation Type"] = "動畫類型"
L["The type of animation activated when a button is hovered."] = "按鍵經過時顯示的動畫類型."
L["Animation Duration"] = "動畫時間"
L["The duration of the animation in seconds."] = "動畫持續時間 (秒)."
L["Backdrop Class Color"] = "背景職業色"
L["Border Class Color"] = "邊框職業色"
L["Border Color"] = "邊框顏色"
L["Normal Class Color"] = "普通職業顏色"
L["Selected Backdrop & Border"] = "選中時背景和邊框"
L["Selected Class Color"] = "選中時職業顏色"
L["Selected Color"] = "選中時顏色"
L["Tab"] = "標籤"
L["Tree Group Button"] = "樹狀分組按鍵"
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
L["Queue Timer"] = true
L["Right Color"] = true
L["Show spark on the bar."] = true
L["Smooth"] = true
L["Smooth the bar animation with ElvUI."] = true
L["Spark"] = true
L["The options below are only for BigWigs %s bar style."] = true
L["You need to manually set the bar style to %s in BigWigs first."] = true

-- Panels
L["Panels"] = true
L["Top Panel"] = true
L["Bottom Panel"] = true
L["Style Panels"] = true
L["Top Left Panel"] = true
L["Top Left Extra Panel"] = true
L["Top Right Panel"] = true
L["Top Right Extra Panel"] = true
L["Bottom Left Panel"] = true
L["Bottom Left Extra Panel"] = true
L["Bottom Right Panel"] = true
L["Bottom Right Extra Panel"] = true

-- Objective Tracker
L["Objective Tracker"] = true
L["1. Customize the font of Objective Tracker."] = "1. 自訂任務追蹤字型."
L["2. Add colorful progress text to the quest."] = "2. 為任務添加彩色進度文字."
L["Progress"] = "進度"
L["No Dash"] = "無標記"
L["Colorful Progress"] = "彩色進度"
L["Percentage"] = "百分比"
L["Add percentage text after quest text."] = "在任務文本後添加百分比文字."
L["Colorful Percentage"] = "彩色百分比"
L["Make the additional percentage text be colored."] = "使得額外的百分比文字為彩色顯示."
L["Cosmetic Bar"] = "裝飾條"
L["Border"] = "邊框"
L["Border Alpha"] = "邊框透明度"
L["Width Mode"] = "寬度模式"
L["'Absolute' mode means the width of the bar is fixed."] = "'絕對'模式代表條的寬度是固定的."
L["'Dynamic' mode will also add the width of header text."] = "'動態'模式同時會自動加上加入標題文字的寬度."
L["'Absolute' mode means the height of the bar is fixed."] = "'絕對'模式代表條的高度是固定的."
L["'Dynamic' mode will also add the height of header text."] = "'動態'模式同時會自動加上標題文字的高度."
L["Absolute"] = "絕對"
L["Dyanamic"] = "動態"
L["Color Mode"] = "顏色模式"
L["Gradient"] = "漸層"
L["Class Color"] = "職業顏色"
L["Normal Color"] = "正常顏色"
L["Gradient Color 1"] = "漸層顏色 1"
L["Gradient Color 2"] = "漸層顏色 2"
L["Presets"] = "預調設定"
L["Preset %d"] = "預調設定 %d"
L["Here are some example presets, just try them!"] = "這裡有一些預調的設定範例, 趕快試一試!"
L["Default"] = "預設"
L["Header"] = "頂部"
L["Short Header"] = "簡短頂部"
L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."] = "使用簡短頂部替代, 比如 『譴罪之塔』托迦司 到 托迦司."
L["Title Color"] = "標題顏色"
L["Change the color of quest titles."] = "修改任務標題文字顏色."
L["Use Class Color"] = "使用職業顏色"
L["Highlight Color"] = "強調色"
L["Title"] = "標題"
L["Bottom Right Offset X"] = "右下 X 偏移"
L["Bottom Right Offset Y"] = "右下 Y 偏移"
L["Top Left Offset X"] = "左上 X 軸偏移"
L["Top Left Offset Y"] = "左上 Y 軸偏移"
L["Transparent"] = "透明"
L["Style"] = true
L["Height Mode"] = true
L["Menu Title"] = true
L["it shows when objective tracker is collapsed."] = true

-- Filter
L["Filter"] = "過濾器"
L["Unblock the profanity filter."] = "解鎖不當言詞過濾器."
L["Profanity Filter"] = "不當言詞過濾器"
L["Enable this option will unblock the setting of profanity filter. [CN Server]"] = "啟用此項目將解鎖不當言詞過濾器的設定.[中國大陸伺服器]"

-- Friends List
L["Friends List"] = "好友名單"
L["Add additional information to the friend frame."] = "為好友框架增添額外訊息."
L["Modify the texture of status and make name colorful."] = "修改狀態標示材質, 彩色化好友名."
L["Enhanced Texture"] = "材質增強"
L["Game Icons"] = "遊戲圖示"
L["Default"] = "預設"
L["Modern"] = "現代"
L["Status Icon Pack"] = "狀態圖標包"
L["Diablo 3"] = "暗黑破壞神 III"
L["Square"] = "方塊"
L["Faction Icon"] = "陣營圖示"
L["Use faction icon instead of WoW icon."] = "使用陣營圖示來替代魔獸世界遊戲圖示."
L["Name"] = "名字"
L["Level"] = "等級"
L["Hide Max Level"] = "隱藏滿級"
L["Use Note As Name"] = "使用註記作為名字"
L["Replace the Real ID or the character name of friends with your notes."] = "將好友的 Real ID 或角色名稱替換為你的註記."
L["Use Game Color"] = "使用遊戲顏色"
L["Change the color of the name to the in-playing game style."] = "根據遊玩遊戲風格來修改名字顏色."
L["Use Class Color"] = "使用職業顏色"
L["Font Setting"] = "字型設定"

-- Profiles
L["MER_PROFILE_DESC"] = [[This section creates Profiles for some AddOns.

|cffff0000WARNING:|r It will overwrite/delete existing Profiles. If you don't want to apply my Profiles please don't press the Buttons below.]]

-- Addons
L["Skins/AddOns"] = true
L["Profiles"] = "設定檔"
L["BigWigs"] = true
L["MasterPlan"] = true
L["Shadow & Light"] = "|cff9482c9Shadow & Light|r"
L["This will create and apply profile for "] = true

-- Changelog
L["Changelog"] = "更新記錄"

-- Compatibility
L["Compatibility Check"] = "相容性確認"
L["Help you to enable/disable the modules for a better experience with other plugins."] = "為了保證與其他插件的使用體驗, 幫助你啟用/停用一些模組."
L["There are many modules from different addons or ElvUI plugins, but several of them are almost the same functionality."] = "不同的插件和 ElvUI 增強中有非常多的模組, 但其中部分模組功能是高度相似的."
L["Have a good time with %s!"] = "希望 %s 能讓你玩得開心!"
L["Choose the module you would like to |cff00ff00use|r"] = "選擇你更傾向於|cff00ff00使用|r的模組"
L["If you find the %s module conflicts with another addon, alert me via Discord."] = "如果你發現 %s 的模組與其他插件衝突了, 可以透過 Discord 來進行回報."
L["You can disable/enable compatibility check via the option in the bottom of [MerathilisUI]-[Information]."] = "你可以通過設定位於 [MerathilisUI]-[信息] 底部的選項來啟用/停用相容性檢查."
L["Complete"] = "完成"

-- Debug
L["Usage"] = "使用方式"
L["Enable debug mode"] = "啟用偵錯模式"
L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."] = "停用除了 ElvUI 核心, ElvUI %s 和 BugSack 以外所有插件."
L["Disable debug mode"] = "停用偵錯模式"
L["Reenable the addons that disabled by debug mode."] = "重新啟用偵錯模式禁用的插件."
L["Debug Enviroment"] = "偵錯環境"
L["You can use |cff00ff00/muidebug off|r command to exit debug mode."] = "你可以使用 |cff00ff00/muidebug off|r 指令來退出偵錯模式."
L["After you stop debuging, %s will reenable the addons automatically."] = "在停止偵錯模式後, %s 將自動重新啟用插件."
L["Before you submit a bug, please enable debug mode with %s and test it one more time."] = "在提交錯誤報告前, 請先使用 %s 命令啟用除錯模式並再次測試."
L["Error"] = true
L["Warning"] = true

-- Abbreviate
L["[ABBR] Algeth'ar Academy"] = "學院"
L["[ABBR] Announcement"] = "通報"
L["[ABBR] Back"] = "披"
L["[ABBR] Chest"] = "胸"
L["[ABBR] Community"] = "群"
L["[ABBR] Court of Stars"] = "眾星"
L["[ABBR] Dragonflight Keystone Hero: Season One"] = "鑰石英雄 第一季"
L["[ABBR] Dragonflight Keystone Master: Season One"] = "鑰石王 第一季"
L["[ABBR] Emote"] = "情"
L["[ABBR] Event Scenario"] = "事件"
L["[ABBR] Feet"] = "腳"
L["[ABBR] Finger"] = "指"
L["[ABBR] Guild"] = "會"
L["[ABBR] Halls of Valor"] = "英靈"
L["[ABBR] Hands"] = "手"
L["[ABBR] Head"] = "頭"
L["[ABBR] Held In Off-hand"] = "副手"
L["[ABBR] Heroic"] = "H"
L["[ABBR] Instance"] = "副"
L["[ABBR] Instance Leader"] = "隊長"
L["[ABBR] Legs"] = "腿"
L["[ABBR] Looking for Raid"] = "隨團"
L["[ABBR] Mythic"] = "M"
L["[ABBR] Mythic Keystone"] = "M+"
L["[ABBR] Neck"] = "項鏈"
L["[ABBR] Normal"] = "PT"
L["[ABBR] Officer"] = "幹"
L["[ABBR] Party"] = "隊"
L["[ABBR] Party Leader"] = "隊長"
L["[ABBR] Raid"] = "團"
L["[ABBR] Raid Finder"] = "隨團"
L["[ABBR] Raid Leader"] = "RL"
L["[ABBR] Raid Warning"] = "警"
L["[ABBR] Roll"] = "擲"
L["[ABBR] Ruby Life Pools"] = "晶紅"
L["[ABBR] Say"] = "說"
L["[ABBR] Scenario"] = "場景"
L["[ABBR] Shadowmoon Burial Grounds"] = "影月"
L["[ABBR] Shoulders"] = "肩"
L["[ABBR] Temple of the Jade Serpent"] = "玉蛟"
L["[ABBR] The Azure Vault"] = "蒼藍"
L["[ABBR] The Nokhud Offensive"] = "諾庫德"
L["[ABBR] Timewalking"] = "時光"
L["[ABBR] Trinket"] = "飾"
L["[ABBR] Turn In"] = "交接"
L["[ABBR] Vault of the Incarnates"] = "牢獄"
L["[ABBR] Waist"] = "腰"
L["[ABBR] Warfronts"] = "前線"
L["[ABBR] Whisper"] = "密"
L["[ABBR] Wind Emote"] = "情"
L["[ABBR] World"] = "世"
L["[ABBR] Wrist"] = "腕"
L["[ABBR] Yell"] = "喊"

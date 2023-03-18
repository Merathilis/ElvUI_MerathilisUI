local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local S = MER:GetModule('MER_Skins')
local LSM = E.LSM

local _G = _G
local ipairs, pairs, pcall, print, select, tonumber, type, unpack = ipairs, pairs, pcall, print, select, tonumber, type, unpack
local min = min
local abs = abs
local find, format, gsub, match, split, strfind = string.find, string.format, string.gsub, string.match, string.split, strfind
local strmatch, strlen, strsub = strmatch, strlen, strsub
local tconcat, tinsert, tremove, twipe = table.concat, table.insert, table.remove, table.wipe

local CreateFrame = CreateFrame
local GetAchievementInfo = GetAchievementInfo
local GetClassColor = GetClassColor
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetContainerItemID = GetContainerItemID or (C_Container and C_Container.GetContainerItemID)
local GetContainerItemLink = GetContainerItemLink or (C_Container and C_Container.GetContainerItemLink)
local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
local PickupContainerItem = PickupContainerItem or (C_Container and C_Container.PickupContainerItem)
local DeleteCursorItem = DeleteCursorItem
local UnitBuff = UnitBuff
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local UIParent = UIParent

local C_Covenants_GetCovenantData = C_Covenants and C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants and C_Covenants.GetActiveCovenantID
local C_TooltipInfo_GetInventoryItem = C_TooltipInfo and C_TooltipInfo.GetInventoryItem
local C_TooltipInfo_GetBagItem = C_TooltipInfo and C_TooltipInfo.GetBagItem
local C_TooltipInfo_GetHyperlink = C_TooltipInfo and C_TooltipInfo.GetHyperlink

function F.SetFontDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontDB: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontDB: db not found")
		return
	end

	local fontName, fontHeight = text:GetFont()

	text:FontTemplate(db.name and LSM:Fetch("font", db.name) or fontName, db.size or fontHeight, db.style or "NONE")
end

function F.SetFontColorDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontColorDB: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontColorWithDB: db not found")
		return
	end

	text:SetTextColor(db.r, db.g, db.b, db.a)
end

function F.SetFontOutline(text, font, size)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontOutline: text not found")
		return
	end
	local fontName, fontHeight, fontStyle = text:GetFont()

	if size and type(size) == "string" then
		size = fontHeight + tonumber(size)
	end

	if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
		font = LSM:Fetch("font", font)
	end

	text:FontTemplate(font or fontName, size or fontHeight, fontStyle or "OUTLINE")
	text:SetShadowColor(0, 0, 0, 0)
	text.SetShadowColor = E.noop
end

function F.SetVertexColorDB(tex, db)
	if not tex or not tex.GetVertexColor then
		F.Developer.LogDebug("Functions.SetVertexColorDB: No texture to handling")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetVertexColorDB: No texture color database")
		return
	end

	tex:SetVertexColor(db.r, db.g, db.b, db.a)
end

function F.cOption(name, color)
	local hex
	if color == 'orange' then
		hex = '|cffff7d0a%s |r'
	elseif color == 'blue' then
		hex = '|cFF00c0fa%s |r'
	elseif color == 'red' then
		hex = '|cFFFF0000%s |r'
	elseif color == 'gradient' then
		hex = E:TextGradient(name, 1, 0.65, 0, 1, 0.65, 0, 1, 1, 1)
	else
		hex = '|cFFFFFFFF%s |r'
	end

	return (hex):format(name)
end

do
	local gradientLine =
		E:TextGradient(
		"----------------------------------",
		0.910,
		0.314,
		0.357,
		0.976,
		0.835,
		0.431,
		0.953,
		0.925,
		0.761,
		0.078,
		0.694,
		0.671
	)

	function F.PrintGradientLine()
		print(gradientLine)
	end
end

function F.Print(text)
	if not text then
		return
	end

	local message = format("%s: %s", MER.Title, text)
	print(message)
end

function F.DebugPrint(text, msgtype)
	if not text then
		return
	end

	local message
	if msgtype == 'error' then
		message = format("%s: %s", MER.Title..MER.RedColor..L["Error"].."|r", text)
	elseif msgtype == 'warning' then
		message = format("%s: %s", MER.Title..MER.YellowColor..L["Warning"].."|r", text)
	elseif msgtype == 'info' then
		message = format("%s: %s", MER.Title..MER.InfoColor..L["Information"].."|r", text)
	end
	print(message)
end

function F.PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function F.TablePrint(tbl, indent)
	if not indent then indent = 0 end

	local formatting
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			F.TablePrint(v, indent+1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end

do
	-- Tooltip Stuff
	function F:HideTooltip()
		_G.GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		_G.GameTooltip:SetOwner(self, self.anchor, 0, 4)
		_G.GameTooltip:ClearLines()

		if self.title then
			_G.GameTooltip:AddLine(self.title)
		end

		local r, g, b

		if tonumber(self.text) then
			_G.GameTooltip:SetSpellByID(self.text)
		elseif self.text then
			if self.color == 'CLASS' then
				r, g, b = F.r, F.g, F.b
			elseif self.color == 'SYSTEM' then
				r, g, b = 1, 0.8, 0
			elseif self.color == 'BLUE' then
				r, g, b = 0.6, 0.8, 1
			elseif self.color == 'RED' then
				r, g, b = 0.9, 0.3, 0.3
			elseif self.color == 'WHITE' then
				r, g, b = 1, 1, 1
			end
			if self.blankLine then
				_G.GameTooltip:AddLine(' ')
			end

			_G.GameTooltip:AddLine(self.text, r, g, b, 1)
		end

		_G.GameTooltip:Show()
	end

	function F:AddTooltip(anchor, text, color, showTips)
		self.anchor = anchor
		self.text = text
		self.color = color
		if showTips then self.title = L["Tips"] end
		self:HookScript('OnEnter', Tooltip_OnEnter)
		self:HookScript('OnLeave', F.HideTooltip)
	end
end

-- Glow Parent
function F:CreateGlowFrame(size)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("CENTER")
	frame:SetSize(size + 4, size + 4)

	return frame
end

-- LocPanel
function F.GetIconFromID(type, id)
	local path
	if type == "item" then
		path = select(10, GetItemInfo(id))
	elseif type == "spell" then
		path = select(3, GetSpellInfo(id))
	elseif type == "achiev" then
		path = select(10, GetAchievementInfo(id))
	end
	return path or nil
end

function F.GetSpell(id)
	local name = GetSpellInfo(id)
	return name
end

function F.SplitList(list, variable, cleanup)
	if cleanup then twipe(list) end

	for word in variable:gmatch('%S+') do
		list[word] = true
	end
end

F.iLvlClassIDs = {
	[Enum.ItemClass.Gem] = Enum.ItemGemSubclass.Artifactrelic,
	[Enum.ItemClass.Armor] = 0,
	[Enum.ItemClass.Weapon] = 0,
}

do -- Tooltip scanning stuff. Credits siweia, with permission.
	local iLvlDB = {}
	local itemLevelString = "^" .. gsub(ITEM_LEVEL, "%%d", "")
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
	local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO

	local tip = CreateFrame("GameTooltip", "mUI_ScanTooltip", nil, "GameTooltipTemplate")
	F.ScanTip = tip

	function F:InspectItemTextures()
		if not tip.gems then
			tip.gems = {}
		else
			wipe(tip.gems)
		end

		for i = 1, 5 do
			local tex = _G["mUI_ScanTooltipTexture"..i]
			local texture = tex and tex:IsShown() and tex:GetTexture()
			if texture then
				tip.gems[i] = texture
			end
		end

		return tip.gems
	end

	function F:GetEnchantText(link, slotInfo)
		local enchantID = tonumber(strmatch(link, "item:%d+:(%d+):"))
		if enchantID then
			--[[for i = 1, tip:NumLines() do
				local line = _G["NDui_ScanTooltipTextLeft"..i]
				if not line then break end
				local text = line:GetText()
				if text then
					if i == 1 and text == RETRIEVING_ITEM_INFO then
						return "tooSoon"
					elseif i ~= 1 then
						local r, g, b = line:GetTextColor()
						r = B:Round(r, 3)
						g = B:Round(g, 3)
						b = B:Round(b, 3)
						if not (r == 1 and g == 1 and b == 1) then
							return text
						end
					end
				end
			end]]
			return _G.ACTION_ENCHANT_APPLIED
		end
	end

	if E.Retail then
		local slotData = { gems = {}, gemsColor = {} }
		function F.GetItemLevel(link, arg1, arg2, fullScan)
			if fullScan then
				local data = C_TooltipInfo_GetInventoryItem(arg1, arg2)
				if data then
					wipe(slotData.gems)
					wipe(slotData.gemsColor)
					slotData.iLvl = nil
					slotData.enchantText = nil

					local isHoA = data.args and data.args[2] and data.args[2].intVal == 158075
					local num = 0
					for i = 2, #data.lines do
						local lineData = data.lines[i]
						local argVal = lineData and lineData.args
						if argVal then
							if not slotData.iLvl then
								local text = argVal[2] and argVal[2].stringVal
								local found = text and strfind(text, itemLevelString)
								if found then
									local level = strmatch(text, "(%d+)%)?$")
									slotData.iLvl = tonumber(level) or 0
								end
							elseif isHoA then
								if argVal[6] and argVal[6].field == "essenceIcon" then
									num = num + 1
									slotData.gems[num] = argVal[6].intVal
									slotData.gemsColor[num] = argVal[3] and argVal[3].colorVal
								end
							else
								local lineInfo = argVal[4] and argVal[4].field
								if lineInfo == "enchantID" then
									local enchant = argVal[2] and argVal[2].stringVal
									slotData.enchantText = strmatch(enchant, enchantString)
								elseif lineInfo == "gemIcon" then
									num = num + 1
									slotData.gems[num] = argVal[4].intVal
								elseif lineInfo == "socketType" then
									num = num + 1
									slotData.gems[num] = format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", argVal[4].stringVal)
								end
							end
						end
					end
					return slotData
				end
			else
				if iLvlDB[link] then return iLvlDB[link] end

				local data
				if arg1 and type(arg1) == "string" then
					data = C_TooltipInfo_GetInventoryItem(arg1, arg2)
				elseif arg1 and type(arg1) == "number" then
					data = C_TooltipInfo_GetBagItem(arg1, arg2)
				else
					data = C_TooltipInfo_GetHyperlink(link, nil, nil, true)
				end
				if data then
					for i = 2, 5 do
						local lineData = data.lines[i]
						if not lineData then break end
						local argVal = lineData.args
						if argVal then
							local text = argVal[2] and argVal[2].stringVal
							local found = text and strfind(text, itemLevelString)
							if found then
								local level = strmatch(text, "(%d+)%)?$")
								iLvlDB[link] = tonumber(level)
								break
							end
						end
					end
				end

				return iLvlDB[link]
			end
		end
	else
		function F.GetItemLevel(link, arg1, arg2, fullScan)
			if fullScan then
				tip:SetOwner(UIParent, "ANCHOR_NONE")
				tip:SetInventoryItem(arg1, arg2)

				if not tip.slotInfo then tip.slotInfo = {} else wipe(tip.slotInfo) end

				local slotInfo = tip.slotInfo
				slotInfo.gems = F:InspectItemTextures()
				slotInfo.enchantText = F:GetEnchantText(link, slotInfo)

				return slotInfo
			else
				if iLvlDB[link] then return iLvlDB[link] end

				tip:SetOwner(UIParent, "ANCHOR_NONE")
				if arg1 and type(arg1) == "string" then
					tip:SetInventoryItem(arg1, arg2)
				elseif arg1 and type(arg1) == "number" then
					tip:SetBagItem(arg1, arg2)
				else
					tip:SetHyperlink(link)
				end

				local firstLine = _G.mUI_ScanTooltipTextLeft1:GetText()
				if firstLine == RETRIEVING_ITEM_INFO then
					return "tooSoon"
				end

				for i = 2, 5 do
					local line = _G["mUI_ScanTooltipTextLeft" .. i]
					if not line then break end

					local text = line:GetText()
					local found = text and strfind(text, itemLevelString)
					if found then
						local level = strmatch(text, "(%d+)%)?$")
						iLvlDB[link] = tonumber(level)
						break
					end
				end

				return iLvlDB[link]
			end
		end
	end

	local pattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
	function F.GetRealItemLevelByLink(link)
		E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
		E.ScanTooltip:ClearLines()
		E.ScanTooltip:SetHyperlink(link)

		for i = 2, 5 do
			local leftText = _G[E.ScanTooltip:GetName() .. "TextLeft" .. i]
			if leftText then
				local text = leftText:GetText() or ""
				local level = strmatch(text, pattern)
				if level then
					return level
				end
			end
		end
	end
end

--[[----------------------------------
--	Skin Functions
--]]----------------------------------
do
	function F:ResetTabAnchor(size, outline)
		local text = self.Text or (self.GetName and _G[self:GetName().."Text"])
		if text then
			text:SetPoint("CENTER", self)
		end
	end
	hooksecurefunc("PanelTemplates_SelectTab", F.ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", F.ResetTabAnchor)

	-- Kill regions
	F.HiddenFrame = CreateFrame('Frame')
	F.HiddenFrame:Hide()

	function F:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(F.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
    end

	function F:ReplaceIconString(text)
		if not text then text = self:GetText() end
		if not text or text == "" then return end

		local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
		if count > 0 then self:SetFormattedText("%s", newText) end
	end
end

-- Check Chat channels
function F.CheckChat(msg)
	if IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(_G.LE_PARTY_CATEGORY_HOME) then
		if msg and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(_G.LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end

	return "SAY"
end

function F.CheckPlayerBuff(spell)
	for i = 1, 40 do
		local name, _, _, _, _, _, unitCaster = UnitBuff("player", i)
		if not name then break end
		if name == spell then
			return i, unitCaster
		end
	end
	return nil
end

function F.BagSearch(itemId)
	for container = 0, _G.NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function F.Reset(group)
	if not group then print("U wot m8?") end

	if group == "marks" or group == "all" then
		E:CopyTable(E.db.mui.raidmarkers, P.raidmarkers)
		E:ResetMovers(L["Raid Marker Bar"])
	end
	E:UpdateAll()
end

-- Movable Config Buttons
local function MovableButton_Match(s,v)
	local m1, m2, m3, m4 = "^"..v.."$", "^"..v..",", ","..v.."$", ","..v..","
	return (match(s, m1) and m1) or (match(s, m2) and m2) or (match(s, m3) and m3) or (match(s, m4) and v..",")
end

function F.MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end

	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = {split(",", str)}
		for i in ipairs(tbl) do
			if tbl[i] == value then sv = i elseif tbl[i] == movehere then sm = i end
			if sv and sm then break end
		end
		tremove(tbl, sm)
		tinsert(tbl, sv, movehere)

		db[key] = tconcat(tbl,',')

	elseif found and remove then
		db[key] = gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == '' and value) or (str..","..value)
	end
end

function F.CreateMovableButtons(Order, Name, CanRemove, db, key)
	local moveItemFrom, moveItemTo

	local config = {
		order = Order,
		dragdrop = true,
		type = "multiselect",
		name = Name,
		dragOnLeave = function() end, --keep this here
		dragOnEnter = function(info)
			moveItemTo = info.obj.value
		end,
		dragOnMouseDown = function(info)
			moveItemFrom, moveItemTo = info.obj.value, nil
		end,
		dragOnMouseUp = function(info)
			F.MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = GetItemInfo(tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			F.MovableButtonSettings(db, key, moveItemFrom)
		end,
		values = function()
			local str = db[key]
			if str == "" then return nil end
			return {split(",",str)}
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then return nil end
			local tbl = {split(",",str)}
			return tbl[value]
		end,
		set = function(info, value) end,
	}

	if CanRemove then --This allows to remove
		config.dragOnClick = function(info)
			F.MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end

	return config
end

--[[----------------------------------
--	Dropdown Menu
--]]----------------------------------
do
	F.EasyMenu = CreateFrame('Frame', MER.Title .. 'EasyMenu', E.UIParent, 'UIDropDownMenuTemplate')
end

-- Inform us of the patch info we play on.
MER.WoWPatch, MER.WoWBuild, MER.WoWPatchReleaseDate, MER.TocVersion = GetBuildInfo()
MER.WoWBuild = select(2, GetBuildInfo()) MER.WoWBuild = tonumber(MER.WoWBuild)

_G["SLASH_WOWVERSION1"], _G["SLASH_WOWVERSION2"] = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	print("Patch:", MER.WoWPatch..", ".. "Build:", MER.WoWBuild..", ".. "Released", MER.WoWPatchReleaseDate..", ".. "Interface:", MER.TocVersion)
end

-- Icon Style
function F.PixelIcon(self, texture, highlight)
	if not self then return end

	self.bg = S:CreateBDFrame(self)
	self.bg:SetAllPoints()

	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:Point("TOPLEFT", E.mult, -E.mult)
	self.Icon:Point("BOTTOMRIGHT", -E.mult, E.mult)
	self.Icon:SetTexCoord(unpack(E.TexCoords))

	if texture then
		local atlas = strmatch(texture, "Atlas:(.+)$")
		if atlas then
			self.Icon:SetAtlas(atlas)
		else
			self.Icon:SetTexture(texture)
		end
	end
	if highlight and type(highlight) == "boolean" then
		self:EnableMouse(true)
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, .25)
		self.HL:SetAllPoints(self.Icon)
	end
end

-- Role Icons
function F.GetRoleTexCoord(role)
	if role == "TANK" then
		return .32/9.03, 2.04/9.03, 2.65/9.03, 4.3/9.03
	elseif role == "DPS" or role == "DAMAGER" then
		return 2.68/9.03, 4.4/9.03, 2.65/9.03, 4.34/9.03
	elseif role == "HEALER" then
		return 2.68/9.03, 4.4/9.03, .28/9.03, 1.98/9.03
	elseif role == "LEADER" then
		return .32/9.03, 2.04/9.03, .28/9.03, 1.98/9.03
	elseif role == "READY" then
		return 5.1/9.03, 6.76/9.03, .28/9.03, 1.98/9.03
	elseif role == "PENDING" then
		return 5.1/9.03, 6.76/9.03, 2.65/9.03, 4.34/9.03
	elseif role == "REFUSE" then
		return 2.68/9.03, 4.4/9.03, 5.02/9.03, 6.7/9.03
	end
end

function F.ReskinRole(self, role)
	if self.background then self.background:SetTexture("") end
	local cover = self.cover or self.Cover
	if cover then cover:SetTexture("") end
	local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self)
	if texture then
		texture:SetTexture(E.media.roleIcons)
		texture:SetTexCoord(F.GetRoleTexCoord(role))
	end

	local checkButton = self.checkButton or self.CheckButton or self.CheckBox
	if checkButton then
		checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
		checkButton:Point("BOTTOMLEFT", -2, -2)
	end

	local shortageBorder = self.shortageBorder
	if shortageBorder then
		shortageBorder:SetTexture("")
		local icon = self.incentiveIcon
		icon:Point("BOTTOMRIGHT")
		icon:Size(14, 14)
		icon.texture:SetSize(14, 14)
		icon.border:SetTexture("")
	end
end

-- Atlas info
function F.GetTextureStrByAtlas(info, sizeX, sizeY)
	local file = info and info.file
	if not file then return end

	local width, height, txLeft, txRight, txTop, txBottom = info.width, info.height, info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
	local atlasWidth = width / (txRight-txLeft)
	local atlasHeight = height / (txBottom-txTop)

	return format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", file, (sizeX or 0), (sizeY or 0), atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
end

-- Check Textures
local txframe = CreateFrame('Frame')
local tx = txframe:CreateTexture()

function F:TextureExists(path)
	if not path or path == '' then
		return F.DebugPrint('Path not valid or defined.', 'error')
	end
	tx:SetTexture('?')
	tx:SetTexture(path)

	return (tx:GetTexture())
end

-- GUID to npcID
function F.GetNPCID(guid)
	local id = tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
	return id
end

function F.SplitString(delimiter, subject)
	if not subject or subject == "" then
		return {}
	end

	local length = strlen(delimiter)
	local results = {}

	local i = 0
	local j = 0

	while true do
		j = strfind(subject, delimiter, i + length)
		if strlen(subject) == i then
			break
		end

		if j == nil then
			tinsert(results, strsub(subject, i))
			break
		end

		tinsert(results, strsub(subject, i, j - 1))
		i = j + length
	end

	return unpack(results)
end

function F.SetCallback(callback, target, times, ...)
	times = times or 0
	if times >= 10 then
		return
	end

	if times < 10 then
		local result = {pcall(target, ...)}
		if result and result[1] == true then
			tremove(result, 1)
			if callback(unpack(result)) then
				return
			end
		end
	end

	E:Delay(0.1, F.SetCallback, callback, target, times+1, ...)
end

do
	-- Handle close button
	function F:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				self.__texture:SetVertexColor(0, .6, 1, 1)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.__texture:SetVertexColor(1, 1, 1, 1)
		end
	end
end

function F:TogglePanel(frame)
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end

function F.In(val, tbl)
	if not val or not tbl or type(tbl) ~= "table" then
		return false
	end

	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

function F.IsNaN(val)
	return tostring(val) == tostring(0 / 0)
end

function F.Or(val, default)
	if not val or F.IsNaN(val) then
		return default
	end
	return val
end

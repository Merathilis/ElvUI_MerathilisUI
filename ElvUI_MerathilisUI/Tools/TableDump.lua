local MER, E, L, V, P, G = unpack(select(2, ...))

local type, pairs, ipairs, tinsert, strrep, tostring, tremove, wipe, pcall, format, loadstring = type, pairs, ipairs, tinsert, strrep, tostring, tremove, wipe, pcall, format, loadstring
local GameFontHighlightSmall = GameFontHighlightSmall
local GameTooltip_Hide = GameTooltip_Hide
local TableToLuaString
local TableToPluginFormat

do
	local function recurse(table, level, ret)
		for i,v in pairs(table) do
			ret = ret..strrep('    ', level)..'['
			if type(i) == 'string' then ret = ret..'"'..i..'"' else ret = ret..tostring(i) end
			ret = ret..'] = '

			if type(v) == 'number' then
				ret = ret..v..',\n'
			elseif type(v) == 'string' then
				ret = ret..'"'..v:gsub('\\', '\\\\'):gsub('\n', '\\n'):gsub('"', '\\"'):gsub('\124', '\124\124')..'",\n'
			elseif type(v) == 'boolean' then
				if v then ret = ret..'true,\n' else ret = ret..'false,\n' end
			elseif type(v) == 'table' then
				ret = ret..'{\n'
				ret = recurse(v, level + 1, ret)
				ret = ret..strrep('    ', level)..'},\n'
			else
				ret = ret..'"'..tostring(v)..'",\n'
			end
		end

		return ret
	end

	function TableToLuaString(inTable)
		local ret = '{\n'
		if inTable then ret = recurse(inTable, 1, ret) end
		ret = ret..'}'

		return ret
	end
end

do
	local lineStructureTable = {}

	local function buildLineStructure(str)
		for _, v in ipairs(lineStructureTable) do
			if type(v) == 'string' then
				str = str..'["'..v..'"]'
			else
				str = str..'['..tostring(v)..']'
			end
		end

		return str
	end

	local sameLine
	local function recurse(tbl, ret, tableName)
		local lineStructure = buildLineStructure(tableName)
		for k, v in pairs(tbl) do
			if not sameLine then
				ret = ret..lineStructure
			end

			ret = ret..'['

			if type(k) == 'string' then
				ret = ret..'"'..k..'"'
			else
				ret = ret..tostring(k)
			end

			if type(v) == 'table' then
				tinsert(lineStructureTable, k)
				sameLine = true
				ret = ret..']'
				ret = recurse(v, ret, tableName)
			else
				sameLine = false
				ret = ret..'] = '

				if type(v) == 'number' then
					ret = ret..v..'\n'
				elseif type(v) == 'string' then
					ret = ret..'"'..v:gsub('\\', '\\\\'):gsub('\n', '\\n'):gsub('"', '\\"'):gsub('\124', '\124\124')..'"\n'
				elseif type(v) == 'boolean' then
					if v then
						ret = ret..'true\n'
					else
						ret = ret..'false\n'
					end
				else
					ret = ret..'"'..tostring(v)..'"\n'
				end
			end
		end

		tremove(lineStructureTable)

		return ret
	end

	function TableToPluginFormat(t, tableName)
		wipe(lineStructureTable)
		local ret = ''
		sameLine = false
		ret = recurse(t, ret, tableName)

		return ret
	end
end

local function DumpTable(t, tableName, dumpFormat)
	local result

	if dumpFormat == 'luaTable' then
		result = TableToLuaString(t)
	elseif dumpFormat == 'luaPlugin' then
		result = TableToPluginFormat(t, tableName)
	end

	return result
end

local dumpResult = ""
function MER:OpenTableDumper()
	local dumpTypeItems = {
		["luaTable"] = L["Table"],
		["luaPlugin"] = L["Plugin"]
	}
	local dumpTypeListOrder = {
		"luaTable",
		"luaPlugin"
	}

	local Frame = E.Libs.AceGUI:Create("Frame")
	Frame:SetTitle(L["Table Dumper"])
	Frame:EnableResize(false)
	Frame:SetWidth(800)
	Frame:SetHeight(600)
	Frame.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	Frame:SetLayout("flow")

	local Box = E.Libs.AceGUI:Create("MultiLineEditBox")
	Box:SetNumLines(30)
	Box:DisableButton(true)
	Box:SetWidth(800)
	Box:SetLabel("")
	Frame:AddChild(Box)
	--Save original script so we can restore it later
	Box.editBox.OnTextChangedOrig = Box.editBox:GetScript("OnTextChanged")
	Box.editBox.OnCursorChangedOrig = Box.editBox:GetScript("OnCursorChanged")
	--Remove OnCursorChanged script as it causes weird behaviour with long text
	Box.editBox:SetScript("OnCursorChanged", nil)
	Box.scrollFrame:UpdateScrollChildRect()

	local Label1 = E.Libs.AceGUI:Create("Label")
	local font = GameFontHighlightSmall:GetFont()
	Label1:SetFont(font, 14)
	Label1:SetText(".") --Set temporary text so height is set correctly
	Label1:SetWidth(800)
	Frame:AddChild(Label1)

	local TableNameEdit = E.Libs.AceGUI:Create("EditBox")
	TableNameEdit:SetLabel(L["Table Name"])
	Frame:AddChild(TableNameEdit)

	local DumpFormatDropdown = E.Libs.AceGUI:Create("Dropdown")
	DumpFormatDropdown:SetMultiselect(false)
	DumpFormatDropdown:SetLabel(L["Choose Dump Format"])
	DumpFormatDropdown:SetList(dumpTypeItems, dumpTypeListOrder)
	DumpFormatDropdown:SetValue("luaPlugin") --Default format
	DumpFormatDropdown:SetWidth(150)
	Frame:AddChild(DumpFormatDropdown)

	local exportButton = E.Libs.AceGUI:Create("Button")
	exportButton:SetText(L["Dump Now"])
	exportButton:SetAutoWidth(true)
	exportButton:SetCallback("OnClick", function()
		Label1:SetText("")

		local tableName, dumpFormat = TableNameEdit:GetText(), DumpFormatDropdown:GetValue()
		local f, err = loadstring("return "..tableName)
		local t
		if not err then
			local status
			status, t = pcall(f)
		end

		if type(t) ~= 'table' then
			Label1:SetText(format(L["Table %s does not exist"], tableName))
			return
		end

		local result = DumpTable(t, tableName, dumpFormat)

		Label1:SetText(format("%s: %s%s|r", L["Dumped"], E.media.hexvaluecolor, tableName))

		Box:SetText(result)
		Box.editBox:HighlightText()
		Box:SetFocus()

		dumpResult = result
	end)
	Frame:AddChild(exportButton)

	--Set scripts
	Box.editBox:SetScript("OnChar", function()
		Box:SetText(dumpResult)
		Box.editBox:HighlightText()
	end)
	Box.editBox:SetScript("OnTextChanged", function(_, userInput)
		if userInput then
			--Prevent user from changing export string
			Box:SetText(dumpResult)
			Box.editBox:HighlightText()
		else
			--Scroll frame doesn't scroll to the bottom by itself, so let's do that now
			Box.scrollFrame:SetVerticalScroll(Box.scrollFrame:GetVerticalScrollRange())
		end
	end)

	Frame:SetCallback("OnClose", function(widget)
		--Restore changed scripts
		Box.editBox:SetScript("OnChar", nil)
		Box.editBox:SetScript("OnTextChanged", Box.editBox.OnTextChangedOrig)
		Box.editBox:SetScript("OnCursorChanged", Box.editBox.OnCursorChangedOrig)
		Box.editBox.OnTextChangedOrig = nil
		Box.editBox.OnCursorChangedOrig = nil

		--Clear stored export string
		dumpResult = ""

		E.Libs.AceGUI:Release(widget)
		E:Config_OpenWindow()
	end)

	--Clear default text
	Label1:SetText("")

	--Close ElvUI OptionsUI
	E.Libs.AceConfigDialog:Close("ElvUI")

	GameTooltip_Hide()
end

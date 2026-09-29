local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.Table = {}

local pairs, next, rawset, select, type = pairs, next, rawset, select, type
local tinsert = table.insert

---@param tbl table?
---@return boolean
function F.Table.IsEmpty(tbl)
	return not tbl or next(tbl) == nil
end

---Walk down the given keys and create missing sub tables on the way
---@param tbl table
---@param ... any Keys
---@return table
function F.Table.GetOrCreate(tbl, ...)
	local currentTable = tbl

	for i = 1, select("#", ...) do
		local key = (select(i, ...))
		if type(currentTable[key]) ~= "table" then
			currentTable[key] = {}
		end
		currentTable = currentTable[key]
	end

	return currentTable
end

---Shallow merge into a new table; array entries are appended, other keys overwrite
---@param ... table?
---@return table
function F.Table.Join(...)
	local ret = {}

	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(k) == "number" then
					tinsert(ret, v)
				else
					ret[k] = v
				end
			end
		end
	end

	return ret
end

---Deep merge the given tables into `ret` (in place)
---@param ret table
---@param ... table?
function F.Table.Crush(ret, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(v) == "table" and type(ret[k]) == "table" then
					F.Table.Crush(ret[k], v)
				else
					rawset(ret, k, v)
				end
			end
		end
	end
end

---"#rrggbb" or "#rrggbbaa" to { r, g, b[, a] }
---@param hex string
---@return table
function F.Table.HexToRGB(hex)
	local r, g, b, a = F.String.HexToRGB(hex)
	return { r = r, g = g, b = b, a = a }
end

---Pack varargs including trailing nils, `n` holds the count
function F.Table.SafePack(...)
	return { n = select("#", ...), ... }
end

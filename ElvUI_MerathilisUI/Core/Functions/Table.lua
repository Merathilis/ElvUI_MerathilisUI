local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.Table = {}

local pairs, next, type, select, unpack = pairs, next, type, select, unpack
local tinsert = table.insert

function F.Table.IsEmpty(tbl)
	return next(tbl) == nil
end

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

function F.Table.Crush(ret, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(v) == "table" and type(ret[k] or false) == "table" then
					F.Table.Crush(ret[k], v)
				else
					rawset(ret, k, v)
				end
			end
		end
	end
end

function F.Table.RGB(r, g, b, a)
	local ret = {
		r = r,
		g = g,
		b = b,
	}

	if a then
		ret.a = a
	end

	return ret
end

function F.Table.HexToRGB(hex)
	local r, g, b, a = F.String.HexToRGB(hex)
	return F.Table.RGB(r, g, b, a)
end

function F.Table.SafePack(...)
	return { n = select("#", ...), ... }
end

function F.Table.SafeUnpack(tbl)
	return unpack(tbl, 1, tbl.n)
end

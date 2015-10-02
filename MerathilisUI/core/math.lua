local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

function E:ShortValue(v)
	if v >= 1e9 then
		return ("%.fb"):format(v / 1e9):gsub("%.?+([kmb])$", "%1")
	elseif v >= 1e6 then
		return ("%.fm"):format(v / 1e6):gsub("%.?+([kmb])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.fk"):format(v / 1e3):gsub("%.?+([kmb])$", "%1")
	else
		return v
	end
end
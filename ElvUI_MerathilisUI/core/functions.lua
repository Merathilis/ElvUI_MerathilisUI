local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local print = print
local format = format

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:Print(msg)
	print(E["media"].hexvaluecolor..'MUI:|r', msg)
end

local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis Eule'] = {
	['installed'] = nil,
}
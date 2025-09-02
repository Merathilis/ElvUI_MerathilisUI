local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local next, pairs = next, pairs
local format = format
local xpcall = xpcall

module:SecureHook(_G.LibStub, "NewLibrary", "LibStub_NewLibrary")
for libName in pairs(_G.LibStub.libs) do
	local lib, minor = _G.LibStub(libName, true)
	if lib and module.libraryHandlers[libName] then
		module.libraryHandledMinors[libName] = minor
		for _, func in next, module.libraryHandlers[libName] do
			if not xpcall(func, F.Developer.ThrowError, module, lib) then
				module:Log("debug", format("Failed to skin library %s", libName, minor))
			end
		end
	end
end

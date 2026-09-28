local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local next = next
local pcall = pcall
local tostring = tostring
local type = type

local SerializeCBOR = C_EncodingUtil.SerializeCBOR
local DeserializeCBOR = C_EncodingUtil.DeserializeCBOR
local CompressString = C_EncodingUtil.CompressString
local DecompressString = C_EncodingUtil.DecompressString
local EncodeBase64 = C_EncodingUtil.EncodeBase64
local DecodeBase64 = C_EncodingUtil.DecodeBase64

local COMPRESS = Enum.CompressionMethod.Deflate or 0
local OPTIMIZE = Enum.CompressionLevel.Default or 0

-- Separates the profile and the private part of an export string (not part of the Base64 alphabet)
local SEPARATOR = "{}"

F.Profiles = {}

-- Keys that RemoveTableDuplicates must keep even when they match the defaults
local generatedKeys = {
	profile = {},
	private = {},
}

---Serialize, compress and Base64 encode a table
---@param data table
---@return string
function F.Profiles.GenerateString(data)
	return EncodeBase64(CompressString(SerializeCBOR(data), COMPRESS, OPTIMIZE))
end

---Decode a string made by GenerateString
---@param dataString string
---@return table? data
---@return string? err
function F.Profiles.ExtractString(dataString)
	local ok, decoded = pcall(DecodeBase64, dataString)
	if not ok or not decoded then
		return nil, "Error decoding data."
	end

	local decompressed
	ok, decompressed = pcall(DecompressString, decoded, COMPRESS)
	if not ok or not decompressed then
		return nil, "Error decompressing data."
	end

	local data
	ok, data = pcall(DeserializeCBOR, decompressed)
	if not ok or type(data) ~= "table" then
		return nil, "Error deserializing: " .. tostring(data)
	end

	return data
end

---Export string of the MerathilisUI profile and/or private settings (only values that differ from the defaults)
---@param profile boolean
---@param private boolean
---@return string
function F.Profiles.GetOutputString(profile, private)
	local profileData = {}
	if profile then
		profileData = E:CopyTable(profileData, E.db.mui)
		profileData = E:RemoveTableDuplicates(profileData, P, generatedKeys.profile)
	end

	local privateData = {}
	if private then
		privateData = E:CopyTable(privateData, E.private.mui)
		privateData = E:RemoveTableDuplicates(privateData, V, generatedKeys.private)
	end

	return F.Profiles.GenerateString(profileData) .. SEPARATOR .. F.Profiles.GenerateString(privateData)
end

---Import a string made by GetOutputString. Nothing is changed unless both parts decode.
---@param importString string
---@return boolean success
function F.Profiles.ImportByString(importString)
	local profileString, privateString
	if type(importString) == "string" then
		profileString, privateString = E:SplitString(importString, SEPARATOR)
	end

	if not profileString or not privateString then
		F.Print(F.String.Error("Error importing profile. String is invalid or corrupted!"))
		return false
	end

	local profileData, profileErr = F.Profiles.ExtractString(profileString)
	local privateData, privateErr = F.Profiles.ExtractString(privateString)
	if not profileData or not privateData then
		F.Print(F.String.Error(profileErr or privateErr))
		return false
	end

	if next(profileData) ~= nil then
		E:CopyTable(E.db.mui, P)
		E:CopyTable(E.db.mui, profileData)
	end

	if next(privateData) ~= nil then
		E:CopyTable(E.private.mui, V)
		E:CopyTable(E.private.mui, privateData)
	end

	return true
end

local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local next = next
local type = type

local SerializeCBOR = C_EncodingUtil.SerializeCBOR
local DeserializeCBOR = C_EncodingUtil.DeserializeCBOR
local CompressString = C_EncodingUtil.CompressString
local DecompressString = C_EncodingUtil.DecompressString
local EncodeBase64 = C_EncodingUtil.EncodeBase64
local DecodeBase64 = C_EncodingUtil.DecodeBase64

local COMPRESS = Enum.CompressionMethod.Deflate or 0
local OPTIMIZE = Enum.CompressionLevel.Default or 0

---@cast F Functions
F.Profiles = {}

---@type table Generated keys configuration for profile data
local generatedKeys = {
	profile = {},
	private = {},
}

---@class Functions
---Generate compressed and encoded string from data
---@param data table The data to serialize and compress
---@return string encodedString The compressed and encoded string
function F.Profiles.GenerateString(data)
	local exportString = SerializeCBOR(data)
	local compressedData = CompressString(exportString, COMPRESS, OPTIMIZE)
	local encodedData = EncodeBase64(compressedData)

	return encodedData
end

---@class Functions
---Extract and deserialize data from encoded string
---@param dataString string The encoded data string
---@return table? data The deserialized data or nil if failed
function F.Profiles.ExactString(dataString)
	local decodedData = DecodeBase64(dataString)
	if not decodedData then
		F.Print("Error decoding data.")
		return
	end

	local decompressed = DecompressString(decodedData, COMPRESS)
	if not decompressed then
		F.Print("Error decompressing data.")
		return
	end

	local success, data = pcall(DeserializeCBOR, decompressed)
	if not success or type(data) ~= "table" then
		F.Print("Error deserializing: " .. tostring(data))
		return
	end

	return data
end

---@class Functions
---Get output string for profile and private data export
---@param profile boolean Include profile data in export
---@param private boolean Include private data in export
---@return string outputString The combined export string
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

	return F.Profiles.GenerateString(profileData) .. "{}" .. F.Profiles.GenerateString(privateData)
end

---@class Functions
---Import profile and private data from string
---@param importString string The import string containing profile and private data
function F.Profiles.ImportByString(importString)
	local profileString, privateString = E:SplitString(importString, "{}")
	if not profileString or not privateString then
		F.Print("Error importing profile. String is invalid or corrupted!")
	end

	local profileData = F.Profiles.ExactString(profileString)
	local privateData = F.Profiles.ExactString(privateString)

	if profileData and type(next(profileData)) ~= "nil" then
		E:CopyTable(E.db.mui, P)
		E:CopyTable(E.db.mui, profileData)
	end

	if privateData and type(next(privateData)) ~= "nil" then
		E:CopyTable(E.private.mui, V)
		E:CopyTable(E.private.mui, privateData)
	end
end

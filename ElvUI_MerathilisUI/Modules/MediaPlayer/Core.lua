local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MediaPlayer") ---@class MediaPlayer

-- Media Player: browse the game's music by expansion and zone, play it as a
-- playlist and replay the cinematics. Nothing is built before the window opens
-- the first time, until then the module only holds the raw strings of Data.lua.

local _G = _G
local gmatch, gsub, strlower, strsplit = string.gmatch, string.gsub, string.lower, strsplit
local ipairs, pairs, tonumber, tostring, type = ipairs, pairs, tonumber, tostring, type
local sort, tinsert = table.sort, table.insert

local C_Map_GetAreaInfo = C_Map.GetAreaInfo
local C_Sound_IsPlaying = C_Sound.IsPlaying
local C_Timer_After = C_Timer.After
local C_Timer_NewTicker = C_Timer.NewTicker
local GetCVarBool = C_CVar.GetCVarBool
local InCombatLockdown = InCombatLockdown
local IsMoviePlayable = IsMoviePlayable
local PlaySoundFile = PlaySoundFile
local SetCVar = C_CVar.SetCVar
local StopSound = StopSound

-- Section order inside an expansion, the letters come from Data.lua
local KIND_ORDER = { z = 1, d = 2, r = 3, p = 4, s = 5, o = 6 }

-- How many unplayable files in a row are skipped before the playlist gives up
local MAX_SKIPS = 10

local function Debug(...)
	F.Developer.Debug("MediaPlayer", ...)
end

function module:GetKindLabel(kind)
	if not self.kindLabels then
		self.kindLabels = {
			z = L["Zones"],
			d = L["Dungeons"],
			r = L["Raids"],
			p = L["Battlegrounds & Arenas"],
			s = L["Scenarios"],
			o = L["Other Music"],
		}
	end

	return self.kindLabels[kind]
end

---Display name of a track, from its file name
---@param fileID number
---@return string
function module:GetTrackName(fileID)
	local name = self.library.names[fileID]
	return name and gsub(name, "_", " ") or tostring(fileID)
end

-- -----------------------------------------------------------------------------
-- Library
-- -----------------------------------------------------------------------------

local function ParseZones(category, lines)
	for _, line in ipairs(lines) do
		local areaID, kind, english, ids = strsplit("|", line)
		areaID = tonumber(areaID)

		local localized = areaID > 0 and C_Map_GetAreaInfo(areaID)
		local zone = {
			name = (localized and localized ~= "") and localized or english,
			kind = kind,
			category = category,
			tracks = {},
		}

		for id in gmatch(ids, "%d+") do
			tinsert(zone.tracks, tonumber(id))
		end

		-- Folder entries of an expansion all read "Other Music"
		if kind == "o" and areaID == 0 and category.expansion then
			zone.name = module:GetKindLabel("o")
		end

		zone.search = strlower(zone.name)
		tinsert(category.zones, zone)
	end

	sort(category.zones, function(a, b)
		if a.kind ~= b.kind then
			return KIND_ORDER[a.kind] < KIND_ORDER[b.kind]
		end

		return a.search < b.search
	end)
end

---Builds the browsable library from Data.lua and Movies.lua on first use
---@return table library { categories, names }
function module:GetLibrary()
	if self.library then
		return self.library
	end

	local data = self.MusicData
	local names = {}
	for id, name in gmatch(data.names, "(%d+) ([^\n]+)") do
		names[tonumber(id)] = name
	end

	local expansions = {}
	for key in pairs(data) do
		if type(key) == "number" then
			tinsert(expansions, key)
		end
	end
	for key in pairs(self.Movies) do
		if not data[key] then
			tinsert(expansions, key)
		end
	end
	sort(expansions, function(a, b)
		return a > b
	end)

	local categories = {}
	for _, expansion in ipairs(expansions) do
		local category = {
			key = expansion,
			expansion = expansion,
			name = _G["EXPANSION_NAME" .. expansion] or tostring(expansion),
			zones = {},
			movies = {},
		}

		for _, movie in ipairs(self.Movies[expansion] or {}) do
			tinsert(category.movies, {
				id = movie[1],
				name = movie[2],
				search = strlower(movie[2]),
				category = category,
			})
		end

		ParseZones(category, data[expansion] or {})
		tinsert(categories, category)
	end

	local various = { key = "various", name = L["Various"], zones = {}, movies = {} }
	ParseZones(various, data.various)
	tinsert(categories, various)

	self.library = { categories = categories, names = names }

	-- The parsed tables replace the raw strings
	self.MusicData = nil
	self.Movies = nil

	return self.library
end

---Tracks, zones and cinematics whose name contains the text
---@param text string lower case search text
---@return table results row data for the window
function module:Search(text)
	local library = self:GetLibrary()
	local zones, movies, tracks = {}, {}, {}
	local seen = {}

	for _, category in ipairs(library.categories) do
		for _, movie in ipairs(category.movies) do
			if movie.search:find(text, 1, true) then
				tinsert(movies, { type = "movie", movie = movie })
			end
		end

		for _, zone in ipairs(category.zones) do
			if zone.search:find(text, 1, true) then
				tinsert(zones, { type = "zone", zone = zone })
			end

			for index, fileID in ipairs(zone.tracks) do
				-- One row per file, the first zone that plays it names it
				if not seen[fileID] then
					local name = library.names[fileID]
					if name and strlower(name):find(text, 1, true) then
						seen[fileID] = true
						tinsert(tracks, { type = "track", zone = zone, index = index })
					end
				end
			end
		end
	end

	local results = {}
	local function AddSection(label, rows)
		if #rows > 0 then
			tinsert(results, { type = "header", text = label })
			for _, row in ipairs(rows) do
				tinsert(results, row)
			end
		end
	end

	AddSection(L["Cinematics"], movies)
	AddSection(L["Zones"], zones)
	AddSection(L["Tracks"], tracks)

	return results
end

-- -----------------------------------------------------------------------------
-- Game music
-- -----------------------------------------------------------------------------

-- The tracks play on the master channel, the zone music would play over them.
-- It's switched off for the time a track plays and back on afterwards; the
-- saved flag also restores it after a crash or a logout mid-track.
local musicMuted = false

local function RestoreGameMusic()
	if musicMuted then
		SetCVar("Sound_EnableMusic", "1")
		musicMuted = false
	end

	E.global.mui.mediaPlayer.restoreMusic = false
	module:UnregisterEvent("PLAYER_LOGOUT")
end

local function MuteGameMusic()
	if musicMuted or not GetCVarBool("Sound_EnableMusic") then
		return
	end

	SetCVar("Sound_EnableMusic", "0")
	musicMuted = true
	E.global.mui.mediaPlayer.restoreMusic = true
	module:RegisterEvent("PLAYER_LOGOUT", RestoreGameMusic)
end

-- -----------------------------------------------------------------------------
-- Playback
-- -----------------------------------------------------------------------------

-- module.playing = { zone, index, handle } while a track plays
local ticker

local function StopTicker()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
end

local function OnTick()
	local playing = module.playing
	if not playing then
		StopTicker()
		return
	end

	-- There is no event for the end of a sound file, its handle tells
	if not C_Sound_IsPlaying(playing.handle) then
		module:Next()
	end
end

---Plays a track of a zone and continues with the following ones, looping the zone
---@param zone table
---@param index number
function module:PlayTrack(zone, index)
	local tracks = zone.tracks
	local count = #tracks

	if self.playing then
		StopSound(self.playing.handle)
		self.playing = nil
	end

	for _ = 1, MAX_SKIPS do
		local fileID = tracks[index]
		local willPlay, handle = PlaySoundFile(fileID, "Master")

		if willPlay then
			MuteGameMusic()
			self.playing = { zone = zone, index = index, handle = handle, fileID = fileID }
			Debug("play", fileID, self.library.names[fileID])

			if not ticker then
				ticker = C_Timer_NewTicker(1, OnTick)
			end

			self:UpdateWindow()
			return
		end

		Debug("not playable, skipping", fileID)
		index = index % count + 1
	end

	self:Stop()
end

function module:Next()
	local playing = self.playing
	if playing then
		self:PlayTrack(playing.zone, playing.index % #playing.zone.tracks + 1)
	end
end

function module:Previous()
	local playing = self.playing
	if playing then
		local count = #playing.zone.tracks
		self:PlayTrack(playing.zone, (playing.index - 2) % count + 1)
	end
end

function module:Stop()
	if self.playing then
		StopSound(self.playing.handle)
		self.playing = nil
	end

	StopTicker()
	RestoreGameMusic()
	self:UpdateWindow()
end

-- -----------------------------------------------------------------------------
-- Cinematics
-- -----------------------------------------------------------------------------

function module:IsMoviePlayable(movieID)
	return IsMoviePlayable(movieID)
end

---Plays a cinematic through Blizzard's MovieFrame, the path the game uses itself.
---An own MovieFrame widget only shows a black screen.
---@param movieID number
function module:PlayMovie(movieID)
	if InCombatLockdown() then
		F.Print(L["Cinematics can't be played in combat."])
		return
	end

	if not IsMoviePlayable(movieID) then
		F.Print(L["This cinematic is not available, it may still be downloading."])
		return
	end

	local movieFrame = _G.MovieFrame
	if not movieFrame then
		return
	end

	self:Stop()
	Debug("movie", movieID)
	movieFrame:PlayMovie(movieID)
end

-- -----------------------------------------------------------------------------
-- Setup
-- -----------------------------------------------------------------------------

function module:Toggle()
	if E.Forever then
		return
	end

	local window = self:GetWindow()
	window:SetShown(not window:IsShown())
end

---Swaps the options window for the player, the options come back when it closes
function module:OpenFromOptions()
	-- Not from inside the options click: AceConfigDialog still reads its
	-- window after the button's func returns
	C_Timer_After(0, function()
		E:ToggleOptions()
		self.reopenOptions = true

		local window = self:GetWindow()
		window:Show()
		window:Raise()
	end)
end

function module:Initialize()
	-- The last session ended while a track played
	if E.global.mui.mediaPlayer.restoreMusic then
		SetCVar("Sound_EnableMusic", "1")
		E.global.mui.mediaPlayer.restoreMusic = false
	end
end

MER:AddCommand("MEDIAPLAYER", { "/muimedia" }, function()
	module:Toggle()
end)

MER:RegisterModule(module:GetName())

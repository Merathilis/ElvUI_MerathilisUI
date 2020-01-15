local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("PVP", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G
local format = string.format
local band = bit.band
local twipe = table.wipe
--WoW API / Variables
local CancelDuel = CancelDuel
local CancelPetPVPDuel = C_PetBattles.CancelPVPDuel
local StaticPopup_Hide = StaticPopup_Hide
local GetBattlefieldScore = GetBattlefieldScore
local GetNumBattlefieldScores = GetNumBattlefieldScores
local TopBannerManager_Show = TopBannerManager_Show
local BossBanner_BeginAnims = BossBanner_BeginAnims
local PlaySound = PlaySound
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local Opponents = {}

-- Credits: Shadow&Light

function module:BlockDuel(event, name)
	local cancelled = false

	if event == "DUEL_REQUESTED" and module.db.duels.regular then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "REGULAR"
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" and module.db.duels.pet then
		CancelPetPVPDuel()
		StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
		cancelled = "PET"
	end

	if cancelled then
		MER:Print(format(L["MER_DuelCancel_"..cancelled], name))
	end
end

-- Building opponents table for boss banner
function module:OpponentsTable()
	twipe(Opponents)

	for index = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, classToken = GetBattlefieldScore(index)
		if (E.myfaction == "Horde" and faction == 1) or (E.myfaction == "Alliance" and faction == 0) then
			Opponents[name] = classToken --Saving oponents class to use for coloring
		end
	end
end

--Parse combat log for killing blows
function module:LogParse()
	local _, subevent, _, _, Caster, _, _, _, TargetName, TargetFlags = CombatLogGetCurrentEventInfo()

	if subevent == "PARTY_KILL" then
		local mask = band(TargetFlags, COMBATLOG_OBJECT_TYPE_PLAYER) --Don't ask me, it's some dark magic. If bit mask for this is positive, it means a player was killed
		if Caster == E.myname and (Opponents[TargetName] or mask > 0) then --If this is my kill and target is a player (world) or in the oponents table (BGs)
			if mask > 0 and Opponents[TargetName] then
				TargetName = "|c"..RAID_CLASS_COLORS[Opponents[TargetName]].colorStr..TargetName.."|r"
			end --Color dat name into class color. Only for BGs

			TopBannerManager_Show(_G["BossBanner"], { name = TargetName, mode = "MER_PVPKILL" }); --Show boss banner with own mode and a dead person's name instead of boss name
		end
	end
end


function module:Initialize()
	module.db = E.db.mui.pvp
	MER:RegisterDB(self, "pvp")

	function module:ForUpdateAll()
		module.db = E.db.mui.pvp
	end

	self:RegisterEvent("DUEL_REQUESTED", "BlockDuel")
	self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", "BlockDuel")

	if E.db.mui.pvp.killingBlow.enable then
		--Hook to blizz function for boss kill banner
		hooksecurefunc(_G["BossBanner"], "PlayBanner", function(self, data)
			if (data) then
				if (data.mode == "MER_PVPKILL") then
					self.Title:SetText(data.name)
					self.Title:Show()
					self.SubTitle:Hide()
					self:Show()
					BossBanner_BeginAnims(self)
					if E.db.mui.pvp.killingBlow.sound then
						PlaySound(SOUNDKIT.UI_RAID_BOSS_DEFEATED)
					end
				end
			end
		end)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "LogParse")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE", "OpponentsTable")
	end
end

MER:RegisterModule(module:GetName())

local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Notification

local GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local GetFactionInfoByID = C_Reputation.GetFactionDataByID
local GetQuestLogCompletionText = GetQuestLogCompletionText
local PlaySound = PlaySound

-- Credits: Paragon Reputation
local PARAGON_QUEST_ID = {
	--War Within
	[79219] = { -- Council of Dornogal
		factionID = 2590,
		cache = 225239,
	},
	[79218] = { -- Hallowfall Arathi
		factionID = 2570,
		cache = 225246,
	},
	[79220] = { -- The Assembly of the Deep
		factionID = 2594,
		cache = 225245,
	},
	[79196] = { -- The Severed Threads
		factionID = 2600,
		cache = 225247,
	},
	[83739] = { -- The General
		factionID = 2605,
		cache = 226045,
	},
	[83740] = { -- The Vizier
		factionID = 2607,
		cache = 226100,
	},
	[83738] = { -- The Weaver
		factionID = 2601,
		cache = 226103,
	},
}

function module:QUEST_ACCEPTED(_, arg1)
	module.db = E.db.mui.notification
	if not module.db.enable then
		return
	end

	if module.db.paragon and PARAGON_QUEST_ID[arg1] then
		local data = GetFactionInfoByID(PARAGON_QUEST_ID[arg1].factionID)
		local text = GetQuestLogCompletionText(GetLogIndexForQuestID(arg1))
		PlaySound(618, "Master") -- QUEST ADDED
		self:DisplayToast(
			data.name,
			text,
			nil,
			"Interface\\Icons\\Achievement_Quests_Completed_08",
			0.08,
			0.92,
			0.08,
			0.92
		)
	end
end

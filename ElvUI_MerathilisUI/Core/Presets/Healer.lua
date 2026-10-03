local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local ipairs = ipairs

-- Cropped to the group frames, the player block and the action bars, at the width : height of the preset cards
local PREVIEW_COORDS = { 0.17, 0.83, 0.51, 0.94 }

-- Group frames in the middle of the screen, above the player and target frames
local GROUP_POSITION = "BOTTOM,UIParent,BOTTOM,0,300"

-- The player block moves down towards the action bars to make room for the group frames.
-- SkironCooldownManager anchors the cooldown viewer to the power and class bar, it follows them.
-- Target of target and pet keep their place next to the moved frames, below the portraits.
local PLAYER_BLOCK_OFFSET = -60
local PLAYER_BLOCK = {
	"ElvUF_PlayerMover",
	"ElvUF_TargetMover",
	"ElvUF_TargetCastbarMover",
	"ElvUF_TargetTargetMover",
	"ElvUF_PetMover",
	"ElvUF_PetCastbarMover",
	"PlayerPowerBarMover",
	"ClassBarMover",
	"AdditionalPowerMover",
}

F.Presets.Register({
	key = "healer",
	name = L["Healer"],
	desc = L["Bigger party and raid frames in the middle of the screen, close to your character."],
	base = "gradient",
	preview = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Presets\Healer.tga]],
	previewCoords = PREVIEW_COORDS,
	apply = function()
		local units = E.db.unitframe.units

		units.party.growthDirection = "RIGHT_DOWN"
		units.party.width = 110
		units.party.height = 42
		units.party.horizontalSpacing = 3
		E.db.movers.ElvUF_PartyMover = GROUP_POSITION

		for i = 1, 3 do
			local raid = units["raid" .. i]
			raid.width = 90
			raid.height = 38
			E.db.movers["ElvUF_Raid" .. i .. "Mover"] = GROUP_POSITION
		end

		for _, mover in ipairs(PLAYER_BLOCK) do
			F.Presets.ShiftMover(mover, 0, PLAYER_BLOCK_OFFSET)
		end
	end,
})

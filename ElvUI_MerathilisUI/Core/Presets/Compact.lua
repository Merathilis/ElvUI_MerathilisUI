local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local ipairs = ipairs

-- Cropped to the unit frames and action bars, at the width : height of the preset cards
local PREVIEW_COORDS = { 0.2, 0.8, 0.61, 0.99 }

-- 8 buttons of 28px + 7 gaps of 3px + backdrop spacing and border, the layout's 285 for 32px buttons
local BAR_WIDTH = 253
local LAYOUT_BAR_WIDTH = 285
local FRAME_WIDTH = 170
local OUTER_EDGE_SHIFT = 46

F.Presets.Register({
	key = "compact",
	name = L["Compact"],
	desc = L["Smaller unit frames and action buttons for 1080p and small screens."],
	base = "gradient",
	preview = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Presets\Compact.tga]],
	previewCoords = PREVIEW_COORDS,
	-- The cooldown viewer is as wide as the action bars
	cooldownManagerScale = BAR_WIDTH / LAYOUT_BAR_WIDTH,
	apply = function()
		local units = E.db.unitframe.units

		units.player.width = FRAME_WIDTH
		units.target.width = FRAME_WIDTH
		units.target.castbar.width = FRAME_WIDTH
		units.party.width = 140
		units.party.height = 32

		for i = 1, 3 do
			local raid = units["raid" .. i]
			raid.width = 75
			raid.height = 30
		end

		for _, bar in ipairs({ "bar1", "bar2", "bar3", "bar6" }) do
			E.db.actionbar[bar].buttonSize = 28
			E.db.actionbar[bar].buttonHeight = 23
		end

		-- Bars 2 and 3 sit in the backdrop of bar 1, 3px closer per row with the lower buttons
		E.db.movers.ElvAB_2 = "BOTTOM,UIParent,BOTTOM,0,99"
		E.db.movers.ElvAB_3 = "BOTTOM,UIParent,BOTTOM,0,125"

		-- The bars between the player and target frame keep the width of the action bars
		units.player.power.detachedWidth = BAR_WIDTH
		units.player.classbar.detachedWidth = BAR_WIDTH
		units.player.castbar.width = BAR_WIDTH

		-- Same gap to the power bar as in the layout with the narrower frames
		E.db.movers.ElvUF_PlayerMover = "BOTTOM,UIParent,BOTTOM,-217,296"
		E.db.movers.ElvUF_TargetMover = "BOTTOM,UIParent,BOTTOM,217,296"
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOM,UIParent,BOTTOM,217,277"

		-- Their outer edges moved 46px inwards (348 -> 302), target of target and pet follow,
		-- so they keep their gap to the portraits
		F.Presets.ShiftMover("ElvUF_TargetTargetMover", -OUTER_EDGE_SHIFT, 0)
		F.Presets.ShiftMover("ElvUF_PetMover", OUTER_EDGE_SHIFT, 0)
		F.Presets.ShiftMover("ElvUF_PetCastbarMover", OUTER_EDGE_SHIFT, 0)
	end,
})

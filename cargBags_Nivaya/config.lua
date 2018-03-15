local addon, ns = ...
ns.options = {

	itemSlotSize = 35,
	itemSlotPadding = 6,

	sizes = {
		bags = {
			columnsSmall = 10,
			columnsLarge = 10,
			largeItemCount = 64,	-- Switch to columnsLarge when >= this number of items in your bags
		},
		bank = {
			columnsSmall = 12,
			columnsLarge = 12,
			largeItemCount = 96,	-- Switch to columnsLarge when >= this number of items in the bank
		},
	},


	fonts = {
		-- Font to use for bag captions and other strings
		standard = {
			[[Interface\AddOns\ElvUI\media\fonts\Expressway.ttf]], 	-- Font path
			9, 						-- Font Size
			"OUTLINE",	-- Flags
		},
	
		--Font to use for the dropdown menu
		dropdown = {
			[[Interface\AddOns\ElvUI\media\fonts\Expressway.ttf]], 	-- Font path
			10, 						-- Font Size
			"OUTLINE",	-- Flags
		},
	
		-- Font to use for durability and item level
		itemInfo = {
			[[Interface\AddOns\ElvUI\media\fonts\Expressway.ttf]], 	-- Font path
			10, 						-- Font Size
			"OUTLINE",	-- Flags
		},
	
		-- Font to use for number of items in a stack
		itemCount = {
			[[Interface\AddOns\ElvUI\media\fonts\Expressway.ttf]], 	-- Font path
			11, 						-- Font Size
			"OUTLINE",	-- Flags
		},
	},

	colors = {
		background = {0.05, 0.05, 0.05, 1},	-- r, g, b, opacity
	},
}
local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.modules.args

-- options.databars = {
	-- type = "group",
	-- name = L["DataBars"],
	-- get = function(info) return E.db.mui.databars[ info[#info] ] end,
	-- set = function(info, value) E.db.mui.databars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	-- args = {
		-- header = {
			-- order = 1,
			-- type = "header",
			-- name = F.cOption(L["DataBars"], 'orange'),
		-- },
	-- },
-- }

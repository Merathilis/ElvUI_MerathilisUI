local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Mail = MER:GetModule("MER_Mail")

local options = module.options.modules.args

F.MarkTabAsNew("mail")

options.mail = {
	type = "group",
	name = module:AddCategorieIcon(L["Mail"], "mail"),
	get = function(info)
		return E.db.mui.mail[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.mail[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.NewFeatureText(F.cOption(L["Mail"], "orange")),
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add small extras to the Mail Frame."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
	},
}

options.mail.args.selection = {
	order = 4,
	type = "group",
	inline = true,
	name = L["Selection"],
	disabled = function()
		return not E.db.mui.mail.enable
	end,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Adds checkboxes to the inbox to open or delete multiple mails at once."],
			width = "full",
			get = function()
				return E.db.mui.mail.selection.enable
			end,
			set = function(_, value)
				E.db.mui.mail.selection.enable = value
				Mail:UpdateSelectionCheckboxes()
			end,
		},
	},
}

do
	local selectedKey
	local tempName
	local tempRecipients
	local tempSubject
	local tempBody

	-- AceConfig "input" widgets only commit their text (call this file's set()
	-- functions) on Enter - or, for multiline fields, on the small checkmark
	-- button below the box - never on merely clicking away to another widget.
	-- A separate "Add / Update" button relying solely on those cached locals
	-- silently saved nothing (or a stale/incomplete entry) whenever a field
	-- was typed but never explicitly committed before clicking it. Saving
	-- straight from each field's own set() means the template is already
	-- persisted the moment any field is committed, regardless of whether the
	-- button is ever clicked. showErrors is only true for the explicit button
	-- click, so typing progressively doesn't spam chat with "no name yet".
	local function SaveTemplate(showErrors)
		if not tempName or tempName == "" then
			if showErrors then
				F.Print(L["Please set a template name first."])
			end
			return
		end

		local recipients = Mail.ParseRecipients(tempRecipients or "")
		if #recipients == 0 then
			if showErrors then
				F.Print(L["Please add at least one recipient."])
			end
			return
		end

		E.global.mui.mail.templates[tempName] = {
			recipients = recipients,
			subject = tempSubject or "",
			body = tempBody or "",
		}
		E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
	end

	options.mail.args.templates = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Send Templates"],
		disabled = function()
			return not E.db.mui.mail.enable
		end,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["Save recipient lists to send the same mail to multiple people at once from the mailbox."],
				fontSize = "medium",
			},
			name = {
				order = 2,
				type = "input",
				name = L["Template Name"],
				get = function()
					return tempName or ""
				end,
				set = function(_, value)
					tempName = value
					SaveTemplate(false)
				end,
			},
			recipients = {
				order = 3,
				type = "input",
				multiline = 4,
				width = "full",
				name = L["Recipients (one per line, or comma separated)"],
				get = function()
					return tempRecipients or ""
				end,
				set = function(_, value)
					tempRecipients = value
					SaveTemplate(false)
				end,
			},
			subject = {
				order = 4,
				type = "input",
				width = "full",
				name = L["Subject"],
				get = function()
					return tempSubject or ""
				end,
				set = function(_, value)
					tempSubject = value
					SaveTemplate(false)
				end,
			},
			body = {
				order = 5,
				type = "input",
				multiline = 6,
				width = "full",
				name = L["Body"],
				get = function()
					return tempBody or ""
				end,
				set = function(_, value)
					tempBody = value
					SaveTemplate(false)
				end,
			},
			newButton = {
				order = 6,
				type = "execute",
				name = L["New Template"],
				desc = L["Clear the fields above to create a new template."],
				func = function()
					selectedKey, tempName, tempRecipients, tempSubject, tempBody = nil, nil, nil, nil, nil
					E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
				end,
			},
			addButton = {
				order = 7,
				type = "execute",
				name = L["Add / Update"],
				desc = L["Confirm each field above first (Enter, or the checkmark under multiline boxes) - this button re-saves whatever is currently confirmed."],
				func = function()
					SaveTemplate(true)
				end,
			},
			spacer = {
				order = 8,
				type = "description",
				name = " ",
				width = "full",
			},
			listTable = {
				order = 9,
				type = "select",
				name = L["Saved Templates"],
				desc = L["Pick a saved template to load it into the fields above for editing."],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
					local tpl = E.global.mui.mail.templates[value]
					if tpl then
						tempName = value
						tempRecipients = table.concat(tpl.recipients or {}, "\n")
						tempSubject = tpl.subject or ""
						tempBody = tpl.body or ""
					end
				end,
				values = function()
					local result = {}
					for name in pairs(E.global.mui.mail.templates) do
						result[name] = name
					end
					return result
				end,
			},
			deleteButton = {
				order = 10,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.global.mui.mail.templates[selectedKey] = nil
						selectedKey, tempName, tempRecipients, tempSubject, tempBody = nil, nil, nil, nil, nil
						E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
					end
				end,
			},
		},
	}
end

local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[733] = {
	RELEASE_DATE = "TBD",
	FIXES = {},
	NEW = {
		"Mail: added a Postal-style selection bar to the inbox with numbered checkboxes to open or delete multiple mails at once.",
		"Mail: added send templates (recipients/subject/body) with a quick \"Send Templates\" button on the send-mail frame.",
		"Mail: added a quick-attach bar for trade goods (Cloth, Leather, Herb, ...) on the send-mail frame, with a per-category default recipient.",
		"Bags: added an optional Categorized Bags view (sidebar with default/custom categories, Pinned/Recent items, search) as an alternative to ElvUI's default bag frame. Disabled by default, requires a UI reload after enabling.",
		"Bags: Categorized Bags - added item level and bind-status indicators on slots, each with its own font/size/outline/position options.",
		"Bags: Categorized Bags - added custom icons for user-defined categories (right-click a category and choose Change Icon).",
		"Bags: Categorized Bags - added drag & drop reordering of sidebar categories.",
		"Bags: Categorized Bags - added tracked currencies to the footer, next to gold.",
		"Bags: Categorized Bags - added a Vendor Grays button that sells all grey items at once while at a merchant.",
		"Bags: Categorized Bags - added a Bag view mode that groups items by physical bag instead of category.",
	},
	IMPROVEMENTS = {
		"Options: scrollbars on MerathilisUI's own options pages now use a slimmer, accent-colored thumb instead of ElvUI's general value color.",
		"Bags: Categorized Bags - added ElvUI-style Sort/Stack/Help buttons to the title bar.",
		"Bags: Categorized Bags - added more layout options (item spacing, header height, sidebar row height, spacing between categories).",
		"Bags: Categorized Bags - added an alternating sidebar row background, matching the Armory panel's stat rows.",
		"Bags: Categorized Bags - right-clicking an item while a merchant is open now sells it (including equipment) instead of using/equipping it.",
	},
}

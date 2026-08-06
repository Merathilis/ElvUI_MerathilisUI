local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local format = format
local HasNewMail = HasNewMail
local InCombatLockdown = InCombatLockdown
local PlaySoundFile = PlaySoundFile
local MAIL_LABEL = MAIL_LABEL
local HAVE_MAIL = HAVE_MAIL

local hasMail = false

function module:UPDATE_PENDING_MAIL()
	local db = E.db.mui.notification
	if not db or not db.enable or not db.mail or InCombatLockdown() then
		return
	end

	local newMail = HasNewMail()
	if hasMail == newMail then
		return
	end

	hasMail = newMail
	if not hasMail then
		return
	end

	self:DisplayToast(
		format("|cfff9ba22%s|r", MAIL_LABEL),
		HAVE_MAIL,
		nil,
		"Interface\\Icons\\inv_letter_15",
		0.08,
		0.92,
		0.08,
		0.92
	)

	if not db.noSound then
		PlaySoundFile([[Interface\AddOns\ElvUI_MerathilisUI\Media\Sounds\mail.mp3]])
	end
end

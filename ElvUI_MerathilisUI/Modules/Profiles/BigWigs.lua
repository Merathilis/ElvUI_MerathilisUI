local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:DrvSoUTrquWWZfbxaSoza5IeaRgh4RigNKITdUgdWZswsr3Dc6KIbCHnxsoICrwYDXURKozCveUi16tWf5dqa5hGDUBHQtsHr6dW9fKDjf5bKTyWoZY5nV5nJK1VZQfdcbkegtfyjMMi((miMfv6o07SUxmT7eLT1F9LekpgrQEQ90lhRUN1Od3ThJZOekxS0JTGZiWPJTp5PVWk364rwueOTX8J2tc5aKueXo364VgvgW2Bnqi0vNAN)wlpkhLecNM79S8qT5qqHFoITVDphUcKsCsO43QXPlKeCcKnT)GZ(5lNnD0Gl6MoNMiVc)b44DM2CgJbCFKaCtNJcajoggB36PT)I5XZPju)iongIY1KE6uVafdz)qZUxZ466TcTohqtuvdh)iKmABawWiO1gSU3wtExwWdvTTHC6QzSviEGikDHaW(Ab39t(eKq4Bep3Qcz4yRjicomrz)P47OYgpeVqO)LD6Roi)Fvd7IKGHw9F5F)oZb6)Y)99MZ7msthZNnfUwEvekGUAOLLLnFFOH26tAjIdhFGwjFMX2PJX(8FY2KCxnNqcnHcgABsEjWf6fG2oVPfRUVU2snUjvBqnszLRikB9IZh)MTAqQgmFN6(89tJnqjYU3UelWEeWbXhHJXYpVjV3NQvXjtg86(t3axZ6d4Wi5JZm6wz5Cg1T30BRa61AjEbZ1Xi)UP6CEdoqg9phYQv9jtaHeXLUogyC5sToSGdPoOejvxEJCCLCnbyp(g)57pNdC9SftWIB4frFrWjOzdUH3KlyiFDN9OSIFFuqYJ3w4LxEzDVWsEPRMR6HQg77pTRQJZCmHeTRIHMU(HSh8)KeZy4ZQMrQJ(2SY1ytShXEqvMNVGiXmcg4M94w3b550LArUAyvSb1yJbN87pVo3UEOvDpRmD)F3)gSvlHLEVnFC(hzDjlN179J1l5axDWBvNOo5p)kYxNoBWyehsKSJQQt5uFU6(QAQJq7QEX0JhA6gTwmzjf7dSgbWR6EAZxbZr62O5t6bAbeo()(d"

	-- Profile import
	-- Arg 1: AddOn name, Arg 2: Profile string, Arg 3: Profile name
	BigWigsAPI:ImportProfileString(MER.Title, ProfileString, ProfileName)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

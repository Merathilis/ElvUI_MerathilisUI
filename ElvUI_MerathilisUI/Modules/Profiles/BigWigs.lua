local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:DrvZUTTrqyWYKdfUarwbW5qlq8LuGCOb6NANaFXO0q2sQw2cYuna5GdxsoICrxYDXURKSk8jHCON1JGp0habKxaEZ3wOZT9qqVxa)e0DjfPb6EyWoZY5B(MVzKS(dwTeqiqrWqQalX0uX3NbjS4s3((N05c3oJu2w)1xsP8eeP6PwUxou9uRZ3zZwmoHsOCXmF2uoJahn0UXBERvU1XNmTiqlJ5hThfXbiTiIDU1jybQmGT)cGqOZpYo)TM(uokncok37G8qT4qyHFoITEylhUcKsCAK43RXPtLeCkK52T3j)8LJDpV3fDwoHMkVc)BWR3yAZXmgWdqcWB5euiiXjWq7MVP1xmpoGMsdI50eioxtovN6fOei7h2VZnmUUEZrlYb0evTNtqmsgVoelye0cdwpDTjVll4HQ26ioD(y2CepueVCQaWbAb37UacsicmINxvHmCS5iebhLQSVl5rQSYhXle6FzJ(Qdk4x1WonnSVv3J)7RnhO7X)7hnNRnstBZN5c3iVkgfsN33YYYMVnuFB9zzjI9h(eTsEGX2UTXE47Snj3rZjKqtOW(2MKNbCHEbOLZ7BYQhORTuJBA1g0ElzLRikB9IZN(M1AqQgmFN6z8TtJvqjYEpmdlW(eWbXphNGL3VkV3D1Q4Or9oRR7k4gwxahflFvMr3klNZ5Do19HkGotlXtzEog53BPoN3JdLX)ZoSAvFYiqirCPNJbgpUuRdt5WshuQKQlVroUsUGaSxDBWKTNbaxpBXeS4wEr03g2anU3T895cgkq3zVmR43hfK81Rl8YlVSUFujV0vZt9c1EB7pTRQTZemHeVPIHMU(fSN))KeZy4E1(XQD)2SY1ytSxYEEvMdMsKygbdCZECZhHCaDMwKRgwfBq7TYGt(9dRZTRhzv33kt3)p(VbR1syP3hYhNFoRdz24t)4q9soWvp5dQgQg)5xr(6LJ7neXHujB3Q6uo1NOEMQMAx0MQxm94oMUrRfJMrXbqwN0iTahF0()uYI)7p"

	-- Profile import
	-- Arg 1: AddOn name, Arg 2: Profile string, Arg 3: Profile name
	BigWigsAPI:ImportProfileString(MER.Title, ProfileString, ProfileName)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

function module:ApplyBigWigsProfile()
	module:Wrap("Applying BigWigs Profile ...", function()
		-- Apply Fonts
		self:LoadBigWigsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "BigWigs")
end

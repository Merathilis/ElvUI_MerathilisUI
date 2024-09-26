local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:LvvZUTXnqySyJbAGtqLSRDsqdqCttksoydl5gBeFPiRT8F16hiTUjXOaDPwrTlrO2LLKRTvGrlGo1Z6rWpc6qFa0TEBHo0ha)iy0hGYH7psoEpqjoC4WV57B4qJ)MvOhwiqE4gHcIKegi(HX4Em)SPhv2UEJytJlF41bH8EiA(cT3Psn7knJN74LEWdMKgLDcPHCXzTzrCgfVDdZ1xBld9OvBAuIHYWWpA20JJXbjwm1JwU9rzgmB3htPHNVTPETsTd5Oap826zVrBQmh3jzUoILVjfdTWsjjWt8xf4HrskjaZRFI9XhwRYGUHbYwKpJF9eihpHXWCxKa7pOlQdws6HBywATYxdlwnmi01Nh2d7RjK9uBTgQhM9nRUY(HsFuVAiop88vTOi3pPJmS84vxPYfmUcjNJ6B56JK(J6qemkQpe)5gbXQEcSgBFWH78ZPyBKNkyNWohX7iCgejWexLy4CLlfjeUaT6KJdifk1erjEbnBE4(hyFvVPOLvmaGjfjNYeRnrIVqcBvlqhzQ(ylbNW(koUbp0TLeXLVlG0ZHTS2Ucn7s4yxqR1lADCL9ShbXPE3UcS8dg3ao(obt5utKYph2IGLDcdPDcppOwuV2yUqfqyt3nGXMJa3tI2hn0tAXqUkep31WefrQ2aGqhwXzJCRZjmSJ(4Tc5DW8KSYWWW8kW4byINV8jAhGKoLVJlmd8)48xdtMvMZ4iqhJxwdHDXcKmIR4YPldS)l1eAEbKZenvejdB5IO4u4ciFpo(3JWbU9p4N(3UWNsFUdDe)k2c3oHT7ZWnzKlW0RNMLWbBM4Pw2GLpwLxIhE1uNCypEwDfK0DHeqDmP7fYHQZwVCh9wHNfV9PGd8K(3NvywvOshV0e)2fwJZmb4T4KSaL4qJ7T(AV9nth3OSj7jzUae4oiHSHQ6G4sXIIPfJz4W2N4(jvclmtuYBPRP1ogdHT8EshP)3na(7PHH9mYbLwCF8mvEFyPHjzv(fJBvfFyWzQIyfnT0xIsTuBoSnkP8t8ltu)1s1mqDtokOZr5DQMoSb4InGvFKk46kwEQj9zpilAAIA9sW4MBOPRnmHnxr1cajueBNeQClTFVfgFZMMCaRkbSS17lXwWvbdjKd592xEalR9D8CXZz8RgJuXmVnXtJ)64cdXzhHZnNreK2uSfIFmPhrwCOUNJTQrw8RgIVGLCrBvn5MDiXp)M8iavvrmhlO1NZa1g0YY)vGvi3LMyb0mWXcIHdheYioEuf6zNC4k1up5uc4KwY(um7Lx62n9Rkwvt7tOeXL8eRB1zD0jhEjFfUiPq4zJtEXkbKVCuYmncEXYT9YGM6aDIFu8JtZn104NB1LqPotYbjKXlXw8lOdqlUF837hx8BhN9Ycy7zSfZ3z1iQKWOemhEAP00qwn8mfbNlrjLqlpSB2vPnxGBUGNXcT11nJvCW0xOhPyYSzNELvDB76vHUZC1B1WVgV4Rgde4E)MnI7HLX3704)i(pn2DEwXDXseHkSuDT2JRUluIvmhezfcDv1bpnU4)mjFfGaMhs1hfVCZZcjUQ3bXbN0A7v2f3fPYXvEvv1THx))"

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

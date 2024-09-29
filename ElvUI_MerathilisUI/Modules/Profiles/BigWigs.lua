local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:LvvZUTXnq4UyJbAG7pw21ooObiofjnnhSJLCSnIVuK1s2wUw2csRAs8LUuRO0seQDzjPKSkmql0L2d9KqFc8JGo0haDR3wOd9up5hb)euoC)rYX7bkrYHZ8nFFdhA83SfAJfculC5abrsc8fF7yCBMxY0JRVFHtTluj004V(IR9d4Tr009YzFw5W5m(V5Me7K9dObCr36SoCgfVxzZn3yxd9OvDANOfYbdVYSslog7hTIPE0YTpkzbZ69XuAqV9m17LTEah53cVNE226LYXXnIMR9yUBIXqvSus8Bj(Jf4bDKuIpMFwn7tkEAHbnd8Lvj)c(ftGuSgJH5Uib2BqtudSK0gx2m7g5Ug2SuGFGRhpOn2tZhhOo6PO2y2xT(Ahgi9qTpfX5b9w3IIC)G2ZW2JxFTcxW4kK0d13Y1dj9g1GiyuuFW)Znc81zrWAS9rf3)hIX2OwkNvJ1dXBi8g0rGjUkTW5kxksiCbA1jfhqkKTcIsA5hAEv7PiLLXhGifjNYcVCIeFHeoMwCo2u9Xwg8(Hk(TmpWTQeXLVXN02HTIEDfsYt4yxqJ1BADsHdShb(5SMnfy57mUbm8ncMYOkiLDoSfsCPTkppb3uAWwcwA)GaAJGE(N2PDDmxOIb4N7gJW5gbMhfG3BONuLHCvjXCxdtu8Q6aqeCyzM1Zv7ryyhnISc4nW8Oe1WWW8kyXJWKwEYhQna4Hy6pCHzYO3p)1WKzv9eAdK1Wv0qipwGKD4k6D62Gy8mnhNwp5mrZoDKbvDruCmCbKFah)ZDW(U9p67)3MWNsYUdDe(C2I3oHT7ZWvyKlW0RNMLqGnJSuRKW2NOYlXNF1uJCyRoRudQCEibuHj(SqouA2sO7ucOWZs3oky)wsV7hj5jQqHgTIt8BxRnozjaVzMK4OidkFVn341BpDCRCMShMycqG7JeYYQQdIlflYexFMGdBpI7hujSWmsjVLUgx7ymeoYBjnKEpza83ZdcABKckT4U6mvEVB5Hrzv6DLBvfx0VRQiwrtl)XOul1MdRJIk)e)4e1FTu9guxS743440gxth2cmXgWQhs5CDflpEjDShK4nnrTzwyCNT001wMWHlO6iGekITrevUR2UxdJBVJjhWQsaZz92SSfDvWqc5qAN(vgWs6KhAgA(NFYVps5Z0ohpk8ldxyiojeo30Lii1Pyle)esBImZqDli4(E4ZhIVGfDr7LAYnjivQu8WJSVj1lqLvhMJf0n0zG6qAP5vFgBHutQGfqdbhlWpoCqm7WXJkq7wR4ANQEbklWlvL9Py2ZU0Tz8xjSQU2JqjIl5rRUBJnr1kEjFnUiQy4XJJEalcOpzu0mncE6I1BLanvaDcFq4QX5NAAi2QjHsDMKcsiRxMT0hrjGEC)WVXlmZxpo5XgyThZwk9KL6qLegLG5WRnzN6YsbDvKCQmfvgTYWMjxN2zrU5ITmwSUU2zSIdM(M9iftMm78RSoZ2(SsqtBU6fA435F6NogiWd(jBeVfwgEVZd)1WFZi)8Sm5XseHkSuDUoGRUpKLLjfejfdnv1cpkmZ)mjDhGaMhs1heUsLUbex1tJy)Av3BT84MivoU23vsDJ4f))d"

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

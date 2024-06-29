local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

function MER:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	-- Profile Name
	local ProfileName = MER.Title

	-- Profile String
	local main =
		"BW1:DrvSoUTrq0qq7QlawNmGCrcGvJdYvedlDX2bxJb4zEws50jbjQyaxyZLKJixKLCxS7kPtbxLqksT(eCr(aeq(byN7wO6KuyK(aCFbzxsrEazlgSZSCEZBEZiz97SgPGqGIHXubwIPzIVjhszjvUdco39kp3jkBR)6ZzuEkIu)uxVrJv336YJ2FaJZPekxSmGTGZiWzJTF2tFPvH1jGSOmqxJ57TNeZbiRmIDH1jCnQkGDWAGqORoZU4TobuoklgoRW75fH6YHOs)ce7E7bomfKsCwS43AWPlKeCgK71R)5)4OzEx2)k3nZPzYP4FbozVPnNXyapeja)nZrrGeNcJT780UF284qAgnmHttHKcn5cDQxHsH8VRT71mUUERqRla0ev1Yjmbjt2fHfmcATbR7VZK3OsEOASlMtxnJTcXJejBwiaCOwW9)yibjeHgXZVUqgo2zcIGJZu2Fm9oQSnaXlf6FAV(Qdk8N1WUilAGvVx93V3CGEV6F)G58EJ0CQ5Z8GRLttqr0vdSSSS5hcnWwF2uH4GX3tRKp3yp9uJ9f)GTjzxnNqcnHIgyBsEjWf6fGUoVTdRzOU2snUz1BqT2WQwru26fNF9l3PbPEW81QhWpmn2cvi7F7sSahqahe)sCkw(PTf9UNwfNmP)B65TfUM1dWXjYNKB0TQY5CP7fE3wd0B0s8cMVJr(93OZ5T4izY)CeRr9Nmbesex67yGXNl16WcoSXbLjP6YBKJPY1eG9KBcNF4me46zlMGf3WlJ(YONHM1)gEBUGHc1D2JZl)9rjjpzxPxr5LndIR4LUA(QhPADO)0UQtDMJjKK91m001pI9W)NKygdFs1orD8xLxTgBI9y2dRZC4cIeZiyGB2J7ChKdPl1IC9WQCdQ1wdof3FrtUDZyRMbw56()U)nyNwcR8ExX48pYDjlNDXhgRxYbU6EVBNZipVrdlMsQR(ZVq2yZS(JrCitYoUUIvZ)5QhOAOogTV(ft3EKPV0QYKLuCiWAfbV29S2VgMJ0nu7V9cqlLWj)h"

	-- Profile import
	-- Arg 1: AddOn name, Arg 2: Profile string, Arg 3: Profile name
	BigWigsAPI:ImportProfileString(MER.Title, main, MER.Title)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

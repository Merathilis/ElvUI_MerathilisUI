local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

local _G = _G

function module:LoadPermoksAccountManager()
	local PAMAPI = _G.PAMAPI

	local Profile = E.Forever
			and [[Tv1ZVnXruyqPrH4iejKeOqf)OUusTLALWrL2kvGeBcjHMsmobhA7H1ZU7B3DWR3z6mZ6G5OpuH6XCOs0tuFOh6HEWsCVk3QehEI7CHBvQN4VG(M12yKkx2DM3mZBEVVVV3Bo6PucPHls0p(9RjmrG6wQuPpZa(Z0pqXAb7yumdR8gBU(g9JzUq82bbAWSOC2SzveXPTs2J7BIEVCDdejMD4pcoTCXFmf0MkIwYyW6FYn8KWUdnaVWlvPGeVoB6r3D0ls1WoEcfqUtOA46ku(G6Qk3Wmd3EJB8NN)8x8ih5iVRb)ZtEYtPbDb)qWE5ZuZB4H(JZE2vY2Y)FW)(8N)x0a5SCd0YgevfAUnqRP4HrM(6iX(BNSwIbur9OOB7utmpbAiN3UsLSO3SJe8SNnsox2(hGKLtngYMYn7VUooru)9TauvqTAS5sh71dwzx4HMmG7LDFqQ2Wd6SHBL1UZURvR)GnKT4LowpViMI5rrIU(HAHYuUZwGwdQgDBXt2cAdXpt5jA5sXxK7GnuldaLZn(O0LxLfcNtoNpeWsJnvisouO4G(3vPjXcVM66usXCJb)OYje1RU3aZy(x66fXJ9156L9FBRZZ1te77SpanJ7uhVCeUuVTJ9V4EzgW8pdluu5YdD85HYzTWJthrQYPfymXaw8Y4NgIFg)aRt8z8r(4aRpUPDoM)VXc5WI56PazQHzX2aAkDp1EJbm)e4LB0lI7d7kcdJHi6mdfxMrXwX6e)WITQBES2rl4kaM4aMBAIplXdMuEsTrOAXuKhDyATfEM(WyH24edHqIVEQ(dCMn8zxGcHpPmVWOuTGnYlCD8ZXRIFj(fxa)kx66f7NKLsf(1(SwSeUdvb4cVMIchnvkKgtxNPJRLGmCcH4XTbvlbfbEeoz6PbPDjH6kV(rPXpGPumTtGq5rfpmPHXtCmIMnzVYhOtQDgM0hkvqNrtW8ZGlHLWI)cE9PWVEc8AtI3CE8gtJLpbwzoCLzWvpEFPseqckEMy1cW9Ro2cM)UzzrofbeGIfhGl3axsT(Gzy(Jseaw4Pl8I3O1UdPD62e6qGAciN1J6FettCSBie091uI10XN68OLZLaUPXIuTtBb332cOhrtchpf1(OxRoMObdLZB)sl7tWtqaOCOlqEMXJD0K39Dg1xPlPChOqw5vVjWYQvkhssUXOBj5csfN4(ooJXbNR8oTwA8Xw(GaUIYjg3NQ9enjgvfW1r0FS4JxaV9K49ohU5ey9lG35443mfwDoC7tG)qbCNZG3)JWVFj87(yC3pax504wtJ1weV784EFi(TZC4qY7TQkQnSIyXbveLKTLet9t9O)dRaxTwKirOMmZugaRVXbu)ZAeiKeoZRy2s7btwU9Yt3L6AL1HEc8(x7TxSu7stHlvQA9Qy(FlJ4)z0hBGa6HU49rg6ipJTAE9uQrWQgtAc0Ic2Hn9ouZAdJAL2GYeIZATL9Hc9TkBB1MR7igkN7GvZvllqYv2(4rV1EiPF169zDKNBiouze9DllIpY5rhAl6h2eRtKCH3(fLrBcpjj)YULXD7ofUEqMKTiUPlp2kjSIyROg3W2xIinZK9TEFpMYLL434GrpsOJ(Vp]]
		or [[fwvVUTXrqyBWiqikyyj7i7yhyGawyfsGKczz5eJ44yklzzzfl6tYuf5NJ7D3C3Tr7D7MD3JY0LSiiiL6niSmLeWVaQiaPBG6DrsrksPEcYShjTeqks1D7SZoZSFZ38Tx8AAPYYL5MF(d8K2uqVHUqfXSq0CJI1SmyxRMzzT28PpzZrcwai2jo2a2fvZxUAnPOilFFEKn99QniwMB3L)A46Qf)XcWyxtMPeGl(uy45jdMyaojSqRH8W(pnKYD3tkmWUHsnqHtQ7gei1rGEvDqsPHT28H)2nV5xDHlCH)7pvgarjGlPZ5f()6SAEUfYCjTT0WDfMNMNKAhzsLhUt(65wqNoKQMDkScEo0vDv3oRvwT2DvqO7SPQfk9FmY1QWAjB6GYVMoyL0rh6aK2G(rc7FE64n2dELTeNE7GFOWy5X93myT1F(ER7nASdJ3CyyktZcP6W05yJuBB1FBWyaD3bz88THEG4n6qzwavDPbJDWReUulC2rPu3MLa3sTqeeZke21OwAIuZbZVRlYfYWdmDORelqarPTYPgT(LJnJ1FBqykxezQnS87oUGxBOue5Fiahi63bVDkU0WDerF0(LgW6VbB0uhWt8J4jQ5DGJFFzH2pdSwbGnVn(jj4NYpYfKigFAmoYfJh7wJ1)dSrnSzTGX5iEykpc2tMKiaYXGPjQkE7UyJxtnaMWrx5cJVrY1aCelOipILhchlKgRVasG8iJ6kgRuNX0uRYNzmoWGAQuNKZeod8K8mQ3AovPH(g)ChDGChgEOutvBG0yWM9WvQGF(LW7nlE3zWpBoC1Q49VSxpx06GnxvnFIgyw)sd(AgpAMtpVfvpvv1cN3cnhuyQGnUp(L4xGpaRpJ7MTKxh3UtgpStX7MB4YpLzkTujS0WpUfVXuiPHdkBSfUcExCv8Eb0bLhM7ouGJpy5vhXYy5CFAemaQCkbB(gAySqqGIT)mu)Il6b6mjHqHuxZ6YGhOkSmhbhR3FsgEmUoUgUHMawqZeX4YufRFY4vy9lw2B(NtEhn85eTkGlCC2wjuRFWbectmDyObuUstQxwnFiPVii7(UZLaMrgAVd8JiLjJAHCiOqilm(9K8iNeXzN9odjcG0putkndZ6BtN877Cyf1vDgOdfrxS4yq7tvG6gN9VVHYjT5e1iS5FJF9SyNpe3764ZNd9UkU7Iy7lJ7Fl8L3a3UkUvf8zZG7Cj8flmsPLX0OjVCOVznCPrTpZcw)fLOwTwo2GRBCKrrvsmtiM9expWDHmkI6ot5YiICKP5X2kQRq8VWuFQDqQOcItZmvD4)3HFl(943G1RuYvA5rr(4juLZnv5nzIAXXtultKpk))0q67Kj4h5LkZL6zknvc3MhEeP26rn88K5(lMtAy8I707oZoG08k1ZRGEp48BUCVLRIlTC7oTX6)A519xWumc5ycgJEiGHQB4udEsbjK8iRTihCdBtKmp2W6btfI7s3eQxLTT7zfZgTCc11gmTZuly8U18klKATCp1mC9xrdTgZHS(QBnbhwBk5BdU2yNg80JDYjteb7NQE)Z)(ZuNWRmY51(mDalpQlXmlt5zsNxd3mUKJFFCl8zUH2lwocGpLKaCuJhuLyhhn9jgt3)9p]]
	if PAMAPI and PAMAPI.Import then
		PAMAPI.Import(Profile)
		return
	end

	-- PAM excludes its api.lua on Forever/Classic, so mirror PAMAPI.Import on the addon object
	local PAM = E.Libs.AceAddon:GetAddon("PermoksAccountManager", true)
	if not PAM or not PAM.ParseImportString or not PAM.db then
		F.Developer.LogWarning("PermoksAccountManager import API not found. Will not apply profile.")
		return
	end

	local data = PAM:ParseImportString(Profile)
	if not data then
		F.Developer.LogWarning("PermoksAccountManager profile string could not be parsed.")
		return
	end

	PAM.db.global.custom = data.custom
	PAM.db.global.options = data.options
	PAM.db.global.internalVersion = data.internalVersion
	PAM:OnLogin()
end

function module:ApplyPermoksAccountManagerProfile()
	if not E:IsAddOnEnabled("PermoksAccountManager") then
		F.Developer.LogWarning("PermoksAccountManager is not enabled. Will not apply profile.")
		return
	end

	Splash:Wrap("Applying PermoksAccountManager Profile ...", function()
		self:LoadPermoksAccountManager()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "PermoksAccountManager")
end

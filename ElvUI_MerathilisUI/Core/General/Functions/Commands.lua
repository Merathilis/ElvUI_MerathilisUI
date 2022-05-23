local MER, F, E, L, V, P, G = unpack(select(2, ...))

function MER.PrintDebugEnviromentTip()
	F.PrintGradientLine()
	F.Print(L["Debug Enviroment"])
	print(L["You can use |cff00ff00/wtdebug off|r command to exit debug mode."])
	print(format(L["After you stop debuging, %s will reenable the addons automatically."], W.Title))
	F.PrintGradientLine()
end
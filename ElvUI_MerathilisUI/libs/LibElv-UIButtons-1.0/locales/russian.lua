--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")

if not L then return; end

--UI buttons--
L["LibUIButtons_DESC"] = "Добавляет небольшую полосу с кнопками, дающими доступ к набору полезных функций.\nЭти опции выводятся библиотекой LibElv-UIButtons. Если вы их видите, то один из Ваших аддонов ее использует."
L["UI Buttons"] = "Меню интерфейса"
L["Show/Hide UI buttons."] = "Показать/скрыть меню"
L["Mouse Over"] = "При наведении"
L["Show on mouse over."] = "Отображать при наведении мыши."
L["Dropdown Backdrop"] = "Фон выпадающего списка"
L["Buttons position"] = "Положение кнопок"
L["Layout for UI buttons."] = "Режим положения кнопок"
L["UI Buttons Style"] = "Стиль меню"
L["Dropdown"] = "Выпадающий список"
L["Sets size of buttons"] = "Устанавливает размер кнопок"
L["What point of dropdown will be attached to the toggle button."] = "Какая точка выпадающего списка будет крепиться к кнопке его открытия."
L["What point to anchor dropdown on the toggle button."] = "К какой точке кнопки будет крепиться ее выпадающий список."
L["Horizontal offset of dropdown from the toggle button."] = "Отступ выпадающего списка от кнопки его открытия по горизонтали."
L["Vertical offset of dropdown from the toggle button."] = "Отступ выпадающего списка от кнопки его открытия по вертикали."
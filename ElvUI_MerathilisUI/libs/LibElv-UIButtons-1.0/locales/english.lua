--Russian localization
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "enUS")

if not L then return; end

--UI buttons--
L["UI Buttons"] = true
L["Show/Hide UI buttons."] = true
L["Mouse Over"] = true
L["Show on mouse over."] = true
L["Dropdown Backdrop"] = true
L["Buttons position"] = true
L["Layout for UI buttons."] = true
L["UI Buttons Style"] = true
L["Dropdown"] = true
L["Sets size of buttons"] = true
L["What point of dropdown will be attached to the toggle button."] = true
L["What point to anchor dropdown on the toggle button."] = true
L["Horizontal offset of dropdown from the toggle button."] = true
L["Vertical offset of dropdown from the toggle button."] = true
L["LibUIButtons_DESC"] = "This adds a small bar with some useful buttons which acts as a small menu for common things.\nThe options below are provided by LibElv-UIButtons. If you see them that means one of your addons is using this library."

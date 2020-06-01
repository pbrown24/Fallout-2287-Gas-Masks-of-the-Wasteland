ScriptName Metro:Dogtooth extends Metro:Core:Required
import Metro:Context


; Events
;---------------------------------------------

Event OnEnable()
	Player.AddItem(Metro_Dogtooth_Gasmask, 1)
	Player.AddItem(Filter, 5)
EndEvent

Event OnDisable()
	Player.RemoveItem(Metro_Dogtooth_Gasmask, 1)
	Player.RemoveItem(Filter, 5)
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Armor Property Metro_Dogtooth_Gasmask Auto Const Mandatory
	Potion Property Filter Auto Const Mandatory
EndGroup

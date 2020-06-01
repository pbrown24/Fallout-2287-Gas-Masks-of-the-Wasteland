ScriptName Metro:Terminals:GearMaskHUDOpacityOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnOpacityChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		GearWidget.OpacityVal = 0.2
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 2)
		GearWidget.OpacityVal = 0.3
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 3)
		GearWidget.OpacityVal = 0.4
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 4)
		GearWidget.OpacityVal = 0.5
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 5)
		GearWidget.OpacityVal = 0.6
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 6)
		GearWidget.OpacityVal = 0.7
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 7)
		GearWidget.OpacityVal = 0.8
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 8)
		GearWidget.OpacityVal = 0.9
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 9)
		GearWidget.OpacityVal = 1.0
		SendCustomEvent("OnOpacityChanged")
    EndIf
	Debug.Notification("Gear Widget | Opacity: " + GearWidget.OpacityVal)
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:GearWidget Property GearWidget Auto Const Mandatory
EndGroup

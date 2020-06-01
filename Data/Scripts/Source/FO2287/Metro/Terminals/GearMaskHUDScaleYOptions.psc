ScriptName Metro:Terminals:GearMaskHUDScaleYOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnScaleYChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		GearWidget.ScaleY = 0.2
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 2)
		GearWidget.ScaleY = 0.3
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 3)
		GearWidget.ScaleY = 0.4
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 4)
		GearWidget.ScaleY = 0.5
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 5)
		GearWidget.ScaleY = 0.6
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 6)
		GearWidget.ScaleY = 0.7
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 7)
		GearWidget.ScaleY = 0.8
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 8)
		GearWidget.ScaleY = 0.9
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 9)
		GearWidget.ScaleY = 1.0
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 10)
		GearWidget.ScaleY = 1.1
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 11)
		GearWidget.ScaleY = 1.2
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 14)
		GearWidget.ScaleY = 1.3
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 15)
		GearWidget.ScaleY = 1.4
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 16)
		GearWidget.ScaleY = 1.5
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 17)
		GearWidget.ScaleY = 1.6
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 18)
		GearWidget.ScaleY = 1.7
		SendCustomEvent("OnScaleYChanged")	
	ElseIf (auiMenuItemID == 19)
		GearWidget.ScaleY = 1.8
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 20)
		GearWidget.ScaleY = 1.9
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 21)
		GearWidget.ScaleY = 2.0
		SendCustomEvent("OnScaleYChanged")
    EndIf
	Debug.Notification("Gear Widget | ScaleX: " + GearWidget.ScaleX + " | ScaleY: " + GearWidget.ScaleY)
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:GearWidget Property GearWidget Auto Const Mandatory
EndGroup

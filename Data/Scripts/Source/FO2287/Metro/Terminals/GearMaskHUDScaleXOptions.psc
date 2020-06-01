ScriptName Metro:Terminals:GearMaskHUDScaleXOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnScaleXChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		GearWidget.ScaleX = 0.2
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 2)
		GearWidget.ScaleX = 0.3
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 3)
		GearWidget.ScaleX = 0.4
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 4)
		GearWidget.ScaleX = 0.5
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 5)
		GearWidget.ScaleX = 0.6
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 6)
		GearWidget.ScaleX = 0.7
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 7)
		GearWidget.ScaleX = 0.8
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 8)
		GearWidget.ScaleX = 0.9
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 9)
		GearWidget.ScaleX = 1.0
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 10)
		GearWidget.ScaleX = 1.1
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 11)
		GearWidget.ScaleX = 1.2
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 14)
		GearWidget.ScaleX = 1.3
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 15)
		GearWidget.ScaleX = 1.4
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 16)
		GearWidget.ScaleX = 1.5
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 17)
		GearWidget.ScaleX = 1.6
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 18)
		GearWidget.ScaleX = 1.7
		SendCustomEvent("OnScaleXChanged")	
	ElseIf (auiMenuItemID == 19)
		GearWidget.ScaleX = 1.8
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 20)
		GearWidget.ScaleX = 1.9
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 21)
		GearWidget.ScaleX = 2.0
		SendCustomEvent("OnScaleXChanged")
    EndIf
	Debug.Notification("Gear Widget | ScaleX: " + GearWidget.ScaleX + " | ScaleY: " + GearWidget.ScaleY)
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:GearWidget Property GearWidget Auto Const Mandatory
EndGroup

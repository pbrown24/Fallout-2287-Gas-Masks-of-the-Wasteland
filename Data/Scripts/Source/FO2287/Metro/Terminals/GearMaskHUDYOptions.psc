ScriptName Metro:Terminals:GearMaskHUDYOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnYChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		GearWidget.Y = 10
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 2)
		GearWidget.Y = 72
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 3)
		GearWidget.Y = 144
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 4)
		GearWidget.Y = 216
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 5)
		GearWidget.Y = 288
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 6)
		GearWidget.Y = 360
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 7)
		GearWidget.Y = 432
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 8)
		GearWidget.Y = 504
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 9)
		GearWidget.Y = 576
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 10)
		GearWidget.Y = 648
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 11)
		GearWidget.Y = 710
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 14)
		GearWidget.Y = GearWidget.Y + 10
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 15)
		GearWidget.Y = GearWidget.Y - 10
		SendCustomEvent("OnYChanged")
    EndIf
	GasMask_HUDXY.show(GearWidget.X, GearWidget.Y)
	Debug.Notification("Gear Widget | X: " + GearWidget.X + " | Y: " + GearWidget.Y)
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:GearWidget Property GearWidget Auto Const Mandatory
	Message Property GasMask_HUDXY Auto
EndGroup

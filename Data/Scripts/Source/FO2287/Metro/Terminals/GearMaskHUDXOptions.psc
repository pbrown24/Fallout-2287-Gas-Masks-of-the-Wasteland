ScriptName Metro:Terminals:GearMaskHUDXOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnXChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		GearWidget.X = 10
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 2)
		GearWidget.X = 128
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 3)
		GearWidget.X = 256
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 4)
		GearWidget.X = 384	
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 5)
		GearWidget.X = 512
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 6)
		GearWidget.X = 640
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 7)
		GearWidget.X = 768
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 8)
		GearWidget.X = 896
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 9)
		GearWidget.X = 1024
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 10)
		GearWidget.X = 1115
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 11)
		GearWidget.X = 1270
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 14)
		GearWidget.X = GearWidget.X + 10
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 15)
		GearWidget.X = GearWidget.X - 10
		SendCustomEvent("OnXChanged")
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

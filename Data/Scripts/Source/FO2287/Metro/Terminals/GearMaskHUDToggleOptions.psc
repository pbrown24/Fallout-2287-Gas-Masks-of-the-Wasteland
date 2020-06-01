ScriptName Metro:Terminals:GearMaskHUDToggleOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnToggleChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 4)
		SendCustomEvent("OnToggleChanged")
    EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:GearWidget Property GearWidget Auto Const Mandatory
EndGroup

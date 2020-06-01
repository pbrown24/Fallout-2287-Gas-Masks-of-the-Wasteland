ScriptName Metro:Terminals:ContextActivation extends Terminal
import Shared:Log
import Metro

UserLog Log

int ReturnID = 2 const
int OptionStartup = 1 const
int OptionShutdown = 3 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == ReturnID)
		return

    ElseIf (auiMenuItemID == OptionStartup)
		WriteLine(Log, "Attempting to start the '"+Context.Title+"' context.")
		Context.IsActivated = true

	ElseIf(auiMenuItemID == OptionShutdown)
		WriteLine(Log, "Attempting to shutdown the '"+Context.Title+"' context.")
		Context.IsActivated = false
	Else
		WriteLine(Log, "Unhandled menu item with '"+auiMenuItemID+"' ID.")
    EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
EndGroup

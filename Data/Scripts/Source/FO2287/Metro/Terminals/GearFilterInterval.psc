ScriptName Metro:Terminals:GearFilterInterval extends Terminal
import Metro
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	ElseIf(auiMenuItemID == 2)
		Filter.Interval = 5
	ElseIf(auiMenuItemID == 3)
		Filter.Interval = 10
	ElseIf(auiMenuItemID == 4)
		Filter.Interval = 15
	ElseIf(auiMenuItemID == 5)
		Filter.Interval = 20
	ElseIf(auiMenuItemID == 6)
		Filter.Interval = 25
	ElseIf(auiMenuItemID == 7)
		Filter.Interval = 30
	ElseIf(auiMenuItemID == 8)
		Filter.Interval = 35
	ElseIf(auiMenuItemID == 9)
		Filter.Interval = 60
	ElseIf(auiMenuItemID == 10)
		Filter.Interval = Filter.Interval + 15
	ElseIf(auiMenuItemID == 11)
		Filter.Interval = Filter.Interval + 3
	ElseIf(auiMenuItemID == 12)
		Filter.Interval = Filter.Interval - 3
	ElseIf(auiMenuItemID == 13)
		Filter.Interval = Filter.Interval - 15
	EndIf
	GasMask_FilterDuration_MSG.show(((Filter.Interval * 20) / 60) as float)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Message Property GasMask_FilterDuration_MSG Auto
	Metro:Context Property Context Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
EndGroup

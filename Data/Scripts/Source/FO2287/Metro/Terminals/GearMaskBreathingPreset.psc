ScriptName Metro:Terminals:GearMaskBreathingPreset extends Terminal
import Metro
import Shared:Log
import Metro:Context

UserLog Log
CustomEvent OnChanged

int ReturnID = 1 const

; Events
;---------------------------------------------

Event OnInit()
	Log = GetLog(self)
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	Var[] kargs = new Var[1]
	If (auiMenuItemID == ReturnID)
		return
    ElseIf (auiMenuItemID == MaskBreathing.SoundPresetA)
		WriteLine(Log, "Set breathing sound to preset A")
		kargs[0] = 2
		SendCustomEvent("OnChanged", kargs)

	ElseIf(auiMenuItemID == MaskBreathing.SoundPresetB)
		WriteLine(Log, "Set breathing sound to preset B")
		kargs[0] = 3
		SendCustomEvent("OnChanged", kargs)

	ElseIf(auiMenuItemID == MaskBreathing.SoundPresetC)
		WriteLine(Log, "Set breathing sound to preset C")
		kargs[0] = 4
		SendCustomEvent("OnChanged", kargs)
	ElseIf(auiMenuItemID == MaskBreathing.SoundPresetD)
		WriteLine(Log, "Set breathing sound to preset D (female only)")
		kargs[0] = 5
		SendCustomEvent("OnChanged", kargs)
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
EndGroup

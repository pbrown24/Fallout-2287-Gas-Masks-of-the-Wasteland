ScriptName Metro:Terminals:WorldRadiationB extends Terminal
import Shared:Log

UserLog Log

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Radiation"
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		return
	ElseIf (auiMenuItemID == 2) ; Default
		Radiation.InMultiplierB = 17
	ElseIf (auiMenuItemID == 3)
		Radiation.InMultiplierB = Radiation.InMultiplierB + 1
	ElseIf (auiMenuItemID == 4)
		If Radiation.InMultiplierB > 0
			Radiation.InMultiplierB = Radiation.InMultiplierB - 1
		EndIf
	ElseIf (auiMenuItemID == 5)
			Radiation.InMultiplierB = Radiation.InMultiplierB + 5
	ElseIf (auiMenuItemID == 6)
		If Radiation.InMultiplierB > 0
			Radiation.InMultiplierB = Radiation.InMultiplierB - 5
		EndIf
	ElseIf (auiMenuItemID == 7)
			Radiation.InMultiplierB = Radiation.InMultiplierB + 10
	ElseIf (auiMenuItemID == 8)
		If Radiation.InMultiplierB > 0
			Radiation.InMultiplierB = Radiation.InMultiplierB - 10
		EndIf
    EndIf
	
	;Check for less than 0
	If Radiation.InMultiplierB < 0
		Radiation.InMultiplierB = 0
	EndIf
	GasMask_RadiationLevel.show(Radiation.InMultiplierB)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Message Property GasMask_RadiationLevel Auto
	Metro:World:Radiation Property Radiation Auto Const Mandatory
EndGroup
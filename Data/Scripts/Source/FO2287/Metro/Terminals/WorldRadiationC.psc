ScriptName Metro:Terminals:WorldRadiationC extends Terminal
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
		Radiation.InMultiplierC = 29
	ElseIf (auiMenuItemID == 3)
		Radiation.InMultiplierC = Radiation.InMultiplierC + 1
	ElseIf (auiMenuItemID == 4)
		If Radiation.InMultiplierC > 0
			Radiation.InMultiplierC = Radiation.InMultiplierC - 1
		EndIf
	ElseIf (auiMenuItemID == 5)
			Radiation.InMultiplierC = Radiation.InMultiplierC + 5
	ElseIf (auiMenuItemID == 6)
		If Radiation.InMultiplierC > 0
			Radiation.InMultiplierC = Radiation.InMultiplierC - 5
		EndIf
	ElseIf (auiMenuItemID == 7)
			Radiation.InMultiplierC = Radiation.InMultiplierC + 10
	ElseIf (auiMenuItemID == 8)
		If Radiation.InMultiplierC > 0
			Radiation.InMultiplierC = Radiation.InMultiplierC - 10
		EndIf
    EndIf
	
	;Check for less than 0
	If Radiation.InMultiplierC < 0
		Radiation.InMultiplierC = 0
	EndIf
	GasMask_RadiationLevel.show(Radiation.InMultiplierC)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Message Property GasMask_RadiationLevel Auto
	Metro:World:Radiation Property Radiation Auto Const Mandatory
EndGroup
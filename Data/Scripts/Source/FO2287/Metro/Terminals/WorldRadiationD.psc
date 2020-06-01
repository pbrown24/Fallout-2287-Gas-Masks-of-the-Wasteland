ScriptName Metro:Terminals:WorldRadiationD extends Terminal
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
		Radiation.InMultiplierD = 61
	ElseIf (auiMenuItemID == 3)
		Radiation.InMultiplierD = Radiation.InMultiplierD + 1
	ElseIf (auiMenuItemID == 4)
		If Radiation.InMultiplierD > 0
			Radiation.InMultiplierD = Radiation.InMultiplierD - 1
		EndIf
	ElseIf (auiMenuItemID == 5)
			Radiation.InMultiplierD = Radiation.InMultiplierD + 5
	ElseIf (auiMenuItemID == 6)
		If Radiation.InMultiplierD > 0
			Radiation.InMultiplierD = Radiation.InMultiplierD - 5
		EndIf
	ElseIf (auiMenuItemID == 7)
			Radiation.InMultiplierD = Radiation.InMultiplierD + 10
	ElseIf (auiMenuItemID == 8)
		If Radiation.InMultiplierD > 0
			Radiation.InMultiplierD = Radiation.InMultiplierD - 10
		EndIf
    EndIf
	
	;Check for less than 0
	If Radiation.InMultiplierD < 0
		Radiation.InMultiplierD = 0
	EndIf
	GasMask_RadiationLevel.show(Radiation.InMultiplierD)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Message Property GasMask_RadiationLevel Auto
	Metro:World:Radiation Property Radiation Auto Const Mandatory
EndGroup
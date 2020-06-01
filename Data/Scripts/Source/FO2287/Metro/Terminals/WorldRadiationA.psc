ScriptName Metro:Terminals:WorldRadiationA extends Terminal
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
		Radiation.InMultiplierA = 7
	ElseIf (auiMenuItemID == 3)
		Radiation.InMultiplierA = Radiation.InMultiplierA + 1
	ElseIf (auiMenuItemID == 4)
		If Radiation.InMultiplierA > 0
			Radiation.InMultiplierA = Radiation.InMultiplierA - 1
		EndIf
	ElseIf (auiMenuItemID == 5)
			Radiation.InMultiplierA = Radiation.InMultiplierA + 5
	ElseIf (auiMenuItemID == 6)
		If Radiation.InMultiplierA > 0
			Radiation.InMultiplierA = Radiation.InMultiplierA - 5
		EndIf
	ElseIf (auiMenuItemID == 7)
			Radiation.InMultiplierA = Radiation.InMultiplierA + 10
	ElseIf (auiMenuItemID == 8)
		If Radiation.InMultiplierA > 0
			Radiation.InMultiplierA = Radiation.InMultiplierA - 10
		EndIf
    EndIf
	
	;Check for less than 0
	If Radiation.InMultiplierA < 0
		Radiation.InMultiplierA = 0
	EndIf
	GasMask_RadiationLevel.show(Radiation.InMultiplierA)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Message Property GasMask_RadiationLevel Auto
	Metro:World:Radiation Property Radiation Auto Const Mandatory
EndGroup

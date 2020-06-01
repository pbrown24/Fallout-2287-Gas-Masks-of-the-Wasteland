ScriptName Metro:Terminals:SoundMenuSprinting extends Terminal
import Metro
import Shared:Log

UserLog Log


; Events
;---------------------------------------------



Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	ElseIf (auiMenuItemID == 2)
			GasMask_SprintToggle.SetValue(0.0)
			return
	ElseIf( auiMenuItemID == 5 )
			GasMask_SprintToggle.SetValue(1.0)
			return
	ElseIf (auiMenuItemID == 3)
			GasMask_MaxVolume_Sprinting.SetValue(1.0)
			return
	ElseIf (auiMenuItemID == 4)
			GasMask_MaxVolume_Sprinting.SetValue(0.8)
			return
	ElseIf (auiMenuItemID == 6)
			GasMask_MaxVolume_Sprinting.SetValue(0.6)
			return
	ElseIf (auiMenuItemID == 7)
			GasMask_MaxVolume_Sprinting.SetValue(0.4)
			return
	ElseIf (auiMenuItemID == 8)
			GasMask_MaxVolume_Sprinting.SetValue(0.2)
			return
	EndIf
EndEvent


; Properties
;---------------------------------------------

GlobalVariable Property GasMask_SprintToggle Auto Mandatory
GlobalVariable Property GasMask_MaxVolume_Sprinting Auto Mandatory


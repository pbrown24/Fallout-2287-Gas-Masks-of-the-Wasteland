ScriptName Metro:Terminals:NPCDamageToggle extends Terminal
import Metro

; Events
;---------------------------------------------

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	ElseIf(auiMenuItemID == 2)
		GasMask_NPCDamage_Toggle.SetValue(1.0)
	ElseIf(auiMenuItemID == 3)
		GasMask_NPCDamage_Toggle.SetValue(0.0)
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property GasMask_PlayerDamage_Toggle Auto
EndGroup

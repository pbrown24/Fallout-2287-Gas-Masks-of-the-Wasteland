ScriptName Metro:Terminals:GearPlayerDamageToggle extends Terminal
import Metro

CustomEvent OnChanged

; Events
;---------------------------------------------

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	ElseIf(auiMenuItemID == 2)
		GasMask_PlayerDamage_Toggle.SetValueInt(1)
		SendCustomEvent("OnChanged")
	ElseIf(auiMenuItemID == 3)
		GasMask_PlayerDamage_Toggle.SetValueInt(0)
		SendCustomEvent("OnChanged")
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property GasMask_PlayerDamage_Toggle Auto
EndGroup

ScriptName Metro:Terminals:GearAddMask extends Terminal
import Metro
import Shared:Log

UserLog Log


; Events
;---------------------------------------------	


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	ElseIf (auiMenuItemID == 2)
		Game.GetPlayer().EquipItem(GasMask_GearDatabaseMenu)
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Potion Property GasMask_GearDatabaseMenu Auto
EndGroup

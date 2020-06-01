Scriptname Metro:Gear:CraftRepairKit extends Metro:Core:Optional

import Metro
import Shared:Log

UserLog Log

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Craft Repair Kit"
EndEvent


Event OnEnable()
	WriteLine(Log, "CraftRepairKit Initialized.")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
EndEvent


Event OnDisable()
	WriteLine(Log, "CraftRepairKit Disabled.")
	UnRegisterForRemoteEvent(Player, "OnItemEquipped")
EndEvent


; Methods
;---------------------------------------------

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == GasMask_GearRepairKit && GasMask_RepairCharges.GetValue() < 3.0)
			GasMask_RepairCharges.SetValue(GasMask_RepairCharges.GetValue() + 1)
			GasMask_RepairKitHelpMessage.show(GasMask_RepairCharges.GetValue())
			WriteLine(Log, "Made a Repair Kit.")
		ElseIf (akBaseObject == GasMask_GearRepairKit && GasMask_RepairCharges.GetValue() == 3.0)
			Player.AddItem(GasMask_GearRepairKit,1,true)
			GasMask_RepairKitHelpMessage.show(GasMask_RepairCharges.GetValue())
			WriteLine(Log, "Maximum number of Repair Kits.")
		EndIf
EndEvent


; Properties
;---------------------------------------------


Group Properties
	Message Property GasMask_RepairKitHelpMessage Auto
	GlobalVariable Property GasMask_RepairCharges Auto
	GlobalVariable Property GasMask_MaxRepairCharges Auto
	Potion Property GasMask_GearRepairKit Auto
EndGroup

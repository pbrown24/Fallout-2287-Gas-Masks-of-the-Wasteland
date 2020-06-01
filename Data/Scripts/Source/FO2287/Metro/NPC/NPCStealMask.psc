Scriptname Metro:NPC:NPCStealMask extends ReferenceAlias
{MGEF:Metro_CloakEquipEffect}
import Metro
import Shared:Log

UserLog Log
Actor Player
Actor NPC
Form kMask
int DatabaseLength = 0

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPC Steal Mask"
	NPC = self.GetReference() as Actor
	Player = Game.GetPlayer()
	WriteLine(Log, self+" has had his gas mask stolen")
	Form xMask
	int index = DatabaseLength - 1
	DatabaseLength = Database.Count	
	While(index >= 0)
		xMask = Database.GetAt(index)
		If (NPC.GetItemCount(kMask) > 1)
			NPC.EquipItem(kMask, true, true)
			WriteLine(Log, self+" has another gas mask "+kMask)
			GasMask_PickPocket.Stop()
			return
		EndIf
		index -= 1
	EndWhile
	WriteLine(Log, self+" is suffering radiation.")
	GasMask_NPC_MaskDamage.Cast(NPC, NPC)
	GasMask_PickPocket.Stop()
EndEvent

; Properties
;---------------------------------------------

Group Context
	Gear:Database Property Database Auto Const Mandatory
EndGroup

Group Properties
	Spell Property GasMask_NPC_MaskDamage Auto Const Mandatory
	Quest Property GasMask_PickPocket Auto Const Mandatory
EndGroup
